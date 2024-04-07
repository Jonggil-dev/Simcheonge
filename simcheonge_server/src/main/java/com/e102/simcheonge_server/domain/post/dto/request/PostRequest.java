package com.e102.simcheonge_server.domain.post.dto.request;

public class PostRequest {

    private String postName;
    private String postContent;
    private String categoryCode;
    private Integer categoryNumber;
    private String keyword;
    private String userNickname;

    // Constructors, Getters, and Setters

    public PostRequest() {
    }

    public String getPostName() {
        return postName;
    }

    public void setPostName(String postName) {
        this.postName = postName;
    }

    public String getPostContent() {
        return postContent;
    }

    public void setPostContent(String postContent) {
        this.postContent = postContent;
    }

    public String getCategoryCode() {
        return categoryCode;
    }

    public void setCategoryCode(String categoryCode) {
        this.categoryCode = categoryCode;
    }

    public Integer getCategoryNumber() { return this.categoryNumber; }

    public void setCategoryNumber(Integer categoryNumber) { this.categoryNumber = categoryNumber; }

    public String getKeyword() { return keyword; }

    public void setKeyword(String keyword) { this.keyword = keyword; }

    public String getUserNickname() {
        return userNickname;
    }

    public void setUserNickname(String userNickname) {
        this.userNickname = userNickname;
    }
}