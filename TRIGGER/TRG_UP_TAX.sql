
  CREATE OR REPLACE TRIGGER "TRG_UP_TAX" after update on taxonomy
for each row
begin
         insert into taxonomy_archive (
                when,
                who,
                TAXON_NAME_ID,
                PHYLCLASS,
                PHYLORDER,
                SUBORDER,
                FAMILY,
                SUBFAMILY,
                GENUS,
                SUBGENUS,
                SPECIES,
                SUBSPECIES,
                VALID_CATALOG_TERM_FG,
                SOURCE_AUTHORITY,
                FULL_TAXON_NAME,
                SCIENTIFIC_NAME,
                AUTHOR_TEXT,
                TRIBE,
                INFRASPECIFIC_RANK ,
                TAXON_REMARKS,
                PHYLUM,
                SUPERFAMILY,
                SUBPHYLUM,
                SUBCLASS,
                KINGDOM,
                NOMENCLATURAL_CODE,
                INFRASPECIFIC_AUTHOR,
                INFRAORDER,
                SUPERORDER,
                DIVISION,
                SUBDIVISION,
                SUPERCLASS
         ) values (
                sysdate,
                user,
                :OLD.TAXON_NAME_ID,
                :OLD.PHYLCLASS,
                :OLD.PHYLORDER,
                :OLD.SUBORDER,
                :OLD.FAMILY,
                :OLD.SUBFAMILY,
                :OLD.GENUS,
                :OLD.SUBGENUS,
                :OLD.SPECIES,
                :OLD.SUBSPECIES,
                :OLD.VALID_CATALOG_TERM_FG,
                :OLD.SOURCE_AUTHORITY,
                :OLD.FULL_TAXON_NAME,
                :OLD.SCIENTIFIC_NAME,
                :OLD.AUTHOR_TEXT,
                :OLD.TRIBE,
                :OLD.INFRASPECIFIC_RANK ,
                :OLD.TAXON_REMARKS,
                :OLD.PHYLUM,
                :OLD.SUPERFAMILY,
                :OLD.SUBPHYLUM,
                :OLD.SUBCLASS,
                :OLD.KINGDOM,
                :OLD.NOMENCLATURAL_CODE,
                :OLD.INFRASPECIFIC_AUTHOR,
                :OLD.INFRAORDER,
                :OLD.SUPERORDER,
                :OLD.DIVISION,
                :OLD.SUBDIVISION,
                :OLD.SUPERCLASS
         );
end;
ALTER TRIGGER "TRG_UP_TAX" ENABLE