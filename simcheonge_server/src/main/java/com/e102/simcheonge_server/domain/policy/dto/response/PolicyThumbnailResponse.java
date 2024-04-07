package com.e102.simcheonge_server.domain.policy.dto.response;

import lombok.Builder;
import lombok.Data;

@Data
@Builder
public class PolicyThumbnailResponse {
    private int policyId;
    private String policy_name;
}
