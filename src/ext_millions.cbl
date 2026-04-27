       IDENTIFICATION DIVISION.
       PROGRAM-ID. EXT-MILLIONS.

       DATA DIVISION.
       WORKING-STORAGE SECTION.
       01  WS-N                      PIC 9(9) COMP-5.
       01  WS-M                      PIC 999   COMP-5.
       01  WS-R                      PIC 9(6)  COMP-5.
       01  WS-TXT                    PIC X(256) VALUE SPACES.
       01  WS-AUX                    PIC X(160) VALUE SPACES.
       01  WS-AUX2                   PIC X(160) VALUE SPACES.
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
           IF WS-N < 1000000 OR WS-N > 999999999
               MOVE "RNG" TO OUT-STATUS
               GOBACK
           END-IF

           COMPUTE WS-M = WS-N / 1000000
           COMPUTE WS-R = FUNCTION MOD(WS-N, 1000000)

           MOVE WS-M TO WS-IN-NUM
           MOVE SPACES TO WS-OUT-TEXT
           MOVE "OK"   TO WS-OUT-STATUS
           CALL "EXT-HUNDREDS" USING WS-EXT-IN WS-EXT-OUT END-CALL
           IF WS-OUT-STATUS NOT = "OK"
               MOVE "ERR" TO OUT-STATUS
               GOBACK
           END-IF

           IF WS-M = 1
               STRING
                   FUNCTION TRIM(WS-OUT-TEXT)
                   " MILHÃO"
                   INTO WS-AUX
               END-STRING
           ELSE
               STRING
                   FUNCTION TRIM(WS-OUT-TEXT)
                   " MILHÕES"
                   INTO WS-AUX
               END-STRING
           END-IF

           IF WS-R = 0
               MOVE FUNCTION TRIM(WS-AUX) TO OUT-TEXT
               GOBACK
           END-IF

           MOVE WS-R TO WS-IN-NUM
           MOVE SPACES TO WS-OUT-TEXT
           MOVE "OK"   TO WS-OUT-STATUS

           IF WS-R >= 100000
               CALL "EXT-HUNDRED-THOUSANDS" USING WS-EXT-IN WS-EXT-OUT END-CALL
           ELSE
               IF WS-R >= 1000
                   CALL "EXT-THOUSANDS" USING WS-EXT-IN WS-EXT-OUT END-CALL
               ELSE
                   CALL "EXT-HUNDREDS" USING WS-EXT-IN WS-EXT-OUT END-CALL
               END-IF
           END-IF

           IF WS-OUT-STATUS NOT = "OK"
               MOVE "ERR" TO OUT-STATUS
               GOBACK
           END-IF
           MOVE WS-OUT-TEXT TO WS-AUX2

           MOVE SPACES TO WS-TXT
           IF WS-R < 100
               STRING
                   FUNCTION TRIM(WS-AUX)
                   " E "
                   FUNCTION TRIM(WS-AUX2)
                   INTO WS-TXT
               END-STRING
           ELSE
               STRING
                   FUNCTION TRIM(WS-AUX)
                   " "
                   FUNCTION TRIM(WS-AUX2)
                   INTO WS-TXT
               END-STRING
           END-IF

           MOVE FUNCTION TRIM(WS-TXT) TO OUT-TEXT
           MOVE "OK" TO OUT-STATUS
           GOBACK.

