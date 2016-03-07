FROM ubuntu:15.10

MAINTAINER Vitaly Lobchuk <vn.lobchuk@gmail.com>

RUN apt-get update && apt-get install -y --no-install-recommends --fix-missing openjdk-7-jre-headless wget supervisor

RUN mkdir -p /var/log/supervisor
COPY ./supervisord.conf /etc/supervisor/conf.d/supervisord.conf

ENV YOUTRACK_HOMEDIR /usr/local/youtrack
ENV YOUTRACK_RUN_SCRIPT $YOUTRACK_HOMEDIR/youtrack.sh

RUN adduser youtrack --disabled-password
RUN mkdir -p $YOUTRACK_HOMEDIR
RUN chown youtrack.youtrack $YOUTRACK_HOMEDIR

COPY ./youtrack_run.sh $YOUTRACK_RUN_SCRIPT

RUN chmod +x $YOUTRACK_RUN_SCRIPT

# Download YouTrack
ENV YOUTRACK_DOWNLOAD http://download.jetbrains.com/charisma/youtrack-6.5.17031.jar
RUN cd $YOUTRACK_HOMEDIR && wget $YOUTRACK_DOWNLOAD

EXPOSE 8112

CMD ["/usr/bin/supervisord"]