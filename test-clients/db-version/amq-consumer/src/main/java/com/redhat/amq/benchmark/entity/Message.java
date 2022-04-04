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

@Entity
@Getter
@Setter
@ToString
@NoArgsConstructor
public class Message {

    @Id
    @GeneratedValue(strategy = GenerationType.AUTO)
    private Long id;
    private String uuid;
    private String name;
    private String description;
    private LocalDateTime sent;
    private LocalDateTime received;
    private String benchmarkSeqId;

    public Message(String uuid, String name, String description, String benchmarkSeqId) {
        this.uuid = uuid;
        this.name = name;
        this.description = description;
        this.benchmarkSeqId = benchmarkSeqId;
    }

    public void update(Message other) {
        received = other.received != null ? other.received : LocalDateTime.now();
    }

    @Override
    public boolean equals(Object o) {
        if (this == o) return true;
        if (o == null || Hibernate.getClass(this) != Hibernate.getClass(o)) return false;
        Message message = (Message) o;
        return id != null && Objects.equals(id, message.id);
    }

    @Override
    public int hashCode() {
        return getClass().hashCode();
    }
}
