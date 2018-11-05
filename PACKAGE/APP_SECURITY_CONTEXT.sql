
  CREATE OR REPLACE PACKAGE "APP_SECURITY_CONTEXT" 
-- Sets user info and predicates 
IS
    PROCEDURE set_user_info;
    
    FUNCTION set_cid_pred (
        object_schema   IN  VARCHAR2  DEFAULT NULL,
        object_name     IN  VARCHAR2  DEFAULT NULL
    )     
    RETURN VARCHAR2;

    FUNCTION set_lid_pred (
        object_schema   IN  VARCHAR2  DEFAULT NULL,
        object_name     IN  VARCHAR2  DEFAULT NULL
    )     
    RETURN VARCHAR2;
END;
 
CREATE OR REPLACE PACKAGE BODY "APP_SECURITY_CONTEXT" 
IS
    PROCEDURE set_user_info
    -- Sets VPD_CONTEXT based on login
    IS
        username        VARCHAR2(30);
        clist           VARCHAR2(4000);
        rlist           VARCHAR2(4000);
        sep             CHAR(1);
    BEGIN
        -- get user information from the USERENV context
        SELECT SYS_CONTEXT ('USERENV','SESSION_USER') INTO username FROM dual;
        
        -- get the list of allowable collection_ids based on username/roles.
        FOR c IN (
            SELECT c.collection_id, d.granted_role
            FROM sys.dba_role_privs d, mczbase.cf_collection c
            WHERE d.granted_role = c.portal_name
            AND d.grantee = username
            ORDER BY c.collection_id
        ) LOOP
            clist := clist || sep || c.collection_id;
            rlist := rlist || sep || c.granted_role;
            sep := ',';
        END LOOP;
        
        -- set the vpd_context to be the list of allowable collection_ids
        DBMS_SESSION.SET_CONTEXT('VPD_CONTEXT', 'CID_LIST', clist);
        DBMS_SESSION.SET_CONTEXT('VPD_CONTEXT', 'ROLE_LIST', rlist);
    END set_user_info;
    -- generate predicate for collection_id
    
    FUNCTION set_cid_pred (
        object_schema   IN  VARCHAR2  DEFAULT NULL
       ,object_name     IN  VARCHAR2  DEFAULT NULL
    )     
    RETURN VARCHAR2
    IS
        username  VARCHAR2(30);
        predicate VARCHAR2(4000);
    BEGIN
        SELECT SYS_CONTEXT ('USERENV','SESSION_USER') INTO username FROM dual;
        
        IF SYS_CONTEXT('VPD_CONTEXT','CID_LIST') IS NOT NULL THEN
            predicate := 'collection_id in (' || SYS_CONTEXT('VPD_CONTEXT','CID_LIST') || ')';
        ELSE
            predicate := '1 = 2';
        END IF;
            
        RETURN predicate;
    END set_cid_pred;
    
    -- generate predicate for locality_id
    FUNCTION set_lid_pred (
        object_schema   IN  VARCHAR2  DEFAULT NULL
       ,object_name     IN  VARCHAR2  DEFAULT NULL
    )     
    RETURN VARCHAR2
    IS
        username  VARCHAR2(30);
        predicate VARCHAR2(4000);
    BEGIN
        SELECT SYS_CONTEXT ('USERENV','SESSION_USER') INTO username FROM dual;
        IF SYS_CONTEXT('VPD_CONTEXT','CID_LIST') IS NOT NULL THEN 
            predicate := 'locality_id in (' || 
                        'select locality_id from mczbase.vpd_collection_locality ' ||
                'where collection_id in (0,' || 
                SYS_CONTEXT('VPD_CONTEXT','CID_LIST') || '))';
        ELSE
            predicate := '1 = 2';
        END IF;
            
        RETURN predicate;
    END set_lid_pred;
END;