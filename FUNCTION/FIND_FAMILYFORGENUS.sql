
  CREATE OR REPLACE FUNCTION "FIND_FAMILYFORGENUS" (genus  in varchar2)
    return varchar2
    -- Given a generic name, find the single family this genus is most frequently placed in in MCZbase
    -- return null if no match is found.
    --
    -- Intended for use with lepidoptera bulkload, to find the family in order to find the 
    -- container (room) into which to place the bulkloaded material.
    as
        type rc is ref cursor;
        l_str    varchar2(4000);
       l_val    varchar2(4000);

       l_cur    rc;
   begin
      l_str := '';
      open l_cur for '
        select family from (
         select family from taxonomy where genus = :x and family is not null group by family order by count(*) desc
        ) where rownum < 2
         '
          using genus;
       loop
           fetch l_cur into l_val;
           exit when l_cur%notfound;
           l_str := l_val;
       end loop;
       close l_cur;

       return l_str;
  end;