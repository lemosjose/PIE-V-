FROM ubuntu:22.04

ENV DEBIAN_FRONTEND=noninteractive

RUN apt-get update && \
    apt-get install -y --no-install-recommends \
      gnucobol \
      build-essential \
      locales \
      unixodbc \
      unixodbc-dev \
      odbc-mariadb \
      mariadb-client \
      ca-certificates && \
    sed -i 's/^# *\\(pt_BR.UTF-8\\)/\\1/' /etc/locale.gen && \
    locale-gen && \
    rm -rf /var/lib/apt/lists/*

ENV LANG=pt_BR.UTF-8
ENV LC_ALL=pt_BR.UTF-8

WORKDIR /cobol/src

CMD ["sleep", "infinity"]
