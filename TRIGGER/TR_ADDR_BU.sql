
  CREATE OR REPLACE EDITIONABLE TRIGGER "TR_ADDR_BU" BEFORE UPDATE ON "MCZBASE"."ADDR"
FOR EACH ROW
DECLARE
    ship INTEGER;
    corr INTEGER;
	new_data VARCHAR2(4000);
	old_data VARCHAR2(4000);
BEGIN
	SELECT :OLD.addr_id || :OLD.street_addr1 || :OLD.street_addr2 || 
		:OLD.city ||:OLD.state || :OLD.zip || :OLD.country_cde || 
		:OLD.mail_stop || :OLD.agent_id || :OLD.addr_type || 
		:OLD.job_title || :OLD.institution || :OLD.department
    INTO old_data FROM dual;
	SELECT :NEW.addr_id || :NEW.street_addr1 || :NEW.street_addr2 || 
		:NEW.city || :NEW.state || :NEW.zip || :NEW.country_cde || 
		:NEW.mail_stop || :NEW.agent_id || :NEW.addr_type || 
		:NEW.job_title || :NEW.institution || :NEW.department
    INTO new_data FROM dual;
    dbms_output.put_line('OLD: ' || old_data);
    dbms_output.put_line('NEW: ' || new_data);
    IF old_data != new_data THEN
		SELECT COUNT(*) INTO ship
		FROM shipment
		WHERE shipped_to_addr_id = :OLD.addr_id;
		SELECT COUNT(*) INTO corr
		FROM correspondence
		WHERE to_agent_addr_id = :OLD.addr_id;
	    dbms_output.put_line('SHIP: ' || ship);
	    dbms_output.put_line('CORR: ' || corr);
		IF (ship > 0 OR corr > 0) THEN
			-- if we made it here we want to create a new record
			-- call procedure for autonomous transaction
			add_new_addr(
				:NEW.street_addr1,
				:NEW.street_addr2,
				:NEW.city,
				:NEW.state,
				:NEW.zip,
				:NEW.country_cde,
				:NEW.mail_stop,
				:NEW.agent_id,
				:NEW.addr_type,
				:NEW.job_title,
				:NEW.addr_remarks,
				:NEW.institution,
				:NEW.department);
			-- now that we've used the changes to create a new record,
			--   1) set valid_addr_fg = 0 and
			--   2) replace :NEW values with :OLD ones
			-- so that we don't update anything for the existing used record.
			-- formatted_addr gets updated by trigger BUILD_FORMATTED_ADDR
            -- but, this gets done with NEW values, so need to replace 
            -- formatted_addr with the OLD value to prevent this update.
			:NEW.valid_addr_fg := 0;
			:NEW.street_addr1 := :OLD.street_addr1;
			:NEW.street_addr2 := :OLD.street_addr2;
			:NEW.city := :OLD.city;
			:NEW.state := :OLD.state;
			:NEW.zip := :OLD.zip;
			:NEW.country_cde := :OLD.country_cde;
			:NEW.mail_stop := :OLD.mail_stop;
			:NEW.agent_id := :OLD.agent_id;
			:NEW.addr_type := :OLD.addr_type;
			:NEW.job_title := :OLD.job_title;
			:NEW.addr_remarks := :OLD.addr_remarks;
			:NEW.institution := :OLD.institution;
			:NEW.department := :OLD.department;
            :NEW.formatted_addr := :OLD.formatted_addr;
		END IF;
	END IF;
END;

ALTER TRIGGER "TR_ADDR_BU" ENABLE