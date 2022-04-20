package com.redhat.amq.benchmark.resources;

import java.util.List;

import javax.inject.Inject;
import javax.inject.Singleton;
import javax.persistence.EntityManager;
import javax.transaction.Transactional;
import com.redhat.amq.benchmark.entity.Error;

import lombok.extern.slf4j.Slf4j;

@Singleton
@Slf4j
public class ErrorResource {
    @Inject
    EntityManager entityManager;

    @Transactional
    public void insertError(String errorMessage) {
        Error error = new Error(errorMessage);
        entityManager.persist(error);
    }

    public void printTopHunErrors() {
        List<Error> errors = entityManager.createQuery("select e from Error e", Error.class)
                .setFirstResult(0)
                .setMaxResults(100)
                .getResultList();
        errors.forEach(System.out::println);
    }

    public long getErrorsCount() {
        return entityManager.createQuery("select count(e) from Error e", Long.class)
                .getSingleResult();
    }

    @Transactional
    public long deleteAllErrors() {
        return entityManager.createQuery("delete from Error ").executeUpdate();
    }

}
