
  CREATE OR REPLACE EDITIONABLE FUNCTION "MAKE_SEARCH_TERMS_NEST_OLD" (p_list IN CLOB)
      RETURN searchTermsTableNest
-- parse json in the form:       
-- [{"field": "genus","comparator": "SOUNDEX","value": "MUREX"},{"join":"and","field": "family","comparator": "=","value": "MURICIDAE"}]      
-- into searchTermTable records with join, field, comparator, and value.
-- @param p_list a list of search terms in a json string
-- @see mczbase.build_query_dbms_sql
    PIPELINED
    AS
      l_string       CLOB := regexp_replace(p_list, '\]$','') || ',{';
      l_comma_index  PLS_INTEGER;
      l_index        PLS_INTEGER := 1;
      RowString       VARCHAR2(4000);
      out_rec         SearchTermsRecordNest := SearchTermsRecordNest(NULL,NULL,NULL,NULL,NULL,NULL);
    BEGIN
      LOOP
      l_comma_index := INSTR(l_string, '},{', l_index);
      -- TODO: JSON serialization order is not guaranteed, replace the hard coding here with a json parser 
      -- e.g. https://github.com/pljson/pljson or update to oracle 12+ for native json functionality.
       EXIT WHEN l_comma_index = 0;
       RowString := SUBSTR(l_string, l_index, l_comma_index - l_index);
       /*out_rec.openparens := to_number(regexp_substr(RowString,'"openparens":([[:blank:]]*)"(.*)","closeparens"',1,1,'i',2));
       out_rec.closeparens := to_number(regexp_substr(RowString,'"closeparens":([[:blank:]]*)"(.*)","join"',1,1,'i',2));*/
       out_rec.openparens := to_number(regexp_substr(RowString,'"openparens":([[:blank:]]*)"([0-9]*)",',1,1,'i',2));
       out_rec.closeparens := to_number(regexp_substr(RowString,'"closeparens":([[:blank:]]*)"([0-9]*)",',1,1,'i',2));
       out_rec.joinfield := regexp_substr(RowString,'"join":([[:blank:]]*)"(and|or)"',1,1,'i',2);
       if out_rec.joinfield is null then 
          out_rec.joinfield := 'and';
       end if;
       out_rec.searchfield := regexp_substr(RowString,'"field":([[:blank:]]*)"(.*)","comparator":',1,1,'i',2);
       out_rec.Comparator := regexp_substr(RowString,'"comparator":([[:blank:]]*)"(.*)","value":',1,1,'i',2);
       out_rec.searchTerm := regexp_substr(RowString,'"value":([[:blank:]]*)"(.*)"$',1,1,'i',2);

       --  raise_application_error(-20001,'['|| out_rec.joinfield || '][' || '['|| out_rec.searchfield || '][' || out_rec.comparator || '][' || out_rec.searchterm || ']');
       dbms_output.put_line('[' || out_rec.openparens || '][' || out_rec.closeparens || '][' || out_rec.joinfield || '][' || '['|| out_rec.searchfield || '][' || out_rec.comparator || '][' || out_rec.searchterm || ']');
       PIPE ROW (out_rec);
       l_index := l_comma_index + 1;
    END LOOP;
     RETURN;
   END make_search_terms_nest_old;