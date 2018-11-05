
  CREATE OR REPLACE FUNCTION "GET_COLLECTORSTYPEDNAME" 
(
   COLLOBJID  in varchar2, 
   NAMETYPE IN VARCHAR2 DEFAULT 'preferred' 
)
return varchar2 
--  Given a collection_object_id, return a comma separated list of collectors, using the specified
--  form of the collector's names (falling back to login and then preferred name if the specified 
--  form is not present for an agent, default specified form is preferred).  
--  @param collobjid the collection_object_id for which to look up the collectors
--  @praram nametype the agent name type to preferentially use, preferred is the default if not specified. 
--  @return a comma separated list of collector names, preferentially using the specified form
as
   type rc is ref cursor;
   l_str    varchar2(4000);
   l_sep    varchar2(3);
   l_val    varchar2(4000);
   l_cur    rc;
BEGIN
open l_cur for 
        'select MCZBASE.get_agentnameoftype(agent_id, :x ) from collector 
             where
                 collector_role=''c'' AND collection_object_id = :y
                 and agent_id is not null
             order by coll_order'
using NAMETYPE, COLLOBJID;
   loop
      fetch l_cur into l_val;
      exit when l_cur%notfound;
      l_str := l_str || l_sep || l_val;
      l_sep := ', ';
   end loop;
close l_cur;

return l_str;
end GET_COLLECTORSTYPEDNAME;