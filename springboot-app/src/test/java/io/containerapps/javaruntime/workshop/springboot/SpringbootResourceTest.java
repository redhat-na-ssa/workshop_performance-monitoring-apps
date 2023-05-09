package io.containerapps.javaruntime.workshop.springboot;

import static org.assertj.core.api.Assertions.assertThat;
import static org.junit.jupiter.api.Assertions.assertEquals;

import org.junit.jupiter.api.Test;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.boot.test.context.SpringBootTest;
import org.springframework.boot.test.context.SpringBootTest.WebEnvironment;
import org.springframework.boot.test.web.client.TestRestTemplate;
import org.springframework.http.HttpStatus;
import org.springframework.http.ResponseEntity;

@SpringBootTest(webEnvironment = WebEnvironment.DEFINED_PORT)
class SpringbootResourceTest {

    private static String basePath = "http://localhost:8703/springboot";

    @Autowired
    private TestRestTemplate restTemplate;

    @Test
    public void testHelloEndpoint() {
        ResponseEntity<String> response = this.restTemplate.
            getForEntity(basePath, String.class);
    
        assertEquals(response.getStatusCode(), HttpStatus.OK);
        assertThat(response.getBody()).contains("Spring Boot: hello");
    }

    @Test
    public void testCpuWithDBAndDescEndpoint() {
        ResponseEntity<String> response = this.restTemplate.
            getForEntity(basePath + "/cpu?iterations=1&db=true&dec=Java17", String.class);
    
        assertEquals(response.getStatusCode(), HttpStatus.OK);
        assertThat(response.getBody())
            .startsWith("Spring Boot: CPU consumption is done with")
            .doesNotContain("Java17")
            .endsWith("The result is persisted in the database.");
    }

    @Test
    public void testMemoryWithDBAndDescEndpoint() {
        ResponseEntity<String> response = this.restTemplate.
            getForEntity(basePath + "/memory?bites=1&db=true&desc=Java17", String.class);
    
        assertEquals(response.getStatusCode(), HttpStatus.OK);
        assertThat(response.getBody())
            .startsWith("Spring Boot: Memory consumption is done with")
            .doesNotContain("Java17")
            .endsWith("The result is persisted in the database.");
    }

    @Test
    public void testStats() {
        ResponseEntity<String> response = this.restTemplate.
            getForEntity(basePath + "/stats", String.class);
    
        assertEquals(response.getStatusCode(), HttpStatus.OK);
    }
}