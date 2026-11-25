
  CREATE OR REPLACE EDITIONABLE FUNCTION "IS_MEDIA_ENCUMBERED" 
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
--  @param the media_id to check for visibility
--  @return 0 if media are freely visible,
--    -1 if media have restrictions, but not for
--    the current user
--    1 if the media are restricted for the
--    current user and should be hidden from them.
AS
  hiddenlist    NUMBER;
  vpinternal    NUMBER;
  checkval      NUMBER;
  encumbered    NUMBER;
BEGIN
      -- Question 1: is this image encumbered?
      -- Encumbered means: mask_media_fg is 1, or media is in a directory where
      --   all media should be encumbered (vertpaleo/internal).
      -- Question 2, asked only of encumbered media: is it in the VP encumbered directory?
      -- The parameter is qualified with the function name, as media_id alone is the column.
      SELECT count(*),
             count(CASE WHEN auto_path LIKE '%specimen_images/vertpaleo/internal%' THEN 1 END)
        INTO hiddenlist, vpinternal
        FROM MCZBASE.media
       WHERE ((mask_media_fg IS NOT NULL AND mask_media_fg = 1)
              OR auto_path LIKE '%specimen_images/vertpaleo/internal%')
         AND media.media_id = IS_MEDIA_ENCUMBERED.media_id;

      IF hiddenlist = 0 THEN
          RETURN 0;
      END IF;
      encumbered := 1;

      -- if media are encumbered, should the current user be allowed to see them?
      IF vpinternal = 1 THEN
          -- It is a VP specimen
          -- Question 3: Does the current user have see VP images permissions
          SELECT count(*)
            INTO checkval
            FROM SYS.dba_role_privs
                 LEFT JOIN MCZBASE.cf_ctuser_roles ON upper(dba_role_privs.granted_role) = upper(cf_ctuser_roles.role_name)
           WHERE role_name IS NOT NULL
             AND grantee = SYS_CONTEXT('USERENV','SESSION_USER')
             AND granted_role = 'SEE_HIDDEN_VP_MEDIA';
          IF checkval = 1 THEN
              -- media are encumbered, but can be shown in this context
              encumbered := -1;
          END IF;
      ELSE
          -- It is not a hidden VP specimen
          -- Question 3: Does the current user have manage media permissions?
          SELECT count(*)
            INTO checkval
            FROM SYS.dba_role_privs
                 LEFT JOIN MCZBASE.cf_ctuser_roles ON upper(dba_role_privs.granted_role) = upper(cf_ctuser_roles.role_name)
           WHERE role_name IS NOT NULL
             AND grantee = SYS_CONTEXT('USERENV','SESSION_USER')
             AND granted_role = 'MANAGE_MEDIA';
          IF checkval = 1 THEN
              -- Question 4: Is the media object either not of a specimen, or of a specimen in a collection for which the
              -- current user has VPD access.
              SELECT count(DISTINCT media.media_id)
                INTO checkval
                FROM MCZBASE.media
                     LEFT JOIN MCZBASE.media_relations ON media.media_id = media_relations.media_id
                     LEFT JOIN MCZBASE.cataloged_item ON media_relations.related_primary_key = cataloged_item.collection_object_id
                     LEFT JOIN MCZBASE.vpd_collection_cde ON cataloged_item.collection_cde = vpd_collection_cde.collection_cde
               WHERE ((
                        media_relations.media_relationship = 'shows cataloged_item' AND
                        (vpd_collection_cde.collection_cde IS NOT NULL OR media_relations.media_relationship IS NULL)
                      ) OR (
                        media_relations.media_relationship <> 'shows cataloged_item'
                      ) OR (
                        media_relations.media_relationship IS NULL
                      ))
                 AND media.media_id = IS_MEDIA_ENCUMBERED.media_id;
              IF checkval = 1 THEN
                  -- media are encumbered, but can be shown in this context
                  encumbered := -1;
              END IF;
          END IF;
      END IF;

      RETURN encumbered;
END IS_MEDIA_ENCUMBERED;
