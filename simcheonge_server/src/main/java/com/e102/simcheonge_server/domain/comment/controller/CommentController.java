package com.e102.simcheonge_server.domain.comment.controller;

import com.e102.simcheonge_server.common.util.ResponseUtil;
import com.e102.simcheonge_server.domain.comment.dto.request.CommentCreateRequest;
import com.e102.simcheonge_server.domain.comment.service.CommentService;
import com.e102.simcheonge_server.domain.user.entity.User;
import com.e102.simcheonge_server.domain.user.repository.UserRepository;
import com.e102.simcheonge_server.domain.user.utill.UserUtil;
import lombok.AllArgsConstructor;
import lombok.extern.slf4j.Slf4j;
import org.springframework.http.HttpStatus;
import org.springframework.http.ResponseEntity;
import org.springframework.security.core.annotation.AuthenticationPrincipal;
import org.springframework.security.core.userdetails.UserDetails;
import org.springframework.security.core.userdetails.UsernameNotFoundException;
import org.springframework.web.bind.annotation.*;

@RestController
@Slf4j
@RequestMapping("/comment")
@AllArgsConstructor
public class CommentController {
    private final CommentService commentService;
    private final UserRepository userRepository;

    @PostMapping
    public ResponseEntity<?> addComment(@RequestBody CommentCreateRequest commentRequest, @AuthenticationPrincipal UserDetails userDetails){
        User user = UserUtil.getUserFromUserDetails(userDetails);
        commentService.addComment(commentRequest, user.getUserId());
        return ResponseUtil.buildBasicResponse(HttpStatus.OK, "댓글 등록에 성공했습니다.");
    }

    @GetMapping("/{commentType}/{referencedId}")
    public ResponseEntity<?> getBoardComments(@PathVariable("commentType") String commentType, @PathVariable("referencedId") int referencedId, @AuthenticationPrincipal UserDetails userDetails) {
        User user = UserUtil.getUserFromUserDetails(userDetails);
        return ResponseUtil.buildBasicResponse(HttpStatus.OK, commentService.getBoardComments(commentType, referencedId, user.getUserId()));
    }

    @GetMapping("/{commentType}")
    public ResponseEntity<?> getMyComments(@PathVariable("commentType") String commentType, @AuthenticationPrincipal UserDetails userDetails) {
        User user = UserUtil.getUserFromUserDetails(userDetails);
        return ResponseUtil.buildBasicResponse(HttpStatus.OK, commentService.getMyComments(commentType, user.getUserId()));
    }

    @GetMapping("/{commentType}/search")
    public ResponseEntity<?> searchMyComments(@PathVariable("commentType") String commentType, @RequestParam(name="keyword", required = true) String keyword, @AuthenticationPrincipal UserDetails userDetails) {
        User user = UserUtil.getUserFromUserDetails(userDetails);
        return ResponseUtil.buildBasicResponse(HttpStatus.OK, commentService.searchMyComments(commentType, keyword, user.getUserId()));
    }

    @DeleteMapping("/{commentId}")
    public ResponseEntity<?> deleteComment(@PathVariable("commentId") int commentId, @AuthenticationPrincipal UserDetails userDetails) {
        User user = UserUtil.getUserFromUserDetails(userDetails);
        commentService.deleteComment(commentId, user.getUserId());
        return ResponseUtil.buildBasicResponse(HttpStatus.OK, "댓글 삭제에 성공했습니다.");
    }

}
