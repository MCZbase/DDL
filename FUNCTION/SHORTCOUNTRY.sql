
  CREATE OR REPLACE EDITIONABLE FUNCTION "SHORTCOUNTRY" 
--  Given a string that might be a country name, shorten it if it occurs on a list of long country names
(
  COUNTRY IN VARCHAR2  
) RETURN VARCHAR2 AS 
BEGIN
  if country like 'United States' then return 'USA'; end if;
  if country like 'United States of America' then return 'USA'; end if;
  if country like 'United States Minor Outlying Islands' then return 'US Minor Outlying Islands'; end if;
  if country like 'Commonwealth of the Bahamas' then return 'Bahamas'; end if;
  if country like 'Democratic Republic of the Congo' then return 'D.R. Congo'; end if;
  if country like 'Federated States of Micronesia' then return 'Micronesia'; end if;
  if country like 'British Virgin Islands' then return 'Virgin Islands (UK)'; end if;
  if country like 'Republic of Trinidad and Tobago' then return 'Trinidad and Tobago'; end if;
  if country like 'Saint Kitts and Nevis' then return 'St. Kitts and Nevis'; end if;
  if country like 'Central African Republic' then return 'C.A.R.'; end if;
  if country like 'Virgin Islands of the United States' then return 'U.S. Virgin Islands'; end if;
  if country like 'Turks and Caicos Islands' then return 'Turks and Caicos'; end if;
  if country like 'Democratic Republic of Timor-Leste' then return 'D.R. Timor-Leste'; end if;
  if country like 'Saint Vincent and the Grenadines' then return 'St. Vincent and Grenadines'; end if;
  if country like 'Saint Vincent And The Grenadines' then return 'St. Vincent and Grenadines'; end if;
  if country like 'Saint Helena, Ascension and Tristan da Cunha' then return 'St. Helena, Ascension, Tristan da Cunha'; end if;
  if country like 'British Indian Ocean Territory' then return 'British Indian Ocean Terr.'; end if;

  RETURN country;
END SHORTCOUNTRY;