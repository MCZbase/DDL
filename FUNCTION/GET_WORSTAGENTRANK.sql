
  CREATE OR REPLACE EDITIONABLE FUNCTION "GET_WORSTAGENTRANK" 
(
  AGENTID IN VARCHAR2
) 
--  Given an agentid, return the lowest rank (F, D, C, B) asserted by anyone for that agent
--  @param agentid the agent id for which to obtain the rank
--  @return the worst recorded rank of the agent B-F if a rank has been recorded (F is worst), 
--          A if no rank has been recorded but the agent exists, null if the agent does not exist .
RETURN VARCHAR2 AS 
      type rc is ref cursor;
      retval    varchar2(4000);
      hits number;
      r_cur rc;
      t_cur rc;
BEGIN

  open t_cur for 'select count(*) from agent where agent_id = :x ' using AGENTID;
  loop 
    fetch t_cur into hits;
    exit;
  end loop;    
  close t_cur;
  if (hits = 0) then 
     retval := '';
  else 
     retval := 'A';
     open r_cur for ' select agent_rank from (select agent_rank from agent_rank where agent_id = :x order by agent_rank desc) where rownum < 2 '
     using AGENTID; 
     loop 
          fetch r_cur into retval;
          exit;
     end loop;   
     close r_cur;
   end if;
   return retval;
  
END GET_WORSTAGENTRANK;