FROM ghcr.io/cyber-dojo/sinatra-base:1200d3b@sha256:7c4eb39e9b9de9b49f8fc650e47fac58bff984fe50198ab51d8fbdf623d4cc3f AS base

# Compile the SCSS/JS assets to a single app.css and app.js.
FROM cyberdojo/asset_builder:f2bcab7 AS assets
COPY app/assets/javascripts /app/app/assets/javascripts
COPY app/assets/stylesheets /app/app/assets/stylesheets
RUN /app/config/compile.sh /tmp/out

FROM base
LABEL maintainer=jon@jaggersoft.com

ARG COMMIT_SHA
ENV SHA=${COMMIT_SHA}

# The code lives at ${APP_DIR}/source and the tests are mounted at ${APP_DIR}/test
# (siblings under ${APP_DIR}), so they can both be live read-only-mounted without
# nesting, and SimpleCov's root can be ${APP_DIR} to cover both.
ARG APP_DIR=/app
ENV APP_DIR=${APP_DIR}

WORKDIR ${APP_DIR}/source
COPY --chown=nobody:nogroup app/ .
COPY --from=assets --chown=nobody:nogroup /tmp/out/app.css ${APP_DIR}/assets/app.css
COPY --from=assets --chown=nobody:nogroup /tmp/out/app.js  ${APP_DIR}/assets/app.js
USER nobody
HEALTHCHECK --interval=1s --timeout=1s --retries=5 --start-period=5s CMD ./config/healthcheck.sh
ENTRYPOINT [ "/sbin/tini", "-g", "--" ]
CMD [ "./config/up.sh" ]
