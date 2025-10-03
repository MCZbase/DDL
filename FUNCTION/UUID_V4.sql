
  CREATE OR REPLACE EDITIONABLE FUNCTION "UUID_V4" RETURN VARCHAR2 IS
   -- return an RFC 4122 compliant type 4 uuid as a formatted string with dashes, using java UUIDGen to guarantee RFC 4122 compliance.
    LANGUAGE JAVA
    NAME 'UUIDGen.randomUUID() return java.lang.String';
