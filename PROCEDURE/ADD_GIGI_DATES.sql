
  CREATE OR REPLACE PROCEDURE "ADD_GIGI_DATES" as

cursor c1 is select ID from GIGICOLLDATES20161220 where loaded <> 'Y' or loaded is null and (NEW_BEGIN_DATE is not null or NEW_ENDED_DATE is not null);

numID GIGICOLLDATES20161220.ID%TYPE;
numcollectingeventid collecting_event.collecting_event_id%TYPE;
numNewCollEventId collecting_event.collecting_event_id%TYPE; 
numlocalityid collecting_event.locality_id%TYPE;
varaccnnumber accn.accn_number%TYPE;
varverbatimdate collecting_event.verbatim_date%TYPE;
varbegandate collecting_event.began_date%TYPE;
varendeddate collecting_event.ended_date%TYPE;
varverbatimlocality collecting_event.verbatim_locality%TYPE;
varreceiveddate accn.received_date%TYPE;
varcollectors flat.collectors%TYPE;
varnewbegindate collecting_event.began_date%TYPE;
varnewendeddate collecting_event.ended_date%TYPE;
varnewcolleventremarks collecting_event.coll_event_remarks%TYPE;

numRecs number;
numCollEvent number;
ERR_NUM NUMBER(5); 
err_msg VARCHAR2(513);  
debug varchar2(100);

begin
for c1_rec in c1 loop
      begin
      numID := c1_rec.ID;
debug := 'getting data';

      select 
      collecting_event_id,
      locality_id,
      accn_number,
      verbatim_date,
      began_date,
      ended_date,
      verbatim_locality,
      received_date,
      collectors,
      new_begin_date,
      new_ended_date,
      new_coll_event_remarks
      into
      numcollectingeventid,
      numlocalityid,
      varaccnnumber,
      varverbatimdate,
      varbegandate,
      varendeddate,
      varverbatimlocality,
      varreceiveddate,
      varcollectors,
      varnewbegindate,
      varnewendeddate,
      varnewcolleventremarks
      from 
      GIGICOLLDATES20161220
      where ID = numID;

debug := 'getting record counts'; 
      select count(*) into numCollEvent from cataloged_item where collecting_event_id = numcollectingeventid;
      
      select count(*) into numRecs 
      from cataloged_item ci, collecting_event ce, flat f, accn a 
      where ci.collecting_event_id = ce.collecting_event_id and 
      ci.collection_object_id = f.collection_object_id and 
      ci.accn_id = a.transaction_id and
      ci.collecting_event_id =  numcollectingeventid and 
      NVL(a.accn_number,'XXX') =  NVL(varaccnnumber,'XXX') and 
      NVL(ce.began_date,'XXX') =  NVL(varbegandate,'XXX') and 
      NVL(ce.ended_date,'XXX') =  NVL(varendeddate,'XXX') and 
      NVL(f.collectors,'XXX') = NVL(varcollectors, 'XXX');

If numRecs > 0 then
     
        If numCollEvent = numRecs then
  debug := 'no other records update';  
  ---no other records in collecting event   
          update collecting_event set 
            began_date = varnewbegindate,
            ended_date = varnewendeddate,
            coll_event_remarks = decode(coll_event_remarks, null, null, coll_event_remarks || '|') || varnewcolleventremarks
            where collecting_event_id = numcollectingeventid;
          update GIGICOLLDATES20161220 set loaded = 'Y' where ID=numID;
          commit;
        Else
  
  debug := 'other records update';  
  ---other records in collecting event   
  
    ---make new collecting event with new data
  debug := 'make new coll event'; 
          
          numNewCollEventId := sq_collecting_event_id.nextval;
          insert into collecting_event
            (collecting_event_id, locality_id, verbatim_date, verbatim_locality, coll_event_remarks, valid_distribution_fg, collecting_source, collecting_method, 
              habitat_desc,date_determined_by_agent_id,fish_field_number, began_date, ended_date, collecting_time)
          select numNewCollEventId, locality_id, verbatim_date, verbatim_locality, decode(coll_event_remarks, null, null, coll_event_remarks || '|') || varnewcolleventremarks, 
              valid_distribution_fg, collecting_source, collecting_method,habitat_desc,100813,fish_field_number, varnewbegindate, varnewendeddate, collecting_time 
            from collecting_event 
            where collecting_event_id = numcollectingeventid;
  
    ---update pertinent records
  debug := 'update pertinent records';  
          update cataloged_item set collecting_event_id = numNewCollEventId where collection_object_id in
            (select ci.collection_object_id
              from cataloged_item ci, collecting_event ce, flat f, accn a 
              where ci.collecting_event_id = ce.collecting_event_id and 
              ci.collection_object_id = f.collection_object_id and 
              ci.accn_id = a.transaction_id and
              ci.collecting_event_id =  numcollectingeventid and 
              NVL(a.accn_number,'XXX') =  NVL(varaccnnumber,'XXX') and 
              NVL(ce.began_date,'XXX') =  NVL(varbegandate,'XXX') and 
              NVL(ce.ended_date,'XXX') =  NVL(varendeddate,'XXX') and 
              NVL(f.collectors,'XXX') = NVL(varcollectors, 'XXX'));
  
    ---update load table
          update GIGICOLLDATES20161220 set loaded = 'Y', newcolleventid = numNewCollEventId where ID=numID;
          commit;
        end if;
else
    ---no records found
           update GIGICOLLDATES20161220 set loaded = 'N' where ID=numID;
end if;
      
debug := 'updating error column';     
      update GIGICOLLDATES20161220 set error = 'found:' || numRecs || 'total:' || numCollEvent  where ID = numID;
      EXCEPTION
             
             WHEN OTHERS THEN
             ROLLBACK;
             err_num := SQLCODE;
             err_msg := SUBSTR(SQLERRM, 1, 512);
             update GIGICOLLDATES20161220 set error = debug || '; ' || err_num || ': ' || err_msg WHERE ID=numID;
             COMMIT;
    end;
    null;
  commit;
end loop;
end;