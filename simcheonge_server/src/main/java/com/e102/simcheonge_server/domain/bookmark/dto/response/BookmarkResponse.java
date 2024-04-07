package com.e102.simcheonge_server.domain.bookmark.dto.response;

import lombok.AllArgsConstructor;
import lombok.Data;
import lombok.NoArgsConstructor;

@Data
@NoArgsConstructor
@AllArgsConstructor
public class BookmarkResponse {
    private int bookmarkId;
    private int userId;
    private int referencedId;
    private String bookmarkType;
    private boolean isMyComment;
}
