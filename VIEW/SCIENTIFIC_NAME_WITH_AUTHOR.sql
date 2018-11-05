
  CREATE OR REPLACE FORCE VIEW "SCIENTIFIC_NAME_WITH_AUTHOR" ("TAXON_NAME_ID", "SCIENTIFIC_NAME") AS 
  select
	taxon_name_id,
	'<i>' || scientific_name || '</a>' ||
	decode(author_text,
	NULL,'',
	' ' || author_text) scientific_name
	from taxonomy
 