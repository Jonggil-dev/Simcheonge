package com.e102.simcheonge_server.domain.category.dto.response;

import lombok.Builder;
import lombok.Data;

@Data
@Builder
public class CategoryResponse {
    public String code;
    public String name;
}
