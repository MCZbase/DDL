
  CREATE OR REPLACE TRIGGER "TR_SPEC_PART_PRES_REM_AIU" AFTER UPDATE OR INSERT ON COLL_OBJECT_REMARK
FOR EACH ROW
DECLARE
    usrid NUMBER;
    cnt NUMBER;
    curr_remarks varchar2(4000);
    chngdate date;
    currhisrec number;
BEGIN
    SELECT COUNT(*) INTO cnt
    FROM agent_name
    WHERE agent_name_type = 'login'
    AND upper(agent_name.agent_name) = SYS_CONTEXT('USERENV','SESSION_USER');
    IF cnt=1 THEN
        SELECT agent_id INTO usrid
        FROM agent_name
        WHERE agent_name_type = 'login'
        AND upper(agent_name.agent_name) = SYS_CONTEXT('USERENV','SESSION_USER');
    ELSE
        usrid:=0;
    END IF;
    SELECT COUNT(*) into cnt FROM SPECIMEN_PART where collection_object_id = :NEW.collection_object_id;
    If cnt = 1 then
      select coll_object_remarks, changed_date, specimen_part_pres_hist_ID into curr_remarks, chngdate, currhisrec from specimen_part_pres_hist where collection_object_id = :NEW.collection_object_id and is_current_fg=1;
      if nvl(curr_remarks,1) <> NVL(:NEW.COLL_OBJECT_REMARKS,1) then
        if (sysdate - chngdate)*24*60*60 < 10 then
          update specimen_part_pres_hist set coll_object_remarks = :NEW.COLL_OBJECT_REMARKS where specimen_part_pres_hist_ID = currhisrec;
        else
          update specimen_part_pres_hist set is_current_fg = 0 where specimen_part_pres_hist_id = currhisrec;
          insert into specimen_part_pres_hist(specimen_part_pres_hist_ID, collection_object_id, part_name, sampled_from_obj_id, preserve_method, derived_from_cat_item, changed_agent_id, changed_date, coll_object_remarks, is_current_fg, lot_count, lot_count_modifier)
          select SQ_SPECIMEN_PART_PRES_HIST_ID.nextval, collection_object_id, part_name, sampled_from_obj_id, preserve_method, derived_from_cat_item, usrid, sysdate, :new.coll_object_remarks, 1, lot_count, lot_count_modifier from specimen_part_pres_hist where specimen_part_pres_hist_ID=currhisrec;
        end if;
      end if;
    END IF;
EXCEPTION
    WHEN DUP_VAL_ON_INDEX THEN
        NULL; -- just ignore
END;
ALTER TRIGGER "TR_SPEC_PART_PRES_REM_AIU" ENABLE