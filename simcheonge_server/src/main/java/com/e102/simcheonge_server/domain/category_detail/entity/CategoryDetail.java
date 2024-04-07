package com.e102.simcheonge_server.domain.category_detail.entity;

import jakarta.persistence.*;
import jakarta.validation.constraints.NotNull;
import lombok.AllArgsConstructor;
import lombok.Builder;
import lombok.Getter;
import lombok.NoArgsConstructor;

@Builder
@AllArgsConstructor
@NoArgsConstructor
@Getter
@Entity
@IdClass(CategoryDetailId.class)
@Table(name = "category_detail")
public class CategoryDetail {
    @Id @Column(name = "category_code", length = 21, nullable = false)
    private String code;

    @Id @Column(name = "category_number", nullable = false)
    private int number;

    @Column(name = "category_name", length = 100)
    private String name;

    public String getCategoryCode() {
        return code;
    }

    public int getCategoryNumber() {
        return number;
    }

    public String getCategoryName() {
        return name;
    }
}
