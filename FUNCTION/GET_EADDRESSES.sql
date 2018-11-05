
  CREATE OR REPLACE FUNCTION "GET_EADDRESSES" 
(
  TRANSID IN NUMBER,
  CONTACTTYPE IN VARCHAR2 DEFAULT 'additional in-house contact' 
) 
--  Given an transaction number, return the electronic addresses for a 
--  transaction agent role type.
RETURN VARCHAR2 AS 
      type rc is ref cursor;
      addr    varchar2(4000);
      retval    varchar2(4000);
      l_cur rc;
BEGIN
  addr := '';
  retval := '';
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
              retval := retval || ' ' || addr;
       end loop;  
       close l_cur;

       return retval;
  
END GET_EADDRESSES;