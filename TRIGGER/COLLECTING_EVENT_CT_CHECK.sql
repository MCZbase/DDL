
  CREATE OR REPLACE TRIGGER "COLLECTING_EVENT_CT_CHECK" 
before UPDATE or INSERT
ON collecting_event
for each row
declare
numrows number;
BEGIN
SELECT COUNT(*) INTO numrows FROM ctcollecting_source WHERE collecting_source =
:NEW.collecting_source;
        IF (numrows = 0) THEN
                 raise_application_error(
                -20001,
                'Invalid collecting_source'
           );
        END IF;
END;

ALTER TRIGGER "COLLECTING_EVENT_CT_CHECK" ENABLE