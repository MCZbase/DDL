
  CREATE OR REPLACE FUNCTION "ASSEMBLE_FULLCITATION" (
	publication_id IN VARCHAR2,
	with_markup in NUMBER default 1
) RETURN VARCHAR2
	-- Assemble the full form of formatted_publication.
	-- Produces a value suitable to be saved in formatted_publication, but does not 
	-- populate formatted_publication.formatted_publication or change an existing value.
	-- @param publication_id, the publication id for which to assemble the full formatted citation.
	-- @param with_markup if 1 (default), includes html markup, if 0, removes html entities 
	--   and any start/end tags in the set: i,b,strong,sub,sup.
	-- @return a varchar representation of the long/full form of a citation for a publication.
    -- @see assemble_fullcitation_tr for a form suitable for invocation from a trigger on publication.
AS
	TYPE rc IS REF CURSOR;
	pub_cur				rc;
    retval varchar2(4000);
BEGIN

    retval := '';

    OPEN pub_cur FOR '
       SELECT assemble_fullcitation_tr(publication_id, publication_title, published_year, doi, publication_type,:x)
       FROM publication 
       WHERE  publication_id = :y '
    USING with_markup, publication_id;

	LOOP 
		FETCH pub_cur INTO retval;
		IF pub_cur%notfound THEN
			EXIT;
		END IF;
	END LOOP;

	RETURN trim(retval);
END;