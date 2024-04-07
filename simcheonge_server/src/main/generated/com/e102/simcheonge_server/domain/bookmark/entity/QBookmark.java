package com.e102.simcheonge_server.domain.bookmark.entity;

import static com.querydsl.core.types.PathMetadataFactory.*;

import com.querydsl.core.types.dsl.*;

import com.querydsl.core.types.PathMetadata;
import javax.annotation.processing.Generated;
import com.querydsl.core.types.Path;


/**
 * QBookmark is a Querydsl query type for Bookmark
 */
@Generated("com.querydsl.codegen.DefaultEntitySerializer")
public class QBookmark extends EntityPathBase<Bookmark> {

    private static final long serialVersionUID = 1484604814L;

    public static final QBookmark bookmark = new QBookmark("bookmark");

    public final NumberPath<Integer> bookmarkId = createNumber("bookmarkId", Integer.class);

    public final StringPath bookmarkType = createString("bookmarkType");

    public final NumberPath<Integer> referencedId = createNumber("referencedId", Integer.class);

    public final NumberPath<Integer> userId = createNumber("userId", Integer.class);

    public QBookmark(String variable) {
        super(Bookmark.class, forVariable(variable));
    }

    public QBookmark(Path<? extends Bookmark> path) {
        super(path.getType(), path.getMetadata());
    }

    public QBookmark(PathMetadata metadata) {
        super(Bookmark.class, metadata);
    }

}

