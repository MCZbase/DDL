
  CREATE OR REPLACE EDITIONABLE FUNCTION "GETFIRSTIDENTIFIER" (p_key_val  in number )
return varchar2
as
-- return the name of the agent who is the first in a list of determiners in
-- the current identification of a cataloged item.
-- @param p_key_val the collection_object_id of the cataloged item to look up
-- the first identifier for the current identification of.
-- @return the prefered agent name for the agent who is first in the list
-- of determiners for the current identification of the specified collection object.
type rc is ref cursor;
l_str    varchar2(4000);
l_sep    varchar2(3);
l_val    varchar2(4000);
l_cur    rc;
begin
open l_cur for 'select agent_name
from
	preferred_agent_name,identification_agent,identification
where
identification_agent.agent_id=preferred_agent_name.agent_id AND
identification_agent.identification_id=identification.identification_id AND
accepted_id_fg=1 AND
identification.collection_object_id = :x
order by identifier_order'
using p_key_val;
fetch l_cur into l_val;
close l_cur;
       return l_val;
  end;