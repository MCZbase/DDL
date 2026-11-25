REM INSERTING into CTTAXON_CATEGORY
SET DEFINE OFF;
SET SQLBLANKLINES ON;
Insert into CTTAXON_CATEGORY (TAXON_CATEGORY,CATEGORY_TYPE,DESCRIPTION,HIDDEN_FG) values ('BGEPA Listed','US Federal protected taxa','Bald and Golden Eagle Protection Act listed taxon.',1);
Insert into CTTAXON_CATEGORY (TAXON_CATEGORY,CATEGORY_TYPE,DESCRIPTION,HIDDEN_FG) values ('ESA endangered','US Federal protected taxa','Endangered Species Act taxon listed as endangered',1);
Insert into CTTAXON_CATEGORY (TAXON_CATEGORY,CATEGORY_TYPE,DESCRIPTION,HIDDEN_FG) values ('ESA threatened','US Federal protected taxa','Endangered Species Act taxon listed as threatened',1);
Insert into CTTAXON_CATEGORY (TAXON_CATEGORY,CATEGORY_TYPE,DESCRIPTION,HIDDEN_FG) values ('Extinct','conservation status','No reasonable doubt that the last individual of the taxon has died.',1);
Insert into CTTAXON_CATEGORY (TAXON_CATEGORY,CATEGORY_TYPE,DESCRIPTION,HIDDEN_FG) values ('Ichnotaxon','taxonomic','A taxon based on the fossilized work of an organism.',0);
Insert into CTTAXON_CATEGORY (TAXON_CATEGORY,CATEGORY_TYPE,DESCRIPTION,HIDDEN_FG) values ('MBTA Listed','US Federal protected taxa','Migratory Bird Treaty Act listed taxon.',1);
Insert into CTTAXON_CATEGORY (TAXON_CATEGORY,CATEGORY_TYPE,DESCRIPTION,HIDDEN_FG) values ('MMPA Listed','US Federal protected taxa','Marine Mammal Protection Act listed taxon.',1);
