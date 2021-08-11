
  CREATE OR REPLACE FUNCTION "GET_INDIVIDUALCOUNT" 
(
   COLLECTIONOBJECTID IN NUMBER  
) RETURN VARCHAR2 
-- Given a collection object id obtain a value for the number of individual orgainsms
-- suitable for mapping to dwc:individualCount
-- @param collectionobjectid the collection_object_id of the cataloged item for
-- which to return the individual count.
-- @return a value for the number of individuals
AS 
    type rc is ref cursor;
         ind_count number;
         retval number;
         l_cur rc;
BEGIN
-- currently, estimate from lot count of parts.
-- add one for each whole animal or shell (except herps)
-- add one half, ceiling up for each valve.
-- add one for all histological serial sections
-- add the largest number for other parts as a loose estimator.
--
-- longer term intent is to obtain this value directly from a field.
  retval := 0;
  open l_cur for '
     select sum(lot_count) as ind_count  
     from cataloged_item 
        left join specimen_part on cataloged_item.collection_object_id = specimen_part.derived_From_Cat_item
        left join coll_object on specimen_part.collection_object_id = coll_object.collection_object_id
    where cataloged_item.collection_object_id = :a
        and (part_name = ''whole animal'' or part_name = ''shell'' or part_name = ''whole animal: tissue'')
        and cataloged_item.collection_cde <> ''VP''
    union 
     select sum(lot_count) as ind_count  
     from cataloged_item 
        left join specimen_part on cataloged_item.collection_object_id = specimen_part.derived_From_Cat_item
        left join coll_object on specimen_part.collection_object_id = coll_object.collection_object_id
    where cataloged_item.collection_object_id = :b
        and (part_name = ''whole animal'' or part_name = ''whole animal: tissue'')     
        and cataloged_item.collection_cde = ''VP''
    union 
    select ceil(sum(lot_count)/2) as ind_count
    from cataloged_item 
      left join specimen_part on cataloged_item.collection_object_id = specimen_part.derived_from_cat_item
      left join coll_object on specimen_part.collection_object_id = coll_object.collection_object_id
    where cataloged_item.collection_object_id = :c
        and part_name = ''valve''
    union 
    select max(lot_count) as ind_count
    from cataloged_item 
        left join specimen_part on cataloged_item.collection_object_id = specimen_part.derived_From_Cat_item
        left join coll_object on specimen_part.collection_object_id = coll_object.collection_object_id
    where cataloged_item.collection_object_id = :d
    and part_name <> ''valve'' and part_name <> ''whole animal'' and 
    (part_name <> ''shell'' or (part_name = ''shell'' and cataloged_item.collection_cde = ''VP'')) 
    and part_name not like ''model%'' and part_name <> ''chart'' and part_name <> ''firearm''
    and part_name <> ''histological serial section''
    union 
    select 1 as ind_count
    from cataloged_item 
        left join specimen_part on cataloged_item.collection_object_id = specimen_part.derived_From_Cat_item
        left join coll_object on specimen_part.collection_object_id = coll_object.collection_object_id
    where cataloged_item.collection_object_id = :e
    and part_name = ''histological serial section''
    group by part_name
  '
  using collectionobjectid, collectionobjectid, collectionobjectid, collectionobjectid, collectionobjectid;
  loop 
    fetch l_cur into ind_count;
       if (ind_count is not null) then
        retval := retval + ind_count;
       end if;
    exit when l_cur%notfound;
  end loop;
  RETURN retval;
END GET_INDIVIDUALCOUNT;