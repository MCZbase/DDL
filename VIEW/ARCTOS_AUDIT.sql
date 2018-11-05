
  CREATE OR REPLACE FORCE VIEW "ARCTOS_AUDIT" ("TIMESTAMP", "DB_USER", "OBJECT_NAME", "SQL_TEXT", "SQL_BIND") AS 
  SELECT TIMESTAMP,
    DB_USER,
    OBJECT_NAME,
    regexp_replace(regexp_replace(SQL_TEXT,'[^[:print:]]',' '),'[    ]+',' ') AS SQL_TEXT,
    sql_bind
  FROM dba_fga_audit_trail