
  CREATE OR REPLACE TRIGGER "TU_PERMIT" after UPDATE on Permit for each row
-- ERwin Builtin Wed May 05 11:26:47 2004
-- UPDATE trigger on Permit
declare numrows INTEGER;
begin
  /* ERwin Builtin Wed May 05 11:26:47 2004 */
  /* Permit R/208 Permit_Trans ON PARENT UPDATE RESTRICT */
  if
    /* %JoinPKPK(:%Old,:%New," <> "," or ") */
    :old.Permit_id <> :new.Permit_id
  then
    select count(*) into numrows
      from Permit_Trans
      where
        /*  %JoinFKPK(Permit_Trans,:%Old," = "," and") */
        Permit_Trans.Permit_id = :old.Permit_id;
    if (numrows > 0)
    then
      raise_application_error(
        -20005,
        'Cannot UPDATE "Permit" because "Permit_Trans" exists.'
      );
    end if;
  end if;

  /* ERwin Builtin Wed May 05 11:26:47 2004 */
  /* Permit R/207 Permit_Shipment ON PARENT UPDATE RESTRICT */
  if
    /* %JoinPKPK(:%Old,:%New," <> "," or ") */
    :old.Permit_id <> :new.Permit_id
  then
    select count(*) into numrows
      from Permit_Shipment
      where
        /*  %JoinFKPK(Permit_Shipment,:%Old," = "," and") */
        Permit_Shipment.Permit_id = :old.Permit_id;
    if (numrows > 0)
    then
      raise_application_error(
        -20005,
        'Cannot UPDATE "Permit" because "Permit_Shipment" exists.'
      );
    end if;
  end if;

  /* ERwin Builtin Wed May 05 11:26:47 2004 */
  /* Agent R/577 Permit ON CHILD UPDATE RESTRICT */
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
      -20007,
      'Cannot UPDATE "Permit" because "Agent" does not exist.'
    );
  end if;

  /* ERwin Builtin Wed May 05 11:26:47 2004 */
  /* Agent R/576 Permit ON CHILD UPDATE RESTRICT */
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
      -20007,
      'Cannot UPDATE "Permit" because "Agent" does not exist.'
    );
  end if;


-- ERwin Builtin Wed May 05 11:26:47 2004
end;



ALTER TRIGGER "TU_PERMIT" ENABLE