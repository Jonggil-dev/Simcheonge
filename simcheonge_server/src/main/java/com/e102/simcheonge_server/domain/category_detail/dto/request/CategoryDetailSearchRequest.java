package com.e102.simcheonge_server.domain.category_detail.dto.request;

import lombok.Builder;
import lombok.Data;

@Data @Builder
public class CategoryDetailSearchRequest {
    private String code;
    private int number;
}
