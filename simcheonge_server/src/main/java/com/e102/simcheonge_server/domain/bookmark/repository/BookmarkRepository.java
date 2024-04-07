package com.e102.simcheonge_server.domain.bookmark.repository;

import com.e102.simcheonge_server.domain.bookmark.entity.Bookmark;
import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.stereotype.Repository;

import java.util.List;
import java.util.Optional;

@Repository
public interface BookmarkRepository extends JpaRepository<Bookmark, Integer> {
    Optional<Bookmark> findByUserIdAndReferencedIdAndBookmarkType(int userId, int referencedId, String bookmarkType);

    List<Bookmark> findByUserIdAndBookmarkType(int userId, String bookmarkType);
}
