
  CREATE OR REPLACE TRIGGER "TR_MEDIA_SQ" before insert ON media
for each row
begin
    IF :new.media_id IS NULL THEN
        select sq_media_id.nextval
        into :new.media_id from dual;
    END IF;
end;

ALTER TRIGGER "TR_MEDIA_SQ" ENABLE