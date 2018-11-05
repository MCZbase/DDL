
  CREATE OR REPLACE TRIGGER "TRG_KEY_SHIPMENT" 
    BEFORE INSERT OR UPDATE ON shipment
    FOR EACH ROW
    BEGIN
        if :new.shipment_id is null then
        select sq_shipment_id.nextval into :new.shipment_id from dual;
        end if;
    end;

ALTER TRIGGER "TRG_KEY_SHIPMENT" ENABLE