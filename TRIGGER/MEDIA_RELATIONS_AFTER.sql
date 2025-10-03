
  CREATE OR REPLACE EDITIONABLE TRIGGER "MEDIA_RELATIONS_AFTER" AFTER insert OR UPDATE OR DELETE ON media_relations
    for each row
    declare
    numrows number := 0;
    tabl VARCHAR2(38);
    colName VARCHAR2(38);
    fkname VARCHAR2(38);
    sqlstr VARCHAR2(4000);

BEGIN
 IF inserting THEN
     tabl := upper(SUBSTR(:NEW.media_relationship,instr(:NEW.media_relationship,' ',-1)+1));
     fkname:='CFK_' || tabl;
     sqlstr:='INSERT INTO tab_media_rel_fkey (media_relations_id,' || fkname || ') VALUES (';
     sqlstr:=sqlstr || :NEW.media_relations_id || ',' || :NEW.related_primary_key || ')';
     EXECUTE IMMEDIATE sqlstr;
 ELSIF updating THEN
     IF :NEW.related_primary_key != :OLD.related_primary_key THEN
         tabl := upper(SUBSTR(:NEW.media_relationship,instr(:NEW.media_relationship,' ',-1)+1));
         fkname:='CFK_' || tabl;
         DELETE FROM tab_media_rel_fkey WHERE media_relations_id=:NEW.media_relations_id;
         sqlstr:='INSERT INTO tab_media_rel_fkey (media_relations_id,' || fkname || ') VALUES (';
         sqlstr:=sqlstr || :NEW.media_relations_id || ',' || :NEW.related_primary_key || ')';
         EXECUTE IMMEDIATE sqlstr;
     END IF;
        ELSIF deleting THEN
     DELETE FROM tab_media_rel_fkey WHERE media_relations_id=:OLD.media_relations_id;
        END IF;
END;


ALTER TRIGGER "MEDIA_RELATIONS_AFTER" ENABLE