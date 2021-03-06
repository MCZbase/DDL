
  CREATE OR REPLACE TRIGGER "SPECIMEN_ANNOTATIONS_KEY" 
BEFORE INSERT ON specimen_annotations
FOR EACH ROW
BEGIN
    IF :new.annotation_id IS NULL THEN
        SELECT specimen_annotations_seq.nextval
        INTO :new.annotation_id
        FROM dual;
    END IF;
    IF :new.annotate_date IS NULL THEN
        :new.annotate_date := sysdate;
    END IF;
END;


ALTER TRIGGER "SPECIMEN_ANNOTATIONS_KEY" ENABLE