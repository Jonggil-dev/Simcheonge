package com.e102.simcheonge_server.domain.policy_category_detail.entity;

import static com.querydsl.core.types.PathMetadataFactory.*;

import com.querydsl.core.types.dsl.*;

import com.querydsl.core.types.PathMetadata;
import javax.annotation.processing.Generated;
import com.querydsl.core.types.Path;


/**
 * QPolicyCategoryDetail is a Querydsl query type for PolicyCategoryDetail
 */
@Generated("com.querydsl.codegen.DefaultEntitySerializer")
public class QPolicyCategoryDetail extends EntityPathBase<PolicyCategoryDetail> {

    private static final long serialVersionUID = -43810744L;

    public static final QPolicyCategoryDetail policyCategoryDetail = new QPolicyCategoryDetail("policyCategoryDetail");

    public final StringPath code = createString("code");

    public final NumberPath<Integer> number = createNumber("number", Integer.class);

    public final NumberPath<Integer> policyId = createNumber("policyId", Integer.class);

    public QPolicyCategoryDetail(String variable) {
        super(PolicyCategoryDetail.class, forVariable(variable));
    }

    public QPolicyCategoryDetail(Path<? extends PolicyCategoryDetail> path) {
        super(path.getType(), path.getMetadata());
    }

    public QPolicyCategoryDetail(PathMetadata metadata) {
        super(PolicyCategoryDetail.class, metadata);
    }

}

