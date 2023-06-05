
  CREATE OR REPLACE TRIGGER "TRG_PK_EXTERNAL_RESOURCE_REL" 
   before insert on "MCZBASE"."EXTERNAL_RESOURCE_RELATION" 
   for each row 
declare l_sysguid varchar2(32);   
begin  
   if inserting then 
      -- set primary key value
      if :NEW."EXTERNAL_RESOURCE_RELATION_ID" is null then 
         select SEQ_EXTERNAL_RESOURCE_REL_PK.nextval into :NEW."EXTERNAL_RESOURCE_RELATION_ID" from dual; 
      end if; 
      -- assign a UUID as the dwc:resourceRelationshipID
      if :NEW."RESOURCE_RELATIONSHIP_ID" is null then 
         select lower(sys_guid()) into l_sysguid from dual;
         select 
            'urn:uuid:' ||
            substr(l_sysguid, 1, 8)  || '-' ||
            substr(l_sysguid, 9, 4)  || '-' ||
            substr(l_sysguid, 10, 4) || '-' ||
            substr(l_sysguid, 15, 4) || '-' ||
            substr(l_sysguid, 20, 12)
         into :NEW."RESOURCE_RELATIONSHIP_ID" from dual; 
      end if; 
   end if; 
end;
ALTER TRIGGER "TRG_PK_EXTERNAL_RESOURCE_REL" ENABLE