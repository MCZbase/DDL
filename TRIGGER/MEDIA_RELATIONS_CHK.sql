
  CREATE OR REPLACE EDITIONABLE TRIGGER "MEDIA_RELATIONS_CHK" before insert OR UPDATE ON media_relations
    for each row
    declare
    numrows number := 0;
    tabl VARCHAR2(38);
    colName VARCHAR2(38);
BEGIN
        -- makes sure that the string after the last space in media_relationship resolves to a valid table name
        tabl := upper(SUBSTR(:NEW.media_relationship,instr(:NEW.media_relationship,' ',-1)+1));
		SELECT COUNT(*) INTO numrows FROM USEr_tables WHERE upper(table_name)=upper(tabl);
		IF numrows=0 THEN
		     raise_application_error(
    	        -20001,
    	        'Invalid media_relationship'
    	      );
		END IF;
		select COUNT(column_name) INTO numrows from
            user_constraints,
            user_cons_columns
        where
            user_constraints.CONSTRAINT_NAME=user_cons_columns.CONSTRAINT_NAME and
            user_constraints.CONSTRAINT_TYPE='P' and
            user_constraints.TABLE_NAME=tabl;
        IF numrows=0 THEN
		     raise_application_error(
    	        -20001,
    	        'Primary key not found.'
    	      );
		END IF;
		select COLUMN_NAME INTO colName from
        user_constraints,
        user_cons_columns
        where
        user_constraints.CONSTRAINT_NAME=user_cons_columns.CONSTRAINT_NAME and
        user_constraints.CONSTRAINT_TYPE='P' and
        user_constraints.TABLE_NAME=tabl;
		execute immediate 'SELECT COUNT(*) FROM ' || tabl || ' WHERE ' || colName || '=' || :NEW.related_primary_key  INTO numrows;
		IF numrows=0 THEN
		     raise_application_error(
    	        -20001,
    	        'Related record not found.'
    	      );
		END IF;
END;


ALTER TRIGGER "MEDIA_RELATIONS_CHK" ENABLE