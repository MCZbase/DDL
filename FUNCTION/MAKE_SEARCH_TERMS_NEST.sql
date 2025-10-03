
  CREATE OR REPLACE EDITIONABLE FUNCTION "MAKE_SEARCH_TERMS_NEST" (p_list IN CLOB)
  RETURN searchTermsTableNest PIPELINED
AS
BEGIN
  FOR rec IN (
    SELECT
      NVL(openparens, 0)    AS openparens,
      NVL(closeparens, 0)   AS closeparens,
      NVL(joinfield, 'and') AS joinfield,
      searchfield,
      comparator,
      searchterm
    FROM JSON_TABLE(
      p_list,
      '$[*]'
      COLUMNS (
        openparens   NUMBER       PATH '$.openparens',
        closeparens  NUMBER       PATH '$.closeparens',
        joinfield    VARCHAR2(20) PATH '$.join',
        searchfield  VARCHAR2(50) PATH '$.field',
        comparator   VARCHAR2(50) PATH '$.comparator',
        searchterm   CLOB         PATH '$.value'
      )
    )
  )
  LOOP
    PIPE ROW (SearchTermsRecordNest(
      rec.openparens,
      rec.closeparens,
      rec.joinfield,
      rec.searchfield,
      rec.comparator,
      rec.searchterm
    ));
  END LOOP;

  RETURN;
END make_search_terms_nest;