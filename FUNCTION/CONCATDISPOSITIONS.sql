
  CREATE OR REPLACE EDITIONABLE FUNCTION "CONCATDISPOSITIONS" ( collection_object_id  in varchar2)
return varchar2
-- Given a collection_object_id for a cataloged_item, concatenate the coll_obj_disposition 
-- values for the parts for that cataloged item.
-- @param colleciton_object_id the primary key value for the cataloged item for which to 
--   obtain part dispositions;
    as
        type rc is ref cursor;
        l_str    varchar2(4000);
       l_sep    varchar2(30);
       l_val    varchar2(4000);
       l_ct  varchar2(30);

       l_cur    rc;
   begin

      open l_cur for 'select coll_obj_disposition, to_char(count(*)) ct
                      from coll_object 
                          join specimen_part on coll_object.collection_object_id = specimen_part.collection_object_id
                      where (coll_object_type = ''SP'' or coll_object_type = ''SS'')
                          and specimen_part.derived_from_cat_item = :x
                      group by coll_obj_disposition    
                      order by coll_obj_disposition'
                   using collection_object_id;
       loop
           fetch l_cur into l_val, l_ct;
           exit when l_cur%notfound;
           if l_str is null or length(l_str) < 4000 then
              if l_ct = '1' then
                  l_str := l_str || l_sep || l_val;
              else
                  l_str := l_str || l_sep || l_val || ' (' || l_ct || ')';
              end if;
              l_sep := ', ';
           end if;
       end loop;
       close l_cur;

       return l_str;
  end;