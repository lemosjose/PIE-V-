# MariaDB + COBOL (GnuCOBOL) via ODBC

Esta pasta contém o serviço de banco **MariaDB** e um container para **build/execução COBOL** com **unixODBC + driver ODBC do MariaDB**, para que o seu processo COBOL consiga se conectar ao MariaDB.

## Como executar

A partir da raiz do repositório:

```bash
cd mariadb/mysql
docker compose up -d --build
```

Se você usa Podman:

```bash
cd mariadb/mysql
podman-compose up -d --build
```

O MariaDB ficará disponível em `localhost:${MARIADB_PORT:-3306}` e é inicializado automaticamente a partir de `initdb/01-init.sql`.

## Compilar e executar o exemplo COBOL

Este exemplo conecta no MariaDB via ODBC e executa um `SELECT` em `tre.funcionario`.

### Docker

```bash
cd mariadb/mysql
docker compose exec cobol cobc -x -o TRE0028_ODBC TRE0028_ODBC.cbl -lodbc
docker compose exec cobol ./TRE0028_ODBC
```

Se aparecer o erro `libcob: error: module 'SQLAllocHandle' not found`, suba o stack novamente (ou recrie o container) para aplicar a variável `COB_PRE_LOAD` do `docker-compose.yaml`:

```bash
cd mariadb/mysql
docker compose down
docker compose up -d --build
```

Se aparecer `Falha ao conectar via ODBC`, confirme o nome do driver instalado dentro do container:

```bash
docker compose exec cobol odbcinst -q -d
```

E então rode informando o nome correto:

```bash
ODBC_DRIVER="MariaDB Unicode" docker compose exec cobol ./TRE0028_ODBC
```

Obs.: o programa imprime `SQLSTATE`/mensagem do driver quando a conexão falha.

### Podman

Se você subiu os containers com `sudo podman-compose up`, então execute também com `sudo` nos comandos abaixo.

```bash
cd mariadb/mysql
sudo podman-compose exec cobol cobc -x -o TRE0028_ODBC TRE0028_ODBC.cbl -lodbc
sudo podman-compose exec cobol ./TRE0028_ODBC
```

## Configurações de conexão (container COBOL)

O serviço `cobol` passa estas variáveis de ambiente para o programa:

- `MARIADB_HOST` (padrão `mariadb`)
- `MARIADB_PORT` (padrão `3306`)
- `MARIADB_DATABASE` (padrão `tre`)
- `MARIADB_USER` (padrão `tre`)
- `MARIADB_PASSWORD` (padrão `trepass`)

O nome do driver ODBC pode ser sobrescrito com:

- `ODBC_DRIVER` (padrão `MariaDB Unicode`)

Se você não tiver certeza do nome do driver dentro do container, rode:

```bash
docker compose exec cobol odbcinst -q -d
```

