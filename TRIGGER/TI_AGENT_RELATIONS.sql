
  CREATE OR REPLACE TRIGGER "TI_AGENT_RELATIONS" after INSERT on Agent_Relations for each row
-- ERwin Builtin Mon May 17 12:58:26 2004
-- INSERT trigger on Agent_Relations
declare numrows INTEGER;
begin
    /* ERwin Builtin Mon May 17 12:58:26 2004 */
    /* Agent R/479 Agent_Relations ON CHILD INSERT RESTRICT */
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
        -20002,
        'Cannot INSERT "Agent_Relations" because "Agent" does not exist.'
      );
    end if;

    /* ERwin Builtin Mon May 17 12:58:26 2004 */
    /* Agent R/478 Agent_Relations ON CHILD INSERT RESTRICT */
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
        -20002,
        'Cannot INSERT "Agent_Relations" because "Agent" does not exist.'
      );
    end if;


-- ERwin Builtin Mon May 17 12:58:26 2004
end;



ALTER TRIGGER "TI_AGENT_RELATIONS" ENABLE