
  CREATE OR REPLACE EDITIONABLE FUNCTION "CONCATCITEDAS" ( p_key_val  in varchar2)
    return varchar2
    as
        type rc is ref cursor;
        l_str    varchar2(4000);
        l_sep    varchar2(30);
        l_val    varchar2(4000);

        l_cur    rc;
   begin

      open l_cur for 
      'select t.scientific_name from citation c, taxonomy t
        where c.cited_taxon_name_id = t.taxon_name_id
        and type_status in (''Holotype'',''Lectotype'',''Neotype'',''Paralectotype'',''Paratopotype'',''Paratype'',''Syntype'',''Type?'',''Holotype?'',''Paratype?'',''Syntype?'',''Lectotype?'',''Allotype?'',''Cotype?'',''Topoparatype'',''Genoholotype'',''Genotype'',''Plastoholotype'',''Plastoparatype'',''Plastotype'',''Cotype'',''Allotype'',''Allolectotype'')
        and c.collection_object_id = :x'
        using p_key_val;
      loop
        fetch l_cur into l_val;
        exit when l_cur%notfound;
        l_str := l_str || l_sep || l_val;
        l_sep := '; ';
       end loop;
       close l_cur;

       return l_str;
  end;