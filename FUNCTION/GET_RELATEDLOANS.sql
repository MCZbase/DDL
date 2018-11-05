
  CREATE OR REPLACE FUNCTION "GET_RELATEDLOANS" (transaction_id IN number, asHtml in number)
    return varchar
-- Given a transaction_id, return a list of any subloans or parent loans.
--
-- @param transaction_id the transaction for which to return the list related loans.
-- @param asHtml 1 for html, otherwise delimited text list.
-- @return a varchar list of subloans in html format for inclusion in a report.
    as
      type rc is ref cursor;
      retval     varchar2(4000);
      ltype      varchar2(4000);
      lnum       varchar2(4000);
      lstatus    varchar2(4000);      
      sep        varchar(3);      
      l_cur      rc;
   begin
          open l_cur for '
          select relation_type, loan_number, loan_status 
             from loan_relations 
                  left join loan on related_transaction_id = loan.transaction_id 
             where loan_relations.transaction_id = :x 
         union
         select replace(relation_type,''Subloan'',''Master Loan'') relation_type, loan_number, loan_status 
            from loan_relations 
                 left join loan on loan_relations.transaction_id = loan.transaction_id
            where loan_relations.related_transaction_id = :x
          '
          using transaction_id, transaction_id;      
       if (asHtml=1) then
          retval := '';
       else 
          retval := '';
       end if;
       sep := '';
       loop
           fetch l_cur into ltype, lnum, lstatus;
           exit when l_cur%notfound;
           if (asHtml=1) then
               retval := retval || '<strong>' || ltype || ': </strong>' || lnum || ' (' || lstatus  || ')<br>';
           else 
               retval := retval || sep || ltype || ':' || lnum || ' (' || lstatus  || ')';
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
  --create public synonym get_relatedLoans for MCZBASE.get_relatedLoans;
  --grant execute on get_relatedLoans to public;