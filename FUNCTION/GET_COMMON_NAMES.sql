
  CREATE OR REPLACE FUNCTION "GET_COMMON_NAMES" (collobjid IN number )
--  Given a collection object id, return the common names for taxa used in idendifications
--  of that collection object.
return varchar2
as
  type rc is ref cursor;
  final_str    varchar2(4000);
  common_name  varchar2(4000);
  l_cur    rc;
begin
  open l_cur for
      'SELECT common_name.common_name 
      FROM
        identification
          left join identification_taxonomy on identification.identification_id = identification_taxonomy.identification_id
          left join common_name on identification_taxonomy.taxon_name_id = common_name.taxon_name_id
      WHERE collection_object_id = :x
          and common_name.taxon_name_id is not null'
  using collobjid;
LOOP 
   fetch l_cur into common_name;
           exit when l_cur%notfound;
   if (final_str is null) then
       final_str := common_name;
   else 
       final_str :=  final_str || ', ' || common_name;
   end if;
END LOOP;
return  final_str;

END GET_COMMON_NAMES;