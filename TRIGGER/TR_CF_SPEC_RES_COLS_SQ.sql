
  CREATE OR REPLACE EDITIONABLE TRIGGER "TR_CF_SPEC_RES_COLS_SQ" BEFORE INSERT ON cf_spec_res_cols
FOR EACH ROW
BEGIN
	if :new.cf_spec_res_cols_id is null then
		SELECT sq_cf_spec_res_cols_id.nextval 
		INTO :new.cf_spec_res_cols_id FROM dual;
	end if;
END;


ALTER TRIGGER "TR_CF_SPEC_RES_COLS_SQ" ENABLE