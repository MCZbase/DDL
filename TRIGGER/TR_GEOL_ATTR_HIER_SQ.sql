
  CREATE OR REPLACE EDITIONABLE TRIGGER "TR_GEOL_ATTR_HIER_SQ" before insert ON geology_attribute_hierarchy
for each row
begin
    IF :new.geology_attribute_hierarchy_id IS NULL THEN
        select sq_geology_attribute_hier_id.nextval
        into :new.geology_attribute_hierarchy_id
        from dual;
    END IF;
end;


ALTER TRIGGER "TR_GEOL_ATTR_HIER_SQ" ENABLE