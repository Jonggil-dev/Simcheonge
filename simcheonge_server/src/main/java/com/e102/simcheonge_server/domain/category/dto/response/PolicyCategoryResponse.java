package com.e102.simcheonge_server.domain.category.dto.response;

import lombok.AllArgsConstructor;
import lombok.Builder;
import lombok.Data;
import lombok.NoArgsConstructor;

import java.util.List;

@Data @Builder
@NoArgsConstructor
@AllArgsConstructor
public class PolicyCategoryResponse {
    public String tag;
    public List<CategoryResponse> categoryList;
}
