CREATE DATABASE IF NOT EXISTS tre CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci;

USE tre;

CREATE TABLE IF NOT EXISTS funcionario (
  fun_num_matric DECIMAL(5,0) NOT NULL,
  fun_nome_func  VARCHAR(50),
  fun_cd_cargo   DECIMAL(2,0),
  PRIMARY KEY (fun_num_matric)
);

INSERT INTO funcionario (fun_num_matric, fun_nome_func, fun_cd_cargo) VALUES
  (1000, 'Antônio', 2),
  (1100, 'Abadio', 3),
  (1200, 'Antônio', 4);
