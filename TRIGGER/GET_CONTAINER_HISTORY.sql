
  CREATE OR REPLACE TRIGGER "GET_CONTAINER_HISTORY" 
AFTER UPDATE ON container
FOR EACH ROW
DECLARE isAlreadyThere NUMBER;

BEGIN

SELECT count(*) INTO isAlreadyThere FROM container_history WHERE
	container_id = :OLD.container_id AND
	parent_container_id = :OLD.parent_container_id AND
	install_date = :OLD.parent_install_date
	;
	IF isAlreadyThere = 0 THEN
		INSERT INTO container_history (container_id, parent_container_id, install_date)
		VALUES(:Old.container_id, :Old.parent_container_id, :Old.parent_install_date);
	END IF;
END get_container_history;

ALTER TRIGGER "GET_CONTAINER_HISTORY" ENABLE