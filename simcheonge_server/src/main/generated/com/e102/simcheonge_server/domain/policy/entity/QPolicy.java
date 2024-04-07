package com.e102.simcheonge_server.domain.policy.entity;

import static com.querydsl.core.types.PathMetadataFactory.*;

import com.querydsl.core.types.dsl.*;

import com.querydsl.core.types.PathMetadata;
import javax.annotation.processing.Generated;
import com.querydsl.core.types.Path;


/**
 * QPolicy is a Querydsl query type for Policy
 */
@Generated("com.querydsl.codegen.DefaultEntitySerializer")
public class QPolicy extends EntityPathBase<Policy> {

    private static final long serialVersionUID = -1462423610L;

    public static final QPolicy policy = new QPolicy("policy");

    public final StringPath additionalClues = createString("additionalClues");

    public final StringPath ageInfo = createString("ageInfo");

    public final StringPath applicationPeriod = createString("applicationPeriod");

    public final StringPath applicationProcedure = createString("applicationProcedure");

    public final StringPath area = createString("area");

    public final StringPath businessPeriod = createString("businessPeriod");

    public final StringPath code = createString("code");

    public final DateTimePath<java.util.Date> createdAt = createDateTime("createdAt", java.util.Date.class);

    public final StringPath educationRequirements = createString("educationRequirements");

    public final StringPath employmentStatus = createString("employmentStatus");

    public final DateTimePath<java.util.Date> endDate = createDateTime("endDate", java.util.Date.class);

    public final StringPath entryLimit = createString("entryLimit");

    public final StringPath etc = createString("etc");

    public final StringPath evaluationContent = createString("evaluationContent");

    public final StringPath field = createString("field");

    public final StringPath intro = createString("intro");

    public final BooleanPath isProcessed = createBoolean("isProcessed");

    public final StringPath mainContact = createString("mainContact");

    public final StringPath mainOrganization = createString("mainOrganization");

    public final StringPath majorRequirements = createString("majorRequirements");

    public final StringPath name = createString("name");

    public final StringPath operationOrganization = createString("operationOrganization");

    public final StringPath operationOrganizationContact = createString("operationOrganizationContact");

    public final StringPath periodTypeCode = createString("periodTypeCode");

    public final NumberPath<Integer> policyId = createNumber("policyId", Integer.class);

    public final DateTimePath<java.util.Date> processedAt = createDateTime("processedAt", java.util.Date.class);

    public final StringPath requiredDocuments = createString("requiredDocuments");

    public final StringPath residenceIncome = createString("residenceIncome");

    public final StringPath siteAddress = createString("siteAddress");

    public final StringPath specializedField = createString("specializedField");

    public final DateTimePath<java.util.Date> startDate = createDateTime("startDate", java.util.Date.class);

    public final StringPath supportContent = createString("supportContent");

    public final StringPath supportScale = createString("supportScale");

    public QPolicy(String variable) {
        super(Policy.class, forVariable(variable));
    }

    public QPolicy(Path<? extends Policy> path) {
        super(path.getType(), path.getMetadata());
    }

    public QPolicy(PathMetadata metadata) {
        super(Policy.class, metadata);
    }

}

