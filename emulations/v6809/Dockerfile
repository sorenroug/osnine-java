FROM openjdk:13-alpine

COPY target/v6809-1.0-SNAPSHOT-jar-with-dependencies.jar /var/opt

WORKDIR /var/local

VOLUME /var/local

CMD java $JAVA_OPTS -jar /var/opt/v6809-1.0-SNAPSHOT-jar-with-dependencies.jar

