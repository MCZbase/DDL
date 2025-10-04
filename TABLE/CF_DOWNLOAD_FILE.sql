
  CREATE TABLE "CF_DOWNLOAD_FILE" 
   (	"CF_DOWNLOAD_FILE_ID" NUMBER NOT NULL ENABLE, 
	"TOKEN" VARCHAR2(50) NOT NULL ENABLE, 
	"RESULT_ID" VARCHAR2(50), 
	"USERNAME" VARCHAR2(30), 
	"STATUS" VARCHAR2(255), 
	"DOWNLOAD_PROFILE_ID" NUMBER, 
	"FILENAME" VARCHAR2(1000), 
	"TIME_CREATED" TIMESTAMP (6) DEFAULT CURRENT_TIMESTAMP, 
	"MESSAGE" VARCHAR2(4000), 
	 CONSTRAINT "CF_DOWNLOAD_FILE_PK" PRIMARY KEY ("CF_DOWNLOAD_FILE_ID")
  USING INDEX  ENABLE
   ) ;
COMMENT ON TABLE "CF_DOWNLOAD_FILE" IS 'Table to support asynchronous generation of large files for downloads.';
COMMENT ON COLUMN "CF_DOWNLOAD_FILE"."CF_DOWNLOAD_FILE_ID" IS 'surrogate numeric primary key';
COMMENT ON COLUMN "CF_DOWNLOAD_FILE"."TOKEN" IS 'Token to identify a download file request record';
COMMENT ON COLUMN "CF_DOWNLOAD_FILE"."RESULT_ID" IS 'Identifier for ressult in username.user_search_table to query for download.';
COMMENT ON COLUMN "CF_DOWNLOAD_FILE"."USERNAME" IS 'username of the user requesting the download.';
COMMENT ON COLUMN "CF_DOWNLOAD_FILE"."STATUS" IS 'status of the generation of the download file';
COMMENT ON COLUMN "CF_DOWNLOAD_FILE"."DOWNLOAD_PROFILE_ID" IS 'download profile to be used in creating the download.';
COMMENT ON COLUMN "CF_DOWNLOAD_FILE"."FILENAME" IS 'Filename of the file ready for download';
COMMENT ON COLUMN "CF_DOWNLOAD_FILE"."TIME_CREATED" IS 'Timestamp record was created.';
COMMENT ON COLUMN "CF_DOWNLOAD_FILE"."MESSAGE" IS 'Optional status message';
