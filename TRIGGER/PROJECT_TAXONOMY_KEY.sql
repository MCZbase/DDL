
  CREATE OR REPLACE EDITIONABLE TRIGGER "PROJECT_TAXONOMY_KEY" 
 before insert  ON project_taxonomy
 for each row
    begin
    if :NEW.project_taxon_id is null then
    select sq_project_taxon_id.nextval into :new.project_taxon_id from dual;
    end if;
    end;


ALTER TRIGGER "PROJECT_TAXONOMY_KEY" ENABLE