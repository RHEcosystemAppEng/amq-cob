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
import java.time.LocalDateTime;
import java.time.temporal.ChronoUnit;

@ApplicationScoped
@Slf4j
public class StatsService {
    @Inject
    MessageResource messageResource;

    @Inject
    ErrorResource errorResource;

    @Inject
    MetadataResource metadataResource;

    public TestMetrics buildMetrics() throws InterruptedException {
        final Metadata metadata = metadataResource.getMetadata();

        TestMetrics metrics = new TestMetrics();
        Duration testDuration = Duration.between(metadata.getStartTime(), metadata.getEndTime());
        metrics.setProducerStartTime(metadata.getStartTime());
        metrics.setProducerEndTime(metadata.getEndTime());

        metrics.setTotalMessagesSent(messageResource.getMessagesCount());
        metrics.setElapsedTimeMillis(testDuration.toMillis());

        return metrics;
    }

    public TestMetrics getIntermittentMetrics(){
        Metadata metadata = metadataResource.getMetadata();
        TestMetrics metrics = new TestMetrics();
        if(metadata == null){
            metrics.setMessage("ERROR: There is no existing benchmark run so no metrics available.");
            return metrics;
        }

        LocalDateTime endTime = LocalDateTime.now();
        long testDuration = ChronoUnit.MILLIS.between(metadata.getStartTime(), endTime);

        metrics.setTotalMessagesSent(messageResource.getMessagesCount());
        metrics.setElapsedTimeMillis(testDuration);

        return metrics;
    }
}
