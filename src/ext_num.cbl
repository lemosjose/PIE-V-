       IDENTIFICATION DIVISION.
       PROGRAM-ID. EXT-NUM.

       DATA DIVISION.
       WORKING-STORAGE SECTION.
       01  WS-N                      PIC 9(9) COMP-5.

       LINKAGE SECTION.
       COPY "ext_types.cpy".

       PROCEDURE DIVISION USING EXT-IN EXT-OUT.
           MOVE SPACES TO OUT-TEXT
           MOVE "OK"   TO OUT-STATUS

           MOVE IN-NUM TO WS-N
           IF WS-N < 0 OR WS-N > 999999999
               MOVE "RNG" TO OUT-STATUS
               GOBACK
           END-IF

           IF WS-N = 0
               CALL "EXT-UNITS" USING EXT-IN EXT-OUT END-CALL
               GOBACK
           END-IF

           IF WS-N < 10
               CALL "EXT-UNITS" USING EXT-IN EXT-OUT END-CALL
           ELSE
               IF WS-N < 100
                   CALL "EXT-TENS" USING EXT-IN EXT-OUT END-CALL
               ELSE
                   IF WS-N < 1000
                       CALL "EXT-HUNDREDS" USING EXT-IN EXT-OUT END-CALL
                   ELSE
                       IF WS-N < 10000
                           CALL "EXT-THOUSANDS" USING EXT-IN EXT-OUT END-CALL
                       ELSE
                           IF WS-N < 1000000
                               CALL "EXT-HUNDRED-THOUSANDS"
                                   USING EXT-IN EXT-OUT
                               END-CALL
                           ELSE
                               CALL "EXT-MILLIONS"
                                   USING EXT-IN EXT-OUT
                               END-CALL
                           END-IF
                       END-IF
                   END-IF
               END-IF
           END-IF

           GOBACK.

