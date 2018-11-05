
  CREATE OR REPLACE FUNCTION "GET_BHL_LINKS" 
(
  PUBLICATION_ID IN NUMBER  
) RETURN VARCHAR2
-- Given a publication_id, return all of the links to that publication which are pointers to BHL.
-- @param publication_id to look up.
-- @return a &nbsp separated list of anchor tags with an href of the media_uri of a linked media
-- record (media relationship shows publication) where the uri contains biodiversitylibrary.org, and 
-- the anchor tag wrapping the text 'BHL'.
AS 
        type rc is ref cursor;
        l_str    varchar2(4000);
       l_sep    varchar2(30);
       l_val    varchar2(4000);

       l_cur    rc;
   begin
      l_sep := '';
      open l_cur for 'select m.media_uri
                          from media_relations mr left join media m on mr.media_id = m.media_id 
                          where mr.media_relationship = ''shows publication'' and 
                            media_uri like ''%biodiversitylibrary.org%'' and
                            related_primary_key = :x '
                   using publication_id;
       loop
           fetch l_cur into l_val;
           exit when l_cur%notfound;
           l_str := l_str || l_sep || '<a href="' || l_val || '">BHL</a>';
           l_sep := '&nbsp;';
       end loop;
       close l_cur;

       return l_str;


END GET_BHL_LINKS;