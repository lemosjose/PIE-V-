#!/bin/bash
# ================================================================
# Inicializacao do banco de dados
# Cria o schema TRE, tabela FUNCIONARIO e popula com dados
#
# Uso: su - db2inst1 -c "/cobol/scripts/init-db.sh"
# ================================================================
set -e

echo "========================================"
echo "  Inicializando banco de dados TESTDB"
echo "========================================"

db2 connect to testdb

echo ">> Executando script de inicializacao..."
db2 -tvf /cobol/src/init.sql

db2 connect reset

echo ""
echo ">> Banco de dados inicializado com sucesso!"
echo "========================================"
