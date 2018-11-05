
  CREATE OR REPLACE FUNCTION "GETYEARCOLLECTED" (b IN varchar,e IN varchar)
RETURN varchar
AS
   rby varchar(4);
    rey  varchar(4);
BEGIN
    if length(b) < 4 OR length(e) < 4 then
    return '00';
    end if;
    rby:=substr( b, 1, 4 );
    rey:=substr( e, 1, 4 );
if (rby!=rey) then
return '00';
end if;
return rby;
end;
 
 