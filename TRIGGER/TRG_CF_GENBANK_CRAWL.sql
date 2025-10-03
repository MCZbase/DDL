
  CREATE OR REPLACE EDITIONABLE TRIGGER "TRG_CF_GENBANK_CRAWL" 
 before insert OR UPDATE ON cf_genbank_crawl
 for each row
    begin
        select somerandomsequence.nextval into :new.gbcid from dual;
    end;


ALTER TRIGGER "TRG_CF_GENBANK_CRAWL" ENABLE