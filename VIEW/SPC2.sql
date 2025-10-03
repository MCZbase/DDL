
  CREATE OR REPLACE FORCE EDITIONABLE VIEW "SPC2" ("BLA") AS 
  select part_name||':'||collection_cde bla
 from ctspecimen_part_name
 