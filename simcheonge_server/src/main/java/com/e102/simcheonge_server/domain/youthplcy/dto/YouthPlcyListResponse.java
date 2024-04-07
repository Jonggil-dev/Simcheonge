package com.e102.simcheonge_server.domain.youthplcy.dto;

import jakarta.xml.bind.annotation.XmlAccessType;
import jakarta.xml.bind.annotation.XmlAccessorType;
import jakarta.xml.bind.annotation.XmlElement;
import jakarta.xml.bind.annotation.XmlRootElement;
import lombok.AllArgsConstructor;
import lombok.Builder;
import lombok.Data;
import lombok.NoArgsConstructor;

import java.util.List;

@XmlRootElement(name = "youthPolicyList")
@XmlAccessorType(XmlAccessType.FIELD)
@Data @Builder
@NoArgsConstructor
@AllArgsConstructor
public class YouthPlcyListResponse {
    private int pageIndex;
    private int totalCnt;

    @XmlElement(name = "youthPolicy")
    private List<YouthPlcyElement> youthPolicies;
}
