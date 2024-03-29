
  CREATE OR REPLACE FUNCTION "ASSEMBLE_FULLCITATION_TR" (
	publication_id IN VARCHAR2,
    publication_title in VARCHAR2,
    published_year in NUMBER,
    doi in VARCHAR2,
    publication_type in VARCHAR2,
	with_markup in NUMBER default 1
) RETURN VARCHAR2
	-- Assemble the full form of formatted_publication in a form sutable to exectute in a
    -- trigger on the publication table.
	-- Produces a value suitable to be saved in formatted_publication, but does not 
	-- populate formatted_publication.formatted_publication or change an existing value.
	-- @param publication_id, the publication id for which to assemble the full formatted citation.
	-- @param with_markup if 1 (default), includes html markup, if 0, removes html entities 
	--   and any start/end tags in the set: i,b,strong,sub,sup.
	-- @return a varchar representation of the long/full form of a citation for a publication.
 AS
	TYPE rc IS REF CURSOR;
	authors_cur			rc;
	authors_ct_cur		rc;
	editors_cur			rc;
	editors_ct_cur		rc;
	pub_cur				rc;
	attribs_cur			rc;
	retval				VARCHAR2(4000);
	yearval				VARCHAR2(4000);
	authortemp			VARCHAR2(4000);
	authors				VARCHAR2(4000);
	editors				VARCHAR2(4000);
	separator			VARCHAR2(20);
	author_count		NUMBER;
	author_counter		NUMBER;
	editor_count		NUMBER;
	title				VARCHAR2(4000);
	pub_type			VARCHAR2(255);
	pub_translation		VARCHAR2(4000);
	journal_name		VARCHAR2(4000);
	alternate_journal_name VARCHAR2(4000);
	journal_section		VARCHAR2(4000);
	pub_volume			VARCHAR2(4000);
	issue				VARCHAR2(4000);
	pub_number			VARCHAR2(4000);
	begin_page			VARCHAR2(4000);
	end_page			VARCHAR2(4000);
	series				VARCHAR2(4000);
	part				VARCHAR2(4000);
	supplement			VARCHAR2(4000);
	book_title			VARCHAR2(4000);
	publisher			VARCHAR2(4000);
    publisher_city      VARCHAR2(4000);
	page_total			VARCHAR2(4000);
	edition				VARCHAR2(4000);
	pub_version			VARCHAR2(4000);
	containing_work_author VARCHAR2(4000);
    thesis_type         VARCHAR2(4000);
    university          VARCHAR2(4000);
    date_accessed       VARCHAR2(4000);
    figure_number       VARCHAR2(4000);
    plate_number        VARCHAR2(4000);
    section_order       VARCHAR2(4000);
    section_type        VARCHAR2(4000);
BEGIN

	-- setup initial values
	retval := ' ';
	author_count := 0;
	author_counter := 0;
	editor_count := 0;
	authors := NULL;
	editors := NULL;

	-- authors
	OPEN authors_ct_cur FOR '
		SELECT COUNT(agent_name_id)
		FROM publication_author_name
		WHERE author_role = ''author''
			AND publication_id = :x '
	USING publication_id;
	LOOP 
		FETCH authors_ct_cur INTO author_count;
		IF authors_ct_cur%notfound THEN
			EXIT;
		END IF;
	END LOOP;

	IF author_count > 0 THEN
		OPEN authors_cur FOR '
		  SELECT agent_name
		  FROM publication_author_name
			join agent_name on publication_author_name.agent_name_id = agent_name.agent_name_id
		  WHERE publication_id = :x
			and author_role = ''author''
		  ORDER BY author_position ASC'
		USING publication_id;

		separator := '';
		-- retrieve authors, assemble into an authorship string
		LOOP
			FETCH authors_cur INTO authortemp;
			IF authors_cur%notfound THEN
				EXIT;
			END IF;
			author_counter := author_counter + 1;
			IF author_counter = author_count AND author_count > 2 THEN
				-- and before last author in list of more than 2
				separator := ', and ';
			END IF;
			authors := trim(authors || separator || authortemp);
			IF author_count = 2 THEN
				 -- a pair of authors is first and second
				separator := ' and ';
			ELSE 
				 -- other numbers of authors are a comma separated list
				separator := ', ';
			END IF;
		END LOOP;
	END IF;

	-- editors 
	OPEN editors_ct_cur FOR '
		SELECT
			COUNT(agent_name_id)
		FROM
			publication_author_name
		WHERE
			author_role = ''editor''
			AND publication_id = :x'
	USING publication_id;
	LOOP 
		FETCH editors_ct_cur INTO editor_count;
		IF editors_ct_cur%notfound THEN
			EXIT;
		END IF;
	END LOOP;

	IF editor_count > 0 THEN
		OPEN editors_cur FOR '
		  SELECT agent_name
		  FROM publication_author_name
			join agent_name on publication_author_name.agent_name_id = agent_name.agent_name_id
		  WHERE publication_id = :x
			and author_role = ''editor''  
		  ORDER BY author_position ASC'
			USING publication_id;

		separator := '';
		-- retrieve editors, assemble into an editorship string
		LOOP
			FETCH editors_cur INTO authortemp;
			IF editors_cur%notfound THEN
				EXIT;
			END IF;
			editors := trim(editors || separator || authortemp);
			IF editor_count = 2 THEN
				-- a pair of editors is first and second
				separator := ' and ';
			ELSE 
			 	-- other numbers of editors are a comma separated list
				separator := ', ';
			END IF;

		END LOOP;

	END IF;

	OPEN pub_cur FOR '
	  SELECT 
         get_publication_attribute(:a,''published year range'') year, 
		 get_publication_attribute(:b,''translation'') translation,
		 get_publication_attribute(:c,''journal name'') journal_name,
		 get_publication_attribute(:d,''alternate journal name'') alternate_journal_name,
		 get_publication_attribute(:e,''journal section'') journal_section,
		 get_publication_attribute(:f,''volume'') volume,
		 get_publication_attribute(:g,''issue'') issue,
		 get_publication_attribute(:h,''number'') pub_number,
		 get_publication_attribute(:i,''begin page'') begin_page,
		 get_publication_attribute(:j,''end page'') end_page,
		 get_publication_attribute(:k,''series'') series,
		 get_publication_attribute(:l,''part'') part,
		 get_publication_attribute(:m,''supplement'') supplement,
		 get_publication_attribute(:n,''book title'') book_title,
		 get_publication_attribute(:o,''publisher'') publisher,
		 get_publication_attribute(:p,''page total'') page_total,
		 get_publication_attribute(:q,''edition'') edition,
		 get_publication_attribute(:r,''version'') pub_version,
		 get_publication_attribute(:s,''book author (book section)'') containing_work_author,
         get_publication_attribute(:t,''publisher city'') publisher_city,
         get_publication_attribute(:u,''thesis type'') thesis_type,
         get_publication_attribute(:v,''university'') university,
         get_publication_attribute(:w,''date accessed'') date_accessed,
         get_publication_attribute(:x,''figure number'') figure_number,
         get_publication_attribute(:y,''plate number'') plate_number,
         get_publication_attribute(:z,''section order'') section_order,
         get_publication_attribute(:za,''section type'') section_type
	  FROM 
         dual
      '
		USING publication_id,publication_id,publication_id,publication_id,publication_id,
        publication_id,publication_id,publication_id,publication_id,publication_id,
        publication_id,publication_id,publication_id,publication_id,publication_id,
        publication_id,publication_id,publication_id,publication_id,publication_id,
        publication_id,publication_id,publication_id,publication_id,publication_id,
        publication_id,publication_id
        ;

	FETCH pub_cur INTO
		yearval,
		pub_translation,
		journal_name,
		alternate_journal_name,
		journal_section,
		pub_volume,
		issue,
		pub_number,
		begin_page,
		end_page,
		series,
		part,
		supplement,
		book_title,
		publisher,
		page_total,
		edition,
		pub_version,
		containing_work_author,
        publisher_city,
        thesis_type,
        university,
        date_accessed,
        figure_number,
        plate_number,
        section_order,
        section_type;

	dbms_output.put_line(pub_type);

   -- assemble the citation

   -- if there are any authors, start the result with the authorship string, terminated with a period.
	IF authors IS NOT NULL THEN
		retval := trim(authors);
		IF NOT regexp_like(retval,'[.]$') THEN
			retval := retval || '.';
		END IF;
	END IF;

   -- if there is a year or a year range, append this after the authorship string, terminated with a period.
	IF yearval IS NOT NULL THEN
		retval := retval || ' ' || trim(yearval) || '. ';
    elsif published_year is not null then
        retval := retval || ' ' || to_char(published_year) || '. '; 
	END IF;

	dbms_output.put_line(retval);

   -- make title end with a . if it does not end with . ! or ?   
	IF publication_title is not null AND NOT regexp_like(trim(publication_title), '[.!?]$') THEN
		title := trim(publication_title) || '.';
    elsif publication_title is not null THEN
        title := publication_title;
	END IF;

    pub_type := publication_type;

   -- assemble the rest of the citation depending on the publication type
	--  book
	IF pub_type = 'book' THEN
        retval := retval || ' ' || trim(editors);
        IF editor_count > 0 AND length(trim(editors)) > 0 THEN
			IF editor_count = 1 THEN
				retval := retval || ', Ed. ';
			ELSE
				retval := retval || ', Eds. ';
			END IF;
        END IF; 
        title := trim(title);
        -- strip off leading/trailing italics from title
        title := regexp_replace(title,'^<i>','');
        title := regexp_replace(title,'<\i>$','');
        -- change any embedded italics to be plain
        title := replace(replace(title,'<i>','</_i>'),'</i>','<_i>');
        title := trim(replace(title,'_i>','i>'));
        -- enclose entire title in italics
		retval := retval || '<i>' || title || '</i> ';
		IF length(pub_volume) > 0 THEN
			retval := retval || ' Vol. ' || trim(pub_volume);
			IF length(part) > 0 THEN
				retval := retval || ', Part ' || trim(part) || '. ';
			ELSE 
				retval := retval || '.';
			END IF;
		ELSE
			IF length(part) > 0 THEN
				retval := retval || ' Part ' || trim(part) || '. ';
			END IF;
		END IF;
		IF length(supplement) > 0 THEN
			retval := retval || ' Supplement ' || trim(supplement) || '. ';
		END IF;
		IF length(series) > 0 THEN
			retval := retval || ' (Series' || trim(series) || '). ';
		END IF;
		IF length(edition) > 0 THEN
			IF regexp_like(trim(edition),' ed(ition){0,1}[.]{0,1}$') THEN
				retval := retval || ' ' || regexp_replace(trim(edition),' ed(ition){0,1}[.]{0,1}$',' ') || ' edition. ';
			ELSE 
				retval := retval || ' ' || trim(edition) || ' edition. ';
			END IF;
		END IF;
		IF length(publisher) > 0 THEN
			IF regexp_like(trim(publisher),'[.]$') THEN
                publisher := regexp_replace(trim(publisher),'[.]$','');
			END IF;
            IF regexp_like(trim(publisher_city),'[.]$') THEN
                publisher_city := regexp_replace(trim(publisher_city),'[.]$','');
			END IF;
            IF length(publisher_city) > 0 THEN
                retval := retval || publisher || ', ' || publisher_city || '. ';
            ELSE 
                retval := retval || publisher || '. ';
            END IF;
		END IF;      
		IF length(page_total) > 0 THEN
			retval := retval || ' ' || page_total || ' pp.';
		ELSE
			IF NOT regexp_like(retval,'[.]$') THEN
				retval := retval || '.';
			END IF;
		END IF;
        IF length(figure_number) > 0 THEN
            if REGEXP_LIKE(figure_number,'^[0-9]+$') THEN
    			retval := retval || ' ' || figure_number || ' figures.';
            ELSE
                retval := retval || ' Figures: ' || figure_number || '.';
            END IF;
		END IF;  
        IF length(plate_number) > 0 THEN
            if REGEXP_LIKE(plate_number,'^[0-9]+$') THEN
                retval := retval || ' ' || plate_number || ' plates.';
            ELSE
                retval := retval || ' Plates: ' || plate_number || '.';
            END IF;                
		END IF; 
        -- remove any double spaces
        retval := trim(replace(retval,'  ',' '));

	END IF;

	--  book section
	IF pub_type = 'book section' THEN
		retval := retval || trim(title);
        IF length(section_order) > 0  THEN
            IF length(section_type) > 0  THEN
                retval := retval || section_type || ' ' || section_order || '.';
            ELSE
                retval := retval || 'Section ' || section_order || '.';
            END IF;
        END IF;
		IF length(begin_page) > 0 OR length(end_page) > 0 THEN
			IF begin_page = end_page THEN
				retval := retval || ' P. ' || begin_page || '.';
			ELSE
				retval := retval || ' Pp. ' || begin_page || chr(38) || 'ndash;' || end_page || '.';
			END IF;
		END IF;
		IF length(containing_work_author) > 0 OR length(book_title) > 0 THEN 
			retval := retval || ' <i>In</i> ';
			IF editor_count > 0 THEN
            	retval := retval || ' ' || trim(editors);
				IF editor_count = 1 THEN
					retval := retval || ' (ed.) ';
				ELSE
					retval := retval || ' (eds.) ';
				END IF;
			END IF;
			retval := retval || containing_work_author || ' <i>' || book_title || '</i>. ';
		END IF;
		IF length(edition) > 0 THEN
			IF regexp_like(trim(edition),' ed(ition){0,1}[.]{0,1}$') THEN
				retval := retval || ' ' || regexp_replace(trim(edition),' ed(ition){0,1}[.]{0,1}$',' ') || ' edition.';
			ELSE 
				retval := retval || ' ' || trim(edition) || ' edition.';
			END IF;
		END IF;
		IF length(pub_volume) > 0 THEN
			retval := retval || ' Vol. ' || trim(pub_volume);
			IF length(part) > 0 THEN
				retval := retval || ', Part ' || trim(part) || '. ';
			ELSE 
				retval := retval || '. ';
			END IF;
		ELSE
			IF length(part) > 0 THEN
				retval := retval || ' Part ' || trim(part) || '. ';
			END IF;
		END IF;
		IF length(publisher) > 0 THEN
			IF regexp_like(trim(publisher),'[.]$') THEN
                publisher := regexp_replace(trim(publisher),'[.]$','');
			END IF;
            IF regexp_like(trim(publisher_city),'[.]$') THEN
                publisher_city := regexp_replace(trim(publisher_city),'[.]$','');
			END IF;
            IF length(publisher_city) > 0 THEN
                retval := retval || publisher || ', ' || publisher_city || '. ';
            ELSE 
                retval := retval || publisher || '. ';
            END IF;
		END IF;
		IF length(page_total) > 0 THEN
			retval := retval || ' ' || page_total || ' pp.';
		END IF;
        IF length(figure_number) > 0 THEN
            if REGEXP_LIKE(figure_number,'^[0-9]+$') THEN
    			retval := retval || ' ' || figure_number || ' figures.';
            ELSE
                retval := retval || ' Figures: ' || figure_number || '.';
            END IF;
		END IF;  
        IF length(plate_number) > 0 THEN
            if REGEXP_LIKE(plate_number,'^[0-9]+$') THEN
                retval := retval || ' ' || plate_number || ' plates.';
            ELSE
                retval := retval || ' Plates: ' || plate_number || '.';
            END IF;                
		END IF;         
	END IF;

	--  journal article
	--  journal section
	IF pub_type = 'journal article' OR pub_type = 'journal section' THEN
		retval := retval || trim(title) || ' ';
		IF length(pub_translation) > 0 THEN
			retval := retval || ' [' || trim(pub_translation) || '] ';
		END IF;
		IF pub_type = 'journal section' AND length(journal_section) > 0 THEN
            IF length(containing_work_author) > 0 THEN 
                retval := retval || ' <i>In</i>: ' || containing_work_author;
                IF length(editors) > 0 THEN
                    retval := retval || ' ' || trim(editors);
                END IF;
            ELSE
            	retval := retval || ' <i>In</i>: ' || trim(editors);
            END IF;
			IF editor_count = 1 THEN
				retval := retval || '., (ed.) ';
			ELSIF editor_count > 1 THEN
				retval := retval || '., (eds.) ';
            ELSE 
                retval := retval || ' ';
			END IF;
			retval := retval || trim(journal_section) || '. ';
		END IF;
		retval := retval || journal_name;
		IF length(series) > 0 THEN
			retval := retval || ', Series ' || trim(series) || ',';
		END IF;
		IF length(part) > 0 THEN
			retval := retval || ', Part ' || trim(part) || ','; 
		END IF;
        retval := replace(retval,',,',','); 
		retval := retval || ' ' || pub_volume;
		IF length(pub_number) > 0 THEN
			IF length(pub_volume) > 0 OR length(issue) > 0 THEN
				retval := retval || '(' || pub_number || ')';
			ELSE 
				-- cases like Breviora, number but no volume (or issue).
				retval := retval || pub_number;
			END IF;
		END IF;
		IF length(issue) > 0 THEN
			IF length(pub_volume) > 0 OR length(pub_number) > 0 THEN
				retval := retval || '(' || issue || ')';
			ELSE 
				-- cases like Copeia, issue but no volume or number
				retval := retval || issue;
			END IF;
		END IF;
		IF length(begin_page) > 0 OR length(end_page) > 0 THEN
			IF begin_page = end_page THEN
				retval := retval || ':' || begin_page || '.';
            ELSIF end_page is null THEN
                retval := retval || ':' || begin_page || '.';
			ELSE
				retval := retval || ':' || begin_page || chr(38) || 'ndash;' || end_page || '.';
			END IF;
		END IF;
		IF length(supplement) > 0 THEN
			retval := retval || ' Supplement ' || supplement || '.';
		END IF;
	END IF;

	--  newsletter
	IF pub_type = 'newsletter' THEN
		retval := retval || trim(title) || ' ';
		IF length(publisher) > 0 THEN
			IF regexp_like(trim(publisher),'[.]$') THEN
                publisher := regexp_replace(trim(publisher),'[.]$','');
			END IF;
            IF regexp_like(trim(publisher_city),'[.]$') THEN
                publisher_city := regexp_replace(trim(publisher_city),'[.]$','');
			END IF;
            IF length(publisher_city) > 0 THEN
                retval := retval || publisher || ', ' || publisher_city || '. ';
            ELSE 
                retval := retval || publisher || '. ';
            END IF;
		END IF;
		IF length(pub_volume) > 0 THEN
			retval := retval || ' ' || trim(pub_volume);
		END IF;
		IF length(pub_number) > 0 THEN
			IF length(pub_volume) = 0 THEN
				retval := retval || ' No. ' || trim(pub_number) || ' ';
			ELSE
				retval := retval || '(' || trim(pub_number) || ') ';
			END IF;
		END IF;
		IF length(issue) > 0 THEN
			IF length(pub_volume) = 0 AND length(pub_number) = 0 THEN
				retval := retval || ' No. ' || trim(issue) || ' ';
			ELSE
				retval := retval || '(' || trim(issue) || ') ';
			END IF;
		END IF;
		IF length(begin_page) > 0 OR length(end_page) > 0 THEN
			IF length(pub_volume) > 0 OR length(pub_number) > 0 OR length(issue) > 0 THEN
				retval := trim(retval) || ':';
            ELSE 
              retval := trim(retval) || ' ';
			END IF;
			IF begin_page = end_page THEN
				retval := retval || begin_page || '.';
			ELSE
				retval := retval || begin_page || chr(38) || 'ndash;' || end_page || '.';
			END IF;
		END IF;
	END IF;

	--  annual report
	IF pub_type = 'annual report' THEN
        -- strip off trailing period from title
        title := trim(title);
        title := regexp_replace(title,'[.]$','');
        -- unlike other cases, follow title with a comma.
		retval := retval || trim(title) || ', ';
		IF length(journal_name) > 0 THEN
			retval := retval || '<i>' || journal_name || '.</i> ';
		END IF;
		IF length(pub_number) > 0 THEN
			retval := retval || ' no. ' || pub_number || '.';
		END IF;
        IF (page_total is null) AND ( length(begin_page) > 0 OR length(end_page) > 0) THEN
			IF begin_page = end_page THEN
				retval := retval || ' p. ' || begin_page || '.';
			ELSE
				retval := retval || ' pp. ' || begin_page || chr(38) || 'ndash;' || end_page || '.';
			END IF;
		END IF;
        -- note city: publisher, different from usual publisher, city
		IF length(publisher) > 0 THEN
			IF regexp_like(trim(publisher),'[.]$') THEN
                publisher := regexp_replace(trim(publisher),'[.]$','');
			END IF;
            IF regexp_like(trim(publisher_city),'[.]$') THEN
                publisher_city := regexp_replace(trim(publisher_city),'[.]$','');
			END IF;
            IF length(publisher_city) > 0 THEN
                retval := retval || publisher_city || ': ' || publisher || '. ';
            ELSE 
                retval := retval || publisher || '. ';
            END IF;
		END IF;
        IF length(page_total) > 0 THEN
			retval := retval || ' ' || page_total || ' pp.';
		END IF;
	END IF;

	--  serial monograph
	IF pub_type = 'serial monograph' THEN
        retval := retval || ' ' || trim(editors);
        IF editor_count > 0 AND length(trim(editors)) > 0 THEN
			IF editor_count = 1 THEN
				retval := retval || ', Ed. ';
			ELSE
				retval := retval || ', Eds. ';
			END IF;
        END IF;            
		retval := retval || trim(title) || ' ';
        IF length(section_order) > 0  THEN
            IF length(section_type) > 0  THEN
                retval := retval || section_type || ' ' || section_order || '.';
            ELSE
                retval := retval || 'Section ' || section_order || '.';
            END IF;
        END IF;
		IF length(journal_name) > 0 THEN
			retval := retval || ' <i>' || trim(journal_name) || '</i>, ';
		END IF;
		IF length(series) > 0 THEN
			retval := retval || ' ' || trim(series) || ', ';
		END IF;
		IF length(pub_volume) > 0 THEN
            IF (length(pub_number) > 0 or length(issue) > 0) and part is null then
                retval := retval || ' ' || trim(pub_volume);
                IF length(part) > 0 THEN
        			retval := retval || ', Partxx ' || trim(part) || '. ';
        		END IF;   
            else 
                retval := retval || ' Vol. ' || trim(pub_volume);
    			IF length(part) > 0 THEN
        			retval := retval || ', Part ' || trim(part) || '.';
            	ELSE 
                	retval := retval || '.';
        		END IF;                
            end if;
		ELSE
			IF length(part) > 0 THEN
				retval := retval || ' Part ' || trim(part) || '.';
			END IF;
		END IF;
		IF length(pub_number) > 0 THEN
			IF length(pub_volume) > 0 and part is null THEN
				retval := retval || '(' || pub_number || ')';
			ELSE 
				retval := retval || ' no. ' || pub_number;
			END IF;
		END IF;
		IF length(issue) > 0 THEN
			IF length(pub_volume) > 0 and part is null THEN
				retval := retval || '(' || issue || ')';
			ELSE 
				retval := retval || ' issue ' || issue;
			END IF;
		END IF;
		IF length(begin_page) > 0 OR length(end_page) > 0 THEN
			IF begin_page = end_page THEN
				IF regexp_like(trim(retval),'[)]$') THEN
					retval := retval || ':';
				ELSE 
					retval := retval || ' p. ';
				END IF;
				retval := retval || begin_page || '.';
			ELSE
				IF regexp_like(trim(retval),'[)]$') THEN
					retval := retval || ':';
				ELSE 
					retval := retval || ' pp. ';
				END IF;
				retval := retval || begin_page || chr(38) || 'ndash;' || end_page || '.';
			END IF;
		END IF;
		IF length(supplement) > 0 THEN
			retval := retval || ' Supplement ' || trim(supplement) || '.';
		END IF;
		IF length(edition) > 0 THEN
			IF regexp_like(trim(edition),' ed(ition){0,1}[.]{0,1}$') THEN
				retval := retval || ' ' || regexp_replace(trim(edition),' ed(ition){0,1}[.]{0,1}$',' ') || ' edition.';
			ELSE 
				retval := retval || ' ' || trim(edition) || ' edition.';
			END IF;
		END IF;
		IF length(publisher) > 0 THEN
			IF regexp_like(trim(publisher),'[.]$') THEN
                publisher := regexp_replace(trim(publisher),'[.]$','');
			END IF;
            IF regexp_like(trim(publisher_city),'[.]$') THEN
                publisher_city := regexp_replace(trim(publisher_city),'[.]$','');
			END IF;
            IF length(publisher_city) > 0 THEN
                retval := retval || ' ' || publisher || ', ' || publisher_city || '. ';
            ELSE 
                retval := retval || ' '  || publisher || '. ';
            END IF;
		END IF;
		IF length(page_total) > 0 THEN
			retval := retval || ' ' || page_total || ' pp.';
		ELSE
			IF NOT regexp_like(retval,'[.]$') THEN
				retval := retval || '.';
			END IF;
		END IF;
                IF length(figure_number) > 0 THEN
            if REGEXP_LIKE(figure_number,'^[0-9]+$') THEN
    			retval := retval || ' ' || figure_number || ' figures.';
            ELSE
                retval := retval || ' Figures: ' || figure_number || '.';
            END IF;
		END IF;  
        IF length(plate_number) > 0 THEN
            if REGEXP_LIKE(plate_number,'^[0-9]+$') THEN
                retval := retval || ' ' || plate_number || ' plates.';
            ELSE
                retval := retval || ' Plates: ' || plate_number || '.';
            END IF;                
		END IF; 

	END IF;

	--  data release
	IF pub_type = 'data release' THEN
		retval := retval || trim(title) || ' ';
		IF length(pub_version) > 0 THEN
			retval := retval || ' (' || pub_version || '). ';
		END IF;        
		IF length(publisher) > 0 THEN
			IF regexp_like(trim(publisher),'[.]$') THEN
                publisher := regexp_replace(trim(publisher),'[.]$','');
			END IF;
            IF regexp_like(trim(publisher_city),'[.]$') THEN
                publisher_city := regexp_replace(trim(publisher_city),'[.]$','');
			END IF;
            IF length(publisher_city) > 0 THEN
                retval := retval || publisher || ', ' || publisher_city || '. ';
            ELSE 
                retval := retval || publisher || '. ';
            END IF;
		END IF;
		IF length(date_accessed) > 0 THEN
			retval := retval || ' Accessed ' || date_accessed || '. ';
		END IF;          
	END IF;

	--  thesis
	IF pub_type = 'thesis' THEN
		retval := retval || trim(title) || ' ';
		IF length(thesis_type) > 0 THEN
			IF regexp_like(trim(thesis_type),'[.]$') THEN
                thesis_type := regexp_replace(trim(thesis_type),'[.]$','');
			END IF;
        END IF;    
        IF length(university) > 0 THEN
            IF regexp_like(trim(university),'[.]$') THEN
                university := regexp_replace(trim(university),'[.]$','');
			END IF;
        END IF;    
        retval := retval || thesis_type || ', ' || university || ', ' || publisher_city || '. ';
        retval := replace(retval,', , ',', ');
        retval := replace(retval,', . ','. ');

		IF length(page_total) > 0 THEN
			retval := retval || ' ' || page_total || ' pp.';
		ELSE
			IF NOT regexp_like(retval,'[.]$') THEN
				retval := retval || '.';
			END IF;
		END IF;        
	END IF;    

	-- terminate with a period if not already.
	retval := trim(retval);
	IF NOT regexp_like(retval,'[?.]$') THEN
		retval := retval || '.';
	END IF;
	-- always append doi if there is one
	IF length(doi) > 0 THEN
		retval := retval || ' doi:' || doi || '.';
	END IF;
	-- remove any instances of two spaces in a row
	retval := replace(retval,'  ',' ');
    -- remove any instances of period space period, expected from missing data.
    retval := replace(retval,'. .','.');
    -- remove extraneous period inside and outside of end italic tag, expected from missing data.
    retval := replace(retval,'.</i> .','.</i>');

	IF with_markup  = 0 THEN
		retval := regexp_replace(retval,'<[/]{0,1}(i|b|sub|sup|strong)>','');
		retval := UTL_I18N.UNESCAPE_REFERENCE(retval);
	END IF;

	dbms_output.put_line(retval);
	RETURN trim(retval);
END;