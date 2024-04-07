package com.e102.simcheonge_server.domain.comment.dto.request;

import lombok.Data;

@Data
public class CommentReadRequest {
    String commentType;
    int referencedId;
}
