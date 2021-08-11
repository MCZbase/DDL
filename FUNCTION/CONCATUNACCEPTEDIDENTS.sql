
  CREATE OR REPLACE FUNCTION "CONCATUNACCEPTEDIDENTS" (p_key_val  in number)
return varchar2
--  return a pipe concatenated list of the scientific names used in unaccepted 
--  identifications of a cataloged item.
--  @param p_key_val the collection_object_id of the cataloged item for which
--     to return unaccepted identifications.
as
l_str    varchar2(4000);
l_sep    varchar2(6);
temp varchar2(255);
cursor cur is
    select
    SCIENTIFIC_NAME
    FROM
        identification
    WHERE
        collection_object_id=p_key_val
        and ACCEPTED_ID_FG = 0
    ORDER BY
        made_date;
begin
    FOR r IN cur loop
        temp:=r.scientific_name;

        l_str:=l_str  || l_sep || temp;
        l_sep:=' | ';
    end loop;
    return l_str;
end;