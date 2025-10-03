
  CREATE OR REPLACE FORCE EDITIONABLE VIEW "FORM_PUB_FULL_CIT" ("PUBLICATION_ID", "FORMAT_STYLE", "FORMATTED_PUBLICATION") AS 
  (
	select
		publication_id,
		'full citation' format_style,
		getFullCitation(publication_id) formatted_publication
	from
		publication)
 