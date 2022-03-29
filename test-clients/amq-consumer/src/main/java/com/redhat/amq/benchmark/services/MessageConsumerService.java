package com.redhat.amq.benchmark.services;

import java.sql.Timestamp;
import java.time.Instant;

import javax.enterprise.context.ApplicationScoped;
import javax.inject.Inject;

import com.redhat.amq.benchmark.pojo.Message;
import com.redhat.amq.benchmark.pojo.Metadata;

import org.eclipse.microprofile.reactive.messaging.Incoming;
import org.jboss.logging.Logger;

@ApplicationScoped
public class MessageConsumerService {
    private final Logger logger = Logger.getLogger(MessageConsumerService.class);
    private long receiveCount = 0;

    @Inject
    MessageDaoService messageDaoService;

    @Inject
    ErrorDaoService errorDaoService;

    @Inject
    MetadataDaoService metadataDaoService;

    @Incoming("exampleQueue-in")
    public void receive(Message message) {
        receiveCount++;
        logger.info("\tid: *" + receiveCount + " " + message.getDescription());
        
        Metadata metadata = metadataDaoService.getMetadata();
        if(metadata == null || !metadata.getBenchmarkSeqId().equalsIgnoreCase(message.getBenchmarkSeqId())){
            logger.info("Received an old message..message_benchmark_seq_id="+message.getBenchmarkSeqId()+", metadata_benchmark_seq_id="+metadata.getBenchmarkSeqId());
            return;
        }
       int updatedCount = messageDaoService.updateMessage(message.setReceived(Timestamp.from(Instant.now())));
        logger.info("Message Received: "+ message.getUuid()+", updatedCount="+updatedCount);
       if(updatedCount != 1){
           errorDaoService.insertError("Message is received but updatedCount is not 1 - message UID="+message.getUuid()+", updatedCount"+updatedCount);
           logger.error("Message is received but updatedCount is not 1. There is no source message record - message UID= "+message.getUuid());
       }
    }    
}
