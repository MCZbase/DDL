
  CREATE OR REPLACE EDITIONABLE FUNCTION "GET_TRANS_AGENT" 
-- Given a transaction_id and an agent_role, return the preferred --
-- names of the agents in that role, if there are no    --
-- agents in that role, then an empty string is returned.       --
( transaction_id IN VARCHAR2,
  agent_role in varchar2
) RETURN VARCHAR2 AS
type rc is ref cursor;
l_str    varchar2(4000);
l_sep    varchar2(3);
l_val    varchar2(4000);
l_cur    rc;
begin
open l_cur for '
select agent_name 
from agent_name, trans_agent 
where
trans_agent.agent_id = agent_name.agent_id and
agent_name.agent_name_type = ''preferred'' and
trans_agent.trans_agent_role = :x and
trans_agent.transaction_id = :y
'
using agent_role, transaction_id;
loop
fetch l_cur into l_val;
exit when l_cur%notfound;
l_str := l_str || l_sep || l_val;
l_sep := ', ';
end loop;
close l_cur;
       return l_str;
END;


