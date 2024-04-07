package com.e102.simcheonge_server.domain.post_category.repository;

import com.e102.simcheonge_server.domain.post_category.entity.PostCategory;
import com.e102.simcheonge_server.domain.post_category.entity.PostCategoryId;
import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.data.jpa.repository.Query;
import org.springframework.stereotype.Repository;
import java.util.List;
import java.util.Optional;

@Repository
public interface PostCategoryRepository extends JpaRepository<PostCategory, PostCategoryId> {
    Optional<PostCategory> findByPostId(int postId);

    // 특정 카테고리 코드에 해당하는 모든 게시글의 ID 조회
    @Query("SELECT pc.postId FROM PostCategory pc WHERE pc.categoryCode = :categoryCode")
    List<Integer> findPostIdsByCategoryCode(String categoryCode);
}
