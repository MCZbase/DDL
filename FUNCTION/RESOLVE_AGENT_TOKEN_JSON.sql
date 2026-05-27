
  CREATE OR REPLACE EDITIONABLE FUNCTION "RESOLVE_AGENT_TOKEN_JSON" 
( p_agent_token IN VARCHAR2
, p_field_label IN VARCHAR2
) RETURN VARCHAR2
-- Given an agent token from a bulkloader field, resolve it to a unique agent_id.
-- The token may be either an integer agent_id or an agent_name value.
--
-- The function returns a JSON object with a status, the resolved agent_id when found,
-- and an error message when not found or ambiguous.  This function does not raise
-- an exception; callers may choose to accumulate messages or raise based on the JSON.
--
-- NOTE ON LENGTH LIMITS:
-- This function returns VARCHAR2 for convenience. In PL/SQL, VARCHAR2 can hold up to
-- 32767 bytes, and this JSON payload is expected to remain well within that limit.
-- If this function is called from SQL (e.g., SELECT ... FROM dual), VARCHAR2 results
-- are typically limited to 4000 bytes; if the JSON exceeds that limit in a SQL context,
-- the call will fail with an error rather than returning a truncated JSON value.
-- when obtaining the message (or another field) from the returned JSON with JSON_VALUE(), 
-- specify a field type longer than the message, e.g. varchar2(4000) or the message may be
-- returned as null instead of an empty string, for example:
-- JSON_VALUE(MCZBASE.RESOLVE_AGENT_TOKEN_JSON('A.SMITH','COLLECTOR_AGENT_1'),'$.MESSAGE'RETURNINGVARCHAR2(4000)) 
--
-- Status rules:
--   * If TRIM(p_agent_token) IS NULL: status="OK", agent_id=null, message=null
--   * If token matches regexp '^\d+$': treated as AGENT.AGENT_ID (must exist)
--   * Otherwise: treated as AGENT_NAME.AGENT_NAME (must map to exactly one distinct AGENT_ID)
--
-- JSON payload (keys):
--   status:               "OK" | "ERROR"
--   agent_id:             number | null
--   message:              string | null
--   field:                the provided p_field_label (for context in error messages)
--   token:                trimmed input token (or null)
--   token_interpreted_as: "empty" | "agent_id" | "agent_name"
--   match_count:          number | null  -- count used for validation (0, 1, >1) where applicable
--   regex:                '^\d+$'         -- the integer-token rule used
--
-- @author GitHub Copilot with guidance and revision by Paul J. Morris
--
-- @param p_agent_token the value from a bulkloader column (agent name or integer agent_id).
-- @param p_field_label label for the source field being validated (e.g., 'COLLECTOR_AGENT_3').
-- @return JSON VARCHAR2 describing success/error and resolved agent_id when applicable.
AS
	l_token        VARCHAR2(4000);
	l_cnt          NUMBER;
	l_agent_id     NUMBER;
	l_interpreted  VARCHAR2(30);
BEGIN
	l_token := TRIM(p_agent_token);

	IF l_token IS NULL THEN
		l_interpreted := 'empty';
		RETURN JSON_OBJECT(
			'status'               VALUE 'OK',
			'field'                VALUE p_field_label,
			'token'                VALUE NULL,
			'token_interpreted_as' VALUE l_interpreted,
			'agent_id'             VALUE NULL,
			'match_count'          VALUE NULL,
			'regex'                VALUE '^\d+$',
			'message'              VALUE NULL
			RETURNING VARCHAR2
		);
	END IF;

	IF REGEXP_LIKE(l_token, '^\d+$') THEN
		l_interpreted := 'agent_id';
		l_agent_id := TO_NUMBER(l_token);

		SELECT COUNT(*)
		  INTO l_cnt
		  FROM agent
		 WHERE agent_id = l_agent_id;

		IF l_cnt = 0 THEN
			RETURN JSON_OBJECT(
				'status'               VALUE 'ERROR',
				'field'                VALUE p_field_label,
				'token'                VALUE l_token,
				'token_interpreted_as' VALUE l_interpreted,
				'agent_id'             VALUE NULL,
				'match_count'          VALUE l_cnt,
				'regex'                VALUE '^\d+$',
				'message'              VALUE ('Bad ' || p_field_label || ' (agent_id ' || l_token || ' not found in AGENT)')
				RETURNING VARCHAR2
			);
		END IF;

		RETURN JSON_OBJECT(
			'status'               VALUE 'OK',
			'field'                VALUE p_field_label,
			'token'                VALUE l_token,
			'token_interpreted_as' VALUE l_interpreted,
			'agent_id'             VALUE l_agent_id,
			'match_count'          VALUE l_cnt,
			'regex'                VALUE '^\d+$',
			'message'              VALUE NULL
			RETURNING VARCHAR2
		);
	END IF;

	-- non-numeric: treat as agent_name
	l_interpreted := 'agent_name';

	SELECT COUNT(DISTINCT agent_id)
	  INTO l_cnt
	  FROM agent_name
	 WHERE agent_name = l_token;

	IF l_cnt = 0 THEN
		RETURN JSON_OBJECT(
			'status'               VALUE 'ERROR',
			'field'                VALUE p_field_label,
			'token'                VALUE l_token,
			'token_interpreted_as' VALUE l_interpreted,
			'agent_id'             VALUE NULL,
			'match_count'          VALUE l_cnt,
			'regex'                VALUE '^\d+$',
			'message'              VALUE ('Bad ' || p_field_label || ' (agent_name "' || l_token || '" not found)')
			RETURNING VARCHAR2
		);

	ELSIF l_cnt > 1 THEN
		RETURN JSON_OBJECT(
			'status'               VALUE 'ERROR',
			'field'                VALUE p_field_label,
			'token'                VALUE l_token,
			'token_interpreted_as' VALUE l_interpreted,
			'agent_id'             VALUE NULL,
			'match_count'          VALUE l_cnt,
			'regex'                VALUE '^\d+$',
			'message'              VALUE ('Bad ' || p_field_label || ' (agent_name "' || l_token ||
			                             '" is ambiguous, name for: ' || l_cnt || ' different agents)')
			RETURNING VARCHAR2
		);
	END IF;

	BEGIN
		SELECT DISTINCT agent_id
		  INTO l_agent_id
		  FROM agent_name
		 WHERE agent_name = l_token;
	EXCEPTION
		WHEN NO_DATA_FOUND THEN
			RETURN JSON_OBJECT(
				'status'               VALUE 'ERROR',
				'field'                VALUE p_field_label,
				'token'                VALUE l_token,
				'token_interpreted_as' VALUE l_interpreted,
				'agent_id'             VALUE NULL,
				'match_count'          VALUE 0,
				'regex'                VALUE '^\d+$',
				'message'              VALUE ('Bad ' || p_field_label || ' (agent_name "' || l_token || '" disappeared during validation)')
				RETURNING VARCHAR2
			);
		WHEN TOO_MANY_ROWS THEN
			RETURN JSON_OBJECT(
				'status'               VALUE 'ERROR',
				'field'                VALUE p_field_label,
				'token'                VALUE l_token,
				'token_interpreted_as' VALUE l_interpreted,
				'agent_id'             VALUE NULL,
				'match_count'          VALUE NULL,
				'regex'                VALUE '^\d+$',
				'message'              VALUE ('Bad ' || p_field_label || ' (agent_name "' || l_token || '" became ambiguous during validation)')
				RETURNING VARCHAR2
			);
	END;

	RETURN JSON_OBJECT(
		'status'               VALUE 'OK',
		'field'                VALUE p_field_label,
		'token'                VALUE l_token,
		'token_interpreted_as' VALUE l_interpreted,
		'agent_id'             VALUE l_agent_id,
		'match_count'          VALUE l_cnt,
		'regex'                VALUE '^\d+$',
		'message'              VALUE NULL
		RETURNING VARCHAR2
	);
END;
