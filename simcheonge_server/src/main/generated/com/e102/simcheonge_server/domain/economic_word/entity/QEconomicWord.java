package com.e102.simcheonge_server.domain.economic_word.entity;

import static com.querydsl.core.types.PathMetadataFactory.*;

import com.querydsl.core.types.dsl.*;

import com.querydsl.core.types.PathMetadata;
import javax.annotation.processing.Generated;
import com.querydsl.core.types.Path;


/**
 * QEconomicWord is a Querydsl query type for EconomicWord
 */
@Generated("com.querydsl.codegen.DefaultEntitySerializer")
public class QEconomicWord extends EntityPathBase<EconomicWord> {

    private static final long serialVersionUID = -1275783317L;

    public static final QEconomicWord economicWord = new QEconomicWord("economicWord");

    public final StringPath description = createString("description");

    public final NumberPath<Integer> economicWordId = createNumber("economicWordId", Integer.class);

    public final StringPath word = createString("word");

    public QEconomicWord(String variable) {
        super(EconomicWord.class, forVariable(variable));
    }

    public QEconomicWord(Path<? extends EconomicWord> path) {
        super(path.getType(), path.getMetadata());
    }

    public QEconomicWord(PathMetadata metadata) {
        super(EconomicWord.class, metadata);
    }

}

