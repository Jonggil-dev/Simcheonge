package com.e102.simcheonge_server.domain.category_detail.entity;

import static com.querydsl.core.types.PathMetadataFactory.*;

import com.querydsl.core.types.dsl.*;

import com.querydsl.core.types.PathMetadata;
import javax.annotation.processing.Generated;
import com.querydsl.core.types.Path;


/**
 * QCategoryDetail is a Querydsl query type for CategoryDetail
 */
@Generated("com.querydsl.codegen.DefaultEntitySerializer")
public class QCategoryDetail extends EntityPathBase<CategoryDetail> {

    private static final long serialVersionUID = -1583911143L;

    public static final QCategoryDetail categoryDetail = new QCategoryDetail("categoryDetail");

    public final StringPath code = createString("code");

    public final StringPath name = createString("name");

    public final NumberPath<Integer> number = createNumber("number", Integer.class);

    public QCategoryDetail(String variable) {
        super(CategoryDetail.class, forVariable(variable));
    }

    public QCategoryDetail(Path<? extends CategoryDetail> path) {
        super(path.getType(), path.getMetadata());
    }

    public QCategoryDetail(PathMetadata metadata) {
        super(CategoryDetail.class, metadata);
    }

}

