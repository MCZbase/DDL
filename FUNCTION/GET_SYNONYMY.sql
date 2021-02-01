
  CREATE OR REPLACE FUNCTION "GET_SYNONYMY" (taxonnameid IN number)
    return varchar2
    as
        rela    varchar2(4000);
        l_str  varchar2(4000);
	begin

    select taxon_relationship || ' is ' || scientific_name || ' ' || author_text into rela from taxon_relations tr, taxonomy t where tr.taxon_name_id = taxonnameid and tr.related_taxon_name_id = t.taxon_name_id;
    l_str := rela;
    select scientific_name || ' ' || author_text || ' is ' || taxon_relationship into rela from taxon_relations tr, taxonomy t where tr.related_taxon_name_id = taxonnameid and tr.taxon_name_id = t.taxon_name_id;
    l_str := l_str || ';' || rela;
    return l_str;

  end;