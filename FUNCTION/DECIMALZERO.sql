
  CREATE OR REPLACE FUNCTION "DECIMALZERO" (n  in number )
    return VARCHAR2
   as r VARCHAR2(40);
   begin
       if n>0 and n<1 then
r:='0' || to_char(n);
 elsif n> -1 and n<0 then
 r:='-0' || to_char(n*-1);
 else
 r:=to_char(n);
 end if;
return r;
  end;
 
 