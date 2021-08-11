
  CREATE OR REPLACE TRIGGER "TR_BI_AGENT_RELATIONS" 
   before insert on "MCZBASE"."AGENT_RELATIONS" 
   for each row 
begin  
   if inserting then 
      if :NEW."AGENT_RELATIONS_ID" is null then 
         select SQ_AGENT_RELATIONS_ID.nextval into :NEW."AGENT_RELATIONS_ID" from dual; 
      end if; 
   end if; 
end;
ALTER TRIGGER "TR_BI_AGENT_RELATIONS" ENABLE