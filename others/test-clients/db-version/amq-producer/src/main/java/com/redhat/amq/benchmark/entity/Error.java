package com.redhat.amq.benchmark.entity;

import java.time.LocalDateTime;

import javax.persistence.Entity;
import javax.persistence.GeneratedValue;
import javax.persistence.GenerationType;
import javax.persistence.Id;

import lombok.Data;
import lombok.NoArgsConstructor;

@Entity
@Data
@NoArgsConstructor
public class Error {
    @Id
    @GeneratedValue(strategy = GenerationType.AUTO)
    private Long id;

    private String errorMessage;
    private LocalDateTime created;

    public Error(String errorMessage) {
        this.errorMessage = errorMessage;
        this.created = LocalDateTime.now();
    }
}