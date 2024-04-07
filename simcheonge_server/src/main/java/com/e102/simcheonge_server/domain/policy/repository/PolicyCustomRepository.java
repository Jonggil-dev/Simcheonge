package com.e102.simcheonge_server.domain.policy.repository;

import com.e102.simcheonge_server.domain.category_detail.dto.request.CategoryDetailSearchRequest;
import com.e102.simcheonge_server.domain.category_detail.entity.CategoryDetail;
import com.e102.simcheonge_server.domain.policy.entity.Policy;
import org.springframework.data.domain.PageImpl;
import org.springframework.data.domain.Pageable;

import java.util.ArrayList;
import java.util.List;

public interface PolicyCustomRepository {
    public PageImpl<Policy> searchPolicy(String keyword, List<CategoryDetailSearchRequest> detailList, Pageable pageable);
}
