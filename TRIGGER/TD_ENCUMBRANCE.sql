
  CREATE OR REPLACE EDITIONABLE TRIGGER "TD_ENCUMBRANCE" after DELETE on Encumbrance for each row
-- ERwin Builtin Wed May 05 11:26:47 2004
-- DELETE trigger on Encumbrance
declare numrows INTEGER;
begin
    /* ERwin Builtin Wed May 05 11:26:47 2004 */
    /* Encumbrance R/625 Coll_Object_Encumbrance ON PARENT DELETE RESTRICT */
    select count(*) into numrows
      from Coll_Object_Encumbrance
      where
        /*  %JoinFKPK(Coll_Object_Encumbrance,:%Old," = "," and") */
        Coll_Object_Encumbrance.Encumbrance_id = :old.Encumbrance_id;
    if (numrows > 0)
    then
      raise_application_error(
        -20001,
        'Cannot DELETE "Encumbrance" because "Coll_Object_Encumbrance" exists.'
      );
    end if;


-- ERwin Builtin Wed May 05 11:26:47 2004
end;




ALTER TRIGGER "TD_ENCUMBRANCE" ENABLE