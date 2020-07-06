# Emulator core


## Docker image

The docker image build a configuration that makes it possible to have OS9 on a host on the Internet. To build do:
```
docker build -t sorenroug/v6809:latest .
docker push sorenroug/v6809:latest
```
It then expects a volume to be mounted at /var/local where it can find its two disks and the configuration file.

## Configurations

The tinybasic, exbasic directories show different ways to wire the v6809 emulator.
