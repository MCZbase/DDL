
  CREATE OR REPLACE TRIGGER "TR_SPEC_PART_LOT_COUNT_AIU" AFTER UPDATE OR INSERT ON COLL_OBJECT
FOR EACH ROW
DECLARE
    usrid NUMBER;
    cnt NUMBER;
    curr_count number;
    curr_count_mod varchar2(5);
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
      select lot_count, lot_count_modifier, changed_date, specimen_part_pres_hist_ID into curr_count, curr_count_mod, chngdate, currhisrec from specimen_part_pres_hist where collection_object_id = :NEW.collection_object_id and is_current_fg=1;
      if nvl(curr_count,-1) <> NVL(:NEW.LOT_COUNT,-1) or nvl(curr_count_mod,'X') <> NVL(:NEW.LOT_COUNT_MODIFIER,'X')then
        if (sysdate - chngdate)*24*60*60 < 10 then
          update specimen_part_pres_hist set lot_count = :NEW.LOT_COUNT, lot_count_modifier = :NEW.LOT_COUNT_MODIFIER where specimen_part_pres_hist_ID = currhisrec;
        else
          update specimen_part_pres_hist set is_current_fg = 0 where specimen_part_pres_hist_id = currhisrec;
          insert into specimen_part_pres_hist(specimen_part_pres_hist_ID, collection_object_id, part_name, sampled_from_obj_id, preserve_method, derived_from_cat_item, changed_agent_id, changed_date, coll_object_remarks, is_current_fg, lot_count, lot_count_modifier)
          select SQ_SPECIMEN_PART_PRES_HIST_ID.nextval, collection_object_id, part_name, sampled_from_obj_id, preserve_method, derived_from_cat_item, usrid, sysdate, coll_object_remarks, 1, :NEW.lot_count, :NEW.lot_count_modifier from specimen_part_pres_hist where specimen_part_pres_hist_ID=currhisrec;
        end if;
      end if;
    END IF;
EXCEPTION
    WHEN DUP_VAL_ON_INDEX THEN
        NULL; -- just ignore
END;
ALTER TRIGGER "TR_SPEC_PART_LOT_COUNT_AIU" ENABLE