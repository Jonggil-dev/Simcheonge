package com.e102.simcheonge_server.domain.comment.repository;

import com.e102.simcheonge_server.domain.comment.entity.Comment;
import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.stereotype.Repository;

import java.util.List;
import java.util.Optional;

@Repository
public interface CommentRepository extends JpaRepository<Comment, Integer> {

    Optional<Comment> findByCommentIdAndIsDeletedFalse(int commentId);

    List<Comment> findByCommentTypeAndReferencedIdAndIsDeletedFalse(String commentType, int referencedId);

    List<Comment> findByUserAndCommentTypeAndIsDeletedFalseOrderByCreatedAtDesc(int userId, String commentType);

    List<Comment> findByUserAndCommentTypeAndCommentContentContainingAndIsDeletedFalseOrderByCreatedAtDesc(int userId, String commentType, String keyword);

}
