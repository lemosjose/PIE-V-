	IDENTIFICATION DIVISION.
       PROGRAM-ID. CALC-DIG_CPF.
       AUTHOR. GEISE.dow

       DATA DIVISION.
       WORKING-STORAGE SECTION.
       01  WS-CPF-ENTRADA.
           05 WS-NROS          PIC 9(01) OCCURS 9 TIMES.

       01  WS-VARIAVEIS-AUX.
           05 WS-SOMA           PIC 9(04) VALUE ZEROS.
           05 WS-RESTO          PIC 9(02) VALUE ZEROS.
           05 WS-I              PIC 9(02) VALUE ZEROS.
           05 WS-PESO           PIC 9(02) VALUE ZEROS.
           05 WS-DIGITO-1       PIC 9(01) VALUE ZEROS.
           05 WS-DIGITO-2       PIC 9(01) VALUE ZEROS.

       LINKAGE SECTION.
       01  LK-PARAMETROS.
           05 LK-CPF-9          PIC 9(09).
           05 LK-DIGITOS-RES    PIC 9(02).

       PROCEDURE DIVISION USING LK-PARAMETROS.
              PERFORM 1000-PRIMEIRO-SEGUNDO-DIGITO

              PERFORM 2000-NONO-DECIMO

              PERFORM 3000-RETORNO

              GOBACK.


       1000-PRIMEIRO-SEGUNDO-DIGITO SECTION.
              MOVE LK-CPF-9 TO WS-CPF-ENTRADA.

              *>PRIMEIRO DIGITO ---
              MOVE ZEROS TO WS-SOMA.
              MOVE 10 TO WS-PESO.

              PERFORM VARYING WS-I FROM 1 BY 1 UNTIL WS-I > 9
                     COMPUTE WS-SOMA = WS-SOMA +
                     (WS-NROS(WS-I) * WS-PESO)
                     SUBTRACT 1 FROM WS-PESO
              END-PERFORM.

              COMPUTE WS-RESTO = FUNCTION MOD((WS-SOMA * 10), 11).

              IF WS-RESTO = 10
                     MOVE 0 TO WS-DIGITO-1
              ELSE
                     MOVE WS-RESTO TO WS-DIGITO-1
              END-IF.

       2000-NONO-DECIMO SECTION.

              MOVE ZEROS TO WS-SOMA.
              MOVE 11 TO WS-PESO.

              PERFORM VARYING WS-I FROM 1 BY 1 UNTIL WS-I > 9
                     COMPUTE WS-SOMA = WS-SOMA +
                     (WS-NROS(WS-I) * WS-PESO)
                     SUBTRACT 1 FROM WS-PESO
              END-PERFORM.

              *> Soma o décimo (primeiro dígito calculado)
              COMPUTE WS-SOMA = WS-SOMA + (WS-DIGITO-1 * 2).

              COMPUTE WS-RESTO = FUNCTION MOD((WS-SOMA * 10), 11).

              IF WS-RESTO = 10
                     MOVE 0 TO WS-DIGITO-2
              ELSE
                     MOVE WS-RESTO TO WS-DIGITO-2
              END-IF.
       3000-RETORNO SECTION.
              *> Retorno do resultado via Linkage
              STRING WS-DIGITO-1 WS-DIGITO-2 DELIMITED BY SIZE
                     INTO LK-DIGITOS-RES.
