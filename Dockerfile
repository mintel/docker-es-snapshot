FROM python:alpine

LABEL maintainer "cward@mintel.com" \
      vcs-url "https://github.com/mintel/docker-es-snapshot"

RUN pip install -U --quiet elasticsearch-curator==5.6.0
RUN apk --no-cache add curl

COPY entrypoint.sh /

USER nobody

CMD /entrypoint.sh
