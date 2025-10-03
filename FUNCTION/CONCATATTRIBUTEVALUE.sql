
  CREATE OR REPLACE EDITIONABLE FUNCTION "CONCATATTRIBUTEVALUE" 
   (p_key_val  in varchar2, attribute_type in varchar2 )
return varchar2
    -- given a  collection_object_id and an attribute type, 
    -- return a comma separated list of the attribute value and units for the
    -- specified attribute for the specified collection_object
    -- @param p_key_val the collection object id for which to look up an attribute
    -- @param attribute_type the type of attribute to return values for
    -- @return a comma separated list of value and units for the specified 
    --  attribute type for the specified collection object.
as
   type rc is ref cursor;
   l_str    varchar2(4000);
   l_sep    varchar2(30);
   l_val    varchar2(4000);
   l_cur    rc;
begin
      open l_cur for 'select attribute_value || '' '' || attribute_units
                         from attributes
                        where
                        attribute_type='''||attribute_type||''' and
                        collection_object_id = :x'
                   using p_key_val;

       loop
           fetch l_cur into l_val;
           exit when l_cur%notfound;
           l_str := l_str || l_sep || l_val;
           l_sep := ', ';
       end loop;
       close l_cur;

       return l_str;
  end;