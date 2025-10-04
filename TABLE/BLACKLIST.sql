
  CREATE TABLE "BLACKLIST" 
   (	"IP" VARCHAR2(40 CHAR) NOT NULL ENABLE, 
	"LISTDATE" DATE DEFAULT sysdate
   ) ;
COMMENT ON TABLE "BLACKLIST" IS 'List of IP Addressed for which access is to be blocked by the MCZbase web application.';
COMMENT ON COLUMN "BLACKLIST"."IP" IS 'IP Address to block.  DOMAIN: IPV4 addresses.';
COMMENT ON COLUMN "BLACKLIST"."LISTDATE" IS 'The date on which this entry was added to the list.';
