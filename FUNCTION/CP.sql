
  CREATE OR REPLACE FUNCTION "CP" ( collobjid in integer)
    return varchar2
--  Obsolete?   References table ctsp, which does not exist.    
    as
        type rc is ref cursor;
        l_str    varchar2(4000);
       l_sep    varchar2(2);
       l_val    varchar2(4000);

       l_cur    rc;
   begin

       open l_cur for 'select decode(part_modifier,
	null, decode(preserve_method,
		null, part_name,
		part_name||'' (''||preserve_method||'')''),
	part_modifier||'' ''||
	decode(preserve_method,
		null, part_name,
		part_name||'' (''||preserve_method||'')''))
                         from specimen_part,ctsp
                        where specimen_part.part_name =  ctsp.partname (+)
                        and derived_from_cat_item = :x
                        ORDER BY list_order,part_name'
                   using collobjid;

       loop
           fetch l_cur into l_val;
           exit when l_cur%notfound;
           l_str := l_str || l_sep || l_val;
           l_sep := '; ';
       end loop;
       close l_cur;

       return l_str;
   end;