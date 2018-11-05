
  CREATE OR REPLACE FUNCTION "GET_SHORT_PARTS_LIST_CONCAT" 
( collobjid IN NUMBER
) 
-- Given a collection_object.collection_object_id, return a string containing -- 
-- a brief list of the parts associated with that collection object, that is, --
-- return Skull,Skeleton,Skin instead of skull(dry), skin (dry), partial      --
-- skeleton (dry).  --
RETURN VARCHAR2 AS
      type rc is ref cursor;
      l_str    varchar2(4000);
      l_sep    varchar2(2);
      l_val    varchar2(4000);
      l_cur    rc;
   begin

       open l_cur for 'select  part_name
                         from specimen_part,ctspecimen_part_list_order
                        where specimen_part.part_name =  ctspecimen_part_list_order.partname (+)
                        and derived_from_cat_item = :x
                        ORDER BY list_order'
                   using collobjid;
       loop
           fetch l_cur into l_val;
           exit when l_cur%notfound;
           if l_val='tissues only' then l_val := 'tiss.'; end if;
           if l_val='tissue' then l_val := 'tiss.'; end if;
           if l_val='skeleton' then l_val := 'skel.'; end if;
           if l_val='whole animal' then l_val := ''; end if;
           l_str := l_str || l_sep || l_val;
           l_sep := ';';
       end loop;
       close l_cur;

       return l_str;
END;
 
 