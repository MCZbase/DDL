
  CREATE OR REPLACE EDITIONABLE FUNCTION "GET_MEDIA_FOR_TRANS" 
(
  TRANSACTION_ID IN NUMBER  
, MEDIA_RELATIONSHIP IN VARCHAR2  
) 
--  Given a transaction id and a type of media relationship (e.g. documents accn), return the description 
--  of the media objects having that relationship for that transaction (that is, list the media for a 
--  transaction by media relationship type, giving the description for each media object).
--  @param transaction_id the transaction for which to look up media
--  @param media_relationship the type of relationship to list (e.g. documents accn)
--  @return a clob containing a pipe separated list of media descriptions, with markers for media with no description.
RETURN VARCHAR2 AS 
  type rc is ref cursor;
  retval   clob;
  l_sep    varchar2(3);
  l_val    varchar(4000);
  l_cur rc;
BEGIN
  l_sep := '';
  open l_cur for
       ' 
       select nvl(mczbase.get_medialabel(media_relations.media_id,''description''), media.media_type || '' [No Description]'') as label_value 
       from media_relations left join media on media_relations.media_id = media.media_id
       where media_relationship = :x
       and related_primary_key = :y
       '
  using MEDIA_RELATIONSHIP, TRANSACTION_ID;
  loop 
       fetch l_cur into l_val;
       exit when l_cur%notfound;
       if (l_val = '') then l_val := '[No Description]'; end if; 
       retval := retval || l_sep || l_val;
       l_sep := '| ';
  end loop;   
  close l_cur;

  RETURN retval;

END GET_MEDIA_FOR_TRANS;