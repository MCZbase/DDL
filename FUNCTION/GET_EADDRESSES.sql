
  CREATE OR REPLACE FUNCTION "GET_EADDRESSES" 
(
  TRANSID IN NUMBER,
  CONTACTTYPE IN VARCHAR2 DEFAULT 'additional in-house contact',
  SEPARATOR in VARCHAR2 DEFAULT '; '
) 
--  Given an transaction number, return the electronic addresses for a 
--  transaction agent role type (email and/or work phone number).
--  @param transid the transaction_id for which to obtain the contact addresses for 
--    all agents with a particular role in the transaction.
--  @param contactype the transaction agent role to obtain, additional in-house contact
--     is the default if no value is specified.
--  @param the separator to use between addresses, a semicolon and space if no value
--     is specified.
--  @return a concatenated list of emails and work phone numbers for all agents with
--     a particular contact type for a particular transaction.
--  @see GET_EMAILADDRESSES for addresses for a specific agent.
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
     'select ea.address from trans_agent ta 
   left join electronic_address ea on ta.agent_id = ea.agent_id
   where ta.trans_agent_role = :x 
      and ta.transaction_id = :y
      and (ea.address_type = ''email'' or ea.address_type = ''work phone number'') 
   order by ta.agent_id, ea.address_type desc '
  using CONTACTTYPE, TRANSID; 
       loop 
          fetch l_cur into addr;
              exit when l_cur%notfound;
              retval := retval || sep || addr;
              sep := SEPARATOR;
       end loop;  
       close l_cur;

       return retval;
  
END GET_EADDRESSES;