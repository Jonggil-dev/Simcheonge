package com.e102.simcheonge_server.domain.youthplcy.dto;

import jakarta.xml.bind.annotation.XmlAccessType;
import jakarta.xml.bind.annotation.XmlAccessorType;
import lombok.AllArgsConstructor;
import lombok.Builder;
import lombok.Data;
import lombok.NoArgsConstructor;


@Data @Builder
@NoArgsConstructor
@AllArgsConstructor
@XmlAccessorType(XmlAccessType.FIELD)
public class YouthPlcyElement {
    private int rnum;
    private String bizId;
    private String polyBizSecd;
    private String polyBizTy;
    private String polyBizSjnm;
    private String polyItcnCn;
    private String sporCn;
    private String sporScvl;
    private String bizPrdCn;
    private String prdRpttSecd;
    private String rqutPrdCn;
    private String ageInfo;
    private String majrRqisCn;
    private String empmSttsCn;
    private String splzRlmRqisCn;
    private String accrRqisCn;
    private String prcpCn;
    private String aditRscn;
    private String prcpLmttTrgtCn;
    private String rqutProcCn;
    private String pstnPaprCn;
    private String jdgnPresCn;
    private String rqutUrla;
    private String rfcSiteUrla1;
    private String rfcSiteUrla2;
    private String mngtMson;
    private String mngtMrofCherCn;
    private String cherCtpcCn;
    private String cnsgNmor;
    private String tintCherCn;
    private String tintCherCtpcCn;
    private String etct;
    private String polyRlmCd;
}
