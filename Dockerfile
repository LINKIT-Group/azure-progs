FROM python:3.8-slim-buster

RUN apt-get update --fix-missing \
    && apt-get -y install --no-install-recommends \
        apt-transport-https \
        bash \
        procps \
        jq \
        curl \
        telnet \
        openssh-client \
        build-essential \
        gosu \
        git \
        unixodbc-dev \
    && python -m pip install \
        requests==2.23.0 \
        numpy==1.19.5 \
        pandas==1.2.1 \
        pylint==2.6.0 \
        pre-commit==2.7.1 \
        pyodbc==4.0.32
    
# Azure CLI
RUN curl -sL https://aka.ms/InstallAzureCLIDeb | bash

# Microsoft ODBC driver
RUN curl https://packages.microsoft.com/keys/microsoft.asc | apt-key add -
RUN curl https://packages.microsoft.com/config/debian/10/prod.list > /etc/apt/sources.list.d/mssql-release.list
RUN apt-get update \
    && ACCEPT_EULA=Y apt-get install msodbcsql17 --assume-yes

COPY files/entrypoint.sh .
COPY files/bash_prompt.sh /etc/profile.d/
COPY files/profile /etc/profile

# temp - delete this group as it also has gid 20 which conflicts on mac
# note -- this is likely different on other system, should be fixed more elegantly
RUN groupdel dialout
WORKDIR /app
CMD ["/bin/sh", "/entrypoint.sh" ]