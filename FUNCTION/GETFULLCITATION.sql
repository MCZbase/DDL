
  CREATE OR REPLACE EDITIONABLE FUNCTION "GETFULLCITATION" (pub_id  in varchar2 )
    return varchar2
    -- Obtain the long form of formatted_publication, removing any html tags and unescaping html entities.
    -- @param pub_id, the publication id for which to obtain the formatted citation.
    as
       type rc is ref cursor;
       formcitation_cur rc;
       l_str    varchar2(4000);
   begin   
   
   open formcitation_cur for 
   'select 
      UTL_I18N.UNESCAPE_REFERENCE(REGEXP_REPLACE(formatted_publication,''<[/a-zA-Z]+>'',''''))
    from formatted_publication 
    where format_style = ''long'' and publication_id = :x '
    using pub_id; 
   
   fetch formcitation_cur into l_str;
   
   return l_str;

  end;