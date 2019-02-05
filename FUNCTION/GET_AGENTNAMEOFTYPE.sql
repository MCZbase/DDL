
  CREATE OR REPLACE FUNCTION "GET_AGENTNAMEOFTYPE" 
(
  AGENTID IN VARCHAR2
, NAMETYPE IN VARCHAR2 DEFAULT 'preferred' 
) 
--  Given an agentid, return the agent name of the specified type, falling back to login then preferred name if 
--  the specified type is not present.
--  
--  @param agentid the agent id for which to obtain the name.
--  @param nametype the type of name to return, default value is preferred.
--  @return the name of the agent, in order of priority, the provided type, the login name, the preferred name, [Error] 
--     if no match was found.
RETURN VARCHAR2 AS 
      type rc is ref cursor;
      retval    varchar2(4000);
      l_cur rc;
BEGIN
  retval := '[Error]';
  open l_cur for 
     'select agent_name from (
          select agent_name, 1 as ordering from agent_name where agent_name_type = :x and agent_id = :y
          union 
          select agent_name, 2 as ordering from agent_name where agent_name_type = ''login'' and agent_id = :z
          union 
          select agent_name, 3 as ordering from agent_name where agent_name_type = ''preferred'' and agent_id = :j
          union 
          select p.agent_name, 4 as ordering from agent c left join agent_name p on c.preferred_agent_name_id = p.agent_name_id 
              where p.agent_name_type = :a and c.agent_id = :b
          union 
          select p.agent_name, 5 as ordering from agent c left join agent_name p on c.preferred_agent_name_id = p.agent_name_id 
              where c.agent_id = :c              
          union 
          select ''[Error]'', 6 as ordering from dual 
          order by ordering asc
      ) names
      '
  using NAMETYPE, AGENTID, AGENTID, AGENTID, NAMETYPE, AGENTID, AGENTID; 
       loop 
          fetch l_cur into retval;
          exit;
       end loop;   
       close l_cur;

       return retval;
  
END GET_AGENTNAMEOFTYPE;