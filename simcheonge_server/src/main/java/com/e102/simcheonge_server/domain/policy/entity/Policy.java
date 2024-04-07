package com.e102.simcheonge_server.domain.policy.entity;

import com.e102.simcheonge_server.domain.policy.dto.request.PolicyUpdateRequest;
import jakarta.persistence.*;
import jakarta.validation.constraints.NotNull;
import lombok.AllArgsConstructor;
import lombok.Builder;
import lombok.Getter;
import lombok.NoArgsConstructor;

import java.util.Date;

@Builder
@AllArgsConstructor
@NoArgsConstructor
@Getter
@Entity
@Table(name = "policy")
public class Policy {
    @Id
    @GeneratedValue(strategy = GenerationType.IDENTITY)
    @Column(name = "policy_id")
    private int policyId;

    @Column(name = "policy_code", length = 16, nullable = false)
    private String code;

    @Column(name = "policy_area", length = 21, nullable = false)
    private String area;

    @Column(name = "policy_name", nullable = false, columnDefinition = "TEXT")
    private String name;

    @Column(name = "policy_intro", columnDefinition = "TEXT")
    private String intro;

    @Column(name = "policy_support_content", columnDefinition = "TEXT")
    private String supportContent;

    @Column(name = "policy_support_scale", columnDefinition = "TEXT")
    private String supportScale;

    @Column(name = "policy_etc", columnDefinition = "TEXT")
    private String etc;

    @Column(name = "policy_field", nullable = false)
    @NotNull
    private String field;

    @Column(name = "policy_business_period", columnDefinition = "TEXT")
    private String businessPeriod;

    @Column(name = "policy_period_type_code", length = 21, nullable = false)
    private String periodTypeCode;

    @Column(name = "policy_start_date", columnDefinition = "DATE")
    private Date startDate;

    @Column(name = "policy_end_date", columnDefinition = "DATE")
    private Date endDate;

    @Column(name = "policy_age_info", length = 40)
    private String ageInfo;

    @Column(name = "policy_major_requirements", columnDefinition = "TEXT")
    private String majorRequirements;

    @Column(name = "policy_employment_status", length = 31, nullable = false)
    private String employmentStatus;

    @Column(name = "policy_specialized_field", length = 31, nullable = false)
    private String specializedField;

    @Column(name = "policy_education_requirements", length = 31, nullable = false)
    private String educationRequirements;

    @Column(name = "policy_residence_income", columnDefinition = "TEXT")
    private String residenceIncome;

    @Column(name = "policy_additional_clues", columnDefinition = "TEXT")
    private String additionalClues;

    @Column(name = "policy_entry_limit", columnDefinition = "TEXT")
    private String entryLimit;

    @Column(name = "policy_application_procedure", columnDefinition = "TEXT")
    private String applicationProcedure;

    @Column(name = "policy_required_documents", columnDefinition = "TEXT")
    private String requiredDocuments;

    @Column(name = "policy_evaluation_content", columnDefinition = "TEXT")
    private String evaluationContent;

    @Column(name = "policy_site_address", length = 1000)
    private String siteAddress;

    @Column(name = "policy_main_organization", columnDefinition = "TEXT")
    private String mainOrganization;

    @Column(name = "policy_main_contact", columnDefinition = "TEXT")
    private String mainContact;

    @Column(name = "policy_operation_organization", columnDefinition = "TEXT")
    private String operationOrganization;

    @Column(name = "policy_operation_organization_contact", columnDefinition = "TEXT")
    private String operationOrganizationContact;

    @Column(name = "policy_application_period", columnDefinition = "TEXT")
    private String applicationPeriod;

    @Column(name = "policy_is_processed", nullable = false)
    @Builder.Default
    private boolean isProcessed = false;

    @Column(name = "policy_processed_at", columnDefinition = "DATETIME")
    private Date processedAt;

    @Column(name = "policy_created_at", columnDefinition = "DATETIME")
    private Date createdAt;

    /** 관리자의 정책 수정 메서드 **/
    public void updatePolicy(PolicyUpdateRequest policyUpdateRequest) {
        this.code=policyUpdateRequest.getCode();
        this.area=policyUpdateRequest.getArea();
        this.name=policyUpdateRequest.getName();
        this.intro=policyUpdateRequest.getIntro();
        this.supportContent=policyUpdateRequest.getSupportContent();
        this.supportScale=policyUpdateRequest.getSupportScale();
        this.etc=policyUpdateRequest.getEtc();
        this.field=policyUpdateRequest.getField();
        this.businessPeriod=policyUpdateRequest.getBusinessPeriod();
        this.periodTypeCode=policyUpdateRequest.getPeriodTypeCode();
        this.startDate=policyUpdateRequest.getStartDate();
        this.endDate=policyUpdateRequest.getEndDate();
        this.ageInfo=policyUpdateRequest.getAgeInfo();
        this.majorRequirements=policyUpdateRequest.getMajorRequirements();
        this.employmentStatus=policyUpdateRequest.getEmploymentStatus();
        this.specializedField=policyUpdateRequest.getSpecializedField();
        this.educationRequirements=policyUpdateRequest.getEducationRequirements();
        this.residenceIncome=policyUpdateRequest.getResidenceIncome();
        this.additionalClues=policyUpdateRequest.getAdditionalClues();
        this.entryLimit=policyUpdateRequest.getEntryLimit();
        this.applicationProcedure=policyUpdateRequest.getApplicationProcedure();
        this.requiredDocuments=policyUpdateRequest.getRequiredDocuments();
        this.evaluationContent=policyUpdateRequest.getEvaluationContent();
        this.siteAddress=policyUpdateRequest.getSiteAddress();
        this.mainOrganization=policyUpdateRequest.getMainOrganization();
        this.mainContact=policyUpdateRequest.getMainContact();
        this.operationOrganization=policyUpdateRequest.getOperationOrganization();
        this.operationOrganizationContact=policyUpdateRequest.getOperationOrganizationContact();
        this.applicationPeriod=policyUpdateRequest.getApplicationPeriod();

        this.isProcessed = policyUpdateRequest.isProcessed();
        this.processedAt = new Date();
    }
}
