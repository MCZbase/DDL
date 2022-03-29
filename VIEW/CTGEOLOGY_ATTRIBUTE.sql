
  CREATE OR REPLACE FORCE VIEW "CTGEOLOGY_ATTRIBUTE" ("GEOLOGY_ATTRIBUTE", "ORDINAL", "TYPE", "DESCRIPTION") AS 
  SELECT geology_attribute, ordinal, type, description
FROM MCZBASE.ctgeology_attributes
ORDER BY ordinal asc