
  CREATE OR REPLACE EDITIONABLE FUNCTION "GET_CONTIGUOUSLOCTAX" 
(
  COLLECTIONOBJECTID IN NUMBER  
, IDLIST IN VARCHAR2  
) RETURN VARCHAR2  
    as
       type rc is ref cursor;
       l_str    varchar2(4000);
       target    varchar2(200);
       targetn NUMBER;
       targetlocn NUMBER;
       targettaxn NUMBER;
       targetspecloc VARCHAR2(4000);
       l_val    varchar2(4000);
       l_valn   NUMBER;
       previous NUMBER;
       inrange  number;
       maxrange number;
       minrange number;
       done     number;
       l_cur    rc;
       l_cur1    rc;       
       r_cur    rc;
   begin
        open r_cur for 'select cat_num, cat_num_integer, taxon_name_id, collecting_event.locality_id, locality.spec_locality
                        from cataloged_item 
                        left join identification on cataloged_item.collection_object_id = identification.collection_object_id 
                        left join identification_taxonomy on identification.identification_id = identification_taxonomy.identification_id 
                        left join collecting_event on cataloged_item.collecting_event_id = collecting_event.collecting_event_id
                        left join locality on collecting_event.locality_id = locality.locality_id
                        where cataloged_item.collection_object_id = ' || COLLECTIONOBJECTID ;
        fetch r_cur into target, targetn, targettaxn, targetlocn, targetspecloc;
        
        previous := 0;
        inrange := 0;

        maxrange := targetn;         
        minrange := targetn;
        
        done := 0;
        previous := 0;
        open l_cur for 'select distinct cat_num_integer from cataloged_item 
                        left join identification on cataloged_item.collection_object_id = identification.collection_object_id 
                        left join identification_taxonomy on identification.identification_id = identification_taxonomy.identification_id 
                        left join collecting_event on cataloged_item.collecting_event_id = collecting_event.collecting_event_id
                        left join locality on collecting_event.locality_id = locality.locality_id
                        where cataloged_item.collection_object_id in (' || IDLIST ||') and taxon_name_id = :s and ( locality.locality_id = :s or locality.spec_locality = :s ) 
                        order by cat_num_integer asc ' using  IN targettaxn , IN targetlocn , IN targetspecloc  ; 
       loop
           -- start at targetn, walkup to contiguuous maxrange
           fetch l_cur into l_valn;
           exit when l_cur%NOTFOUND;
              if l_valn >= targetn and done=0 then 
                  if previous = 0 then 
                     previous := l_valn - 1; 
                  end if;    
                  if previous = l_valn - 1 then 
                      maxrange:= l_valn;
                      previous := l_valn;
                  else 
                      done := 1;
                  end if; 
              end if;
       end loop;
       
       close l_cur;
       
        done := 0;
        previous := 0;
        open l_cur1 for 'select distinct cat_num_integer from cataloged_item 
                        left join identification on cataloged_item.collection_object_id = identification.collection_object_id 
                        left join identification_taxonomy on identification.identification_id = identification_taxonomy.identification_id 
                        left join collecting_event on cataloged_item.collecting_event_id = collecting_event.collecting_event_id
                        left join locality on collecting_event.locality_id = locality.locality_id
                        where cataloged_item.collection_object_id in (' || IDLIST ||') and taxon_name_id = :s and ( locality.locality_id = :s or locality.spec_locality = :s ) 
                        order by cat_num_integer desc ' using  IN targettaxn , IN targetlocn , IN targetspecloc  ; 
       loop
           -- start at targetn, walkup to contiguuous maxrange
           fetch l_cur1 into l_valn;
           exit when l_cur1%notfound;
              if l_valn<=targetn and done=0 then 
                  if previous = 0 then 
                     previous := l_valn + 1; 
                  end if;    
                  if previous = l_valn + 1 then 
                      minrange:= l_valn;
                      previous := l_valn;
                  else 
                      done := 1;
                  end if; 
              end if;
       end loop;       
       close l_cur1;

       l_str := minrange || '-' || maxrange;

       return l_str;
END GET_CONTIGUOUSLOCTAX;
--create public synonym get_contiguous for get_contiguous;
-- grant execute on get_contiguous to public;