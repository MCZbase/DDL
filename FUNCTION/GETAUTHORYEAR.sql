
  CREATE OR REPLACE EDITIONABLE FUNCTION "GETAUTHORYEAR" (pub_id in varchar2 )
return varchar2
-- return an authorship string for a publication with author last names and year of publication.
-- uses last names of first and second authors, separated by and if there are two or more authors
-- followed by et al. if there are more than two authors, followed by the year of publication.
-- @param pub_id the publication_id of the publication for which to lookup the authorship
-- @return a string represeintation of the authorship and year of publication.
as
	type rc is ref cursor;
	l_str	varchar2(4000);
	l_sep	varchar2(30);
	t_sep	varchar2(30);
	l_val	varchar2(4000);
	title	varchar2(4000);
	loopcount	number;
	name_cur	rc;
	title_cur	rc;
	year_cur	rc;
	year_val	varchar2(30);
begin
	OPEN name_cur FOR 'SELECT last_name
		FROM
			agent_name,
			person,
			publication_author_name
		WHERE agent_name.agent_name_id = publication_author_name.agent_name_id
		AND agent_name.agent_id = person.person_id
		AND publication_id = :x
		ORDER BY author_position'
	USING pub_id;
	loopcount := 0;
    -- see how many authors we have
	loop
		fetch name_cur into l_val;
		exit when name_cur%notfound;
		loopcount := loopcount + 1;
	end loop;
	CLOSE name_cur;
	OPEN name_cur for 'SELECT last_name
		FROM
			agent_name,
			person,
			publication_author_name
		WHERE agent_name.agent_name_id = publication_author_name.agent_name_id
		AND agent_name.agent_id = person.person_id
		AND publication_id=:x
		ORDER BY author_position'
	using pub_id;
	case loopcount
		when 1 then
			fetch name_cur into l_val;
			l_str := l_str || l_val;
		when 2 then
			loop
				fetch name_cur into l_val;
				exit when name_cur%notfound;
				l_str := l_str || l_sep || l_val;
				l_sep := ' and ';
			end loop;
		else
			fetch name_cur into l_val;
			l_str := l_str ||  l_val || ' <i>et al.</i>';
	end case;
	/*
	loop
		fetch name_cur into l_val;
		exit when name_cur%notfound;
		loopcount := loopcount + 1;
	end loop;
	case loopcount
		when 1 then
			fetch name_cur into l_val;
			l_str := l_str || l_val;
		when 2 then
			loop
				fetch name_cur into l_val;
				exit when name_cur%notfound;
				l_str := l_str || 'got two' ;
			end loop;
		else
			fetch name_cur into l_val;
			l_str := l_str ||  l_val || ' et al.';
	end case;
	case loopcount
		when 1 then
			fetch name_cur into l_val;
			l_str := loopcount;
		when 2 then
			l_str := loopcount;
		else
			l_str := loopcount;
	end case;
	*/
	OPEN year_cur for 'SELECT published_year
		FROM publication
		WHERE publication_id = :x'
	using pub_id;
	fetch year_cur into year_val;
	l_sep := ' ';
	l_str := l_str || l_sep  || year_val;
	CLOSE year_cur;
	CLOSE name_cur;
	return l_str;
end;