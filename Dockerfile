FROM bitnami/tomcat:9.0.33

LABEL MAINTAINER="Alex Sorkin alexander.sorkin@gmail.com"

ARG WEBAPP_URL=https://tomcat.apache.org/tomcat-7.0-doc/appdev/sample/sample.war
ARG WEBAPP_NAME=botika

USER root
RUN \
    apt-get install -y curl gzip && \
    rm -r /var/lib/apt/lists /var/cache/apt/archives

RUN \
    export TINI_VERSION=`curl -s https://github.com/krallin/tini/releases/latest|grep -Eo "[[:digit:]]{1,2}"|xargs|sed 's/\ /./g'` && \
    echo "Tini Supervisor Version: ${TINI_VERSION}" && \
    curl -o /bin/tini -fsSL https://github.com/krallin/tini/releases/download/v${TINI_VERSION}/tini-static-amd64 && \
    chmod +x /bin/tini

RUN \
    curl -o /opt/bitnami/tomcat/webapps_default/botika.war -sSL ${WEBAPP_URL} 2>&1

#COPY assembly/* /opt/bitnami/tomcat/webapps_default

EXPOSE 8080

USER 1001
ENTRYPOINT [ "/bin/tini", "--", "/opt/bitnami/scripts/tomcat/entrypoint.sh" ]
CMD [ "/opt/bitnami/scripts/tomcat/run.sh" ]
