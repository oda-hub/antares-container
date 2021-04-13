FROM centos:8

RUN yum -y install epel-release && yum -y install root
ADD antares-backend/antares_data_server_wd /antares_data_server

RUN pip3 install -r /antares_data_server/requirements.txt && \
    pip3 install /antares_data_server

ADD antares-backend/antares_environment /workdir/antares_environment

RUN mkdir -p /workdir/antares_environment/antares_bin; mkdir -p /workdir/antares_environment/antares_output; cd /workdir/antares_environment/antares_src; bash make.sh

WORKDIR /workdir/antares_environment

ENV ANTARES_CONFIG_FILE=/antares_data_server/antares_data_server/config_dir/config.yml

ADD entrypoint.sh /antares/entrypoint.sh
ENTRYPOINT [ "/bin/bash", "/antares/entrypoint.sh" ]
