
  CREATE OR REPLACE EDITIONABLE FUNCTION "IS_ACCN_BENEFITS" (COLLECTION_OBJECT_ID IN NUMBER) 
--  Given a collection_object_id, return 1 if there is a non-null value in the benefits summary
--  of the accession to which this cataloged item belongs, otherwise return 0.
--  @param COLLECTION_OBJECT_ID the collection object id for the cataloged item to check.
--  @return 1 if any permit attached to the accession for this cataloged item has a non-null
--    value for the benefits summary.
RETURN NUMBER AS 
      type rc is ref cursor;
      retval   number;
      l_cur    rc;
   BEGIN
      retval := 0;

      open l_cur for '
         select count(permit.permit_id)
         from cataloged_item
           join accn on cataloged_item.accn_id = accn.transaction_id
           join permit_trans on accn.transaction_id = permit_trans.transaction_id
           join permit on permit_trans.permit_id = permit.permit_id
         where cataloged_item.collection_object_id = :x
            and permit.benefits_summary is not null
			and length(trim(permit.benefits_summary)) > 0
       '
       using COLLECTION_OBJECT_ID;
       loop
           fetch l_cur into retval;
           exit when l_cur%notfound;
       end loop;
       close l_cur;

       if retval > 1 then
          retval := 1;
       end if;

       return retval;
END IS_ACCN_BENEFITS;