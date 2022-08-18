package com.redhat.amq.benchmark.services;

import com.redhat.amq.benchmark.resources.MessageResource;
import org.eclipse.microprofile.reactive.messaging.Channel;
import org.eclipse.microprofile.reactive.messaging.Emitter;
import org.eclipse.microprofile.reactive.messaging.OnOverflow;

import javax.enterprise.context.ApplicationScoped;
import javax.inject.Inject;

import com.redhat.amq.benchmark.entity.Message;


import java.time.LocalDateTime;

@ApplicationScoped
public class MessageProducerService {

    @Inject
    @Channel("exampleQueue-out")
    @OnOverflow(value = OnOverflow.Strategy.UNBOUNDED_BUFFER)
    Emitter<Message> emitter;

    @Inject
    MessageResource messageResource;

    public Message send(Message message) {
        message.setSent(LocalDateTime.now());
        emitter.send(message);
        messageResource.create(message);
        return message;
    }
}
