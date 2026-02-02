FROM cyberdojo/sinatra-base:dd38f41@sha256:78e366649c6b28379a7666503149d71aa154960b9421e8a57721da13c1eb7ab1
LABEL maintainer=jon@jaggersoft.com

RUN apk add --upgrade c-ares=1.34.6-r0   # https://security.snyk.io/vuln/SNYK-ALPINE322-CARES-14409293

ARG COMMIT_SHA
ENV SHA=${COMMIT_SHA}

COPY --chown=nobody:nogroup . /
WORKDIR /app
USER nobody
HEALTHCHECK --interval=1s --timeout=1s --retries=5 --start-period=5s CMD /app/config/healthcheck.sh
ENTRYPOINT [ "/sbin/tini", "-g", "--" ]
CMD [ "/app/config/up.sh" ]
