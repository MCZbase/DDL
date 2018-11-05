
  CREATE OR REPLACE FUNCTION "GET_TRANS_RECIEVEDAGENT" 
-- Given a transaction_id, if that transaction is a accession,   --
-- returns a comma delimited, concatenated list of the preferred --
-- names of the agents from whom the accession was recieved,     --
-- that is, the donor or the list of donors of the accession.    --
-- If the transaction is not an accession, or if there are no    --
-- recieved from agents, then an empty string is returned.       --
( p_key_val IN VARCHAR2
) RETURN VARCHAR2 AS
type rc is ref cursor;
l_str    varchar2(4000);
l_sep    varchar2(3);
l_val    varchar2(4000);
l_cur    rc;
begin
open l_cur for 'select agent_name 
from agent_name, trans_agent 
where
trans_agent.agent_id = agent_name.agent_id and
agent_name.agent_name_type = ''preferred'' and
trans_agent.trans_agent_role = ''received from'' and
trans_agent.transaction_id = :x
'
using p_key_val;
loop
fetch l_cur into l_val;
exit when l_cur%notfound;
l_str := l_str || l_sep || l_val;
l_sep := ', ';
end loop;
close l_cur;
       return l_str;
END;

 
 