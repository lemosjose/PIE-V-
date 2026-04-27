       IDENTIFICATION DIVISION.
       PROGRAM-ID. EXT-TENS.

       DATA DIVISION.
       WORKING-STORAGE SECTION.
       01  WS-TXT                    PIC X(256) VALUE SPACES.
       01  WS-N                      PIC 9(9) COMP-5.
       01  WS-T                      PIC 99    COMP-5.
       01  WS-U                      PIC 9     COMP-5.
       01  WS-AUX                    PIC X(64) VALUE SPACES.
       01  WS-AUX2                   PIC X(64) VALUE SPACES.
       01  WS-EXT-IN.
           05  WS-IN-NUM             PIC 9(9) COMP-5.
       01  WS-EXT-OUT.
           05  WS-OUT-TEXT           PIC X(256).
           05  WS-OUT-STATUS         PIC X(3).

       LINKAGE SECTION.
       COPY "ext_types.cpy".

       PROCEDURE DIVISION USING EXT-IN EXT-OUT.
           MOVE SPACES TO OUT-TEXT
           MOVE "OK"   TO OUT-STATUS

           MOVE IN-NUM TO WS-N
           IF WS-N < 10 OR WS-N > 99
               MOVE "RNG" TO OUT-STATUS
               GOBACK
           END-IF

           IF WS-N >= 10 AND WS-N <= 19
               EVALUATE WS-N
                   WHEN 10 MOVE "DEZ" TO WS-TXT
                   WHEN 11 MOVE "ONZE" TO WS-TXT
                   WHEN 12 MOVE "DOZE" TO WS-TXT
                   WHEN 13 MOVE "TREZE" TO WS-TXT
                   WHEN 14 MOVE "QUATORZE" TO WS-TXT
                   WHEN 15 MOVE "QUINZE" TO WS-TXT
                   WHEN 16 MOVE "DEZESSEIS" TO WS-TXT
                   WHEN 17 MOVE "DEZESSETE" TO WS-TXT
                   WHEN 18 MOVE "DEZOITO" TO WS-TXT
                   WHEN 19 MOVE "DEZENOVE" TO WS-TXT
               END-EVALUATE
               MOVE FUNCTION TRIM(WS-TXT) TO OUT-TEXT
               GOBACK
           END-IF

           COMPUTE WS-T = WS-N / 10
           COMPUTE WS-U = FUNCTION MOD(WS-N, 10)

           MOVE SPACES TO WS-AUX WS-AUX2 WS-TXT
           EVALUATE WS-T
               WHEN 2 MOVE "VINTE" TO WS-AUX
               WHEN 3 MOVE "TRINTA" TO WS-AUX
               WHEN 4 MOVE "QUARENTA" TO WS-AUX
               WHEN 5 MOVE "CINQUENTA" TO WS-AUX
               WHEN 6 MOVE "SESSENTA" TO WS-AUX
               WHEN 7 MOVE "SETENTA" TO WS-AUX
               WHEN 8 MOVE "OITENTA" TO WS-AUX
               WHEN 9 MOVE "NOVENTA" TO WS-AUX
               WHEN OTHER
                   MOVE "ERR" TO OUT-STATUS
           END-EVALUATE

           IF OUT-STATUS NOT = "OK"
               GOBACK
           END-IF

           IF WS-U = 0
               MOVE FUNCTION TRIM(WS-AUX) TO OUT-TEXT
               GOBACK
           END-IF

           MOVE WS-U TO WS-IN-NUM
           MOVE SPACES TO WS-OUT-TEXT
           MOVE "OK"   TO WS-OUT-STATUS
           CALL "EXT-UNITS" USING
               WS-EXT-IN
               WS-EXT-OUT
           END-CALL
           IF WS-OUT-STATUS NOT = "OK"
               MOVE "ERR" TO OUT-STATUS
               GOBACK
           END-IF
           MOVE WS-OUT-TEXT TO WS-AUX2

           STRING
               FUNCTION TRIM(WS-AUX)
               " E "
               FUNCTION TRIM(WS-AUX2)
               INTO WS-TXT
           END-STRING

           MOVE FUNCTION TRIM(WS-TXT) TO OUT-TEXT
           MOVE "OK" TO OUT-STATUS
           GOBACK.

