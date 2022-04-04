package com.redhat.amq.benchmark.entity;

import com.fasterxml.jackson.annotation.JsonAutoDetect;
import com.fasterxml.jackson.annotation.JsonPropertyOrder;
import com.fasterxml.jackson.annotation.JsonAutoDetect.Visibility;

import lombok.Data;

import java.time.LocalDateTime;

@JsonAutoDetect(fieldVisibility = Visibility.ANY)
@JsonPropertyOrder
@Data
public class TestMetrics {

    private long elapsedTimeMillis;
    private long totalMessagesSent;
    private String message;
    private LocalDateTime producerStartTime;
    private LocalDateTime producerEndTime;
}
