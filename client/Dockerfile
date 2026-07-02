FROM ghcr.io/cyber-dojo/sinatra-base:3efccf8@sha256:ec7ac22d2d1935065036de11e8b119a1d60a21e112eac395de10987349e5bfe3 AS base
LABEL maintainer=jon@jaggersoft.com

ARG COMMIT_SHA
ENV SHA=${COMMIT_SHA}

# Code at ${APP_DIR}/source, tests mounted at ${APP_DIR}/test (siblings) - mirrors
# ../saver and the server image, so both can be live-mounted and SimpleCov's root
# can be ${APP_DIR}.
ARG APP_DIR=/app
ENV APP_DIR=${APP_DIR}

WORKDIR ${APP_DIR}/source
COPY --chown=nobody:nogroup app/ .
USER nobody
HEALTHCHECK --interval=1s --timeout=1s --retries=5 --start-period=5s CMD ./config/healthcheck.sh
ENTRYPOINT [ "/sbin/tini", "-g", "--" ]
CMD [ "./config/up.sh" ]
