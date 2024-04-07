package com.e102.simcheonge_server.domain.bookmark.dto.request;

import lombok.Getter;
import lombok.Setter;

@Getter
@Setter
public class BookmarkCreateRequest {
    private String bookmarkType; // "POL" 또는 "POS"
    private Integer policyId;
    private Integer postId;
}
