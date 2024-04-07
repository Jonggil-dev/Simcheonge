package com.e102.simcheonge_server.domain.youthplcy.service;

import com.e102.simcheonge_server.domain.policy.entity.Policy;
import com.e102.simcheonge_server.domain.policy.repository.PolicyRepository;
import com.e102.simcheonge_server.domain.youthplcy.dto.YouthPlcyElement;
import com.e102.simcheonge_server.domain.youthplcy.dto.YouthPlcyListResponse;
import jakarta.xml.bind.JAXBContext;
import jakarta.xml.bind.JAXBException;
import jakarta.xml.bind.Unmarshaller;
import lombok.extern.slf4j.Slf4j;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.beans.factory.annotation.Value;
import org.springframework.boot.web.client.RestTemplateBuilder;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;
import org.springframework.web.client.RestTemplate;

import java.io.StringReader;
import java.text.SimpleDateFormat;
import java.time.LocalDate;
import java.time.format.DateTimeFormatter;
import java.util.*;
import java.util.regex.Matcher;
import java.util.regex.Pattern;

@Service
@Slf4j
public class YouthPlcyService {
    private final RestTemplate restTemplate;
    private final PolicyRepository policyRepository;

    @Value("${OPENAPIVLAK}")
    private String accessKey;

    @Autowired
    public YouthPlcyService(RestTemplateBuilder restTemplateBuilder, PolicyRepository policyRepository) {
        this.restTemplate = restTemplateBuilder.build();
        this.policyRepository = policyRepository;
    }

    @Transactional
    public void insertUnprocessedPolicyData() {

        for (int i = 1; ; i++) {
            //응답 데이터 받아오기
            YouthPlcyListResponse youthPlcyListResponse = fetchYouthPolicy(i);
            if (youthPlcyListResponse.getPageIndex() == 0) break;

            //DB에 있는지 확인, 없으면 youthPlcyElementList에 담기
            List<YouthPlcyElement> youthPlcyElementList = new ArrayList<>();
            for (YouthPlcyElement youthPolicy : youthPlcyListResponse.getYouthPolicies()) {
                if (!policyRepository.existsByCode(youthPolicy.getBizId())) {
                    youthPlcyElementList.add(youthPolicy);
                }
            }
            log.info("i={}, youthPlcyElementList.size()={}", i, youthPlcyElementList.size());

            //youthPlcyElementList를 Policy엔티티로 변경하고, DB에 넣기
            for (YouthPlcyElement youthPlcy : youthPlcyElementList) {

                Policy policy = Policy.builder()
                        .code(youthPlcy.getBizId())
                        .area(youthPlcy.getPolyBizSecd().substring(2))
                        .name(youthPlcy.getPolyBizSjnm())
                        .intro(youthPlcy.getPolyItcnCn())
                        .supportContent(youthPlcy.getSporCn())
                        .supportScale(youthPlcy.getSporScvl())
                        .etc(youthPlcy.getEtct())
                        .field(youthPlcy.getPolyRlmCd())
                        .businessPeriod(youthPlcy.getBizPrdCn())
                        .periodTypeCode(youthPlcy.getPrdRpttSecd())
                        .startDate(null)
                        .endDate(null)
                        .ageInfo(youthPlcy.getAgeInfo())
                        .majorRequirements(youthPlcy.getMajrRqisCn())
                        .employmentStatus(youthPlcy.getEmpmSttsCn())
                        .specializedField(youthPlcy.getSplzRlmRqisCn())
                        .educationRequirements(youthPlcy.getAccrRqisCn())
                        .residenceIncome(youthPlcy.getPrcpCn())
                        .additionalClues(youthPlcy.getAditRscn())
                        .entryLimit(youthPlcy.getPrcpLmttTrgtCn())
                        .applicationProcedure(youthPlcy.getRqutProcCn())
                        .requiredDocuments(youthPlcy.getPstnPaprCn())
                        .evaluationContent(youthPlcy.getJdgnPresCn())
                        .siteAddress(youthPlcy.getRqutUrla())
                        .mainOrganization(youthPlcy.getMngtMson())
                        .mainContact(youthPlcy.getCherCtpcCn())
                        .operationOrganization(youthPlcy.getCnsgNmor())
                        .operationOrganizationContact(youthPlcy.getTintCherCtpcCn())
                        .applicationPeriod(youthPlcy.getRqutPrdCn())
                        .isProcessed(false)
                        .processedAt(null)
                        .createdAt(new Date())
                        .build();
                Policy saved = policyRepository.save(policy);
                log.info("saved={}",saved);
            }
        }
    }

    public YouthPlcyListResponse fetchYouthPolicy(int pageIndex) {

        String apiUrl = "https://www.youthcenter.go.kr/opi/youthPlcyList.do?display=100&pageIndex=" + Integer.toString(pageIndex) + "&openApiVlak=" + accessKey;
        String xmlResponse = restTemplate.getForObject(apiUrl, String.class);

        try {
            JAXBContext jaxbContext = JAXBContext.newInstance(YouthPlcyListResponse.class);
            Unmarshaller unmarshaller = jaxbContext.createUnmarshaller();
            StringReader reader = new StringReader(xmlResponse);
            return (YouthPlcyListResponse) unmarshaller.unmarshal(reader);

        } catch (JAXBException e) {
            e.printStackTrace();
            return null;
        }
    }

}
