
  CREATE OR REPLACE TRIGGER "TI_PERMIT_SHIPMENT" after INSERT on Permit_Shipment for each row
-- ERwin Builtin Wed May 05 11:26:47 2004
-- INSERT trigger on Permit_Shipment
declare numrows INTEGER;
begin
    /* ERwin Builtin Wed May 05 11:26:47 2004 */
    /* Permit R/207 Permit_Shipment ON CHILD INSERT RESTRICT */
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
        -20002,
        'Cannot INSERT "Permit_Shipment" because "Permit" does not exist.'
      );
    end if;


-- ERwin Builtin Wed May 05 11:26:47 2004
end;



ALTER TRIGGER "TI_PERMIT_SHIPMENT" ENABLE