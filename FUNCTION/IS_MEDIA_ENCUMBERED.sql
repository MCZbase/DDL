
  CREATE OR REPLACE FUNCTION "IS_MEDIA_ENCUMBERED" 
(
   MEDIA_ID IN NUMBER
)  RETURN NUMBER 
--  Supporting enucumberance of media objects  --
--  Given a media id, return 0 if the media have 
--  no encuberance.  Return 1 if the media are
--  encumbered and should not be shown for the 
--  current user.  Return -1 if the media are 
--  encumbered but can be shown to the current 
--  user (session_user).  
--  Use with: 
--    where is_media_encumbered(media_id) < 1 
--  to show media that can be shown in the current
--  user context.
--  Use with: 
--    where is_media_encumbered(media_id) = 0
--  to show only media that are not encumbered 
--  (as in an audubon core image feed).
AS 
  type rc is ref cursor;
  hiddenlist    NUMBER;
  encumbered    NUMBER;
  checkval      NUMBER;
  l_cur    rc;
BEGIN
      hiddenlist := 1; 
      encumbered := 1;
      -- Question 1: is this image encumbered?
      -- Encumbered means: mask_media_fg is 1, or media is in a directory where
      --   all media should be encumbered (vertpaleo/internal).
      open l_cur for 'select count(*) from media
                      where ((mask_media_fg is not null and mask_media_fg = 1)
                             or media_uri like ''%specimen_images/vertpaleo/internal%'')
                      and  media_id = :x '
                 using media_id;
      loop
           fetch l_cur into hiddenlist;
           exit when l_cur%notfound;
           if hiddenlist=0 then            
              encumbered := 0 ;
           end if;   
           if hiddenlist>0 then 
              encumbered := 1 ;
           end if; 
      end loop;
      close l_cur;
 
      -- if media are encumbered, should the current user be allowed to see them? 
      if encumbered=1 then 
          -- Question 2: Is this media object in the VP encumbered directory?
          checkval := 0;
          open l_cur for 'select count(distinct media.media_id) from media
                      where media_uri like ''%specimen_images/vertpaleo/internal%''
                      and  media_id = :x '
                 using media_id;
          loop
              fetch l_cur into checkval;
              exit when l_cur%notfound;    
           end loop;      
           close l_cur;
           if checkval=1 then            
              -- It is a VP specimen
              -- Question 3: Does the current user have see VP images permissions
              open l_cur for '
                    select count(*) from dba_role_privs 
                         left join cf_ctuser_roles on upper(dba_role_privs.granted_role) = upper(cf_ctuser_roles.role_name)
                    where role_name is not null and 
                          grantee = SYS_CONTEXT(''USERENV'',''SESSION_USER'') and
                          granted_role = ''SEE_HIDDEN_VP_MEDIA''';
              loop
                  fetch l_cur into checkval;
                  exit when l_cur%notfound;    
              end loop;      
              close l_cur;
              if checkval = 1 then 
                   -- media are encumbered, but can be shown in thiis context
                   encumbered := -1;
              end if;
           else 
              -- It is not a hidden VP specimen 
       
              -- Question 3: Does the current user have manage media permissions? 
              checkval := 0;
              open l_cur for 'select count(*) from dba_role_privs 
                         left join cf_ctuser_roles on upper(dba_role_privs.granted_role) = upper(cf_ctuser_roles.role_name)
                    where role_name is not null and 
                          grantee = SYS_CONTEXT(''USERENV'',''SESSION_USER'') and
                          granted_role = ''MANAGE_MEDIA'' ';
              loop
                  fetch l_cur into checkval;
                  exit when l_cur%notfound;    
               end loop;      
               close l_cur;
               if checkval=1 then            
                  -- Question 4: Is the media object either not of a specimen, or of a specimen in a collection for which the
                  -- current user has VPD access.
                  checkval := 0;
                  open l_cur for '
                      select count(distinct media.media_id) from media
                           left join media_relations on media.media_id = media_relations.media_id
                           left join cataloged_item on media_relations.related_primary_key = cataloged_item.collection_object_id
                           left join vpd_collection_cde on cataloged_item.collection_cde = vpd_collection_cde.collection_cde
                      where ((
                               media_relations.media_relationship = ''shows cataloged_item'' and 
                               (vpd_collection_cde.collection_cde is not null or media_relations.media_relationship is null) 
                             ) or (
                               media_relations.media_relationship <> ''shows cataloged_item''
                            ))
                            and
                            media.media_id = :x '
                      using media_id;
                  loop
                      fetch l_cur into checkval;
                      exit when l_cur%notfound;    
                  end loop;      
                  close l_cur;
                  if checkval = 1 then 
                       -- media are encumbered, but can be shown in this context
                       encumbered := -1;
                  end if;
               end if;       
          end if;  -- VP or not 
      end if; -- is encumbered 

      return encumbered;
END IS_MEDIA_ENCUMBERED;