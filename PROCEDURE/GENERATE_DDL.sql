
  CREATE OR REPLACE EDITIONABLE PROCEDURE "GENERATE_DDL" AS

    CURSOR c1 IS
    SELECT
        object_type,
        object_name
    FROM
        user_objects
    WHERE
        object_type NOT IN ( 'LOB', 'PACKAGE BODY', 'TABLE PARTITION', 'DATABASE LINK', 'JAVA CLASS' )
        AND object_name NOT LIKE 'X_%';

    objddl  CLOB;
    ddlfile utl_file.file_type;
BEGIN
    FOR c1_rec IN c1 LOOP
        BEGIN
            SELECT
                mczbase.getsimpleddl( c1_rec.object_type, c1_rec.object_name, 1)
            INTO objddl
            FROM
                dual;

---using UTL_FILE to write to file
/************
ddlFile := UTL_FILE.fopen (c1_rec.object_type, c1_rec.object_name || '.sql', 'w');
---dbms_output.put_line('exporting ' || c1_rec.object_type || ' ' || c1_rec.object_name || ' to ' || c1_rec.object_name || '.sql')  ;

      UTL_FILE.put (ddlFile, objDDL);
      UTL_FILE.fclose (ddlFile);  
************/

---using CLOB2FILE to write to file 

-- a directory object with the appropriate directory path must exist for each object type to be exported.
-- the MCZBASE schema needs grants for read and write on each directory object to be exported into.
-- dbms_output.put_line(c1_rec.object_type || '.' || c1_rec.object_name);

            IF c1_rec.object_type = 'JAVA SOURCE' THEN
                -- special case handling, for clearer directory names, change space to underscore for directory name.
                dbms_xslprocessor.clob2file(
                                           objddl,
                                           'JAVA_SOURCE',
                                           c1_rec.object_name || '.sql'
                );
            ELSE
                dbms_xslprocessor.clob2file(
                                           objddl,
                                           c1_rec.object_type,
                                           c1_rec.object_name || '.sql'
                );
            END IF;

        EXCEPTION
            WHEN utl_file.invalid_path THEN
                dbms_output.put_line('ORA-06512');
                dbms_output.put_line(c1_rec.object_type
                                     || '.'
                                     || c1_rec.object_name);
            WHEN OTHERS THEN
                IF sqlcode = -22285 THEN
                    dbms_output.put_line('ORA-22285: non-existent directory or file for FILEOPEN operation');
                    dbms_output.put_line(c1_rec.object_type
                                         || '.'
                                         || c1_rec.object_name);
                    CONTINUE;
                ELSE
                    dbms_output.put_line(sqlerrm);
                    dbms_output.put_line(c1_rec.object_type
                                         || '.'
                                         || c1_rec.object_name);
                    RAISE;
                END IF;
        END;
    END LOOP;
END;