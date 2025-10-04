
  CREATE TABLE "COLLECTOR" 
   (	"COLLECTION_OBJECT_ID" NUMBER NOT NULL ENABLE, 
	"AGENT_ID" NUMBER NOT NULL ENABLE, 
	"COLLECTOR_ROLE" CHAR(1 CHAR) NOT NULL ENABLE, 
	"COLL_NUM_PREFIX" VARCHAR2(20 CHAR), 
	"COLL_NUM" NUMBER(15,0), 
	"COLL_NUM_SUFFIX" VARCHAR2(9 CHAR), 
	"COLL_ORDER" NUMBER NOT NULL ENABLE, 
	"COLLECTOR_ID" NUMBER NOT NULL ENABLE, 
	 CONSTRAINT "COLL_ROLE_CHECK" CHECK (COLLECTOR_ROLE IN ('c','p')) ENABLE, 
	 CONSTRAINT "COLLECTOR_PK" PRIMARY KEY ("COLLECTOR_ID")
  USING INDEX  ENABLE, 
	 CONSTRAINT "FK_COLLECTOR_CATITEM" FOREIGN KEY ("COLLECTION_OBJECT_ID")
	  REFERENCES "CATALOGED_ITEM" ("COLLECTION_OBJECT_ID") ENABLE, 
	 CONSTRAINT "FK_CTCOLLECTOR_ROLE" FOREIGN KEY ("COLLECTOR_ROLE")
	  REFERENCES "CTCOLLECTOR_ROLE" ("COLLECTOR_ROLE") ENABLE, 
	 CONSTRAINT "FK_COLLECTOR_AGENT" FOREIGN KEY ("AGENT_ID")
	  REFERENCES "AGENT" ("AGENT_ID") ENABLE
   ) ;
COMMENT ON TABLE "COLLECTOR" IS 'Agents who act upon collection objects (collectors, preparators).    Collectors are treated as attributes of collection objects rather than collecting events to (1) support vauge collecting events to which multiple specimens can be attached from different collectors on different unknown event dates, and more importantly (2) to support different disciplines understanding of what comprises a collecting event, where some disciplines associate a collector with a collecting event, but others bin multiple collectors of different material from the same place and time into one collecting event.';
COMMENT ON COLUMN "COLLECTOR"."COLLECTION_OBJECT_ID" IS 'collection object on which the agent acted';
COMMENT ON COLUMN "COLLECTOR"."AGENT_ID" IS 'agent who acted on the collection object';
COMMENT ON COLUMN "COLLECTOR"."COLLECTOR_ROLE" IS 'role (c=collector, p=preparator) in which the agent acted on the collection object.';
COMMENT ON COLUMN "COLLECTOR"."COLL_NUM_PREFIX" IS 'unused';
COMMENT ON COLUMN "COLLECTOR"."COLL_NUM" IS 'unused';
COMMENT ON COLUMN "COLLECTOR"."COLL_NUM_SUFFIX" IS 'unused';
COMMENT ON COLUMN "COLLECTOR"."COLL_ORDER" IS 'sort order for agents with the same role on the same collection object.';
COMMENT ON COLUMN "COLLECTOR"."COLLECTOR_ID" IS 'surrogate numeric primary key';
