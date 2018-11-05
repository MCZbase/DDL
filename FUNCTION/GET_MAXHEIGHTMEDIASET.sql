
  CREATE OR REPLACE FUNCTION "GET_MAXHEIGHTMEDIASET" 
(
  MEDIA_ID IN NUMBER 
) RETURN VARCHAR2 
--  Given a media_id type, return the largest value of the media_label of type height
--  out of the set of media objects that show cataloged_item that are related to the
--  given media_id.  That is, get the largest height from a set of related media objects.
AS 
  type rc is ref cursor;
  retval    varchar2(4000);
  l_cur rc;
BEGIN
  retval := null;
  open l_cur for 
     ' 
select * from (     
  select get_medialabel(endm.media_id,''height'') height
  from media_relations startm 
       left join media_relations mr on startm.related_primary_key = mr.related_primary_key
       left join media endm on mr.media_id = endm.media_id
  where mr.media_relationship = ''shows cataloged_item''
		   and startm.media_id = :x
  order by to_number(get_medialabel(endm.media_id,''height'')) desc     
) a where rownum < 2
     '
  using MEDIA_ID; 
       loop 
          fetch l_cur into retval;
          exit;
       end loop;   
       close l_cur;
       return retval;
  
END;