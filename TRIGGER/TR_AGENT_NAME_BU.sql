
  CREATE OR REPLACE TRIGGER "TR_AGENT_NAME_BU" 
BEFORE UPDATE ON AGENT_NAME
FOR EACH ROW
DECLARE numrows INTEGER;
BEGIN
    SELECT COUNT(*) INTO numrows
	FROM PUBLICATION_AUTHOR_NAME
	WHERE AGENT_NAME_ID = :OLD.AGENT_NAME_ID;
    IF (numrows > 0) THEN
        RAISE_APPLICATION_ERROR(
    	-20001,
		'Cannot UPDATE an agent name used as a publication author.');
    end if;
    SELECT COUNT(*) INTO numrows
	FROM PROJECT_AGENT
	WHERE AGENT_NAME_ID = :OLD.AGENT_NAME_ID;
    IF (numrows > 0) THEN
        RAISE_APPLICATION_ERROR(
    	-20001,
		'Cannot UPDATE an agent name used as a project agent.');
    end if;
    SELECT COUNT(*) INTO numrows
	FROM PROJECT_SPONSOR
	WHERE AGENT_NAME_ID = :OLD.AGENT_NAME_ID;
    IF (numrows > 0) THEN
        RAISE_APPLICATION_ERROR(
    	-20001,
		'Cannot UPDATE an agent name used as a project sponsor.');
    end if;
END;

ALTER TRIGGER "TR_AGENT_NAME_BU" DISABLE