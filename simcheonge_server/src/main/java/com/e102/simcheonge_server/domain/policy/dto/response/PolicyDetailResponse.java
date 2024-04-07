package com.e102.simcheonge_server.domain.policy.dto.response;

import lombok.Builder;
import lombok.Data;

@Data @Builder
public class PolicyDetailResponse {
    private String policy_name;
    private String policy_intro;
    private String policy_support_scale;
    private String policy_period_type_code; //상시, 미정, 특정 기간
    private String policy_start_date;
    private String policy_end_date;
    private String policy_main_organization;
    private String policy_operation_organization;
    private String policy_area;
    private String policy_age_info;
    private String policy_education_requirements;
    private String policy_major_requirements;
    private String policy_employment_status;

    private String policy_site_address;
    private String policy_support_content;
    private String policy_entry_limit;
    private String policy_application_procedure;
    private String policy_etc;

    private boolean isBookmarked;
}
