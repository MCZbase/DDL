
  CREATE TABLE "CF_TEMP_AGENTS" 
   (	"KEY" NUMBER NOT NULL ENABLE, 
	"AGENT_TYPE" VARCHAR2(255 CHAR), 
	"PREFERRED_NAME" VARCHAR2(255 CHAR), 
	"FIRST_NAME" VARCHAR2(255 CHAR), 
	"MIDDLE_NAME" VARCHAR2(255 CHAR), 
	"LAST_NAME" VARCHAR2(255 CHAR), 
	"BIRTH_DATE" VARCHAR2(22), 
	"DEATH_DATE" VARCHAR2(22), 
	"AGENT_REMARK" VARCHAR2(255 CHAR), 
	"PREFIX" VARCHAR2(255 CHAR), 
	"SUFFIX" VARCHAR2(255 CHAR), 
	"STATUS" VARCHAR2(4000 CHAR), 
	"OTHER_NAME_TYPE_2" VARCHAR2(255 CHAR), 
	"OTHER_NAME_2" VARCHAR2(255 CHAR), 
	"OTHER_NAME_TYPE_3" VARCHAR2(255 CHAR), 
	"OTHER_NAME_3" VARCHAR2(255 CHAR), 
	"USERNAME" VARCHAR2(1020), 
	"AGENTGUID" VARCHAR2(255), 
	"AGENTGUID_GUID_TYPE" VARCHAR2(255 CHAR), 
	"OTHER_NAME_1" VARCHAR2(255 CHAR), 
	"OTHER_NAME_TYPE_1" VARCHAR2(255 CHAR), 
	"BIOGRAPHY" VARCHAR2(4000)
   ) ;
COMMENT ON COLUMN "CF_TEMP_AGENTS"."KEY" IS 'Surrogate Numeric Primary Key';
COMMENT ON COLUMN "CF_TEMP_AGENTS"."AGENT_TYPE" IS 'Required; Only "person" is valid for bulkloader. Other agent types are expedition, group, organization, other agent, vessel.';
COMMENT ON COLUMN "CF_TEMP_AGENTS"."PREFERRED_NAME" IS 'Required; This is the name that will appear on records.';
COMMENT ON COLUMN "CF_TEMP_AGENTS"."FIRST_NAME" IS 'agent_type="person" only';
COMMENT ON COLUMN "CF_TEMP_AGENTS"."MIDDLE_NAME" IS 'agent_type="person" only';
COMMENT ON COLUMN "CF_TEMP_AGENTS"."LAST_NAME" IS 'agent_type="person" only, required for a person';
COMMENT ON COLUMN "CF_TEMP_AGENTS"."BIRTH_DATE" IS 'agent_type="person" only; format: yyyy, yyyy-mm, or yyyy-mm-dd';
COMMENT ON COLUMN "CF_TEMP_AGENTS"."DEATH_DATE" IS 'agent_type="person" only; format:  yyyy, yyyy-mm, or yyyy-mm-dd';
COMMENT ON COLUMN "CF_TEMP_AGENTS"."AGENT_REMARK" IS 'Internal remarks related to the agent';
COMMENT ON COLUMN "CF_TEMP_AGENTS"."PREFIX" IS 'agent_type="person" only; A prefix to go before the first name, e.g. Dr.';
COMMENT ON COLUMN "CF_TEMP_AGENTS"."SUFFIX" IS 'agent_type="person" only; A suffix to go after the name, e.g. Jr., III';
COMMENT ON COLUMN "CF_TEMP_AGENTS"."STATUS" IS 'Error messages from validation';
COMMENT ON COLUMN "CF_TEMP_AGENTS"."OTHER_NAME_TYPE_2" IS 'Valid agent name types are: abbrevation, acronym, aka, author, expanded, full, initials, initials plus last, last plus initials, login, maiden, married, preferred, published misspelling, second author.';
COMMENT ON COLUMN "CF_TEMP_AGENTS"."OTHER_NAME_2" IS 'Form of name for the other name type';
COMMENT ON COLUMN "CF_TEMP_AGENTS"."OTHER_NAME_TYPE_3" IS 'Valid agent name types are: abbrevation, acronym, aka, author, expanded, full, initials, initials plus last, last plus initials, login, maiden, married, preferred, published misspelling, second author.';
COMMENT ON COLUMN "CF_TEMP_AGENTS"."OTHER_NAME_3" IS 'Form of name for the other name type';
COMMENT ON COLUMN "CF_TEMP_AGENTS"."USERNAME" IS 'The person who created these temp rows';
COMMENT ON COLUMN "CF_TEMP_AGENTS"."AGENTGUID" IS 'For ORCiD: https://orcid.org/9999-9999-9999-9999, For VIAF: http://viaf.org/viaf/nnnnn.';
COMMENT ON COLUMN "CF_TEMP_AGENTS"."AGENTGUID_GUID_TYPE" IS 'ORCiD, VIAF';
COMMENT ON COLUMN "CF_TEMP_AGENTS"."OTHER_NAME_1" IS 'Form of name for the other name type';
COMMENT ON COLUMN "CF_TEMP_AGENTS"."OTHER_NAME_TYPE_1" IS 'Valid agent name types are: abbrevation, acronym, aka, author, expanded, full, initials, initials plus last, last plus initials, login, maiden, married, preferred, published misspelling, second author';
COMMENT ON COLUMN "CF_TEMP_AGENTS"."BIOGRAPHY" IS 'Biographical information about the agent, visible to the public';
