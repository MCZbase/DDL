
  CREATE OR REPLACE EDITIONABLE TRIGGER "TR_MEDIA_TECH_METADATA_SQ" before insert ON media_tech_metadata
for each row
begin
    IF :new.MEDIA_TECH_METADATA_id IS NULL THEN
        select SQ_MEDIA_TECH_METADATA_ID.nextval
        into :new.MEDIA_TECH_METADATA_id from dual;
    END IF;
end;

ALTER TRIGGER "TR_MEDIA_TECH_METADATA_SQ" ENABLE