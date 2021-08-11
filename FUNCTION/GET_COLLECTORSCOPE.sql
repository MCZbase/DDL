
  CREATE OR REPLACE FUNCTION "GET_COLLECTORSCOPE" 
(
  AGENT_ID  in number,
  show_scope varchar2 default 'collections'
) 
--  Given an agent_id, return counts of specimens by collection and 
--  known years collected ranges for that agent as a collector.
--  @param agent_id the agent for which to obtain collector scope information.
--- @param the nature of the scope to show, collections, years, all (slow).
--  @return a string listing departments, counts, and year ranges for the specified 
--     agent as a collector
RETURN VARCHAR2 AS 
      type rc is ref cursor;
      ct number;
      startyear number;
      endyear number;
      daterange varchar(50);
      collection_cde    varchar2(4000);
      retval    varchar2(4000);
      sep varchar2(10);
      l_cur rc;
BEGIN
  ct := 0;  
  startyear := 0;
  endyear := 0;
  daterange := '';
  retval := '';
  sep := '';
  if show_scope = 'all' then 
  open l_cur for '
    select nvl(sum(ct),0), collection_cde, sum(st), sum(en) from (
        select count(*) ct, flat.collection_cde, to_number(min(substr(flat.began_date,0,4))) st, to_number(max(substr(flat.ended_date,0,4))) en 
        from agent
            left join collector on agent.agent_id = collector.AGENT_ID
            left join flat on collector.COLLECTION_OBJECT_ID = flat.collection_object_id
        where collector.COLLECTOR_ROLE = ''c''
            and substr(flat.began_date,0,4) = substr(flat.ENDED_DATE,0,4)
            and agent.agent_id = :x
        group by flat.collection_cde
        union
        select count(*) ct, flat.collection_cde, 0 st, 0 en 
        from agent
            left join collector on agent.agent_id = collector.AGENT_ID
            left join flat on collector.COLLECTION_OBJECT_ID = flat.collection_object_id
        where collector.COLLECTOR_ROLE = ''c''
            and (flat.began_date is null or substr(flat.began_date,0,4) <> substr(flat.ENDED_DATE,0,4))
            and agent.agent_id = :y
        group by flat.collection_cde, 0
        )
    group by collection_cde    
     '
  using AGENT_ID, AGENT_ID; 
  loop 
     fetch l_cur into ct, collection_cde, startyear, endyear;
        exit when l_cur%notfound;
        retval := retval || sep || collection_cde || ' (' || to_char(ct) || ' ' || to_char(startyear,'9999') || '-' || trim(to_char(endyear,'9999')) || ')' ;
        if startyear = 0 and endyear = 0 then
          daterange := '';
        elsif startyear > 0 and endyear > 0 then
          daterange := ' ' || to_char(startyear,'9999') || '-' || trim(to_char(endyear,'9999'));
        elsif startyear = 0 and endyear > 0 then
          daterange := ' [?]-' || trim(to_char(endyear,'9999'));       
        elsif startyear > 0 and endyear = 0 then
          daterange := ' ' || to_char(startyear,'9999') || '-[?]';          
        elsif startyear = endyear  then
          daterange := ' ' || to_char(startyear,'9999');          
        end if;
        retval := retval || sep || collection_cde || ' (' || to_char(ct) || daterange || ')' ;
        sep := '; ';
  end loop;  
  close l_cur;
  end if; 
  
  if show_scope = 'collections' then 
  open l_cur for '
        select count(*) ct, flat.collection_cde 
        from agent
            left join collector on agent.agent_id = collector.AGENT_ID
            left join flat on collector.COLLECTION_OBJECT_ID = flat.collection_object_id
        where collector.COLLECTOR_ROLE = ''c''
            and substr(flat.began_date,0,4) = substr(flat.ENDED_DATE,0,4)
            and agent.agent_id = :x
        group by flat.collection_cde   
     '
  using AGENT_ID; 
  loop 
     fetch l_cur into ct, collection_cde;
        exit when l_cur%notfound;
        retval := retval || sep || collection_cde || ' (' || to_char(ct) || ')' ;
        sep := '; ';
  end loop;  
  close l_cur;
  end if; 
  
  if show_scope = 'years' then 
  open l_cur for '
        select count(*) ct, agent.agent_id, min(substr(flat.began_date,0,4)) st, max(substr(flat.ended_date,0,4)) en 
        from agent
            left join collector on agent.agent_id = collector.AGENT_ID
            left join flat on collector.COLLECTION_OBJECT_ID = flat.collection_object_id
        where collector.COLLECTOR_ROLE = ''c''
            and substr(flat.began_date,0,4) = substr(flat.ENDED_DATE,0,4)
            and agent.agent_id = :x
        group by agent.agent_id
     '
  using AGENT_ID; 
  loop 
     fetch l_cur into ct, collection_cde, startyear, endyear;
        exit when l_cur%notfound;
        retval := retval || sep || to_char(ct) || ' (' || trim(startyear) || '-' || trim(endyear) || ')' ;
        sep := '; ';
  end loop;    
  close l_cur;
  end if;    

  return retval;
END GET_COLLECTORSCOPE;