
  CREATE OR REPLACE FORCE VIEW "CTGEOLOGY_ATTRIBUTE" ("GEOLOGY_ATTRIBUTE") AS 
  SELECT attribute geology_attribute
 FROM geology_attribute_hierarchy
 WHERE usable_value_fg=1
 GROUP BY attribute
 