FROM cyberdojo/rack-base
LABEL maintainer=jon@jaggersoft.com

COPY --chown=nobody:nogroup . /
WORKDIR /app

ARG SHA
ENV SHA=${SHA}

ARG CYBER_DOJO_CREATOR_PORT
ENV PORT=${CYBER_DOJO_CREATOR_PORT}
EXPOSE ${PORT}

USER nobody
CMD [ "/app/up.sh" ]
