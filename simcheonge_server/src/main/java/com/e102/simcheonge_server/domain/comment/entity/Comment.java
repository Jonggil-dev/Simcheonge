package com.e102.simcheonge_server.domain.comment.entity;

import com.e102.simcheonge_server.common.BaseEntity;
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
@Table(name = "comment")
public class Comment extends BaseEntity {
    @Id
    @GeneratedValue(strategy = GenerationType.IDENTITY)
    @Column(name = "comment_id", nullable = false)
    private int commentId;

    @Column(name = "user_id", nullable = false)
    @NotNull
    private int user;

    @Column(name = "referenced_id", nullable = false)
    private int referencedId;

    @Column(name = "comment_type", length = 3, nullable = false)
    @Builder.Default()
    private String commentType = "POS";

    @Column(name = "comment_content", length = 1200, nullable = false)
    private String commentContent;

}
