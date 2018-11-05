
  CREATE TABLE "CONTAINER" 
   (	"CONTAINER_ID" NUMBER NOT NULL ENABLE, 
	"PARENT_CONTAINER_ID" NUMBER NOT NULL ENABLE, 
	"CONTAINER_TYPE" VARCHAR2(20 CHAR) NOT NULL ENABLE, 
	"LABEL" VARCHAR2(255 CHAR) NOT NULL ENABLE, 
	"DESCRIPTION" VARCHAR2(1000 CHAR), 
	"PARENT_INSTALL_DATE" DATE, 
	"CONTAINER_REMARKS" VARCHAR2(1000 CHAR), 
	"BARCODE" VARCHAR2(50 CHAR), 
	"PRINT_FG" NUMBER(1,0), 
	"WIDTH" NUMBER, 
	"HEIGHT" NUMBER, 
	"LENGTH" NUMBER, 
	"NUMBER_POSITIONS" NUMBER, 
	"LOCKED_POSITION" NUMBER(1,0) NOT NULL ENABLE, 
	"INSTITUTION_ACRONYM" VARCHAR2(20 CHAR) DEFAULT 'MCZ' NOT NULL ENABLE, 
	 CONSTRAINT "PK_CONTAINER" PRIMARY KEY ("CONTAINER_ID")
  USING INDEX  ENABLE, 
	 CONSTRAINT "FK_CTCONTAINER_TYPE" FOREIGN KEY ("CONTAINER_TYPE")
	  REFERENCES "CTCONTAINER_TYPE" ("CONTAINER_TYPE") ENABLE
   ) 