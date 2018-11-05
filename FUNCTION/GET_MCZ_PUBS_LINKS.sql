
  CREATE OR REPLACE FUNCTION "GET_MCZ_PUBS_LINKS" 
(
  PUBLICATION_ID IN NUMBER  
) RETURN VARCHAR2
--  Supporting the Publications part of the MCZ website --
--  Given a publicationid, return the list of links to: -- 
--  PDF copies of the publication hosted by the MCZ,    --
--  Supplemental materials hosted by the MCZ, and       --
--  The publication in BHL.                             --
AS 
        type rc is ref cursor;
        l_str    varchar2(4000);
       l_sep    varchar2(30);
       uri    varchar2(4000);
       mimetype varchar2(255);
       ismcz   number;
       isbhl   number;
       issupplement number;
       word    varchar2(50);

       l_cur    rc;
   begin
      l_sep := '';
      open l_cur for 'select distinct m.media_uri,  m.mime_type, 
                      instr(m.media_uri,''biodiversitylibrary.org''), 
                      instr(m.media_uri,''mcz.harvard.edu''),
                      instr(m.media_uri,''supp'')
                          from media_relations mr left join media m on mr.media_id = m.media_id 
                          where mr.media_relationship = ''shows publication'' and 
                            (media_uri like ''%mcz.harvard.edu%'' or media_uri like ''%biodiversitylibrary.org%'') and
                            related_primary_key = :x '
                   using publication_id;
       loop
           fetch l_cur into uri, mimetype, isbhl, ismcz, issupplement;
           word := 'BHL';
           if ismcz > 0 then 
               word := 'pdf';
               if issupplement >0 then 
                   word := 'Supplemental materials';
              end if;               
           end if;
           exit when l_cur%notfound;
           l_str := l_str || l_sep || '<a href="' || uri || '">' || word  ||  '</a>';
           l_sep := ']&nbsp;[';
       end loop;
       close l_cur;

       return l_str;

END GET_MCZ_PUBS_LINKS;