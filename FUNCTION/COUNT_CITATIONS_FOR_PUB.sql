
  CREATE OR REPLACE EDITIONABLE FUNCTION "COUNT_CITATIONS_FOR_PUB" 
(
  PUBLICATION_ID IN NUMBER    
) 
--  Given a publication id return the number of cited for cataloged items linked to that publication
--  @param publication_id the primary key value for the publication to look up citations for.
--  @return the count of the number of distinct cited of cataloged items linked to the specified publication.
RETURN VARCHAR2 AS
  type rc is ref cursor;
  ct NUMBER;
  retval  NUMBER;
  l_cur rc;
BEGIN
  retval := 0;
  open l_cur for
       ' select count(distinct citation.collection_object_id) as ct 
       from citation 
       where publication_id = :x '
  using PUBLICATION_ID;
  loop 
       fetch l_cur into ct;
       exit when l_cur%notfound;
       retval := ct;
  end loop;   
  close l_cur;
 RETURN retval;

END COUNT_CITATIONS_FOR_PUB;