//package com.e102.simcheonge_server.common;
//
//import com.e102.simcheonge_server.domain.category.entity.Category;
//import com.e102.simcheonge_server.domain.category.repository.CategoryRepository;
//import com.e102.simcheonge_server.domain.category_detail.entity.CategoryDetail;
//import com.e102.simcheonge_server.domain.category_detail.repository.CategoryDetailRepository;
//import jakarta.annotation.PostConstruct;
//import lombok.AllArgsConstructor;
//import lombok.extern.slf4j.Slf4j;
//import org.springframework.stereotype.Component;
//import org.springframework.transaction.annotation.Transactional;
//
//import java.util.Optional;
//
//@Component
//@AllArgsConstructor
//@Slf4j
//@Transactional
//public class CategoryInitializer {
//
//    private final CategoryRepository categoryRepository;
//    private final CategoryDetailRepository categoryDetailRepository;
//
//    @PostConstruct
//    @Transactional
//    public void init(){
//
//        CategoryDetail categoryDetail1= CategoryDetail.builder()
//                .code("EPM")
//                .number(1)
//                .name("제한 없음")
//                .build();
//        categoryDetailRepository.save(categoryDetail1);
//
//        CategoryDetail categoryDetail2= CategoryDetail.builder()
//                .code("EPM")
//                .number(2)
//                .name("재직자")
//                .build();
//        categoryDetailRepository.save(categoryDetail2);
//
//        CategoryDetail categoryDetail3= CategoryDetail.builder()
//                .code("EPM")
//                .number(3)
//                .name("개인사업자")
//                .build();
//        categoryDetailRepository.save(categoryDetail3);
//
//        CategoryDetail categoryDetail4= CategoryDetail.builder()
//                .code("EPM")
//                .number(4)
//                .name("미취업자")
//                .build();
//        categoryDetailRepository.save(categoryDetail4);
//
//        CategoryDetail categoryDetail5= CategoryDetail.builder()
//                .code("EPM")
//                .number(5)
//                .name("석, 박사")
//                .build();
//        categoryDetailRepository.save(categoryDetail5);
//
//        CategoryDetail categoryDetail0= CategoryDetail.builder()
//                .code("EPM")
//                .number(6)
//                .name("제한 없음")
//                .build();
//        categoryDetailRepository.save(categoryDetail0);
//    }
//}
