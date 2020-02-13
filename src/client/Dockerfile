FROM cyberdojo/rack-base
LABEL maintainer=jon@jaggersoft.com

COPY --chown=nobody:nogroup . /app

ARG CYBER_DOJO_CREATOR_CLIENT_PORT
ENV PORT=${CYBER_DOJO_CREATOR_CLIENT_PORT}
EXPOSE ${PORT}

USER nobody
CMD [ "/app/up.sh" ]
