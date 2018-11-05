
  CREATE OR REPLACE TRIGGER "TR_CF_REPORT_SQL_SQ" 
before insert ON cf_report_sql
for each row
begin
    if :NEW.report_id is null then
        select SQ_REPORT_ID.nextval
        into :new.report_id from dual;
    end if;
end;

ALTER TRIGGER "TR_CF_REPORT_SQL_SQ" ENABLE