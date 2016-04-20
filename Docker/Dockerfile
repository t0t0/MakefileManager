
FROM alpine
MAINTAINER Tomas Vercautter & Toon Lamberigts

# Install redis
RUN apk add --update redis && \
    rm -rf /var/cache/apk/* && \
    mkdir /data && \
    chown -R redis:redis /data


VOLUME ["/data"]

# Expose the ports for redis
EXPOSE 6379