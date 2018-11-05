
  CREATE OR REPLACE TRIGGER "TI_COLL_OBJ_CONT_HIST" after INSERT on Coll_Obj_Cont_Hist for each row
-- ERwin Builtin Wed May 05 11:26:47 2004
-- INSERT trigger on Coll_Obj_Cont_Hist
declare numrows INTEGER;
begin
    /* ERwin Builtin Wed May 05 11:26:47 2004 */
    /* Coll_Object R/623 Coll_Obj_Cont_Hist ON CHILD INSERT RESTRICT */
    select count(*) into numrows
      from Coll_Object
      where
        /* %JoinFKPK(:%New,Coll_Object," = "," and") */
        :new.Collection_Object_id = Coll_Object.Collection_Object_id;
    if (
      /* %NotnullFK(:%New," is not null and") */

      numrows = 0
    )
    then
      raise_application_error(
        -20002,
        'Cannot INSERT "Coll_Obj_Cont_Hist" because "Coll_Object" does not exist.'
      );
    end if;

    /* ERwin Builtin Wed May 05 11:26:47 2004 */
    /* Container R/622 Coll_Obj_Cont_Hist ON CHILD INSERT RESTRICT */
    select count(*) into numrows
      from Container
      where
        /* %JoinFKPK(:%New,Container," = "," and") */
        :new.Container_id = Container.Container_id;
    if (
      /* %NotnullFK(:%New," is not null and") */

      numrows = 0
    )
    then
      raise_application_error(
        -20002,
        'Cannot INSERT "Coll_Obj_Cont_Hist" because "Container" does not exist.'
      );
    end if;


-- ERwin Builtin Wed May 05 11:26:47 2004
end;



ALTER TRIGGER "TI_COLL_OBJ_CONT_HIST" ENABLE