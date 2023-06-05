
  CREATE OR REPLACE FUNCTION "GET_UNDCOLLAGENTS" 
(
  UNDERSCORE_COLLECTION_ID IN VARCHAR2, 
 role IN VARCHAR2 DEFAULT 'ALL'
)
--  Given an underscore_collection_id and an optional role, return the agents related to that named group.
--  If a role is specified, restrict to agents in that role, and just list agent names, otherwise
--  list agents by role.
--  @param underscore_collection_id the underscore_collection for which to obtain the names.
--  @param role limit on the role to return, default value ALL returns all agents.
--  @return the preferred names of the agents, in order of role ordinal order, or [No Agent] if
--    there are no related agents for the specified named group
RETURN VARCHAR2 AS
      type rc is ref cursor;
      l_name varchar2(184);
      l_role varchar2(50);
      last_role varchar2(50);
      retval varchar2(4000);
      sep varchar2(2);
      l_cur rc;
BEGIN
  retval := '[No Agent]';
  l_name := '';
  last_role := ' ';
  sep := ' ';
  if role = 'ALL' THEN
    open l_cur for '
        select preferred_agent_name.agent_name, underscore_collection_agent.role
        from underscore_collection_agent
            join preferred_agent_name on underscore_collection_agent.agent_id = preferred_agent_name.agent_id
            left join ctunderscore_coll_agent_role on underscore_collection_agent.role = ctunderscore_coll_agent_role.role
        where underscore_collection_id = :a
           and underscore_collection_agent.agent_id is not null
        order by ordinal
        '
    using underscore_collection_id;
    loop
      fetch l_cur into l_name, l_role;
      exit when l_cur%notfound;
      if retval = '[No Agent]' then
        retval := ' ';
      end if;
      if last_role = l_role then
         retval := trim(retval || sep || l_name);
      else 
         retval := trim(retval || sep || l_role || ': ' || l_name);
      end if;
      sep := '; ';
    end loop;
    close l_cur;
  else 
    open l_cur for '
        select MCZBASE.get_agentnameoftype(agent_id)
        from underscore_collection_agent
            left join ctunderscore_coll_agent_role on underscore_collection_agent.role = ctunderscore_coll_agent_role.role
        where underscore_collection_id = :i
          and underscore_collection_agent.role = :j
          and agent_id is not null
        order by ordinal
        '
    using underscore_collection_id;
    loop
      fetch l_cur into l_name;
      exit when l_cur%notfound;
      if retval = '[No Agent]' then
        retval := ' ';
      end if;
      retval := trim(retval || sep || l_name);
      sep := '; ';
    end loop;
  end if;

  return retval;

END GET_UNDCOLLAGENTS;