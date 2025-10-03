
  CREATE OR REPLACE EDITIONABLE FUNCTION "GET_TYPESTATUSBITS" (collection_object_id in NUMBER, typestatus in VARCHAR2 )
return varchar2
--  Given a collection object id and a type status, return a pipe delimited list of the scientific name, the 
--  authorship string for that name, the author of the cided publication, the formatted publication without html tags
--  but with html entities), the cited page number, and the publication_id for the first scientific name with that
--  type status in the identification history of the collection object.
--  @param collection_object_id the cataloged item for which to obtain the type authorship and citation information
--  @param typestatus the type status 
--  @see get_typestatusname 
--  @see get_typestatusauthor
as
   type rc is ref cursor;
   l_str varchar2(9000);
   sn varchar2(2000);
   na varchar2(2000);
   pa varchar2(2000);
   fp varchar2(2000);
   pg varchar2(255);
   puri varchar2(2000);
   pubid varchar2(255);
   l_cur rc;

begin
   l_str := '';
   open l_cur for '
     select distinct 
        scientific_name, 
        author_text, 
        mczbase.get_publication_authors(citation.publication_id) as pub_author, 
        REGEXP_REPLACE(formatted_publication,''\s*</?(i|b|em)((\s+\w+(\s*=\s*(".*?"|''''.*?''''|[^''''">\s]+))?)+\s*|\s*)/?>\s*'', NULL, 1, 0, ''im'') formatted_publication, 
        citation.occurs_page_number,
        citation.citation_page_uri,
        to_char(citation.publication_id) as pubid 
     from citation 
        left join taxonomy on cited_taxon_name_id = taxon_name_id
        left join formatted_publication on citation.publication_id = formatted_publication.publication_id
      where format_style = ''long''
         and citation.collection_object_id  = :x and type_status = :x and rownum < 2 
      '
   using collection_object_id, typestatus;
   loop
      fetch l_cur into sn,na,pa,fp,pg,puri,pubid;
      exit when l_cur%notfound;
      l_str :=  sn || '|' || na || '|' || pa || '|' || fp || '|' || pg || '|' || puri || '|' || pubid;
   end loop;
   close l_cur;

   return l_str;

end;