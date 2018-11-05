
  CREATE OR REPLACE TRIGGER "LOG_LOGINS" 
AFTER update OR INSERT ON cf_users
FOR EACH ROW
BEGIN
	IF :new.last_login != :old.last_login THEN
    insert into logins(username, last_login)
    values(:new.username, :new.last_login);
	END IF;
END;
ALTER TRIGGER "LOG_LOGINS" ENABLE