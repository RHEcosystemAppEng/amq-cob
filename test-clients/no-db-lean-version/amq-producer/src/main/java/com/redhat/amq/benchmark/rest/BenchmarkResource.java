package com.redhat.amq.benchmark.rest;

import javax.inject.Inject;
import javax.ws.rs.GET;
import javax.ws.rs.Path;
import javax.ws.rs.PathParam;
import javax.ws.rs.Produces;
import javax.ws.rs.core.MediaType;

import com.fasterxml.jackson.core.JsonProcessingException;
import com.redhat.amq.benchmark.runner.BenchmarkRunner;

@Path("/benchmark")
public class BenchmarkResource {
    @Inject
    BenchmarkRunner benchmarkRunner;

    @GET
    @Produces(MediaType.TEXT_PLAIN)
    @Path("/{durationInSeconds}/{noOfThreads}")
    public String run(@PathParam("durationInSeconds") int durationInSeconds,
                      @PathParam("noOfThreads") int noOfThreads) throws JsonProcessingException, InterruptedException {
        return benchmarkRunner.run(durationInSeconds, noOfThreads);
    }
}