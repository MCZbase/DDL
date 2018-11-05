
  CREATE OR REPLACE TRIGGER "TR_SPECIMEN_ANNOTATIONS_SQ" before insert ON specimen_annotations
for each row
begin
    if :NEW.annotation_id is null then
        select sq_annotation_id.nextval
        into :new.annotation_id from dual;
    end if;

    if :NEW.annotate_date is null then
        :NEW.annotate_date := sysdate;
    end if;
end;

ALTER TRIGGER "TR_SPECIMEN_ANNOTATIONS_SQ" ENABLE