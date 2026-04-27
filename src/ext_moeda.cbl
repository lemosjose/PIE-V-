       IDENTIFICATION DIVISION.
       PROGRAM-ID. EXT-MOEDA.

       DATA DIVISION.
       WORKING-STORAGE SECTION.
       01  WS-RAW                    PIC X(40)  VALUE SPACES.
       01  WS-RAW-TRIM               PIC X(40)  VALUE SPACES.
       01  WS-RAW-NODOT              PIC X(40)  VALUE SPACES.
       01  WS-INT-PART               PIC X(30)  VALUE SPACES.
       01  WS-CENT-PART              PIC X(10)  VALUE SPACES.
       01  WS-CENT2                  PIC X(2)   VALUE "00".

       01  WS-I                      PIC 99 COMP-5.
       01  WS-LEN                    PIC 99 COMP-5.
       01  WS-POS-COMMA              PIC 99 COMP-5.
       01  WS-CH                     PIC X(1).

       01  WS-REAIS                  PIC 9(9) COMP-5.
       01  WS-CENTS                  PIC 99   COMP-5.

       01  WS-TXT                    PIC X(256) VALUE SPACES.
       01  WS-AUX                    PIC X(256) VALUE SPACES.
       01  WS-AUX2                   PIC X(256) VALUE SPACES.

       01  WS-NUM-IN.
           05  WS-IN-NUM             PIC 9(9) COMP-5.
       01  WS-NUM-OUT.
           05  WS-OUT-TEXT           PIC X(256).
           05  WS-OUT-STATUS         PIC X(3).

       LINKAGE SECTION.
       01  LK-IN.
           05  LK-VALOR              PIC X(40).
       01  LK-OUT.
           05  LK-TEXTO              PIC X(256).
           05  LK-STATUS             PIC X(3).

       PROCEDURE DIVISION USING LK-IN LK-OUT.
           MOVE SPACES TO LK-TEXTO
           MOVE "OK"   TO LK-STATUS

           MOVE LK-VALOR TO WS-RAW
           MOVE FUNCTION TRIM(WS-RAW) TO WS-RAW-TRIM

           IF WS-RAW-TRIM = SPACES
               MOVE "ERR" TO LK-STATUS
               GOBACK
           END-IF

           *> Remove separador de milhar '.' e espaços
           MOVE SPACES TO WS-RAW-NODOT
           MOVE 0 TO WS-LEN
           PERFORM VARYING WS-I FROM 1 BY 1 
               UNTIL WS-I > FUNCTION LENGTH(WS-RAW-TRIM)
               MOVE WS-RAW-TRIM(WS-I:1) TO WS-CH
               IF WS-CH NOT = "." AND WS-CH NOT = " "
                   ADD 1 TO WS-LEN
                   MOVE WS-CH TO WS-RAW-NODOT(WS-LEN:1)
               END-IF
           END-PERFORM

           *> Localiza vírgula decimal
           MOVE 0 TO WS-POS-COMMA
           PERFORM VARYING WS-I FROM 1 BY 1 
               UNTIL WS-I > FUNCTION LENGTH(WS-RAW-NODOT)
               IF WS-RAW-NODOT(WS-I:1) = ","
                   MOVE WS-I TO WS-POS-COMMA
               END-IF
           END-PERFORM

           MOVE SPACES TO WS-INT-PART WS-CENT-PART
           IF WS-POS-COMMA = 0
               MOVE FUNCTION TRIM(WS-RAW-NODOT) TO WS-INT-PART
               MOVE "00" TO WS-CENT2
           ELSE
               MOVE WS-RAW-NODOT(1:WS-POS-COMMA - 1) TO WS-INT-PART
               MOVE WS-RAW-NODOT(WS-POS-COMMA + 1:) TO WS-CENT-PART

               IF FUNCTION LENGTH(FUNCTION TRIM(WS-CENT-PART)) = 0
                   MOVE "00" TO WS-CENT2
               ELSE
                   MOVE WS-CENT-PART(1:1) TO WS-CENT2(1:1)
                   IF FUNCTION LENGTH(FUNCTION TRIM(WS-CENT-PART)) >= 2
                       MOVE WS-CENT-PART(2:1) TO WS-CENT2(2:1)
                   ELSE
                       MOVE "0" TO WS-CENT2(2:1)
                   END-IF
               END-IF
           END-IF

           *> Converte para numérico (somente dígitos esperados)
           MOVE FUNCTION NUMVAL(WS-INT-PART) TO WS-REAIS
           MOVE FUNCTION NUMVAL(WS-CENT2)    TO WS-CENTS

           IF WS-REAIS < 0 OR WS-REAIS > 999999999
               MOVE "RNG" TO LK-STATUS
               GOBACK
           END-IF

           MOVE SPACES TO WS-AUX WS-AUX2 WS-TXT

           *> Extenso dos reais
           MOVE WS-REAIS TO WS-IN-NUM
           MOVE SPACES TO WS-OUT-TEXT
           MOVE "OK"   TO WS-OUT-STATUS
           CALL "EXT-NUM" USING WS-NUM-IN WS-NUM-OUT END-CALL
           IF WS-OUT-STATUS NOT = "OK"
               MOVE "ERR" TO LK-STATUS
               GOBACK
           END-IF
           MOVE WS-OUT-TEXT TO WS-AUX

           IF WS-REAIS = 1
               STRING FUNCTION TRIM(WS-AUX) " REAL" INTO WS-AUX END-STRING
           ELSE
               STRING FUNCTION TRIM(WS-AUX) " REAIS" INTO WS-AUX END-STRING
           END-IF

           *> Extenso dos centavos (se houver)
           IF WS-CENTS = 0
               MOVE FUNCTION TRIM(WS-AUX) TO LK-TEXTO
               MOVE "OK" TO LK-STATUS
               GOBACK
           END-IF

           MOVE WS-CENTS TO WS-IN-NUM
           MOVE SPACES TO WS-OUT-TEXT
           MOVE "OK"   TO WS-OUT-STATUS
           IF WS-CENTS < 10
               CALL "EXT-UNITS" USING WS-NUM-IN WS-NUM-OUT END-CALL
           ELSE
               CALL "EXT-TENS" USING WS-NUM-IN WS-NUM-OUT END-CALL
           END-IF
           IF WS-OUT-STATUS NOT = "OK"
               MOVE "ERR" TO LK-STATUS
               GOBACK
           END-IF
           MOVE WS-OUT-TEXT TO WS-AUX2

           IF WS-CENTS = 1
               STRING FUNCTION TRIM(WS-AUX2) " CENTAVO" INTO WS-AUX2 END-STRING
           ELSE
               STRING FUNCTION TRIM(WS-AUX2) " CENTAVOS" INTO WS-AUX2 END-STRING
           END-IF

           STRING
               FUNCTION TRIM(WS-AUX)
               " E "
               FUNCTION TRIM(WS-AUX2)
               INTO WS-TXT
           END-STRING

           MOVE FUNCTION TRIM(WS-TXT) TO LK-TEXTO
           MOVE "OK" TO LK-STATUS
           GOBACK.

