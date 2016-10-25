FROM tomcat:jre8-alpine

ENV CAS_VERSION 1.0.6

RUN rm -rf $CATALINA_HOME/webapps/*  \
    && apk add --update curl 

RUN curl -fsSL -o $CATALINA_HOME/webapps/cas.war \
        "https://oss.sonatype.org/content/groups/public/mil/navy/spawar/soaf/cas-overlay/$CAS_VERSION/cas-overlay-$CAS_VERSION.war" 

ADD conf/lhnva.jar $CATALINA_HOME/lib/
ADD conf/truststore.jks $CATALINA_HOME/certs/
ADD conf/setenv.sh $CATALINA_HOME/bin

