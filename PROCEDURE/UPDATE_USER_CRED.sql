
  CREATE OR REPLACE PROCEDURE "UPDATE_USER_CRED" 
(
  USERNAME IN VARCHAR2 
, NEWPASSWORD IN VARCHAR2 
) AS 
   l_stmt VARCHAR2(4000);
BEGIN
  l_stmt := 'ALTER USER ' || dbms_assert.schema_name(USERNAME) || ' IDENTIFIED BY ' || dbms_assert.enquote_name(NEWPASSWORD);

  EXECUTE IMMEDIATE l_stmt;

EXCEPTION
    WHEN OTHERS THEN
      DBMS_OUTPUT.put_line('Exception raised trying to change user credentials');
      RAISE VALUE_ERROR;
END UPDATE_USER_CRED;