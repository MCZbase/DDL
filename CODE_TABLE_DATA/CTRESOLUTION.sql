REM INSERTING into CTRESOLUTION
SET DEFINE OFF;
SET SQLBLANKLINES ON;
Insert into CTRESOLUTION (RESOLUTION,DESCRIPTION) values ('DUPLICATE','The report duplicates another existing annotation report or issue.');
Insert into CTRESOLUTION (RESOLUTION,DESCRIPTION) values ('FIXED','The reported problem was confirmed and corrected.');
Insert into CTRESOLUTION (RESOLUTION,DESCRIPTION) values ('INCOMPLETE','The report lacks enough information to evaluate or act on it.');
Insert into CTRESOLUTION (RESOLUTION,DESCRIPTION) values ('INVALID','The report does not describe a valid problem in the data or system.');
Insert into CTRESOLUTION (RESOLUTION,DESCRIPTION) values ('MOVED','The issue was transferred to another system, process, or target record for handling.');
Insert into CTRESOLUTION (RESOLUTION,DESCRIPTION) values ('NOTABUG','The report concerns expected behavior or a non-defect condition.');
Insert into CTRESOLUTION (RESOLUTION,DESCRIPTION) values ('OBSOLETE','The report is no longer relevant because the underlying context has changed.');
Insert into CTRESOLUTION (RESOLUTION,DESCRIPTION) values ('RESOLVED','The issue has been resolved, but with no more specific resolution category applied.');
Insert into CTRESOLUTION (RESOLUTION,DESCRIPTION) values ('WONTFIX','The reported issue is acknowledged but will not be corrected.');
Insert into CTRESOLUTION (RESOLUTION,DESCRIPTION) values ('WORKSFORME','The problem could not be reproduced or is no longer observed.');
