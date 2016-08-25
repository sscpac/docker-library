FROM tomcat:jre8-alpine

ENV SOAF_VERSION 1.0.3 

ADD dump /dump
ADD run.sh /usr/local/bin/

RUN  echo "http://dl-4.alpinelinux.org/alpine/edge/testing" >> /etc/apk/repositories \
    && apk add --update curl mongodb-tools netcat-openbsd \
    && rm -rf $CATALINA_HOME/webapps/* \
    && chmod +x /usr/local/bin/run.sh \
    && touch /.firstrun \ 
    && curl -fsSL -o $CATALINA_HOME/webapps/soaf.war \
        "https://oss.sonatype.org/content/groups/public/mil/navy/spawar/soaf/soaf-services-webapp/$SOAF_VERSION/soaf-services-webapp-$SOAF_VERSION.war" \
    && curl -fsSL -o $CATALINA_HOME/webapps/examples.war \
        "https://oss.sonatype.org/content/groups/public/mil/navy/spawar/soaf/soaf-examples-webapp/$SOAF_VERSION/soaf-examples-webapp-$SOAF_VERSION.war"  

ADD conf/truststore.jks $CATALINA_HOME/certs/
ADD conf/setenv.sh $CATALINA_HOME/bin/

ENTRYPOINT /usr/local/bin/run.sh
