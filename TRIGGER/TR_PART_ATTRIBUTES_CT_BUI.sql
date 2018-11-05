
  CREATE OR REPLACE TRIGGER "TR_PART_ATTRIBUTES_CT_BUI" 
BEFORE UPDATE OR INSERT ON specimen_part_attribute
FOR EACH ROW
DECLARE
  num number;
  numRecs NUMBER;
  thisError varchar2(4000);
  taxa_one varchar2(255);
  taxa_two varchar2(255);
   no_problem_go_away exception;

BEGIN

IF :new.attribute_type = 'scientific name' then
  thisError :=null;
      
  IF (:new.attribute_value is null) THEN
                          thisError :=  thisError || '; taxon_name is required';
                  ELSE
                          if instr(:new.attribute_value,' or ') > 1 then
                                  num := instr(:new.attribute_value, ' or ') -1;
                                  taxa_one := substr(:new.attribute_value,1,num);
                                  taxa_two := substr(:new.attribute_value,num+5);
                          elsif instr(:new.attribute_value,' and ') > 1 then
                                  num := instr(:new.attribute_value, ' and ') -1;
                                  taxa_one := substr(:new.attribute_value,1,num);
                                  taxa_two := substr(:new.attribute_value,num+6);
                          elsif instr(:new.attribute_value,' near ') > 1 then
                                  num := instr(:new.attribute_value, ' near ') -1;
                                  taxa_one := substr(:new.attribute_value,1,num);
                                  taxa_two := substr(:new.attribute_value,num+7);
                          elsif instr(:new.attribute_value,' x ') > 1 then
                                  num := instr(:new.attribute_value, ' x ') -1;
                                  taxa_one := substr(:new.attribute_value,1,num);
                                  taxa_two := substr(:new.attribute_value,num+4);
                          elsif  substr(:new.attribute_value,length(:new.attribute_value) - 3) = ' sp.' then
                                  taxa_one := substr(:new.attribute_value,1,length(:new.attribute_value) - 4);
                          elsif  substr(:new.attribute_value,length(:new.attribute_value) - 4) = ' ssp.' then
                                  taxa_one := substr(:new.attribute_value,1,length(:new.attribute_value) - 5);
                          elsif  substr(:new.attribute_value,length(:new.attribute_value) - 4) = ' var.' then
                                  taxa_one := substr(:new.attribute_value,1,length(:new.attribute_value) - 5);
                          elsif  substr(:new.attribute_value,length(:new.attribute_value) - 8) = ' sp. nov.' then
                                  taxa_one := substr(:new.attribute_value,1,length(:new.attribute_value) - 9);
                          elsif  substr(:new.attribute_value,length(:new.attribute_value) - 9) = ' gen. nov.' then
                                  taxa_one := substr(:new.attribute_value,1,length(:new.attribute_value) - 10);
                          elsif  substr(:new.attribute_value,length(:new.attribute_value) - 7) = ' (Group)' then
                                  taxa_one := substr(:new.attribute_value,1,length(:new.attribute_value) - 8);
                          elsif  substr(:new.attribute_value,length(:new.attribute_value) - 3) = ' cf.' then
                                  taxa_one := substr(:new.attribute_value,1,length(:new.attribute_value) - 4);
                          elsif  substr(:new.attribute_value,length(:new.attribute_value) - 4) = ' aff.' then
                                  taxa_one := substr(:new.attribute_value,1,length(:new.attribute_value) - 5);
                          elsif  substr(:new.attribute_value,length(:new.attribute_value) - 4) = ' neaer' then
                                  taxa_one := substr(:new.attribute_value,1,length(:new.attribute_value) - 5);
                          elsif  substr(:new.attribute_value,length(:new.attribute_value) - 1) = ' ?' then
                                  taxa_one := substr(:new.attribute_value,1,length(:new.attribute_value) - 2);
                          elsif (instr(:new.attribute_value,' {') > 1 AND instr(:new.attribute_value,'}') > 1) then
                                  taxa_one := regexp_replace(:new.attribute_value,' {.*}$','');
                          else
                                  taxa_one := :new.attribute_value;
                          end if;                         
                          if taxa_two is not null AND (
                                    substr(taxa_one,length(taxa_one) - 3) = ' sp.' OR
                                          substr(taxa_two,length(taxa_two) - 3) = ' sp.' OR
                                          substr(taxa_one,length(taxa_one) - 1) = ' ?' OR
                                          substr(taxa_two,length(taxa_two) - 1) = ' ?' 
                                  ) then
                                          thisError :=  thisError || '; "sp." and "?" are not allowed in multi-taxon IDs';
                          end if;
                          if taxa_one is not null then
                                  select count(distinct(taxon_name_id)) into numRecs from taxonomy where scientific_name = trim(taxa_one);
                                  if numRecs = 0 then
                                          thisError :=  thisError || '; Taxonomy (' || taxa_one || ') not found';
                                  end if;
                          end if;
                          if taxa_two is not null then
                                  select count(distinct(taxon_name_id)) into numRecs from taxonomy where scientific_name = trim(taxa_two);
                                  if numRecs = 0 then
                                          thisError :=  thisError || '; Taxonomy (' || taxa_two || ') not found';
                                  end if;
                          end if;
  END IF;
                  
  if thisError is not null then
    raise_application_error(
    -20001,
    'Invalid scientific name for specimen part:' || thisError);
  end if; 

end if;

EXCEPTION
    WHEN no_problem_go_away THEN
        NULL;
END;
ALTER TRIGGER "TR_PART_ATTRIBUTES_CT_BUI" ENABLE