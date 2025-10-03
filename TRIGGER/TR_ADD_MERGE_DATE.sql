
  CREATE OR REPLACE EDITIONABLE TRIGGER "TR_ADD_MERGE_DATE" before INSERT or UPDATE on Agent_Relations for each row
begin
if :new.agent_relationship = 'bad duplicate of' 
then :new.date_to_merge := SYSDATE + 7;
end if;
end;

ALTER TRIGGER "TR_ADD_MERGE_DATE" ENABLE