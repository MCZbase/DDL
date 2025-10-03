
  CREATE OR REPLACE EDITIONABLE TRIGGER "PUBLICATION_ATTRIBUTES_KEY" 
 before insert  ON publication_attributes
 for each row
    begin
    if :NEW.publication_attribute_id is null then
    select sq_publication_attribute_id.nextval into :new.publication_attribute_id from dual;
    end if;
    end;


ALTER TRIGGER "PUBLICATION_ATTRIBUTES_KEY" ENABLE