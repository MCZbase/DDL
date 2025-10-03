
  CREATE OR REPLACE EDITIONABLE FUNCTION "CONCATPARTNAME_MAMMAL" ( collobjid in integer)
    return varchar2
    --  Concatenation of part names, with reworking as requested by Mammalogy for 
    --  their labels.
    as
        type rc is ref cursor;
        l_str    varchar2(4000);
       l_sep    varchar2(2);
       l_val    varchar2(4000);

       l_cur    rc;
   begin

       open l_cur for 'select  mczbase.get_part_prep(specimen_part.collection_object_id)
                         from specimen_part,ctspecimen_part_list_order
                        where specimen_part.part_name =  ctspecimen_part_list_order.partname (+)
                        and derived_from_cat_item = :x
                        ORDER BY list_order'
                   using collobjid;

       loop
           fetch l_cur into l_val;
           exit when l_cur%notfound;
           l_val := replace(l_val,'(dry)','');
           l_val := replace(l_val,'whole','');
           l_val := replace(l_val,'skin flat','skin');
           l_str := l_str || l_sep || trim(l_val);
           l_sep := '; ';
       end loop;
       close l_cur;

       return l_str;
END CONCATPARTNAME_MAMMAL;
 