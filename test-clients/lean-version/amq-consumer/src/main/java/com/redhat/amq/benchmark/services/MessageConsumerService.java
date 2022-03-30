package com.redhat.amq.benchmark.services;

import java.sql.Timestamp;
import java.time.Instant;

import javax.enterprise.context.ApplicationScoped;
import javax.inject.Inject;

import com.redhat.amq.benchmark.pojo.Message;

import org.eclipse.microprofile.reactive.messaging.Incoming;
import org.jboss.logging.Logger;

@ApplicationScoped
public class MessageConsumerService {
    private final Logger logger = Logger.getLogger(MessageConsumerService.class);
    private long receiveCount = 0;

    @Incoming("exampleQueue-in")
    public void receive(Message message) {
        if ( receiveCount == 0 ) {
            logger.info("Beginning to receive messages");
        }
        receiveCount++;
        if (receiveCount % 50000 == 0) {
            logger.info("*" + receiveCount + " " + message.getDescription());
        }
    }
}
