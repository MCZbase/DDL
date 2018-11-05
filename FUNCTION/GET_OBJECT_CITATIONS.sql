
  CREATE OR REPLACE FUNCTION "GET_OBJECT_CITATIONS" 
(
  COLLECTION_OBJECT_ID IN NUMBER,  
  SHOW_STATUS IN NUMBER  
) RETURN VARCHAR2 
-- Given a collection object id, reeturns a list of citations
-- @param collection_object_id the collection object id for which to return citations.
-- @param show_status 0 or 1.  If not 0, includes the type status with the citation.
-- @return a list of citations, with html markup.
AS
      type rc is ref cursor;
      l_str    varchar2(4000);
      l_sep    varchar2(6);
      typestatus    varchar2(4000);
      page    varchar2(4000);
      citation  varchar2(4000);
      l_cur    rc;
   begin
       open l_cur for 'select type_status, concat(''p.'',occurs_page_number), 
            replace(replace(replace(formatted_publication,''Article Title Unavailable'',''''),''no article title available'',''''),''..'',''.'') 
            from citation c, formatted_publication fp where c.publication_id = fp.publication_id and fp.format_style = ''long'' and c.collection_object_id = :x '
       using COLLECTION_OBJECT_ID;
       l_sep := '';
       loop
           fetch l_cur into typestatus, page, citation;
           exit when l_cur%notfound;
           if (page = 'p.') then 
              page := '';
           else 
              page := ' ' || page;
           end if;
           if (SHOW_STATUS = 0) then 
              typestatus := '';
           end if;
           l_str := l_str || l_sep || typestatus || page || ' ' || citation;
           l_sep := '<br>';
       end loop;
       close l_cur;

       return l_str;
END GET_OBJECT_CITATIONS;