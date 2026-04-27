       IDENTIFICATION DIVISION.
       PROGRAM-ID. EXT-HUNDREDS.

       DATA DIVISION.
       WORKING-STORAGE SECTION.
       01  WS-N                      PIC 9(9) COMP-5.
       01  WS-C                      PIC 9     COMP-5.
       01  WS-R                      PIC 99    COMP-5.
       01  WS-TXT                    PIC X(256) VALUE SPACES.
       01  WS-AUX                    PIC X(128) VALUE SPACES.
       01  WS-AUX2                   PIC X(128) VALUE SPACES.
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
           IF WS-N < 0 OR WS-N > 999
               MOVE "RNG" TO OUT-STATUS
               GOBACK
           END-IF

           IF WS-N < 100
               MOVE WS-N TO WS-IN-NUM
               MOVE SPACES TO WS-OUT-TEXT
               MOVE "OK"   TO WS-OUT-STATUS
               IF WS-N < 10
                   CALL "EXT-UNITS" USING WS-EXT-IN WS-EXT-OUT END-CALL
               ELSE
                   CALL "EXT-TENS" USING WS-EXT-IN WS-EXT-OUT END-CALL
               END-IF
               IF WS-OUT-STATUS = "OK"
                   MOVE FUNCTION TRIM(WS-OUT-TEXT) TO OUT-TEXT
               ELSE
                   MOVE "ERR" TO OUT-STATUS
               END-IF
               GOBACK
           END-IF

           COMPUTE WS-C = WS-N / 100
           COMPUTE WS-R = FUNCTION MOD(WS-N, 100)

           IF WS-N = 100
               MOVE "CEM" TO OUT-TEXT
               GOBACK
           END-IF

           MOVE SPACES TO WS-AUX WS-AUX2 WS-TXT
           EVALUATE WS-C
               WHEN 1 MOVE "CENTO" TO WS-AUX
               WHEN 2 MOVE "DUZENTOS" TO WS-AUX
               WHEN 3 MOVE "TREZENTOS" TO WS-AUX
               WHEN 4 MOVE "QUATROCENTOS" TO WS-AUX
               WHEN 5 MOVE "QUINHENTOS" TO WS-AUX
               WHEN 6 MOVE "SEISCENTOS" TO WS-AUX
               WHEN 7 MOVE "SETECENTOS" TO WS-AUX
               WHEN 8 MOVE "OITOCENTOS" TO WS-AUX
               WHEN 9 MOVE "NOVECENTOS" TO WS-AUX
               WHEN OTHER
                   MOVE "ERR" TO OUT-STATUS
           END-EVALUATE

           IF OUT-STATUS NOT = "OK"
               GOBACK
           END-IF

           IF WS-R = 0
               MOVE FUNCTION TRIM(WS-AUX) TO OUT-TEXT
               GOBACK
           END-IF

           MOVE WS-R TO WS-IN-NUM
           MOVE SPACES TO WS-OUT-TEXT
           MOVE "OK"   TO WS-OUT-STATUS
           IF WS-R < 10
               CALL "EXT-UNITS" USING WS-EXT-IN WS-EXT-OUT END-CALL
           ELSE
               CALL "EXT-TENS" USING WS-EXT-IN WS-EXT-OUT END-CALL
           END-IF
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

