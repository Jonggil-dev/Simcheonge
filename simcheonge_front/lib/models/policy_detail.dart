class PolicyDetail {
  final String policyName;
  final String policyIntro;
  final String policySupportScale;
  final String policyPeriodTypeCode;
  final String policyStartDate;
  final String policyEndDate;
  final String policyMainOrganization;
  final String policyOperationOrganization;
  final String policyArea;
  final String policyAgeInfo;
  final String policyEducationRequirements;
  final String policyMajorRequirements;
  final String policyEmploymentStatus;
  final String policySiteAddress;
  final String policySupportContent;
  final String policyEntryLimit;
  final String policyApplicationProcedure;
  final String policyEtc;
  bool isBookmarked;

  PolicyDetail({
    required this.policyName,
    required this.policyIntro,
    required this.policySupportScale,
    required this.policyPeriodTypeCode,
    required this.policyStartDate,
    required this.policyEndDate,
    required this.policyMainOrganization,
    required this.policyOperationOrganization,
    required this.policyArea,
    required this.policyAgeInfo,
    required this.policyEducationRequirements,
    required this.policyMajorRequirements,
    required this.policyEmploymentStatus,
    required this.policySiteAddress,
    required this.policySupportContent,
    required this.policyEntryLimit,
    required this.policyApplicationProcedure,
    required this.policyEtc,
    this.isBookmarked = false,
  });

  factory PolicyDetail.fromJson(Map<String, dynamic> json) {
    return PolicyDetail(
      policyName: json['policy_name'] ?? '',
      policyIntro: json['policy_intro'] ?? '',
      policySupportScale: json['policy_support_scale'] ?? '',
      policyPeriodTypeCode: json['policy_period_type_code'] ?? '',
      policyStartDate: json['policy_start_date'] ?? '',
      policyEndDate: json['policy_end_date'] ?? '',
      policyMainOrganization: json['policy_main_organization'] ?? '',
      policyOperationOrganization: json['policy_operation_organization'] ?? '',
      policyArea: json['policy_area'] ?? '',
      policyAgeInfo: json['policy_age_info'] ?? '',
      policyEducationRequirements: json['policy_education_requirements'] ?? '',
      policyMajorRequirements: json['policy_major_requirements'] ?? '',
      policyEmploymentStatus: json['policy_employment_status'] ?? '',
      policySiteAddress: json['policy_site_address'] ?? '',
      policySupportContent: json['policy_support_content'] ?? '',
      policyEntryLimit: json['policy_entry_limit'] ?? '',
      policyApplicationProcedure: json['policy_application_procedure'] ?? '',
      policyEtc: json['policy_etc'] ?? '',
      isBookmarked: json['isBookmarked'] ?? false,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'policy_name': policyName,
      'policy_intro': policyIntro,
      'policy_support_scale': policySupportScale,
      'policy_period_type_code': policyPeriodTypeCode,
      'policy_start_date': policyStartDate,
      'policy_end_date': policyEndDate,
      'policy_main_organization': policyMainOrganization,
      'policy_operation_organization': policyOperationOrganization,
      'policy_area': policyArea,
      'policy_age_info': policyAgeInfo,
      'policy_education_requirements': policyEducationRequirements,
      'policy_major_requirements': policyMajorRequirements,
      'policy_employment_status': policyEmploymentStatus,
      'policy_site_address': policySiteAddress,
      'policy_support_content': policySupportContent,
      'policy_entry_limit': policyEntryLimit,
      'policy_application_procedure': policyApplicationProcedure,
      'policy_etc': policyEtc,
      'isBookmarked': isBookmarked,
    };
  }
}
