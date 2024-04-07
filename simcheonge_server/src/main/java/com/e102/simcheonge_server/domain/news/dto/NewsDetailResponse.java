package com.e102.simcheonge_server.domain.news.dto;

import lombok.AllArgsConstructor;
import lombok.Data;
import lombok.NoArgsConstructor;

@Data
@NoArgsConstructor
@AllArgsConstructor
public class NewsDetailResponse {
    private String title;
    private String originalContent;
    private String summarizedContent;
    private String time;
    private String reporter;
}
