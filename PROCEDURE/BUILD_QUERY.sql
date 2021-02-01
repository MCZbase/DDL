
  CREATE OR REPLACE PROCEDURE "BUILD_QUERY" (fieldname in varchar2, comparator in VARCHAR2, searchvalue in varchar2, res out sys_refcursor) as

varSQL varchar2(4000);

begin

varSQL := 'select * from flat where ' || fieldname || ' ' || comparator || ' ''' || searchvalue || '''';
DBMS_OUTPUT.put_line(varSQL);
---execute immediate varSQL;
open res for varSQL;

end;