
  CREATE OR REPLACE TRIGGER "TR_CF_LOG_SQ" before insert ON cf_log
for each row
begin
	if :NEW.log_id is null then
                select sq_log_id.nextval into :new.log_id from dual;
        end if;
                if :NEW.access_date is null then
                :NEW.access_date:= sysdate;
        end if;
end;

ALTER TRIGGER "TR_CF_LOG_SQ" ENABLE