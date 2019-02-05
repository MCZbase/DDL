
  CREATE OR REPLACE TRIGGER "TRG_TAXON_COMPOUND_NAMES" 
BEFORE INSERT OR UPDATE ON taxonomy
FOR EACH ROW
DECLARE
nScientificName varchar2(4000);
nFullTaxonomy varchar2(4000);
nDisplayName varchar2(4000);
c NUMBER;
stoopidX VARCHAR2(10):=CHR (215 USING NCHAR_CS);
err_msg VARCHAR2(100);
BEGIN

    -- uncomment following if 0=1 test and subsequent lines numbered 1 to 4 to disable checks
    -- (1) 
    -- if 0=1 THEN

    if :NEW.nomenclatural_code != 'noncompliant' THEN
       IF :new.SUBORDER IS NOT NULL THEN
           IF NOT (regexp_like(:new.SUBORDER,'^[A-Z][a-z]*$')) THEN
                 raise_application_error(
            -20001,
        'SUBORDER (' || :new.SUBORDER || ') must be Proper Case.'
            );
            END IF;
        END IF;
        IF :new.INFRAORDER IS NOT NULL THEN
           IF NOT (regexp_like(:new.INFRAORDER,'^[A-Z][a-z]*$')) THEN
                 raise_application_error(
            -20001,
        'INFRAORDER (' || :new.INFRAORDER || ') must be Proper Case.'
            );
            END IF;
        END IF;
        IF :new.FAMILY IS NOT NULL THEN
           IF NOT (regexp_like(:new.FAMILY,'^[A-Z][a-z]*$')) THEN
                 raise_application_error(
            -20001,
        'FAMILY (' || :new.FAMILY || ') must be Proper Case.'
            );
            END IF;
        END IF;
        IF :new.SUBFAMILY IS NOT NULL THEN
           IF NOT (regexp_like(:new.SUBFAMILY,'^[A-Z][a-z]*$')) THEN
                 raise_application_error(
            -20001,
        'SUBFAMILY (' || :new.SUBFAMILY || ') must be Proper Case.'
            );
            END IF;
        END IF;
        IF :new.SUBGENUS IS NOT NULL THEN
           IF NOT (regexp_like(:new.SUBGENUS,'^[A-Z][a-z]*$')) THEN
                 raise_application_error(
            -20001,
        'SUBGENUS (' || :new.SUBGENUS || ') must be Proper Case.'
            );
            END IF;
        END IF;
        IF :new.TRIBE IS NOT NULL THEN
           IF NOT (regexp_like(:new.TRIBE,'^[A-Z][a-z]*$')) THEN
                 raise_application_error(
            -20001,
        'TRIBE (' || :new.TRIBE || ') must be Proper Case.'
            );
            END IF;
        END IF;
        IF :new.SUBPHYLUM IS NOT NULL THEN
           IF NOT (regexp_like(:new.SUBPHYLUM,'^[A-Z][a-z]*$')) THEN
                 raise_application_error(
            -20001,
        'SUBPHYLUM (' || :new.SUBPHYLUM || ') must be Proper Case.'
            );
            END IF;
        END IF;
        IF :new.PHYLUM IS NOT NULL THEN
           IF NOT (regexp_like(:new.PHYLUM,'^[A-Z][a-z]*$')) THEN
                 raise_application_error(
            -20001,
        'PHYLUM (' || :new.PHYLUM || ') must be Proper Case.'
            );
            END IF;
        END IF;
        IF :new.KINGDOM IS NOT NULL THEN
           IF NOT (regexp_like(:new.KINGDOM,'^[A-Z][a-z]*$')) THEN
                 raise_application_error(
            -20001,
        'KINGDOM (' || :new.KINGDOM || ') must be Proper Case.'
            );
            END IF;
        END IF;
        IF :new.SUBCLASS IS NOT NULL THEN
           IF NOT (regexp_like(:new.SUBCLASS,'^[A-Z][a-z]*$')) THEN
                 raise_application_error(
            -20001,
        'SUBCLASS (' || :new.SUBCLASS || ') must be Proper Case.'
            );
            END IF;
        END IF;
        IF :new.INFRACLASS IS NOT NULL THEN
           IF NOT (regexp_like(:new.INFRACLASS,'^[A-Z][a-z]*$')) THEN
                 raise_application_error(
            -20001,
        'INFRACLASS (' || :new.INFRACLASS || ') must be Proper Case.'
            );
            END IF;
        END IF;        
        IF :new.SUPERFAMILY IS NOT NULL THEN
           IF NOT (regexp_like(:new.SUPERFAMILY,'^[A-Z][a-z]*$')) THEN
                 raise_application_error(
            -20001,
        'SUPERFAMILY (' || :new.SUPERFAMILY || ') must be Proper Case.'
            );
            END IF;
        END IF;
        IF :new.PHYLORDER IS NOT NULL THEN
           IF NOT (regexp_like(:new.PHYLORDER,'^[A-Z][a-z]*$')) THEN
                 raise_application_error(
            -20001,
        'PHYLORDER (' || :new.PHYLORDER || ') must be Proper Case.'
            );
            END IF;
        END IF;
        IF :new.phylclass IS NOT NULL THEN
           IF NOT (regexp_like(:new.phylclass,'^[A-Z][a-z]*$')) THEN
                 raise_application_error(
            -20001,
        'phylclass (' || :new.phylclass || ') must be Proper Case.'
            );
            END IF;
        END IF;
        IF :new.superclass IS NOT NULL THEN
           IF NOT (regexp_like(:new.superclass,'^[A-Z][a-z]*$')) THEN
                 raise_application_error(
            -20001,
        'superclass (' || :new.superclass || ') must be Proper Case.'
            );
            END IF;
        END IF;
    END IF;
    IF :new.genus IS NOT NULL THEN
        if :NEW.nomenclatural_code='ICBN' then
            if NOT (
                REGEXP_LIKE(:NEW.genus,'^[A-Z][a-z-]*[a-z]+$') OR
                (substr(:new.genus,1,1) = stoopidX and regexp_like(:new.genus,'^.[A-Z][a-z-]*[a-z]+$'))) then
               raise_application_error(-20001,
                   'genus (' || :new.genus || '-' || :NEW.taxon_name_id || ') must be Proper Case, but may start with a multiplication sign and contain a dash.');
            end if;
        ELSIF :NEW.nomenclatural_code='ICZN' THEN
            if NOT regexp_like(:new.genus,'^[A-Z][a-zæ]*$') then
                raise_application_error(-20001,
                    'genus (' || :new.genus || ') must be Proper Case.');
            END IF;
        END IF;
    END IF;
    IF :new.species IS NOT NULL THEN
        if :NEW.nomenclatural_code='ICBN' then
            IF NOT (
                REGEXP_LIKE(:NEW.species,'^[a-z][a-z-]*[a-z]+$') OR 
                (substr(:new.species,1,1) = stoopidX and regexp_like(:new.species,'^.[a-z][a-z-]*[a-z]+$'))) then
               raise_application_error(-20001,
                   'species (' || :new.species || ') must be lowercase letters, but may start with a multiplication sign and contain a dash.');
            end if;
        ELSIF :NEW.nomenclatural_code='ICZN' THEN
            IF NOT (REGEXP_LIKE(:NEW.species,'^[a-z]*$') OR REGEXP_LIKE(:NEW.species,'^[a-z]-[a-z]*$'))  THEN
                raise_application_error(-20001,
                    'species (' || :new.species || ') must be lowercase letters.');
            END IF;
        END IF;
    END IF;
    IF :new.subspecies IS NOT NULL THEN
        if :NEW.nomenclatural_code='ICBN' then
            if NOT (
                REGEXP_LIKE(:NEW.subspecies,'^[a-z][a-z-]*[a-z]+$') OR
                (substr(:new.subspecies,1,1) = stoopidX and regexp_like(:new.subspecies,'^.[a-z][a-z-]*[a-z]+$'))) then
               raise_application_error(-20001,
                   'subspecies (' || :new.subspecies || ') must be lowercase letters, but may start with a multiplication sign and contain a dash.');
            end if;
        ELSIF :NEW.nomenclatural_code='ICZN' THEN
            if NOT (regexp_like(:new.subspecies,'^[a-z][a-z]*[a-z]+$') OR regexp_like(:new.subspecies,'^[a-z]-[a-z][a-z]*[a-z]+$')) then
                raise_application_error(-20001,
                    'subspecies (' || :new.subspecies || ') must be lowercase letters.');
            END IF;
        END IF;
    END IF;

    -- uncomment to disable checks 
    -- (2) 
    -- end if;

    if :new.taxon_name_id is null then
    select sq_taxon_name_id.nextval into :new.taxon_name_id from dual;
    end if;

    if :NEW.nomenclatural_code='ICBN' AND :NEW.subspecies IS NOT NULL then
    nDisplayName:=prependTaxonomy(nDisplayName, :NEW.INFRASPECIFIC_AUTHOR);
    end if;
    /*if (:NEW.nomenclatural_code='ICZN' or :NEW.nomenclatural_code='noncompliant') AND :NEW.genus IS NOT NULL then
    nDisplayName:=prependTaxonomy(nDisplayName, :NEW.AUTHOR_TEXT);
    end if;*/
    nScientificName:=prependTaxonomy(nScientificName, :NEW.subspecies);
    nFullTaxonomy:=prependTaxonomy(nFullTaxonomy, :NEW.subspecies);
    nDisplayName:=prependTaxonomy(nDisplayName, :NEW.subspecies,1);

    if :NEW.nomenclatural_code='ICBN' or :NEW.infraspecific_rank='var.' then
    nScientificName:=prependTaxonomy(nScientificName, :NEW.infraspecific_rank);
    nFullTaxonomy:=prependTaxonomy(nFullTaxonomy, :NEW.infraspecific_rank);
    nDisplayName:=prependTaxonomy(nDisplayName, :NEW.infraspecific_rank);
    end if;
  
    /*if :NEW.nomenclatural_code='ICBN' AND :NEW.genus IS NOT NULL then
    nDisplayName:=prependTaxonomy(nDisplayName, :NEW.AUTHOR_TEXT);
    end if;*/

    nScientificName:=prependTaxonomy(nScientificName, :NEW.species);
    nFullTaxonomy:=prependTaxonomy(nFullTaxonomy, :NEW.species);
    nDisplayName:=prependTaxonomy(nDisplayName, :NEW.species,1);

    if :new.subgenus is not null then
    nScientificName:=prependTaxonomy(nScientificName, '(' || :NEW.subgenus || ')');
    nFullTaxonomy:=prependTaxonomy(nFullTaxonomy, '(' || :NEW.subgenus || ')');
    nDisplayName:=prependTaxonomy(nDisplayName, '(' || :NEW.subgenus || ')',1);
    end if;

    nScientificName:=prependTaxonomy(nScientificName, :NEW.genus);
    nFullTaxonomy:=prependTaxonomy(nFullTaxonomy, :NEW.genus);
    nDisplayName:=prependTaxonomy(nDisplayName, :NEW.genus,1);

    nScientificName:=prependTaxonomy(nScientificName, :NEW.tribe,0,1);
    nFullTaxonomy:=prependTaxonomy(nFullTaxonomy, :NEW.tribe);
    nDisplayName:=prependTaxonomy(nDisplayName, :NEW.tribe,0,1);

    nScientificName:=prependTaxonomy(nScientificName, :NEW.subfamily,0,1);
    nFullTaxonomy:=prependTaxonomy(nFullTaxonomy, :NEW.subfamily);
    nDisplayName:=prependTaxonomy(nDisplayName, :NEW.subfamily,0,1);

    nScientificName:=prependTaxonomy(nScientificName, :NEW.family,0,1);
    nFullTaxonomy:=prependTaxonomy(nFullTaxonomy, :NEW.family);
    nDisplayName:=prependTaxonomy(nDisplayName, :NEW.family,0,1);

    nScientificName:=prependTaxonomy(nScientificName, :NEW.superfamily,0,1);
    nFullTaxonomy:=prependTaxonomy(nFullTaxonomy, :NEW.superfamily);
    nDisplayName:=prependTaxonomy(nDisplayName, :NEW.superfamily,0,1);
    
    nScientificName:=prependTaxonomy(nScientificName, :NEW.subsection,0,1);
    nFullTaxonomy:=prependTaxonomy(nFullTaxonomy, :NEW.subsection);
    nDisplayName:=prependTaxonomy(nDisplayName, :NEW.subsection,0,1);
    
    nScientificName:=prependTaxonomy(nScientificName, :NEW.infraorder,0,1);
    nFullTaxonomy:=prependTaxonomy(nFullTaxonomy, :NEW.infraorder);
    nDisplayName:=prependTaxonomy(nDisplayName, :NEW.infraorder,0,1);

    nScientificName:=prependTaxonomy(nScientificName, :NEW.suborder,0,1);
    nFullTaxonomy:=prependTaxonomy(nFullTaxonomy, :NEW.suborder);
    nDisplayName:=prependTaxonomy(nDisplayName, :NEW.suborder,0,1);

    nScientificName:=prependTaxonomy(nScientificName, :NEW.phylorder,0,1);
    nFullTaxonomy:=prependTaxonomy(nFullTaxonomy, :NEW.phylorder);
    nDisplayName:=prependTaxonomy(nDisplayName, :NEW.phylorder,0,1);
    
    nScientificName:=prependTaxonomy(nScientificName, :NEW.superorder,0,1);
    nFullTaxonomy:=prependTaxonomy(nFullTaxonomy, :NEW.superorder);
    nDisplayName:=prependTaxonomy(nDisplayName, :NEW.superorder,0,1);
    
    nScientificName:=prependTaxonomy(nScientificName, :NEW.infraclass,0,1);
    nFullTaxonomy:=prependTaxonomy(nFullTaxonomy, :NEW.infraclass);
    nDisplayName:=prependTaxonomy(nDisplayName, :NEW.infraclass,0,1);

    nScientificName:=prependTaxonomy(nScientificName, :NEW.subclass,0,1);
    nFullTaxonomy:=prependTaxonomy(nFullTaxonomy, :NEW.subclass);
    nDisplayName:=prependTaxonomy(nDisplayName, :NEW.subclass,0,1);

    nScientificName:=prependTaxonomy(nScientificName, :NEW.phylclass,0,1);
    nFullTaxonomy:=prependTaxonomy(nFullTaxonomy, :NEW.phylclass);
    nDisplayName:=prependTaxonomy(nDisplayName, :NEW.phylclass,0,1);
    
    nScientificName:=prependTaxonomy(nScientificName, :NEW.superclass,0,1);
    nFullTaxonomy:=prependTaxonomy(nFullTaxonomy, :NEW.superclass);
    nDisplayName:=prependTaxonomy(nDisplayName, :NEW.superclass,0,1);
    
    nScientificName:=prependTaxonomy(nScientificName, :NEW.subdivision,0,1);
    nFullTaxonomy:=prependTaxonomy(nFullTaxonomy, :NEW.subdivision);
    nDisplayName:=prependTaxonomy(nDisplayName, :NEW.subdivision,0,1);
    
    nScientificName:=prependTaxonomy(nScientificName, :NEW.division,0,1);
    nFullTaxonomy:=prependTaxonomy(nFullTaxonomy, :NEW.division);
    nDisplayName:=prependTaxonomy(nDisplayName, :NEW.division,0,1);
    
    nScientificName:=prependTaxonomy(nScientificName, :NEW.subphylum,0,1);
    nFullTaxonomy:=prependTaxonomy(nFullTaxonomy, :NEW.subphylum);
    nDisplayName:=prependTaxonomy(nDisplayName, :NEW.subphylum,0,1);

    nScientificName:=prependTaxonomy(nScientificName, :NEW.phylum,0,1);
    nFullTaxonomy:=prependTaxonomy(nFullTaxonomy, :NEW.phylum);
    nDisplayName:=prependTaxonomy(nDisplayName, :NEW.phylum,0,1);

    nScientificName:=prependTaxonomy(nScientificName, :NEW.kingdom,0,1);
    nFullTaxonomy:=prependTaxonomy(nFullTaxonomy, :NEW.kingdom);
    nDisplayName:=prependTaxonomy(nDisplayName, :NEW.kingdom,0,1);

    :new.scientific_name:=nScientificName;
    :new.full_taxon_name:=nFullTaxonomy;
    :new.display_name:=nDisplayName;

    -- uncomment to disable checks
    -- (3)
    -- if 0 = 1 then 

    IF :new.scientific_name != :OLD.scientific_name THEN
        SELECT COUNT(*) INTO c FROM identification_taxonomy WHERE taxon_name_id=:NEW.taxon_name_id;
        IF c != 0 THEN
           -- uncomment this FOR DEVELOPER UPDATES ONLY!
           /*
           SELECT COUNT(DISTINCT(TAXA_FORMULA)) INTO c FROM identification,identification_taxonomy WHERE
               identification.identification_id=identification_taxonomy.identification_id AND
               taxon_name_id=:NEW.taxon_name_id;
           IF c != 1 THEN
               raise_application_error(
            -20001,
        ' more than A formulas used for ' || nScientificName
            );
            ELSE
                UPDATE identification SET scientific_name=nScientificName WHERE
                    identification_id IN (SELECT identification_id FROM
                    identification_taxonomy WHERE taxon_name_id=:NEW.taxon_name_id);
            END IF;
          */
           -- uncomment this for normal usage
           raise_application_error(
        -20002,
    :old.scientific_name || ' is used in Identifications and cannot be updated.'
          
        );
        /* 
        */
        END IF;
    END IF;
    
    -- uncomment to disable checks
   -- (4)
   -- end if;
    
EXCEPTION
	WHEN OTHERS THEN
    err_msg := SUBSTR(SQLERRM, 1, 100);
    IF err_msg like 'ORA-20001:%' THEN
      INSERT INTO bad_taxonomy (taxon_name_id, scientific_name, error_text)
      VALUES (:NEW.taxon_name_id, :NEW.scientific_name, err_msg);
    END IF;
END;
ALTER TRIGGER "TRG_TAXON_COMPOUND_NAMES" ENABLE