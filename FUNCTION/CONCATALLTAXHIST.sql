
  CREATE OR REPLACE FUNCTION "CONCATALLTAXHIST" (p_key_val  in number)
return varchar2
as
l_str    varchar2(4000);
l_sep    varchar2(6);
temp varchar2(255);
cursor cur is
    select
    SCIENTIFIC_NAME,
    NATURE_OF_ID,
    ACCEPTED_ID_FG,
    MADE_DATE,
    NVL (concatidagent(identification.identification_id),'not recorded') idby
    FROM
        identification
    WHERE
        collection_object_id=p_key_val
    ORDER BY
        ACCEPTED_ID_FG DESC,
        made_date;
begin
    FOR r IN cur loop
        temp:= r.scientific_name;
        IF r.accepted_id_fg=1 THEN
            temp:=temp || ' (accepted ID)';
        END IF;

        l_str:=l_str  || l_sep || temp;
        l_sep:=' | ';
    end loop;
    return l_str;
end;