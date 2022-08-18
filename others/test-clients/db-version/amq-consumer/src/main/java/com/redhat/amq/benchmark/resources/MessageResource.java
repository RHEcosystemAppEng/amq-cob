package com.redhat.amq.benchmark.resources;

import java.time.LocalDateTime;

import javax.inject.Inject;
import javax.inject.Singleton;
import javax.persistence.EntityManager;
import javax.transaction.Transactional;

import com.redhat.amq.benchmark.entity.Message;

import lombok.extern.slf4j.Slf4j;

@Singleton
@Slf4j
public class MessageResource {

    @Inject
    EntityManager entityManager;

    @Transactional
    public void create(Message message) {
        entityManager.persist(message);
    }

    @Transactional
    public Message updateMessage(Message message) {
        Message result = null;

        if (message.getUuid() == null) {
            String errorMsg = "Message UUID is NOT set. It is required for an update.";
            log.error("{} {}", errorMsg, message);
        } else {
            result = entityManager.createQuery("select m from Message m where m.uuid = :uuid and m.received is null ", Message.class)
                    .setParameter("uuid", message.getUuid())
                    .getSingleResult();
            if (result == null) {
                String errorMsg = "NO message found for the given uuid (" + message.getUuid() + ").";
                log.error("{} {}", errorMsg, message);
            } else {
                result.update(message);
            }
        }

        return result;
    }

    public long getNumberOfMessagesReceived(LocalDateTime received) {
        return entityManager.createQuery("select count(m) from Message m where m.received <= :received", Long.class)
                .setParameter("received", received)
                .getSingleResult();
    }

    public LocalDateTime getLastMessageReceivedTime() {
        LocalDateTime maxReceivedTime = entityManager.createQuery("select max(m.received) from Message m ", LocalDateTime.class).getSingleResult();
        return maxReceivedTime;
    }

    public long getMessagesCount() {
        return entityManager.createQuery("select count(m) from Message m", Long.class)
                .getSingleResult();
    }

    public boolean hasAllMessagesReceived() {
        Long messagesNotYetReceived = entityManager.createQuery("select count(m) from Message m where m.received is null", Long.class)
                .getSingleResult();
        return messagesNotYetReceived == 0;
    }

    @Transactional
    public long deleteAllMessages() {
        return entityManager.createQuery("delete from Message ").executeUpdate();
    }

}
