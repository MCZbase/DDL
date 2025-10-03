
  CREATE OR REPLACE EDITIONABLE FUNCTION "GET_MEDIA_DCTERMSRIGHTS" 
(
   MEDIA_ID IN NUMBER
)  RETURN VARCHAR 
--  Supporting media metadata delivery  --
--  Given a media id, return dcterms:rights, a machine value for the license for the media.  --
AS 
  type rc is ref cursor;
  l_val    varchar(2000);
  l_cur    rc;
BEGIN
      l_val := 0; 
      open l_cur for 'select case 
           when MCZBASE.is_mcz_media(media.media_id) = 1 then ''http://creativecommons.org/licences/by-nc-sa/4.0/legalcode'' 
           else ctmedia_license.uri
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
END GET_MEDIA_DCTERMSRIGHTS;