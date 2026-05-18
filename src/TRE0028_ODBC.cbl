       IDENTIFICATION DIVISION.
       PROGRAM-ID. TRE0028-ODBC.

       ENVIRONMENT DIVISION.
       CONFIGURATION SECTION.
       SPECIAL-NAMES.
           DECIMAL-POINT IS COMMA.

       DATA DIVISION.
       WORKING-STORAGE SECTION.
       01  RC                    PIC S9(9) COMP-5 VALUE 0.

       01  HENV                  USAGE POINTER.
       01  HDBC                  USAGE POINTER.
       01  HSTMT                 USAGE POINTER.

       01  SQL-NULL-HANDLE       PIC S9(9) COMP-5 VALUE 0.

       01  SQL-HANDLE-ENV        PIC S9(9) COMP-5 VALUE 1.
       01  SQL-HANDLE-DBC        PIC S9(9) COMP-5 VALUE 2.
       01  SQL-HANDLE-STMT       PIC S9(9) COMP-5 VALUE 3.

       01  SQL-NTS               PIC S9(9) COMP-5 VALUE -3.

       01  SQL-SUCCESS           PIC S9(9) COMP-5 VALUE 0.
       01  SQL-SUCCESS-W-INFO    PIC S9(9) COMP-5 VALUE 1.
       01  SQL-NO-DATA           PIC S9(9) COMP-5 VALUE 100.
       01  SQL-INVALID-HANDLE    PIC S9(9) COMP-5 VALUE -2.

       01  SQL-ATTR-ODBC-VERSION PIC S9(9) COMP-5 VALUE 200.
       01  SQL-OV-ODBC3          PIC S9(9) COMP-5 VALUE 3.

       01  CONNSTR               PIC X(512).
       01  ODBC-DRIVER           PIC X(64).
       01  ODBC-DRIVER-Z         PIC X(64).
       01  DB-HOST              PIC X(128).
       01  DB-HOST-Z            PIC X(128).
       01  DB-PORT              PIC X(16).
       01  DB-PORT-Z            PIC X(16).
       01  DB-NAME              PIC X(64).
       01  DB-NAME-Z            PIC X(64).
       01  DB-USER              PIC X(64).
       01  DB-USER-Z            PIC X(64).
       01  DB-PASS              PIC X(64).
       01  DB-PASS-Z            PIC X(64).

       01  QRY                   PIC X(512).
       01  QRY-LEN               PIC S9(9) COMP-5.

       01  COL1-NUM-MATRIC       PIC S9(9) COMP-5.
       01  COL2-NOME-FUNC        PIC X(50).
       01  IND1                  PIC S9(9) COMP-5.
       01  IND2                  PIC S9(9) COMP-5.

       01  DIAG-STATE            PIC X(6).
       01  DIAG-NATIVE           PIC S9(9) COMP-5.
       01  DIAG-MSG              PIC X(256).
       01  DIAG-MSG-LEN          PIC S9(9) COMP-5.

       PROCEDURE DIVISION.
           PERFORM 1000-CONNECT
           PERFORM 2000-QUERY
           PERFORM 9000-CLOSE
           GOBACK.

       1000-CONNECT SECTION.
           ACCEPT ODBC-DRIVER FROM ENVIRONMENT "ODBC_DRIVER"
           IF ODBC-DRIVER = SPACES
             MOVE "MariaDB Unicode" TO ODBC-DRIVER
           END-IF

           ACCEPT DB-HOST FROM ENVIRONMENT "MARIADB_HOST"
           IF DB-HOST = SPACES
             MOVE "mariadb" TO DB-HOST
           END-IF

           ACCEPT DB-PORT FROM ENVIRONMENT "MARIADB_PORT"
           IF DB-PORT = SPACES
             MOVE "3306" TO DB-PORT
           END-IF

           ACCEPT DB-NAME FROM ENVIRONMENT "MARIADB_DATABASE"
           IF DB-NAME = SPACES
             MOVE "tre" TO DB-NAME
           END-IF

           ACCEPT DB-USER FROM ENVIRONMENT "MARIADB_USER"
           IF DB-USER = SPACES
             MOVE "tre" TO DB-USER
           END-IF

           ACCEPT DB-PASS FROM ENVIRONMENT "MARIADB_PASSWORD"
           IF DB-PASS = SPACES
             MOVE "trepass" TO DB-PASS
           END-IF

           MOVE ODBC-DRIVER TO ODBC-DRIVER-Z
           INSPECT ODBC-DRIVER-Z REPLACING TRAILING SPACES BY LOW-VALUES
           MOVE DB-HOST TO DB-HOST-Z
           INSPECT DB-HOST-Z REPLACING TRAILING SPACES BY LOW-VALUES
           MOVE DB-PORT TO DB-PORT-Z
           INSPECT DB-PORT-Z REPLACING TRAILING SPACES BY LOW-VALUES
           MOVE DB-NAME TO DB-NAME-Z
           INSPECT DB-NAME-Z REPLACING TRAILING SPACES BY LOW-VALUES
           MOVE DB-USER TO DB-USER-Z
           INSPECT DB-USER-Z REPLACING TRAILING SPACES BY LOW-VALUES
           MOVE DB-PASS TO DB-PASS-Z
           INSPECT DB-PASS-Z REPLACING TRAILING SPACES BY LOW-VALUES

           STRING
             "DRIVER={"          DELIMITED BY SIZE
             ODBC-DRIVER-Z       DELIMITED BY LOW-VALUES
             "}"                 DELIMITED BY SIZE
             ";SERVER="         DELIMITED BY SIZE
             DB-HOST-Z           DELIMITED BY LOW-VALUES
             ";PORT="           DELIMITED BY SIZE
             DB-PORT-Z           DELIMITED BY LOW-VALUES
             ";DATABASE="       DELIMITED BY SIZE
             DB-NAME-Z           DELIMITED BY LOW-VALUES
             ";USER="           DELIMITED BY SIZE
             DB-USER-Z           DELIMITED BY LOW-VALUES
             ";PASSWORD="       DELIMITED BY SIZE
             DB-PASS-Z           DELIMITED BY LOW-VALUES
             INTO CONNSTR
           END-STRING

           CALL "SQLAllocHandle" USING
             BY VALUE SQL-HANDLE-ENV
             BY VALUE SQL-NULL-HANDLE
             BY REFERENCE HENV
           RETURNING RC
           END-CALL
           IF RC = SQL-INVALID-HANDLE
             DISPLAY "Falha SQLAllocHandle(ENV): INVALID_HANDLE"
             STOP RUN
           END-IF

           CALL "SQLSetEnvAttr" USING
             BY VALUE HENV
             BY VALUE SQL-ATTR-ODBC-VERSION
             BY VALUE SQL-OV-ODBC3
             BY VALUE 0
           RETURNING RC
           END-CALL
           IF RC NOT = SQL-SUCCESS AND RC NOT = SQL-SUCCESS-W-INFO
             DISPLAY "Falha SQLSetEnvAttr(ODBC3), RC=" RC
             STOP RUN
           END-IF

           CALL "SQLAllocHandle" USING
             BY VALUE SQL-HANDLE-DBC
             BY VALUE HENV
             BY REFERENCE HDBC
           RETURNING RC
           END-CALL
           IF RC = SQL-INVALID-HANDLE
             DISPLAY "Falha SQLAllocHandle(DBC): INVALID_HANDLE"
             STOP RUN
           END-IF

           CALL "SQLDriverConnect" USING
             BY VALUE HDBC
             BY VALUE 0
             BY REFERENCE CONNSTR
             BY VALUE SQL-NTS
             BY VALUE 0
             BY VALUE 0
             BY VALUE 0
             BY VALUE 0
           RETURNING RC
           END-CALL

           IF RC NOT = SQL-SUCCESS AND RC NOT = SQL-SUCCESS-W-INFO
             DISPLAY "Falha ao conectar via ODBC, RC=" RC
             PERFORM 1100-DIAG-CONNECT
             STOP RUN
           END-IF
           .

       1100-DIAG-CONNECT SECTION.
           MOVE SPACES TO DIAG-STATE
           MOVE SPACES TO DIAG-MSG
           MOVE 0 TO DIAG-NATIVE
           MOVE 0 TO DIAG-MSG-LEN

           CALL "SQLGetDiagRec" USING
             BY VALUE SQL-HANDLE-DBC
             BY VALUE HDBC
             BY VALUE 1
             BY REFERENCE DIAG-STATE
             BY REFERENCE DIAG-NATIVE
             BY REFERENCE DIAG-MSG
             BY VALUE 255
             BY REFERENCE DIAG-MSG-LEN
           RETURNING RC
           END-CALL

           DISPLAY "SQLSTATE=" DIAG-STATE
           DISPLAY "NATIVE=" DIAG-NATIVE
           DISPLAY "MSG=" DIAG-MSG
           .

       2000-QUERY SECTION.
           STRING
             "SELECT fun_num_matric, fun_nome_func "
             "FROM funcionario "
             "ORDER BY fun_nome_func"
             INTO QRY
           END-STRING
           MOVE 0 TO QRY-LEN

           CALL "SQLAllocHandle" USING
             BY VALUE SQL-HANDLE-STMT
             BY VALUE HDBC
             BY REFERENCE HSTMT
           RETURNING RC
           END-CALL

           CALL "SQLExecDirect" USING
             BY VALUE HSTMT
             BY REFERENCE QRY
             BY VALUE SQL-NTS
           RETURNING RC
           END-CALL

           IF RC NOT = SQL-SUCCESS AND RC NOT = SQL-SUCCESS-W-INFO
             DISPLAY "Falha SQLExecDirect, RC=" RC
             STOP RUN
           END-IF

           CALL "SQLBindCol" USING
             BY VALUE HSTMT
             BY VALUE 1
             BY VALUE 4
             BY REFERENCE COL1-NUM-MATRIC
             BY VALUE 4
             BY REFERENCE IND1
           RETURNING RC
           END-CALL

           CALL "SQLBindCol" USING
             BY VALUE HSTMT
             BY VALUE 2
             BY VALUE 1
             BY REFERENCE COL2-NOME-FUNC
             BY VALUE 50
             BY REFERENCE IND2
           RETURNING RC
           END-CALL

           PERFORM UNTIL 1 = 0
             CALL "SQLFetch" USING BY VALUE HSTMT
             RETURNING RC
             END-CALL
             IF RC = SQL-NO-DATA
               EXIT PERFORM
             END-IF
             IF RC NOT = SQL-SUCCESS AND RC NOT = SQL-SUCCESS-W-INFO
               DISPLAY "Falha SQLFetch, RC=" RC
               EXIT PERFORM
             END-IF
             DISPLAY "MATRICULA FUNCIONARIO " COL1-NUM-MATRIC
             DISPLAY "NOME FUNCIONARIO " COL2-NOME-FUNC
           END-PERFORM
           .

       9000-CLOSE SECTION.
           CALL "SQLFreeHandle" USING
             BY VALUE SQL-HANDLE-STMT
             BY VALUE HSTMT
           END-CALL

           CALL "SQLDisconnect" USING
             BY VALUE HDBC
           END-CALL

           CALL "SQLFreeHandle" USING
             BY VALUE SQL-HANDLE-DBC
             BY VALUE HDBC
           END-CALL

           CALL "SQLFreeHandle" USING
             BY VALUE SQL-HANDLE-ENV
             BY VALUE HENV
           END-CALL
           .
