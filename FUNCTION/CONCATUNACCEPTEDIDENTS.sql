
  CREATE OR REPLACE FUNCTION "CONCATUNACCEPTEDIDENTS" (p_key_val  in number)
return varchar2
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