# Extenso — Valor monetário por extenso em COBOL

Programa em COBOL que converte um valor monetário em reais (R$) para sua representação por extenso em português.

## Pré-requisitos

- [Docker](https://docs.docker.com/get-docker/) instalado na máquina.

## Como executar

### 1. Construir a imagem Docker

No diretório raiz do projeto (onde está o `Dockerfile`), execute:

```bash
docker build -t cobol-app .
```

### 2. Executar o programa

```bash
docker run -it --rm cobol-app
```

> **Nota:** A flag `-it` é obrigatória pois o programa solicita entrada do usuário pelo terminal.
> A flag `--rm` remove o container automaticamente após a execução.

### 3. Usar o programa

O programa solicitará um valor em reais. Digite o valor usando `.` como separador de milhar e `,` como separador decimal:

```
Digite um valor em R$ (ex.: 1,15 / 27,30 / 1.157,20):
```

## Exemplo de saída

```
Digite um valor em R$ (ex.: 1,15 / 27,30 / 1.157,20): 
1,19
STATUS: OK 
EXTENSO: UM REAL E DEZENOVE CENTAVOS
```

## Estrutura do projeto

```
extenso/
├── Dockerfile          # Ambiente com GnuCOBOL (Ubuntu 22.04)
├── README.md
└── src/
    ├── extenso.cbl             # Programa principal
    ├── ext_moeda.cbl           # Conversão de valor monetário (reais + centavos)
    ├── ext_num.cbl             # Roteador por faixa numérica
    ├── ext_units.cbl           # Unidades (0–9)
    ├── ext_tens.cbl            # Dezenas (10–99)
    ├── ext_hundreds.cbl        # Centenas (100–999)
    ├── ext_thousands.cbl       # Milhares (1.000–9.999)
    ├── ext_hundred_thousands.cbl  # Dezenas/centenas de milhar (10.000–999.999)
    ├── ext_millions.cbl        # Milhões (1.000.000–999.999.999)
    └── ext_types.cpy           # Copybook com tipos compartilhados
```
