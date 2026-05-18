       IDENTIFICATION DIVISION.
       PROGRAM-ID. CIDADES-UF.
      *---------------------------------------------------------------
      * Consulta a tabela Cidade (banco UFIBGE) e exibe a quantidade
      * de cidades por UF em formato de grade 9x3.
      * Conexao via ODBC (unixODBC + driver MariaDB).
      *---------------------------------------------------------------

       ENVIRONMENT DIVISION.
       CONFIGURATION SECTION.
       SPECIAL-NAMES.
           DECIMAL-POINT IS COMMA.

       DATA DIVISION.
       WORKING-STORAGE SECTION.

      *---------------------------------------------------------------
      * Constantes e handles ODBC
      *---------------------------------------------------------------
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

      *---------------------------------------------------------------
      * Variaveis de conexao
      *---------------------------------------------------------------
       01  CONNSTR               PIC X(512).
       01  ODBC-DRIVER           PIC X(64).
       01  ODBC-DRIVER-Z         PIC X(64).
       01  DB-HOST               PIC X(128).
       01  DB-HOST-Z             PIC X(128).
       01  DB-PORT               PIC X(16).
       01  DB-PORT-Z             PIC X(16).
       01  DB-NAME               PIC X(64).
       01  DB-NAME-Z             PIC X(64).
       01  DB-USER               PIC X(64).
       01  DB-USER-Z             PIC X(64).
       01  DB-PASS               PIC X(64).
       01  DB-PASS-Z             PIC X(64).

      *---------------------------------------------------------------
      * Query e resultado
      *---------------------------------------------------------------
       01  QRY                   PIC X(512).
       01  QRY-LEN               PIC S9(9) COMP-5.

       01  WS-UF                 PIC X(3).
       01  WS-QTDE               PIC S9(9) COMP-5.
       01  IND-UF                PIC S9(9) COMP-5.
       01  IND-QTDE              PIC S9(9) COMP-5.

      *---------------------------------------------------------------
      * Diagnostico ODBC
      *---------------------------------------------------------------
       01  DIAG-STATE            PIC X(6).
       01  DIAG-NATIVE           PIC S9(9) COMP-5.
       01  DIAG-MSG              PIC X(256).
       01  DIAG-MSG-LEN          PIC S9(9) COMP-5.

      *---------------------------------------------------------------
      * Grade de UFs (ordem conforme layout do relatorio)
      * Linha 1: AC AL AP AM BA CE DF ES GO
      * Linha 2: MA MT MS MG PA PB PR PE PI
      * Linha 3: RJ RN RS RO RR SC SP SE TO
      *---------------------------------------------------------------
       01  WS-GRID-UFS-DATA.
           05  FILLER PIC X(2) VALUE "AC".
           05  FILLER PIC X(2) VALUE "AL".
           05  FILLER PIC X(2) VALUE "AP".
           05  FILLER PIC X(2) VALUE "AM".
           05  FILLER PIC X(2) VALUE "BA".
           05  FILLER PIC X(2) VALUE "CE".
           05  FILLER PIC X(2) VALUE "DF".
           05  FILLER PIC X(2) VALUE "ES".
           05  FILLER PIC X(2) VALUE "GO".
           05  FILLER PIC X(2) VALUE "MA".
           05  FILLER PIC X(2) VALUE "MT".
           05  FILLER PIC X(2) VALUE "MS".
           05  FILLER PIC X(2) VALUE "MG".
           05  FILLER PIC X(2) VALUE "PA".
           05  FILLER PIC X(2) VALUE "PB".
           05  FILLER PIC X(2) VALUE "PR".
           05  FILLER PIC X(2) VALUE "PE".
           05  FILLER PIC X(2) VALUE "PI".
           05  FILLER PIC X(2) VALUE "RJ".
           05  FILLER PIC X(2) VALUE "RN".
           05  FILLER PIC X(2) VALUE "RS".
           05  FILLER PIC X(2) VALUE "RO".
           05  FILLER PIC X(2) VALUE "RR".
           05  FILLER PIC X(2) VALUE "SC".
           05  FILLER PIC X(2) VALUE "SP".
           05  FILLER PIC X(2) VALUE "SE".
           05  FILLER PIC X(2) VALUE "TO".

       01  WS-GRID-UFS REDEFINES WS-GRID-UFS-DATA.
           05  WS-GRID-UF        PIC X(2) OCCURS 27 TIMES.

      *---------------------------------------------------------------
      * Contadores por posicao na grade
      *---------------------------------------------------------------
       01  WS-COUNTS-DATA.
           05  WS-COUNT          PIC 9(4) OCCURS 27 TIMES.

      *---------------------------------------------------------------
      * Variaveis auxiliares de exibicao
      *---------------------------------------------------------------
       01  WS-IDX                PIC 99.
       01  WS-ROW                PIC 99.
       01  WS-COL                PIC 99.
       01  WS-BASE               PIC 99.
       01  WS-POS                PIC 99.
       01  WS-SEARCH             PIC 99.

       01  WS-FMT-COUNT          PIC Z.ZZ9.

       01  WS-SEP-LINE           PIC X(65) VALUE ALL "-".

       01  WS-HDR-LINE           PIC X(65).
       01  WS-VAL-LINE           PIC X(65).

       01  WS-CELL-HDR           PIC X(7).
       01  WS-CELL-VAL           PIC X(7).

       PROCEDURE DIVISION.
           PERFORM 0000-INIT
           PERFORM 1000-CONNECT
           PERFORM 2000-QUERY
           PERFORM 3000-REPORT
           PERFORM 9000-CLOSE
           GOBACK.

      *---------------------------------------------------------------
      * 0000 - Inicializa contadores com zero
      *---------------------------------------------------------------
       0000-INIT SECTION.
           INITIALIZE WS-COUNTS-DATA
           .

      *---------------------------------------------------------------
      * 1000 - Conexao ODBC ao MariaDB
      *---------------------------------------------------------------
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
             MOVE "UFIBGE" TO DB-NAME
           END-IF

           ACCEPT DB-USER FROM ENVIRONMENT "MARIADB_USER"
           IF DB-USER = SPACES
             MOVE "cobol" TO DB-USER
           END-IF

           ACCEPT DB-PASS FROM ENVIRONMENT "MARIADB_PASSWORD"
           IF DB-PASS = SPACES
             MOVE "cobol" TO DB-PASS
           END-IF

           MOVE ODBC-DRIVER TO ODBC-DRIVER-Z
           INSPECT ODBC-DRIVER-Z
               REPLACING TRAILING SPACES BY LOW-VALUES
           MOVE DB-HOST TO DB-HOST-Z
           INSPECT DB-HOST-Z
               REPLACING TRAILING SPACES BY LOW-VALUES
           MOVE DB-PORT TO DB-PORT-Z
           INSPECT DB-PORT-Z
               REPLACING TRAILING SPACES BY LOW-VALUES
           MOVE DB-NAME TO DB-NAME-Z
           INSPECT DB-NAME-Z
               REPLACING TRAILING SPACES BY LOW-VALUES
           MOVE DB-USER TO DB-USER-Z
           INSPECT DB-USER-Z
               REPLACING TRAILING SPACES BY LOW-VALUES
           MOVE DB-PASS TO DB-PASS-Z
           INSPECT DB-PASS-Z
               REPLACING TRAILING SPACES BY LOW-VALUES

           STRING
             "DRIVER={"          DELIMITED BY SIZE
             ODBC-DRIVER-Z       DELIMITED BY LOW-VALUES
             "}"                 DELIMITED BY SIZE
             ";SERVER="          DELIMITED BY SIZE
             DB-HOST-Z           DELIMITED BY LOW-VALUES
             ";PORT="            DELIMITED BY SIZE
             DB-PORT-Z           DELIMITED BY LOW-VALUES
             ";DATABASE="        DELIMITED BY SIZE
             DB-NAME-Z           DELIMITED BY LOW-VALUES
             ";USER="            DELIMITED BY SIZE
             DB-USER-Z           DELIMITED BY LOW-VALUES
             ";PASSWORD="        DELIMITED BY SIZE
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
             DISPLAY "Erro SQLAllocHandle(ENV): INVALID_HANDLE"
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
             DISPLAY "Erro SQLSetEnvAttr(ODBC3), RC=" RC
             STOP RUN
           END-IF

           CALL "SQLAllocHandle" USING
             BY VALUE SQL-HANDLE-DBC
             BY VALUE HENV
             BY REFERENCE HDBC
           RETURNING RC
           END-CALL
           IF RC = SQL-INVALID-HANDLE
             DISPLAY "Erro SQLAllocHandle(DBC): INVALID_HANDLE"
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
             DISPLAY "Erro ao conectar via ODBC, RC=" RC
             PERFORM 1100-DIAG-CONNECT
             STOP RUN
           END-IF
           .

      *---------------------------------------------------------------
      * 1100 - Diagnostico de erro de conexao
      *---------------------------------------------------------------
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
           DISPLAY "NATIVE="   DIAG-NATIVE
           DISPLAY "MSG="      DIAG-MSG
           .

      *---------------------------------------------------------------
      * 2000 - Executa SELECT e popula tabela de contadores
      *---------------------------------------------------------------
       2000-QUERY SECTION.
           MOVE SPACES TO QRY
           STRING
             "SELECT UF, COUNT(*) AS QTDE "
             "FROM Cidade "
             "GROUP BY UF "
             "ORDER BY UF"
             INTO QRY
           END-STRING
           INSPECT QRY REPLACING TRAILING SPACES
               BY LOW-VALUES

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
             DISPLAY "Erro SQLExecDirect, RC=" RC
             PERFORM 2100-DIAG-QUERY
             STOP RUN
           END-IF

           CALL "SQLBindCol" USING
             BY VALUE HSTMT
             BY VALUE 1
             BY VALUE 1
             BY REFERENCE WS-UF
             BY VALUE 3
             BY REFERENCE IND-UF
           RETURNING RC
           END-CALL

           CALL "SQLBindCol" USING
             BY VALUE HSTMT
             BY VALUE 2
             BY VALUE 4
             BY REFERENCE WS-QTDE
             BY VALUE 4
             BY REFERENCE IND-QTDE
           RETURNING RC
           END-CALL

           PERFORM UNTIL 1 = 0
             CALL "SQLFetch" USING BY VALUE HSTMT
             RETURNING RC
             END-CALL
             IF RC = SQL-NO-DATA
               EXIT PERFORM
             END-IF
             IF RC NOT = SQL-SUCCESS
                 AND RC NOT = SQL-SUCCESS-W-INFO
               DISPLAY "Erro SQLFetch, RC=" RC
               EXIT PERFORM
             END-IF

      *      Procura a UF na grade e armazena a contagem
             PERFORM VARYING WS-SEARCH FROM 1 BY 1
                 UNTIL WS-SEARCH > 27
               IF WS-GRID-UF(WS-SEARCH) = WS-UF(1:2)
                 MOVE WS-QTDE TO WS-COUNT(WS-SEARCH)
                 EXIT PERFORM
               END-IF
             END-PERFORM
           END-PERFORM
           .

      *---------------------------------------------------------------
      * 2100 - Diagnostico de erro na query
      *---------------------------------------------------------------
       2100-DIAG-QUERY SECTION.
           MOVE SPACES TO DIAG-STATE
           MOVE SPACES TO DIAG-MSG
           MOVE 0 TO DIAG-NATIVE
           MOVE 0 TO DIAG-MSG-LEN

           CALL "SQLGetDiagRec" USING
             BY VALUE SQL-HANDLE-STMT
             BY VALUE HSTMT
             BY VALUE 1
             BY REFERENCE DIAG-STATE
             BY REFERENCE DIAG-NATIVE
             BY REFERENCE DIAG-MSG
             BY VALUE 255
             BY REFERENCE DIAG-MSG-LEN
           RETURNING RC
           END-CALL

           DISPLAY "SQLSTATE=" DIAG-STATE
           DISPLAY "NATIVE="   DIAG-NATIVE
           DISPLAY "MSG="      DIAG-MSG
           .

      *---------------------------------------------------------------
      * 3000 - Monta e exibe o relatorio em grade 9x3
      *---------------------------------------------------------------
       3000-REPORT SECTION.
           DISPLAY SPACES
           DISPLAY "Relatorio de Cidades por UF (IBGE)"
           DISPLAY SPACES

           PERFORM VARYING WS-ROW FROM 1 BY 1
               UNTIL WS-ROW > 3

             COMPUTE WS-BASE = (WS-ROW - 1) * 9

      *      Linha separadora
             DISPLAY WS-SEP-LINE

      *      Linha de cabecalho (nomes das UFs)
             MOVE SPACES TO WS-HDR-LINE
             PERFORM VARYING WS-COL FROM 1 BY 1
                 UNTIL WS-COL > 9
               COMPUTE WS-POS = WS-BASE + WS-COL
               COMPUTE WS-IDX = (WS-COL - 1) * 7 + 1
               MOVE "|" TO WS-HDR-LINE(WS-IDX:1)
               MOVE " " TO WS-HDR-LINE(WS-IDX + 1:1)
               MOVE WS-GRID-UF(WS-POS)
                   TO WS-HDR-LINE(WS-IDX + 2:2)
               MOVE "  " TO WS-HDR-LINE(WS-IDX + 4:2)
               MOVE " " TO WS-HDR-LINE(WS-IDX + 6:1)
             END-PERFORM
             MOVE "|" TO WS-HDR-LINE(64:1)
             DISPLAY WS-HDR-LINE

      *      Linha de valores (contagens formatadas)
             MOVE SPACES TO WS-VAL-LINE
             PERFORM VARYING WS-COL FROM 1 BY 1
                 UNTIL WS-COL > 9
               COMPUTE WS-POS = WS-BASE + WS-COL
               MOVE WS-COUNT(WS-POS) TO WS-FMT-COUNT
               COMPUTE WS-IDX = (WS-COL - 1) * 7 + 1
               MOVE "|" TO WS-VAL-LINE(WS-IDX:1)
               MOVE WS-FMT-COUNT
                   TO WS-VAL-LINE(WS-IDX + 1:5)
               MOVE " " TO WS-VAL-LINE(WS-IDX + 6:1)
             END-PERFORM
             MOVE "|" TO WS-VAL-LINE(64:1)
             DISPLAY WS-VAL-LINE

           END-PERFORM

      *    Linha separadora final
           DISPLAY WS-SEP-LINE
           DISPLAY SPACES
           .

      *---------------------------------------------------------------
      * 9000 - Fecha handles ODBC
      *---------------------------------------------------------------
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
