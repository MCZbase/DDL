
  CREATE OR REPLACE EDITIONABLE FUNCTION "GET_MEDIA_LICENSELOGOURL" 
(
   MEDIA_ID IN NUMBER
)  RETURN VARCHAR 
--  Supporting media metadata delivery  --
--  Given a media id, return the link to the licence logo ac:licenselogourl for the media.  --
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
             (
                ''https://mirrors.creativecommons.org/presskit/buttons/88x31/'' 
                || 
                substr(
                   replace(mczbase.get_media_dctermsrights(media_id), ''http://creativecommons.org/licences/'', null)
                   ,0
                   ,instr(replace(mczbase.get_media_dctermsrights(media_id), ''http://creativecommons.org/licences/'',null),''/'') -1
                ) 
                || 
                ''.png''
              )
           end as licencelogourl
       from media
       where media_id = :x '
                 using media_id;
      loop
           fetch l_cur into l_val;
           exit when l_cur%notfound; 
      end loop;
      close l_cur;

      return l_val;
END GET_MEDIA_LICENSELOGOURL;