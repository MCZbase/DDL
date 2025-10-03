
  CREATE OR REPLACE EDITIONABLE FUNCTION "IS_DEACCESSIONED" 
(
  collection_object_id IN VARCHAR2  
) RETURN VARCHAR2 
--  Identify whether or not parts of a cataloged item have been deaccessioned.
--  
--  @param collection_object_id for a cataloged item to look up
--  @return null if no parts are deaccessioned, partially deaccessioned
--  if some parts are deaccessioned, deaccessioned if all parts are deaccessioned,
--  transfered if all parts are in an internal transfer deaccesion
--
AS
  type rc is ref cursor;
  ctdeacloop NUMBER;
  ctdeac NUMBER;
  cttrans NUMBER;
  ctotalloop NUMBER;
  ctotal NUMBER;
  retval VARCHAR2(50);
  deacctype varchar(30);
  l_cur    rc;
BEGIN
      cttrans := 0;
      ctdeac := 0;

      open l_cur for '
         select count(specimen_part.collection_object_id) totalparts,
            count(deacc_item.collection_object_id) deaccparts,
            ''deaccessioned'' as type
         from specimen_part 
             join deacc_item on specimen_part.collection_object_id = deacc_item.collection_object_id
             left join deaccession on deacc_item.transaction_id = deaccession.transaction_id
         where specimen_part.derived_from_cat_item = :x
            and (deacc_type is null or deacc_type <> ''transfer (internal)'')
         group by specimen_part.derived_from_cat_item
         union
         select count(specimen_part.collection_object_id) totalparts,
            count(deacc_item.collection_object_id) deaccparts,
            ''transfer'' as type
         from specimen_part 
             join deacc_item on specimen_part.collection_object_id = deacc_item.collection_object_id
             left join deaccession on deacc_item.transaction_id = deaccession.transaction_id
         where specimen_part.derived_from_cat_item = :y
            and (deacc_type is null or deacc_type = ''transfer (internal)'')
         group by specimen_part.derived_from_cat_item
         union 
         select count(specimen_part.collection_object_id) totalparts,
            0 deaccparts,
            ''total'' as type
         from specimen_part 
         where specimen_part.derived_from_cat_item = :z
         group by specimen_part.derived_from_cat_item
        '
      using collection_object_id, collection_object_id, collection_object_id;
      loop
           fetch l_cur into ctotalloop, ctdeacloop, deacctype;
           exit when l_cur%notfound; 
           if deacctype = 'transfer' then
              cttrans := ctdeacloop;
           elsif deacctype = 'total' then
              ctotal := ctotalloop;
           else 
              ctdeac := ctdeacloop;
           end if;        
      end loop;

      if ctotal = 0 then
          retval := 'no parts';
      elsif cttrans = 0 and ctdeac = 0 then
          retval := '';
      elsif cttrans = ctotal then 
          retval := 'transfer (internal)';
      elsif ctdeac = ctotal then
          retval := 'deaccessioned';
      else 
          retval := 'partial';
      end if;

   return retval;
END;