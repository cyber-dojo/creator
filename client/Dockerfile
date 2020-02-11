FROM cyberdojo/rack-base
LABEL maintainer=jon@jaggersoft.com

COPY . /app

ARG CYBER_DOJO_CREATOR_DEMO_PORT
ENV PORT=${CYBER_DOJO_CREATOR_DEMO_PORT}
EXPOSE ${PORT}

CMD [ "./up.sh" ]
