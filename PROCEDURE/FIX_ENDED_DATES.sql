
  CREATE OR REPLACE EDITIONABLE PROCEDURE "FIX_ENDED_DATES" as

cursor c1 is
select  max(co.COLL_OBJECT_ENTERED_DATE) maxEndedDate, 
decode(coll_event_remarks, null, 'End of date collected range set to latest date of data entry for a cataloged item in this collecting event', coll_event_remarks || '; Ended date set to latest date of data entry for a cataloged item in this collecting event') as newRemarks,
ce.collecting_event_id
from collecting_event ce, cataloged_item ci, coll_object co
where ENDED_DATE like '2100%'
and ce.collecting_event_id = ci.collecting_event_id
and ci.collection_object_id = co.collection_object_id
and ce.collecting_event_id not in (464983,464780)
group by ce.collecting_event_id, ended_date, coll_event_remarks;

x number;
t1 pls_integer;
err_num NUMBER(5);
err_msg VARCHAR2(513);
begin

t1 := dbms_utility.get_time;
execute immediate 'alter trigger TR_COLLEVENT_AU_FLAT disable';
dbms_fga.disable_policy('MCZBASE', 'COLLECTING_EVENT', 'COLLECTING_EVENT');
x:=1;
    for c1_rec in c1 loop
    begin
        ---exit when x=1000;
        update collecting_event set ended_date = c1_rec.maxEndedDate, coll_event_remarks = c1_rec.newRemarks where collecting_event_id = c1_rec.collecting_event_id;
        commit; 
        x:=x+1;
    EXCEPTION

		 WHEN OTHERS THEN
		 ROLLBACK;
		 err_num := SQLCODE;
		 err_msg := SUBSTR(SQLERRM, 1, 512);
		 INSERT INTO x_fix_end_date_log VALUES (c1_rec.collecting_event_id, err_num || ': ' || err_msg);
		 COMMIT;
    END;
    end loop;
dbms_fga.enable_policy('MCZBASE', 'COLLECTING_EVENT', 'COLLECTING_EVENT');
execute immediate 'alter trigger TR_COLLEVENT_AU_FLAT enable';
dbms_output.put_line(x || ' records updated in ' || (dbms_utility.get_time - t1)/100 || ' seconds');
end;