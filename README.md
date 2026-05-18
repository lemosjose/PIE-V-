# COBOL + MariaDB via ODBC — Relatório de Cidades por UF

Programa GnuCOBOL que conecta ao **MariaDB** via **unixODBC** e gera um relatório com a quantidade de cidades por UF (dados do IBGE, 5570 municípios).

## Estrutura do Projeto

```
mariadb/
├── docker-compose.yaml      # MariaDB + container COBOL
├── Dockerfile               # Imagem COBOL (GnuCOBOL + unixODBC)
├── .env.example             # Variáveis de ambiente
├── initdb/                  # Scripts executados no primeiro start do MariaDB
│   ├── 01-schema.sql        #   Cria tabela Cidade
│   └── 02-cidades-data.sql  #   Insere 5570 municípios
├── src/                     # Fontes COBOL
│   ├── CIDADES_UF.cbl       #   Relatório de cidades por UF (grade 9x3)
│   └── TRE0028_ODBC.cbl     #   Exemplo anterior (tabela funcionario)
└── specs/                   # Material de referência
    └── Cap11_Cobol_Db2.pdf
```

## Pré-requisitos

- **Podman** com `podman-compose` (ou Docker)

## Como Usar

### 1. Configurar ambiente

```bash
cp .env.example .env
```

### 2. Subir os containers

```bash
sudo podman-compose up -d --build
```

> Na primeira execução, o MariaDB importa ~5600 registros automaticamente via `initdb/`.
> Acompanhe o progresso com:
> ```bash
> sudo podman-compose logs -f mariadb
> ```
> Aguarde até ver que o MariaDB está aceitando conexões.

### 3. Compilar o programa COBOL

```bash
sudo podman-compose exec cobol cobc -x -o CIDADES_UF CIDADES_UF.cbl -lodbc
```

### 4. Executar

```bash
sudo podman-compose exec cobol ./CIDADES_UF
```

### Saída esperada

```
Relatorio de Cidades por UF (IBGE)

-----------------------------------------------------------------
| AC   | AL   | AP   | AM   | BA   | CE   | DF   | ES   | GO   |
|   22 |  102 |   16 |   62 |  417 |  184 |    1 |   78 |  246 |
-----------------------------------------------------------------
| MA   | MT   | MS   | MG   | PA   | PB   | PR   | PE   | PI   |
|  217 |  141 |   79 |  853 |  144 |  223 |  399 |  185 |  224 |
-----------------------------------------------------------------
| RJ   | RN   | RS   | RO   | RR   | SC   | SP   | SE   | TO   |
|   92 |  167 |  497 |   52 |   15 |  295 |  645 |   75 |  139 |
-----------------------------------------------------------------
```

## Parar / Remover

```bash
sudo podman-compose down          # para os containers
sudo podman-compose down -v       # para e remove o volume (dados do MariaDB)
```

## Recompilar após alterar o fonte

```bash
sudo podman-compose exec cobol cobc -x -o CIDADES_UF CIDADES_UF.cbl -lodbc
sudo podman-compose exec cobol ./CIDADES_UF
```

## Fluxo de compilação (ODBC, sem `prep`)

```
CIDADES_UF.cbl ──(cobc -x -lodbc)──► CIDADES_UF (executável)
       │
       │ COBOL puro com CALLs à API ODBC:
       │ SQLAllocHandle, SQLDriverConnect,
       │ SQLExecDirect, SQLFetch, etc.
```

O GnuCOBOL **não tem SQL embarcado nativo**. A abordagem usada é chamar
as funções da API ODBC diretamente via `CALL` no COBOL. Não é necessário
pré-compilador (`prep`, `OCESQL`, etc.).

## Referências

- [GnuCOBOL](https://gnucobol.sourceforge.io/)
- [unixODBC](http://www.unixodbc.org/)
- [MariaDB ODBC Connector](https://mariadb.com/kb/en/mariadb-connector-odbc/)
- Cap. 11 — *Linguagem de Programação COBOL para Mainframe* (Jaime Wojciechowski)
