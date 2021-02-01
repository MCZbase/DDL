
  CREATE OR REPLACE FUNCTION "GET_PERMITS_FOR_SHIPMENT" 
(
  SHIPMENT_ID IN NUMBER    
) 
--  Given a shipment id return the list of permits for that shipment.
--  @param shipment_id the primary key value for the shipment to look up permits for.
--  @return a clob containing a pipe separated list of all the permits for the shipment.
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
        from permit_shipment
        left outer join permit on permit_shipment.PERMIT_ID = permit.permit_id
        where
            permit_shipment.shipment_id = :x
       '
  using SHIPMENT_ID;
  loop 
       fetch l_cur into ptype, stype, idate, pnum;
       exit when l_cur%notfound;
       retval := retval || l_sep || ptype || ':' || stype || ' ' || idate || ' ' || pnum ;
       l_sep := '|';
  end loop;   
  close l_cur;

  RETURN retval;

END GET_PERMITS_FOR_SHIPMENT;