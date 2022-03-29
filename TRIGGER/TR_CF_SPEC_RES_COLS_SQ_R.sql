
  CREATE OR REPLACE TRIGGER "TR_CF_SPEC_RES_COLS_SQ_R" BEFORE INSERT ON "MCZBASE"."CF_SPEC_RES_COLS_R"
FOR EACH ROW
BEGIN
	if :new.cf_spec_res_cols_id is null then
		SELECT mczbase.sq_cf_spec_res_cols_r_id.nextval 
		INTO :new.cf_spec_res_cols_id FROM dual;
	end if;
END;
ALTER TRIGGER "TR_CF_SPEC_RES_COLS_SQ_R" ENABLE