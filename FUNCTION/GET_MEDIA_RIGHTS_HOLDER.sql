
  CREATE OR REPLACE FUNCTION "GET_MEDIA_RIGHTS_HOLDER" 
(
   MEDIA_ID IN NUMBER
)  RETURN VARCHAR 
--  Supporting media metadata delivery  --
--  Given a media id, return a value for the rights holder for the media. 
--  For MCZ media, this returns president and fellows, for non-MCZ
--  media, it returns media_label owner. --
AS 
  type rc is ref cursor;
  l_val    varchar(2000);
  l_cur    rc;
BEGIN
      l_val := 0; 
      open l_cur for 'select case when MCZBASE.is_mcz_media(media.media_id) = 1 then ''President and Fellows of Harvard College'' 
       else get_medialabel(media_id, ''owner'') end as rightsholder 
       from media where media_id = :x '
                 using media_id;
      loop
           fetch l_cur into l_val;
           exit when l_cur%notfound; 
      end loop;
      close l_cur;

      return l_val;
END GET_MEDIA_RIGHTS_HOLDER;