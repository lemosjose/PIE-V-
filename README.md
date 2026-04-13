# TRE0028 — COBOL com DB2 (Exemplo de Cursor)

Programa COBOL com SQL embarcado (embedded SQL) que utiliza um **cursor** para consultar a tabela `TRE.FUNCIONARIO`, filtrando por código de cargo e exibindo matrícula e nome dos funcionários.

Baseado no **Capítulo 11 — Acesso ao Banco de Dados** do livro *Linguagem de Programação COBOL para Mainframe* (Jaime Wojciechowski).

## Pré-requisitos

- **Podman** (ou Docker) + **podman-compose** (ou docker-compose)
- ~2 GB de espaço em disco (imagem DB2 Community Edition)

## Como Usar

### 1. Configurar ambiente

```bash
cp env.example .env
```

### 2. Subir os containers

```bash
podman-compose up -d
```

> ⏳ Na primeira execução, o DB2 pode levar **2-3 minutos** para inicializar.
> Acompanhe com: `podman-compose logs -f db2`
> Aguarde a mensagem **"Setup has completed"**.

### 3. Inicializar o banco de dados

```bash
podman-compose exec db2 su - db2inst1 -c "/cobol/scripts/init-db.sh"
```

Isso cria o schema `TRE`, a tabela `FUNCIONARIO` e insere os dados de exemplo.

### 4. Pré-compilar o programa (PREP)

```bash
podman-compose exec db2 su - db2inst1 -c "/cobol/scripts/compile-and-run.sh"
```

O PREP da IBM converte o `.sqc` em `.cbl`, substituindo:

- `EXEC SQL INCLUDE SQLCA` → `COPY sqlca.cpy`
- `EXEC SQL INCLUDE TREDFUN` → `COPY TREDFUN`
- `EXEC SQL ... END-EXEC` → chamadas (CALL) ao runtime DB2

### 5. Compilar com GnuCOBOL

```bash
podman-compose exec cobol cobc -x TRE0028.cbl
```

---

## Fluxo de Compilação

```
TRE0028.sqc  ──(prep)──►  TRE0028.cbl  ──(cobc -x)──►  TRE0028 (executável)
     │                         │
     │ SQL embarcado           │ COBOL puro + CALLs DB2
     │ EXEC SQL...END-EXEC     │ COPY sqlca.cpy
     │ INCLUDE SQLCA           │ COPY TREDFUN
```

---

## Dados da Tabela

```sql
CREATE TABLE FUNCIONARIO (
    FUN_NUM_MATRIC  NUMERIC(5) NOT NULL,
    FUN_NOME_FUNC   VARCHAR(50),
    FUN_CD_CARGO    NUMERIC(2),
    PRIMARY KEY (FUN_NUM_MATRIC)
);
```

| FUN_NUM_MATRIC | FUN_NOME_FUNC | FUN_CD_CARGO |
|----------------|---------------|--------------|
| 1000           | Antônio       | 2            |
| 1100           | Abadio        | 3            |
| 1200           | Antônio       | 4            |

---

## Limitações Conhecidas

### 1. `cobc -x` pode falhar sem bibliotecas DB2

O arquivo `.cbl` gerado pelo `db2 prep` contém chamadas (`CALL`) a funções do runtime DB2 (ex: `SQLGSTRT`, `SQLGCALL`). A compilação com `cobc -x` precisa **linkar** contra `libdb2.so`, que só existe dentro do container DB2.

O container `cobol` (Ubuntu + GnuCOBOL) **não possui** essas bibliotecas. Possíveis soluções:

- Compilar GnuCOBOL **dentro do container DB2** (compilação from source, pois o DB2 usa RHEL UBI 8 e o pacote EPEL tem conflitos de dependência com `libjson-c`)
- Instalar o **IBM Data Server Driver** no container COBOL (requer download manual da IBM)
- Copiar `libdb2.so` do container DB2 para o container COBOL e adicionar ao `LD_LIBRARY_PATH`

### 3. Imagem DB2 é pesada (~2 GB)

A imagem `icr.io/db2_community/db2` é baseada em **Red Hat UBI 8** e pesa cerca de 2 GB. O primeiro `podman-compose up` pode demorar significativamente dependendo da conexão.

### 4. Container DB2 requer modo privilegiado

O DB2 necessita de `privileged: true` no container para funcionar corretamente. Isso é uma exigência da imagem oficial da IBM.

### 5. `prep` é específico do DB2

O comando `prep` (pré-compilador de SQL embarcado) é uma ferramenta proprietária da IBM, disponível apenas dentro do container DB2. Não existe um equivalente open-source exato. Alternativas como **OCESQL** (Open COBOL ESQL) existem, mas usam ODBC ao invés do protocolo nativo DB2.

---

## Referências

- [IBM DB2 Community Edition (Docker)](https://www.ibm.com/docs/en/db2/11.5?topic=system-db2-community-edition-docker)
- [GnuCOBOL](https://gnucobol.sourceforge.io/)
- Cap. 11 — *Linguagem de Programação COBOL para Mainframe* (Jaime Wojciechowski)
