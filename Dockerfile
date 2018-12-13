FROM alpine:3.8

LABEL maintainer "cward@mintel.com" \
      vcs-url "https://github.com/mintel/docker-es-snapshot"

RUN apk --no-cache add curl jq

COPY entrypoint.sh /

USER nobody

CMD /entrypoint.sh
