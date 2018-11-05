
  CREATE OR REPLACE FUNCTION "ISNUMERIC" 
    ( p_string in varchar2)
    return integer
    as
        l_number number;
    begin
        l_number := p_string;
        return 1;
   exception
       when others then
           return 0;
   end;
 