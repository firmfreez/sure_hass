# syntax=docker/dockerfile:1
FROM ghcr.io/we-promise/sure:stable

USER root

RUN apt-get update -qq \
  && apt-get install --no-install-recommends -y jq bash \
  && rm -rf /var/lib/apt/lists/* /var/cache/apt/archives

COPY run.sh /usr/local/bin/run.sh
RUN chmod +x /usr/local/bin/run.sh

WORKDIR /rails
EXPOSE 3000