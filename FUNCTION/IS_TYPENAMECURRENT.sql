
  CREATE OR REPLACE FUNCTION "IS_TYPENAMECURRENT" 
(
   COLLECTION_OBJECT_ID IN NUMBER
)  RETURN NUMBER 
--  Given a collection_object id, return 1 if there is only one type name 
--  and it is the same as the name used in the current identication,
--  otherwise return 0.
--  Intended for use with labels to decide whether or not to display a type name 
--  Example use: 
--   
--  decode (MCZBASE.IS_TYPENAMECURRENT(cataloged_item.collection_object_id),1,'', 0,   
--    replace(MCZBASE.CONCATTYPESTATUS_LABEL(cataloged_item.collection_object_id), '&', '&amp;')
--  ) as tsname,
--  @param collection_object_id the cataloged item to check for type names.
--  @return 1 if the specified cataloged item has one type name, and that type
--    name is also the current identification, otherwise 0.
AS 
  type rc is ref cursor;
  retval number;
  typetax number;
  curtax number;
  l_cur    rc;
BEGIN
      retval := 0; 
      open l_cur for '
        select citation.cited_taxon_name_id, identification_taxonomy.taxon_name_id
        from cataloged_item
        left join citation on cataloged_item.collection_object_id = citation.collection_object_id
        left join identification on cataloged_item.collection_object_id = identification.collection_object_id
        left join identification_taxonomy on identification.identification_id = identification_taxonomy.identification_id
        where identification.accepted_id_fg = 1 and taxa_formula = ''A''
        and citation.type_status is not null 
        and cataloged_item.collection_object_id = :x '
      using COLLECTION_OBJECT_ID;
      loop
           fetch l_cur into typetax, curtax;
           exit when l_cur%notfound or retval = 1;
           if typetax=curtax then 
              retval := 1 ;
           end if; 
      end loop;
      close l_cur;

      return retval;
END IS_TYPENAMECURRENT;