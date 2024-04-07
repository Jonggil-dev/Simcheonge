package com.e102.simcheonge_server.domain.category_detail.entity;

import lombok.AllArgsConstructor;
import lombok.Builder;
import lombok.Getter;
import lombok.NoArgsConstructor;

import java.io.Serializable;

@AllArgsConstructor
@NoArgsConstructor
@Getter @Builder
public class CategoryDetailId implements Serializable {
    private String code;
    private int number;
}
