package io.containerapps.javaruntime.workshop.micronaut;

import io.micronaut.test.extensions.junit5.annotation.MicronautTest;
import io.restassured.specification.RequestSpecification;
import org.junit.jupiter.api.BeforeEach;
import org.junit.jupiter.api.Test;

import static io.restassured.RestAssured.given;
import static org.hamcrest.CoreMatchers.*;

@MicronautTest
class MicronautResourceTest {

    private static String basePath = "http://localhost:8802/micronaut";

    @Test
    public void testHelloEndpoint(RequestSpecification spec) {
        spec
          .when().get(basePath)
          .then()
            .statusCode(200)
            .body(is("Micronaut: hello"));
    }

    @Test
    public void testCpuWithDBAndDescEndpoint() {
        given().param("iterations", 1).param("db", true).param("desc", "Java17")
          .when().get(basePath + "/cpu")
          .then()
            .statusCode(200)
            .body(startsWith("Micronaut: CPU consumption is done with"))
            .body(not(containsString("Java17")))
            .body(endsWith("The result is persisted in the database."));
    }

    @Test
    public void testMemoryWithDBAndDescEndpoint() {
        given().param("bites", 1).param("db", true).param("desc", "Java17")
          .when().get(basePath + "/memory")
          .then()
            .statusCode(200)
            .body(startsWith("Micronaut: Memory consumption is done with"))
            .body(not(containsString("Java17")))
            .body(endsWith("The result is persisted in the database."));
    }

    @Test
    public void testStats() {
        given()
            .when().get(basePath + "/stats")
            .then()
            .statusCode(200);
    }

}