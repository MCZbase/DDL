
  CREATE OR REPLACE EDITIONABLE FUNCTION "IS_HAS_MEDIA_FOR_RELATION" 
(
  RELATED_PRIMARY_KEY IN NUMBER 
, RELATIONSHIP IN VARCHAR2 
) RETURN NUMBER 
--  Given a media relationship and a replated primary key, and , obtain the media id, or null if no media for that relationship type
--  @param related_primary_key the primary key to look up in media_relations
--  @param relationship the media_relastions.media_relastionship for the related_primary_key, accepts leading
--    wildcards, for example 'shows cataloged_item' for just that relationship, 
--    or '% cataloged_item' for any media relationship involving cataloged items.
--  @return 1 if there is at least one media object in this relationship, or 0 if no match.
AS
  type rc is ref cursor;
  ct NUMBER;
  retval NUMBER;
  l_cur    rc;
BEGIN
      retval := 0; 

      open l_cur for '
         select count(media.media_id)
         from media_relations 
             join media on media_relations.media_id = media.media_id
         where media_relations.related_primary_key = :x
               and media_relationship like :y 
        '
      using RELATED_PRIMARY_KEY, RELATIONSHIP;
      loop
           fetch l_cur into ct;
           exit when l_cur%notfound; 
           retval := ct;
      end loop;
      close l_cur;
      if retval > 0 then
         retval := 1;
      end if;

      return retval;
END IS_HAS_MEDIA_FOR_RELATION;