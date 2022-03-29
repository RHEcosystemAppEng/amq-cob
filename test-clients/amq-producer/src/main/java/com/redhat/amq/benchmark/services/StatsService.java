package com.redhat.amq.benchmark.services;

import com.redhat.amq.benchmark.pojo.Metadata;
import com.redhat.amq.benchmark.pojo.TestMetrics;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;

import javax.enterprise.context.ApplicationScoped;
import javax.inject.Inject;
import java.time.Duration;
import java.time.Instant;

@ApplicationScoped
public class StatsService {
    private Logger logger = LoggerFactory.getLogger(StatsService.class);

    @Inject
    MessageDaoService messageDaoService;

    @Inject
    ErrorDaoService errorDaoService;

    @Inject
    MetadataDaoService metadataDaoService;

    public TestMetrics buildMetrics(int receiveWaitTimeInSeconds) throws InterruptedException {
        final Metadata metadata = metadataDaoService.getMetadata();


        performConsumerSleepWaitTime(receiveWaitTimeInSeconds);
        logger.info("Consumer wait is done and going to generate metrics now.");
        TestMetrics metrics = new TestMetrics();
        Duration testDuration = Duration.between(metadata.getStartTime().toInstant(), metadata.getEndTime().toInstant());

        metrics.setProducerStartTime(metadata.getStartTime());
        metrics.setProducerEndTime(metadata.getEndTime());

        metrics.setTotalMessagesSent(messageDaoService.getMessagesCount());
        metrics.setElapsedTimeMillis(testDuration.toMillis());

        return metrics;
    }

    private void performConsumerSleepWaitTime(int receiveWaitTimeInSeconds) throws InterruptedException {
        if (receiveWaitTimeInSeconds == -1) {
            Instant consTimeoutStart = Instant.now();
            while (!messageDaoService.hasAllMessagesReceived()) {
                Thread.sleep(10000);
                logger.info("Sleeping for default 10 seconds to receive all the messages.");
                Instant consTimeoutEnd = Instant.now();
                Duration timeoutElapsed = Duration.between(consTimeoutStart, consTimeoutEnd);
                //timeout after 120 minutes.
                if(timeoutElapsed.toMinutes() > 120){
                    break;
                }
            }
        } else {
            logger.info("Sleeping for receiveWaitTimeInSeconds=["+ receiveWaitTimeInSeconds +"] to receive messages");
            Thread.sleep(receiveWaitTimeInSeconds * 1000);
        }
    }

    public TestMetrics getIntermittentMetrics(){
        Instant endTime = Instant.now();
        Metadata metadata = metadataDaoService.getMetadata();
        TestMetrics metrics = new TestMetrics();
        if(metadata == null){
            metrics.setMessage("ERROR: There is no existing benchmark run so no metrics available.");
            return metrics;
        }

        Instant startTime = metadata.getStartTime().toInstant();
        Duration testDuration = Duration.between(startTime, endTime);
        metrics.setTotalMessagesSent(messageDaoService.getMessagesCount());
        metrics.setElapsedTimeMillis(testDuration.toMillis());

        return metrics;
    }
}
