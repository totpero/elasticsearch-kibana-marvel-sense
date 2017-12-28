FROM java:jre-alpine

MAINTAINER arcseldon <arcseldon@gmail.com>

ENV ES_VERSION=5.2.1 \
    KIBANA_VERSION=6.1.1 \
    FILE elasticsearch-$VERSION.tar.gz
	
RUN apk add openssl --quiet --no-progress --no-cache nodejs \
  && adduser -D elasticsearch

USER elasticsearch

WORKDIR /home/elasticsearch

RUN wget https://artifacts.elastic.co/downloads/elasticsearch/elasticsearch-${ES_VERSION}.tar.gz
RUN tar xvzf elasticsearch-${ES_VERSION}.tar.gz
RUN mv elasticsearch-${ES_VERSION} elasticsearch
RUN wget http://artifacts.elastic.co/downloads/kibana/kibana-${KIBANA_VERSION}-linux-x86_64.tar.gz
RUN tar xvzf kibana-${KIBANA_VERSION}-linux-x86_64.tar.gz
RUN mv kibana-${KIBANA_VERSION}-linux-x86_64 kibana
RUN rm -f kibana/node/bin/node kibana/node/bin/npm
RUN ln -s $(which node) kibana/node/bin/node
RUN ln -s $(which npm) kibana/node/bin/npm
#RUN ./elasticsearch/bin/plugin install license
#RUN ./elasticsearch/bin/plugin install marvel-agent
#RUN ./kibana/bin/kibana plugin --install elasticsearch/marvel/latest
#RUN ./kibana/bin/kibana plugin --install elastic/sense 

CMD elasticsearch/bin/elasticsearch --es.logger.level=OFF --network.host=0.0.0.0 & kibana/bin/kibana -Q

EXPOSE 9200 5601
