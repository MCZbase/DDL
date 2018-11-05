
  CREATE OR REPLACE TRIGGER "TR_CONTAINER_CHECK_BI_SQ" before insert ON container_check
for each row
begin
    if :NEW.container_check_id is null then
        select sq_container_check_id.nextval
        into :new.container_check_id from dual;
    end if;
    if :NEW.check_date is null then
        :NEW.check_date:= sysdate;
    end if;
end;

ALTER TRIGGER "TR_CONTAINER_CHECK_BI_SQ" ENABLE