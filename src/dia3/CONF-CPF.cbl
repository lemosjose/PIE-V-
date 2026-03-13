	   IDENTIFICATION DIVISION.
       PROGRAM-ID. CONF-CPF.
       AUTHOR. GEISE.

       DATA DIVISION.
       WORKING-STORAGE SECTION.
       *> Variáveis para comunicação com a sub-rotina
       01  WS-CPF-BASE          PIC 9(09).
       01  WS-DV-RESULTADO      PIC 9(02).

       *> Variável para exibição formatada
       01  WS-CPF-FORMATADO.
           05 FILLER            PIC X(05) VALUE "CPF: ".
           05 PARTE-1           PIC 9(03).
           05 FILLER            PIC X(01) VALUE ".".
           05 PARTE-2           PIC 9(03).
           05 FILLER            PIC X(01) VALUE ".".
           05 PARTE-3           PIC 9(03).
           05 FILLER            PIC X(01) VALUE "-".
           05 DV-FINAL          PIC 9(02).

       PROCEDURE DIVISION.

       PERFORM 000-DISPLAY.
           DISPLAY "------------------------------------------".
           DISPLAY "   MOSTRA OS DIGITOS VERIFICADORES CPF   ".
           DISPLAY "------------------------------------------".

           DISPLAY "DIGITE OS 9 PRIMEIROS NUMEROS DO CPF: "
           ACCEPT WS-CPF-BASE.

           *> Chamada da sub-rotina (o programa que fizemos antes)
           CALL "CALC-DIG_CPF" USING WS-CPF-BASE WS-DV-RESULTADO.

           *> Preparando a máscara de saída para ficar bonito
           MOVE WS-CPF-BASE(1:3) TO PARTE-1.
           MOVE WS-CPF-BASE(4:3) TO PARTE-2.
           MOVE WS-CPF-BASE(7:3) TO PARTE-3.
           MOVE WS-DV-RESULTADO  TO DV-FINAL.

           DISPLAY " ".
           DISPLAY "RESULTADO FINAL:".
           DISPLAY WS-CPF-FORMATADO.
           DISPLAY "------------------------------------------".

           STOP RUN.

       000-DISPLAY SECTION.
              DISPLAY "------------------------------------------".
              DISPLAY "   MOSTRA OS DIGITOS VERIFICADORES CPF   ".
              DISPLAY "------------------------------------------".

              DISPLAY "DIGITE OS 9 PRIMEIROS NUMEROS DO CPF: "
              ACCEPT WS-CPF-BASE.

              *> Chamada da sub-rotina (o programa que fizemos antes)
              CALL "CALC-DIG_CPF" USING WS-CPF-BASE WS-DV-RESULTADO.

              *> Preparando a máscara de saída para ficar bonito
              MOVE WS-CPF-BASE(1:3) TO PARTE-1.
              MOVE WS-CPF-BASE(4:3) TO PARTE-2.
              MOVE WS-CPF-BASE(7:3) TO PARTE-3.
              MOVE WS-DV-RESULTADO  TO DV-FINAL.

              DISPLAY " ".
              DISPLAY "RESULTADO FINAL:".
              DISPLAY WS-CPF-FORMATADO.
              DISPLAY "------------------------------------------".

              STOP RUN.
