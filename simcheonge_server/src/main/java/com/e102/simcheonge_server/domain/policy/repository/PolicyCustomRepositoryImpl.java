package com.e102.simcheonge_server.domain.policy.repository;

import com.e102.simcheonge_server.common.util.QueryDslSupport;
import com.e102.simcheonge_server.domain.category_detail.dto.request.CategoryDetailSearchRequest;
import com.e102.simcheonge_server.domain.policy.entity.Policy;
import com.e102.simcheonge_server.domain.policy.entity.QPolicy;
import com.e102.simcheonge_server.domain.policy_category_detail.entity.QPolicyCategoryDetail;
import com.querydsl.core.BooleanBuilder;
import com.querydsl.core.Tuple;
import com.querydsl.core.types.dsl.Expressions;
import com.querydsl.core.types.dsl.NumberPath;
import com.querydsl.jpa.JPQLQuery;
import com.querydsl.jpa.impl.JPAQueryFactory;
import com.querydsl.jpa.sql.JPASQLQuery;
import com.querydsl.sql.PostgreSQLTemplates;
import jakarta.persistence.TypedQuery;
import org.springframework.beans.factory.annotation.Autowired;

import java.util.List;
import jakarta.persistence.EntityManager;
import lombok.extern.slf4j.Slf4j;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.data.domain.PageImpl;
import org.springframework.data.domain.Pageable;
import org.springframework.stereotype.Repository;

import java.util.ArrayList;
import java.util.List;
import java.util.Objects;

import static com.querydsl.jpa.JPAExpressions.select;
import static org.springframework.jdbc.core.JdbcOperationsExtensionsKt.query;
import static org.springframework.web.servlet.mvc.method.annotation.MvcUriComponentsBuilder.on;

@Repository
@Slf4j
public class PolicyCustomRepositoryImpl extends QueryDslSupport implements PolicyCustomRepository {

    @Autowired
    public PolicyCustomRepositoryImpl(EntityManager entityManager) {
        super(Policy.class, entityManager);
    }

    @Override
    public PageImpl<Policy> searchPolicy(String keyword, List<CategoryDetailSearchRequest> detailList, Pageable pageable) {
        String jpql = buildDynamicJPQL(keyword, detailList);

        log.info("jpql={}", jpql);

        TypedQuery<Policy> query = getEntityManager().createQuery(jpql, Policy.class);

        List<Policy> resultList = query.getResultList();

        return new PageImpl<>(resultList, pageable, resultList.size());
    }

    public String buildDynamicJPQL(String keyword, List<CategoryDetailSearchRequest> detailList) {
        StringBuilder jpqlBuilder = new StringBuilder();

        jpqlBuilder.append("SELECT p FROM Policy p ");
        jpqlBuilder.append("WHERE p.policyId IN (");
        jpqlBuilder.append("    SELECT pcd.policyId ");
        jpqlBuilder.append("    FROM PolicyCategoryDetail pcd ");

        if (!detailList.isEmpty()) {
            // JOIN 부분
            jpqlBuilder.append("    RIGHT JOIN (");

            if (!detailList.isEmpty()) {
                // Define the subquery alias and columns outside of the RIGHT JOIN clause
                jpqlBuilder.append("    RIGHT JOIN (");
                jpqlBuilder.append("        SELECT '").append(detailList.get(0).getCode()).append("' AS code, ").append(detailList.get(0).getNumber()).append(" AS number, p2.policyId ");
                jpqlBuilder.append("        FROM Policy p2 WHERE p2.policyId = pcd.policyId ");  // JPAExpressions 사용
                jpqlBuilder.append("    ) AS detailList ON pcd.code = detailList.code AND ");
                jpqlBuilder.append("                          pcd.number = detailList.number ");
                jpqlBuilder.append("    GROUP BY pcd.policyId ");
                jpqlBuilder.append("    HAVING COUNT(pcd.policyId) = ").append(detailList.size());
            }
        }
        jpqlBuilder.append(")");
        return jpqlBuilder.toString();
    }
}