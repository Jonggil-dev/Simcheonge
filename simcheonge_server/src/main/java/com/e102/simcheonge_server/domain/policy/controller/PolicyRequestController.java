//package com.e102.simcheonge_server.domain.policy.controller;
//
//import lombok.Value;
//import lombok.extern.slf4j.Slf4j;
//import org.springframework.http.ResponseEntity;
//import org.springframework.web.bind.annotation.GetMapping;
//import org.springframework.web.bind.annotation.RequestMapping;
//import org.springframework.web.bind.annotation.RequestParam;
//import org.springframework.web.bind.annotation.RestController;
//
//import java.io.BufferedReader;
//import java.io.IOException;
//import java.io.InputStream;
//import java.io.InputStreamReader;
//import java.net.HttpURLConnection;
//import java.net.MalformedURLException;
//import java.net.URL;
//
//@RestController
//@RequestMapping("/api")
//@Slf4j
//public class PolicyRequestController {
//    @Value("${openApi.serviceKey}")
//    private String serviceKey;
//
//    @Value("${openApi.callBackUrl}")
//    private String callBackUrl;
//
//    @Value("${openApi.dataType}")
//    private String dataType;
//
//
//    @GetMapping("/forecast")
//    public ResponseEntity<String> callForecastApi(
//            @RequestParam(value="base_time") String baseTime,
//            @RequestParam(value="base_date") String baseDate,
//            @RequestParam(value="beach_num") String beachNum
//    ){
//        HttpURLConnection urlConnection=null;
//        InputStream stream=null;
//        String result=null;
//
//        String urlStr = callBackUrl +
//                "serviceKey=" + serviceKey +
//                "&dataType=" + dataType +
//                "&base_date=" + baseDate +
//                "&base_time=" + baseTime +
//                "&beach_num=" + beachNum;
//
//        try {
//            URL url=new URL(urlStr);
//
//
//            urlConnection = (HttpURLConnection) url.openConnection();
//            stream = getNetworkConnection(urlConnection);
//            result = readStreamToString(stream);
//
//            if (stream != null) stream.close();
//        } catch (MalformedURLException e) {
//            throw new RuntimeException(e);
//        }finally {
//            if (urlConnection != null) {
//                urlConnection.disconnect();
//            }
//        }
//
//
//    }
//
//    private InputStream getNetworkConnection(HttpURLConnection urlConnection) {
//        urlConnection.setConnectTimeout(3000);
//        urlConnection.setReadTimeout(3000);
//        urlConnection.setRequestMethod("GET");
//        urlConnection.setDoInput(true);
//
//        if(urlConnection.getResponseCode() != HttpURLConnection.HTTP_OK) {
//            throw new IOException("HTTP error code : " + urlConnection.getResponseCode());
//        }
//
//        return urlConnection.getInputStream();
//    }
//
//    /* InputStream을 전달받아 문자열로 변환 후 반환 */
//    private String readStreamToString(InputStream stream) throws IOException{
//        StringBuilder result = new StringBuilder();
//
//        BufferedReader br = new BufferedReader(new InputStreamReader(stream, "UTF-8"));
//
//        String readLine;
//        while((readLine = br.readLine()) != null) {
//            result.append(readLine + "\n\r");
//        }
//
//        br.close();
//
//        return result.toString();
//    }
//}
