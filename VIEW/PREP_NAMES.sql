
  CREATE OR REPLACE FORCE VIEW "PREP_NAMES" ("COLLECTION_OBJECT_ID", "AGENT_NAME", "COLL_ORDER") AS 
  SELECT collection_object_id, agent_name, coll_order
			FROM collector, preferred_agent_name WHERE
			preferred_agent_name.agent_id = collector.agent_id AND
			collector.collector_role='p'
 