
  CREATE OR REPLACE FUNCTION "GET_MEDIA_CREDIT" 
(
   MEDIA_ID IN NUMBER
)  RETURN VARCHAR 
--  Supporting media metadata delivery  --
--  Given a media id, return a value for the credit (AC=photoshop:credit) for the media.  --
AS 
  type rc is ref cursor;
  l_val    varchar(2000);
  l_cur    rc;
BEGIN
      l_val := 0; 
      open l_cur for 'select case 
           when MCZBASE.is_mcz_media(media.media_id) = 1 then ''Museum of Comparative Zoology, Harvard University'' 
           else mczbase.get_medialabel(media.media_id,''credit'')
           end as credit 
       from media
       where media_id = :x '
                 using media_id;
      loop
           fetch l_cur into l_val;
           exit when l_cur%notfound; 
      end loop;
      close l_cur;

      return l_val;
END GET_MEDIA_CREDIT;