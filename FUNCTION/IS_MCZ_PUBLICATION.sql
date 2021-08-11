
  CREATE OR REPLACE FUNCTION "IS_MCZ_PUBLICATION" 
(
   PUBLICATION_ID IN NUMBER
)  RETURN NUMBER 
--  Supporting the Publications part of the MCZ website 
--  Given a publication id, return 0 if the publication 
--  is not an MCZ publication, 1 if it is.              
--  @param publication_id the publication to check 
--  @return 1 if MCZ publication, otherwise 0.
AS 
  type rc is ref cursor;
  l_val    NUMBER;
  l_cur    rc;
BEGIN
      l_val := 0; 
      open l_cur for 'select count(*) from publication_attributes
                      where publication_attribute = ''MCZ publication''
                      and  publication_id = :x '
                 using publication_id;
      loop
           fetch l_cur into l_val;
           exit when l_cur%notfound;
           if l_val>0 then 
              l_val := 1 ;
           end if; 
      end loop;
      close l_cur;

      return l_val;
END IS_MCZ_PUBLICATION;