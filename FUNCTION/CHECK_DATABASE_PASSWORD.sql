
  CREATE OR REPLACE EDITIONABLE FUNCTION "CHECK_DATABASE_PASSWORD" (
      p_username     IN VARCHAR2,
      p_new_password IN VARCHAR2,
      p_old_password IN VARCHAR2 DEFAULT NULL
) RETURN VARCHAR2
AS
      -- Returns 'OK', or a message saying why the username or password is not acceptable for
      -- an Oracle account's password change.  Which accounts MCZbase may change is checked by the caller.
      v_account VARCHAR2(128);
BEGIN
      IF p_username IS NULL THEN
              RETURN 'No database username given.';
      END IF;
      IF NOT REGEXP_LIKE(p_username, '^[A-Za-z][A-Za-z0-9_$#]{0,127}$') THEN
              RETURN 'Not a valid database username.';
      END IF;

      BEGIN
              SELECT username INTO v_account FROM all_users WHERE username = UPPER(p_username);
      EXCEPTION
              WHEN NO_DATA_FOUND THEN
                      RETURN 'No database account for this username.';
      END;

      IF p_new_password IS NULL THEN
              RETURN 'No password given.';
      END IF;
      IF LENGTHB(p_new_password) < 8 THEN
              RETURN 'The password must be at least 8 characters.';
      END IF;
      IF LENGTHB(p_new_password) > 30 THEN
              RETURN 'The password must be no more than 30 characters.';
      END IF;
      IF LENGTHB(p_new_password) <> LENGTH(p_new_password) THEN
              RETURN 'The password may not contain accented or other non-ASCII characters.';
      END IF;
      IF INSTR(p_new_password, CHR(34)) > 0 THEN
              RETURN 'The password may not contain a double quote.';
      END IF;
      IF REGEXP_LIKE(p_new_password, '[[:space:][:cntrl:]]') THEN
              RETURN 'The password may not contain spaces or control characters.';
      END IF;

      RETURN 'OK';
END check_database_password;
