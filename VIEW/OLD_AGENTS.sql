
  CREATE OR REPLACE FORCE VIEW "OLD_AGENTS" ("AGENT_NAME_ID", "AGENT_ID", "AGENT_NAME_TYPE", "DONOR_CARD_PRESENT_FG", "AGENT_NAME") AS 
  select "AGENT_NAME_ID","AGENT_ID","AGENT_NAME_TYPE","DONOR_CARD_PRESENT_FG","AGENT_NAME" from agent_name
 