
  CREATE OR REPLACE EDITIONABLE TRIGGER "TI_PERMIT" after INSERT on Permit for each row
-- ERwin Builtin Wed May 05 11:26:47 2004
-- INSERT trigger on Permit
declare numrows INTEGER;
begin
    /* ERwin Builtin Wed May 05 11:26:47 2004 */
    /* Agent R/577 Permit ON CHILD INSERT RESTRICT */
    select count(*) into numrows
      from Agent
      where
        /* %JoinFKPK(:%New,Agent," = "," and") */
        :new.Issued_To_Agent_id = Agent.Agent_id;
    if (
      /* %NotnullFK(:%New," is not null and") */

      numrows = 0
    )
    then
      raise_application_error(
        -20002,
        'Cannot INSERT "Permit" because "Agent" does not exist.'
      );
    end if;

    /* ERwin Builtin Wed May 05 11:26:47 2004 */
    /* Agent R/576 Permit ON CHILD INSERT RESTRICT */
    select count(*) into numrows
      from Agent
      where
        /* %JoinFKPK(:%New,Agent," = "," and") */
        :new.Issued_By_Agent_id = Agent.Agent_id;
    if (
      /* %NotnullFK(:%New," is not null and") */

      numrows = 0
    )
    then
      raise_application_error(
        -20002,
        'Cannot INSERT "Permit" because "Agent" does not exist.'
      );
    end if;


-- ERwin Builtin Wed May 05 11:26:47 2004
end;




ALTER TRIGGER "TI_PERMIT" ENABLE