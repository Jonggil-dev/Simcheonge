package com.e102.simcheonge_server.domain.comment.dto.response;

import lombok.Builder;
import lombok.Data;

@Data
@Builder
public class CommentResponse {
    int commentId;
    String nickname;
    String content;
    String createAt;
    boolean isMyComment;
}
