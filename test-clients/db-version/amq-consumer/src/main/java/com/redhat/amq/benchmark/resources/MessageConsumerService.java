package com.redhat.amq.benchmark.resources;

import javax.enterprise.context.ApplicationScoped;
import javax.inject.Inject;

import com.redhat.amq.benchmark.entity.Message;
import com.redhat.amq.benchmark.entity.Metadata;
import org.eclipse.microprofile.reactive.messaging.Incoming;

import io.smallrye.common.annotation.Blocking;
import lombok.extern.slf4j.Slf4j;

@ApplicationScoped
@Slf4j
public class MessageConsumerService {
    private long receiveCount = 0;

    @Inject
    MessageResource messageResource;

    @Inject
    ErrorResource errorResource;

    @Inject
    MetadataResource metadataResource;

    @Incoming("exampleQueue-in")
    // SG: required if using entityManager
    @Blocking
    public void receive(Message message) {
        if ( receiveCount == 0 ) {
            log.info("Beginning to receive messages");
        }
        receiveCount++;
        
        log.info("Message received: * " + receiveCount + " " + message.getUuid());
        
        Metadata metadata = metadataResource.getMetadata();
        if (metadata != null) {
            if (metadata.getBenchmarkSeqId() != null && metadata.getBenchmarkSeqId().equals(message.getBenchmarkSeqId())) {
                Message updatedMessage = messageResource.updateMessage(message);

                if (updatedMessage == null) {
                    String errorMsg = "Message is received but there is no source message record - message UID=" + message.getUuid();
                    errorResource.insertError(errorMsg);
                    log.error(errorMsg);
                }
            } else {
                log.info("Received an old message. message_benchmark_seq_id=" + message.getBenchmarkSeqId() + ", metadata_benchmark_seq_id=" + metadata.getBenchmarkSeqId());
                return;
            }
        } else {
                log.info(String.format("Received an old message. benchmark_seq_id=%s, uuid=%s, sent=%s", message.getBenchmarkSeqId(), message.getUuid(), message.getSent()));
                return;
        }
    }
}