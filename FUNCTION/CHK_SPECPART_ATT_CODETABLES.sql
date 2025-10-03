
  CREATE OR REPLACE EDITIONABLE FUNCTION "CHK_SPECPART_ATT_CODETABLES" (atttype in varchar2, attval  in varchar2, collcde in varchar2) 
return varchar2 as

---allows for single line check of attributes controlled by value and unit codetables. Primarily used by the parts bulkloaders.

ctable varchar2(100);
colnm varchar2(100);
cnt VARCHAR2(500);
sqlStmt varchar2(1000);
clcd number;

begin

select decode(value_code_table, null, unit_code_table, value_code_table) into ctable from CTSPEC_PART_ATT_ATT where ATTRIBUTE_TYPE=atttype;

select column_name into colnm from cols where column_id = 1 and table_name = upper(ctable);
select count(*) into clcd from cols where column_name = 'COLLECTION_CDE' and table_name = upper(ctable);

sqlstmt := 'select count(*) from ' || ctable || ' where ' || colnm || '=''' || attval || '''';
if clcd = 1 then
    sqlstmt := sqlstmt || ' and collection_cde = ''' || collcde || '''';
end if;
execute immediate sqlstmt into cnt;

return cnt;

END;