
  CREATE OR REPLACE EDITIONABLE TRIGGER "OTHER_ID_CT_CHECK" BEFORE
INSERT
OR UPDATE ON "MCZBASE"."COLL_OBJ_OTHER_ID_NUM" REFERENCING OLD AS OLD NEW AS NEW FOR EACH ROW declare
numrows number;
collectionCode varchar2(20);
BEGIN
execute immediate 'SELECT COUNT(*)
        FROM ctcoll_other_id_type
        WHERE other_id_type = ''' || :NEW.other_id_type || '''' INTO numrows ;
IF (numrows = 0) THEN
raise_application_error(
-20001,
'Invalid other ID type');
END IF;
END;


ALTER TRIGGER "OTHER_ID_CT_CHECK" ENABLE