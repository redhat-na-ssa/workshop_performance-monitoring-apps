package io.containerapps.javaruntime.workshop.springboot;

import java.time.Duration;
import java.time.Instant;

import jakarta.persistence.Column;
import jakarta.persistence.Entity;
import jakarta.persistence.GeneratedValue;
import jakarta.persistence.Id;
import jakarta.persistence.Table;

@Entity
@Table(name = "Statistics_Springboot")
public class Statistics {

    @GeneratedValue
    @Id
    private Long id;
    @Column(name = "done_at")
    public Instant doneAt = Instant.now();
    public Framework framework = Framework.SPRINGBOOT;
    public Type type;
    public String parameter;
    public Duration duration;
    public String description;
}

enum Type {
    CPU, MEMORY
}

enum Framework {
    QUARKUS, MICRONAUT, SPRINGBOOT
}