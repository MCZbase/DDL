
  CREATE OR REPLACE EDITIONABLE FUNCTION "GET_PERMITS_FOR_TRANS" 
(
  TRANSACTION_ID IN NUMBER    
) 
--  Given a transaction id return the list of permits for that transaction.
--  @param transaction_id the primary key value for the transaction to look up permits for.
--  @return a clob containing a pipe separated list of all the permits for the transaction.
RETURN VARCHAR2 AS 
  type rc is ref cursor;
  retval   clob;
  l_sep    varchar2(3);
  ptype    varchar(4000);
  stype    varchar(4000);
  idate    varchar(4000);
  pnum     varchar(4000);
  l_cur rc;
BEGIN
  l_sep := '';
  open l_cur for
       ' 
        select permit_type, specific_type, issued_date, permit_num 
            from permit_trans 
                left join permit on PERMIT_TRANS.PERMIT_ID = permit.permit_id
        where
            permit_trans.transaction_id = :x
       '
  using TRANSACTION_ID;
  loop 
       fetch l_cur into ptype, stype, idate, pnum;
       exit when l_cur%notfound;
       retval := retval || l_sep || ptype || ':' || stype || ' ' || idate || ' ' || pnum ;
       l_sep := '|';
  end loop;   
  close l_cur;

  RETURN retval;

END GET_PERMITS_FOR_TRANS;