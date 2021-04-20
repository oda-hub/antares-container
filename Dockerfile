FROM centos:8

RUN yum -y install epel-release && yum -y install root && yum -y install git
ADD antares-backend/antares_data_server_wd /antares_data_server

RUN pip3 install -r /antares_data_server/requirements.txt && \
    pip3 install /antares_data_server

RUN pip3 install git+https://git.km3net.de/open-data/openkm3

RUN useradd --home-dir /workdir --create-home --uid 1000 antares

ADD antares-backend/antares_environment /workdir/antares_environment

ADD populate_data.py /workdir/populate_data.py
ADD entrypoint.sh /workdir/entrypoint.sh

RUN mkdir -p /workdir/antares_environment/antares_bin; \
    mkdir -p /workdir/antares_environment/antares_output; \
    cd /workdir/antares_environment/antares_src; bash make.sh; \
    rm /workdir/antares_environment/antares_data/*;\
    chown -R antares:antares /workdir

USER antares

WORKDIR /workdir

ENV ANTARES_CONFIG_FILE=/antares_data_server/antares_data_server/config_dir/config.yml

ENTRYPOINT [ "/bin/bash", "/workdir/entrypoint.sh" ]
