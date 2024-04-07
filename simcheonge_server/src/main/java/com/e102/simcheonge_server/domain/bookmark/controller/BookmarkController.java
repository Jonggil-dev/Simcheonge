package com.e102.simcheonge_server.domain.bookmark.controller;

import com.e102.simcheonge_server.domain.bookmark.dto.request.BookmarkCreateRequest;
import com.e102.simcheonge_server.domain.bookmark.dto.response.BookmarkResponse;
import com.e102.simcheonge_server.domain.bookmark.service.BookmarkService;
import com.e102.simcheonge_server.domain.user.entity.User;
import com.e102.simcheonge_server.domain.user.utill.UserUtil;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.http.HttpStatus;
import org.springframework.http.ResponseEntity;
import org.springframework.security.core.annotation.AuthenticationPrincipal;
import org.springframework.security.core.userdetails.UserDetails;
import org.springframework.web.bind.annotation.*;

import java.util.LinkedHashMap;
import java.util.Map;

@RestController
@RequestMapping("/bookmarks")
public class BookmarkController {
    private final BookmarkService bookmarkService;

    @Autowired
    public BookmarkController(BookmarkService bookmarkService) {
        this.bookmarkService = bookmarkService;
    }

    // 북마크 등록
    @PostMapping
    public ResponseEntity<?> createBookmark(@RequestBody BookmarkCreateRequest request, @AuthenticationPrincipal UserDetails userDetails) {
        if (userDetails == null) {
            return ResponseEntity.status(HttpStatus.UNAUTHORIZED).body("로그인이 필요합니다.");
        }

        User user = UserUtil.getUserFromUserDetails(userDetails);
        BookmarkResponse response = bookmarkService.createBookmark(request, user.getUserId());

        Map<String, Object> responseBody = new LinkedHashMap<>();
        responseBody.put("status", HttpStatus.OK.value());
        responseBody.put("data", "북마크가 등록되었습니다.");
        responseBody.put("bookmark_id", response.getBookmarkId());

        return new ResponseEntity<>(responseBody, HttpStatus.OK);
    }


    // 북마크 조회
    @GetMapping
    public ResponseEntity<?> getBookmarks(@RequestParam("bookmarkType") String bookmarkType, @AuthenticationPrincipal UserDetails userDetails) {
        if (userDetails == null) {
            return ResponseEntity.status(HttpStatus.UNAUTHORIZED).body("로그인이 필요합니다.");
        }

        User user = UserUtil.getUserFromUserDetails(userDetails);
        LinkedHashMap<String, Object> bookmarks = bookmarkService.getBookmarksByType(user.getUserId(), bookmarkType);

        return ResponseEntity.ok(bookmarks);
    }


    // 북마크 삭제
    @DeleteMapping("/{bookmarkId}")
    public ResponseEntity<?> deleteBookmark(@PathVariable("bookmarkId") int bookmarkId, @AuthenticationPrincipal UserDetails userDetails) {
        if (userDetails == null) {
            return ResponseEntity.status(HttpStatus.UNAUTHORIZED).body(Map.of("message", "로그인이 필요합니다."));
        }

        User user = UserUtil.getUserFromUserDetails(userDetails);
        bookmarkService.deleteBookmark(bookmarkId, user.getUserId());

        LinkedHashMap<String, Object> response = new LinkedHashMap<>();
        response.put("status", HttpStatus.OK.value());
        response.put("data", "북마크가 삭제되었습니다.");

        return ResponseEntity.ok(response);
    }
}
