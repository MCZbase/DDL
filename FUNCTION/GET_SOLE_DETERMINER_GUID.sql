
  CREATE OR REPLACE EDITIONABLE FUNCTION "GET_SOLE_DETERMINER_GUID" 
(
  COLLECTION_OBJECT_ID IN NUMBER 
) RETURN VARCHAR2  
--  If a collection object has only one idntifier for the current identification, return the identifiedByID for that determiner if such exists.
--  @param collection_object_id the collection object for which to look up the determiner.
--  @return the agent.agentguid for the determiner if there is only one determiner, otherwise null
AS
   TYPE rc is ref cursor;
   l_str varchar(900);
   l_val varchar(900);
   l_ct number;
   l_cur rc;
   cur rc;
BEGIN
   l_str := '';
   open l_cur for '
   select count(distinct agent.agent_id) from identification
   left outer join MCZBASE.IDENTIFICATION_AGENT on identification.identification_id = MCZBASE.IDENTIFICATION_AGENT.IDENTIFICATION_ID
   left outer join agent on identification_agent.agent_id = agent.agent_id
   where identification.collection_object_id = :x
   and identification.accepted_id_fg = 1
   '
   using collection_object_id;
   loop
       fetch l_cur into l_ct;
        exit when l_cur%notfound;
   end loop;
   if l_ct = 1 then 
     open cur for '
       select agentguid from
       identification
       left outer join IDENTIFICATION_AGENT on identification.identification_id = IDENTIFICATION_AGENT.IDENTIFICATION_ID
       left outer join agent on identification_agent.agent_id = agent.agent_id
       where identification.accepted_id_fg = 1
       and agentguid is not null
       and identification.collection_object_id = :x
     ' using collection_object_id;
     loop
         fetch cur into l_val;
         l_str := l_val;
         exit when cur%notfound;
     end loop;
     close cur;

   end if;
   close l_cur;
  RETURN l_str;
END GET_SOLE_DETERMINER_GUID;