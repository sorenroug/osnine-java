#!/bin/sh
MYDIR=`dirname "$0" 2>/dev/null`

java=java
if test -n "$JAVA_HOME"; then
    java="$JAVA_HOME/bin/java"
fi
exec "$java" -jar "$MYDIR/@JARFILE@" "$@"

