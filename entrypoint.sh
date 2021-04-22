export PYTHONUNBUFFERED=TRUE

export XDG_CACHE_HOME=/tmp/xdg_cache_home
mkdir -pv $XDG_CACHE_HOME/astropy

ls -tlroa /var/log/containers/

python populate_data.py -conf_file $ANTARES_CONFIG_FILE || exit 1

run_antares_back_end.py \
        -conf_file $ANTARES_CONFIG_FILE \
        -debug \
        -use_gunicorn 2>&1 | tee -a /var/log/containers/${CONTAINER_NAME:-`hostname`}