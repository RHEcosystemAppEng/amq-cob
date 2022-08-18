package com.redhat.amq.benchmark.pojo;

import java.time.LocalDateTime;

import lombok.Data;

@Data
public class Message {

    private String name;
    private String description;
    private String uuid;
    private LocalDateTime sent;
    private LocalDateTime received;
    private String benchmarkSeqId;

    public Message(String uuid, String name, String description, String benchmarkSeqId) {
        this.uuid = uuid;
        this.name = name;
        this.description = description;
        this.benchmarkSeqId = benchmarkSeqId;
    }
}