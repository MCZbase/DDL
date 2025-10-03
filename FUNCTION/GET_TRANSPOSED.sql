
  CREATE OR REPLACE EDITIONABLE FUNCTION "GET_TRANSPOSED" ( p_a in varchar2 )
        return varchar2
        is
        l_str  varchar2(255) default null;
        l_sep  varchar2(30) default null;
        begin
for x in ( select b from t where a = p_a ) loop
l_str := l_str || l_sep || x.b;
         l_sep := '-';
    end loop;
     return l_str;
 end;