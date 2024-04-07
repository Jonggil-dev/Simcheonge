package com.e102.simcheonge_server.domain.policy.dto.admin;

import lombok.AllArgsConstructor;
import lombok.Builder;
import lombok.Data;
import lombok.NoArgsConstructor;

@Data
@Builder
@AllArgsConstructor
@NoArgsConstructor
public class PolicyAdminReadResponse {
    private int policyId;
    private String policy_name;
    private boolean isProcessed;
}
