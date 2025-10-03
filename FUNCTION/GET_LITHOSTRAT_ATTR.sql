
  CREATE OR REPLACE EDITIONABLE FUNCTION "GET_LITHOSTRAT_ATTR" 
(
  LOCALITY_ID IN NUMBER  
, ATTRIB IN VARCHAR2  
) RETURN VARCHAR2 AS 
--  Given a locality ID and the lithostratigraphic attribute to return (Supergroup, Group, Formation, Member, Bed)
--  return the value of that attribute for that locality
--  If more than one attribute of that type is present, return a pipe concatenated list.
      type rc is ref cursor;
      l_str    varchar2(4000);
      l_sep    varchar2(2);
      l_val    varchar2(4000);
      l_cur    rc;
   BEGIN
       open l_cur for '
       select 
           geo_att_value 
       from geology_attributes 
          join ctgeology_attributes on geology_attributes.geology_attribute = ctgeology_attributes.geology_attribute
       where locality_id = :x and geology_attributes.geology_attribute = :y 
          and ctgeology_attributes.type = ''lithostratigraphic''
       '
       using LOCALITY_ID, ATTRIB;
       loop
           fetch l_cur into l_val;
           exit when l_cur%notfound;
           l_str := l_str || l_sep || l_val;
           l_sep := '|';
       end loop;
       close l_cur;
       return l_str;
END GET_LITHOSTRAT_ATTR;