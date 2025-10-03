
  CREATE OR REPLACE EDITIONABLE TRIGGER "CTSPECIMEN_PART_NAME_SEQ" before insert ON ctspecimen_part_name for each row
   begin
       IF :new.ctspnid IS NULL THEN
           select someRandomSequence.nextval into :new.ctspnid from dual;
       END IF;
   end;


ALTER TRIGGER "CTSPECIMEN_PART_NAME_SEQ" ENABLE