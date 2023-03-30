package io.containerapps.javaruntime.workshop.quarkus;

import javax.ws.rs.DefaultValue;
import javax.ws.rs.GET;
import javax.ws.rs.Path;
import javax.ws.rs.Produces;
import javax.ws.rs.QueryParam;
import javax.ws.rs.core.MediaType;
import java.lang.System.Logger;
import java.time.Duration;
import java.time.Instant;
import java.util.HashMap;
import java.util.List;

import static java.lang.System.Logger.Level.INFO;
import static java.lang.invoke.MethodHandles.lookup;

@Path("/quarkus")
@Produces(MediaType.TEXT_PLAIN)
public class QuarkusResource {

    private static final Logger LOGGER = System.getLogger(lookup().lookupClass().getName());

    // private final StatisticsRepository repository;

    // public QuarkusResource(StatisticsRepository statisticsRepository) {
    //     this.repository = statisticsRepository;
    // }
    @GET
    public String hello() {
      LOGGER.log(INFO, "Quarkus: hello");
      return "Quarkus: hello";
    }
}