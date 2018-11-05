
  CREATE OR REPLACE TRIGGER "TR_TRANS_AGENT_BUIPA" 
BEFORE UPDATE OR INSERT ON TRANS_AGENT
FOR EACH ROW
DECLARE 
    numrows NUMBER;
	pragma autonomous_transaction;
BEGIN
    IF :new.trans_agent_role IN ('entered by','in-house contact','outside contact') THEN
        IF (inserting
            OR (updating
                AND (:new.trans_agent_role != :old.trans_agent_role
                    OR :new.transaction_id != :old.transaction_id)
            ) 
        ) THEN
            SELECT COUNT(*) INTO numrows
	        FROM trans_agent
	        WHERE transaction_id=:new.transaction_id
	        AND trans_agent_role = :new.trans_agent_role;
        	IF (numrows > 0) THEN
	        	raise_application_error(
	    			-20001,
	    			'Only one agent in role ' || :new.trans_agent_role || ' is allowed per transaction.');
	        END IF;  
        END IF;
    END IF;
END;
ALTER TRIGGER "TR_TRANS_AGENT_BUIPA" ENABLE