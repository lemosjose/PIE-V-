#!/bin/bash
# ================================================================
# Compilacao e execucao do programa COBOL-DB2 TRE0028
#
# Fluxo (dois containers):
#   1. prep  -> roda no container db2  (tem o precompilador)
#   2. cobc  -> roda no container cobol (tem o GnuCOBOL)
#
# Uso (de fora dos containers):
#   podman-compose exec db2 su - db2inst1 -c "/cobol/scripts/compile-and-run.sh"
# ================================================================
set -e

echo "========================================"
echo "  COBOL-DB2: Compilacao do TRE0028"
echo "========================================"

cd /cobol/src

# Conecta ao banco
echo ">> Conectando ao TESTDB..."
db2 connect to testdb

# Passo 1: Pre-compilacao (PREP da IBM)
# Gera TRE0028.cbl (INCLUDE -> COPY, EXEC SQL -> CALLs DB2)
echo ">> Passo 1: prep TRE0028.sqc"
db2 prep TRE0028.sqc bindfile

echo ""
echo ">> .cbl gerado com sucesso!"
echo ">> Para compilar, execute no container cobol:"
echo ">>   podman-compose exec cobol cobc -x TRE0028.cbl"
echo "========================================"

db2 connect reset
