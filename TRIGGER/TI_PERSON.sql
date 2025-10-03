
  CREATE OR REPLACE EDITIONABLE TRIGGER "TI_PERSON" after INSERT on Person for each row
-- ERwin Builtin Wed May 05 11:26:47 2004
-- INSERT trigger on Person
declare numrows INTEGER;
begin
    /* ERwin Builtin Wed May 05 11:26:47 2004 */
    /* Agent  Person ON CHILD INSERT RESTRICT */
    select count(*) into numrows
      from Agent
      where
        /* %JoinFKPK(:%New,Agent," = "," and") */
        :new.Person_id = Agent.Agent_id;
    if (
      /* %NotnullFK(:%New," is not null and") */

      numrows = 0
    )
    then
      raise_application_error(
        -20002,
        'Cannot INSERT "Person" because "Agent" does not exist.'
      );
    end if;


-- ERwin Builtin Wed May 05 11:26:47 2004
end;




ALTER TRIGGER "TI_PERSON" ENABLE