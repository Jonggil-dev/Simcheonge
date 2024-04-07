package com.e102.simcheonge_server.domain.policy.repository;

import com.e102.simcheonge_server.domain.policy.entity.Policy;
import org.springframework.data.domain.PageImpl;
import org.springframework.data.domain.Pageable;
import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.data.jpa.repository.Query;
import org.springframework.stereotype.Repository;

import java.util.List;
import java.util.Optional;

@Repository
public interface PolicyRepository extends JpaRepository<Policy,Integer>, PolicyCustomRepository {
    Optional<Policy> findByPolicyId(int policyId);

    Optional<Policy> findByPolicyIdAndIsProcessed(int policyId, boolean isProcessed);

    @Query("SELECT p FROM Policy p WHERE p.policyId IN :policyIds")
    PageImpl<Policy> findByPolicyIds(List<Integer> policyIds, Pageable pageable);
    PageImpl<Policy> findAll(Pageable pageable);

    boolean existsByCode(String code);

    List<Policy> findAllByIsProcessed(boolean isProcessed);
}
