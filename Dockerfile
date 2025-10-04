FROM cyberdojo/sinatra-base:759c4e9@sha256:d5f87f343a9f88a598b810c0f02b81db0bb67319701a956aec3577cbd51c1c24
LABEL maintainer=jon@jaggersoft.com

RUN apk upgrade libcrypto3 libssl3       # https://security.snyk.io/vuln/SNYK-ALPINE322-OPENSSL-13174133
RUN apk upgrade git                      # https://security.snyk.io/vuln/SNYK-ALPINE320-GIT-10669667
RUN apk upgrade libexpat                 # https://security.snyk.io/vuln/SNYK-ALPINE320-EXPAT-13003709
RUN apk upgrade musl                     # https://security.snyk.io/vuln/SNYK-ALPINE320-MUSL-8720638

ARG COMMIT_SHA
ENV SHA=${COMMIT_SHA}

COPY --chown=nobody:nogroup . /
WORKDIR /app
USER nobody
HEALTHCHECK --interval=1s --timeout=1s --retries=5 --start-period=5s CMD /app/config/healthcheck.sh
ENTRYPOINT [ "/sbin/tini", "-g", "--" ]
CMD [ "/app/config/up.sh" ]
