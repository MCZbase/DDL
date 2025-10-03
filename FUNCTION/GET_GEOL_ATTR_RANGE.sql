
  CREATE OR REPLACE EDITIONABLE FUNCTION "GET_GEOL_ATTR_RANGE" 
(
  LOCALITY_ID IN NUMBER  
, ATTRIB IN VARCHAR2  
, EARLIER IN NUMBER  
) RETURN VARCHAR2 AS 
--  Given a locality ID and the lithostratigraphic attribute to return 
--  (Erathem/Era, Period/System, Epoch/Series, Age/Stage, Sub-Epoch)
--  return the last encountered value of that attribute for that locality
--  
--  If the attribute is a range (earlyest - latest) or (earliest or latest)
--  and earlier = 1, then return the first element (earliest)
--  otherwise return the second element (latest).
--
--  If there is no range, return the entire value, regardless of the value of earlier.
      type rc is ref cursor;
      l_str    varchar2(4000);
      pos      number;
      l_val    varchar2(4000);
      l_precambrian varchar2(4000);
      l_cur    rc;
   BEGIN
       --  Obtain the attribute value 
       open l_cur for '
       select geo_att_value from geology_attributes where locality_id = :x and geology_attribute = :y 
       '
       using LOCALITY_ID, ATTRIB;
       loop
           fetch l_cur into l_val;
           exit when l_cur%notfound;
           l_str :=  l_val;
       end loop;
       close l_cur;
       
       --  Skip the parsing logic if there is no value.
       if l_str is not null then 
          --  Find out if a range separator is present in the value.
          if instr(l_str,' - ') > 0 then 
             pos := instr(l_str,' - ');
          end if;
          if instr(l_str,' or ') > 0 then 
             pos := instr(l_str,' or ');
          end if;
          --  If there is a range separator, return only one part of the string
          if pos > 0 then    
             if earlier = 1 then
                --  Assume the earlier part of the range comes first (Ordovician - Devonian)
                l_str := substr(l_str, 0, pos); 
             else
                -- account for the length of the range separator
                l_str := substr(l_str, pos + 3, length(l_str));
             end if;
          end if;
          l_str := trim(l_str);
       elsif attrib = 'Eonothem/Eon' then
           l_precambrian := get_geol_attr_range(locality_id, 'Period/System', earlier);
           if l_precambrian = 'Precambrian' then
              l_str := 'Precambrian';
           end if;
       end if;
       
       return l_str;


END GET_GEOL_ATTR_RANGE;