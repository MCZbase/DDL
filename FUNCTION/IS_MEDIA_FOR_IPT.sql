
  CREATE OR REPLACE EDITIONABLE FUNCTION "IS_MEDIA_FOR_IPT" 
(
   MEDIA_ID IN NUMBER
)  RETURN NUMBER 
--  Supporting media metadata delivery  --
--  Given a media id, return 0 if the media  --
--  should not be included in an IPT media feed, 1 if it may be --
--  Note: Includes test is_medi_encumbered()=0  --
AS 
  type rc is ref cursor;
  l_val    NUMBER;
  l_cur    rc;
BEGIN
      l_val := 0; 
      open l_cur for 'select count(display) from media 
                      left join ctmedia_license on media.media_license_id = ctmedia_license.media_license_id 
                      where media_id = :x 
                      and display <>  ''Rights defined by 3rd party host'' 
                      and (uri like ''%mcz.harvard.edu%'' or uri like ''%%creativecommons.org%%'')
                      and is_media_encumbered(media_id)=0 '
                 using media_id;
      loop
           fetch l_cur into l_val;
           exit when l_cur%notfound;
           if l_val>0 then 
              l_val := 1 ;
           end if; 
      end loop;
      close l_cur;

      return l_val;
END IS_MEDIA_FOR_IPT;