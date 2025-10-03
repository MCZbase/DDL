
  CREATE OR REPLACE EDITIONABLE FUNCTION "ASSEMBLE_SHORTCITATION_TR" (publication_id  in varchar2, publication_title in varchar2, published_year in number )
    return varchar2
    -- Assemble the short form of formatted_publication in a manner that can run on 
    -- a trigger on the publication table.
    -- Produces a value suitable to be saved in formatted_publication, but does not 
    -- populate formatted_publication.formatted_publication or change an existing value.
    -- @param pub_id, the publication id for which to assemble the short formatted citation.
    -- @param publication_title use :NEW.publication_title in a trigger on publication.
    -- @param published_year use :NEW.published_year in a trigger on publication.
    -- @return a varchar representation of the short form of a citation for a publication.
AS     
       type rc is ref cursor;
       authors_cur rc;
       pub_cur rc;
       yearval varchar2(255);
       authortemp varchar2(4000);
       author1 varchar2(4000);
       author2 varchar2(4000);
       authors varchar2(4000);
       retval  varchar2(4000);
       author_count number;
       titleval varchar2(4000);
       titlechars number;
BEGIN  

   retval := ' ';
   author_count := 0;

   open authors_cur for '
      SELECT nvl(last_name, agent_name) as name
      FROM publication_author_name
        join agent_name on publication_author_name.agent_name_id = agent_name.agent_name_id
        left join person on agent_name.agent_id = person.person_id
      WHERE publication_id = :x
        and author_role = ''author''  
      ORDER BY author_position ASC'
   using publication_id; 

   -- retrieve up to the first three authors
   loop 
      fetch authors_cur into authortemp;
      if authors_cur%NOTFOUND then 
        exit;
      end if;
      author_count := author_count + 1;
      if author_count > 2 then 
         exit;
      end if;
      if author_count = 1 then
         author1 := authortemp;
      end if;  
      if author_count = 2 then
         author2 := authortemp;
      end if; 
   end loop;

   -- assemble the authorship string for one, two, or more than two authors
   if author_count = 1 then
      authors := trim(author1);
   end if;
   if author_count = 2 then 
       authors := trim(author1) || ' and ' || trim(author2);
   end if;
   if author_count > 2 then 
       authors := trim(author1) || ' et al.';
   end if;

   -- if there are any authors, start the result with the authorship string 
   if authors is not null then
      retval := authors;
   end if;

   open pub_cur for '
      SELECT pub_att_value
      FROM  publication_attributes      
      WHERE 
        publication_id = :x 
        and publication_attribute = ''published year range''
    '
   using publication_id;

   fetch pub_cur into yearval;

   titleval := substr(publication_title,1,20);
   titlechars := length(publication_title);

   -- handle case of publication record with no authors added yet.
   if trim(retval) is null then
       if (titlechars > 20) then 
           -- truncated title with elipsis
           retval := titleval || '...';
       else 
           -- full title shorter than 21 chars
           retval := titleval;
       end if;
   end if;

   -- if there is a year or a year range, append this after the authorship string
   if yearval is not null then
      retval := retval || ' ' || trim(yearval);
   elsif published_year is not null then
       retval := retval || ' ' || to_char(published_year);
   end if;   

   return trim(retval);

  end;