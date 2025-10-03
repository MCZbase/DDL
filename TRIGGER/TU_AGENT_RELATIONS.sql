
  CREATE OR REPLACE EDITIONABLE TRIGGER "TU_AGENT_RELATIONS" after UPDATE on Agent_Relations for each row
-- ERwin Builtin Wed May 05 11:26:47 2004
-- UPDATE trigger on Agent_Relations
declare numrows INTEGER;
begin
  /* ERwin Builtin Wed May 05 11:26:47 2004 */
  /* Agent R/479 Agent_Relations ON CHILD UPDATE RESTRICT */
  select count(*) into numrows
    from Agent
    where
      /* %JoinFKPK(:%New,Agent," = "," and") */
      :new.Related_Agent_id = Agent.Agent_id;
  if (
    /* %NotnullFK(:%New," is not null and") */

    numrows = 0
  )
  then
    raise_application_error(
      -20007,
      'Cannot UPDATE "Agent_Relations" because "Agent" does not exist.'
    );
  end if;

  /* ERwin Builtin Wed May 05 11:26:47 2004 */
  /* Agent R/478 Agent_Relations ON CHILD UPDATE RESTRICT */
  select count(*) into numrows
    from Agent
    where
      /* %JoinFKPK(:%New,Agent," = "," and") */
      :new.Agent_id = Agent.Agent_id;
  if (
    /* %NotnullFK(:%New," is not null and") */

    numrows = 0
  )
  then
    raise_application_error(
      -20007,
      'Cannot UPDATE "Agent_Relations" because "Agent" does not exist.'
    );
  end if;


-- ERwin Builtin Wed May 05 11:26:47 2004
end;




ALTER TRIGGER "TU_AGENT_RELATIONS" ENABLE