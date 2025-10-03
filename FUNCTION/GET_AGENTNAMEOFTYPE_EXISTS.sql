
  CREATE OR REPLACE EDITIONABLE FUNCTION "GET_AGENTNAMEOFTYPE_EXISTS" 
(
  AGENTID IN VARCHAR2
, NAMETYPE IN VARCHAR2
) 
--  Given an agentid, return the agent name of the specified type or null if 
--  the specified type is not present.  If more than one name of the specified type 
--  exists, return a pipe delimited list of names of that type for the specified agent.
--  
--  @param agentid the agent id for which to obtain the name.
--  @param nametype the type of name to return
--  @return the name of the agent or null if no match was found for that name type and agent id.
--  @see GET_AGENTNAMEOFTYPE
RETURN VARCHAR2 AS 
      type rc is ref cursor;
      retval    varchar2(4000);
      namebit varchar2(255);
      sep varchar2(1);
      l_cur rc;
BEGIN
  retval := '';
  sep := '';
  open l_cur for 
     ' select agent_name from agent_name where agent_name_type = :x and agent_id = :y '
  using NAMETYPE, AGENTID; 
       loop 
          fetch l_cur into namebit;
          retval := retval || sep || namebit;
          sep := '|';
          exit;
       end loop;   
       close l_cur;

       return retval;

END GET_AGENTNAMEOFTYPE_EXISTS;