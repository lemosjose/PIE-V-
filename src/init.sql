-- ================================================================
-- Inicializacao do banco de dados TESTDB
-- Criacao do schema TRE, tabela FUNCIONARIO e dados
-- ================================================================

connect to testdb;

CREATE SCHEMA TRE;

CREATE TABLE TRE.FUNCIONARIO (
    FUN_NUM_MATRIC  NUMERIC(5)    NOT NULL,
    FUN_NOME_FUNC   VARCHAR(50),
    FUN_CD_CARGO    NUMERIC(2),
    PRIMARY KEY (FUN_NUM_MATRIC)
);

INSERT INTO TRE.FUNCIONARIO (FUN_NUM_MATRIC, FUN_NOME_FUNC, FUN_CD_CARGO)
    VALUES (1000, 'Antônio', 2);
INSERT INTO TRE.FUNCIONARIO (FUN_NUM_MATRIC, FUN_NOME_FUNC, FUN_CD_CARGO)
    VALUES (1100, 'Abadio', 3);
INSERT INTO TRE.FUNCIONARIO (FUN_NUM_MATRIC, FUN_NOME_FUNC, FUN_CD_CARGO)
    VALUES (1200, 'Antônio', 4);
