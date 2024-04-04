
  CREATE OR REPLACE FUNCTION "IS_MASK_LOC_COORD" 
(
   LOCALITY_ID IN NUMBER
)  RETURN NUMBER 
--  function IS_MASK_LOC_COORD check if any cataloged item attached to a locality has a mask record or mask locality encumbrance  
--  to test for cases where the encumbrance should be inherited for display of coordinates of the locality 
--  @param locality_id the locality to check 
--  @return 0 if the the locality is not associated with any cataloged item with a mask record or mask locality encumbrance
--    1 if it is associated with any cataloged item with such and encumbrance.
AS 
  type rc is ref cursor;
  l_val    NUMBER;
  l_cur    rc;
BEGIN
    l_val := 0; 
    open l_cur for '
        select count(encumbrance.encumbrance_id) as ct 
        from flat
            left join coll_object_encumbrance on flat.collection_object_id = coll_object_encumbrance.collection_object_id
            left join encumbrance on coll_object_encumbrance.encumbrance_id = encumbrance.encumbrance_id
        where (encumbrance_action = ''mask locality'' or encumbrance_action = ''mask record'')
            and flat.locality_id = :x '
    using LOCALITY_ID;

    loop
        fetch l_cur into l_val;
    exit when l_cur%notfound;
        if l_val>0 then 
          l_val := 1 ;
        end if; 
    end loop;
    close l_cur;

    return l_val;
END IS_MASK_LOC_COORD;