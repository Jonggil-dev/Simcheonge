package com.e102.simcheonge_server.domain.comment.service;

import com.e102.simcheonge_server.common.exception.DataNotFoundException;
import com.e102.simcheonge_server.common.exception.AuthenticationException;
import com.e102.simcheonge_server.domain.comment.dto.request.CommentCreateRequest;
import com.e102.simcheonge_server.domain.comment.dto.response.CommentResponse;
import com.e102.simcheonge_server.domain.comment.dto.response.MyCommentResponse;
import com.e102.simcheonge_server.domain.comment.entity.Comment;
import com.e102.simcheonge_server.domain.comment.repository.CommentRepository;
import com.e102.simcheonge_server.domain.policy.entity.Policy;
import com.e102.simcheonge_server.domain.policy.repository.PolicyRepository;
import com.e102.simcheonge_server.domain.post.entity.Post;
import com.e102.simcheonge_server.domain.post.repository.PostRepository;
import com.e102.simcheonge_server.domain.user.entity.User;
import com.e102.simcheonge_server.domain.user.repository.UserRepository;
import lombok.AllArgsConstructor;
import lombok.extern.slf4j.Slf4j;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

import java.text.SimpleDateFormat;
import java.util.ArrayList;
import java.util.List;
import java.util.Optional;

@Service
@Slf4j
@AllArgsConstructor
public class CommentService {

    private final CommentRepository commentRepository;
    private final UserRepository userRepostory;
    private final PostRepository postRepository;
    private final PolicyRepository policyRepository;

    public void addComment(CommentCreateRequest commentRequest, final int userId) {
        if (commentRequest.getContent().isEmpty()) {
            throw new DataNotFoundException("해당 내용이 존재하지 않습니다.");
        }

        User user = userRepostory.findById(userId)
                .orElseThrow(() -> new DataNotFoundException("해당 사용자가 존재하지 않습니다."));

        if (commentRequest.getCommentType().equals("POS")) {
            Post post = postRepository.findByPostIdAndIsDeleted(commentRequest.getReferencedId(),false)
                    .orElseThrow(() -> new DataNotFoundException("해당 게시물이 존재하지 않습니다."));
        } else if (commentRequest.getCommentType().equals("POL")) {
            Policy policy = policyRepository.findByPolicyIdAndIsProcessed(commentRequest.getReferencedId(),true)
                    .orElseThrow(() -> new DataNotFoundException("해당 정책이 존재하지 않습니다."));
        }else{
            throw new IllegalArgumentException("게시물과 정책 외에 다른 타입에 대한 댓글은 존재하지 않습니다.");
        }

        Comment comment = Comment.builder()
                .user(userId)
                .referencedId(commentRequest.getReferencedId())
                .commentType(commentRequest.getCommentType())
                .commentContent(commentRequest.getContent())
                .build();
        commentRepository.save(comment);
    }

    public List<CommentResponse> getBoardComments(final String commentType, final int referencedId, final int userId) {
        User user = userRepostory.findById(userId)
                .orElseThrow(() -> new DataNotFoundException("해당 사용자가 존재하지 않습니다."));
        if (commentType.equals("POS")) {
            Post post = postRepository.findByPostIdAndIsDeleted(referencedId,false)
                    .orElseThrow(() -> new DataNotFoundException("해당 게시물이 존재하지 않습니다."));
        } else if (commentType.equals("POL")) {
            Policy policy = policyRepository.findByPolicyIdAndIsProcessed(referencedId,true)
                    .orElseThrow(() -> new DataNotFoundException("해당 정책이 존재하지 않습니다."));
        }else{
            throw new IllegalArgumentException("게시물과 정책 외에 다른 타입에 대한 댓글은 존재하지 않습니다.");
        }

        List<Comment> commentList = commentRepository.findByCommentTypeAndReferencedIdAndIsDeletedFalse(commentType, referencedId);
        List<CommentResponse> responses = new ArrayList<>();
        SimpleDateFormat formatter = new SimpleDateFormat("yyyy-MM-dd");
        commentList.forEach(comment -> {
            if (!comment.isDeleted()) {
                User commenter = userRepostory.findByUserId(comment.getUser())
                        .orElseThrow(() -> new DataNotFoundException("해당 댓글 작성자가 존재하지 않습니다."));
                String nickname = commenter.getUserNickname();

                CommentResponse commentResponse = CommentResponse.builder()
                        .commentId(comment.getCommentId())
                        .nickname(nickname)
                        .content(comment.getCommentContent())
                        .createAt(formatter.format(comment.getCreatedAt()).toString())
                        .isMyComment(commenter.getUserId() == userId) //삭제된 회원이거나 요청 회원이 아닌 경우
                        .build();
                responses.add(commentResponse);
            }
        });
        return responses;
    }

    public List<MyCommentResponse> getMyComments(String commentType, int userId) {
        User user = userRepostory.findById(userId)
                .orElseThrow(() -> new DataNotFoundException("해당 사용자가 존재하지 않습니다."));
        List<Comment> commentList = commentRepository.findByUserAndCommentTypeAndIsDeletedFalseOrderByCreatedAtDesc(userId,commentType);
        List<MyCommentResponse> responses = new ArrayList<>();
        SimpleDateFormat formatter = new SimpleDateFormat("MM-dd");
        for (Comment comment : commentList) {
            if (!comment.isDeleted()) {
                if (commentType.equals("POS")) {
                    Optional<Post> post = postRepository.findByPostId(comment.getReferencedId());
                    if(post.isEmpty()||post.get().isDeleted()) continue;
                } else if (commentType.equals("POL")) {
                    Optional<Policy> policy = policyRepository.findByPolicyId(comment.getReferencedId());
                    if(policy.isEmpty()||!policy.get().isProcessed()) continue;
                }
                else{
                    throw new DataNotFoundException("해당 타입은 존재하지 않습니다.");
                }
                MyCommentResponse myCommentResponse=MyCommentResponse.builder()
                        .commentId(comment.getCommentId())
                        .commentType(commentType)
                        .referencedId(comment.getReferencedId())
                        .content(comment.getCommentContent())
                        .createAt(formatter.format(comment.getCreatedAt()).toString())
                        .build();
                responses.add(myCommentResponse);
            }
        }
        return responses;
    }

    public List<MyCommentResponse> searchMyComments(String commentType, String keyword, int userId) {
        User user = userRepostory.findById(userId)
                .orElseThrow(() -> new DataNotFoundException("해당 사용자가 존재하지 않습니다."));
        List<Comment> commentList = commentRepository.findByUserAndCommentTypeAndCommentContentContainingAndIsDeletedFalseOrderByCreatedAtDesc(userId,commentType,keyword);
        List<MyCommentResponse> responses = new ArrayList<>();
        SimpleDateFormat formatter = new SimpleDateFormat("MM-dd");
        commentList.forEach(comment -> {
            if (!comment.isDeleted()) {
                if (commentType.equals("POS")) {
                    Post post = postRepository.findByPostId(comment.getReferencedId())
                            .orElseThrow(() -> new DataNotFoundException("해당 게시물이 존재하지 않습니다."));
                } else if (commentType.equals("POL")) {
                    Policy policy = policyRepository.findByPolicyId(comment.getReferencedId())
                            .orElseThrow(() -> new DataNotFoundException("해당 정책이 존재하지 않습니다."));
                }
                MyCommentResponse myCommentResponse=MyCommentResponse.builder()
                        .commentId(comment.getCommentId())
                        .commentType(commentType)
                        .referencedId(comment.getReferencedId())
                        .content(comment.getCommentContent())
                        .createAt(formatter.format(comment.getCreatedAt()).toString())
                        .build();
                responses.add(myCommentResponse);
            }
        });
        return responses;
    }

    @Transactional
    public void deleteComment(int commentId, int userId) {
        User user = userRepostory.findById(userId)
                .orElseThrow(() -> new DataNotFoundException("해당 사용자가 존재하지 않습니다."));
        Comment comment = commentRepository.findByCommentIdAndIsDeletedFalse(commentId)
                .orElseThrow(() -> new DataNotFoundException("해당 댓글이 존재하지 않습니다."));
        if(comment.getUser()!=userId){
            throw new AuthenticationException("해당 댓글 삭제 권한이 존재하지 않습니다.");
        }
        comment.setDeleted(true);
    }
}
