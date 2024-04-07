package com.e102.simcheonge_server.domain.economic_word.service;

import com.e102.simcheonge_server.domain.economic_word.entity.EconomicWord;
import com.e102.simcheonge_server.domain.economic_word.repository.EconomicWordRepository;
import org.apache.commons.compress.archivers.zip.ZipArchiveEntry;
import org.apache.commons.compress.archivers.zip.ZipFile;
import org.apache.commons.csv.CSVFormat;
import org.apache.commons.csv.CSVParser;
import org.apache.commons.csv.CSVRecord;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.beans.factory.annotation.Value;
import org.springframework.stereotype.Service;
import jakarta.transaction.Transactional;
import org.springframework.data.domain.PageRequest;
import org.springframework.data.domain.Pageable;
import java.util.Random;


import java.io.*;
import java.net.URL;
import java.nio.charset.Charset;
import java.nio.file.Files;
import java.nio.file.Path;
import java.nio.file.Paths;
import java.nio.file.StandardCopyOption;
import java.util.stream.Collectors;

@Service
public class EconomicWordService {

    @Value("${file.download.outputPath}")
    private String outputPath;

    @Autowired
    private EconomicWordRepository economicWordRepository; // 가정: 데이터베이스에 저장을 담당하는 리포지토리

    public EconomicWord getRandomEconomicWord() {
        long count = economicWordRepository.count(); // DB에 저장된 총 데이터 수
        int index = new Random().nextInt((int) count); // 무작위 인덱스 생성
        Pageable pageable = PageRequest.of(index, 1); // 무작위 페이지 요청
        return economicWordRepository.findAll(pageable).getContent().get(0);
    }

    @Transactional
    public void updateData(String downloadUrl) throws IOException {
        URL url = new URL(downloadUrl);
        Path targetPath = Paths.get(outputPath);
        Files.createDirectories(targetPath.getParent());

        // 파일 다운로드
        try (InputStream in = url.openStream()) {
            Files.copy(in, targetPath, StandardCopyOption.REPLACE_EXISTING);
        }

        economicWordRepository.deleteAllInBatch();

        // ZIP 파일 압축 해제 및 데이터 처리
        try (ZipFile zipFile = new ZipFile(targetPath.toFile(),"CP949")) {
            ZipArchiveEntry entry = zipFile.getEntries().nextElement(); // 첫 번째 엔트리 (CSV 파일 가정)
            try (InputStream zipInputStream = zipFile.getInputStream(entry);
                 BufferedReader bufferedReader = new BufferedReader(new InputStreamReader(zipInputStream, "CP949"))) {

                // 첫 번째 행 읽기
                String firstLine = bufferedReader.readLine();
                if (firstLine != null && firstLine.contains("{")) {
                    firstLine = firstLine.substring(0, firstLine.indexOf('{')).trim();
                }

                // 나머지 행 읽기
                StringBuilder remainingLines = new StringBuilder();
                String line;
                while ((line = bufferedReader.readLine()) != null) {
                    remainingLines.append(line).append("\n");
                }

                // CSVParser에 전달하기 위한 전체 텍스트 생성
                String csvText = firstLine + "\n" + remainingLines.toString();

                // CSVParser 생성 및 사용
                try (CSVParser csvParser = CSVParser.parse(csvText, CSVFormat.DEFAULT
                        .withDelimiter('|')  // 파이프(|)를 구분자로 설정
                        .withFirstRecordAsHeader())) {  // 첫 번째 레코드를 헤더로 인식
                    for (CSVRecord record : csvParser) {
                        // CSV 레코드에서 데이터 추출
                        String word = record.get("용어");
                        String definition = record.get("설명");

                        // EconomicWord 엔티티 생성 및 데이터 설정
                        EconomicWord economicWord = new EconomicWord();
                        economicWord.setWord(word);
                        economicWord.setDescription(definition);

                        // 데이터베이스에 저장
                        economicWordRepository.save(economicWord);
                    }
                }
            }

        }

        // 처리 후 다운로드된 ZIP 파일 삭제
        Files.deleteIfExists(targetPath);
    }
}