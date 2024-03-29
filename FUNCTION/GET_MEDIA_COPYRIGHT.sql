
  CREATE OR REPLACE FUNCTION "GET_MEDIA_COPYRIGHT" 
(
   MEDIA_ID IN NUMBER
)  RETURN VARCHAR 
--  Supporting media metadata delivery  --
--  Given a media id, return a (human readable) value for a copyright statement for the media.  --
AS 
  type rc is ref cursor;
  l_val    varchar(2000);
  l_cur    rc;
BEGIN
      l_val := 0; 
      open l_cur for '
        select
            ''Copyright © ''|| DECODE(MCZBASE.GET_MEDIALABEL(media_id,''made date''), NULL, ''2008'', SUBSTR(MCZBASE.GET_MEDIALABEL(media_id,''made date''),1,4))
                || '' '' 
                || mczbase.get_media_rights_holder(media_id) 
                || '', Some Rights Reserved '' 
                ||  mczbase.get_media_license(media_id) 
          as rights
       from media
       where media_id = :x '
                 using media_id;
      loop
           fetch l_cur into l_val;
           exit when l_cur%notfound; 
      end loop;
      close l_cur;

      return l_val;
END GET_MEDIA_COPYRIGHT;