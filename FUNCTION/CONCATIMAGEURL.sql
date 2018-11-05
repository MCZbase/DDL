
  CREATE OR REPLACE FUNCTION "CONCATIMAGEURL" (p_key_val  in number)
    --  Given a collection object id, returns a string containing a pipe delimited list
    --  of URIs for media objects suitable for use in the dwc:associatedMedia term.
    return varchar2
    as
 type rc is ref cursor;
        l_str    clob;
       l_sep    clob;
       l_val    clob;

       l_cur    rc;
                
   begin
        open l_cur for 'select  media_uri
                         from media,media_relations
                        where 
                       media.media_id=media_relations.media_id and
                       MEDIA_RELATIONSHIP like ''% cataloged_item'' and
                       MEDIA_RELATIONSHIP not like ''%ledger%'' and
                       RELATED_PRIMARY_KEY  = :x '
                          using p_key_val;
      loop
           fetch l_cur into l_val;
           exit when l_cur%notfound;
           l_str := l_str || l_sep || l_val;
           l_sep := '|';
       end loop;
       close l_cur;
       IF LENGTH(l_str) > 4000 THEN -- ADDED THIS LINE
            l_str := substr(l_str, 1, 3925) || l_sep || '*** THERE ARE ADDITIONAL IMAGES THAT ARE NOT SHOWN HERE ***'; -- ADDED THIS LINE
      END IF;

       return l_str;
   end;