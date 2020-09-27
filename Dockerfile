ARG GRAALVM_VERSION=latest
ARG BUSYBOX_VERSION=latest

FROM oracle/graalvm-ce:${GRAALVM_VERSION} as graal
ARG WIREMOCK_VERSION=2.27.2

RUN gu install native-image

WORKDIR /wiremock

ADD https://repo1.maven.org/maven2/com/github/tomakehurst/wiremock-jre8-standalone/${WIREMOCK_VERSION}/wiremock-jre8-standalone-${WIREMOCK_VERSION}.jar \
    /wiremock/wiremock-standalone.jar
ADD https://repo1.maven.org/maven2/org/slf4j/slf4j-simple/1.7.30/slf4j-simple-1.7.30.jar \
    /wiremock/slf4j-simple.jar

RUN mkdir -p META-INF
COPY native-image META-INF/native-image

#CMD java -agentlib:native-image-agent=config-merge-dir=META-INF/native-image \
#  -cp wiremock-standalone.jar:slf4j-simple.jar \
#  com.github.tomakehurst.wiremock.standalone.WireMockServerRunner

RUN native-image \
  -cp .:wiremock-standalone.jar:slf4j-simple.jar \
  -H:Name=wiremock --static  --no-fallback \
  --report-unsupported-elements-at-runtime --allow-incomplete-classpath \
  --enable-https --initialize-at-run-time \
  com.github.tomakehurst.wiremock.standalone.WireMockServerRunner

FROM scratch
WORKDIR /wiremock
COPY --from=graal /wiremock/wiremock /wiremock/

ENTRYPOINT ["/wiremock/wiremock"]
EXPOSE 8080
