
  CREATE OR REPLACE PROCEDURE "BUILD_FORMATTED_PUB" as 

cursor c1 is 
select publication_id from publication where publication_id not in 
(select publication_id from formatted_publication);

cursor c2(pubid IN NUMBER) is 
		select 
			last_name
		from 
			publication_author_name,
			agent_name,
			person
		where 
			publication_author_name.agent_name_id=agent_name.agent_name_id and
			agent_name.agent_id=person.person_id and
			publication_author_name.publication_id=pubid
		order by 
			author_position; 

cursor c3(pubid IN NUMBER) is 
		select 
			agent_name
		from 
			publication_author_name,
			agent_name
		where 
			publication_author_name.agent_name_id=agent_name.agent_name_id and
			publication_author_name.publication_id=pubid and 
      author_role = 'author'
		order by 
			author_position;

cursor c4(pubid IN NUMBER) is 
		select 
			agent_name
		from 
			publication_author_name,
			agent_name
		where 
			publication_author_name.agent_name_id=agent_name.agent_name_id and
			publication_author_name.publication_id=pubid
      and author_role = 'author'
		order by 
			author_position;

numPUBID number;
numPUBYEAR number;
numAUTHORS number;
numEDITORS number;
numNULLAUTHORS number;
varPUBTITLE varchar2(1000);
varPUBTYPE varchar2(50);
varSHORTCIT varchar2(500);
varLONGCIT varchar2(1000);
varAUTHORNAME1 varchar2(500);
varAUTHORNAME2 varchar2(500);
varAUTHORSTRING varchar2(1000);
varEDITORSTRING varchar2(1000);
varJOURNALNAME varchar2(1000);
varissue varchar2(1000);
varnumber varchar2(1000);
varvolume varchar2(1000);
varbeginpg varchar2(1000);
varendpg varchar2(1000);
varpgtotal varchar2(1000);
x number;


begin

numPUBID := null;
numPUBYEAR := null;
numAUTHORS := null;
numEDITORS := null;
numNULLAUTHORS := null;
varPUBTITLE := null;
varPUBTYPE := null;
varSHORTCIT := null;
varLONGCIT := null;
varAUTHORNAME1 := null;
varAUTHORNAME2 := null;
varAUTHORSTRING := null;
varEDITORSTRING := null;
varJOURNALNAME := null;
varissue := null;
varnumber := null;
varvolume := null;
varbeginpg := null;
varendpg := null;
varpgtotal := null;
x := null;

for c1_rec in c1 loop
numPUBID := null;
numPUBYEAR := null;
numAUTHORS := null;
numEDITORS := null;
numNULLAUTHORS := null;
varPUBTITLE := null;
varPUBTYPE := null;
varSHORTCIT := null;
varLONGCIT := null;
varAUTHORNAME1 := null;
varAUTHORNAME2 := null;
varAUTHORSTRING := null;
varEDITORSTRING := null;
varJOURNALNAME := null;
varissue := null;
varvolume := null;
varbeginpg := null;
varendpg := null;
varpgtotal := null;
x := null;

  numPUBID := c1_rec.publication_id;
  
  select publication_title, published_year, publication_type into varPUBTITLE, numPUBYEAR, varPUBTYPE from publication where publication_id = numPUBID;
  
  select 
      count(*) into numNULLAUTHORS
      from 
        publication_author_name,
        agent_name,
        person
      where 
        publication_author_name.agent_name_id=agent_name.agent_name_id and
        agent_name.agent_id=person.person_id and
        publication_author_name.publication_id=numpubid
        and last_name is null;
        
  select 
      count(*) into numAUTHORS
      from 
        publication_author_name,
        agent_name,
        person
      where 
        publication_author_name.agent_name_id=agent_name.agent_name_id and
        agent_name.agent_id=person.person_id and
        publication_author_name.publication_id=numpubid;
        
  if numNULLAUTHORS > 0 then
    select publication_title into varSHORTCIT from publication where publication_id = numPUBID;
  elsif numAUTHORS=1 then
    open c2(numPUBID);
    fetch c2 into varAUTHORNAME1;
    varSHORTCIT := varAUTHORNAME1 || ' ' || numPUBYEAR;
    close  c2;
  elsif numAUTHORS=2 then
    open c2(numPUBID);
    fetch c2 into varAUTHORNAME1;
    fetch c2 into varAUTHORNAME2;
    close  c2;
    varSHORTCIT := varAUTHORNAME1 || ' and ' || varAUTHORNAME2 || ' ' || numPUBYEAR;
  else 
    open c2(numPUBID);
    fetch c2 into varAUTHORNAME1;
    varSHORTCIT := varAUTHORNAME1 || ' et al. ' || numPUBYEAR;
    close  c2;
  end if;


  --long citation 
  select 
      count(*) into numAUTHORS
      from 
        publication_author_name,
        agent_name
      where 
        publication_author_name.agent_name_id=agent_name.agent_name_id and
        publication_author_name.publication_id=numPUBID
        and author_role = 'author';
  
  select 
        count(*) into numEDITORS
      from 
        publication_author_name,
        agent_name
      where 
        publication_author_name.agent_name_id=agent_name.agent_name_id and
        publication_author_name.publication_id=numPUBID
        and author_role = 'editor';
  
  If numAUTHORS = 1 then 
    open c3(numPUBID);
    fetch c3 into varAUTHORNAME1;
    varAUTHORSTRING := varAUTHORNAME1;
    close c3;
  elsif numAUTHORS = 2 then 
    open c3(numPUBID);
    fetch c3 into varAUTHORNAME1;
    fetch c3 into varAUTHORNAME2;
    varAUTHORSTRING := varAUTHORNAME1 || ' and ' || varAUTHORNAME2;
    close c3;
  else
    open c3(numPUBID);
    fetch c3 into varAUTHORNAME1;
    varAUTHORSTRING := varAUTHORNAME1;
    loop
      fetch c3 into varAUTHORNAME1;
      exit when c3%NOTFOUND;
      varAUTHORSTRING := varAUTHORSTRING || ', ' || varAUTHORNAME1;
    end loop;
    close c3;
  end if;
  
  If numEDITORS = 1 then 
    open c4(numPUBID);
    fetch c4 into varAUTHORNAME1;
    varEDITORSTRING := varAUTHORNAME1;
    close c4;
  elsif numAUTHORS = 2 then 
    open c4(numPUBID);
    fetch c4 into varAUTHORNAME1;
    fetch c4 into varAUTHORNAME2;
    varEDITORSTRING := varAUTHORNAME1 || ' and ' || varAUTHORNAME2;
    close c4;
  else
    open c4(numPUBID);
    fetch c4 into varAUTHORNAME1;
    varAUTHORSTRING := varAUTHORNAME1;
    loop
      fetch c4 into varAUTHORNAME1;
      exit when c4%NOTFOUND;
      varEDITORSTRING := varEDITORSTRING || ', ' || varAUTHORNAME1;
    end loop;
    close c4;
  end if;
  
  select count(*) into x from publication_attributes where publication_id=numPUBID and publication_attribute='journal name';
  if x > 0 then
    select pub_att_value into varJOURNALNAME from publication_attributes where publication_id=numPUBID and publication_attribute='journal name';
  end if;
  select count(*) into x from publication_attributes where publication_id=numPUBID and publication_attribute='issue';
  if x > 0 then
    select pub_att_value into varISSUE from publication_attributes where publication_id=numPUBID and publication_attribute='issue';
  end if;
  select count(*) into x from publication_attributes where publication_id=numPUBID and publication_attribute='number';
  if x > 0 then
    select pub_att_value into varNUMBER from publication_attributes where publication_id=numPUBID and publication_attribute='number';
  end if;
  select count(*) into x from publication_attributes where publication_id=numPUBID and publication_attribute='volume';
  if x > 0 then
    select pub_att_value into varVOLUME from publication_attributes where publication_id=numPUBID and publication_attribute='volume';
  end if;
  select count(*) into x from publication_attributes where publication_id=numPUBID and publication_attribute='begin page';
  if x > 0 then
    select pub_att_value into varBEGINPG from publication_attributes where publication_id=numPUBID and publication_attribute='begin page';
  end if;
  select count(*) into x from publication_attributes where publication_id=numPUBID and publication_attribute='end page';
  if x > 0 then
    select pub_att_value into varENDPG from publication_attributes where publication_id=numPUBID and publication_attribute='end page';
  end if;
  select count(*) into x from publication_attributes where publication_id=numPUBID and publication_attribute='page total';
  if x > 0 then
    select pub_att_value into varPGTOTAL from publication_attributes where publication_id=numPUBID and publication_attribute='page total';
  end if;
  
  if substr(varPUBTITLE, -1, 1) <> '.' and substr(varPUBTITLE, -1, 1) <> '?' then varPUBTITLE := varPUBTITLE || '.'; end if;
  varPUBTITLE := replace(varPUBTITLE, ' In: ', ' <i>In:</i> ');

  if varPUBTYPE = 'journal article' then
    varLONGCIT := varAUTHORSTRING || '. ' || numPUBYEAR || '. ' || varPUBTITLE || ' ' || varJOURNALNAME;
    if varVOLUME is not null then
      varLONGCIT := varLONGCIT || ' ' || varVOLUME;
    end if;
    if varNumber is not null then
      varLONGCIT := varLONGCIT || ' (' || varNumber || ')';
    elsif varIssue is not null and varNumber is null then
      varLONGCIT := varLONGCIT || ' (' || varIssue || ')';
    end if;
    varLONGCIT := varLONGCIT || ':' || varBEGINPG || '-' || varENDPG;
  elsif varPUBTYPE = 'book' then
    varLONGCIT := varAUTHORSTRING || '. ' || numPUBYEAR || '. ' || varPUBTITLE;
    if varVOLUME is not null then
      varLONGCIT := varLONGCIT || ' Volume ' || varVOLUME;
    end if;
    if varPGTOTAL is not null then
      varLONGCIT := varLONGCIT || ' ' || varPGTOTAL || 'pp.';
    end if;
  elsif varPUBTYPE = 'book section' then
    varLONGCIT := varAUTHORSTRING || '. ' || numPUBYEAR || '. ' || varPUBTITLE;
    if varVOLUME is not null then
      varLONGCIT := varLONGCIT || ' Volume ' || varVOLUME || '.';
    end if;
    if varPGTOTAL is not null then
      varLONGCIT := varLONGCIT || ' ' || varPGTOTAL || 'pp.';
    end if;
    if varEDITORSTRING is not null then
      varLONGCIT := varLONGCIT || ' Edited by ' || varEDITORSTRING || '.';
    end if;
  else
    varLONGCIT := varAUTHORSTRING;
    if numPUBYEAR is not null then
      varLONGCIT := varLONGCIT || '. ' || numPUBYEAR;
    end if;
    varLONGCIT := varLONGCIT || '. ' || varPUBTITLE;
  end if;
    
dbms_output.put_line('long citation: ' || varLONGCIT);
dbms_output.put_line('short citation: ' || varSHORTCIT);

insert into formatted_publication(publication_id, format_style, formatted_publication)
values(numPUBID, 'short', varSHORTCIT);
insert into formatted_publication(publication_id, format_style, formatted_publication)
values(numPUBID, 'long', varLONGCIT);
commit;
end loop;
end;