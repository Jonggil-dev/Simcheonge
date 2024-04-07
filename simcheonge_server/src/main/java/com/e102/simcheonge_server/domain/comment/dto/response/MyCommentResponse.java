package com.e102.simcheonge_server.domain.comment.dto.response;

import lombok.Builder;
import lombok.Data;

@Data
@Builder
public class MyCommentResponse {
    int commentId;
    String commentType;
    int referencedId;
    String content;
    String createAt;
}
