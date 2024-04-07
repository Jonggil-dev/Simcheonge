package com.e102.simcheonge_server.domain.economic_word.entity;

import jakarta.persistence.*;
import lombok.*;

@Builder
@AllArgsConstructor
@NoArgsConstructor
@Getter
@Setter
@Entity
@Table(name = "economic_word")
public class EconomicWord {
    @Id
    @GeneratedValue(strategy = GenerationType.IDENTITY)
    @Column(name = "economic_word_id", nullable = false)
    private int economicWordId;

    @Column(name = "economic_word", length = 255, nullable = false)
    private String word;

    @Column(name = "economic_word_description", columnDefinition = "TEXT", nullable = false)
    private String description;
}
