
  CREATE OR REPLACE FUNCTION "AY" (pub_id  in varchar2 )
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
                                           using pub_id
                   ;

       loopcount := 0;
       --- see how many authors we have

       loop
           fetch name_cur into l_val;
           exit when name_cur%notfound;
           loopcount := loopcount + 1;
       end loop;
       close name_cur;
        open name_cur for 'select  last_name FROM
       						agent_name,
       						person,
       						publication_author_name
       					WHERE
       						agent_name.agent_name_id = publication_author_name.agent_name_id
       						AND agent_name.agent_id = person.person_id
       						AND publication_id=:x
       					ORDER BY author_position'
                                           using pub_id
                   ;
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
           		l_str := l_str ||  l_val || ' et al.';
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
       open year_cur for 'select published_year from publication where
       publication_id=:x'
       using pub_id
       ;
       fetch year_cur into year_val;
       l_sep := ' ';
       l_str := l_str || l_sep  || year_val;
        close year_cur;

    close name_cur;
       return l_str;
  end;
 
 