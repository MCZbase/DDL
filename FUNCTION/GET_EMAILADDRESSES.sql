
  CREATE OR REPLACE EDITIONABLE FUNCTION "GET_EMAILADDRESSES" 
(
  AGENT_ID  in number,
  SEPARATOR in VARCHAR2 DEFAULT ' '
) 
--  Given an agent_id, return the email addresses for that agent.
--  @param agent_id the agent for which to obtain the emails addresses for 
--  @param the separator to use between emails, a space if no value
--     is specified.
--  @return a concatenated list of emails for the specified agent.
RETURN VARCHAR2 AS 
      type rc is ref cursor;
      addr    varchar2(4000);
      retval    varchar2(4000);
      sep varchar2(10);
      l_cur rc;
BEGIN
  addr := '';
  retval := '';
  sep := '';
  open l_cur for 
     'select address 
     from electronic_address  
     where address_type = ''email'' 
        and agent_id = :x
     '
  using AGENT_ID; 
       loop 
          fetch l_cur into addr;
              exit when l_cur%notfound;
              retval := retval || sep || addr;
              sep := SEPARATOR;
       end loop;  
       close l_cur;

       return retval;

END GET_EMAILADDRESSES;