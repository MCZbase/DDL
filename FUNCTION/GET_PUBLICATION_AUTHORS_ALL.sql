
  CREATE OR REPLACE EDITIONABLE FUNCTION "GET_PUBLICATION_AUTHORS_ALL" 
(
  PUBLICATION_ID IN NUMBER  
) RETURN VARCHAR2 
--  Supporting the Publications part of the MCZ website  --
--  Given a publication id, return the authorship string --
AS 
      type rc is ref cursor;
      l_str    varchar2(4000);
      l_sep    varchar2(30);
      l_val    varchar2(4000);
      numauths number;
      counter  number;
      l_cur    rc;
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
                    agent_name.agent_name_id = publication_author_name.agent_name_id
                    AND publication_id=:x '
           using publication_id; 
      loop
           fetch c_cur into numauths;
           exit when c_cur%notfound;
      end loop;
      
      close c_cur;
      
      if numauths = 1 then 
      
      counter := 0;
      open first_cur for '
            SELECT
                    agent_name
            FROM
                    agent_name,
                    publication_author_name
            WHERE
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
      
      counter := 0;
      open first_cur for '
            SELECT
                    agent_name
            FROM
                    agent_name,
                    publication_author_name
            WHERE
                    agent_name.agent_name_id = publication_author_name.agent_name_id
                    AND publication_id=:x
                    AND author_position = 1                    
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
      
      open l_cur for '
            SELECT
                    agent_name
            FROM
                    agent_name,
                    publication_author_name
            WHERE
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
END GET_PUBLICATION_AUTHORS_ALL;
 