
  CREATE OR REPLACE EDITIONABLE TRIGGER "TU_CLOSED_DATE" before UPDATE on loan for each row
begin
if :old.loan_status <> :new.loan_status and :new.loan_status = 'closed' 
then :new.closed_date := SYSDATE;
:NEW.closed_BY := SYS_CONTEXT('USERENV','SESSION_USER');
end if;
end;

ALTER TRIGGER "TU_CLOSED_DATE" ENABLE