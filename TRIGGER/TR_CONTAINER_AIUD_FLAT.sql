
  CREATE OR REPLACE EDITIONABLE TRIGGER "TR_CONTAINER_AIUD_FLAT" 
FOR UPDATE OR DELETE ON "MCZBASE"."CONTAINER"
COMPOUND TRIGGER

  TYPE t_container_id_tab IS TABLE OF NUMBER;
  g_affected_containers t_container_id_tab := t_container_id_tab();

  BEFORE EACH ROW IS
  BEGIN
    IF :NEW.container_type NOT IN ('building', 'campus', 'floor', 'institution') THEN
      g_affected_containers.EXTEND;
      g_affected_containers(g_affected_containers.LAST) := :NEW.container_id;
    END IF;
  END BEFORE EACH ROW;

  AFTER STATEMENT IS
  BEGIN
    FOR i IN 1 .. g_affected_containers.COUNT LOOP
      -- For each affected container, update all relevant flat records
      UPDATE flat
         SET stale_flag = 1,
             lastuser = sys_context('USERENV', 'SESSION_USER'),
             lastdate = SYSDATE
       WHERE collection_object_id IN (
         SELECT sp.derived_from_cat_item
           FROM specimen_part sp
           JOIN coll_obj_cont_hist ch
             ON sp.collection_object_id = ch.collection_object_id
           WHERE ch.container_id IN (
             SELECT container_id
               FROM container
              START WITH container_id = g_affected_containers(i)
              CONNECT BY PRIOR container_id = parent_container_id
           )
             AND ch.current_container_fg = 1
       );
    END LOOP;
  END AFTER STATEMENT;

END TR_CONTAINER_AIUD_FLAT;

ALTER TRIGGER "TR_CONTAINER_AIUD_FLAT" ENABLE