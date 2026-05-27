
  CREATE OR REPLACE EDITIONABLE FUNCTION "GET_TYPESTATUS_DWC" (collection_object_id in NUMBER)
return varchar2
--  Given a collection object id return a pipe delimited list type status values including 
--  the type status and scientific name for each type in the form expected for dwc:typeStatus
--  @param collection_object_id the cataloged item for which to obtain the type authorship and citation information
as
   type rc is ref cursor;
   l_str varchar2(9000);
   separator varchar(4);
   sn varchar2(2000);
   na varchar2(2000);
   pa varchar2(2000);
   fp varchar2(2000);
   ts varchar2(255);
   pg varchar2(255);
   ordinal number;
   puri varchar2(2000);
   pubid varchar2(255);
   l_cur rc;

begin
   l_str := '';
   separator := '';
   open l_cur for '
     select distinct 
        scientific_name, 
        author_text, 
        mczbase.get_publication_authors(citation.publication_id) as pub_author, 
        REGEXP_REPLACE(formatted_publication,''\s*</?(i|b|em)((\s+\w+(\s*=\s*(".*?"|''''.*?''''|[^''''">\s]+))?)+\s*|\s*)/?>\s*'', NULL, 1, 0, ''im'') formatted_publication, 
        citation.occurs_page_number,
        citation.citation_page_uri,
        to_char(citation.publication_id) as pubid,
        citation.type_status,
        ctcitation_type_status.ordinal
     from citation 
        left join taxonomy on cited_taxon_name_id = taxon_name_id
        left join formatted_publication on citation.publication_id = formatted_publication.publication_id
        join ctcitation_type_status on citation.type_status = ctcitation_type_status.type_status
      where format_style = ''short''
         and citation.collection_object_id  = :x
         and ctcitation_type_status.category in (''Primary'', ''Secondary'')
      order by ctcitation_type_status.ordinal   
      '
   using collection_object_id;
   loop
      fetch l_cur into sn,na,pa,fp,pg,puri,pubid,ts, ordinal;
      exit when l_cur%notfound;
      l_str := l_str || separator ||  ts || ' of ' || sn || ' ' || na;
      separator := ' | ';
   end loop;
   close l_cur;

   return l_str;

end;