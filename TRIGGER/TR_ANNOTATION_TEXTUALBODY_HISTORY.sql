
  CREATE OR REPLACE EDITIONABLE TRIGGER "TR_ANNOTATION_TEXTUALBODY_HISTORY" 
AFTER INSERT OR UPDATE OR DELETE
ON MCZBASE.ANNOTATION_TEXTUALBODY
FOR EACH ROW
DECLARE
	v_changed_by_username VARCHAR2(255);
	v_changed_by_agent_id NUMBER;
	v_changed_date DATE;

	PROCEDURE set_actor_from_agent_id (
		p_agent_id IN NUMBER
	) IS
	BEGIN
		v_changed_by_agent_id := p_agent_id;

		IF p_agent_id IS NOT NULL THEN
			BEGIN
				SELECT MIN(an.agent_name)
				INTO v_changed_by_username
				FROM MCZBASE.AGENT_NAME an
				WHERE an.agent_id = p_agent_id
					AND an.agent_name_type = 'login';
			EXCEPTION
				WHEN NO_DATA_FOUND THEN
					NULL;
			END;
		END IF;
	END;

	PROCEDURE set_actor_from_username (
		p_username IN VARCHAR2
	) IS
	BEGIN
		IF p_username IS NOT NULL AND LENGTH(TRIM(p_username)) > 0 THEN
			v_changed_by_username := p_username;

			BEGIN
				SELECT MIN(an.agent_id)
				INTO v_changed_by_agent_id
				FROM MCZBASE.AGENT_NAME an
				WHERE an.agent_name_type = 'login'
					AND an.agent_name = p_username;
			EXCEPTION
				WHEN NO_DATA_FOUND THEN
					NULL;
			END;
		END IF;
	END;

	PROCEDURE initialize_actor_for_insert IS
		v_parent_agent_id NUMBER;
		v_parent_username VARCHAR2(255);
	BEGIN
		v_changed_by_username := NULL;
		v_changed_by_agent_id := NULL;
		v_changed_date := NVL(:NEW.LAST_UPDATED_DATE, SYSDATE);

		IF :NEW.LAST_UPDATED_BY_AGENT_ID IS NOT NULL THEN
			set_actor_from_agent_id(:NEW.LAST_UPDATED_BY_AGENT_ID);
		ELSE
			BEGIN
				SELECT a.last_updated_by_agent_id, a.cf_username
				INTO v_parent_agent_id, v_parent_username
				FROM MCZBASE.annotations a
				WHERE a.annotation_id = :NEW.annotation_id;

				IF v_parent_agent_id IS NOT NULL THEN
					set_actor_from_agent_id(v_parent_agent_id);
				ELSIF v_parent_username IS NOT NULL THEN
					set_actor_from_username(v_parent_username);
				END IF;
			EXCEPTION
				WHEN NO_DATA_FOUND THEN
					NULL;
			END;
		END IF;

		IF v_changed_by_username IS NULL THEN
			set_actor_from_username(SYS_CONTEXT('USERENV', 'SESSION_USER'));
		END IF;
	END;

	PROCEDURE initialize_actor_for_update IS
	BEGIN
		v_changed_by_username := NULL;
		v_changed_by_agent_id := NULL;
		v_changed_date := NVL(:NEW.LAST_UPDATED_DATE, SYSDATE);

		IF :NEW.LAST_UPDATED_BY_AGENT_ID IS NOT NULL THEN
			set_actor_from_agent_id(:NEW.LAST_UPDATED_BY_AGENT_ID);
		ELSIF :OLD.LAST_UPDATED_BY_AGENT_ID IS NOT NULL THEN
			set_actor_from_agent_id(:OLD.LAST_UPDATED_BY_AGENT_ID);
		ELSE
			set_actor_from_username(SYS_CONTEXT('USERENV', 'SESSION_USER'));
		END IF;

		IF v_changed_by_username IS NULL THEN
			v_changed_by_username := SYS_CONTEXT('USERENV', 'SESSION_USER');
		END IF;
	END;

	PROCEDURE initialize_actor_for_delete IS
	BEGIN
		v_changed_by_username := NULL;
		v_changed_by_agent_id := NULL;
		v_changed_date := SYSDATE;

		IF :OLD.LAST_UPDATED_BY_AGENT_ID IS NOT NULL THEN
			set_actor_from_agent_id(:OLD.LAST_UPDATED_BY_AGENT_ID);
		ELSE
			set_actor_from_username(SYS_CONTEXT('USERENV', 'SESSION_USER'));
		END IF;

		IF v_changed_by_username IS NULL THEN
			v_changed_by_username := SYS_CONTEXT('USERENV', 'SESSION_USER');
		END IF;
	END;

	PROCEDURE log_history (
		p_annotation_id      IN NUMBER,
		p_event_type         IN VARCHAR2,
		p_changed_table      IN VARCHAR2,
		p_changed_field      IN VARCHAR2,
		p_old_value          IN VARCHAR2,
		p_new_value          IN VARCHAR2
	) IS
	BEGIN
		INSERT INTO MCZBASE.ANNOTATION_HISTORY (
			ANNOTATION_HISTORY_ID,
			ANNOTATION_ID,
			EVENT_TYPE,
			CHANGED_TABLE,
			CHANGED_FIELD,
			OLD_VALUE,
			NEW_VALUE,
			CHANGED_BY_USERNAME,
			CHANGED_BY_AGENT_ID,
			CHANGED_DATE
		) VALUES (
			MCZBASE.SQ_ANNOTATION_HISTORY_ID.NEXTVAL,
			p_annotation_id,
			p_event_type,
			p_changed_table,
			p_changed_field,
			p_old_value,
			p_new_value,
			v_changed_by_username,
			v_changed_by_agent_id,
			v_changed_date
		);
	END;
BEGIN
	IF INSERTING THEN
		initialize_actor_for_insert();

		log_history(:NEW.ANNOTATION_ID, 'CREATE', 'ANNOTATION_TEXTUALBODY', 'BODY_VALUE', NULL, :NEW.BODY_VALUE);
		log_history(:NEW.ANNOTATION_ID, 'CREATE', 'ANNOTATION_TEXTUALBODY', 'BODY_FORMAT', NULL, :NEW.BODY_FORMAT);
		log_history(:NEW.ANNOTATION_ID, 'CREATE', 'ANNOTATION_TEXTUALBODY', 'BODY_LANGUAGE', NULL, :NEW.BODY_LANGUAGE);

	ELSIF UPDATING THEN
		initialize_actor_for_update();

		IF NVL(:OLD.BODY_VALUE, '{NULL}') <> NVL(:NEW.BODY_VALUE, '{NULL}') THEN
			log_history(:NEW.ANNOTATION_ID, 'UPDATE', 'ANNOTATION_TEXTUALBODY', 'BODY_VALUE', :OLD.BODY_VALUE, :NEW.BODY_VALUE);
		END IF;

		IF NVL(:OLD.BODY_FORMAT, '{NULL}') <> NVL(:NEW.BODY_FORMAT, '{NULL}') THEN
			log_history(:NEW.ANNOTATION_ID, 'UPDATE', 'ANNOTATION_TEXTUALBODY', 'BODY_FORMAT', :OLD.BODY_FORMAT, :NEW.BODY_FORMAT);
		END IF;

		IF NVL(:OLD.BODY_LANGUAGE, '{NULL}') <> NVL(:NEW.BODY_LANGUAGE, '{NULL}') THEN
			log_history(:NEW.ANNOTATION_ID, 'UPDATE', 'ANNOTATION_TEXTUALBODY', 'BODY_LANGUAGE', :OLD.BODY_LANGUAGE, :NEW.BODY_LANGUAGE);
		END IF;

	ELSIF DELETING THEN
		initialize_actor_for_delete();
		log_history(:OLD.ANNOTATION_ID, 'DELETE', 'ANNOTATION_TEXTUALBODY', 'BODY_VALUE', :OLD.BODY_VALUE, NULL);
	END IF;
END;

ALTER TRIGGER "TR_ANNOTATION_TEXTUALBODY_HISTORY" ENABLE