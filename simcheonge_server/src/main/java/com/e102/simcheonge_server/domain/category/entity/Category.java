package com.e102.simcheonge_server.domain.category.entity;

import jakarta.persistence.Column;
import jakarta.persistence.Entity;
import jakarta.persistence.Id;
import jakarta.persistence.Table;
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
@Table(name = "category")
public class Category {

    @Id
    @Column(name = "category_code", length = 21)
    @NotNull
    private String code;

    @Column(name = "category_name", length = 21)
    private String name;
}
