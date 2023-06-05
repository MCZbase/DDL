
  CREATE OR REPLACE FUNCTION "GET_MY_CUSTOMID" 
RETURN VARCHAR 
--  obtain the custom identifier for the current user
--  return previous number if none
AS 
  type rc is ref cursor;
  l_val    varchar(2000);
  l_cur    rc;
BEGIN
      l_val := 'previous number'; 
      open l_cur for 'select customotheridentifier from cf_users where customotheridentifier is not null and upper(username) = user';
      loop
           fetch l_cur into l_val;
           exit when l_cur%notfound; 
      end loop;
      close l_cur;

      return l_val;
END GET_MY_CUSTOMID;