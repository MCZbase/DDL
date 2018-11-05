
  CREATE OR REPLACE PROCEDURE "COMPUTE_TABLE_STATISTICS" as

sql_stmt varchar2(500);

cursor c1 is select table_name from tabs where table_name not like 'X_%';

begin
for c1_rec in c1 loop

sql_stmt := 'analyze table ' || c1_rec.table_name || ' compute statistics';
DBMS_OUTPUT.PUT_LINE(sql_stmt);

execute immediate sql_stmt;

end loop;
end;