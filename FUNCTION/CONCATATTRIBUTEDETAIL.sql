
  CREATE OR REPLACE FUNCTION "CONCATATTRIBUTEDETAIL" (p_key_val  in varchar2,
                                        p_other_col_name in varchar2 )
    return varchar2
    as
        type rc is ref cursor;
        l_str    varchar2(4000);
       l_sep    varchar2(30);
       l_val    varchar2(4000);

       l_cur    rc;
   begin

      open l_cur for 'select attribute_type || ''='' || attribute_value || '' ''
 || attribute_units ||
                                        '' Determined by '' || agent_name
                                        || '' on '' || to_char(determined_date,''dd Mon yyyy'')
                                        || decode(determination_method,
                                                null,null,
                                                '' based upon '' || determination_method)
                                        || decode(attribute_remark,
                                                null,null,
                                                '' Rek: '' || attribute_remark)
                         from attributes, preferred_agent_name
                        where
                        attributes.determined_by_agent_id = preferred_agent_name
.agent_id and
                        attribute_type='''||p_other_col_name||''' and
                        collection_object_id = :x'
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
 