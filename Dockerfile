FROM gcr.io/distroless/java:8
ARG WIREMOCK_VERSION=2.25.1

USER nonroot
ENTRYPOINT ["java", "-jar", "wiremock-standalone.jar"]
EXPOSE 8080

WORKDIR /wiremock

ENV JAVA_TOOL_OPTIONS -Djava.security.egd=file:/dev/./urandom -Djava.awt.headless=true -Xmx96m -Xms96m

ADD --chown=nonroot:nonroot \
    https://repo1.maven.org/maven2/com/github/tomakehurst/wiremock-standalone/${WIREMOCK_VERSION}/wiremock-standalone-${WIREMOCK_VERSION}.jar \
    ./wiremock-standalone.jar

