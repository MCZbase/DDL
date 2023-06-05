
  CREATE OR REPLACE FUNCTION "GET_MEDIA_CREDIT" 
(
   MEDIA_ID IN NUMBER
)  RETURN VARCHAR 
--  Supporting media metadata delivery  --
--  Given a media id, return a value for the credit (AC=photoshop:credit) for the media.  --
AS 
  type rc is ref cursor;
  sep varchar2(4);
  l_val    varchar(2000);
  retval varchar2(4000);
  l_cur    rc;
BEGIN
      l_val := 0; 
      sep := ' ';
      open l_cur for '
      select credit from (
            select 
                case 
                    when MCZBASE.is_mcz_media(media.media_id) = 1 then ''Museum of Comparative Zoology, Harvard University''
                    else ''''
                    end as credit,
                1 as ordinal
            from media
            where media_id = :x
        union       
            select 
                mczbase.get_medialabel(media.media_id,''credit'') as credit,
                2 as ordinal
            from media
            where media_id = :y
        ) 
        where credit is not null
        order by ordinal asc
        '
      using media_id, media_id;
      loop
           fetch l_cur into l_val;
           exit when l_cur%notfound; 
           retval := trim(retval || sep || l_val);
           sep := '; ';
      end loop;
      close l_cur;

      return retval;
END GET_MEDIA_CREDIT;