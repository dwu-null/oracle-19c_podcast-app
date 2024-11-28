-- 
-- ORACLE application database and associated users creation script for podcast application
--
-- Created by:  CST2355_24F_group2
--
-- should be run while connected as 'sys as sysdba'
--

-- Create STORAGE
CREATE TABLESPACE podcast
  DATAFILE 'podcast.dat' SIZE 40M 
  ONLINE; 
  
-- Create Users
CREATE USER podcastAdmin IDENTIFIED BY adminPassword ACCOUNT UNLOCK
	DEFAULT TABLESPACE podcast
	QUOTA 20M ON podcast;
	
CREATE USER podcastUser IDENTIFIED BY userPassword ACCOUNT UNLOCK
	DEFAULT TABLESPACE podcast
	QUOTA 5M ON podcast;
	
-- Create ROLES
CREATE ROLE podcastAppAdmin;
CREATE ROLE podcastAppUser;

-- Grant PRIVILEGES
GRANT CONNECT, RESOURCE, CREATE VIEW, CREATE TRIGGER, CREATE PROCEDURE TO podcastAppAdmin;
GRANT CONNECT, RESOURCE TO podcastAppUser;

GRANT podcastAppAdmin TO podcastAdmin;
GRANT podcastAppUser TO podcastUser;

-- Connect as the podcastAppAdmin and create the stored procedures, tables, and triggers
CONNECT podcastAdmin/adminPassword;

--
-- Sequence for primary keys use
--
CREATE SEQUENCE idchannel_seq
 START WITH     100
 INCREMENT BY   1
 NOCACHE
 NOCYCLE;

CREATE SEQUENCE idcategory_seq
 START WITH     100
 INCREMENT BY   1
 NOCACHE
 NOCYCLE;

CREATE SEQUENCE idshow_seq
 START WITH     100
 INCREMENT BY   1
 NOCACHE
 NOCYCLE;

CREATE SEQUENCE idsdecription_seq
 START WITH     100
 INCREMENT BY   1
 NOCACHE
 NOCYCLE;

CREATE SEQUENCE idshow_sdescription_seq
 START WITH     100
 INCREMENT BY   1
 NOCACHE
 NOCYCLE;

CREATE SEQUENCE idepisode_seq
 START WITH     100
 INCREMENT BY   1
 NOCACHE
 NOCYCLE;

CREATE SEQUENCE idparticipant_seq
 START WITH     100
 INCREMENT BY   1
 NOCACHE
 NOCYCLE;

CREATE SEQUENCE idepisode_participant_seq
 START WITH     100
 INCREMENT BY   1
 NOCACHE
 NOCYCLE;

CREATE SEQUENCE idfepisode_seq
 START WITH     100
 INCREMENT BY   1
 NOCACHE
 NOCYCLE;

CREATE SEQUENCE idpepisode_seq
 START WITH     100
 INCREMENT BY   1
 NOCACHE
 NOCYCLE;

CREATE SEQUENCE idprate_seq
 START WITH     100
 INCREMENT BY   1
 NOCACHE
 NOCYCLE;

CREATE SEQUENCE idpepisode_prate_seq
 START WITH     100
 INCREMENT BY   1
 NOCACHE
 NOCYCLE;

--
-- DDL for Tables
--
CREATE TABLE CHANNELS(
	channel_id NUMBER DEFAULT idchannel_seq.NEXTVAL,
	channel_name VARCHAR2(50) NOT NULL,
	PRIMARY KEY (channel_id)
);

CREATE TABLE CATEGORIES(
	category_id NUMBER DEFAULT idcategory_seq.NEXTVAL,
	category_name VARCHAR2(50) NOT NULL,
	PRIMARY KEY (category_id)
);

CREATE TABLE SHOWS(
	show_id NUMBER DEFAULT idshow_seq.NEXTVAL,
	show_name VARCHAR2(50) NOT NULL,
	channel_id NUMBER NOT NULL,
	category_id NUMBER NOT NULL,
 	PRIMARY KEY (show_id),
	CONSTRAINT fk_s_ch1 FOREIGN KEY (channel_id) REFERENCES CHANNELS (channel_id),
  	CONSTRAINT fk_s_ca1 FOREIGN KEY (category_id) REFERENCES CATEGORIES (category_id)
);

CREATE TABLE SDESCRIPTIONS(
	show_description_id NUMBER DEFAULT idsdecription_seq.NEXTVAL,
	show_description VARCHAR2(50) NOT NULL,
	PRIMARY KEY (show_description_id)
);

CREATE TABLE SHOWS_SDESCRIPTIONS(
	show_sdescription_id NUMBER DEFAULT idshow_sdescription_seq.NEXTVAL,
	show_id NUMBER NOT NULL,
	show_description_id NUMBER NOT NULL,
	start_time TIMESTAMP NOT NULL,
	end_time TIMESTAMP,
	note VARCHAR2(50) DEFAULT NULL,
 	PRIMARY KEY (show_sdescription_id),
	CONSTRAINT fk_s_s_d_s1 FOREIGN KEY (show_id) REFERENCES SHOWS (show_id),
  	CONSTRAINT fk_s_s_d_sd1 FOREIGN KEY (show_description_id) REFERENCES SDESCRIPTIONS (show_description_id)
);

CREATE TABLE EPISODES(
	episode_id NUMBER DEFAULT idepisode_seq.NEXTVAL,
	episode_name VARCHAR2(50) NOT NULL,
	show_id NUMBER NOT NULL,
	PRIMARY KEY (episode_id),
	CONSTRAINT fk_e_s1 FOREIGN KEY (show_id) REFERENCES SHOWS (show_id)
);

CREATE TABLE PARTICIPANTS(
	participant_id NUMBER DEFAULT idparticipant_seq.NEXTVAL,
	participant_name VARCHAR2(50) NOT NULL,
	PRIMARY KEY (participant_id)
);

CREATE TABLE EPISODES_PARTICIPANTS(
	episode_participant_id NUMBER DEFAULT idepisode_participant_seq.NEXTVAL,
	episode_id NUMBER NOT NULL,
	participant_id NUMBER NOT NULL,
	role VARCHAR2(50) NOT NULL,
	start_time TIMESTAMP NOT NULL,
	end_time TIMESTAMP,
	note VARCHAR2(50) DEFAULT NULL,
	PRIMARY KEY (episode_participant_id),
	CONSTRAINT fk_e_p_e1 FOREIGN KEY (episode_id) REFERENCES EPISODES (episode_id),
	CONSTRAINT fk_e_p_p1 FOREIGN KEY (participant_id) REFERENCES PARTICIPANTS (participant_id)
);

CREATE TABLE FEPISODES(
	free_episode_id NUMBER DEFAULT idfepisode_seq.NEXTVAL,
	ads_length_in_min NUMBER NOT NULL,
	episode_id NUMBER NOT NULL,
	PRIMARY KEY (free_episode_id),
	CONSTRAINT fk_f_e_e1 FOREIGN KEY (episode_id) REFERENCES EPISODES (episode_id)
);

CREATE TABLE PEPISODES(
	paid_episode_id NUMBER DEFAULT idpepisode_seq.NEXTVAL,
	premium_charge decimal (5,2) NOT NULL,
	episode_id NUMBER NOT NULL,
	PRIMARY KEY (paid_episode_id),
	CONSTRAINT fk_p_e_e1 FOREIGN KEY (episode_id) REFERENCES EPISODES (episode_id)
);

CREATE TABLE PRATES(
	promotion_rate_id NUMBER DEFAULT idprate_seq.NEXTVAL,
	promotion_rate decimal(5, 2) NOT NULL,
	PRIMARY KEY (promotion_rate_id)
);

CREATE TABLE PEPISODES_PRATES(
	pepisode_prate_id NUMBER DEFAULT idpepisode_prate_seq.NEXTVAL,
	paid_episode_id NUMBER NOT NULL,
	promotion_rate_id NUMBER NOT NULL,
	start_time TIMESTAMP NOT NULL,
	end_time TIMESTAMP,
	note VARCHAR2(50) DEFAULT NULL,
	PRIMARY KEY (pepisode_prate_id),
	CONSTRAINT fk_p_e_p_r_pe1 FOREIGN KEY (paid_episode_id) REFERENCES PEPISODES (paid_episode_id),
	CONSTRAINT fk_p_e_p_r_pr1 FOREIGN KEY (promotion_rate_id) REFERENCES PRATES (promotion_rate_id)
);

--
-- DDL for Altering Tables to Show Deletion
--
ALTER TABLE SHOWS
ADD isShowDeleted VARCHAR2(5) DEFAULT 'FALSE';

ALTER TABLE EPISODES
ADD isEpisodeDeleted VARCHAR2(5) DEFAULT 'FALSE';

ALTER TABLE PEPISODES
ADD isPaidEpisodeDeleted VARCHAR2(5) DEFAULT 'FALSE';

--
-- Create Views
--
CREATE OR REPLACE VIEW SHOW_VIEW AS
SELECT SHOWS.show_id, SHOWS.show_name, SDESCRIPTIONS.show_description, SHOWS.channel_id, SHOWS.category_id
FROM SHOWS
     LEFT JOIN SHOWS_SDESCRIPTIONS
	ON SHOWS.show_id = SHOWS_SDESCRIPTIONS.show_id
     LEFT JOIN SDESCRIPTIONS
	ON SHOWS_SDESCRIPTIONS.show_description_id = SDESCRIPTIONS.show_description_id
	 RIGHT JOIN CHANNELS
	ON SHOWS.channel_id = CHANNELS.channel_id
	 RIGHT JOIN CATEGORIES
	ON SHOWS.category_id = CATEGORIES.category_id
WHERE SHOWS_SDESCRIPTIONS.end_time IS NULL;

CREATE OR REPLACE VIEW EPISODES_VIEW AS
SELECT EPISODES.episode_id, EPISODES.episode_name, PARTICIPANTS.participant_name, EPISODES_PARTICIPANTS.role, EPISODES.show_id
FROM EPISODES
     LEFT JOIN EPISODES_PARTICIPANTS
	ON EPISODES.episode_id = EPISODES_PARTICIPANTS.episode_id
     LEFT JOIN PARTICIPANTS
	ON EPISODES_PARTICIPANTS.participant_id = PARTICIPANTS.participant_id
	 RIGHT JOIN SHOWS
	ON EPISODES.show_id = SHOWS.show_id
WHERE EPISODES_PARTICIPANTS.end_time IS NULL;

CREATE OR REPLACE VIEW PEPISODES_VIEW AS
SELECT PEPISODES.paid_episode_id, PEPISODES.premium_charge ,PRATES.promotion_rate, PEPISODES.episode_id
FROM PEPISODES
     LEFT JOIN PEPISODES_PRATES
	ON PEPISODES.paid_episode_id = PEPISODES_PRATES.paid_episode_id
     LEFT JOIN PRATES
	ON PEPISODES_PRATES.promotion_rate_id = PRATES.promotion_rate_id
	 LEFT JOIN EPISODES
	ON PEPISODES.episode_id = EPISODES.episode_id
WHERE PEPISODES_PRATES.end_time IS NULL;

--
-- Stored Procedures for Use by Triggers
--

-- stored procedure and trigger to update show descriptions related to shows
CREATE OR REPLACE PROCEDURE sp_change_sdescription (idshow IN NUMBER, 
											 sdes IN VARCHAR2 DEFAULT NULL) AS
	var_sdes_seq NUMBER; -- show_description_id (PK) used in TABLE SDESCRIPTIONS
	var_sd_seq NUMBER; -- show_sdescription_id (PK) used in TABLE SHOWS_SDESCRIPTIONS
BEGIN
	UPDATE SHOWS_SDESCRIPTIONS -- set the end time for current show description
		SET end_time = SYSDATE
		WHERE SHOWS_SDESCRIPTIONS.show_id = idshow
		AND end_time IS NULL;
	
	IF sdes IS NOT NULL THEN -- insert / update the show description
		var_sdes_seq := idsdecription_seq.NEXTVAL;
		var_sd_seq := idshow_sdescription_seq.NEXTVAL;
		
		INSERT INTO SDESCRIPTIONS VALUES -- add new description to TABLE SDESCRIPTIONS
			(var_sdes_seq, sdes);
		INSERT INTO SHOWS_SDESCRIPTIONS VALUES -- set the start time for new description
			(var_sd_seq,
			idshow,
			var_sdes_seq,
			SYSDATE, 
			NULL,
			NULL);
	ELSE -- delete the show
		UPDATE SHOWS
		SET isShowDeleted = 'TRUE'
		WHERE SHOWS.show_id = idshow;
	END IF;
END;
/

CREATE OR REPLACE TRIGGER show_trigger
INSTEAD OF INSERT OR UPDATE OR DELETE ON SHOW_VIEW
DECLARE
	var_idshow NUMBER; -- show_id (PK) used in TABLE SHOWS
	var_sname VARCHAR2(50); -- show_name used in TABLE SDESCRIPTIONS
	var_sdes VARCHAR2(50); -- show_description used in TABLE SDESCRIPTIONS
	var_idchannel NUMBER; -- channel_id used in TABLE CHANNELS (PK) and TABLE SHOWS (FK)
	var_idcategory NUMBER; -- category_id used in TABLE CATEGORIES (PK) and TABLE SHOWS (FK)
BEGIN
	IF INSERTING THEN
		var_idshow := idshow_seq.NEXTVAL;
		var_sname := :NEW.show_name;
		var_sdes := :NEW.show_description;
		var_idchannel := :NEW.channel_id;
		var_idcategory := :NEW.category_id;
		INSERT INTO SHOWS (show_id, show_name, channel_id, category_id)
				VALUES (var_idshow, var_sname, var_idchannel, var_idcategory); -- create a new show
	ELSIF DELETING THEN -- show shows as deleted after deleting
		var_idshow := :OLD.show_id;
	ELSIF UPDATING THEN
		var_idshow := :OLD.show_id;
		var_sdes := :NEW.show_description;
	END IF;
	
	sp_change_sdescription (var_idshow, var_sdes);
END;
/

-- stored procedure and trigger to update participants related to episodes
CREATE OR REPLACE PROCEDURE sp_change_eparticipant (idepisode IN NUMBER,
											 role IN VARCHAR2 DEFAULT NULL,
											 pname IN VARCHAR2 DEFAULT NULL) AS
	var_par_seq NUMBER; -- participant_id (PK) used in TABLE PARTICIPANTS
	var_ep_seq NUMBER; -- episode_participant_id (PK) used in TABLE EPISODES_PARTICIPANTS
BEGIN
	UPDATE EPISODES_PARTICIPANTS -- set the end time for current participant
		SET end_time = SYSDATE
		WHERE EPISODES_PARTICIPANTS.episode_id = idepisode
		AND end_time IS NULL;
	
	IF pname IS NOT NULL OR role IS NOT NULL THEN -- insert / update the participant
		var_par_seq := idparticipant_seq.NEXTVAL;
		var_ep_seq := idepisode_participant_seq.NEXTVAL;
		
		INSERT INTO PARTICIPANTS VALUES -- add new participant to TABLE PARTICIPANTS
			(var_par_seq, pname);
		INSERT INTO EPISODES_PARTICIPANTS VALUES -- set the start time for new participant
			(var_ep_seq,
			idepisode,
			var_par_seq,
			role,
			SYSDATE, 
			NULL,
			NULL);
	ELSE -- delete the episode
		UPDATE EPISODES
		SET isEpisodeDeleted = 'TRUE'
		WHERE EPISODES.episode_id = idepisode;
	END IF;
END;
/

CREATE OR REPLACE TRIGGER episode_trigger
INSTEAD OF INSERT OR UPDATE OR DELETE ON EPISODES_VIEW
DECLARE
	var_idepisode NUMBER; -- episode_id (PK) used in TABLE EPISODES
	var_pname VARCHAR2(50); -- participant_name used in TABLE PARTICIPANTS
	var_idshow NUMBER; -- show_id used in TABLE SHOWS (PK) and TABLE EPISODES (FK)
	var_ename VARCHAR2(50); -- episode_name used in TABLE EPISODES
	var_role VARCHAR2(50); -- role used in TABLE EPISODES_PARTICIPANTS
BEGIN
	IF INSERTING THEN
		var_idepisode := idepisode_seq.NEXTVAL;
		var_pname := :NEW.participant_name;
		var_idshow := :NEW.show_id;
		var_ename := :NEW.episode_name;
		var_role := :NEW.role;
		INSERT INTO EPISODES (episode_id, episode_name, show_id)
				VALUES (var_idepisode, var_ename, var_idshow); -- create a new episode
	ELSIF DELETING THEN -- episode shows as deleted after deleting
		var_idepisode := :OLD.episode_id;
	ELSIF UPDATING THEN
		var_idepisode := :OLD.episode_id;
		var_pname := :NEW.participant_name;
		var_role := :NEW.role;
	END IF;
	
	sp_change_eparticipant (var_idepisode, var_role, var_pname);
END;
/

-- stored procedure and trigger to update promotion rates related to paid episodes
CREATE OR REPLACE PROCEDURE sp_change_prate (idpepisode IN NUMBER,
											 prate IN DECIMAL DEFAULT NULL) AS
	var_pr_seq NUMBER; -- promotion_rate_id (PK) used in TABLE PRATES
	var_pp_seq NUMBER; -- pepisode_prate_id (PK) used in TABLE PEPISODES_PRATES
BEGIN
	UPDATE PEPISODES_PRATES -- set the end time for current promotion rate
		SET end_time = SYSDATE
		WHERE PEPISODES_PRATES.paid_episode_id = idpepisode
		AND end_time IS NULL;
	
	IF prate IS NOT NULL THEN -- insert / update the promotion rate
		var_pr_seq := idprate_seq.NEXTVAL;
		var_pp_seq := idpepisode_prate_seq.NEXTVAL;
		
		INSERT INTO PRATES VALUES -- add new promotion rate to TABLE PRATES
			(var_pr_seq, prate);
		INSERT INTO PEPISODES_PRATES VALUES -- set the start time for new promotion rate
			(var_pp_seq,
			idpepisode,
			var_pr_seq,
			SYSDATE, 
			NULL,
			NULL);
	ELSE -- delete the paid episode
		UPDATE PEPISODES
		SET isPaidEpisodeDeleted = 'TRUE'
		WHERE PEPISODES.paid_episode_id = idpepisode;
	END IF;
END;
/

CREATE OR REPLACE TRIGGER pepisode_trigger
INSTEAD OF INSERT OR UPDATE OR DELETE ON PEPISODES_VIEW
DECLARE
	var_idpepisode NUMBER; -- paid_episode_id (PK) used in TABLE PEPISODES
	var_prate decimal(5, 2); -- promotion_rate used in TABLE PRATES
	var_idepisode NUMBER; -- episode_id used in TABLE EPISODES (PK) and TABLE PEPISODES (FK)
	var_pcharge decimal(5, 2); -- premium_charge used in TABLE PEPISODES
BEGIN
	IF INSERTING THEN
		var_idpepisode := idpepisode_seq.NEXTVAL;
		var_prate := :NEW.promotion_rate;
		var_idepisode := :NEW.episode_id;
		var_pcharge := :NEW.premium_charge;
		INSERT INTO PEPISODES (paid_episode_id, premium_charge, episode_id)
				VALUES (var_idpepisode, var_pcharge, var_idepisode); -- create a new paid episode
	ELSIF DELETING THEN -- paid episode shows as deleted after deleting
		var_idpepisode := :OLD.paid_episode_id;
	ELSIF UPDATING THEN
		var_idpepisode := :OLD.paid_episode_id;
		var_prate := :NEW.promotion_rate;
	END IF;
	
	sp_change_prate (var_idpepisode, var_prate);
END;
/

COMMIT;
-- End of File