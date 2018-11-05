
  CREATE OR REPLACE TRIGGER "TU_ENCUMBRANCE" after UPDATE on Encumbrance for each row
-- ERwin Builtin Wed May 05 11:26:47 2004
-- UPDATE trigger on Encumbrance
declare numrows INTEGER;
begin
  /* ERwin Builtin Wed May 05 11:26:47 2004 */
  /* Encumbrance R/625 Coll_Object_Encumbrance ON PARENT UPDATE RESTRICT */
  if
    /* %JoinPKPK(:%Old,:%New," <> "," or ") */
    :old.Encumbrance_id <> :new.Encumbrance_id
  then
    select count(*) into numrows
      from Coll_Object_Encumbrance
      where
        /*  %JoinFKPK(Coll_Object_Encumbrance,:%Old," = "," and") */
        Coll_Object_Encumbrance.Encumbrance_id = :old.Encumbrance_id;
    if (numrows > 0)
    then
      raise_application_error(
        -20005,
        'Cannot UPDATE "Encumbrance" because "Coll_Object_Encumbrance" exists.'
      );
    end if;
  end if;

  /* ERwin Builtin Wed May 05 11:26:47 2004 */
  /* Agent R/626 Encumbrance ON CHILD UPDATE RESTRICT */
  select count(*) into numrows
    from Agent
    where
      /* %JoinFKPK(:%New,Agent," = "," and") */
      :new.Encumbering_Agent_id = Agent.Agent_id;
  if (
    /* %NotnullFK(:%New," is not null and") */

    numrows = 0
  )
  then
    raise_application_error(
      -20007,
      'Cannot UPDATE "Encumbrance" because "Agent" does not exist.'
    );
  end if;


-- ERwin Builtin Wed May 05 11:26:47 2004
end;



ALTER TRIGGER "TU_ENCUMBRANCE" ENABLE