FROM java:jre-alpine

MAINTAINER arcseldon <arcseldon@gmail.com>

ENV ES_VERSION=5.6.3 \
    KIBANA_VERSION=5.6.3

RUN apk add --quiet --no-progress --no-cache nodejs \
  && adduser -D elasticsearch

USER elasticsearch

WORKDIR /home/elasticsearch

RUN wget -q -O - https://artifacts.elastic.co/downloads/elasticsearch/elasticsearch-${ES_VERSION}.tar.gz \
 |  tar -zx \
 && mv elasticsearch-${ES_VERSION} elasticsearch \
 && wget -q -O - https://artifacts.elastic.co/downloads/kibana/kibana-${KIBANA_VERSION}-linux-x86_64.tar.gz \
 |  tar -zx \
 && mv kibana-${KIBANA_VERSION}-linux-x64 kibana \
 && rm -f kibana/node/bin/node kibana/node/bin/npm \
 && ln -s $(which node) kibana/node/bin/node \
 && ln -s $(which npm) kibana/node/bin/npm \
 && ./elasticsearch/bin/plugin install license \
 && ./elasticsearch/bin/plugin install marvel-agent \
 && ./kibana/bin/kibana plugin --install elasticsearch/marvel/latest \
 && ./kibana/bin/kibana plugin --install elastic/sense 

CMD elasticsearch/bin/elasticsearch --es.logger.level=OFF --network.host=0.0.0.0 & kibana/bin/kibana -Q

EXPOSE 9200 5601
