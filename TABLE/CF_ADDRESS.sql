
  CREATE TABLE "CF_ADDRESS" 
   (	"ADDR_ID" NUMBER NOT NULL ENABLE, 
	"STREET_ADDR1" VARCHAR2(255 CHAR) NOT NULL ENABLE, 
	"STREET_ADDR2" VARCHAR2(255 CHAR), 
	"CITY" VARCHAR2(60 CHAR) NOT NULL ENABLE, 
	"STATE" VARCHAR2(20 CHAR) NOT NULL ENABLE, 
	"ZIP" VARCHAR2(10 CHAR) NOT NULL ENABLE, 
	"COUNTRY_CDE" VARCHAR2(50 CHAR), 
	"MAIL_STOP" VARCHAR2(20 CHAR), 
	"ADDR_TYPE" VARCHAR2(25 CHAR) NOT NULL ENABLE, 
	"JOB_TITLE" VARCHAR2(60 CHAR), 
	"VALID_ADDR_FG" NUMBER NOT NULL ENABLE, 
	"ADDR_REMARKS" VARCHAR2(255 CHAR), 
	"INSTITUTION" VARCHAR2(255 CHAR), 
	"DEPARTMENT" VARCHAR2(255 CHAR), 
	"USER_ID" NUMBER NOT NULL ENABLE
   ) 