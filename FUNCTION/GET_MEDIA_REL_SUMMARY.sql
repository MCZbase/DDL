
  CREATE OR REPLACE EDITIONABLE FUNCTION "GET_MEDIA_REL_SUMMARY" 
(
  MEDIA_ID IN NUMBER  
, MEDIA_RELATIONSHIP IN VARCHAR2  
) 
--  Given a media id and a type of media relationship, return a description of that 
--  particular relation, e.g. for a shows cataloged_item, return the collection
--  and catalog number for that cataloged item.  Return is result from media_relation_summary()
--  for the row in media_relations defined by the media_id and the media_relationship.
RETURN VARCHAR2 AS 
  type rc is ref cursor;
  retval   varchar2(4000);
  l_sep    varchar2(3);
  l_val    varchar2(4000);
  l_cur rc;
BEGIN
  l_sep := '';
  open l_cur for
       ' select MEDIA_RELATION_SUMMARY(media_relations_id) from media_relations where media_relationship = :x and media_id = :y'
  using MEDIA_RELATIONSHIP, MEDIA_ID;
  loop 
       fetch l_cur into l_val;
       exit when l_cur%notfound;
       retval := retval || l_sep || l_val;
       l_sep := ', ';
  end loop;   
  close l_cur;

  RETURN retval;
    
END GET_MEDIA_REL_SUMMARY;