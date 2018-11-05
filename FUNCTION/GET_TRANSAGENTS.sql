
  CREATE OR REPLACE FUNCTION "GET_TRANSAGENTS" (transaction_id IN number, asHtml in number, leaveout in varchar)
    return varchar
-- Given a transaction_id, return a list of all of the agents who have roles in that transaction along with their rolesd.
-- For use with transaction reports.
--
-- @param transaction_id the transaction for which to return the list of agents and roles.
-- @param asHtml if 1 returns with html markup, otherwise as delimited list.
-- @param leaveout a role to leave out.
-- @return a varchar .
    as
      type rc is ref cursor;
      retval     varchar2(4000);
      agent_role varchar2(4000);
      sep        varchar(3);
      agent_name varchar2(4000);
      l_cur      rc;
   begin
       if (LENGTH(leaveout)>0) then
          open l_cur for '
           select initcap(trans_agent_role), mczbase.get_agentnameoftype(agent_id,''preferred'')
           from trans_agent where transaction_id = :x and trans_agent_role <> :x
           order by trans_agent_role asc '
          using transaction_id, leaveout;      
       else
          open l_cur for '
           select trans_agent_role, mczbase.get_agentnameoftype(agent_id,''preferred'')
           from trans_agent where transaction_id = :x 
           order by trans_agent_role asc '
          using transaction_id;
       end if;
       if (asHtml=1) then
          retval := '';
       else 
          retval := '';
       end if;
       sep := '';
       loop
           fetch l_cur into agent_role, agent_name;
           exit when l_cur%notfound;
           if (asHtml=1) then
               retval := retval || '<strong>' || agent_role || ': </strong>' || agent_name || '<br>';
           else 
               retval := retval || sep || agent_role || ':' || agent_name;
               sep:= ', ';
           end if;
       end loop;
       close l_cur;
       if (asHtml=1) then
          retval := retval || '';
       else 
          retval := retval;
       end if;

       return retval;
  end;
  --create public synonym get_transAgents for MCZBASE.get_transAgents;
  --grant execute on get_transAgents to public;