
  CREATE OR REPLACE FUNCTION "COUNT_TRANSAGENT_FOR_ROLE" 
(
  agent_role IN VARCHAR2, 
  transaction_type in VARCHAR2
) 
--  Given an agent role and a transaction type return the number of distinct agents in that
--  role for that transaction type.  Used to put counts on roles in transaction search form.
--  @param transaction_type the type of transaction deaccession, accn, borrow, loan.
--  @param agent_role the transaction agent role to count.
--  @return the count of the number of agents in that role in that transaction type.
RETURN VARCHAR2 AS 
  type rc is ref cursor;
  ct NUMBER;
  retval  NUMBER;
  l_cur rc;
BEGIN
  retval := 0;
  open l_cur for
       ' select count(distinct trans_agent_id) as ct 
         from trans_agent 
            left join trans on trans_agent.transaction_id = trans.transaction_id
        where trans_agent_role = :x and
        trans.transaction_type = :y '
  using agent_role, transaction_type;
  loop 
       fetch l_cur into ct;
       exit when l_cur%notfound;
       retval := ct;
  end loop;   
  close l_cur;
 RETURN retval;

END COUNT_TRANSAGENT_FOR_ROLE;