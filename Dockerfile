FROM cyberdojo/sinatra-base:2a66f1d@sha256:2febea8c2c09f561a19afaa7115f1f673403ee18e184d90a7a0a3084958d0085
LABEL maintainer=jon@jaggersoft.com

ARG COMMIT_SHA
ENV SHA=${COMMIT_SHA}

COPY --chown=nobody:nogroup . /
WORKDIR /app
USER nobody
HEALTHCHECK --interval=1s --timeout=1s --retries=5 --start-period=5s CMD /app/config/healthcheck.sh
ENTRYPOINT [ "/sbin/tini", "-g", "--" ]
CMD [ "/app/config/up.sh" ]
