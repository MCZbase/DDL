
  CREATE OR REPLACE EDITIONABLE TRIGGER "TAG_SEQ" before insert ON tag for each row
   begin
       IF :new.tag_id IS NULL THEN
           select sq_tag_id.nextval into :new.tag_id from dual;
       END IF;
   end;


ALTER TRIGGER "TAG_SEQ" ENABLE