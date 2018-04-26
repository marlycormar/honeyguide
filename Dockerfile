# NOTE this image is not meant to be run on it's own. Please use docker-compose
FROM python:3-stretch

ARG CAPPY_CLONE_URL
ARG QUAIL_CLONE_URL

RUN apt-get update
RUN yes | apt-get install vim pwgen sqlite3 cron

RUN useradd icare

WORKDIR /home/icare
RUN chown -R icare /home/icare

RUN git clone $CAPPY_CLONE_URL
RUN git clone $QUAIL_CLONE_URL

RUN pip3 install -e ./cappy
RUN pip3 install -e ./QUAIL

ENV TZ=America/New_York
RUN ln -snf /usr/share/zoneinfo/$TZ /etc/localtime && echo $TZ > /etc/timezone

# remember the hour ranges from 0-23 hours
ARG MINUTE
ARG HOUR
RUN printf "%s %s * * * bash /home/icare/quail_user_script.sh > /proc/1/fd/1 2> /proc/1/fd/2\n" $MINUTE $HOUR \
    | crontab

USER icare

RUN quail install quailroot

COPY --chown=icare:icare quail_user_script.sh quail_run_script.sh fix_quail_unique_field.sql sqlite_to_mysql.py create_and_populate_table.py ./

RUN /home/icare/quail_run_script.sh

USER root

CMD "cron" "-f"
