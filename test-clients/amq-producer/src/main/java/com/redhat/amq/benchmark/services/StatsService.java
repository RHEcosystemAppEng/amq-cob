package com.redhat.amq.benchmark.services;

import com.redhat.amq.benchmark.resources.ErrorResource;
import com.redhat.amq.benchmark.resources.MessageResource;
import com.redhat.amq.benchmark.resources.MetadataResource;
import lombok.extern.slf4j.Slf4j;

import javax.enterprise.context.ApplicationScoped;
import javax.inject.Inject;

import com.redhat.amq.benchmark.entity.Metadata;
import com.redhat.amq.benchmark.entity.TestMetrics;

import java.time.Duration;
import java.time.Instant;

@ApplicationScoped
@Slf4j
public class StatsService {
    @Inject
    MessageResource messageResource;

    @Inject
    ErrorResource errorResource;

    @Inject
    MetadataResource metadataResource;

    public TestMetrics buildMetrics(int receiveWaitTimeInSeconds) throws InterruptedException {
        final Metadata metadata = metadataResource.getMetadata();

        TestMetrics metrics = new TestMetrics();
        Duration testDuration = Duration.between(metadata.getStartTime().toInstant(), metadata.getEndTime().toInstant());

        metrics.setProducerStartTime(metadata.getStartTime());
        metrics.setProducerEndTime(metadata.getEndTime());

        metrics.setTotalMessagesSent(messageResource.getMessagesCount());
        metrics.setElapsedTimeMillis(testDuration.toMillis());

        return metrics;
    }

    public TestMetrics getIntermittentMetrics(){
        Instant endTime = Instant.now();
        Metadata metadata = metadataResource.getMetadata();
        TestMetrics metrics = new TestMetrics();
        if(metadata == null){
            metrics.setMessage("ERROR: There is no existing benchmark run so no metrics available.");
            return metrics;
        }

        Instant startTime = metadata.getStartTime().toInstant();
        Duration testDuration = Duration.between(startTime, endTime);
        metrics.setTotalMessagesSent(messageResource.getMessagesCount());
        metrics.setElapsedTimeMillis(testDuration.toMillis());

        return metrics;
    }
}
