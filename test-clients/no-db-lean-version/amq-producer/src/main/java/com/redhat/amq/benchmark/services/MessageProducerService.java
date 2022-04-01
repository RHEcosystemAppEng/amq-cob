package com.redhat.amq.benchmark.services;

import com.redhat.amq.benchmark.pojo.Message;
import org.eclipse.microprofile.reactive.messaging.Channel;
import org.eclipse.microprofile.reactive.messaging.Emitter;
import org.eclipse.microprofile.reactive.messaging.OnOverflow;

import javax.enterprise.context.ApplicationScoped;
import javax.inject.Inject;
import java.sql.Timestamp;
import java.time.Instant;

@ApplicationScoped
public class MessageProducerService {

    @Inject
    @Channel("exampleQueue-out")
    @OnOverflow(value = OnOverflow.Strategy.UNBOUNDED_BUFFER)
    Emitter<Message> emitter;

    public Message send(Message message) {
        emitter.send(message.setSent(Timestamp.from(Instant.now())));
        return message;
    }
}