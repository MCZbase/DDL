
  CREATE OR REPLACE EDITIONABLE FUNCTION "GET_TAXONRANK" 
-- Given a taxon_name_id, returns the rank for the taxon
-- as a varchar sutable for use as dwc:taxonRank.
--
-- @param taxon_name_id the taxon name for which to lookup the rank
-- @return the rank, or unknown if no included field is populated
( taxon_name_id IN NUMBER
) RETURN VARCHAR2 
as
      type rc is ref cursor;
      retval    varchar2(4000);
      taxonrank    varchar2(4000);
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
        from taxonomy     
        where taxon_name_id = :x 
   '
   using taxon_name_id;
       loop
           fetch l_cur into taxonrank;
           exit when l_cur%notfound;
           retval := taxonrank;
       end loop;
       close l_cur;

       return retval;
END;

