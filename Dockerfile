FROM gradle:7 as builder
COPY --chown=gradle:gradle . /app
WORKDIR /app
RUN gradle bootjar

FROM openjdk:8-jdk-alpine
EXPOSE 8081
VOLUME /tmp
ARG targethost=localhost:8080
ENV API_HOST=$targethost
ARG LIBS=app/build/libs
COPY --from=builder ${LIBS}/ /app/lib
ENTRYPOINT ["java","-jar","./app/lib/project-auth-api-0.0.1-SNAPSHOT.jar"]
