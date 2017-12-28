FROM java:jre-alpine

MAINTAINER arcseldon <arcseldon@gmail.com>

ENV ES_VERSION=5.2.1 \
    KIBANA_VERSION=6.1.1

RUN apk add openssl --quiet --no-progress --no-cache nodejs \
  && adduser -D elasticsearch

USER elasticsearch

WORKDIR /home/elasticsearch

RUN \
 wget https://artifacts.elastic.co/downloads/elasticsearch/elasticsearch-${ES_VERSION}.tar.gz \
 && tar xvzf elasticsearch-${ES_VERSION}.tar.gz \
 && mv elasticsearch-${ES_VERSION} elasticsearch \
 && wget http://artifacts.elastic.co/downloads/kibana/kibana-${KIBANA_VERSION}-linux-x86_64.tar.gz \
 && tar xvzf kibana-${KIBANA_VERSION}-linux-x86_64.tar.gz \
 && mv kibana-${KIBANA_VERSION}-linux-x86_64 kibana \
 && rm -f kibana/node/bin/node kibana/node/bin/npm \
 && ln -s $(which node) kibana/node/bin/node \
 && ln -s $(which npm) kibana/node/bin/npm \
 && ./elasticsearch/bin/plugin install license \
 && ./elasticsearch/bin/plugin install marvel-agent \
 && ./kibana/bin/kibana plugin --install elasticsearch/marvel/latest \
 && ./kibana/bin/kibana plugin --install elastic/sense 

CMD elasticsearch/bin/elasticsearch --es.logger.level=OFF --network.host=0.0.0.0 & kibana/bin/kibana -Q

EXPOSE 9200 5601
