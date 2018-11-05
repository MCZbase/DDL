
  CREATE OR REPLACE TRIGGER "SEQ_PUBLICATION_AUTHOR_NAME" 
 before insert  ON publication_author_name
 for each row
    begin
    if :NEW.publication_author_name_id is null then
    select sq_publication_author_name_id.nextval into :new.publication_author_name_id from dual;
    end if;
    end;

ALTER TRIGGER "SEQ_PUBLICATION_AUTHOR_NAME" ENABLE