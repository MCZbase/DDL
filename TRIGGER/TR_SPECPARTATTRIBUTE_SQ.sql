
  CREATE OR REPLACE EDITIONABLE TRIGGER "TR_SPECPARTATTRIBUTE_SQ" 
    BEFORE INSERT ON specimen_part_attribute
    FOR EACH ROW
    BEGIN
        if :new.part_attribute_id is null then
        	select sq_part_attribute_id.nextval into :new.part_attribute_id from dual;
        end if;
    end;


ALTER TRIGGER "TR_SPECPARTATTRIBUTE_SQ" ENABLE