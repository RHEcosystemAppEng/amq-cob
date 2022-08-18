package com.redhat.amq.benchmark.resources;

import java.util.List;

import javax.inject.Inject;
import javax.inject.Singleton;
import javax.persistence.EntityManager;
import javax.transaction.Transactional;

import com.redhat.amq.benchmark.entity.Metadata;
import lombok.extern.slf4j.Slf4j;

@Singleton
@Slf4j
public class MetadataResource {
    @Inject
    EntityManager entityManager;

    public int deleteMetada() {
        return entityManager.createQuery("delete from Metadata").executeUpdate();
    }

    @Transactional
    public void insertMetadata(Metadata metadata) {
        this.deleteMetada();

        entityManager.persist(metadata);
    }

    public Metadata getMetadata() {
        Metadata metadata = null;

        List<Metadata> dataList = entityManager.createQuery("SELECT m from Metadata m", Metadata.class)
                .getResultList();
        if (!dataList.isEmpty()) {
            metadata = dataList.get(0);
        }

        return metadata;
    }

    @Transactional
    public Metadata updateMetadata(Metadata metadata) {
        Metadata result = entityManager.createQuery("select m from Metadata m where m.benchmarkSeqId = :id", Metadata.class)
                .setParameter("id", metadata.getBenchmarkSeqId())
                .getSingleResult();
        if (result == null) {
            String errorMsg = "NO metadata found for the given seqId (" + metadata.getBenchmarkSeqId() + ").";
            log.error("{} {}", errorMsg, metadata);
        } else {
            result.update(metadata);
        }

        return result;
    }

}