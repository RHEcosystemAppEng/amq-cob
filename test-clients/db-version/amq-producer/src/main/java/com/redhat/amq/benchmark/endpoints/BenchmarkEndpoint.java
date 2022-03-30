package com.redhat.amq.benchmark.endpoints;

import javax.inject.Inject;
import javax.ws.rs.GET;
import javax.ws.rs.Path;
import javax.ws.rs.PathParam;
import javax.ws.rs.Produces;
import javax.ws.rs.core.MediaType;

import com.fasterxml.jackson.core.JsonProcessingException;
import com.fasterxml.jackson.databind.ObjectMapper;
import com.fasterxml.jackson.databind.SerializationFeature;
import com.redhat.amq.benchmark.runner.BenchmarkRunner;
import com.redhat.amq.benchmark.services.StatsService;

@Path("/benchmark")
public class BenchmarkEndpoint {
    @Inject
    BenchmarkRunner benchmarkRunner;

    @Inject
    StatsService statsService;

    @GET
    @Produces(MediaType.TEXT_PLAIN)
    @Path("/{durationInSeconds}/{receiveWaitTimeInSeconds}/{noOfThreads}")
    public String run(@PathParam("durationInSeconds") int durationInSeconds, @PathParam("receiveWaitTimeInSeconds") int receiveWaitTimeInSeconds,
                      @PathParam("noOfThreads") int noOfThreads) throws JsonProcessingException, InterruptedException {
        return benchmarkRunner.run(durationInSeconds, receiveWaitTimeInSeconds, noOfThreads);
    }

    @GET
    @Produces(MediaType.TEXT_PLAIN)
    @Path("/intermittent-metrics")
    public String getIntermittentMetrics() throws JsonProcessingException {
        return new ObjectMapper().enable(SerializationFeature.INDENT_OUTPUT).writeValueAsString(this.statsService.getIntermittentMetrics());
    }
}