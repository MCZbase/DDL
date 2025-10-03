
  CREATE OR REPLACE EDITIONABLE FUNCTION "GETTAXA" (p_key_val  in number,rank in varchar2 )
    return varchar2
    -- Given a collection_object_id and a taxonomic rank, return the higher taxon at that rank for
    -- the taxon used in the current identification of the collection object.
    -- @param p_key_val the collection_object_id for which to look up the identification
    -- @param rank the taxonomic rank to return from the identification.
    -- @return a higher taxon name.  
    as
        type rc is ref cursor;
        l_str    varchar2(4000);
       l_sep    varchar2(3);
       l_val    varchar2(4000);
   	l_cur    rc;
   begin
    open l_cur for 'select distinct( ' || rank || ')  from identification,identification_taxonomy,taxonomy
    	where identification.identification_id = identification_taxonomy.identification_id AND
    	identification_taxonomy.taxon_name_id = taxonomy.taxon_name_id AND
    	accepted_id_fg=1 AND
        identification.collection_object_id = :x '
                                           using p_key_val;

       loop
           fetch l_cur into l_val;
           exit when l_cur%notfound;
           l_str := l_str || l_sep || l_val;
           l_sep := ', ';
       end loop;
       close l_cur;

       return l_str;
  end;