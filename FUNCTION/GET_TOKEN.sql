
  CREATE OR REPLACE EDITIONABLE FUNCTION "GET_TOKEN" (
    the_list  varchar2,
    the_index number,
    delim     varchar2 := ','
)
    return    varchar2
-- Obtain a token at a selected position from a delimited list of tokens.
--   get_token('a,b',1) returns 'a', get_token('a;b',2,';') returns 'b'.
--
-- @param the_list a varchar containing a list of tokens
-- @param the_index the 1 based position of the token in the list to return.
-- @param delim optional delimiter, if not provided a comma is used as the delimiter.
-- @return a varchar containing the token at the provided index position in the list, 
--    returns the_list if the_list does not contain the delimiter and the_index is 1
--    returns null if the_index points to a token past the end of the list.
-- @throws ORA-06502 if the_index is less than or equal to zero.
is
    start_pos number;
    end_pos   number;
begin
    if the_index = 1 then
        start_pos := 1;
    else
        start_pos := instr(the_list,delim,1,the_index - 1);
        if start_pos = 0 then
            return null;
        else
            start_pos := start_pos + length(delim);
        end if;
    end if;

    end_pos := instr(the_list,delim,start_pos,1);

    if end_pos = 0 then
        return substr(the_list,start_pos);
    else
        return substr(the_list,start_pos,end_pos - start_pos);
    end if;

end get_token;