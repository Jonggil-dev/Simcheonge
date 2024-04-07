package com.e102.simcheonge_server.domain.bookmark.service;

import com.e102.simcheonge_server.domain.bookmark.dto.request.BookmarkCreateRequest;
import com.e102.simcheonge_server.domain.bookmark.dto.response.BookmarkResponse;
import com.e102.simcheonge_server.domain.bookmark.entity.Bookmark;
import com.e102.simcheonge_server.domain.bookmark.repository.BookmarkRepository;
import com.e102.simcheonge_server.domain.policy.entity.Policy;
import com.e102.simcheonge_server.domain.policy.repository.PolicyRepository;
import com.e102.simcheonge_server.domain.post.entity.Post;
import com.e102.simcheonge_server.domain.post.repository.PostRepository;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import java.util.ArrayList;
import java.util.LinkedHashMap;
import java.util.List;
import java.util.Optional;

@Service
public class BookmarkService {
    private final BookmarkRepository bookmarkRepository;
    private final PolicyRepository policyRepository;
    private final PostRepository postRepository;

    @Autowired
    public BookmarkService(BookmarkRepository bookmarkRepository, PolicyRepository policyRepository, PostRepository postRepository) {
        this.bookmarkRepository = bookmarkRepository;
        this.policyRepository = policyRepository;
        this.postRepository = postRepository;
    }

    // 북마크 등록
    public BookmarkResponse createBookmark(BookmarkCreateRequest request, int userId) {
        // 요청 유효성 검증 로직
        if (("POL".equals(request.getBookmarkType()) && request.getPolicyId() == null) ||
                ("POS".equals(request.getBookmarkType()) && request.getPostId() == null)) {
            throw new IllegalArgumentException("요청한 북마크 타입과 ID 타입이 일치하는지 확인해주세요.");
        }

        // 실제 데이터 존재 여부 확인
        if ("POL".equals(request.getBookmarkType())) {
            if (request.getPolicyId() == null || !policyRepository.existsById(request.getPolicyId())) {
                throw new IllegalArgumentException("Invalid policy ID or policy does not exist.");
            }
        } else if ("POS".equals(request.getBookmarkType())) {
            if (request.getPostId() == null || !postRepository.existsById(request.getPostId())) {
                throw new IllegalArgumentException("Invalid post ID or post does not exist.");
            }
        } else {
            throw new IllegalArgumentException("Invalid bookmark type.");
        }

        // 요청받은 policyId 또는 postId를 referencedId에 할당
        int referencedId = 0;
        if ("POL".equals(request.getBookmarkType()) && request.getPolicyId() != null) {
            referencedId = request.getPolicyId();
        } else if ("POS".equals(request.getBookmarkType()) && request.getPostId() != null) {
            referencedId = request.getPostId();
        }

        // 같은 userId, referencedId, bookmarkType을 가진 북마크가 이미 존재하는지 확인(중복 검사)
        Optional<Bookmark> existingBookmark = bookmarkRepository.findByUserIdAndReferencedIdAndBookmarkType(userId, referencedId, request.getBookmarkType());
        if (existingBookmark.isPresent()) {
            throw new IllegalArgumentException("이미 등록된 북마크입니다.");
        }

        // Bookmark 엔티티 생성 및 저장
        Bookmark bookmark = Bookmark.builder()
                .userId(userId)
                .referencedId(referencedId)
                .bookmarkType(request.getBookmarkType())
                .build();
        Bookmark savedBookmark = bookmarkRepository.save(bookmark);

        // 응답 반환
        return new BookmarkResponse(
                savedBookmark.getBookmarkId(),
                savedBookmark.getUserId(),
                savedBookmark.getReferencedId(),
                savedBookmark.getBookmarkType(),
                userId==savedBookmark.getUserId());
    }


    // 북마크 조회
    public LinkedHashMap<String, Object> getBookmarksByType(int userId, String bookmarkType) {
        List<LinkedHashMap<String, Object>> data = new ArrayList<>();

        // POL 타입 북마크 조회
        if ("POL".equals(bookmarkType)) {
            List<Bookmark> bookmarks = bookmarkRepository.findByUserIdAndBookmarkType(userId, "POL");
            bookmarks.forEach(bookmark -> {
                Policy policy = policyRepository.findByPolicyId(bookmark.getReferencedId())
                        .orElseThrow(() -> new RuntimeException("Policy not found"));
                LinkedHashMap<String, Object> item = new LinkedHashMap<>();
                item.put("bookmarkId", bookmark.getBookmarkId());
                item.put("bookmarkType", bookmark.getBookmarkType());
                item.put("policyId", policy.getPolicyId());
                item.put("policyName", policy.getName());
                item.put("userId", bookmark.getUserId());
                data.add(item);
            });
        }
        // POS 타입 북마크 조회
        else if ("POS".equals(bookmarkType)) {
            List<Bookmark> bookmarks = bookmarkRepository.findByUserIdAndBookmarkType(userId, "POS");
            bookmarks.forEach(bookmark -> {
                Post post = postRepository.findByPostId(bookmark.getReferencedId())
                        .orElseThrow(() -> new RuntimeException("Post not found"));
                LinkedHashMap<String, Object> item = new LinkedHashMap<>();
                item.put("bookmarkId", bookmark.getBookmarkId());
                item.put("bookmarkType", bookmark.getBookmarkType());
                item.put("postId", post.getPostId());
                item.put("postName", post.getPostName());
                item.put("userId", bookmark.getUserId());
                data.add(item);
            });
        }

        LinkedHashMap<String, Object> response = new LinkedHashMap<>();
        response.put("status", 200);
        response.put("data", data);
        return response;
    }


    // 북마크 삭제
    public void deleteBookmark(int bookmarkId, int userId) {
        Bookmark bookmark = bookmarkRepository.findById(bookmarkId)
                .orElseThrow(() -> new RuntimeException("북마크를 찾을 수 없습니다."));

        if (bookmark.getUserId() != userId) {
            throw new IllegalArgumentException("북마크를 삭제할 권한이 없습니다.");
        }

        bookmarkRepository.delete(bookmark);
    }
}
