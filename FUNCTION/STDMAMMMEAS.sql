
  CREATE OR REPLACE FUNCTION "STDMAMMMEAS" (p_key_val  in number )
    return varchar2
    as
        type rc is ref cursor;
        l_str    varchar2(4000);
       l_sep    varchar2(30);
       l_val    varchar2(4000);

       l_cur    rc;
       arec attributes%ROWTYPE;
       result varchar2(4000) := 'total-tail-hindfoot-earEQIVweight';
       units varchar2(4000);
       thisAtt varchar2(4000);
   begin
   open l_cur for 'select * from attributes where collection_object_id = :x ' using p_key_val;
	loop
		fetch l_cur into arec;
        exit when l_cur%notfound;
			if arec.attribute_units = 'mm' OR arec.attribute_units = 'g' then
				units := '';
			else
				units := ' ' || arec.attribute_units;
			end if;
			if arec.attribute_type = 'tail length' then
				thisAtt := arec.attribute_value || units;
				result := replace(result,'tail',thisAtt);
			elsif arec.attribute_type = 'total length' then
				thisAtt := arec.attribute_value || units;
				result := replace(result,'total',thisAtt);
			elsif arec.attribute_type = 'hind foot with claw' then
				thisAtt := arec.attribute_value || units;
				result := replace(result,'hindfoot',thisAtt);
			elsif arec.attribute_type = 'ear from notch' then
				thisAtt := arec.attribute_value || units;
				result := replace(result,'ear',thisAtt);
			elsif arec.attribute_type = 'weight' then
				thisAtt := arec.attribute_value || units;
				result := replace(result,'weight',thisAtt);
			end if;
	end loop;
		result := replace(result,'total','X');
		result := replace(result,'tail','X');
		result := replace(result,'hindfoot','X');
		result := replace(result,'ear','X');
		result := replace(result,'weight','X');


return result;
  end;
 