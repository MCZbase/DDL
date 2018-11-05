
  CREATE OR REPLACE FUNCTION "GETDAYCOLLECTED" (b IN varchar,e IN varchar)
RETURN varchar
AS
    rby varchar(4);
    rey  varchar(4);
   BEGIN
    if length(b) < 10 OR length(e) < 10 then
    return '00';
    end if;
    rby:=substr( b, 9, 2 );
    rey:=substr( e, 9, 2 );
if (rby!=rey) then
return '00';
end if;
return rby;
end;
 
 