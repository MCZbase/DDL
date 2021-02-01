
  CREATE OR REPLACE FUNCTION "GET_SOLE_COLLECTOR_GUID" 
(
  COLLECTION_OBJECT_ID IN NUMBER 
) RETURN VARCHAR2  
--  If a collection object has only one collector, return the recordedByID for that collector if such exists.
--  @param collection_object_id the collection object for which to look up the collector.
--  @return the agent.agentguid for the collector if there is only one collector, otherwise null
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
   select count(*) ct from collector 
   where collection_object_id = :x
   and collector_role = ''c''
   '
   using collection_object_id;
   loop
       fetch l_cur into l_ct;
        exit when l_cur%notfound;
   end loop;
   if l_ct = 1 then 
     open cur for '
       select agentguid from
       collector left join agent on agent.agent_id = collector.agent_id
       where agentguid is not null
       and collector_role = ''c''
       and collection_object_id = :x
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
END GET_SOLE_COLLECTOR_GUID;