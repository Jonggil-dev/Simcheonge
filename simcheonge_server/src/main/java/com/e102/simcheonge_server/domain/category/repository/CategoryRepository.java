package com.e102.simcheonge_server.domain.category.repository;

import com.e102.simcheonge_server.domain.category.entity.Category;
import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.stereotype.Repository;

import java.util.List;
import java.util.Optional;

@Repository
public interface CategoryRepository extends JpaRepository<Category,String> {
//    Optional<Category> findByCode(String code);
//
    List<Category> findAllByCodeNot(String code);
}
