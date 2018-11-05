
  CREATE OR REPLACE TRIGGER "TRG_MK_HIGHER_GEOG" 
BEFORE INSERT OR UPDATE ON geog_auth_rec
FOR EACH ROW
DECLARE
	hg varchar2(4000);
BEGIN
	IF :NEW.continent_ocean IS NOT null THEN
		IF hg IS null THEN
			hg := :NEW.continent_ocean;
		else
			hg := hg || ': ' || :NEW.continent_ocean;
		END IF;
	END IF;
  IF :NEW.ocean_region IS NOT null THEN
		IF hg IS null THEN
			hg := :NEW.ocean_region;
		else
			hg := hg || ': ' || :NEW.ocean_region;
		END IF;
	END IF;  
  IF :NEW.ocean_subregion IS NOT null THEN
		IF hg IS null THEN
			hg := :NEW.ocean_subregion;
		else
			hg := hg || ': ' || :NEW.ocean_subregion;
		END IF;
	END IF;  
	IF :NEW.sea IS NOT null THEN
		IF hg IS null THEN
			hg := :NEW.sea;
		else
			hg := hg || ': ' || :NEW.sea;
		END IF;
	END IF;
	IF :NEW.country IS NOT null THEN
		IF hg IS null THEN
			hg := :NEW.country;
		else
			hg := hg || ': ' || :NEW.country;
		END IF;
	END IF;
	IF :NEW.state_prov IS NOT null THEN
		IF hg IS null THEN
			hg := :NEW.state_prov;
		else
			hg := hg || ': ' || :NEW.state_prov;
		END IF;
	END IF;
	IF :NEW.county IS NOT null THEN
		IF hg IS null THEN
			hg := :NEW.county;
		else
			hg := hg || ': ' || :NEW.county;
		END IF;
	END IF;
	IF :NEW.quad IS NOT null THEN
		IF hg IS null THEN
			hg := :NEW.quad || ' Quad';
		else
			hg := hg || ': ' || :NEW.quad || ' Quad';
		END IF;
	END IF;
	IF :NEW.feature IS NOT null THEN
		IF hg IS null THEN
			hg := :NEW.feature;
		else
			hg := hg || ': ' || :NEW.feature;
		END IF;
	END IF;
	IF :NEW.water_feature IS NOT null THEN
		IF hg IS null THEN
			hg := :NEW.feature;
		else
			hg := hg || ': ' || :NEW.water_feature;
		END IF;
	END IF;
	IF :NEW.island_group IS NOT null THEN
		IF hg IS null THEN
			hg := :NEW.island_group;
		else
			hg := hg || ': ' || :NEW.island_group;
		END IF;
	END IF;
	IF :NEW.island IS NOT null THEN
		IF hg IS null THEN
			hg := :NEW.island;
		else
			hg := hg || ': ' || :NEW.island;
		END IF;
	END IF;    
	:NEW.higher_geog := trim(hg);
END;
ALTER TRIGGER "TRG_MK_HIGHER_GEOG" ENABLE