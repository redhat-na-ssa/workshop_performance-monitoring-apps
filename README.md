# Modern Cloud-native Java runtimes performance monitoring on Red Hat Openshift

[Check the Lab Instructions here](https://bookbag-url.here).

## Quarkus

```shell
cd quarkus-app
mvn test                          # Execute the tests
mvn quarkus:dev                   # Execute the application
curl 'localhost:8701/quarkus'     # Invokes the hello endpoint
```

To build a native application (you need GraalVM installed):
```shell
mvn -Pnative clean package
./target/*-runner
```

To build a Docker image with the native application (you need to build the native image on Linux):
```shell
docker build -t quarkus-app-native -f src/main/docker/Dockerfile.native .
```

## Micronaut

```shell
cd micronaut-app
mvn test                          # Execute the tests
docker compose -f infrastructure/postgres.yaml up
mvn mn:run                        # Execute the application
curl 'localhost:8702/micronaut'   # Invokes the hello endpoint
```

To build a native application (you need GraalVM installed):
```shell
mvn package -Dpackaging=native-image
./target/micronaut-app
```

To build a Docker image with the native application (you need to build the native image on Linux):
```shell
docker build -t micronaut-app-native -f src/main/docker/Dockerfile.native .
```

## SpringBoot

```shell
cd springboot-app
docker compose -f infrastructure/postgres.yaml up
mvn test                          # Execute the tests
mvn spring-boot:run               # Execute the application
curl 'localhost:8703/springboot'  # Invokes the hello endpoint
```

To build a native application (you need GraalVM installed):
```shell
mvn -Pnative clean package
./target/springboot-app
```

To build a Docker image with the native application (you need to build the native image on Linux):
```shell
docker build -t springboot-app-native -f src/main/docker/Dockerfile.native .
```

## Contributing
