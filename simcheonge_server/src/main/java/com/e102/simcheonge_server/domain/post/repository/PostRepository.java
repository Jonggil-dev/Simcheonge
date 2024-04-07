package com.e102.simcheonge_server.domain.post.repository;

import com.e102.simcheonge_server.domain.post.entity.Post;
import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.data.jpa.repository.Query;
import org.springframework.data.repository.query.Param;
import org.springframework.stereotype.Repository;

import java.util.List;
import java.util.Optional;

@Repository
public interface PostRepository extends JpaRepository<Post, Integer> {
    Optional<Post> findByPostId(int postId);

    Optional<Post> findByPostIdAndIsDeleted(int postId, boolean isDeleted);

    // 게시글 조회
        // 모든 게시글을 키워드에 따라 조회
    @Query("SELECT p FROM Post p WHERE (:keyword IS NULL OR p.postName LIKE %:keyword% OR p.postContent LIKE %:keyword%)")
    List<Post> findAllByKeyword(@Param("keyword") String keyword);

        // 카테고리에 해당하는 게시글을 키워드에 따라 조회
    @Query("SELECT p FROM Post p JOIN PostCategory pc ON p.postId = pc.postId " +
            "WHERE pc.categoryCode = :categoryCode AND pc.categoryNumber = :categoryNumber " +
            "AND (:keyword IS NULL OR p.postName LIKE %:keyword% OR p.postContent LIKE %:keyword%)")
    List<Post> findByCategoryDetailsAndKeyword(@Param("categoryCode") String categoryCode, @Param("categoryNumber") Integer categoryNumber, @Param("keyword") String keyword);


    // 내가 쓴 게시글 조회
    @Query("SELECT p FROM Post p WHERE p.userId = :userId")
    List<Post> findAllPostsByUserId(@Param("userId") int userId);

    @Query("SELECT p FROM Post p JOIN PostCategory pc ON p.postId = pc.postId " +
            "WHERE p.userId = :userId AND pc.categoryCode = :categoryCode AND pc.categoryNumber = :categoryNumber")
    List<Post> findPostsByUserIdAndCategory(@Param("userId") int userId, @Param("categoryCode") String categoryCode, @Param("categoryNumber") Integer categoryNumber);
}
