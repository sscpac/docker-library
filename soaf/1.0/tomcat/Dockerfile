FROM java:8-jre-alpine

ENV TOMCAT_VERSION=8.0.35

ENV CATALINA_HOME /usr/local/tomcat
ENV PATH $CATALINA_HOME/bin:$PATH

ADD dump /dump
ADD run.sh  /usr/local/bin/

RUN  echo "http://dl-4.alpinelinux.org/alpine/edge/testing" >> /etc/apk/repositories \
     && apk add --update curl dos2unix mongodb-tools netcat-openbsd \
  && curl \
  --silent \
  --location \
  --retry 3 \
  --cacert /etc/ssl/certs/ca-certificates.crt \
  "https://archive.apache.org/dist/tomcat/tomcat-8/v${TOMCAT_VERSION}/bin/apache-tomcat-${TOMCAT_VERSION}.tar.gz" \
    | gunzip \
    | tar x -C /usr/ \
    && mv /usr/apache-tomcat* $CATALINA_HOME \
    && rm -rf $CATALINA_HOME/webapps/* $CATALINA_HOME/conf/server.xml \
    && chmod +x /usr/local/bin/run.sh \
    && touch /.firstrun 

RUN curl -fsSL -o $CATALINA_HOME/webapps/soaf.war \
        "https://oss.sonatype.org/content/groups/public/mil/navy/spawar/soaf/soaf-services-webapp/1.0.0/soaf-services-webapp-1.0.0.war" \
	&& curl -fsSL -o $CATALINA_HOME/webapps/examples.war \
        "https://oss.sonatype.org/content/groups/public/mil/navy/spawar/soaf/soaf-examples-webapp/1.0.0/soaf-examples-webapp-1.0.0.war" \
	&& curl -fsSL -o $CATALINA_HOME/webapps/cas.war \
        "https://oss.sonatype.org/content/groups/public/mil/navy/spawar/soaf/cas-overlay/1.0-SNAPSHOT/cas-overlay-1.0-20160707.225430-1.war" 

ADD conf/server.xml $CATALINA_HOME/conf/
ADD conf/keystore.jks $CATALINA_HOME/certs/
ADD conf/setenv.sh $CATALINA_HOME/bin/

RUN dos2unix $CATALINA_HOME/bin/setenv.sh /usr/local/bin/run.sh
ENTRYPOINT /usr/local/bin/run.sh
