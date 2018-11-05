
  CREATE OR REPLACE FUNCTION "GET_STR_EL" (
   	mystring IN VARCHAR,
   	separator IN VARCHAR,
   	pos IN NUMBER)
RETURN VARCHAR2
AS
    theThingy VARCHAR2(4000);
BEGIN
    SELECT bla INTO theThingy
    FROM (
        SELECT
            rownum r,
            SUBSTR(mystring || separator,
                NVL(LAG(TOKEN) OVER (ORDER BY TOKEN),0) + 1,
                TOKEN - (NVL(LAG(TOKEN) OVER (ORDER BY TOKEN), 0) + 1)) bla
        FROM (
            SELECT
                LEVEL,
                INSTR( mystring || separator, separator, 1, LEVEL ) TOKEN
            FROM DUAL
            CONNECT BY INSTR( mystring || separator, separator, 1, LEVEL ) != 0
            ORDER BY LEVEL
        )
    )
    WHERE r = pos;
    RETURN theThingy;
END;
 
 