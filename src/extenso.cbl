       IDENTIFICATION DIVISION.
       PROGRAM-ID. EXTENSO.

       DATA DIVISION.
       WORKING-STORAGE SECTION.
       01  WS-IN-VALOR               PIC X(40)  VALUE SPACES.
       01  WS-OUT-TEXTO              PIC X(256) VALUE SPACES.
       01  WS-OUT-STATUS             PIC X(3)   VALUE SPACES.

       PROCEDURE DIVISION.
           DISPLAY "Digite um valor em R$ (ex.: 1,15 / 27,30 / 1.157,20): "
           ACCEPT WS-IN-VALOR
           MOVE SPACES TO WS-OUT-TEXTO
           MOVE "OK"   TO WS-OUT-STATUS

           CALL "EXT-MOEDA" USING
               WS-IN-VALOR
               WS-OUT-TEXTO
               WS-OUT-STATUS
           END-CALL

           DISPLAY "STATUS: " WS-OUT-STATUS
           DISPLAY "EXTENSO: " FUNCTION TRIM(WS-OUT-TEXTO)
           GOBACK.

