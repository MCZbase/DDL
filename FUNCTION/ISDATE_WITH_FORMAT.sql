
  CREATE OR REPLACE FUNCTION "ISDATE_WITH_FORMAT" 
( p_string in varchar2, format in varchar2)
return integer
as
l_date date;
begin
l_date := to_date(p_string,format);
   return 1;
exception
when others then
return 0;
end;