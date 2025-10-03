
  CREATE OR REPLACE EDITIONABLE TRIGGER "TR_AGENT_NAME_BIUD" 
BEFORE INSERT OR UPDATE OR DELETE ON agent_name
FOR EACH ROW 
DECLARE 
	pragma autonomous_transaction;
	c number;
BEGIN
	IF INSERTING THEN
		SELECT COUNT(*) INTO c
		FROM agent_name
		WHERE agent_id = :NEW.agent_id
		and agent_name_type = 'preferred';
		IF :NEW.agent_name_type = 'preferred' THEN
			c := c + 1; -- pre-transaction value plus the new value we're trying to insert
		END IF;
		IF c != 1 THEN
		    RAISE_APPLICATION_ERROR(
			    -20001,
			    'FAIL: You are trying to make ' || c || ' preferred names!');
		END IF;
	ELSIF UPDATING ('AGENT_NAME_TYPE') THEN
		IF (:NEW.agent_name_type = 'preferred' AND :OLD.agent_name_type != 'preferred')
		    OR (:NEW.agent_name_type != 'preferred' AND :OLD.agent_name_type = 'preferred')
		THEN -- only care if they're trying to update preferred to another name type, or another type to preferred
			RAISE_APPLICATION_ERROR(
			    -20001,
			    'FAIL: no switching!');
		END IF;
	ELSIF DELETING THEN -- since we never let them create >1 preferred, don't ever let them delete the preferred
		IF :OLD.agent_name_type = 'preferred' THEN
			RAISE_APPLICATION_ERROR(
			    -20001,
			    'FAIL: no deleting preferred names!');
		END IF;
    END IF;
END;


ALTER TRIGGER "TR_AGENT_NAME_BIUD" ENABLE