
  CREATE OR REPLACE FUNCTION "NICEURL2" (s  in VARCHAR)
return varchar2
as
 r VARCHAR2(255);
begin
r:=trim(regexp_replace(s,'<[^<>]+>'));
r:=regexp_replace(r,'[^A-Za-z ]*');
r:=regexp_replace(r,' +','-');
r:=lower(r);
if length(r)>150 then
r:=substr(r,1,150);
end if;
IF (substr(r, -1)='-') THEN
    r:=substr(r,1,length(r)-1);
END IF;
    RETURN r;
end;
 
 