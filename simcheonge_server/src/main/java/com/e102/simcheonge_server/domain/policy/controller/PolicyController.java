package com.e102.simcheonge_server.domain.policy.controller;

import com.e102.simcheonge_server.common.util.ResponseUtil;
import com.e102.simcheonge_server.domain.policy.dto.request.PolicyReadRequest;
import com.e102.simcheonge_server.domain.policy.dto.request.PolicySearchRequest;
import com.e102.simcheonge_server.domain.policy.dto.request.PolicyUpdateRequest;
import com.e102.simcheonge_server.domain.policy.service.PolicyService;
import com.e102.simcheonge_server.domain.user.entity.User;
import com.e102.simcheonge_server.domain.user.utill.UserUtil;
import lombok.AllArgsConstructor;
import lombok.extern.slf4j.Slf4j;
import org.springframework.data.domain.Pageable;
import org.springframework.data.domain.Sort;
import org.springframework.data.web.PageableDefault;
import org.springframework.http.HttpStatus;
import org.springframework.http.ResponseEntity;
import org.springframework.security.core.annotation.AuthenticationPrincipal;
import org.springframework.security.core.userdetails.UserDetails;
import org.springframework.web.bind.annotation.*;

@RestController
@AllArgsConstructor
@Slf4j
@RequestMapping("/policy")
public class PolicyController {
    private final PolicyService policyService;
    private final int DEFAULT_SIZE = 15;

    @GetMapping("/{policyId}")
    public ResponseEntity<?> getPolicy(@PathVariable("policyId") int policyId, @AuthenticationPrincipal UserDetails userDetails) {
        log.info("userDetails={}",userDetails);
        return ResponseUtil.buildBasicResponse(HttpStatus.OK, policyService.getPolicy(policyId,userDetails));
    }

    @PostMapping("/search")
    public ResponseEntity<?> searchPolicies(@RequestBody PolicySearchRequest policySearchRequest,
                                            @PageableDefault(size = DEFAULT_SIZE, page = 0, sort = "createdAt", direction = Sort.Direction.DESC) final Pageable pageable) {

        log.info("Controller keyword={}",policySearchRequest.getKeyword());
        return ResponseUtil.buildBasicResponse(HttpStatus.OK, policyService.searchPolicies(policySearchRequest,pageable));
    }

    @GetMapping("/categories")
    public ResponseEntity<?> getCategories(){
        return ResponseUtil.buildBasicResponse(HttpStatus.OK,policyService.getCategories());
    }

    /* 관리자 페이지 */
    @GetMapping("/admin")
    public ResponseEntity<?> getAllPolicies(@RequestParam("isProcessed") boolean  isProcessed,
                                            @AuthenticationPrincipal UserDetails userDetails){

        return ResponseUtil.buildBasicResponse(HttpStatus.OK,policyService.getAllPolicies(isProcessed,userDetails.getUsername()));
    }

    @GetMapping("/admin/{policyId}")
    public ResponseEntity<?> getPolicyforAdmin(@PathVariable("policyId") int policyId,
                                            @AuthenticationPrincipal UserDetails userDetails){

        return ResponseUtil.buildBasicResponse(HttpStatus.OK,policyService.getPolicyforAdmin(policyId,userDetails.getUsername()));
    }

    @PatchMapping("/{policyId}")
    public ResponseEntity<?> updatePolicy(@PathVariable("policyId") int policyId,
                                          @RequestBody PolicyUpdateRequest policyUpdateRequest,
                                          @AuthenticationPrincipal UserDetails userDetails){
        User user = UserUtil.getUserFromUserDetails(userDetails);
        policyService.updatePolicy(policyId,policyUpdateRequest,user.getUserId());
        return ResponseUtil.buildBasicResponse(HttpStatus.OK, "정책 수정에 성공했습니다.");
    }

}
