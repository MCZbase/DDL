
  CREATE OR REPLACE EDITIONABLE FUNCTION "GET_PUBLICATION_CITATION_COUNT" 
(
  PUBLICATION_ID IN NUMBER,
  SHOW_ALL in NUMBER default 0
) RETURN VARCHAR2 
--  Supporting the Publications part of the MCZ website   --
--  Given a publication id, return the number of          --
--  cited specimens are there in MCZbase. 
--  @param PUBLICATION_ID the publication for which to look up citations
--  @param show_all if 0 use filtered_flat, otherwise use flat.
AS 
   type rc is ref cursor;
   ct    number;
   l_cur    rc;
begin
  if show_all = 0 then
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
   else 
      -- Join to flat to only count all specimens
      open l_cur for 'select count(*) from citation c 
                         left join flat ce on c.collection_object_id = ce.collection_object_id 
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
   end if;
END GET_PUBLICATION_CITATION_COUNT;