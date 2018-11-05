
  CREATE OR REPLACE FUNCTION "GET_HIGHER_TAXA_LENLIMITED" 
(
   COLLECTIONOBJECTID IN NUMBER  
,  MAXLENGTH IN NUMBER  
) RETURN VARCHAR2 AS 
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
 