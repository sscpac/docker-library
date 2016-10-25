#!/bin/sh

CATALINA_OPTS="
    -javaagent:$CATALINA_HOME/lib/lhnva.jar
    -Djavax.net.ssl.trustStore=\"$CATALINA_HOME/certs/truststore.jks\"
    -Djavax.net.ssl.trustStorePassword=password
    -XX:+UseConcMarkSweepGC
    -XX:+ExplicitGCInvokesConcurrent
    $CATALINA_OPTS
"

#    -Xmx1024m
#    -Xms512m
#    -XX:PermSize=128m
#    -XX:MaxPermSize=256m


#
# High Performance EXAMPLE CATALINA_OPTS Settings (Notice, Xmx == Xms):
#       -Xmx7168m
#       -Xms7168m
#   -XX:PermSize=1024m
#   -XX:MaxPermSize=2048m
#

#if the server jvm is available
if java -server -version 2> /dev/null; then
    CATALINA_OPTS="-server $CATALINA_OPTS"
fi

echo "Running setenv.sh"
echo "Changing directory to CATALINA_HOME"
cd $CATALINA_HOME


