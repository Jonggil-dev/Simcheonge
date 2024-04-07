package com.e102.simcheonge_server.domain.comment.entity;

import static com.querydsl.core.types.PathMetadataFactory.*;

import com.querydsl.core.types.dsl.*;

import com.querydsl.core.types.PathMetadata;
import javax.annotation.processing.Generated;
import com.querydsl.core.types.Path;


/**
 * QComment is a Querydsl query type for Comment
 */
@Generated("com.querydsl.codegen.DefaultEntitySerializer")
public class QComment extends EntityPathBase<Comment> {

    private static final long serialVersionUID = -1228023000L;

    public static final QComment comment = new QComment("comment");

    public final com.e102.simcheonge_server.common.QBaseEntity _super = new com.e102.simcheonge_server.common.QBaseEntity(this);

    public final StringPath commentContent = createString("commentContent");

    public final NumberPath<Integer> commentId = createNumber("commentId", Integer.class);

    public final StringPath commentType = createString("commentType");

    //inherited
    public final DateTimePath<java.util.Date> createdAt = _super.createdAt;

    //inherited
    public final DateTimePath<java.util.Date> deletedAt = _super.deletedAt;

    //inherited
    public final BooleanPath isDeleted = _super.isDeleted;

    public final NumberPath<Integer> referencedId = createNumber("referencedId", Integer.class);

    public final NumberPath<Integer> user = createNumber("user", Integer.class);

    public QComment(String variable) {
        super(Comment.class, forVariable(variable));
    }

    public QComment(Path<? extends Comment> path) {
        super(path.getType(), path.getMetadata());
    }

    public QComment(PathMetadata metadata) {
        super(Comment.class, metadata);
    }

}

