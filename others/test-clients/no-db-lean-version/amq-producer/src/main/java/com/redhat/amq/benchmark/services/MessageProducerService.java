package com.redhat.amq.benchmark.services;

import com.redhat.amq.benchmark.pojo.Message;
import org.eclipse.microprofile.reactive.messaging.Channel;
import org.eclipse.microprofile.reactive.messaging.Emitter;
import org.eclipse.microprofile.reactive.messaging.OnOverflow;

import javax.enterprise.context.ApplicationScoped;
import javax.inject.Inject;
import java.time.LocalDateTime;

@ApplicationScoped
public class MessageProducerService {

    @Inject
    @Channel("exampleQueue-out")
    @OnOverflow(value = OnOverflow.Strategy.UNBOUNDED_BUFFER)
    Emitter<Message> emitter;

    public Message send(Message message) {
        message.setSent(LocalDateTime.now());
        emitter.send(message);
        return message;
    }
}