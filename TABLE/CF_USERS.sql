
  CREATE TABLE "CF_USERS" 
   (	"USERNAME" VARCHAR2(30 CHAR) NOT NULL ENABLE, 
	"PASSWORD" VARCHAR2(255 CHAR) NOT NULL ENABLE, 
	"TARGET" VARCHAR2(10 CHAR), 
	"DISPLAYROWS" NUMBER, 
	"MAPSIZE" VARCHAR2(255 CHAR), 
	"PARTS" NUMBER(1,0), 
	"ACCN_NUM" NUMBER(1,0), 
	"HIGHER_TAXA" NUMBER(1,0), 
	"AF_NUM" NUMBER(1,0), 
	"RIGHTS" VARCHAR2(255 CHAR), 
	"USER_ID" NUMBER NOT NULL ENABLE, 
	"ACTIVE_LOAN_ID" NUMBER, 
	"COLLECTION" VARCHAR2(255 CHAR), 
	"IMAGES" NUMBER(1,0), 
	"PERMIT" NUMBER(1,0), 
	"CITATION" NUMBER(1,0), 
	"PROJECT" NUMBER(1,0), 
	"PRESMETH" NUMBER(1,0), 
	"ATTRIBUTES" NUMBER(1,0), 
	"COLLS" NUMBER(1,0), 
	"PHYLCLASS" NUMBER(1,0), 
	"SCINAMEOPERATOR" NUMBER(1,0), 
	"DATES" NUMBER(1,0), 
	"DETAIL_LEVEL" NUMBER(1,0), 
	"COLL_ROLE" NUMBER(1,0), 
	"CURATORIAL_STUFF" NUMBER(1,0), 
	"IDENTIFIER" NUMBER(1,0), 
	"BOUNDINGBOX" NUMBER(1,0), 
	"KILLROW" NUMBER(1,0), 
	"APPROVED_TO_REQUEST_LOANS" NUMBER(1,0), 
	"BIGSEARCHBOX" NUMBER(1,0), 
	"COLLECTING_SOURCE" NUMBER(1,0), 
	"SCIENTIFIC_NAME" NUMBER(1,0), 
	"CUSTOMOTHERIDENTIFIER" VARCHAR2(255 CHAR), 
	"CHRONOLOGICAL_EXTENT" NUMBER(1,0), 
	"MAX_ERROR_IN_METERS" NUMBER(1,0), 
	"SHOWOBSERVATIONS" NUMBER(1,0), 
	"COLLECTION_IDS" VARCHAR2(255 CHAR), 
	"EXCLUSIVE_COLLECTION_ID" NUMBER, 
	"LOAN_REQUEST_COLL_ID" VARCHAR2(255 CHAR), 
	"MISCELLANEOUS" NUMBER(1,0), 
	"LOCALITY" NUMBER(1,0), 
	"RESULTCOLUMNLIST" VARCHAR2(1000 CHAR), 
	"PW_CHANGE_DATE" DATE NOT NULL ENABLE, 
	"LAST_LOGIN" DATE, 
	"SPECSRCHPREFS" VARCHAR2(4000 CHAR), 
	"FANCYCOID" NUMBER(1,0), 
	"RESULT_SORT" VARCHAR2(255 CHAR), 
	"BLOCK_SUGGEST" NUMBER(1,0), 
	"LOCSRCHPREFS" VARCHAR2(4000 CHAR), 
	"REPORTPREFS" VARCHAR2(150)
   ) 