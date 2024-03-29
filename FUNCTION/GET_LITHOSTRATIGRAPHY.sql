
  CREATE OR REPLACE FUNCTION "GET_LITHOSTRATIGRAPHY" (LOCALITY_ID IN NUMBER ) 
--  Given a locality ID, return a : separated list of 
--  Supergroup:Group:Formation:Member:Bed from the Geology_Attributes table.
RETURN VARCHAR2 AS 
      type rc is ref cursor;
      l_str    varchar2(4000);
      l_sep    varchar2(2);
      l_val    varchar2(4000);
      l_cur    rc;
   BEGIN
       open l_cur for '
        select geo_att_value 
        from geology_attributes
            join ctgeology_attributes on geology_attributes.geology_attribute = ctgeology_attributes.geology_attribute
        where type = ''lithostratigraphic''
            and locality_id = :x
        order by ordinal asc
       '
       using LOCALITY_ID;
       loop
           fetch l_cur into l_val;
           exit when l_cur%notfound;
           l_str := l_str || l_sep || l_val;
           l_sep := ':';
       end loop;
       close l_cur;

       return l_str;
END GET_LITHOSTRATIGRAPHY;