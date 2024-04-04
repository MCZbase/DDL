
  CREATE OR REPLACE FUNCTION "GET_TAXONRANK_FORID" 
-- Given an identification_id, returns the rank for an A taxon
-- as a varchar sutable for use as dwc:taxonRank.
--
-- @param identification_id the identification for which to lookup the rank
-- @return the rank, or unknown if no included field is populated
( identification_id IN NUMBER
) RETURN VARCHAR2 
as
      type rc is ref cursor;
      retval    varchar2(4000);
      taxonrank    varchar2(4000);
      separator varchar2(4);
      l_cur    rc;
   begin
   retval := '';
   open l_cur for '
        select 
            nvl2(infraspecific_rank, infraspecific_rank, 
            nvl2(subspecies,''subspecies'',
            nvl2(species, ''species'', 
            nvl2(subgenus, ''subgenus'', 
            nvl2(genus, ''genus'', 
            nvl2(tribe, ''tribe'', 
            nvl2(subfamily, ''subfamily'', 
            nvl2(family, ''family'', 
            nvl2(superfamily, ''superfamily'', 
            nvl2(phylorder, ''order'', 
            nvl2(phylclass, ''class'', 
            nvl2(phylum, ''phylym'', 
            nvl2(kingdom, ''kingdom'', 
            ''unknown''
            ))))))))))))) as rank 
        from 
            identification_taxonomy 
            join taxonomy on identification_taxonomy.taxon_name_id = taxonomy.taxon_name_id 
        where identification_id = :x 
        order by variable asc
   '
   using identification_id;
   separator := '';
    loop
           fetch l_cur into taxonrank;
           exit when l_cur%notfound;
           retval := concat(separator,taxonrank);
           separator := ', ';
    end loop;
    close l_cur;

    return retval;
END;

