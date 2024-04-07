package com.e102.simcheonge_server.domain.policy_category_detail.entity;

import lombok.AllArgsConstructor;
import lombok.Builder;
import lombok.Getter;
import lombok.NoArgsConstructor;

import java.io.Serializable;

@AllArgsConstructor
@NoArgsConstructor
@Getter
@Builder
public class PolicyCategoryDetailId implements Serializable {
    private String code;
    private int number;
    private int policyId;
}
