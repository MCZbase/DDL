
  CREATE OR REPLACE TRIGGER "CF_PW_CHANGE" 
BEFORE update OR INSERT ON cf_users
FOR EACH ROW
BEGIN
	IF :new.password != :old.password THEN
		:new.pw_change_date := SYSDATE;
	END IF;
END;

ALTER TRIGGER "CF_PW_CHANGE" ENABLE