
  CREATE OR REPLACE TRIGGER "TR_TAXON_HABITAT_SQ" before insert ON taxon_habitat
for each row
begin
    IF :new.taxon_habitat_id IS NULL THEN
        select sq_taxon_habitat_id.nextval
        into :new.taxon_habitat_id from dual;
    END IF;
end;
ALTER TRIGGER "TR_TAXON_HABITAT_SQ" ENABLE