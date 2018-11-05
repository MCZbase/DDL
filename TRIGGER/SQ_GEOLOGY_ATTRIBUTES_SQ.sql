
  CREATE OR REPLACE TRIGGER "SQ_GEOLOGY_ATTRIBUTES_SQ" before insert ON geology_attributes
for each row
begin
    IF :new.geology_attribute_id IS NULL THEN
        select sq_geology_attribute_id.nextval
        into :new.geology_attribute_id
        from dual;
    END IF;
end;

ALTER TRIGGER "SQ_GEOLOGY_ATTRIBUTES_SQ" ENABLE