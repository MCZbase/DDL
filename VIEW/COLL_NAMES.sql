
  CREATE OR REPLACE FORCE EDITIONABLE VIEW "COLL_NAMES" ("COLLECTION_OBJECT_ID", "AGENT_NAME", "COLL_ORDER") AS 
  (
        select
                collection_object_id,
                agent_name,
                coll_order
               FROM
                collector,
                preferred_agent_name
                WHERE collector.agent_id = preferred_agent_name.agent_id and
                collector_role='c')
 