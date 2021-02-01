
  CREATE OR REPLACE FUNCTION "CONCATCOMMONNAME" (p_key_val  in varchar2 )
--  Given a taxon_name_id, obtain a varchar containing a comma separated list of common names
--  associated with that taxon of length up to 4000 characters.
--  
--  @param p_key_val the taxon_name_id to lookup common names for.
--  @return a varchar containing a comma separated list of common names.
return varchar2 
as
  type rc is ref cursor;
  l_str    varchar2(4000);
  l_sep    varchar2(3);
  l_val    varchar2(4000);
  l_cur    rc;
begin
    l_str := ' ';
    l_sep := '';
    open l_cur for '
        select 
            decode(common_name, null,''None recorded.'',common_name) common_name
        from common_name
        where taxon_name_id = :x
        ORDER BY common_name'
    using p_key_val;

    loop
        fetch l_cur into l_val;
        exit when l_cur%notfound;
        if (length(l_str) + length(l_val) < 3998) then 
           l_str := l_str || l_sep || l_val;
           l_sep := ', ';
        end if;
    end loop;
    close l_cur;

    return trim(l_str);
end;