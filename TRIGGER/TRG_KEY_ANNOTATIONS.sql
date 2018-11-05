
  CREATE OR REPLACE TRIGGER "TRG_KEY_ANNOTATIONS" 
    BEFORE INSERT OR UPDATE ON annotations
    FOR EACH ROW
    BEGIN
        if :new.ANNOTATION_ID is null then
        select sq_annotation_id.nextval into :new.ANNOTATION_ID from dual;
        end if;
    end;

ALTER TRIGGER "TRG_KEY_ANNOTATIONS" ENABLE