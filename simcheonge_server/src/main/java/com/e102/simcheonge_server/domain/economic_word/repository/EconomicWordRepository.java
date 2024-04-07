package com.e102.simcheonge_server.domain.economic_word.repository;

import com.e102.simcheonge_server.domain.economic_word.entity.EconomicWord;
import org.springframework.data.jpa.repository.JpaRepository;

public interface EconomicWordRepository extends JpaRepository<EconomicWord, Long> {
    EconomicWord findByWord(String word);
}