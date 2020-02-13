FROM cyberdojo/rack-base
LABEL maintainer=jon@jaggersoft.com

COPY --chown=nobody:nogroup . /app

ARG CYBER_DOJO_CREATOR_DEMO_PORT
ENV PORT=${CYBER_DOJO_CREATOR_DEMO_PORT}
EXPOSE ${PORT}

USER nobody
CMD [ "/app/up.sh" ]
