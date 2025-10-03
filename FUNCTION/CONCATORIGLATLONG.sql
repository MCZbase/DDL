
  CREATE OR REPLACE EDITIONABLE FUNCTION "CONCATORIGLATLONG" ( p_key_val  in varchar2)
    return varchar2
    as
        type rc is ref cursor;
        l_str    varchar2(4000);
       l_sep    varchar2(2);
       l_val    varchar2(4000);
       t_val    varchar2(4000);
   		l_cur    rc;
   		t_cur    rc;
   begin
   		open l_cur for '
   			select orig_lat_long_units
            from accepted_lat_long
            where locality_id = :x '
            using p_key_val;
     			fetch l_cur into l_val;
       				if l_val = 'decimal degrees' then
   						open t_cur for '
  							select
   							dec_lat  t_val
   							from accepted_lat_long
                       		where locality_id = :x '
                   			using p_key_val;

                   			fetch t_cur into t_val;
                   			l_str := t_val;

         				close t_cur;


       				end if;
	close l_cur;
   return l_str;
  end;


 
 