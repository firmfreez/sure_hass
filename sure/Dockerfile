# syntax=docker/dockerfile:1
ARG SURE_BASE_IMAGE=ghcr.io/firmfreez/sure:0.7.6-alpha.10-ha-2
FROM ${SURE_BASE_IMAGE}

USER root

RUN apt-get update -qq \
  && apt-get install --no-install-recommends -y jq bash \
  && rm -rf /var/lib/apt/lists/* /var/cache/apt/archives

COPY run.sh /usr/local/bin/run.sh
RUN chmod +x /usr/local/bin/run.sh

WORKDIR /rails
EXPOSE 3000

USER root
ENTRYPOINT ["/usr/local/bin/run.sh"]
