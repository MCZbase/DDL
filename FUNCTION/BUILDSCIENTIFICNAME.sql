
  CREATE OR REPLACE FUNCTION "BUILDSCIENTIFICNAME" (p_key_val IN number )
RETURN varchar2
AS  nsn varchar2(4000);
        nft varchar2(4000);
        r taxonomy%ROWTYPE;
BEGIN
        select * into r from taxonomy where taxon_name_id=p_key_val;

         IF r.subspecies IS NOT null THEN
                nsn := r.subspecies;
                nft := r.subspecies;
        END IF;
        IF r.infraspecific_rank IS NOT null THEN
                nsn := r.infraspecIFic_rank || ' ' || nsn;
                nft := r.infraspecIFic_rank || ' ' || nft;
        END IF;
        IF r.species IS NOT null THEN
                nsn := r.species || ' ' || nsn;
                nft := r.species || ' ' || nft;
        END IF;
        IF r.subgenus IS NOT null THEN
        -- ignore for building scientIFic name
                nft := r.subgenus || ' ' || nft;
        END IF;
        IF r.genus IS NOT null THEN
                nsn := r.genus || ' ' || nsn;
                nft := r.genus || ' ' || nft;
        END IF;
        IF r.tribe IS NOT null THEN
                IF nsn IS null THEN
                        nsn := r.tribe;
                END IF;
                -- IF we don't have a scientific name by now, just use the lowest term that we do have
                nft := r.tribe || ' ' || nft;
        END IF;
        IF r.subfamily IS NOT null THEN
                IF nsn IS null THEN
                        nsn := r.subfamily;
                END IF;
                nft := r.subfamily || ' ' || nft;
        END IF;
        IF r.family IS NOT null THEN
                IF nsn IS null THEN
                        nsn := r.family;
                END IF;
                nft := r.family || ' ' || nft;
        END IF;
        IF r.suborder IS NOT null THEN
                IF nsn IS null THEN
                        nsn := r.suborder;
                END IF;
                nft := r.suborder || ' ' || nft;
        END IF;
        IF r.phylorder IS NOT null THEN
                IF nsn IS null THEN
                        nsn := r.phylorder;
                END IF;
                nft := r.phylorder || ' ' || nft;
        END IF;
        IF r.phylclass IS NOT null THEN
                IF nsn IS null THEN
                        nsn := r.phylclass;
                END IF;
                nft := r.phylclass || ' ' || nft;
        END IF;
        IF r.phylum IS NOT null THEN
                IF nsn IS null THEN
                        nsn := r.phylum;
                END IF;
                nft := r.phylum || ' ' || nft;
        END IF;
        return trim(nsn);
        --UPDATE test SET scientific_name = trim(nsn), full_taxon_name=trim(nft);
        --dbms_output.put_line(nsn);
        --dbms_output.put_line(nft);
     END;