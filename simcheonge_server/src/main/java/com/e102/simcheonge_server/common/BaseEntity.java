package com.e102.simcheonge_server.common;

import jakarta.persistence.Column;
import jakarta.persistence.MappedSuperclass;
import lombok.Getter;
import org.hibernate.annotations.CreationTimestamp;

import java.util.Date;


@Getter
@MappedSuperclass
public class BaseEntity {
    @Column(name = "created_at", columnDefinition = "DATETIME", nullable = false)
    @CreationTimestamp
    private Date createdAt;

    @Column(name = "is_deleted", nullable = false)
    private boolean isDeleted = false;

    @Column(name = "deleted_at", columnDefinition = "DATETIME")
    private Date deletedAt;

    public void setDeleted(boolean deleted) {
        isDeleted = deleted;
        if(isDeleted){
            deletedAt = new Date();
        }else{
            deletedAt = null;
        }
    }
}
