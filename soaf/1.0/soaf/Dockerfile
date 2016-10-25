FROM tomcat:jre8-alpine

ENV SOAF_VERSION 1.0.3 

RUN apk add --update curl \
    && rm -rf $CATALINA_HOME/webapps/* \
    && curl -fsSL -o $CATALINA_HOME/webapps/soaf.war \
        "https://oss.sonatype.org/content/groups/public/mil/navy/spawar/soaf/soaf-services-webapp/$SOAF_VERSION/soaf-services-webapp-$SOAF_VERSION.war" \
    && curl -fsSL -o $CATALINA_HOME/webapps/examples.war \
        "https://oss.sonatype.org/content/groups/public/mil/navy/spawar/soaf/soaf-examples-webapp/$SOAF_VERSION/soaf-examples-webapp-$SOAF_VERSION.war"  

ADD conf/lhnva.jar $CATALINA_HOME/lib/
ADD conf/truststore.jks $CATALINA_HOME/certs/
ADD conf/setenv.sh $CATALINA_HOME/bin/

