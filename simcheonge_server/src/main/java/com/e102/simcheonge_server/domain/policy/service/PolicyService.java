package com.e102.simcheonge_server.domain.policy.service;

import com.e102.simcheonge_server.common.exception.AuthenticationException;
import com.e102.simcheonge_server.common.exception.DataNotFoundException;
import com.e102.simcheonge_server.domain.bookmark.entity.Bookmark;
import com.e102.simcheonge_server.domain.bookmark.repository.BookmarkRepository;
import com.e102.simcheonge_server.domain.category.dto.response.CategoryResponse;
import com.e102.simcheonge_server.domain.category.dto.response.PolicyCategoryResponse;
import com.e102.simcheonge_server.domain.category.entity.Category;
import com.e102.simcheonge_server.domain.category.repository.CategoryRepository;
import com.e102.simcheonge_server.domain.category_detail.dto.request.CategoryDetailSearchRequest;
import com.e102.simcheonge_server.domain.category_detail.entity.CategoryDetail;
import com.e102.simcheonge_server.domain.category_detail.repository.CategoryDetailRepository;
import com.e102.simcheonge_server.domain.policy.dto.admin.PolicyDetailAdminReadResponse;
import com.e102.simcheonge_server.domain.policy.dto.request.PolicySearchRequest;
import com.e102.simcheonge_server.domain.policy.dto.request.PolicyUpdateRequest;
import com.e102.simcheonge_server.domain.policy.dto.admin.PolicyAdminReadResponse;
import com.e102.simcheonge_server.domain.policy.dto.response.PolicyDetailResponse;
import com.e102.simcheonge_server.domain.policy.dto.response.PolicyThumbnailResponse;
import com.e102.simcheonge_server.domain.policy.entity.Policy;
import com.e102.simcheonge_server.domain.policy.repository.PolicyNativeRepository;
import com.e102.simcheonge_server.domain.policy.repository.PolicyRepository;
import com.e102.simcheonge_server.domain.user.entity.User;
import com.e102.simcheonge_server.domain.user.repository.UserRepository;
import lombok.AllArgsConstructor;
import lombok.extern.slf4j.Slf4j;
import org.springframework.data.domain.PageImpl;
import org.springframework.data.domain.Pageable;
import org.springframework.security.core.userdetails.UserDetails;
import org.springframework.stereotype.Service;

import java.util.*;

@Service
@AllArgsConstructor
@Slf4j
public class PolicyService {
    private final PolicyRepository policyRepository;
    private final UserRepository userRepository;
    private final CategoryRepository categoryRepository;
    private final CategoryDetailRepository categoryDetailRepository;
    private final PolicyNativeRepository policyNativeRepository;
    private final BookmarkRepository bookmarkRepository;
    private final HashMap<String, Integer> codeCheckMap = new HashMap<>();
    private final String[] checkCategories = {"ADM", "SPC", "EPM"};

    public PolicyDetailResponse getPolicy(int policyId, UserDetails userDetails) {
        Policy policy = policyRepository.findByPolicyId(policyId)
                .orElseThrow(() -> new DataNotFoundException("해당 정책이 존재하지 않습니다."));
        if(!policy.isProcessed()){
            throw new AuthenticationException("해당 정책 조회에 대한 권한이 없습니다.");
        }

        boolean isBookmarked=false;
        if(userDetails!=null){
            String userLoginId = userDetails.getUsername();
            Optional<User> loginUser = userRepository.findByUserLoginId(userLoginId);
            Optional<Bookmark> bookmark = bookmarkRepository.findByUserIdAndReferencedIdAndBookmarkType(loginUser.get().getUserId(), policyId, "POL");
            isBookmarked=bookmark.isPresent();
        }

        String policy_period_type_code = policy.getPeriodTypeCode();
        if (policy.getPeriodTypeCode().equals("002001")) policy_period_type_code = "상시";
        else if (policy.getPeriodTypeCode().equals("002005")) policy_period_type_code = "미정";
        else if (policy.getPeriodTypeCode().equals("002004")) policy_period_type_code = "특정 기간";

        String policy_area=policy.getArea();
        if(policy_area.startsWith("3001")) policy_area="중앙부처";
        else if(policy_area.startsWith("3002001")) policy_area="서울";
        else if(policy_area.startsWith("3002002")) policy_area="부산";
        else if(policy_area.startsWith("3002003")) policy_area="대구";
        else if(policy_area.startsWith("3002004")) policy_area="인천";
        else if(policy_area.startsWith("3002005")) policy_area="광주";
        else if(policy_area.startsWith("3002006")) policy_area="대전";
        else if(policy_area.startsWith("3002007")) policy_area="울산";
        else if(policy_area.startsWith("3002008")) policy_area="경기";
        else if(policy_area.startsWith("3002009")) policy_area="강원";
        else if(policy_area.startsWith("3002010")) policy_area="충북";
        else if(policy_area.startsWith("3002011")) policy_area="충남";
        else if(policy_area.startsWith("3002012")) policy_area="전북";
        else if(policy_area.startsWith("3002013")) policy_area="전남";
        else if(policy_area.startsWith("3002014")) policy_area="경북";
        else if(policy_area.startsWith("3002015")) policy_area="경남";
        else if(policy_area.startsWith("3002016")) policy_area="제주";
        else if(policy_area.startsWith("3002017")) policy_area="세종";

        PolicyDetailResponse thumbnailResponse = PolicyDetailResponse.builder()
                .policy_name(Optional.ofNullable(policy.getName()).orElse(""))
                .policy_intro(Optional.ofNullable(policy.getIntro()).orElse(""))
                .policy_support_scale(Optional.ofNullable(policy.getSupportScale()).orElse(""))
                .policy_period_type_code(policy_period_type_code)
                .policy_start_date(Optional.ofNullable(policy.getStartDate()).map(Object::toString).orElse(""))
                .policy_end_date(Optional.ofNullable(policy.getEndDate()).map(Object::toString).orElse(""))
                .policy_main_organization(Optional.ofNullable(policy.getMainOrganization()).orElse(""))
                .policy_operation_organization(Optional.ofNullable(policy.getOperationOrganization()).orElse(""))
                .policy_area(policy_area)
                .policy_age_info(Optional.ofNullable(policy.getAgeInfo()).orElse(""))
                .policy_education_requirements(Optional.ofNullable(policy.getEducationRequirements()).orElse(""))
                .policy_major_requirements(Optional.ofNullable(policy.getMajorRequirements()).orElse(""))
                .policy_employment_status(Optional.ofNullable(policy.getEmploymentStatus()).orElse(""))
                .policy_site_address(Optional.ofNullable(policy.getSiteAddress()).orElse(""))
                .policy_support_content(Optional.ofNullable(policy.getSupportContent()).orElse(""))
                .policy_entry_limit(Optional.ofNullable(policy.getEntryLimit()).orElse(""))
                .policy_application_procedure(Optional.ofNullable(policy.getApplicationProcedure()).orElse(""))
                .policy_etc(Optional.ofNullable(policy.getEtc()).orElse(""))
                .isBookmarked(isBookmarked)
                .build();
        return thumbnailResponse;
    }

    public List<PolicyCategoryResponse> getCategories() {
        List<Category> categoryList = categoryRepository.findAllByCodeNot("POS");
        List<PolicyCategoryResponse> categoryResponses = new ArrayList<>();
        //카테고리
        List<CategoryResponse> categoryResponse1 = new ArrayList<>();
        categoryList.forEach(category -> {
            CategoryResponse categoryResponse = CategoryResponse.builder()
                    .code(category.getCode())
                    .name(category.getName())
                    .build();
            categoryResponse1.add(categoryResponse);
        });
        PolicyCategoryResponse policyCategoryResponse = PolicyCategoryResponse.builder()
                .tag("menu")
                .categoryList(categoryResponse1)
                .build();
        categoryResponses.add(policyCategoryResponse);

        for (Category category : categoryList) {
            //세부 카테고리
            List<CategoryResponse> categoryResponse2 = new ArrayList<>();
            List<CategoryDetail> detailList = categoryDetailRepository.findAllByCode(category.getCode());
            detailList.forEach(detail -> {
                CategoryResponse categoryResponse = CategoryResponse.builder()
                        .code(Integer.toString(detail.getNumber()))
                        .name(detail.getName())
                        .build();
                categoryResponse2.add(categoryResponse);
            });
            PolicyCategoryResponse policyCategoryDetailResponse = PolicyCategoryResponse.builder()
                    .tag(category.getCode())
                    .categoryList(categoryResponse2)
                    .build();
            categoryResponses.add(policyCategoryDetailResponse);
        }
        return categoryResponses;
    }

    public void updatePolicy(int policyId, PolicyUpdateRequest policyUpdateRequest, int userId) {
        User user = userRepository.findById(userId)
                .orElseThrow(() -> new DataNotFoundException("해당 사용자가 존재하지 않습니다."));
        if (!"admin".equals(user.getUserLoginId())) {
            throw new AuthenticationException("관리자 권한이 필요합니다.");
        }
        Policy policy = policyRepository.findByPolicyId(policyId)
                .orElseThrow(() -> new DataNotFoundException("해당 정책이 존재하지 않습니다."));
        policy.updatePolicy(policyUpdateRequest);
        policyRepository.save(policy);
    }

    public PageImpl<PolicyThumbnailResponse> searchPolicies(PolicySearchRequest policySearchRequest, Pageable pageable) {

        List<String> codeList = validatePolicySearchRequest(policySearchRequest);

        PageImpl<Object[]> policyObjectList = policyNativeRepository.searchPolicy(policySearchRequest.getKeyword(), policySearchRequest.getList(), policySearchRequest.getStartDate(), policySearchRequest.getEndDate(), codeList,pageable);
        List<PolicyThumbnailResponse> responseList = new ArrayList<>();
        for (Object[] policyObject : policyObjectList) {
            Integer policyId = (Integer) policyObject[0];
            String policyName = (String) policyObject[3];

            PolicyThumbnailResponse thumbnailResponse = PolicyThumbnailResponse.builder()
                    .policyId(policyId)
                    .policy_name(policyName)
                    .build();
            responseList.add(thumbnailResponse);
        }
        return new PageImpl<>(responseList, pageable, policyObjectList.getTotalElements());
    }

    private List<String> validatePolicySearchRequest(PolicySearchRequest policySearchRequest) {
        if(policySearchRequest.getKeyword()==null){
            throw new IllegalArgumentException("키워드는 null일 수 없습니다. keyword에 빈 값을 담아 요청해주세요.");
        }

        // {APC,3}일 경우 startDate, endDate null확인
        int APCCount = 0;
        boolean isAPC3exist = false;
        List<String> codeList=new ArrayList<>();
        for (CategoryDetailSearchRequest category : policySearchRequest.getList()) {
            if(!codeList.contains(category.getCode())){
                codeList.add(category.getCode());
            }
            //{ADM,1}, {EPM,1}, {SPC, 1}가 있는지 확인
            if (Arrays.asList(checkCategories).contains(category.getCode()) && category.getNumber() == 1) {
                throw new IllegalArgumentException("해당 카테고리는 '제한 없음'을 선택할 수 없습니다.");
            }
            else if ("APC".equals(category.getCode())) {
                if (category.getNumber() == 3) {
                    if (policySearchRequest.getStartDate() == null || policySearchRequest.getEndDate() == null) {
                        throw new IllegalArgumentException("특정 기간의 startDate, endDate가 없습니다.");
                    }
                    isAPC3exist = true;
                }
                APCCount++;
            }
        }
        if (isAPC3exist && APCCount > 1) {
            throw new IllegalArgumentException("'특정 기간'은 '상시'나 '미정'과 함께 선택할 수 없습니다.");
        }
        return codeList;
    }


    public List<PolicyAdminReadResponse> getAllPolicies(boolean isProcessed,String userNickname) {
        log.info("userNickname={}",userNickname);
        //관리자 권한 필요함
        if(!userNickname.equals("admin")){
            throw new AuthenticationException("해당 유저는 미가공 데이터에 대한 권한이 없습니다.");
        }

        List<Policy> policyList = policyRepository.findAllByIsProcessed(isProcessed);
        List<PolicyAdminReadResponse> responseList=new ArrayList<>();
        policyList.forEach(policy -> {
            PolicyAdminReadResponse resp=PolicyAdminReadResponse.builder()
                    .policyId(policy.getPolicyId())
                    .policy_name(policy.getName())
                    .isProcessed(policy.isProcessed())
                    .build();
            responseList.add(resp);
        });
        return responseList;
    }

    public PolicyDetailAdminReadResponse getPolicyforAdmin(int policyId, String userLoginId) {
        if(!userLoginId.equals("admin")){
            throw new AuthenticationException("해당 유저는 권한이 없습니다.");
        }
        Policy policy = policyRepository.findByPolicyId(policyId)
                .orElseThrow(() -> new DataNotFoundException("해당 정책이 존재하지 않습니다."));

        PolicyDetailAdminReadResponse resp = PolicyDetailAdminReadResponse.builder()
                .code(policy.getCode())
                .area(policy.getArea())
                .name(Optional.ofNullable(policy.getName()).orElse(""))
                .intro(Optional.ofNullable(policy.getIntro()).orElse(""))
                .supportContent(policy.getSupportContent())
                .supportScale(Optional.ofNullable(policy.getSupportScale()).orElse(""))
                .field(policy.getField())
                .businessPeriod(policy.getBusinessPeriod())
                .periodTypeCode(policy.getPeriodTypeCode())
                .startDate(policy.getStartDate())
                .endDate(policy.getEndDate())
                .specializedField(policy.getSpecializedField())
                .residenceIncome(policy.getResidenceIncome())
                .additionalClues(policy.getAdditionalClues())
                .entryLimit(policy.getEntryLimit())
                .applicationProcedure(policy.getApplicationProcedure())
                .requiredDocuments(policy.getRequiredDocuments())
                .evaluationContent(policy.getEvaluationContent())
                .siteAddress(policy.getSiteAddress())
                .mainOrganization(policy.getMainOrganization())
                .mainContact(policy.getMainContact())
                .operationOrganization(policy.getOperationOrganization())
                .operationOrganizationContact(policy.getOperationOrganizationContact())
                .applicationPeriod(policy.getApplicationPeriod())
                .ageInfo(Optional.ofNullable(policy.getAgeInfo()).orElse(""))
                .educationRequirements(Optional.ofNullable(policy.getEducationRequirements()).orElse(""))
                .majorRequirements(Optional.ofNullable(policy.getMajorRequirements()).orElse(""))
                .employmentStatus(Optional.ofNullable(policy.getEmploymentStatus()).orElse(""))
                .etc(Optional.ofNullable(policy.getEtc()).orElse(""))
                .isProcessed(policy.isProcessed())
                .build();

        return resp;
    }

}
