# NOTE: creator is stuck on sinatra-base:db948c1
FROM cyberdojo/sinatra-base:db948c1
LABEL maintainer=jon@jaggersoft.com

COPY --chown=nobody:nogroup . /
WORKDIR /app

ARG COMMIT_SHA
ENV SHA=${COMMIT_SHA}

USER nobody
HEALTHCHECK --interval=1s --timeout=1s --retries=5 --start-period=5s CMD /app/config/healthcheck.sh
ENTRYPOINT [ "/sbin/tini", "-g", "--" ]
CMD [ "/app/config/up.sh" ]
