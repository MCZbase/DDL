
  CREATE OR REPLACE FUNCTION "GET_NONEMAILEADDRESSES" 
(
  AGENT_ID  in number,
  SEPARATOR in VARCHAR2 DEFAULT ' '
) 
--  Given an agent_id, return the non-email electronic addresses for that agent (mostly various phone numbers).
--  @param agent_id the transaction_id for which to obtain the phone eaddresses for.
--  @param the separator to use between emails, a space if no value
--     is specified.
--  @return a concatenated list of phone numbers and address types for the specified agent.
RETURN VARCHAR2 AS 
      type rc is ref cursor;
      addr    varchar2(4000);
      adtype  varchar2(4000);
      retval    varchar2(4000);
      sep varchar2(10);
      l_cur rc;
BEGIN
  addr := '';
  adtype := '';
  retval := '';
  sep := '';
  open l_cur for 
     'select address, address_type
     from electronic_address  
     where address_type <> ''email'' 
        and agent_id = :x
     '
  using AGENT_ID; 
       loop 
          fetch l_cur into addr, adtype;
              exit when l_cur%notfound;
              retval := retval || sep || addr || ' (' || adtype || ')';
              sep := SEPARATOR;
       end loop;  
       close l_cur;

       return retval;

END GET_NONEMAILEADDRESSES;