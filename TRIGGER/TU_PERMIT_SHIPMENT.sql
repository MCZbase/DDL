
  CREATE OR REPLACE TRIGGER "TU_PERMIT_SHIPMENT" after UPDATE on Permit_Shipment for each row
-- ERwin Builtin Wed May 05 11:26:47 2004
-- UPDATE trigger on Permit_Shipment
declare numrows INTEGER;
begin
  /* ERwin Builtin Wed May 05 11:26:47 2004 */
  /* Permit R/207 Permit_Shipment ON CHILD UPDATE RESTRICT */
  select count(*) into numrows
    from Permit
    where
      /* %JoinFKPK(:%New,Permit," = "," and") */
      :new.Permit_id = Permit.Permit_id;
  if (
    /* %NotnullFK(:%New," is not null and") */

    numrows = 0
  )
  then
    raise_application_error(
      -20007,
      'Cannot UPDATE "Permit_Shipment" because "Permit" does not exist.'
    );
  end if;


-- ERwin Builtin Wed May 05 11:26:47 2004
end;



ALTER TRIGGER "TU_PERMIT_SHIPMENT" ENABLE