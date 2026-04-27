       IDENTIFICATION DIVISION.
       PROGRAM-ID. EXT-UNITS.

       DATA DIVISION.
       WORKING-STORAGE SECTION.
       01  WS-TXT                    PIC X(256) VALUE SPACES.

       LINKAGE SECTION.
       COPY "ext_types.cpy".

       PROCEDURE DIVISION USING EXT-IN EXT-OUT.
           MOVE SPACES TO OUT-TEXT
           MOVE "OK"   TO OUT-STATUS

           EVALUATE TRUE
               WHEN IN-NUM = 0
                   MOVE "ZERO" TO WS-TXT
               WHEN IN-NUM = 1
                   MOVE "UM" TO WS-TXT
               WHEN IN-NUM = 2
                   MOVE "DOIS" TO WS-TXT
               WHEN IN-NUM = 3
                   MOVE "TRÊS" TO WS-TXT
               WHEN IN-NUM = 4
                   MOVE "QUATRO" TO WS-TXT
               WHEN IN-NUM = 5
                   MOVE "CINCO" TO WS-TXT
               WHEN IN-NUM = 6
                   MOVE "SEIS" TO WS-TXT
               WHEN IN-NUM = 7
                   MOVE "SETE" TO WS-TXT
               WHEN IN-NUM = 8
                   MOVE "OITO" TO WS-TXT
               WHEN IN-NUM = 9
                   MOVE "NOVE" TO WS-TXT
               WHEN OTHER
                   MOVE SPACES TO WS-TXT
                   MOVE "RNG"  TO OUT-STATUS
           END-EVALUATE

           IF OUT-STATUS = "OK"
               MOVE FUNCTION TRIM(WS-TXT) TO OUT-TEXT
           END-IF

           GOBACK.
