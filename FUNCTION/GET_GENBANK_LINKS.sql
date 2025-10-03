
  CREATE OR REPLACE EDITIONABLE FUNCTION "GET_GENBANK_LINKS" (p_key_val  in varchar2)
    -- Given a collection_object_id, create a pipe delimited list of links to genbank for 
    -- all the NCBI GenBank ID other id values associated with that collection object.
    return varchar2
    as
       type rc is ref cursor;
       l_str    varchar2(4000);
       l_sep    varchar2(3);
       l_val    varchar2(4000);
       l_cur    rc;
   begin
        l_sep := '';
        open l_cur for 'select trim(replace(display_value,''&'',''&amp;'')) 
                         from coll_obj_other_id_num
                         where other_id_type=''NCBI GenBank ID'' AND
                         collection_object_id  = :x '
                       using p_key_val;
       loop
           fetch l_cur into l_val;
           exit when l_cur%notfound;
           l_str := l_str || l_sep || 'http://www.ncbi.nlm.nih.gov/nuccore/' || l_val  ;
           l_sep := ' | ';
       end loop;

       close l_cur;

       return l_str;
   end;