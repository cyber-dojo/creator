FROM ghcr.io/cyber-dojo/sinatra-base:ac5f6a7@sha256:e74f2c4f8d2f8fa6504c7d044fd2ed6692c40a735c144d07e06cea38edfefccd AS base

# Compile the SCSS/JS assets to a single app.css and app.js (like ../web).
FROM cyberdojo/asset_builder:f2bcab7 AS assets
COPY app/assets/javascripts /app/app/assets/javascripts
COPY app/assets/stylesheets /app/app/assets/stylesheets
RUN /app/config/compile.sh /tmp/out

FROM base
LABEL maintainer=jon@jaggersoft.com

ARG COMMIT_SHA
ENV SHA=${COMMIT_SHA}

COPY --chown=nobody:nogroup . /
WORKDIR /app
COPY --from=assets --chown=nobody:nogroup /tmp/out/app.css /app/assets/stylesheets/pre-built-app.css
COPY --from=assets --chown=nobody:nogroup /tmp/out/app.js  /app/assets/javascripts/pre-built-app.js
USER nobody
HEALTHCHECK --interval=1s --timeout=1s --retries=5 --start-period=5s CMD /app/config/healthcheck.sh
ENTRYPOINT [ "/sbin/tini", "-g", "--" ]
CMD [ "/app/config/up.sh" ]
