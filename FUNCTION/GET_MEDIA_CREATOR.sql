
  CREATE OR REPLACE EDITIONABLE FUNCTION "GET_MEDIA_CREATOR" 
(
   MEDIA_ID IN NUMBER
)  RETURN VARCHAR 
--  Supporting media metadata delivery  --
--  Given a media id, return a value for the creator for the media.  --
AS 
  type rc is ref cursor;
  l_val    varchar(2000);
  retval  varchar(2000);
  separator varchar(5);
  l_cur    rc;
BEGIN
      retval := '';
      l_val := ''; 
      separator := '';
      --  note, fixed error 2021 May 8, was returning metadata record creator for created by agent, not created by agent.
      open l_cur for 'select distinct a.creator from (select case when MCZBASE.is_mcz_media(media.media_id) = 1 then ''Museum of Comparative Zoology, Harvard University'' 
       else get_medialabel(media_id, ''owner'') end as creator 
       from media where media_id = :x 
       union 
       select distinct MCZBASE.GET_AGENTNAMEOFTYPE(related_primary_key,''preferred'') as creator
       from media_relations 
       where media_id = :x and media_relationship = ''created by agent''  ) a
       '
       using media_id, media_id;
      loop
           fetch l_cur into l_val;
           if l_val <> '[no agent data]' then 
                if retval is null or instr(retval,l_val) = 0  then 
                   retval := retval || separator || l_val;
                   separator := ', ';
                end if;
           end if;
           exit when l_cur%notfound;                
      end loop;
      close l_cur;

      return retval;
END GET_MEDIA_CREATOR;