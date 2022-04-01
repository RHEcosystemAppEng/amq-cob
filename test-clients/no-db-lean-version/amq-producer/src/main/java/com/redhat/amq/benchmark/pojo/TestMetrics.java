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
    private long totalMessagesSent;
    private long runTimeInSeconds;
    private Timestamp producerStartTime;
    private Timestamp producerEndTime;
}
