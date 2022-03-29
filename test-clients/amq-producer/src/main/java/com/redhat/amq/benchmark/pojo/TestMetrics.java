package com.redhat.amq.benchmark.pojo;

import java.sql.Timestamp;

import com.fasterxml.jackson.annotation.JsonAutoDetect;
import com.fasterxml.jackson.annotation.JsonPropertyOrder;
import com.fasterxml.jackson.annotation.JsonAutoDetect.Visibility;

import lombok.Data;

@JsonAutoDetect(fieldVisibility = Visibility.ANY)
@JsonPropertyOrder
@Data
public class TestMetrics {

    private long elapsedTimeMillis;
    private long totalMessagesSent;
    private String message;
    private Timestamp producerStartTime;
    private Timestamp producerEndTime;

    public long getTotalMessagesSent() {
        return totalMessagesSent;
    }

    public void setTotalMessagesSent(long totalMessagesSent) {
        this.totalMessagesSent = totalMessagesSent;
    }

    public Long getElapsedTimeMillis() {
        return elapsedTimeMillis;
    }

    public void setElapsedTimeMillis(Long elapsedTimeMillis) {
        this.elapsedTimeMillis = elapsedTimeMillis;
    }

    public String getMessage() {
        return message;
    }

    public void setMessage(String message) {
        this.message = message;
    }

    public void setElapsedTimeMillis(long elapsedTimeMillis) {
        this.elapsedTimeMillis = elapsedTimeMillis;
    }

    public Timestamp getProducerStartTime() {
        return producerStartTime;
    }

    public void setProducerStartTime(Timestamp producerStartTime) {
        this.producerStartTime = producerStartTime;
    }

    public Timestamp getProducerEndTime() {
        return producerEndTime;
    }

    public void setProducerEndTime(Timestamp producerEndTime) {
        this.producerEndTime = producerEndTime;
    }
}
