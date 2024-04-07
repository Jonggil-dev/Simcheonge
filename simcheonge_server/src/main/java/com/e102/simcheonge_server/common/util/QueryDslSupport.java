package com.e102.simcheonge_server.common.util;

import com.querydsl.jpa.impl.JPAQueryFactory;
import jakarta.persistence.EntityManager;
import org.springframework.data.jpa.repository.support.QuerydslRepositorySupport;

public class QueryDslSupport extends QuerydslRepositorySupport {

    protected JPAQueryFactory queryFactory;

    public QueryDslSupport(Class<?> clazz, EntityManager entityManager) {
        super(clazz);
        super.setEntityManager(entityManager);

        this.queryFactory = new JPAQueryFactory(entityManager);
    }

}