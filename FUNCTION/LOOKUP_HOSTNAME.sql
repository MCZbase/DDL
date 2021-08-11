
  CREATE OR REPLACE FUNCTION "LOOKUP_HOSTNAME" 
(
  IP IN VARCHAR2 
) RETURN VARCHAR2 
-- given an ip address, try to lookup the hostname, catching any exceptions
-- @param ip the IP address to lookup the hostname for
-- @return the hostname found with UTL_INADDR.get_host_name or a string error message.
AS 
    type rc is ref cursor;
    l_val varchar(2000);
    l_cur    rc;
BEGIN
    l_val := '';
    open l_cur for '
        select UTL_INADDR.get_host_name(:x) from dual
    '
    using IP;
    loop
        fetch l_cur into l_val;
        exit when l_cur%notfound;
    end loop;
EXCEPTION
    WHEN OTHERS THEN
        IF SQLCODE = -29257 THEN
            RETURN '[host unknown]';
        ELSE 
            IF SQLCODE = -24247 THEN
                RETURN '[ORA-24247 network access denied]';
            ELSE
                RETURN '[error looking up hostname]';
            END IF;
        END IF;
        
END LOOKUP_HOSTNAME;