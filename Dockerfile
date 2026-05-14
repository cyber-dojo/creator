FROM ghcr.io/cyber-dojo/sinatra-base:3efccf8@sha256:ec7ac22d2d1935065036de11e8b119a1d60a21e112eac395de10987349e5bfe3 AS base
LABEL maintainer=jon@jaggersoft.com

ARG COMMIT_SHA
ENV SHA=${COMMIT_SHA}

COPY --chown=nobody:nogroup . /
WORKDIR /app
USER nobody
HEALTHCHECK --interval=1s --timeout=1s --retries=5 --start-period=5s CMD /app/config/healthcheck.sh
ENTRYPOINT [ "/sbin/tini", "-g", "--" ]
CMD [ "/app/config/up.sh" ]
