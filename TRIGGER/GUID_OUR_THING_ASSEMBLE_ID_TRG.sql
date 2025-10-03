
  CREATE OR REPLACE EDITIONABLE TRIGGER "GUID_OUR_THING_ASSEMBLE_ID_TRG" 
BEFORE INSERT ON MCZBASE.GUID_OUR_THING
FOR EACH ROW
BEGIN
  -- UUID: urn:uuid:{local_identifier}
  IF :NEW.SCHEME = 'urn' AND :NEW.TYPE = 'uuid' THEN
    :NEW.ASSEMBLED_IDENTIFIER := 'urn:uuid:' || :NEW.LOCAL_IDENTIFIER;
    -- MCZbase has a resolver for these:, use if one was not provided:
    IF :NEW.RESOLVER_PREFIX is null THEN
        :NEW.RESOLVER_PREFIX := 'https://mczbase.mcz.harvard.edu/uuid/';
        :NEW.ASSEMBLED_RESOLVABLE := 'https://mczbase.mcz.harvard.edu/uuid/' || :NEW.LOCAL_IDENTIFIER;
    ELSE
        :NEW.ASSEMBLED_RESOLVABLE := :NEW.RESOLVER_PREFIX || :NEW.LOCAL_IDENTIFIER;
    END IF;

  -- CATALOG: urn:catalog:{authority}:{local_identifier}
  ELSIF :NEW.SCHEME = 'urn' AND :NEW.TYPE = 'catalog' THEN
    :NEW.ASSEMBLED_IDENTIFIER := 'urn:catalog:' || :NEW.AUTHORITY || ':' || :NEW.LOCAL_IDENTIFIER;
    -- MCZbase has a resolver for these:
    :NEW.RESOLVER_PREFIX := 'https://mczbase.mcz.harvard.edu/guid/';
    :NEW.ASSEMBLED_RESOLVABLE := 'https://mczbase.mcz.harvard.edu/guid/' || :NEW.AUTHORITY || ':' || :NEW.LOCAL_IDENTIFIER;

  -- LSID: urn:lsid:{authority}:{local_identifier}
  ELSIF :NEW.SCHEME = 'urn' AND :NEW.TYPE = 'lsid' THEN
    :NEW.ASSEMBLED_IDENTIFIER := 'urn:lsid:' || :NEW.AUTHORITY || ':' || :NEW.LOCAL_IDENTIFIER;

  -- DOI: doi:{authority}/{local_identifier}
  ELSIF :NEW.SCHEME = 'doi' AND :NEW.TYPE = 'doi' THEN
    :NEW.ASSEMBLED_IDENTIFIER := 'doi:' || :NEW.AUTHORITY || '/' || :NEW.LOCAL_IDENTIFIER;
    -- there is a standard doi resolver: 
    :NEW.RESOLVER_PREFIX := 'https://doi.org/';
    :NEW.ASSEMBLED_RESOLVABLE := 'https://doi.org/' || :NEW.AUTHORITY || '/' || :NEW.LOCAL_IDENTIFIER;

  -- ARK: ark:/{authority}/{local_identifier}
  ELSIF :NEW.SCHEME = 'ark' AND :NEW.TYPE = 'ark' THEN
    :NEW.ASSEMBLED_IDENTIFIER := 'ark:/' || :NEW.AUTHORITY || '/' || :NEW.LOCAL_IDENTIFIER;

  -- HANDLE: hdl:{authority}/{local_identifier}  
  ELSIF :NEW.SCHEME = 'hdl' AND :NEW.TYPE = 'handle' THEN
    :NEW.ASSEMBLED_IDENTIFIER := 'hdl:' || :NEW.AUTHORITY || '/' || :NEW.LOCAL_IDENTIFIER;  

  -- PURL: http://purl.org/{authority}/{local_identifier}
  ELSIF :NEW.SCHEME = 'purl' AND :NEW.TYPE = 'purl' THEN
    :NEW.ASSEMBLED_IDENTIFIER := 'https://purl.org/' || :NEW.AUTHORITY || '/' || :NEW.LOCAL_IDENTIFIER;
    -- there is a standard purl resolver
    :NEW.RESOLVER_PREFIX := 'https://purl.org/';
    :NEW.ASSEMBLED_RESOLVABLE := 'https://purl.org/' || :NEW.AUTHORITY || '/' || :NEW.LOCAL_IDENTIFIER;

  -- Default: just concatenate scheme:type:authority:local_identifier (fallback)
  ELSE
    :NEW.ASSEMBLED_IDENTIFIER := 
      NVL(:NEW.SCHEME, '') || ':' ||
      NVL(:NEW.TYPE, '') || ':' ||
      NVL(:NEW.AUTHORITY, '') || ':' ||
      NVL(:NEW.LOCAL_IDENTIFIER, '');
  END IF;
END;

ALTER TRIGGER "GUID_OUR_THING_ASSEMBLE_ID_TRG" ENABLE