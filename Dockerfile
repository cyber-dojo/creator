FROM ghcr.io/cyber-dojo/sinatra-base:3ce6c9b@sha256:7e53acc4239e11722997e85367eb8e995d995ceec05f1cc6430da989bb09b108
LABEL maintainer=jon@jaggersoft.com

ARG COMMIT_SHA
ENV SHA=${COMMIT_SHA}

RUN apk add --upgrade openssl=3.5.6-r0 # https://security.snyk.io/vuln/SNYK-ALPINE322-OPENSSL-15993406

COPY --chown=nobody:nogroup . /
WORKDIR /app
USER nobody
HEALTHCHECK --interval=1s --timeout=1s --retries=5 --start-period=5s CMD /app/config/healthcheck.sh
ENTRYPOINT [ "/sbin/tini", "-g", "--" ]
CMD [ "/app/config/up.sh" ]
