
  CREATE TABLE "TAX_EDITS" 
   (	"TIMESTAMP" DATE, 
	"DB_USER" VARCHAR2(30), 
	"OBJECT_NAME" VARCHAR2(128), 
	"SQL_TEXT" NVARCHAR2(2000), 
	"SQL_BIND" NVARCHAR2(2000)
   ) 