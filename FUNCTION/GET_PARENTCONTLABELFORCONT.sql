
  CREATE OR REPLACE FUNCTION "GET_PARENTCONTLABELFORCONT" 
(
   container_id IN number 
) 
--  Given a container_id of a specimen part, return a label for the
--  parent container of the part in the storage heirarchy.
--
--  @param container_id the container for which to look up the parent label for.
--  @return the name of the parent container, or Unplaced if the parent container is the root node.

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
            nvl(p.label,''Unplaced'') parentcontainer 
        from container c
            left join container p on c.parent_container_id=p.container_id
        where c.container_id = :x 
       '
           using container_id;
       fetch l_cur into par;
       close l_cur;            
       l_result := par;

       return l_result;
END GET_PARENTCONTLABELFORCONT;