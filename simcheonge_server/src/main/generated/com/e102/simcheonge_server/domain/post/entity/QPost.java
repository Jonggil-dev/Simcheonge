package com.e102.simcheonge_server.domain.post.entity;

import static com.querydsl.core.types.PathMetadataFactory.*;

import com.querydsl.core.types.dsl.*;

import com.querydsl.core.types.PathMetadata;
import javax.annotation.processing.Generated;
import com.querydsl.core.types.Path;


/**
 * QPost is a Querydsl query type for Post
 */
@Generated("com.querydsl.codegen.DefaultEntitySerializer")
public class QPost extends EntityPathBase<Post> {

    private static final long serialVersionUID = 398652386L;

    public static final QPost post = new QPost("post");

    public final com.e102.simcheonge_server.common.QBaseEntity _super = new com.e102.simcheonge_server.common.QBaseEntity(this);

    //inherited
    public final DateTimePath<java.util.Date> createdAt = _super.createdAt;

    //inherited
    public final DateTimePath<java.util.Date> deletedAt = _super.deletedAt;

    //inherited
    public final BooleanPath isDeleted = _super.isDeleted;

    public final StringPath postContent = createString("postContent");

    public final NumberPath<Integer> postId = createNumber("postId", Integer.class);

    public final StringPath postName = createString("postName");

    public final NumberPath<Integer> userId = createNumber("userId", Integer.class);

    public QPost(String variable) {
        super(Post.class, forVariable(variable));
    }

    public QPost(Path<? extends Post> path) {
        super(path.getType(), path.getMetadata());
    }

    public QPost(PathMetadata metadata) {
        super(Post.class, metadata);
    }

}

