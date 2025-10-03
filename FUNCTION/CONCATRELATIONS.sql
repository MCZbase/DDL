
  CREATE OR REPLACE EDITIONABLE FUNCTION "CONCATRELATIONS" (p_key_val  in varchar2 )
    return varchar2
    as
        type rc is ref cursor;
        l_str    varchar2(4000);
       l_sep    varchar2(30);
       l_val    varchar2(4000);
       ret_tmp VARCHAR2(20000);

       l_cur    rc;
   begin

      open l_cur for 'select biol_indiv_relationship || ''
      			<a href="http://mczbase.mcz.harvard.edu/SpecimenDetail.cfm?collection_object_id=''
      			|| cataloged_item.collection_object_id || ''"> '' ||
      			institution_acronym || '' '' || collection.collection_cde || '' '' || cat_num || ''</a>''
                         from biol_indiv_relations, cataloged_item, collection
                        where biol_indiv_relations.related_coll_object_id = cataloged_item.collection_object_id and
                        cataloged_item.collection_id = collection.collection_id AND
                        biol_indiv_relations.collection_object_id  = :x '
                          using p_key_val;

       loop
           fetch l_cur into l_val;
           exit when l_cur%notfound;
           ret_tmp := ret_tmp || l_sep || l_val;
           l_sep := '; ';
       end loop;
       close l_cur;

       IF ret_tmp IS NULL THEN
            l_str := ' ';
       ELSIF LENGTH(ret_tmp) > 4000 THEN 
            l_str := substr(ret_tmp, 1, 3921) || '}' || l_sep || ' *** THERE ARE ADDITIONAL RELATIONS THAT ARE NOT SHOWN HERE ***'; 
       ELSE l_str := ret_tmp;
       END IF;

       return l_str;
  end;