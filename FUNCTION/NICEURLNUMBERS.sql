
  CREATE OR REPLACE EDITIONABLE FUNCTION "NICEURLNUMBERS" (s  in VARCHAR)
return varchar2
as
 r VARCHAR2(255);
begin
r:=trim(regexp_replace(s,'<[^<>]+>'));
r:=regexp_replace(r,'[^A-Za-z0-9 ]*');
r:=regexp_replace(r,' +','-');
r:=lower(r);
if length(r)>150 then
r:=substr(r,1,150);
end if;
    RETURN r;
end;
 
 