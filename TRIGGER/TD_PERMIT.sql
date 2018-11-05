
  CREATE OR REPLACE TRIGGER "TD_PERMIT" after DELETE on Permit for each row
-- ERwin Builtin Wed May 05 11:26:47 2004
-- DELETE trigger on Permit
declare numrows INTEGER;
begin
    /* ERwin Builtin Wed May 05 11:26:47 2004 */
    /* Permit R/208 Permit_Trans ON PARENT DELETE RESTRICT */
    select count(*) into numrows
      from Permit_Trans
      where
        /*  %JoinFKPK(Permit_Trans,:%Old," = "," and") */
        Permit_Trans.Permit_id = :old.Permit_id;
    if (numrows > 0)
    then
      raise_application_error(
        -20001,
        'Cannot DELETE "Permit" because "Permit_Trans" exists.'
      );
    end if;

    /* ERwin Builtin Wed May 05 11:26:47 2004 */
    /* Permit R/207 Permit_Shipment ON PARENT DELETE RESTRICT */
    select count(*) into numrows
      from Permit_Shipment
      where
        /*  %JoinFKPK(Permit_Shipment,:%Old," = "," and") */
        Permit_Shipment.Permit_id = :old.Permit_id;
    if (numrows > 0)
    then
      raise_application_error(
        -20001,
        'Cannot DELETE "Permit" because "Permit_Shipment" exists.'
      );
    end if;


-- ERwin Builtin Wed May 05 11:26:47 2004
end;



ALTER TRIGGER "TD_PERMIT" ENABLE