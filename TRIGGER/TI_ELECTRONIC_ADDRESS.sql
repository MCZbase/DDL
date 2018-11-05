
  CREATE OR REPLACE TRIGGER "TI_ELECTRONIC_ADDRESS" after INSERT on Electronic_Address for each row
-- ERwin Builtin Wed May 05 11:26:47 2004
-- INSERT trigger on Electronic_Address
declare numrows INTEGER;
begin
    /* ERwin Builtin Wed May 05 11:26:47 2004 */
    /* Agent R/490 Electronic_Address ON CHILD INSERT RESTRICT */
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
        'Cannot INSERT "Electronic_Address" because "Agent" does not exist.'
      );
    end if;


-- ERwin Builtin Wed May 05 11:26:47 2004
end;



ALTER TRIGGER "TI_ELECTRONIC_ADDRESS" ENABLE