
  CREATE OR REPLACE EDITIONABLE TRIGGER "MEDIA_RELATIONS_CT" before insert OR UPDATE ON ctmedia_relationship
    for each row
    declare
    numrows number := 0;
    tabl VARCHAR2(38);
    colName VARCHAR2(38);
    fkname VARCHAR2(38);
    sqlstr VARCHAR2(4000);
BEGIN
 		tabl := upper(SUBSTR(:NEW.media_relationship,instr(:NEW.media_relationship,' ',-1)+1));
		SELECT COUNT(*) INTO numrows FROM user_tables WHERE upper(table_name)=upper(tabl);
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
    	        'Primary key or related table not found.'
    	      );
		END IF;
		select COLUMN_NAME INTO colName from
        user_constraints,
        user_cons_columns
        where
        user_constraints.CONSTRAINT_NAME=user_cons_columns.CONSTRAINT_NAME and
        user_constraints.CONSTRAINT_TYPE='P' and
        user_constraints.TABLE_NAME=tabl;

		-- check if this relationship is handled
		fkname:='CFK_' || tabl;

		SELECT COUNT(*) INTO numrows FROM all_tab_cols WHERE table_name='TAB_MEDIA_REL_FKEY'  AND column_name=fkname;
		IF numrows=0 THEN
            -- add referencing column using a procedure to avoid the commit-in-trigger error
            init_media_fkeys(tabl,colName);
        END IF;
END;


ALTER TRIGGER "MEDIA_RELATIONS_CT" ENABLE