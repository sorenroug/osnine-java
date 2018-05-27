FROM openjdk:8-jre-alpine

COPY target/osnine-v6809-1.0-SNAPSHOT-jar-with-dependencies.jar /var/opt

WORKDIR /var/local

VOLUME /var/local

CMD java $JAVA_OPTS -jar /var/opt/osnine-v6809-1.0-SNAPSHOT-jar-with-dependencies.jar

