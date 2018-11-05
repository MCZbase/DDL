
  CREATE OR REPLACE PROCEDURE "MIA_MEDIA_KEYWORDS" IS
BEGIN
	INSERT INTO media_keywords (media_id) (
		SELECT media_id 
		FROM media 
		WHERE media_id NOT IN (
			SELECT media_id FROM media_keywords
		)
	);
END;
 
 