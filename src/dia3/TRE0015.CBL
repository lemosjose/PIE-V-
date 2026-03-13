       ID DIVISION.
          PROGRAM-ID. TRE0015.
       ENVIRONMENT DIVISION.
       CONFIGURATION SECTION.

       SPECIAL-NAMES.
           DECIMAL-POINT IS COMMA.

       DATA DIVISION.
       WORKING-STORAGE SECTION.

       01 AREA-SALVAMENTO.
              05 AS-I              PIC 9(006)       VALUE ZEROS.
              05 AS-MENOR          PIC 9(006)V99    VALUE ZEROS.
              05 AS-MENOR-EDIT     PIC ZZZZZ9,99    VALUE ZEROS.

       01 TABLE-DATA.
              05 FILLER PIC 9(3) VALUE 045.
              05 FILLER PIC 9(3) VALUE 012.
              05 FILLER PIC 9(3) VALUE 089.
              05 FILLER PIC 9(3) VALUE 007.
              05 FILLER PIC 9(3) VALUE 105.
              05 FILLER PIC 9(3) VALUE 022.
              05 FILLER PIC 9(3) VALUE 034.
              05 FILLER PIC 9(3) VALUE 099.
              05 FILLER PIC 9(3) VALUE 015.
              05 FILLER PIC 9(3) VALUE 050.



       01 TABLE-NUMS REDEFINES TABLE-DATA.
              05 TABLE-NUM OCCURS 10 TIMES PIC 9(3).


       PROCEDURE DIVISION.
              MOVE TABLE-NUM(1) TO AS-MENOR

              PERFORM VARYING AS-I FROM 1 BY 1 UNTIL AS-I>10


                     IF TABLE-NUM(AS-I) < AS-MENOR
                            MOVE TABLE-NUM(AS-I) TO AS-MENOR
                     END-IF

              END-PERFORM

              MOVE AS-MENOR TO AS-MENOR-EDIT
              DISPLAY "Menor Numero: " AS-MENOR-EDIT
              GOBACK.
