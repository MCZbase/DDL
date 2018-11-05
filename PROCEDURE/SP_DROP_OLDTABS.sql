
  CREATE OR REPLACE PROCEDURE "SP_DROP_OLDTABS" 
IS
        cursor oldtabs IS
                SELECT object_name, to_char(created, 'DD-MON-YYYY HH24:MI') crdate
                FROM user_objects
                WHERE
                        object_type = 'TABLE' AND
                        created < (sysdate - (4/24)) AND (
                        object_name like 'SEARCHRESULTS%' OR
                        object_name like 'TAXARESULTS%')
                ORDER BY object_name;
BEGIN
        FOR oldtab_rec in oldtabs
        LOOP
                EXECUTE IMMEDIATE 'DROP TABLE ' || oldtab_rec.object_name || ' PURGE';
                dbms_output.put_line('Dropping old table: ' || oldtab_rec.object_name
                        || ' created ' || oldtab_rec.crdate);
        END LOOP;
EXCEPTION
        WHEN OTHERS THEN
                raise_application_error(-20001,'An error was encountered: '
                        || sqlcode || '-ERROR-' || sqlerrm);
END;
 
 