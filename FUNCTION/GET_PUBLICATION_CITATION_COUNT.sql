
  CREATE OR REPLACE FUNCTION "GET_PUBLICATION_CITATION_COUNT" 
(
  PUBLICATION_ID IN NUMBER  
) RETURN VARCHAR2 
--  Supporting the Publications part of the MCZ website   --
--  Given a publication id, return the number of          --
--  cited specimens are there in MCZbase.                 --
AS 
        type rc is ref cursor;
        ct    number;
       l_cur    rc;
   begin

      -- Join to filtered_flat to only count non-encumbered (mask_record) specimens
      open l_cur for 'select count(*) from citation c 
                         left join filtered_flat ce on c.collection_object_id = ce.collection_object_id 
                       where 
                         ce.collection_object_id is not null
                         and c.publication_id = :x '
                   using publication_id;

       loop
           fetch l_cur into ct;
           exit when l_cur%notfound;
       end loop;
       close l_cur;

       return ct;
END GET_PUBLICATION_CITATION_COUNT;
 