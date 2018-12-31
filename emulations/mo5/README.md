# Emulation of Thomson MO5

This is a proof of concept emulation of a Thomson MO5 home computer. Keyboard, screen and sound works, but not the lightpen.

You can save and load programs from emulated cassette tapes. These tape files are not compatible with any other MO5 emulator. It should not be too difficult to change if you know the format.

## Screen shot

![Image of terminal](/images/mo5emulator.png)

## Running

```
java -jar target/mo5emulator-1.1.0-jar-with-dependencies.jar
```
## How to activate logging

You can activate logging output for individual classes or for the whole application:

```
java -Dorg.slf4j.simpleLogger.log.org.roug.osnine.mo5.Beeper=debug \
     -Dorg.slf4j.simpleLogger.log.org.roug.osnine.mo5.Keyboard=debug \
-jar target/mo5emulator-1.1.0-jar-with-dependencies.jar
```
There are many other possibilities. See https://www.slf4j.org/api/org/slf4j/impl/SimpleLogger.html
