FROM openjdk:8-jre-alpine

COPY target/osnine-core-1.0-SNAPSHOT-jar-with-dependencies.jar /var/opt

WORKDIR /var/local

VOLUME /var/local

CMD java $JAVA_OPTS -jar /var/opt/osnine-core-1.0-SNAPSHOT-jar-with-dependencies.jar

