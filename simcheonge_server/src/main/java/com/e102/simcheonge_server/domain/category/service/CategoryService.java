package com.e102.simcheonge_server.domain.category.service;

import com.e102.simcheonge_server.domain.category_detail.entity.CategoryDetail;
import com.e102.simcheonge_server.domain.category_detail.repository.CategoryDetailRepository;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;
import java.util.List;

@Service
public class CategoryService {
    private final CategoryDetailRepository categoryDetailRepository;

    @Autowired
    public CategoryService(CategoryDetailRepository categoryDetailRepository) {
        this.categoryDetailRepository = categoryDetailRepository;
    }

    public List<CategoryDetail> getAllCategoryDetails() {
        return categoryDetailRepository.findAllOrderedByNumber();
    }
}