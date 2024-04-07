package com.e102.simcheonge_server.domain.chatbot.service;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.beans.factory.annotation.Value;
import org.springframework.http.HttpHeaders;
import org.springframework.stereotype.Service;
import org.springframework.web.client.RestTemplate;

import com.e102.simcheonge_server.domain.chatbot.dto.request.ChatBotRequest;
import com.e102.simcheonge_server.domain.chatbot.dto.response.ChatBotResponse;

@Service
public class ChatBotService {

	@Value("${chatbot.server.uri}")
	private String GPU_server;

	private RestTemplate restTemplate;

	@Autowired
	public ChatBotService(RestTemplate restTemplate){
		this.restTemplate = restTemplate;
	}

	public ChatBotResponse promptToModel(ChatBotRequest request) {
		ChatBotResponse responseBody = restTemplate.postForObject(
			GPU_server,
			request,
			ChatBotResponse.class
		);

		return responseBody;
	}
}
