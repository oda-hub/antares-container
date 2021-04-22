FROM rootproject/root:6.22.08-ubuntu20.04

RUN pip3 install git+https://git.km3net.de/open-data/openkm3

ADD antares-backend /antares-backend
RUN pip install -r /antares-backend/requirements.txt && \
    pip install /antares-backend

ADD populate_data.py /antares/populate_data.py
ADD config.yml /antares/config.yml
ADD entrypoint.sh /antares/entrypoint.sh

RUN useradd --home-dir /antares --uid 1000 antares

RUN chown -R antares:antares /antares

USER antares

WORKDIR /antares

ENV ANTARES_CONFIG_FILE=/antares/config.yml

ENTRYPOINT [ "/bin/bash", "/antares/entrypoint.sh" ]