
  CREATE OR REPLACE EDITIONABLE FUNCTION "GET_MEDIA_LICENSE" 
(
   MEDIA_ID IN NUMBER
)  RETURN VARCHAR 
--  Supporting media metadata delivery  --
--  Given a media id, return a (human readable) value for the license for the media.  --
AS 
  type rc is ref cursor;
  l_val    varchar(2000);
  l_cur    rc;
BEGIN
      l_val := 0; 
      open l_cur for 'select case 
           when MCZBASE.is_mcz_media(media.media_id) = 1 then ''Creative Commons Attribution Share Alike Non Commerical (CC-BY-NC-SA 4.0)'' 
           else ctmedia_license.display
           end as license 
       from media left join ctmedia_license on media.media_license_id = ctmedia_license.media_license_id
       where media_id = :x '
                 using media_id;
      loop
           fetch l_cur into l_val;
           exit when l_cur%notfound; 
      end loop;
      close l_cur;

      return l_val;
END GET_MEDIA_LICENSE;