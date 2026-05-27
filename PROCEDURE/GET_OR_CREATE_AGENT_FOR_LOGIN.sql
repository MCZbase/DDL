
  CREATE OR REPLACE EDITIONABLE PROCEDURE "GET_OR_CREATE_AGENT_FOR_LOGIN" (
	p_username IN VARCHAR2,
	p_agent_id OUT NUMBER,
	p_status   OUT VARCHAR2,
	p_message  OUT VARCHAR2
)
/****************************************************************************************
 * Procedure: MCZBASE.GET_OR_CREATE_AGENT_FOR_LOGIN
 *
 * Purpose:
 *   Resolve an MCZbase AGENT_ID for an authenticated application login (CF_USERS.USERNAME).
 *   If there is no existing AGENT_NAME of type 'login' for the username, use CF_USER_DATA
 *   (name, affiliation, email) to attempt to match an existing person agent, attach the
 *   login name, and optionally attach an email address; if no match, create a new person
 *   agent with PERSON, AGENT_NAME(preferred), AGENT_NAME(login), and ELECTRONIC_ADDRESS(e-mail).
 *
 * Matching strategy (conservative, in priority order):
 *   1) Exact login match:
 *        AGENT_NAME where agent_name_type='login' and agent_name = username.
 *   2) Email + plausible name match:
 *        ELECTRONIC_ADDRESS where address_type='e-mail' and address matches CF_USER_DATA.email,
 *        and plausible match using either:
 *          (a) atomic PERSON fields (last name exact + first initial match), OR
 *          (b) preferred AGENT_NAME string containing last name as a whole word and first initial
 *              as a word boundary (via REGEXP_LIKE).
 *        Requires exactly one candidate.
 *   3) Name-only match:
 *        plausible match using either atomic PERSON fields or any AGENT_NAME string
 *        (all AGENT_NAME_TYPE) with REGEXP_LIKE word-boundary checks; requires exactly one candidate.
 *   4) Otherwise, create a new person agent:
 *        AGENT(agent_type='person', agent_remarks includes affiliation, preferred_agent_name_id set),
 *        PERSON(atomic name parts),
 *        AGENT_NAME(preferred),
 *        AGENT_NAME(login),
 *        ELECTRONIC_ADDRESS(e-mail) if provided.
 *
 * @author
 *   MCZbase redesign assistant (GitHub Copilot)
 *
 * @param p_username
 *   IN. Application login username (CF_USERS.USERNAME). Used as AGENT_NAME.AGENT_NAME with AGENT_NAME_TYPE='login'.
 *
 * @return
 *   OUT parameters:
 *     p_agent_id  - Resolved or created AGENT.AGENT_ID; may be NULL if ambiguous/error.
 *     p_status    - 'FOUND_LOGIN' | 'FOUND_BY_EMAIL' | 'FOUND_BY_NAME' | 'CREATED' |
 *                   'NO_PROFILE' | 'AMBIGUOUS' | 'ERROR'
 *     p_message   - Diagnostic message for logs (not intended for public display).
 ****************************************************************************************/
AS
	-- username normalized for storage/lookup (AGENT_NAME.login is case-sensitive in this model)
	l_username VARCHAR2(255);

	-- cf_user_data fields (per attached DDL)
	l_first_name  VARCHAR2(60);
	l_middle_name VARCHAR2(60);
	l_last_name   VARCHAR2(60);
	l_affiliation VARCHAR2(255);
	l_email       VARCHAR2(255);

	-- normalized variants for comparisons
	l_last_u         VARCHAR2(200);
	l_email_l        VARCHAR2(255);
	l_first_initial  VARCHAR2(1);

	-- regex patterns for word-boundary matching in agent_name strings
	-- Use POSIX character classes to approximate word boundaries in a portable way.
	-- Example pattern: '(^|[^[:alnum:]])SMITH([^[:alnum:]]|$)'
	l_last_pat        VARCHAR2(500);
	l_firstinit_pat   VARCHAR2(100);

	-- intermediate
	l_agent_id     NUMBER;
	l_candidate_ct NUMBER;

	-- preferred name string (AGENT_NAME.AGENT_NAME is VARCHAR2(184 CHAR))
	l_preferred_name VARCHAR2(184);

	-- new IDs
	l_new_agent_id               NUMBER;
	l_new_pref_agent_name_id     NUMBER;
	l_new_login_agent_name_id    NUMBER;
	l_new_eaddr_id               NUMBER;

BEGIN
	p_agent_id := NULL;
	p_status := NULL;
	p_message := NULL;

	-- Normalize username: collapse whitespace, trim
	l_username := TRIM(REGEXP_REPLACE(p_username, '\s+', ' '));

	IF l_username IS NULL OR LENGTH(l_username) = 0 THEN
		p_status := 'ERROR';
		p_message := 'Username is null/blank.';
		RETURN;
	END IF;

	--------------------------------------------------------------------------------
	-- 1) Direct match on login agent_name
	--------------------------------------------------------------------------------
	BEGIN
		SELECT MIN(an.agent_id)
		INTO l_agent_id
		FROM mczbase.agent_name an
		WHERE an.agent_name_type = 'login'
			AND an.agent_name = l_username;

		p_agent_id := l_agent_id;
		p_status := 'FOUND_LOGIN';
		p_message := 'Found agent by agent_name(login).';
		RETURN;
	EXCEPTION
		WHEN NO_DATA_FOUND THEN
			NULL;
	END;

	--------------------------------------------------------------------------------
	-- 2) Load user profile from CF_USERS + CF_USER_DATA
	--------------------------------------------------------------------------------
	BEGIN
		SELECT
			TRIM(REGEXP_REPLACE(ud.first_name, '\s+', ' ')),
			TRIM(REGEXP_REPLACE(ud.middle_name, '\s+', ' ')),
			TRIM(REGEXP_REPLACE(ud.last_name, '\s+', ' ')),
			TRIM(REGEXP_REPLACE(ud.affiliation, '\s+', ' ')),
			TRIM(REGEXP_REPLACE(ud.email, '\s+', ' '))
		INTO
			l_first_name,
			l_middle_name,
			l_last_name,
			l_affiliation,
			l_email
		FROM mczbase.cf_users u
			JOIN mczbase.cf_user_data ud ON u.user_id = ud.user_id
		WHERE u.username = l_username;
	EXCEPTION
		WHEN NO_DATA_FOUND THEN
			p_status := 'NO_PROFILE';
			p_message := 'No cf_user_data row joined to cf_users for username=' || l_username;
			RETURN;
	END;

	IF l_last_name IS NULL OR LENGTH(TRIM(l_last_name)) = 0 THEN
		p_status := 'NO_PROFILE';
		p_message := 'cf_user_data.last_name is missing for username=' || l_username;
		RETURN;
	END IF;

	-- Normalizations
	l_last_u  := UPPER(TRIM(l_last_name));
	l_email_l := LOWER(TRIM(NVL(l_email,'')));

	IF l_first_name IS NOT NULL AND LENGTH(TRIM(l_first_name)) > 0 THEN
		l_first_initial := UPPER(SUBSTR(TRIM(l_first_name), 1, 1));
	ELSE
		l_first_initial := NULL;
	END IF;

	-- Regex patterns (escaped, conservative)
	-- Word boundary approximation: (^|[^[:alnum:]])NAME([^[:alnum:]]|$)
	l_last_pat := '(^|[^[:alnum:]])' || REGEXP_REPLACE(l_last_u,'([\\.^$|()\\[\\]{}*+?])','\\\1') || '([^[:alnum:]]|$)';
	IF l_first_initial IS NOT NULL THEN
		l_firstinit_pat := '(^|[^[:alnum:]])' || REGEXP_REPLACE(l_first_initial,'([\\.^$|()\\[\\]{}*+?])','\\\1') || '([^[:alnum:]]|$)';
	ELSE
		l_firstinit_pat := NULL;
	END IF;

	-- Preferred name string <= 184 characters
	l_preferred_name := SUBSTR(
		CASE
			WHEN l_first_name IS NOT NULL AND LENGTH(TRIM(l_first_name)) > 0 THEN
				l_last_name || ', ' || l_first_name ||
					CASE WHEN l_middle_name IS NOT NULL AND LENGTH(TRIM(l_middle_name)) > 0 THEN ' ' || l_middle_name ELSE '' END
			ELSE
				l_last_name
		END,
		1, 184
	);

	--------------------------------------------------------------------------------
	-- 3) Try match by email + plausible name match
	--    - atomic PERSON: last exact + first initial match (when both present)
	--    - OR preferred agent_name string has last name as whole token + first initial token
	--------------------------------------------------------------------------------
	IF l_email IS NOT NULL AND LENGTH(TRIM(l_email)) > 0 THEN
		SELECT COUNT(DISTINCT ea.agent_id)
		INTO l_candidate_ct
		FROM mczbase.electronic_address ea
			JOIN mczbase.agent a ON ea.agent_id = a.agent_id
			LEFT JOIN mczbase.person p ON ea.agent_id = p.person_id
			LEFT JOIN mczbase.agent_name pan
				ON pan.agent_id = ea.agent_id
				AND pan.agent_name_type = 'preferred'
		WHERE ea.address_type = 'e-mail'
			AND LOWER(ea.address) = l_email_l
			AND a.agent_type = 'person'
			AND (
				-- atomic plausible match
				(
					p.person_id IS NOT NULL
					AND UPPER(TRIM(p.last_name)) = l_last_u
					AND l_first_initial IS NOT NULL
					AND p.first_name IS NOT NULL
					AND LENGTH(TRIM(p.first_name)) > 0
					AND UPPER(SUBSTR(TRIM(p.first_name),1,1)) = l_first_initial
				)
				OR
				-- preferred-name plausible match using word-boundary regex checks
				(
					pan.agent_name IS NOT NULL
					AND REGEXP_LIKE(UPPER(pan.agent_name), l_last_pat)
					AND (l_firstinit_pat IS NULL OR REGEXP_LIKE(UPPER(pan.agent_name), l_firstinit_pat))
				)
			);

		IF l_candidate_ct = 1 THEN
			SELECT MIN(ea.agent_id)
			INTO l_agent_id
			FROM mczbase.electronic_address ea
				JOIN mczbase.agent a ON ea.agent_id = a.agent_id
				LEFT JOIN mczbase.person p ON ea.agent_id = p.person_id
				LEFT JOIN mczbase.agent_name pan
					ON pan.agent_id = ea.agent_id
					AND pan.agent_name_type = 'preferred'
			WHERE ea.address_type = 'e-mail'
				AND LOWER(ea.address) = l_email_l
				AND a.agent_type = 'person'
				AND (
					(
						p.person_id IS NOT NULL
						AND UPPER(TRIM(p.last_name)) = l_last_u
						AND l_first_initial IS NOT NULL
						AND p.first_name IS NOT NULL
						AND LENGTH(TRIM(p.first_name)) > 0
						AND UPPER(SUBSTR(TRIM(p.first_name),1,1)) = l_first_initial
					)
					OR
					(
						pan.agent_name IS NOT NULL
						AND REGEXP_LIKE(UPPER(pan.agent_name), l_last_pat)
						AND (l_firstinit_pat IS NULL OR REGEXP_LIKE(UPPER(pan.agent_name), l_firstinit_pat))
					)
				);

			-- Ensure login agent_name exists
			INSERT INTO mczbase.agent_name (agent_name_id, agent_id, agent_name_type, agent_name)
			SELECT mczbase.sq_agent_name_id.NEXTVAL, l_agent_id, 'login', l_username
			FROM dual
			WHERE NOT EXISTS (
				SELECT 1
				FROM mczbase.agent_name an
				WHERE an.agent_id = l_agent_id
					AND an.agent_name_type = 'login'
					AND an.agent_name = l_username
			);

			p_agent_id := l_agent_id;
			p_status := 'FOUND_BY_EMAIL';
			p_message := 'Matched by email + plausible name; ensured login agent_name.';
			RETURN;
		END IF;
	END IF;

	--------------------------------------------------------------------------------
	-- 4) Try match by name-only (atomic PERSON OR any AGENT_NAME string); require uniqueness
	--------------------------------------------------------------------------------
	SELECT COUNT(DISTINCT a.agent_id)
	INTO l_candidate_ct
	FROM mczbase.agent a
		LEFT JOIN mczbase.person p ON a.agent_id = p.person_id
		LEFT JOIN mczbase.agent_name an ON a.agent_id = an.agent_id
	WHERE a.agent_type = 'person'
		AND (
			-- atomic match where present (last name required)
			(
				p.person_id IS NOT NULL
				AND UPPER(TRIM(p.last_name)) = l_last_u
				AND (l_first_initial IS NULL OR (p.first_name IS NOT NULL AND UPPER(SUBSTR(TRIM(p.first_name),1,1)) = l_first_initial))
			)
			OR
			-- any agent_name string containing last name as token and first initial token
			(
				an.agent_name IS NOT NULL
				AND REGEXP_LIKE(UPPER(an.agent_name), l_last_pat)
				AND (l_firstinit_pat IS NULL OR REGEXP_LIKE(UPPER(an.agent_name), l_firstinit_pat))
			)
		);

	IF l_candidate_ct = 1 THEN
		SELECT MIN(a.agent_id)
		INTO l_agent_id
		FROM mczbase.agent a
			LEFT JOIN mczbase.person p ON a.agent_id = p.person_id
			LEFT JOIN mczbase.agent_name an ON a.agent_id = an.agent_id
		WHERE a.agent_type = 'person'
			AND (
				(
					p.person_id IS NOT NULL
					AND UPPER(TRIM(p.last_name)) = l_last_u
					AND (l_first_initial IS NULL OR (p.first_name IS NOT NULL AND UPPER(SUBSTR(TRIM(p.first_name),1,1)) = l_first_initial))
				)
				OR
				(
					an.agent_name IS NOT NULL
					AND REGEXP_LIKE(UPPER(an.agent_name), l_last_pat)
					AND (l_firstinit_pat IS NULL OR REGEXP_LIKE(UPPER(an.agent_name), l_firstinit_pat))
				)
			);

		-- Ensure login name exists
		INSERT INTO mczbase.agent_name (agent_name_id, agent_id, agent_name_type, agent_name)
		SELECT mczbase.sq_agent_name_id.NEXTVAL, l_agent_id, 'login', l_username
		FROM dual
		WHERE NOT EXISTS (
			SELECT 1
			FROM mczbase.agent_name an2
			WHERE an2.agent_id = l_agent_id
				AND an2.agent_name_type = 'login'
				AND an2.agent_name = l_username
		);

		-- Ensure email exists if provided
		IF l_email IS NOT NULL AND LENGTH(TRIM(l_email)) > 0 THEN
			INSERT INTO mczbase.electronic_address (electronic_address_id, agent_id, address_type, address)
			SELECT mczbase.sq_electronic_address_id.NEXTVAL, l_agent_id, 'e-mail', l_email
			FROM dual
			WHERE NOT EXISTS (
				SELECT 1
				FROM mczbase.electronic_address ea
				WHERE ea.agent_id = l_agent_id
					AND ea.address_type = 'e-mail'
					AND LOWER(ea.address) = l_email_l
			);
		END IF;

		p_agent_id := l_agent_id;
		p_status := 'FOUND_BY_NAME';
		p_message := 'Matched by name; ensured login agent_name and email (if provided).';
		RETURN;
	ELSIF l_candidate_ct > 1 THEN
		p_agent_id := NULL;
		p_status := 'AMBIGUOUS';
		p_message := 'Multiple candidate agents matched by name; not auto-linking.';
		RETURN;
	END IF;

	--------------------------------------------------------------------------------
	-- 5) Create new agent/person + preferred/login names + email
	--------------------------------------------------------------------------------
	SELECT mczbase.sq_agent_id.NEXTVAL INTO l_new_agent_id FROM dual;

	INSERT INTO mczbase.agent (
		agent_id,
		agent_type,
		agent_remarks,
		preferred_agent_name_id
	) VALUES (
		l_new_agent_id,
		'person',
		CASE
			WHEN l_affiliation IS NOT NULL AND LENGTH(TRIM(l_affiliation)) > 0 THEN 'Affiliation: ' || l_affiliation
			ELSE NULL
		END,
		l_new_agent_id
	);

	INSERT INTO mczbase.person (
		person_id,
		last_name,
		first_name,
		middle_name
	) VALUES (
		l_new_agent_id,
		l_last_name,
		l_first_name,
		l_middle_name
	);

	SELECT mczbase.sq_agent_name_id.NEXTVAL INTO l_new_pref_agent_name_id FROM dual;

	INSERT INTO mczbase.agent_name (
		agent_name_id,
		agent_id,
		agent_name_type,
		agent_name
	) VALUES (
		l_new_pref_agent_name_id,
		l_new_agent_id,
		'preferred',
		l_preferred_name
	);

	SELECT mczbase.sq_agent_name_id.NEXTVAL INTO l_new_login_agent_name_id FROM dual;

	INSERT INTO mczbase.agent_name (
		agent_name_id,
		agent_id,
		agent_name_type,
		agent_name
	) VALUES (
		l_new_login_agent_name_id,
		l_new_agent_id,
		'login',
		l_username
	);

	IF l_email IS NOT NULL AND LENGTH(TRIM(l_email)) > 0 THEN
		SELECT mczbase.sq_electronic_address_id.NEXTVAL INTO l_new_eaddr_id FROM dual;

		INSERT INTO mczbase.electronic_address (
			electronic_address_id,
			agent_id,
			address_type,
			address
		) VALUES (
			l_new_eaddr_id,
			l_new_agent_id,
			'e-mail',
			l_email
		);
	END IF;

	UPDATE mczbase.agent
	SET preferred_agent_name_id = l_new_pref_agent_name_id
	WHERE agent_id = l_new_agent_id;

	p_agent_id := l_new_agent_id;
	p_status := 'CREATED';
	p_message := 'Created new agent/person + preferred/login names + email (if present).';

EXCEPTION
	WHEN DUP_VAL_ON_INDEX THEN
		-- Race inserting login/email: try resolve by login
		BEGIN
			SELECT MIN(an.agent_id)
			INTO p_agent_id
			FROM mczbase.agent_name an
			WHERE an.agent_name_type = 'login'
				AND an.agent_name = l_username;

			p_status := 'FOUND_LOGIN';
			p_message := 'Resolved after DUP_VAL_ON_INDEX (race).';
		EXCEPTION
			WHEN OTHERS THEN
				p_agent_id := NULL;
				p_status := 'ERROR';
				p_message := 'DUP_VAL_ON_INDEX then failed to resolve: ' || SQLERRM;
		END;
	WHEN OTHERS THEN
		p_agent_id := NULL;
		p_status := 'ERROR';
		p_message := SQLERRM;
END;
