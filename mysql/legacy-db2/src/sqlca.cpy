      ******************************************************************
      * SQL COMMUNICATION AREA (SQLCA)
      * Utilizado pelo DB2 para retornar status das operacoes SQL
      ******************************************************************
       01 SQLCA.
          05 SQLCAID        PIC X(8) VALUE 'SQLCA   '.
          05 SQLCABC        PIC S9(9) COMP-5 VALUE 136.
          05 SQLCODE        PIC S9(9) COMP-5 VALUE 0.
          05 SQLERRM.
             49 SQLERRML   PIC S9(4) COMP-5 VALUE 0.
             49 SQLERRMC   PIC X(70) VALUE SPACES.
          05 SQLERRP        PIC X(8) VALUE SPACES.
          05 SQLERRD        PIC S9(9) COMP-5
                            OCCURS 6 TIMES VALUE 0.
          05 SQLWARN.
             10 SQLWARN0   PIC X VALUE SPACE.
             10 SQLWARN1   PIC X VALUE SPACE.
             10 SQLWARN2   PIC X VALUE SPACE.
             10 SQLWARN3   PIC X VALUE SPACE.
             10 SQLWARN4   PIC X VALUE SPACE.
             10 SQLWARN5   PIC X VALUE SPACE.
             10 SQLWARN6   PIC X VALUE SPACE.
             10 SQLWARN7   PIC X VALUE SPACE.
             10 SQLWARN8   PIC X VALUE SPACE.
             10 SQLWARN9   PIC X VALUE SPACE.
             10 SQLWARNA   PIC X VALUE SPACE.
          05 SQLSTATE       PIC X(5) VALUE SPACES.
