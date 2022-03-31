package com.redhat.amq.benchmark.entity;

import lombok.*;
import org.hibernate.Hibernate;

import javax.persistence.Entity;
import javax.persistence.GeneratedValue;
import javax.persistence.GenerationType;
import javax.persistence.Id;

import java.sql.Timestamp;
import java.time.Instant;
import java.time.LocalDateTime;
import java.util.Objects;
import java.util.UUID;

@Entity
@Getter
@Setter
@ToString
public class Metadata {
    @Id
    @GeneratedValue(strategy = GenerationType.AUTO)
    private Long id;

    private String benchmarkSeqId;
    private Timestamp startTime;
    private Timestamp endTime;

    public Metadata(){
        this.benchmarkSeqId = UUID.randomUUID().toString();
        this.startTime = Timestamp.from(Instant.now());
    }

    public Metadata(String benchmarkSeqId, Timestamp startTime, Timestamp endTime) {
        this.benchmarkSeqId = benchmarkSeqId;
        this.startTime = startTime;
        this.endTime = endTime;
    }

    public void update(Metadata other) {
        endTime = other.endTime != null ? other.endTime : Timestamp.from(Instant.now());
    }

    @Override
    public boolean equals(Object o) {
        if (this == o) return true;
        if (o == null || Hibernate.getClass(this) != Hibernate.getClass(o)) return false;
        Metadata metadata = (Metadata) o;
        return id != null && Objects.equals(id, metadata.id);
    }

    @Override
    public int hashCode() {
        return getClass().hashCode();
    }
}
