FROM java:8-jre-alpine

ADD dump /dump
ADD run.sh /usr/local/bin/

RUN  echo "http://dl-4.alpinelinux.org/alpine/edge/testing" >> /etc/apk/repositories \
    && apk add --update curl mongodb-tools netcat-openbsd \
    && rm -rf $CATALINA_HOME/webapps/* \
    && chmod +x /usr/local/bin/run.sh \
    && touch /.firstrun 
    && curl -fsSL -o $CATALINA_HOME/webapps/soaf.war \
        "https://oss.sonatype.org/content/groups/public/mil/navy/spawar/soaf/soaf-services-webapp/1.0.1/soaf-services-webapp-1.0.1.war" \
    && curl -fsSL -o $CATALINA_HOME/webapps/examples.war \
        "https://oss.sonatype.org/content/groups/public/mil/navy/spawar/soaf/soaf-examples-webapp/1.0.1/soaf-examples-webapp-1.0.1.war"  

ADD conf/truststore.jks $CATALINA_HOME/certs/
ADD conf/setenv.sh $CATALINA_HOME/bin/

ENTRYPOINT /usr/local/bin/run.sh
