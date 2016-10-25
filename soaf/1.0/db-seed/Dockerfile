FROM mongo

ADD dump /dump
ADD run.sh /usr/local/bin/

RUN chmod +x /usr/local/bin/run.sh && touch /.firstrun \ 
	&& apt-get update && apt-get install -y netcat

ENTRYPOINT /usr/local/bin/run.sh
