
  CREATE OR REPLACE FUNCTION "CONCATNAME" (p_key_val  in varchar2 )
    return varchar2
    as
        type rc is ref cursor;
        l_str    varchar2(4000);
       l_sep    varchar2(30);
       t_sep    varchar2(30);
       l_val    varchar2(4000);
       title varchar2(4000);
loopcount	number;
       name_cur    rc;
       title_cur    rc;
       year_cur rc;
       year_val varchar2(30);
   begin
    open name_cur for 'select  last_name FROM
       						agent_name,
       						person,
       						publication_author_name
       					WHERE
       						agent_name.agent_name_id = publication_author_name.agent_name_id
       						AND agent_name.agent_id = person.person_id
       						AND publication_id=:x
       					ORDER BY author_position'
                                           using p_key_val
                   ;

       loopcount := 1;
       loop
           fetch name_cur into l_val;
           exit when name_cur%notfound;
           case true
when loopcount = 1 then
	           l_str := l_str || l_sep || l_val;
	           l_sep := '';

	           when loopcount = 2 then
	           	l_sep := ' ';
	        	l_str := l_str || l_sep || 'et al.';

	        when loopcount > 2 then
	        	l_str := l_str;
	        end case;
           /*
           if name_cur%rowcount > 2
           	then
           		l_sep := ', ';
           else
           		l_sep := ':: ';
           end if;
           */
       loopcount := loopcount + 1;
       end loop;
       open year_cur for 'select published_year from publication where
       publication_id=:x'
       using p_key_val
       ;
       fetch year_cur into year_val;
       l_sep := ' ';
       l_str := l_str || l_sep  || year_val;
        close year_cur;
      /*

       open title_cur for 'select publication_title from publication where
      	publication_id = :x'
      	USING p_key_val;
      	fetch name_cur into title;
      	l_str := l_str || t_sep || title;
      	t_sep := '. ';
   close title_cur;
   */
    close name_cur;
       return l_str;
  end;
 
 