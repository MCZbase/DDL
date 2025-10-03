
  CREATE OR REPLACE FORCE EDITIONABLE VIEW "PREFERRED_AGENT_NAME" ("AGENT_NAME", "AGENT_ID") AS 
  ( select agent_name, agent_id from agent_name where agent_name_type = 'preferred')
 