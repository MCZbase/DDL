
  CREATE OR REPLACE TRIGGER "CF_REPORT_SQL_KEY" 
BEFORE INSERT ON cf_report_sql
FOR EACH ROW
BEGIN
    IF :NEW.report_id IS NULL THEN
        SELECT somerandomsequence.NEXTVAL INTO :new.report_id FROM dual;
    END IF;
END;


ALTER TRIGGER "CF_REPORT_SQL_KEY" ENABLE