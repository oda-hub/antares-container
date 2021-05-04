FROM rootproject/root:6.22.08-ubuntu20.04

RUN apt-get update -qq && apt-get -y install python3-pip git

ADD antares-backend /antares-backend
RUN pip3 install -r /antares-backend/requirements.txt && \
    pip3 install -e /antares-backend[dataload]

ADD config.yml /antares/config.yml
ADD entrypoint.sh /antares/entrypoint.sh

RUN useradd --home-dir /antares --uid 1000 antares

RUN chown -R antares:antares /antares

USER antares

WORKDIR /antares

ENV ANTARES_CONFIG_FILE=/antares/config.yml

ENTRYPOINT [ "/bin/bash", "/antares/entrypoint.sh" ]
