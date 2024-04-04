
  CREATE OR REPLACE PROCEDURE "SPC_FIELD_NUMBERS" AS

CURSOR c1 IS 
select collecting_event_id from 
    (select distinct ci.collecting_event_id, oid.display_value
    from (select * from cataloged_item  where collection_cde = 'Ent') ci
    join (select * from coll_obj_other_id_num where other_id_type = 'collector number') oid on ci.collection_object_id = oid.collection_object_id
    where trim(oid.display_value) like 'SPC%')
    group by collecting_event_id
    having count(*) > 1;

c2 SYS_REFCURSOR;
spcnumber varchar2(100);
masterid collecting_event.collecting_event_id%TYPE;
newid collecting_event.collecting_event_id%TYPE;
skipnum number;

xLOCALITY_ID COLLECTING_EVENT.LOCALITY_ID%TYPE;
xDATE_BEGAN_DATE COLLECTING_EVENT.DATE_BEGAN_DATE%TYPE;
xDATE_ENDED_DATE COLLECTING_EVENT.DATE_ENDED_DATE%TYPE;
xVERBATIM_DATE COLLECTING_EVENT.VERBATIM_DATE%TYPE;
xVERBATIM_LOCALITY COLLECTING_EVENT.VERBATIM_LOCALITY%TYPE;
xCOLL_EVENT_REMARKS COLLECTING_EVENT.COLL_EVENT_REMARKS%TYPE;
xVALID_DISTRIBUTION_FG COLLECTING_EVENT.VALID_DISTRIBUTION_FG%TYPE;
xCOLLECTING_SOURCE COLLECTING_EVENT.COLLECTING_SOURCE%TYPE;
xCOLLECTING_METHOD COLLECTING_EVENT.COLLECTING_METHOD%TYPE;
xHABITAT_DESC COLLECTING_EVENT.HABITAT_DESC%TYPE;
xDATE_DETERMINED_BY_AGENT_ID COLLECTING_EVENT.DATE_DETERMINED_BY_AGENT_ID%TYPE;
xFISH_FIELD_NUMBER COLLECTING_EVENT.FISH_FIELD_NUMBER%TYPE;
xBEGAN_DATE COLLECTING_EVENT.BEGAN_DATE%TYPE;
xENDED_DATE COLLECTING_EVENT.ENDED_DATE%TYPE;
xCOLLECTING_TIME COLLECTING_EVENT.COLLECTING_TIME%TYPE;
xVERBATIMCOORDINATES COLLECTING_EVENT.VERBATIMCOORDINATES%TYPE;
xVERBATIMLATITUDE COLLECTING_EVENT.VERBATIMLATITUDE%TYPE;
xVERBATIMLONGITUDE COLLECTING_EVENT.VERBATIMLONGITUDE%TYPE;
xVERBATIMCOORDINATESYSTEM COLLECTING_EVENT.VERBATIMCOORDINATESYSTEM%TYPE;
xVERBATIMSRS COLLECTING_EVENT.VERBATIMSRS%TYPE;
xSTARTDAYOFYEAR COLLECTING_EVENT.STARTDAYOFYEAR%TYPE;
xENDDAYOFYEAR COLLECTING_EVENT.ENDDAYOFYEAR%TYPE;
xVERBATIMELEVATION COLLECTING_EVENT.VERBATIMELEVATION%TYPE;
xVERBATIMDEPTH COLLECTING_EVENT.VERBATIMDEPTH%TYPE;

begin

for c1_rec in c1 loop
    ------dbms_output.put_line(c1_rec.collecting_event_id);
    masterid := c1_rec.collecting_event_id;
    skipnum :=1;

        SELECT 
        LOCALITY_ID,
        DATE_BEGAN_DATE,
        DATE_ENDED_DATE,
        VERBATIM_DATE,
        VERBATIM_LOCALITY,
        COLL_EVENT_REMARKS,
        VALID_DISTRIBUTION_FG,
        COLLECTING_SOURCE,
        COLLECTING_METHOD,
        HABITAT_DESC,
        DATE_DETERMINED_BY_AGENT_ID,
        FISH_FIELD_NUMBER,
        BEGAN_DATE,
        ENDED_DATE,
        COLLECTING_TIME,
        VERBATIMCOORDINATES,
        VERBATIMLATITUDE,
        VERBATIMLONGITUDE,
        VERBATIMCOORDINATESYSTEM,
        VERBATIMSRS,
        STARTDAYOFYEAR,
        ENDDAYOFYEAR,
        VERBATIMELEVATION,
        VERBATIMDEPTH
        into
        xLOCALITY_ID,
        xDATE_BEGAN_DATE,
        xDATE_ENDED_DATE,
        xVERBATIM_DATE,
        xVERBATIM_LOCALITY,
        xCOLL_EVENT_REMARKS,
        xVALID_DISTRIBUTION_FG,
        xCOLLECTING_SOURCE,
        xCOLLECTING_METHOD,
        xHABITAT_DESC,
        xDATE_DETERMINED_BY_AGENT_ID,
        xFISH_FIELD_NUMBER,
        xBEGAN_DATE,
        xENDED_DATE,
        xCOLLECTING_TIME,
        xVERBATIMCOORDINATES,
        xVERBATIMLATITUDE,
        xVERBATIMLONGITUDE,
        xVERBATIMCOORDINATESYSTEM,
        xVERBATIMSRS,
        xSTARTDAYOFYEAR,
        xENDDAYOFYEAR,
        xVERBATIMELEVATION,
        xVERBATIMDEPTH
        from collecting_event where collecting_event_id = masterid;

    open c2 for 'SELECT DISTINCT DISPLAY_VALUE 
                    FROM coll_obj_other_id_num oid
                    join cataloged_item ci on oid.collection_object_id = ci.collection_object_id
                    where other_id_type = ''collector number'' and 
                    collecting_event_id = ' || masterid;
        loop
            fetch c2 into spcnumber;
            exit when c2%NOTFOUND;
            if skipnum > 1 then
            ---dbms_output.put_line('   create new event for' || spcnumber);

            INSERT INTO COLLECTING_EVENT(collecting_event_id,
            LOCALITY_ID,
            DATE_BEGAN_DATE,
            DATE_ENDED_DATE,
            VERBATIM_DATE,
            VERBATIM_LOCALITY,
            COLL_EVENT_REMARKS,
            VALID_DISTRIBUTION_FG,
            COLLECTING_SOURCE,
            COLLECTING_METHOD,
            HABITAT_DESC,
            DATE_DETERMINED_BY_AGENT_ID,
            FISH_FIELD_NUMBER,
            BEGAN_DATE,
            ENDED_DATE,
            COLLECTING_TIME,
            VERBATIMCOORDINATES,
            VERBATIMLATITUDE,
            VERBATIMLONGITUDE,
            VERBATIMCOORDINATESYSTEM,
            VERBATIMSRS,
            STARTDAYOFYEAR,
            ENDDAYOFYEAR,
            VERBATIMELEVATION,
            VERBATIMDEPTH)
            VALUES
            (sq_COLLECTING_EVENT_ID.NEXTVAL,
            xLOCALITY_ID,
            xDATE_BEGAN_DATE,
            xDATE_ENDED_DATE,
            xVERBATIM_DATE,
            xVERBATIM_LOCALITY,
            xCOLL_EVENT_REMARKS,
            xVALID_DISTRIBUTION_FG,
            xCOLLECTING_SOURCE,
            xCOLLECTING_METHOD,
            xHABITAT_DESC,
            xDATE_DETERMINED_BY_AGENT_ID,
            xFISH_FIELD_NUMBER,
            xBEGAN_DATE,
            xENDED_DATE,
            xCOLLECTING_TIME,
            xVERBATIMCOORDINATES,
            xVERBATIMLATITUDE,
            xVERBATIMLONGITUDE,
            xVERBATIMCOORDINATESYSTEM,
            xVERBATIMSRS,
            xSTARTDAYOFYEAR,
            xENDDAYOFYEAR,
            xVERBATIMELEVATION,
            xVERBATIMDEPTH)
            returning collecting_event_id into newid;

            update cataloged_item set collecting_event_id = newid where collection_object_id in
            (select collection_object_id from coll_obj_other_id_num where display_value = spcnumber and other_id_type = 'collector number');
            ---dbms_output.put_line('newid:' || newid);
            else
            ---dbms_output.put_line('   keep event for' || spcnumber);
            newid := masterid;
            end if;
            insert into spc_field_numbers_log
            values(spcnumber, masterid, newid);
            skipnum := skipnum + 1;
        end loop;
end loop;
end;