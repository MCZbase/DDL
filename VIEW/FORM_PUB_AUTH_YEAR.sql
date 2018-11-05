
  CREATE OR REPLACE FORCE VIEW "FORM_PUB_AUTH_YEAR" ("PUBLICATION_ID", "FORMAT_STYLE", "FORMATTED_PUBLICATION") AS 
  (
	select
		publication_id,
		'author-year' format_style,
		getAuthorYear(publication_id) formatted_publication
	from
		publication)
 