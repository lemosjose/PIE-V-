       *> Common types for 'numero por extenso' routines
       *>
       *> Contract:
       *> - IN-NUM must be a non-negative integer in the valid range
       *>   for each routine.
       *> - OUT-TEXT is returned as uppercase Portuguese (pt-BR).
       *> - OUT-STATUS:
       *>     "OK"  -> success
       *>     "RNG" -> out of range for that routine
       *>     "ERR" -> other error (should not happen in normal use)
       *>
       01  EXT-IN.
           05  IN-NUM             PIC 9(9) COMP-5.
       01  EXT-OUT.
           05  OUT-TEXT           PIC X(256).
           05  OUT-STATUS         PIC X(3).