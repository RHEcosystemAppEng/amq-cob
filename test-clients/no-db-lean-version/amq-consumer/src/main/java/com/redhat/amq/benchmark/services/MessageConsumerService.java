package com.redhat.amq.benchmark.services;

import javax.enterprise.context.ApplicationScoped;
import javax.inject.Inject;

import com.redhat.amq.benchmark.pojo.Message;

import org.eclipse.microprofile.reactive.messaging.Incoming;

import lombok.extern.slf4j.Slf4j;

@ApplicationScoped
@Slf4j
public class MessageConsumerService {
    private long receiveCount = 0;
    private long MESSAGE_EVERY = 50000;

    @Incoming("exampleQueue-in")
    public void receive(Message message) {
        if ( receiveCount == 0 ) {
            log.info("Beginning to receive messages");
        }
        receiveCount++;
        if (receiveCount % MESSAGE_EVERY == 0) {
            log.info("*" + receiveCount + " " + message.getDescription());
        }
    }
}
