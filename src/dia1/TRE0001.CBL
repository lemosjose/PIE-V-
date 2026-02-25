      SOURCE FORMAT IS FREE.
      IDENTIFICATION DIVISION.
      PROGRAM-ID. TRE0001.

      ENVIRONMENT DIVISION. 

      CONFIGURATION SECTION.
       OBJECT-COMPUTER. LAB-06.
      SPECIAL-NAMES.
           DECIMAL-POINT IS COMMA.

      INPUT-OUTPUT SECTION.
      FILE-CONTROL.

           SELECT ITREF001
                  ASSIGN ITREF001
                  FILE STATUS AS-STATUS-F001.
      DATA DIVISION.
      
      FILE SECTION.

      FD   ITREF001.
           RECORD 45. 
      
      01   REG-ITREF001.
           03  F001-MATRICULA    PIC 9(005).
           03  F001-NOME         PIC X(040).
       WORKING-STORAGE SECTION.

      * variavel pode ter no maximo 30 caracteres, a-z, 0-9 e -
      * minimo uma letra, obrigatoriamente começa com uma letra
       01 AREAS-DE-SALVAMENTO. 
           05 AS-DATA            PIC 9(008)         VALUE ZEROS.
           05 AS-STATUS-F001     PIC 9(002)         VALUE ZEROS.
           05 AS-VALOR-1         PIC S9(005)V9(002) VALUE ZEROS.
           05 AS-VALOR-2         PIC S9(005)V99     VALUE ZEROS.
           05 AS-RESULTADO       PIC S9(005)V99     VALUE ZEROS.   
           05 AS-RESULTADO-EDIT  PIC --.---.---.-9,99.

      LINKAGE SECTION.

      PROCEDURE DIVISION. 
           COMPUTE AS-RESULTADO = (AS-VALOR-1 / AS-VALOR-2) +
                                         (10*15) ** 3
           
           DISPLAY 'RESULTADO'  AS-RESULTADO

           GOBACK.
