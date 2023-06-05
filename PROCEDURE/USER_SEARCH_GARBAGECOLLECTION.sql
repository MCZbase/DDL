
  CREATE OR REPLACE PROCEDURE "USER_SEARCH_GARBAGECOLLECTION" as

sqlstr varchar2(500);
cursor c1 is select owner from dba_tables where table_name = 'USER_SEARCH_TABLE';

begin
for c1_rec in c1 loop

sqlstr := 'delete ' || c1_rec.owner || '.user_search_table where searchdate < (systimestamp - interval ''7'' day)';

execute immediate sqlstr;
commit;

sqlstr := 'analyze table ' || c1_rec.owner || '.user_search_table compute statistics';

execute immediate sqlstr;

end loop;

end;