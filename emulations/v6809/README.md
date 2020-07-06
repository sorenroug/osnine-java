# V6809 emulator

This is an emulator that is configured with a Java properties file.

## Configurations

The tinybasic, exbasic directories show different ways to wire the emulator.

## Docker image

The docker image build a configuration that makes it possible to have OS9 on a host on the Internet. To build do:
```
docker build -t sorenroug/v6809:latest .
docker push sorenroug/v6809:latest
```
It then expects a volume to be mounted at /var/local where it can find its two disks and the configuration file.

Example docker-compose.yml file:
```
kernel:
  image: sorenroug/v6809:latest
  user: nobody
  environment:
    TZ: Europe/Copenhagen
    JAVA_OPTS: |
      -Dorg.slf4j.simpleLogger.log.org.roug.usim.Acia6551=info
      -Dorg.slf4j.simpleLogger.showDateTime=true
      -Dorg.slf4j.simpleLogger.showLogName=false
      -Dorg.slf4j.simpleLogger.showShortLogName=true
  volumes:
  - /exports/V6809:/var/local
  ports:
  - 23:2323
```
