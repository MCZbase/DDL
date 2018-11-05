
  CREATE OR REPLACE FUNCTION "IS_MCZ_MEDIA" 
(
   MEDIA_ID IN NUMBER
)  RETURN NUMBER 
--  Supporting media metadata delivery  --
--  Given a media id, return 0 if the media  --
--  is not an MCZ media, 1 if it is.         --
--  (encapsulates test for ctmedia_license.display = MCZ Permissions & Copyright)  --
AS 
  type rc is ref cursor;
  l_val    NUMBER;
  l_cur    rc;
BEGIN
      l_val := 0; 
      open l_cur for 'select count(display) from media 
                      left join ctmedia_license on media.media_license_id = ctmedia_license.media_license_id 
                      where media_id = :x and display = ''MCZ Permissions & Copyright'' '
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
END IS_MCZ_MEDIA;