package com.redhat.amq.benchmark.pojo;

import java.time.LocalDateTime;

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

    public String getName() {
        return name;
    }

    public void setName(String name) {
        this.name = name;
    }

    public String getDescription() {
        return description;
    }

    public void setDescription(String description) {
        this.description = description;
    }

    public String getUuid() {
        return uuid;
    }

    public void setUuid(String uuid) {
        this.uuid = uuid;
    }

    public LocalDateTime getSent() {
        return sent;
    }

    public void setSent(LocalDateTime sent) {
        this.sent = sent;
    }

    public LocalDateTime getReceived() {
        return received;
    }

    public void setReceived(LocalDateTime received) {
        this.received = received;
    }

    public String getBenchmarkSeqId() {
        return benchmarkSeqId;
    }

    public void setBenchmarkSeqId(String benchmarkSeqId) {
        this.benchmarkSeqId = benchmarkSeqId;
    }
}