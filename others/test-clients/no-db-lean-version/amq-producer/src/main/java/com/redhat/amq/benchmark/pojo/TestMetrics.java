package com.redhat.amq.benchmark.pojo;

import java.time.LocalDateTime;

import com.fasterxml.jackson.annotation.JsonAutoDetect;
import com.fasterxml.jackson.annotation.JsonPropertyOrder;
import com.fasterxml.jackson.annotation.JsonAutoDetect.Visibility;

@JsonAutoDetect(fieldVisibility = Visibility.ANY)
@JsonPropertyOrder
public class TestMetrics {
    private long totalMessagesSent;
    private long runTimeInSeconds;
    private LocalDateTime producerStartTime;
    private LocalDateTime producerEndTime;
    public long getTotalMessagesSent() {
        return totalMessagesSent;
    }
    public void setTotalMessagesSent(long totalMessagesSent) {
        this.totalMessagesSent = totalMessagesSent;
    }
    public long getRunTimeInSeconds() {
        return runTimeInSeconds;
    }
    public void setRunTimeInSeconds(long runTimeInSeconds) {
        this.runTimeInSeconds = runTimeInSeconds;
    }
    public LocalDateTime getProducerStartTime() {
        return producerStartTime;
    }
    public void setProducerStartTime(LocalDateTime producerStartTime) {
        this.producerStartTime = producerStartTime;
    }
    public LocalDateTime getProducerEndTime() {
        return producerEndTime;
    }
    public void setProducerEndTime(LocalDateTime producerEndTime) {
        this.producerEndTime = producerEndTime;
    }

    
}
