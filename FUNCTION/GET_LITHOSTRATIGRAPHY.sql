
  CREATE OR REPLACE FUNCTION "GET_LITHOSTRATIGRAPHY" (LOCALITY_ID IN NUMBER ) 
--  Given a locality ID, return a : separated list of 
--  Group:Formation:Member:Bed from the Geology_Attributes table.
RETURN VARCHAR2 AS 
      type rc is ref cursor;
      l_str    varchar2(4000);
      l_sep    varchar2(2);
      l_val    varchar2(4000);
      l_cur    rc;
   BEGIN
       open l_cur for '
       select geo_att_value from (
select 1 as ordinal, geo_att_value from geology_attributes where locality_id = :x and geology_attribute = ''Group''
union
select 2 as ordinal, geo_att_value from geology_attributes where locality_id = :x and geology_attribute = ''Formation''
union
select 3 as ordinal, geo_att_value from geology_attributes where locality_id = :x and geology_attribute = ''Member''
union
select 4 as ordinal, geo_att_value from geology_attributes where locality_id = :x and geology_attribute = ''Bed''
) a order by ordinal
       '
       using LOCALITY_ID, LOCALITY_ID, LOCALITY_ID, LOCALITY_ID;
       loop
           fetch l_cur into l_val;
           exit when l_cur%notfound;
           l_str := l_str || l_sep || l_val;
           l_sep := ':';
       end loop;
       close l_cur;

       return l_str;
END GET_LITHOSTRATIGRAPHY;
 
 