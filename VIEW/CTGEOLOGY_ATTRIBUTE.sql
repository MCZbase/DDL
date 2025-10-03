
  CREATE OR REPLACE FORCE EDITIONABLE VIEW "CTGEOLOGY_ATTRIBUTE" ("GEOLOGY_ATTRIBUTE", "ORDINAL", "TYPE", "DESCRIPTION") AS 
  SELECT geology_attribute, ordinal, type, description
FROM MCZBASE.ctgeology_attributes
ORDER BY ordinal asc