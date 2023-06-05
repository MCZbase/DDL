
  CREATE OR REPLACE FUNCTION "GET_CITATION" (publication_id in number, format_style in varchar default 'long', plain in number default 0 )
    return varchar2
    -- Obtain the specified form of formatted_publication, 
    -- @param pubication_id, the publication id for which to obtain the formatted citation.
    -- @param format_style the format style to return, default long.
    -- @param plain if 1 then remove any html tags and unescape html entities, otherwise return
    --  exactly as in formatted_publication.formatted_publication.
as
  type rc is ref cursor;
  formcitation_cur rc;
  l_str    varchar2(4000);
begin   

  if plain = 1 then
    open formcitation_cur for 
        'select 
          UTL_I18N.UNESCAPE_REFERENCE(REGEXP_REPLACE(formatted_publication,''<[/a-zA-Z]+>'',''''))
        from formatted_publication 
        where format_style = :x and publication_id = :y '
    using format_style, publication_id; 
    fetch formcitation_cur into l_str;
  else
    open formcitation_cur for 
        'select formatted_publication
        from formatted_publication 
        where format_style = :x and publication_id = :y '
    using format_style, publication_id; 
    fetch formcitation_cur into l_str;
  end if;

  return l_str;

end;