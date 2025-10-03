
  CREATE OR REPLACE EDITIONABLE TRIGGER "CF_TEMP_TAXONOMY_KEY" 
 before insert  ON cf_temp_taxonomy
 for each row
DECLARE
	nsn varchar2(4000);
    begin
    	if :NEW.key is null then
    		select somerandomsequence.nextval into :new.key from dual;
    	end if;
		IF :NEW.subspecies IS NOT null THEN
			nsn := :NEW.subspecies;
		END IF;
		IF :NEW.infraspecific_rank IS NOT null THEN
			nsn := :NEW.infraspecIFic_rank || ' ' || nsn;
		END IF;
		IF :NEW.species IS NOT null THEN
			nsn := :NEW.species || ' ' || nsn;
		END IF;
    		IF :NEW.subgenus IS NOT null THEN
			nsn := '(' || :NEW.subgenus || ') ' || nsn;
		END IF;
		IF :NEW.genus IS NOT null THEN
			nsn := :NEW.genus || ' ' || nsn;
		END IF;
		IF :NEW.tribe IS NOT null THEN
			IF nsn IS null THEN
			    nsn := :NEW.tribe;
			END IF;
		END IF;
		IF :NEW.subfamily IS NOT null THEN
			IF nsn IS null THEN
				nsn := :NEW.subfamily;
			END IF;
		END IF;
		IF :NEW.family IS NOT null THEN
			IF nsn IS null THEN
				nsn := :NEW.family;
			END IF;
		END IF;
		IF :NEW.superfamily IS NOT null THEN
			IF nsn IS null THEN
				nsn := :NEW.superfamily;
			END IF;
		END IF;
		IF :NEW.subsection IS NOT null THEN
			IF nsn IS null THEN
				nsn := :NEW.subsection;
			END IF;
		END IF;
    IF :NEW.infraorder IS NOT null THEN
			IF nsn IS null THEN
				nsn := :NEW.infraorder;
			END IF;
		END IF;
		IF :NEW.suborder IS NOT null THEN
			IF nsn IS null THEN
				nsn := :NEW.suborder;
			END IF;
		END IF;
		IF :NEW.phylorder IS NOT null THEN
			IF nsn IS null THEN
				nsn := :NEW.phylorder;
			END IF;
		END IF;
		IF :NEW.superorder IS NOT null THEN
			IF nsn IS null THEN
				nsn := :NEW.superorder;
			END IF;
		END IF;
		IF :NEW.infraclass IS NOT null THEN
			IF nsn IS null THEN
				nsn := :NEW.infraclass;
			END IF;
		END IF;
		IF :NEW.subclass IS NOT null THEN
			IF nsn IS null THEN
				nsn := :NEW.subclass;
			END IF;
		END IF;
		IF :NEW.phylclass IS NOT null THEN
			IF nsn IS null THEN
				nsn := :NEW.phylclass;
			END IF;
		END IF;
		IF :NEW.subphylum IS NOT null THEN
			IF nsn IS null THEN
				nsn := :NEW.subphylum;
			END IF;
		END IF;
		IF :NEW.phylum IS NOT null THEN
			IF nsn IS null THEN
				nsn := :NEW.phylum;
			END IF;
		END IF;
		IF :NEW.kingdom IS NOT null THEN
			IF nsn IS null THEN
				nsn := :NEW.kingdom;
			END IF;
		END IF;
		:NEW.scientific_name := trim(nsn);
    end;

ALTER TRIGGER "CF_TEMP_TAXONOMY_KEY" ENABLE