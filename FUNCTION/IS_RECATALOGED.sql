
  CREATE OR REPLACE EDITIONABLE FUNCTION "IS_RECATALOGED" 
(
   collection_object_id IN NUMBER
)  RETURN NUMBER 
--  Test to see whether a collection object has been  
--  recataloged (that is, whether or not a collection 
--  object has a recataloged as relationship with another
--  collection object.
--  Given a collection object id, return 0 if the collection object  
--  is not recataloged, 1 if it is.   
--  @param collection_object_id the cataloged item to check 
--    recataloging status.
--  @return 1 if the specified collection object has a recataloged as
--    relationship to another collection object, otherwise 0
AS 
  type rc is ref cursor;
  l_val    NUMBER;
  l_cur    rc;
BEGIN
      l_val := 0; 
      open l_cur for '
      select count(*) from biol_indiv_relations 
      where biol_indiv_relationship = ''recataloged as'' 
            and collection_object_id = :x '
                 using collection_object_id;
      loop
           fetch l_cur into l_val;
           exit when l_cur%notfound;
           if l_val>0 then 
              l_val := 1 ;
           end if; 
      end loop;
      close l_cur;

      return l_val;
END IS_RECATALOGED;