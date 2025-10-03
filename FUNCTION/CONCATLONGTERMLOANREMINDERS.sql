
  CREATE OR REPLACE EDITIONABLE FUNCTION "CONCATLONGTERMLOANREMINDERS" (p_key_val  in number )
    return varchar2
    as
        type rc is ref cursor;
        l_str    varchar2(4000);
       l_sep    varchar2(30);
       l_val    varchar2(4000);

       l_cur    rc;
   begin

      open l_cur for 'select DISTINCT to_char(date_sent, ''YYYY-MM-DD'') from loan_reminder_log where REMINDER_TYPE = ''L'' AND agent_id = :x '
                          using p_key_val;

       loop
           fetch l_cur into l_val;
           exit when l_cur%notfound;
           l_str := l_str || l_sep || l_val;
           l_sep := '; ';
       end loop;
       close l_cur;

       return l_str;
  end;