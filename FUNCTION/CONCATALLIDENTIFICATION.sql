
  CREATE OR REPLACE EDITIONABLE FUNCTION "CONCATALLIDENTIFICATION" (p_key_val  in number)
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
        temp:='<i>' || r.scientific_name || '</i>';
        IF r.accepted_id_fg=1 THEN
            temp:=temp || ' (accepted ID)';
        END IF;
        temp:=temp || ' identified by ' || r.idby;
        IF r.MADE_DATE IS NOT NULL THEN
            temp:=temp || ' on ' || r.made_date;
        END IF;
        temp:=temp || '; method: ' || r.nature_of_id;

        l_str:=l_str  || l_sep || temp;
        l_sep:='<br>';
    end loop;
    return l_str;
end;