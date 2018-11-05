
  CREATE OR REPLACE FUNCTION "GETMONTHCOLLECTED" (b IN varchar,e IN varchar)
RETURN varchar
AS
    rby varchar(4);
    rey  varchar(4);
   BEGIN
    if length(b) < 7 OR length(e) < 7 then
    return '00';
    end if;
    rby:=substr( b, 6, 2 );
    rey:=substr( e, 6, 2 );
if (rby!=rey) then
return '00';
end if;
return rby;
end;
 
 