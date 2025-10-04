
  CREATE TABLE "COLL_EVENT_NUM_SERIES" 
   (	"COLL_EVENT_NUM_SERIES_ID" NUMBER NOT NULL ENABLE, 
	"NUMBER_SERIES" VARCHAR2(255) NOT NULL ENABLE, 
	"PATTERN" VARCHAR2(100), 
	"REMARKS" VARCHAR2(900), 
	"COLLECTOR_AGENT_ID" NUMBER, 
	 CONSTRAINT "COLL_EVENT_NUM_SERIES_PK" PRIMARY KEY ("COLL_EVENT_NUM_SERIES_ID")
  USING INDEX  ENABLE, 
	 CONSTRAINT "COLL_EVENT_NUM_SERIES_FK1" FOREIGN KEY ("COLLECTOR_AGENT_ID")
	  REFERENCES "AGENT" ("AGENT_ID") ENABLE
   ) ;
COMMENT ON TABLE "COLL_EVENT_NUM_SERIES" IS 'Number Series for collector field numbers and other local identifiers of collecting events.';
COMMENT ON COLUMN "COLL_EVENT_NUM_SERIES"."COLL_EVENT_NUM_SERIES_ID" IS 'surrogate numeric primary key';
COMMENT ON COLUMN "COLL_EVENT_NUM_SERIES"."NUMBER_SERIES" IS 'name of the number series';
COMMENT ON COLUMN "COLL_EVENT_NUM_SERIES"."PATTERN" IS 'brief human readable expected pattern for numbers in the series.';
COMMENT ON COLUMN "COLL_EVENT_NUM_SERIES"."REMARKS" IS 'description of the number series, when used, and other human readable notes concerning the number series.';
COMMENT ON COLUMN "COLL_EVENT_NUM_SERIES"."COLLECTOR_AGENT_ID" IS 'agent id of the agent for which this is a number series.';
