
  CREATE OR REPLACE EDITIONABLE FUNCTION "CONCATIMAGEURLFILTERED" (p_key_val  in number)
    --  Given a collection object id, returns a string containing a pipe delimited list
    --  of URIs for media objects suitable for external use in the dwc:associatedMedia term.
    --  @param p_key_val the primary key for a collection object for which to look up the 
    --  the media records
    --  @return a pipe separated list of image IRIs for related media records that fit the
    --  criteria for inclusion in IPT
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
                       RELATED_PRIMARY_KEY  = :x 
                       AND mczbase.is_media_for_ipt(media.media_id) = 1
                       '
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