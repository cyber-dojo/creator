FROM cyberdojo/rack-base
LABEL maintainer=jon@jaggersoft.com

COPY --chown=nobody:nogroup . /
WORKDIR /app

ARG SHA
ENV SHA=${SHA}

EXPOSE 4523

USER nobody
CMD [ "/app/up.sh" ]
