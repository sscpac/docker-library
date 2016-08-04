FROM tomcat:jre8-alpine

RUN rm -rf $CATALINA_HOME/webapps/*  \
    && apk add --update curl 

RUN curl -fsSL -o $CATALINA_HOME/webapps/cas.war \
        "https://oss.sonatype.org/content/groups/public/mil/navy/spawar/soaf/cas-overlay/1.0.4/cas-overlay-1.0.4.war" 

ADD conf/truststore.jks $CATALINA_HOME/certs/
ADD conf/setenv.sh $CATALINA_HOME/bin



