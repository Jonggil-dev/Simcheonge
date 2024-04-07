package com.e102.simcheonge_server.domain.user.controller;

import com.e102.simcheonge_server.common.util.ResponseUtil;
import com.e102.simcheonge_server.domain.user.dto.request.SignUpRequest;
import com.e102.simcheonge_server.domain.user.dto.request.UpdateNicknameRequest;
import com.e102.simcheonge_server.domain.user.dto.request.UpdatePasswordRequest;
import com.e102.simcheonge_server.domain.user.entity.User;
import com.e102.simcheonge_server.domain.user.service.UserService;
import com.e102.simcheonge_server.domain.user.utill.UserUtil;
import jakarta.servlet.http.HttpSession;
import lombok.AllArgsConstructor;
import lombok.extern.slf4j.Slf4j;
import org.springframework.http.HttpStatus;
import org.springframework.http.ResponseEntity;
import org.springframework.security.core.annotation.AuthenticationPrincipal;
import org.springframework.security.core.userdetails.UserDetails;
import org.springframework.web.bind.annotation.*;

import static com.e102.simcheonge_server.common.util.ResponseUtil.buildBasicResponse;

@RestController
@AllArgsConstructor
@Slf4j
@RequestMapping("/users")
public class UserController {
    private final UserService userService;

    @PostMapping("/signup")
    public ResponseEntity<?> signup(@RequestBody SignUpRequest signUpRequestForm){
        log.info("signUpRequestForm={}",signUpRequestForm);
        userService.saveUser(signUpRequestForm);
        return buildBasicResponse(HttpStatus.OK,"회원 가입에 성공했습니다.");
    }

    @GetMapping("/userInfo")
    public ResponseEntity<?> getInfo(@AuthenticationPrincipal UserDetails userDetails){
        User user = UserUtil.getUserFromUserDetails(userDetails);
        return buildBasicResponse(HttpStatus.OK,user.getUserId());
    }

    @GetMapping("/check-nickname")
    public ResponseEntity<?> checkNickname(@RequestParam("userNickname") String userNickname) {
        userService.isValidateNickname(userNickname);
        return buildBasicResponse(HttpStatus.OK,"해당 닉네임은 사용 가능합니다.");
    }

    @GetMapping("/check-loginId")
    public ResponseEntity<?> checkLoginId(@RequestParam("userLoginId") String userLoginId) {
        userService.isValidateLoginId(userLoginId);
        return buildBasicResponse(HttpStatus.OK,"해당 아이디는 사용 가능합니다.");
    }

    @GetMapping("/update/check-nickname")
    public ResponseEntity<?> updateCheckNickname(@RequestParam("userNickname") String userNickname) {
        userService.isValidateNickname(userNickname);
        return buildBasicResponse(HttpStatus.OK,"해당 닉네임은 사용 가능합니다.");
    }

    @GetMapping("/update/check-loginId")
    public ResponseEntity<?> updateCheckLoginId(@RequestParam("userLoginId") String userLoginId) {
        userService.isValidateLoginId(userLoginId);
        return buildBasicResponse(HttpStatus.OK,"해당 아이디는 사용 가능합니다.");
    }

    @PatchMapping("/update/nickname")
    public ResponseEntity<?> updateNickname(@RequestBody UpdateNicknameRequest userNickname, @AuthenticationPrincipal UserDetails userDetails) {
        User user = UserUtil.getUserFromUserDetails(userDetails);
        userService.updateNickname(userNickname.getUserNickname(),user.getUserId());
        return buildBasicResponse(HttpStatus.OK,"닉네임 변경에 성공했습니다.");
    }

    @PatchMapping("/update/password")
    public ResponseEntity<?> updatePassword(@RequestBody UpdatePasswordRequest userPassword, @AuthenticationPrincipal UserDetails userDetails) {
        User user = UserUtil.getUserFromUserDetails(userDetails);
        userService.updatePassword(userPassword,user.getUserId());
        return buildBasicResponse(HttpStatus.OK,"비밀번호 변경에 성공했습니다.");
    }
}

