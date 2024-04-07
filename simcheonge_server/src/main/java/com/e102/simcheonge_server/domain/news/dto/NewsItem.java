package com.e102.simcheonge_server.domain.news.dto;

import lombok.AllArgsConstructor;
import lombok.Data;
import lombok.NoArgsConstructor;

@Data
@NoArgsConstructor
@AllArgsConstructor
public class NewsItem {
    private String title;
    private String description;
    private String publisher;
    private String Link;
}
