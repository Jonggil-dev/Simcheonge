package com.e102.simcheonge_server.domain.post.dto.response;


import lombok.AllArgsConstructor;
import lombok.Data;
import lombok.NoArgsConstructor;

import java.time.LocalDateTime;
import java.util.Date;

@Data
@NoArgsConstructor
@AllArgsConstructor
public class PostResponse {
    private int userId;
    private int postId;
    private String postName;
    private String postContent;
    private String userNickname;
    private Date createdAt;
    private String categoryName;
}