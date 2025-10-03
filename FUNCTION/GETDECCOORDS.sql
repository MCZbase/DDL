
  CREATE OR REPLACE EDITIONABLE FUNCTION "GETDECCOORDS" (collobjid  in varchar2 )
    return  MYNUMTYPE pipelined
    as
     type rc is ref cursor;
    dlat number;
    dlong number;
    mem    varchar2(30);
     name_cur    rc;
   begin
    open name_cur for 'select  dec_lat,	dec_long,max_error_units
    						 FROM
       						accepted_lat_long,
       						locality,
       						collecting_event,
       						cataloged_item
       					WHERE
       						accepted_lat_long.locality_id = locality.locality_id AND
       						locality.locality_id = collecting_event.locality_id AND
       						collecting_event.collecting_event_id = cataloged_item.collecting_event_id AND
       						cataloged_item.collection_object_id = :x'
       						using collobjid
                   ;

       pipe row(dec_lat);
       return;
  end;