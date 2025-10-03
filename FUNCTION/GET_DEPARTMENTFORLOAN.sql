
  CREATE OR REPLACE EDITIONABLE FUNCTION "GET_DEPARTMENTFORLOAN" 
(
  TRANSACTIONID IN NUMBER  
) 
--  Given a TransactionID, return the name of the department as inferred from the loan number.
--  Depreciated.   
--  Should be deleted.
--  Manage these in the custom tag in getLoanFormInfo.cfm.
RETURN VARCHAR2 AS 
      type rc is ref cursor;
      l_last4    varchar2(4);
      l_last2    varchar2(2);
      l_result    varchar2(50);
      l_cur    rc;
   BEGIN
       open l_cur for 'select substr(trim(loan_Number),-4), substr(trim(loan_number),-2) from loan where transactionid = :x '
           using TRANSACTIONID;
       fetch l_cur into l_last4,l_last2;
       close l_cur;            
           IF l_last4 = 'Mala' THEN
              l_result := 'Malacology';
           ELSIF l_last4 = 'Mamm' then
              l_result := 'Mammalogy'; 
           ELSIF l_last4 = 'Herp' then
              l_result := 'Herpetology';
           ELSIF l_last4 = 'Orni' then
              l_result := 'Ornithology';
           ELSIF l_last2 = 'IZ' then
              l_result := 'Invertebrate Zoology';
           ELSIF l_last2 = 'IP' then
              l_result := 'Invertebrate Paleontology'; 
           ELSIF l_last2 = 'VP' then
              l_result := 'Vertebrate Paleontology';                
           end if;
       return l_result;
END GET_DEPARTMENTFORLOAN;
 