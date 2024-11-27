-- Cleanup for podcast-app

DROP PROCEDURE podcastAdmin.sp_change_sdescription;
DROP PROCEDURE podcastAdmin.sp_change_eparticipant;
DROP PROCEDURE podcastAdmin.sp_change_prate;
DROP USER podcastAdmin CASCADE;
DROP USER podcastUser;
DROP ROLE podcastAppAdmin;
DROP ROLE podcastAppUser;
DROP TABLESPACE podcast INCLUDING CONTENTS AND DATAFILES;

-- End of Cleanup File