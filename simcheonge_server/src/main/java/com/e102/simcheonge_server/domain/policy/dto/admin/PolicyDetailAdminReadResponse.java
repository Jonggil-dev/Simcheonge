package com.e102.simcheonge_server.domain.policy.dto.admin;

import lombok.Builder;
import lombok.Data;

import java.util.Date;

@Data
@Builder
public class PolicyDetailAdminReadResponse {
    private String code;
    private String area;
    private String name;
    private String intro;
    private String supportContent;
    private String supportScale;
    private String etc;
    private String field;
    private String businessPeriod;
    private String periodTypeCode;
    private Date startDate;
    private Date endDate;
    private String ageInfo;
    private String majorRequirements;
    private String employmentStatus;
    private String specializedField;
    private String educationRequirements;
    private String residenceIncome;
    private String additionalClues;
    private String entryLimit;
    private String applicationProcedure;
    private String requiredDocuments;
    private String evaluationContent;
    private String siteAddress;
    private String mainOrganization;
    private String mainContact;
    private String operationOrganization;
    private String operationOrganizationContact;
    private String applicationPeriod;
    private boolean isProcessed;
}
