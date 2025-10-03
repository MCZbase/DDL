
  CREATE OR REPLACE EDITIONABLE FUNCTION "CONCATGEOLOGYATTRIBUTE" (colobjid in number )
return varchar2
as
    type rc is ref cursor;
    l_str    varchar2(4000);
    l_sep    varchar2(30);
    l_val    varchar2(4000);
/*
	returns a semicolon-separated list of geology attribute determinations
*/
BEGIN
    FOR r IN (
        SELECT geology_attribute || '=' || geo_att_value oneAtt
        FROM 
            geology_attributes,
            locality,
            collecting_event,
            cataloged_item
        WHERE geology_attributes.locality_id=locality.locality_id 
        AND locality.locality_id=collecting_event.locality_id 
        AND collecting_event.collecting_event_id=cataloged_item.collecting_event_id 
        AND cataloged_item.collection_object_id=colobjid
    ) LOOP
        l_str := l_str || l_sep || r.oneAtt;
        l_sep := '; ';
    END LOOP;
    RETURN l_str;
END;
 