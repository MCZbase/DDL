
  CREATE OR REPLACE TRIGGER "TU_BORROW_RETURNED" before UPDATE on BORROW for each row
begin
if :old.lenders_invoice_returned_fg <> :new.lenders_invoice_returned_fg and :new.lenders_invoice_returned_fg = 1
then :new.return_acknowledged_date := SYSDATE;
:NEW.ret_acknowledged_BY := SYS_CONTEXT('USERENV','SESSION_USER');
end if;
end;
ALTER TRIGGER "TU_BORROW_RETURNED" ENABLE