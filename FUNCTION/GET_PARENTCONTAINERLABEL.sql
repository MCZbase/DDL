
  CREATE OR REPLACE FUNCTION "GET_PARENTCONTAINERLABEL" 
(
   part_collection_object_id IN number 
) 
--  Given a collection_object_id of a specimen part, return a label for the
--  parent container of the part in the storage heirarchy.
--  If the parent container itself is a pin (for MCZ-ENT material), move up one level in the
--  storage heirarchy above the pin to get the container that pin is in.
--  Returns Unplaced if the parent container is the root node.
RETURN VARCHAR2 AS 
      type rc is ref cursor;
      par    varchar2(255);
      partype    varchar2(255);
      parpar    varchar2(255);
      l_result    varchar2(50);
      l_cur    rc;
   BEGIN
       open l_cur for '

       select distinct 
            decode(p.container_type, ''pin'', nvl(pp.label,''Unplaced''), nvl(p.label,''Unplaced'')) parentcontainer, 
            decode(p.container_type, ''pin'', pp.container_type, p.container_type) parentcontainertype,
            decode(p.container_type, ''pin'', ppp.label, pp.label) parentsparent
        from specimen_part
            left join coll_obj_cont_hist on specimen_part.collection_object_id=coll_obj_cont_hist.collection_object_id
            left join container c on coll_obj_cont_hist.container_id=c.container_id
            left join container p on c.parent_container_id=p.container_id
            left join container pp on p.parent_container_id=pp.container_id
            left join container ppp on pp.parent_container_id=ppp.container_id
        where specimen_part.collection_object_id = :x 
            and current_container_fg = 1

       '
           using part_collection_object_id;
       fetch l_cur into par, partype, parpar;
       close l_cur;            

       l_result := par;

       return l_result;
END GET_PARENTCONTAINERLABEL;