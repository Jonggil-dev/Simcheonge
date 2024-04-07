package com.e102.simcheonge_server.domain.post_category.entity;

import java.io.Serializable;
import lombok.AllArgsConstructor;
import lombok.Builder;
import lombok.Getter;
import lombok.NoArgsConstructor;

@AllArgsConstructor
@NoArgsConstructor
@Getter
@Builder
public class PostCategoryId implements Serializable {
    private String categoryCode;
    private int categoryNumber;
    private int postId;
}
