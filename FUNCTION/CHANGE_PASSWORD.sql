
  CREATE OR REPLACE FUNCTION "CHANGE_PASSWORD" (username IN varchar2, newpassword IN varchar2)
 
RETURN integer
 
IS
 
l_CursorID integer;
l_Command varchar2 (80);
undefined integer;  -- return value for DBMS_SQL.execute is undefined for DDL

xMISSING_PARAMETER EXCEPTION;

BEGIN
   IF (username IS NULL OR newpassword IS NULL) THEN
      RAISE xMISSING_PARAMETER;
   END IF;

   l_Command := 'ALTER USER ' || dbms_assert.schema_name(username) || ' IDENTIFIED BY ' ||  dbms_assert.enquote_name(newpassword);

   l_CursorID := DBMS_SQL.Open_Cursor;  
   DBMS_SQL.Parse(l_CursorID, l_Command, DBMS_SQL.v7);

   undefined := DBMS_SQL.Execute(l_CursorID);
   
   DBMS_SQL.Close_Cursor (l_CursorID);

   RETURN 1;

EXCEPTION
WHEN OTHERS THEN
   DBMS_OUTPUT.put_line('Exception raised trying to change user credentials');
   RETURN 0;
END Change_Password;