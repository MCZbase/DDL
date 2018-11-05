
  CREATE OR REPLACE PROCEDURE "ADD_NEW_ADDR" (
	st1 in VARCHAR2,
	st2 in VARCHAR2,
	ci in VARCHAR2,
	st in VARCHAR2,
	zp in VARCHAR2,
	cc in VARCHAR2,
	ms in VARCHAR2,
	aid in NUMBER,
	atype in VARCHAR2,
	title in VARCHAR2,
	rmk in VARCHAR2,
	inst in VARCHAR2,
	dept in VARCHAR2
)
AS
	pragma autonomous_transaction;
    --  Create a new address record, invoked from TR_ADDR_BU 
    --  for creating a new address when the addr table is updated.
    --  See TR_ADDR_BU for logic of the invocation.
BEGIN
	INSERT INTO addr (
		street_addr1,
		street_addr2,
		city,
		state,
		zip,
		country_cde,
		mail_stop,
		agent_id,
		addr_type,
		job_title,
		valid_addr_fg,
		addr_remarks,
		institution,
		department)
	VALUES (
		st1,
		st2,
		ci,
		st,
		zp,
		cc,
		ms,
		aid,
		atype,
		title,
		1,
		rmk,
		inst,
		dept);
	COMMIT;
END;