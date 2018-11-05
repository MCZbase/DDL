
  CREATE OR REPLACE FUNCTION "GET_MEDIALABEL" 
(
  MEDIA_ID IN NUMBER  
, MEDIA_LABEL IN VARCHAR2  
) RETURN VARCHAR2 
--  Given a media_id and a media_label type, return the value of the media_label
--  for that media_id from media_labels.
AS 
  type rc is ref cursor;
  retval    varchar2(4000);
  l_cur rc;
BEGIN
  retval := null;
  open l_cur for 
     ' select label_value from media_labels where media_id = :x and media_label = :y '
  using MEDIA_ID, MEDIA_LABEL; 
       loop 
          fetch l_cur into retval;
          exit;
       end loop;   
       close l_cur;

       return retval;
  
END;