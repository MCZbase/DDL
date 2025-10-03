
  CREATE OR REPLACE EDITIONABLE FUNCTION "GET_PUBLICATION_EDITORS" 
(
  PUBLICATION_ID IN NUMBER  
) RETURN VARCHAR2 
--  Supporting the Publications part of the MCZ website  (publications.mcz.harvard.edu) --
--  Given a publication id, return the editors in the authorship string --
--  @param publication_id the publication to look up the editors for
--  @return the editors for a publication, assembled in order in a string.
AS 
      type rc is ref cursor;
      l_str    varchar2(4000);
      l_sep    varchar2(30);
      l_val    varchar2(4000);
      numauths number;
      firstauthnum number;
      counter  number;
      l_cur    rc;
      fan_cur  rc;
      first_cur rc;
      c_cur    rc;
   begin

      l_sep := '';
      l_str := '';
      numauths := 0;
      open c_cur for '
                  SELECT
                    count(agent_name)
            FROM
                    agent_name,
                    publication_author_name
            WHERE
                    author_role = ''editor'' and 
                    (agent_name_type = ''author'' or agent_name_type = ''second author'') and
                    agent_name.agent_name_id = publication_author_name.agent_name_id
                    AND publication_id=:x '
           using publication_id; 
      loop
           fetch c_cur into numauths;
           exit when c_cur%notfound;
      end loop;

      close c_cur;

      if numauths = 1 then 
         --  Just one author, obtain the first author name formulation for that author.
         counter := 0;
         open first_cur for '
            SELECT
                    agent_name
            FROM
                    agent_name,
                    publication_author_name
            WHERE
                    author_role = ''editor'' and             
                    agent_name_type = ''author'' and
                    agent_name.agent_name_id = publication_author_name.agent_name_id
                    AND publication_id=:x
            ORDER BY
                    author_position'
            using publication_id;
          loop
             fetch first_cur into l_val;
             exit when first_cur%notfound;
             l_str := l_str || l_sep || l_val;
             l_sep := ', ';           
             counter := counter + 1;
             if (counter=numauths-1) then 
                l_sep := ' and ';
             end if;
          end loop;
          close first_cur;

      else
         --  More than one author, obtain the first author formulation for the first, and second author forumuation for the rest.

         --  Find the lowest author position (the first author), 1 if list was not edited but can be higher numbers if authorship list has been edited.
         firstauthnum := 1;
         open fan_cur for '
            SELECT
                    min(author_position)
            FROM
                    publication_author_name
            WHERE
                    author_role = ''editor'' and 
                    publication_id=:x                   
            '
            using publication_id;
         loop
             fetch fan_cur into firstauthnum;
             exit when fan_cur%notfound;
         end loop;
         close fan_cur;             

         --  First author 
         counter := 0;
         open first_cur for '
            SELECT
                    agent_name
            FROM
                    agent_name,
                    publication_author_name
            WHERE
                    author_role = ''editor'' and 
                    agent_name_type = ''author'' and
                    agent_name.agent_name_id = publication_author_name.agent_name_id
                    AND publication_id=:x
                    AND author_position = :y                    
            ORDER BY
                    author_position'
            using publication_id, firstauthnum;
         loop
             fetch first_cur into l_val;
             exit when first_cur%notfound;
             l_str := l_str || l_sep || l_val;
             l_sep := ', ';           
             counter := counter + 1;
             if (counter=numauths-1) then 
                l_sep := ' and ';
             end if;
         end loop;
         close first_cur;      

          -- Subsequent authors 
         open l_cur for '
            SELECT
                    agent_name
            FROM
                    agent_name,
                    publication_author_name
            WHERE
                    author_role = ''editor'' and 
                    agent_name_type = ''second author'' and
                    agent_name.agent_name_id = publication_author_name.agent_name_id
                    AND publication_id=:x
                    AND author_position > 1
            ORDER BY
                    author_position'
            using publication_id;
         loop
            fetch l_cur into l_val;
            exit when l_cur%notfound;
            l_str := l_str || l_sep || l_val;
            l_sep := ', ';           
            counter := counter + 1;
            if (counter=numauths-1) then 
               l_sep := ' and ';
            end if;
         end loop;
         close l_cur;

       end if;

       return l_str;

  RETURN NULL;
END GET_PUBLICATION_EDITORS;