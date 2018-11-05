
  CREATE OR REPLACE FUNCTION "GET_MEDIA_USAGETERMS" 
(
   MEDIA_ID IN NUMBER
)  RETURN VARCHAR 
--  Supporting media metadata delivery  --
--  Given a media id, return a (human readable) value for the usage terms (ac:usageTerms) for the media.  --
AS 
  type rc is ref cursor;
  l_val    varchar(2000);
  l_cur    rc;
BEGIN
      l_val := 0; 
      open l_cur for 'select case 
           when MCZBASE.is_media_for_ipt(media.media_id) = 0 then 
               null
           else
               decode(mczbase.get_media_license(media_id), null, null, ''Available under '' ||  mczbase.get_media_license(media_id) || '' license'')
           end as usageterms
       from media
       where media_id = :x '
                 using media_id;
      loop
           fetch l_cur into l_val;
           exit when l_cur%notfound; 
      end loop;
      close l_cur;

      return l_val;
END GET_MEDIA_USAGETERMS;