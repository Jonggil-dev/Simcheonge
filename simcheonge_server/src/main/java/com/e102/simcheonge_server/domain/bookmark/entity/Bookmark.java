package com.e102.simcheonge_server.domain.bookmark.entity;

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
@Table(name = "bookmark")
public class Bookmark {
    @Id
    @GeneratedValue(strategy = GenerationType.IDENTITY)
    @Column(name = "bookmark_id")
    private int bookmarkId;

    @Column(name = "user_id")
    @NotNull
    private int userId;

    @Column(name = "referenced_id")
    @NotNull
    private int referencedId;

    @Column(name = "bookmark_type", length = 3)
    @Builder.Default
    private String bookmarkType = "POS";
}
