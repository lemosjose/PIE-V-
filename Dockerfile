# ================================================================
# Dockerfile - Container de compilacao COBOL (Ubuntu + GnuCOBOL)
#
# Separado do DB2 que roda na imagem oficial (RHEL UBI 8).
# O codigo fonte e montado via volume compartilhado.
# ================================================================
FROM ubuntu:22.04

ENV DEBIAN_FRONTEND=noninteractive

RUN apt-get update && \
    apt-get install -y gnucobol && \
    rm -rf /var/lib/apt/lists/*

WORKDIR /cobol/src

CMD ["sleep", "infinity"]
