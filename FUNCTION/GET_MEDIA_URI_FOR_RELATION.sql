
  CREATE OR REPLACE FUNCTION "GET_MEDIA_URI_FOR_RELATION" 
(
  RELATED_PRIMARY_KEY IN NUMBER 
, RELATIONSHIP IN VARCHAR2 
, MIME_TYPE in VARCHAR2
) RETURN VARCHAR2 
--  Given a media relationship and a replated primary key, and mimetype, obtain the media URI for the related media object,
--  or null if no media for that relationship type
--  @param related_primary_key the primary key to look up in media_relations
--  @param relationship the media_relastions.media_relastionship for the related_primary_key
--  @param mime_type the mime type of the related media record 
--  @return the uri for the related media record with the provided mime type, or null if no match.
AS
  type rc is ref cursor;
  l_val    varchar(2000);
  l_cur    rc;
BEGIN
      l_val := null; 

      open l_cur for '
         select media.media_uri
             from media_relations left join media on media_relations.media_id = media.media_id
         where media_relations.related_primary_key = :x
               and media_relationship = :y 
               and mime_type = :z
        '
      using RELATED_PRIMARY_KEY, RELATIONSHIP, MIME_TYPE;
      loop
           fetch l_cur into l_val;
           exit when l_cur%notfound; 
      end loop;
      close l_cur;

      return l_val;
END GET_MEDIA_URI_FOR_RELATION;