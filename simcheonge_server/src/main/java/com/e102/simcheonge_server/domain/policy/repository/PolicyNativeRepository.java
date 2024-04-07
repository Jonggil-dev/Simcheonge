package com.e102.simcheonge_server.domain.policy.repository;

import com.e102.simcheonge_server.domain.category_detail.dto.request.CategoryDetailSearchRequest;
import com.e102.simcheonge_server.domain.category_detail.entity.CategoryDetail;
import com.e102.simcheonge_server.domain.policy.entity.Policy;
import jakarta.persistence.EntityManager;
import jakarta.persistence.PersistenceContext;
import jakarta.persistence.Query;
import lombok.extern.slf4j.Slf4j;
import org.springframework.data.domain.PageImpl;
import org.springframework.data.domain.Pageable;
import org.springframework.stereotype.Repository;

import java.math.BigInteger;
import java.text.SimpleDateFormat;
import java.util.Date;
import java.util.List;

@Repository
@Slf4j
public class PolicyNativeRepository {

    @PersistenceContext
    private EntityManager entityManager;

    public PageImpl<Object[]> searchPolicy(String keyword, List<CategoryDetailSearchRequest> detailList, Date startDate, Date endDate, List<String> codeList, Pageable pageable) {

        log.info("Repository keyword={}", keyword);
        String subQuery = "";
        if (!detailList.isEmpty()) {
            subQuery = "and policy_id IN ( " +
                    "SELECT policy_id " +
                    "FROM policy_category_detail pcd " +
                    "RIGHT JOIN ( " +
                    "SELECT '" + detailList.get(0).getCode() + "' AS code, " + detailList.get(0).getNumber() + " AS number ";
            for (int i = 1; i < detailList.size(); i++) {
                subQuery += "UNION ALL " +
                        "SELECT '" + detailList.get(i).getCode() + "', " + detailList.get(i).getNumber() + " ";
            }
            subQuery += ") detailList ON pcd.category_code = detailList.code AND " +
                    "pcd.category_number = detailList.number " +
                    "GROUP BY pcd.policy_id ";
            if (!codeList.isEmpty()) {
                subQuery += " HAVING SUM(CASE WHEN pcd.category_code = '"+codeList.get(0)+"' THEN 1 ELSE 0 END) >= 1";
            }
            for (int i = 1; i < codeList.size(); i++) {
                subQuery += " AND SUM(CASE WHEN pcd.category_code = '"+codeList.get(i)+"' THEN 1 ELSE 0 END) >= 1";
            }
            subQuery+=" )";
        }

        boolean containsDetail = detailList.stream()
                .anyMatch(detail -> "APC".equals(detail.getCode()) && 3 == detail.getNumber());

        String sqlQuery = "SELECT * FROM policy WHERE policy_is_processed = true ";
        String countQuery = "SELECT count(*) FROM policy WHERE policy_is_processed = true ";
        if (!keyword.isEmpty()) {
            sqlQuery += "and (policy_name like '%" + keyword + "%' " +
                    "or policy_support_content like '%" + keyword + "%' ) ";
            countQuery += "and (policy_name like '%" + keyword + "%' " +
                    "or policy_support_content like '%" + keyword + "%' ) ";
        }
        if (containsDetail) {
            Date currentDate = new Date();
            SimpleDateFormat sdf = new SimpleDateFormat("yyyy-MM-dd");
            sqlQuery += "and (policy_start_date <= '" + sdf.format(startDate) + "' and policy_end_date >= '" + sdf.format(endDate) + "' )";
            countQuery += "and (policy_start_date <= '" + sdf.format(startDate) + "' and policy_end_date >= '" + sdf.format(endDate) + "' )";
        }
        sqlQuery += subQuery;
        countQuery += subQuery;
        log.info("sqlQuery={}", sqlQuery);
        Query cquery = entityManager.createNativeQuery(countQuery);
        Long count = (Long) cquery.getSingleResult();

        sqlQuery += " LIMIT " + pageable.getPageSize() + " OFFSET " + pageable.getOffset();
        Query query = entityManager.createNativeQuery(sqlQuery);


        @SuppressWarnings("unchecked")
        List<Object[]> resultList = query.getResultList();
        return new PageImpl<>(resultList, pageable, count);
    }
}
