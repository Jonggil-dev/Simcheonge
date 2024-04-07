package com.e102.simcheonge_server.domain.policy_category_detail.entity;

import com.e102.simcheonge_server.domain.category_detail.entity.CategoryDetailId;
import jakarta.persistence.*;
import lombok.AllArgsConstructor;
import lombok.Builder;
import lombok.Getter;
import lombok.NoArgsConstructor;

@Builder
@AllArgsConstructor
@NoArgsConstructor
@Getter
@Entity
@IdClass(PolicyCategoryDetailId.class)
@Table(name = "policy_category_detail")
public class PolicyCategoryDetail {
    @Id
    @Column(name = "category_code", length = 21, nullable = false)
    private String code;

    @Id @Column(name = "category_number", nullable = false)
    private int number;

    @Id  @Column(name = "policy_id", nullable = false)
    private int policyId;
}
