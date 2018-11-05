
  CREATE OR REPLACE TRIGGER "TI_ENCUMBRANCE" after INSERT on Encumbrance for each row
-- ERwin Builtin Wed May 05 11:26:47 2004
-- INSERT trigger on Encumbrance
declare numrows INTEGER;
begin
    /* ERwin Builtin Wed May 05 11:26:47 2004 */
    /* Agent R/626 Encumbrance ON CHILD INSERT RESTRICT */
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
        -20002,
        'Cannot INSERT "Encumbrance" because "Agent" does not exist.'
      );
    end if;


-- ERwin Builtin Wed May 05 11:26:47 2004
end;



ALTER TRIGGER "TI_ENCUMBRANCE" ENABLE