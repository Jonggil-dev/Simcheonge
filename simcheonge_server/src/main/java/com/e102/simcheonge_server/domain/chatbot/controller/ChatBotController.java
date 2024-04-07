package com.e102.simcheonge_server.domain.chatbot.controller;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.http.HttpStatus;
import org.springframework.http.ResponseEntity;
import org.springframework.security.core.annotation.AuthenticationPrincipal;
import org.springframework.security.core.userdetails.UserDetails;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.RequestBody;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RestController;

import com.e102.simcheonge_server.common.util.ResponseUtil;
import com.e102.simcheonge_server.domain.chatbot.dto.request.ChatBotRequest;
import com.e102.simcheonge_server.domain.chatbot.service.ChatBotService;

@RestController
@RequestMapping("/chatbot")
public class ChatBotController {

	@Autowired
	private ChatBotService chatBotService;


	@PostMapping("/requests")
	public ResponseEntity<?> promptModel(@RequestBody ChatBotRequest request, @AuthenticationPrincipal UserDetails userDetails){
		if(userDetails == null){
			return ResponseUtil.buildErrorResponse(
				HttpStatus.UNAUTHORIZED, "AuthenticationException", "해당 인증 정보가 존재하지 않습니다.");
		}
		return ResponseUtil.buildBasicResponse(HttpStatus.OK, chatBotService.promptToModel(request));
	}
}
