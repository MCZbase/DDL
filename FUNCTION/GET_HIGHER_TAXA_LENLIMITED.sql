
  CREATE OR REPLACE EDITIONABLE FUNCTION "GET_HIGHER_TAXA_LENLIMITED" 
(
   COLLECTIONOBJECTID IN NUMBER  
,  MAXLENGTH IN NUMBER  
) RETURN VARCHAR2 
-- Given a collection object id and a maximum string length obtain a concatenated
-- string of selected higher taxon ranks (most from phylum to family) for the 
-- taxonomy record used in the current identification of the specified cataloged
-- item, truncated to the given length, in the middle, retaining the family, if 
-- the string is longer than the specified maximum length (e.g. "Mollusca Ga... Muricidae") 
-- used to obtain a higher taxonomy string for labels where all higher ranks
-- will be used if they will fit, but the list will be truncated above family if they
-- do not.
-- @param collectionobjectid the collection_object_id of the cataloged item for
-- which to return the higher taxon ranks from the current identification.
-- @param maxlength the maximum number of characters to return, if smaller than 
-- length of the family + 4, then "... {family}" will still be returned.
-- @see GET_TAXONOMY used to obtain ranks from the heirarchy from current identifications
AS 
    type rc is ref cursor;
         taxa varchar2(900);
         family varchar2(255);
         result varchar2(900);
         l_cur rc;
BEGIN
     open l_cur for 'select 
replace(trim (
get_taxonomy(:x,''phylum'') || '' '' ||
get_taxonomy(:x1,''subphylum'') || '' '' ||
get_taxonomy(:x2,''phylclass'') || '' '' ||
get_taxonomy(:x3,''phylorder'') || '' '' ||
get_taxonomy(:x4,''suborder'') || '' '' ||
get_taxonomy(:x5,''infraorder'') || '' '' ||
get_taxonomy(:x6,''superfamily'')
),''  '','' '') taxon,
get_taxonomy(:x7,''family'') family
from cataloged_item'
     using collectionobjectid,collectionobjectid,collectionobjectid,collectionobjectid,collectionobjectid,collectionobjectid,collectionobjectid,collectionobjectid;
     fetch l_cur into taxa, family;
     close l_cur;
     result := taxa || ' ' ||  family;
     if length(result) > maxlength then 
         result := substr(result,0,maxlength-length(family)-4) || '... ' || family ;
     end if;
  RETURN result;
END GET_HIGHER_TAXA_LENLIMITED;