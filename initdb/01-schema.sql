-- Schema for UFIBGE database (created automatically by MARIADB_DATABASE env var)

USE UFIBGE;

CREATE TABLE IF NOT EXISTS Cidade (
    CodCidade  INT          NOT NULL,
    NomeCidade VARCHAR(35)  NOT NULL,
    UF         CHAR(2),
    PRIMARY KEY (CodCidade)
) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci;
