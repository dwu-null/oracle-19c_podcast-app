-- 
-- ORACLE application database and associated users creation script for podcast application
--
-- Created by:  CST2355_24F_group2
--
-- should be run while connected as 'sys as sysdba'
--

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

INSERT INTO CHANNELS (channel_name) VALUES ('News Channel');
INSERT INTO CHANNELS (channel_name) VALUES ('Sports Channel');
INSERT INTO CHANNELS (channel_name) VALUES ('Music Channel');
INSERT INTO CHANNELS (channel_name) VALUES ('Educational Channel');

CREATE TABLE CATEGORIES(
	category_id NUMBER DEFAULT idcategory_seq.NEXTVAL,
	category_name VARCHAR2(50) NOT NULL,
	PRIMARY KEY (category_id)
);

INSERT INTO CATEGORIES (category_name) VALUES ('Interview Podcasts');
INSERT INTO CATEGORIES (category_name) VALUES ('Monologue Podcasts');
INSERT INTO CATEGORIES (category_name) VALUES ('Investigative Podcasts');
INSERT INTO CATEGORIES (category_name) VALUES ('Conversational Podcasts');

CREATE TABLE SHOWS(
	show_id NUMBER DEFAULT idshow_seq.NEXTVAL,
	show_name VARCHAR2(50) NOT NULL,
	channel_id NUMBER NOT NULL,
	category_id NUMBER NOT NULL,
 	PRIMARY KEY (show_id),
	CONSTRAINT fk_s_ch1 FOREIGN KEY (channel_id) REFERENCES CHANNELS (channel_id),
  	CONSTRAINT fk_s_ca1 FOREIGN KEY (category_id) REFERENCES CATEGORIES (category_id)
);

INSERT INTO SHOWS (show_name, channel_id, category_id) VALUES ('Tech Insights', 100, 100); 
INSERT INTO SHOWS (show_name, channel_id, category_id) VALUES ('Morning News Roundup', 100, 101); 
INSERT INTO SHOWS (show_name, channel_id, category_id) VALUES ('Sports Recap', 101, 103); 
INSERT INTO SHOWS (show_name, channel_id, category_id) VALUES ('Tech Talks', 101, 102); 
INSERT INTO SHOWS (show_name, channel_id, category_id) VALUES ('Daily News Brief', 102, 101); 
INSERT INTO SHOWS (show_name, channel_id, category_id) VALUES ('Game Highlights', 102, 102); 
INSERT INTO SHOWS (show_name, channel_id, category_id) VALUES ('Music Legends', 103, 102);
INSERT INTO SHOWS (show_name, channel_id, category_id) VALUES ('Behind the Music', 103, 101); 

CREATE TABLE SDESCRIPTIONS(
	show_description_id NUMBER DEFAULT idsdecription_seq.NEXTVAL,
	show_description VARCHAR2(50) NOT NULL,
	PRIMARY KEY (show_description_id)
);

INSERT INTO SDESCRIPTIONS (show_description) VALUES ('Exploring history is untold stories.');
INSERT INTO SDESCRIPTIONS (show_description) VALUES ('Decoding the world of technology and innovation.');
INSERT INTO SDESCRIPTIONS (show_description) VALUES ('Quick tips for a balanced and mindful life.');
INSERT INTO SDESCRIPTIONS (show_description) VALUES ('Chilling true crime stories, one case at a time.');
INSERT INTO SDESCRIPTIONS (show_description) VALUES ('Breaking down science into everyday language.');
INSERT INTO SDESCRIPTIONS (show_description) VALUES ('Inspiration for artists, writers, and dreamers.');
INSERT INTO SDESCRIPTIONS (show_description) VALUES ('Profiles of people redefining success.');
INSERT INTO SDESCRIPTIONS (show_description) VALUES ('Stories and cultures from around the globe.');
INSERT INTO SDESCRIPTIONS (show_description) VALUES ('Your guide to physical and mental well-being.');
INSERT INTO SDESCRIPTIONS (show_description) VALUES ('Simple strategies to grow your money and mindset.');
INSERT INTO SDESCRIPTIONS (show_description) VALUES ('Short, thrilling stories for your imagination.');
INSERT INTO SDESCRIPTIONS (show_description) VALUES ('A backstage look at podcast creation and trends.');

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

INSERT INTO SHOWS_SDESCRIPTIONS (show_id, show_description_id, start_time, end_time, note) 
VALUES (100, 100, TO_TIMESTAMP('2000-01-01 00:00:00', 'YYYY-MM-DD HH24:MI:SS'), 
				TO_TIMESTAMP('2010-09-17 00:00:00', 'YYYY-MM-DD HH24:MI:SS'), 'Initial airing');

INSERT INTO SHOWS_SDESCRIPTIONS (show_id, show_description_id, start_time, end_time, note) 
VALUES (100, 111, TO_TIMESTAMP('2010-09-17 00:00:00', 'YYYY-MM-DD HH24:MI:SS'), 
				NULL, 'Rename');

INSERT INTO SHOWS_SDESCRIPTIONS (show_id, show_description_id, start_time, end_time, note) 
VALUES (101, 104, TO_TIMESTAMP('2011-12-21 00:00:00', 'YYYY-MM-DD HH24:MI:SS'), 
				NULL, 'Initial airing');

INSERT INTO SHOWS_SDESCRIPTIONS (show_id, show_description_id, start_time, end_time, note) 
VALUES (107, 103, TO_TIMESTAMP('2008-01-31 00:00:00', 'YYYY-MM-DD HH24:MI:SS'), 
				TO_TIMESTAMP('2009-05-23 00:00:00', 'YYYY-MM-DD HH24:MI:SS'), 'Initial airing');

INSERT INTO SHOWS_SDESCRIPTIONS (show_id, show_description_id, start_time, end_time, note) 
VALUES (107, 101, TO_TIMESTAMP('2009-05-23 00:00:00', 'YYYY-MM-DD HH24:MI:SS'), 
				TO_TIMESTAMP('2015-04-28 00:00:00', 'YYYY-MM-DD HH24:MI:SS'), 'Updating');

INSERT INTO SHOWS_SDESCRIPTIONS (show_id, show_description_id, start_time, end_time, note) 
VALUES (107, 108, TO_TIMESTAMP('2015-04-28 00:00:00', 'YYYY-MM-DD HH24:MI:SS'), 
				NULL, 'Rebranding');
				
INSERT INTO SHOWS_SDESCRIPTIONS (show_id, show_description_id, start_time, end_time, note) 
VALUES (103, 105, TO_TIMESTAMP('2015-03-27 00:00:00', 'YYYY-MM-DD HH24:MI:SS'), 
				NULL, 'Initial airing');

INSERT INTO SHOWS_SDESCRIPTIONS (show_id, show_description_id, start_time, end_time, note) 
VALUES (104, 102, TO_TIMESTAMP('2002-02-02 00:00:00', 'YYYY-MM-DD HH24:MI:SS'), 
				NULL, 'Initial airing');

INSERT INTO SHOWS_SDESCRIPTIONS (show_id, show_description_id, start_time, end_time, note) 
VALUES (102, 106, TO_TIMESTAMP('2011-03-03 00:00:00', 'YYYY-MM-DD HH24:MI:SS'), 
				NULL, 'Initial airing');
				
INSERT INTO SHOWS_SDESCRIPTIONS (show_id, show_description_id, start_time, end_time, note) 
VALUES (106, 107, TO_TIMESTAMP('2010-11-20 00:00:00', 'YYYY-MM-DD HH24:MI:SS'), 
				TO_TIMESTAMP('2015-10-01 00:00:00', 'YYYY-MM-DD HH24:MI:SS'), 'Initial airing');

INSERT INTO SHOWS_SDESCRIPTIONS (show_id, show_description_id, start_time, end_time, note) 
VALUES (106, 109, TO_TIMESTAMP('2015-10-01 00:00:00', 'YYYY-MM-DD HH24:MI:SS'), 
				NULL, 'Renaming');

INSERT INTO SHOWS_SDESCRIPTIONS (show_id, show_description_id, start_time, end_time, note) 
VALUES (105, 110, TO_TIMESTAMP('2020-03-01 00:00:00', 'YYYY-MM-DD HH24:MI:SS'), 
				NULL, 'Initial airing');

CREATE TABLE EPISODES(
	episode_id NUMBER DEFAULT idepisode_seq.NEXTVAL,
	episode_name VARCHAR2(50) NOT NULL,
	show_id NUMBER NOT NULL,
	PRIMARY KEY (episode_id),
	CONSTRAINT fk_e_s1 FOREIGN KEY (show_id) REFERENCES SHOWS (show_id)
);

INSERT INTO EPISODES (episode_name, show_id) VALUES ('Introduction to AI', 100);
INSERT INTO EPISODES (episode_name, show_id) VALUES ('The Future of Blockchain', 100);
INSERT INTO EPISODES (episode_name, show_id) VALUES ('Tech Innovations in 2024', 100);
INSERT INTO EPISODES (episode_name, show_id) VALUES ('Top Headlines of the Day', 101);
INSERT INTO EPISODES (episode_name, show_id) VALUES ('Breaking News Analysis', 101);
INSERT INTO EPISODES (episode_name, show_id) VALUES ('Highlights from the Football World', 102);
INSERT INTO EPISODES (episode_name, show_id) VALUES ('Top 10 Basketball Moments', 102);
INSERT INTO EPISODES (episode_name, show_id) VALUES ('Cricket Match Recap', 102);
INSERT INTO EPISODES (episode_name, show_id) VALUES ('Morning Yoga Routine', 103);
INSERT INTO EPISODES (episode_name, show_id) VALUES ('Healthy Diet Tips', 103);
INSERT INTO EPISODES (episode_name, show_id) VALUES ('The Story of Classical Music', 104);
INSERT INTO EPISODES (episode_name, show_id) VALUES ('Evolution of Jazz', 104);
INSERT INTO EPISODES (episode_name, show_id) VALUES ('Behind the Scenes of Pop Hits', 105);
INSERT INTO EPISODES (episode_name, show_id) VALUES ('Uncovering Rock Anthems', 105);
INSERT INTO EPISODES (episode_name, show_id) VALUES ('The Physics of Everyday Life', 106);
INSERT INTO EPISODES (episode_name, show_id) VALUES ('Understanding Quantum Mechanics', 106);
INSERT INTO EPISODES (episode_name, show_id) VALUES ('Mental Health Matters', 107);
INSERT INTO EPISODES (episode_name, show_id) VALUES ('The Importance of Sleep', 107);

CREATE TABLE PARTICIPANTS(
	participant_id NUMBER DEFAULT idparticipant_seq.NEXTVAL,
	participant_name VARCHAR2(50) NOT NULL,
	PRIMARY KEY (participant_id)
);

INSERT INTO PARTICIPANTS (participant_name) VALUES ('Alice Johnson');
INSERT INTO PARTICIPANTS (participant_name) VALUES ('Dr. Emily Carter');
INSERT INTO PARTICIPANTS (participant_name) VALUES ('John Doe');
INSERT INTO PARTICIPANTS (participant_name) VALUES ('Sophia Chen');
INSERT INTO PARTICIPANTS (participant_name) VALUES ('Michael Brown');
INSERT INTO PARTICIPANTS (participant_name) VALUES ('Rachel Green');
INSERT INTO PARTICIPANTS (participant_name) VALUES ('David Wilson');
INSERT INTO PARTICIPANTS (participant_name) VALUES ('Chris Johnson');
INSERT INTO PARTICIPANTS (participant_name) VALUES ('James Anderson');
INSERT INTO PARTICIPANTS (participant_name) VALUES ('Sarah White');
INSERT INTO PARTICIPANTS (participant_name) VALUES ('Robert King');
INSERT INTO PARTICIPANTS (participant_name) VALUES ('Emma Taylor');
INSERT INTO PARTICIPANTS (participant_name) VALUES ('Thomas Clark');
INSERT INTO PARTICIPANTS (participant_name) VALUES ('Olivia Brown');
INSERT INTO PARTICIPANTS (participant_name) VALUES ('Jessica Moore');
INSERT INTO PARTICIPANTS (participant_name) VALUES ('Liam Hall');
INSERT INTO PARTICIPANTS (participant_name) VALUES ('Benjamin Wright');
INSERT INTO PARTICIPANTS (participant_name) VALUES ('Ella Davis');
INSERT INTO PARTICIPANTS (participant_name) VALUES ('Isabella Martinez');
INSERT INTO PARTICIPANTS (participant_name) VALUES ('William Lee');
INSERT INTO PARTICIPANTS (participant_name) VALUES ('Chloe Adams');
INSERT INTO PARTICIPANTS (participant_name) VALUES ('Mason Thompson');
INSERT INTO PARTICIPANTS (participant_name) VALUES ('Emily Scott');
INSERT INTO PARTICIPANTS (participant_name) VALUES ('Lucas Evans');

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


INSERT INTO EPISODES_PARTICIPANTS (episode_id, participant_id, role, start_time, end_time, note) 
VALUES (100, 100, 'Host', TO_TIMESTAMP('2012-03-05 00:00:00', 'YYYY-MM-DD HH24:MI:SS'), 
							TO_TIMESTAMP('2018-09-12 00:00:00', 'YYYY-MM-DD HH24:MI:SS'), 'Lead discussion');
INSERT INTO EPISODES_PARTICIPANTS (episode_id, participant_id, role, start_time, end_time, note) 
VALUES (100, 101, 'Host', TO_TIMESTAMP('2018-09-12 00:00:00', 'YYYY-MM-DD HH24:MI:SS'), NULL, 'AI Expert');


INSERT INTO EPISODES_PARTICIPANTS (episode_id, participant_id, role, start_time, end_time, note) 
VALUES (101, 102, 'Guest', TO_TIMESTAMP('2015-05-15 00:00:00', 'YYYY-MM-DD HH24:MI:SS'), 
							TO_TIMESTAMP('2016-09-13 00:00:00', 'YYYY-MM-DD HH24:MI:SS'), 'Moderates session');
INSERT INTO EPISODES_PARTICIPANTS (episode_id, participant_id, role, start_time, end_time, note) 
VALUES (101, 103, 'Guest', TO_TIMESTAMP('2016-09-13 00:00:00', 'YYYY-MM-DD HH24:MI:SS'), NULL, 'Blockchain Specialist');


INSERT INTO EPISODES_PARTICIPANTS (episode_id, participant_id, role, start_time, end_time, note) 
VALUES (102, 104, 'Host', TO_TIMESTAMP('2023-08-20 00:00:00', 'YYYY-MM-DD HH24:MI:SS'), NULL, 'Solo presentation');


INSERT INTO EPISODES_PARTICIPANTS (episode_id, participant_id, role, start_time, end_time, note) 
VALUES (103, 105, 'Analyst', TO_TIMESTAMP('2011-03-10 00:00:00', 'YYYY-MM-DD HH24:MI:SS'), 
							TO_TIMESTAMP('2019-10-11 00:00:00', 'YYYY-MM-DD HH24:MI:SS'), 'Daily news update');
INSERT INTO EPISODES_PARTICIPANTS (episode_id, participant_id, role, start_time, end_time, note) 
VALUES (103, 106, 'Analyst', TO_TIMESTAMP('2019-10-11 00:00:00', 'YYYY-MM-DD HH24:MI:SS'), NULL, 'Analysis and insights');


INSERT INTO EPISODES_PARTICIPANTS (episode_id, participant_id, role, start_time, end_time, note)
VALUES (104, 107, 'Anchor', TO_TIMESTAMP('2017-12-14 00:00:00', 'YYYY-MM-DD HH24:MI:SS'), NULL, 'Breaking news coverage');


INSERT INTO EPISODES_PARTICIPANTS (episode_id, participant_id, role, start_time, end_time, note) 
VALUES (105, 108, 'Commentator', TO_TIMESTAMP('2009-03-08 00:00:00', 'YYYY-MM-DD HH24:MI:SS'), 
							TO_TIMESTAMP('2011-10-19 00:00:00', 'YYYY-MM-DD HH24:MI:SS'), 'Football highlights');
INSERT INTO EPISODES_PARTICIPANTS (episode_id, participant_id, role, start_time, end_time, note)
VALUES (105, 109, 'Commentator', TO_TIMESTAMP('2011-10-19 00:00:00', 'YYYY-MM-DD HH24:MI:SS'), NULL, 'In-depth analysis');


INSERT INTO EPISODES_PARTICIPANTS (episode_id, participant_id, role, start_time, end_time, note) 
VALUES (106, 110, 'Host', TO_TIMESTAMP('2007-04-04 00:00:00', 'YYYY-MM-DD HH24:MI:SS'), 
							TO_TIMESTAMP('2015-10-25 00:00:00', 'YYYY-MM-DD HH24:MI:SS'), 'Presents countdown');
INSERT INTO EPISODES_PARTICIPANTS (episode_id, participant_id, role, start_time, end_time, note)
VALUES (106, 111, 'Host', TO_TIMESTAMP('2015-10-25 00:00:00', 'YYYY-MM-DD HH24:MI:SS'), NULL, 'Basketball expert');


INSERT INTO EPISODES_PARTICIPANTS (episode_id, participant_id, role, start_time, end_time, note)
VALUES (107, 112, 'Host', TO_TIMESTAMP('2016-12-21 00:00:00', 'YYYY-MM-DD HH24:MI:SS'), NULL, 'Recap presenter');


INSERT INTO EPISODES_PARTICIPANTS (episode_id, participant_id, role, start_time, end_time, note)
VALUES (108, 113, 'Instructor', TO_TIMESTAMP('2023-11-21 00:00:00', 'YYYY-MM-DD HH24:MI:SS'), NULL, 'Yoga guide');


INSERT INTO EPISODES_PARTICIPANTS (episode_id, participant_id, role, start_time, end_time, note)
VALUES (109, 114, 'Nutritionist', TO_TIMESTAMP('2020-05-25 00:00:00', 'YYYY-MM-DD HH24:MI:SS'), NULL, 'Diet advice');


INSERT INTO EPISODES_PARTICIPANTS (episode_id, participant_id, role, start_time, end_time, note)
VALUES (110, 115, 'Host', TO_TIMESTAMP('2017-09-03 00:00:00', 'YYYY-MM-DD HH24:MI:SS'), NULL, 'Explains classical music history');


INSERT INTO EPISODES_PARTICIPANTS (episode_id, participant_id, role, start_time, end_time, note) 
VALUES (111, 116, 'Host', TO_TIMESTAMP('2004-03-03 00:00:00', 'YYYY-MM-DD HH24:MI:SS'), 
							TO_TIMESTAMP('2014-02-08 00:00:00', 'YYYY-MM-DD HH24:MI:SS'), 'Discusses jazz origins');
INSERT INTO EPISODES_PARTICIPANTS (episode_id, participant_id, role, start_time, end_time, note)
VALUES (111, 117, 'Host', TO_TIMESTAMP('2014-02-08 00:00:00', 'YYYY-MM-DD HH24:MI:SS'), NULL, 'Jazz musician');


INSERT INTO EPISODES_PARTICIPANTS (episode_id, participant_id, role, start_time, end_time, note)
VALUES (112, 118, 'Host', TO_TIMESTAMP('2011-03-01 00:00:00', 'YYYY-MM-DD HH24:MI:SS'), NULL, 'Explores pop hits production');


INSERT INTO EPISODES_PARTICIPANTS (episode_id, participant_id, role, start_time, end_time, note)
VALUES (113, 119, 'Guest', TO_TIMESTAMP('2002-02-02 00:00:00', 'YYYY-MM-DD HH24:MI:SS'), 
							TO_TIMESTAMP('2010-10-10 00:00:00', 'YYYY-MM-DD HH24:MI:SS'), 'Discusses rock anthems');
INSERT INTO EPISODES_PARTICIPANTS (episode_id, participant_id, role, start_time, end_time, note)
VALUES (113, 120, 'Guest', TO_TIMESTAMP('2010-10-10 00:00:00', 'YYYY-MM-DD HH24:MI:SS'), NULL, 'Rock music expert');


INSERT INTO EPISODES_PARTICIPANTS (episode_id, participant_id, role, start_time, end_time, note)
VALUES (114, 121, 'Host', TO_TIMESTAMP('2010-12-12 00:00:00', 'YYYY-MM-DD HH24:MI:SS'), NULL, 'Explains physics concepts');


INSERT INTO EPISODES_PARTICIPANTS (episode_id, participant_id, role, start_time, end_time, note)
VALUES (115, 122, 'Host', TO_TIMESTAMP('2005-06-03 00:00:00', 'YYYY-MM-DD HH24:MI:SS'), 
							TO_TIMESTAMP('2010-06-03 00:00:00', 'YYYY-MM-DD HH24:MI:SS'), 'Quantum physics discussion');
INSERT INTO EPISODES_PARTICIPANTS (episode_id, participant_id, role, start_time, end_time, note)
VALUES (115, 123, 'Host', TO_TIMESTAMP('2010-06-03 00:00:00', 'YYYY-MM-DD HH24:MI:SS'), NULL, 'Quantum mechanics researcher');

CREATE TABLE FEPISODES(
	free_episode_id NUMBER DEFAULT idfepisode_seq.NEXTVAL,
	ads_length_in_min NUMBER NOT NULL,
	episode_id NUMBER NOT NULL,
	PRIMARY KEY (free_episode_id),
	CONSTRAINT fk_f_e_e1 FOREIGN KEY (episode_id) REFERENCES EPISODES (episode_id)
);

INSERT INTO FEPISODES (ads_length_in_min, episode_id) VALUES (5, 100);
INSERT INTO FEPISODES (ads_length_in_min, episode_id) VALUES (3, 103);
INSERT INTO FEPISODES (ads_length_in_min, episode_id) VALUES (6, 106);
INSERT INTO FEPISODES (ads_length_in_min, episode_id) VALUES (4, 108);
INSERT INTO FEPISODES (ads_length_in_min, episode_id) VALUES (8, 111);
INSERT INTO FEPISODES (ads_length_in_min, episode_id) VALUES (7, 114);

CREATE TABLE PEPISODES(
	paid_episode_id NUMBER DEFAULT idpepisode_seq.NEXTVAL,
	premium_charge decimal (5,2) NOT NULL,
	episode_id NUMBER NOT NULL,
	PRIMARY KEY (paid_episode_id),
	CONSTRAINT fk_p_e_e1 FOREIGN KEY (episode_id) REFERENCES EPISODES (episode_id)
);

INSERT INTO PEPISODES (premium_charge, episode_id) VALUES (24.56, 101);
INSERT INTO PEPISODES (premium_charge, episode_id) VALUES (32.45, 105);
INSERT INTO PEPISODES (premium_charge, episode_id) VALUES (11.09, 109);
INSERT INTO PEPISODES (premium_charge, episode_id) VALUES (20.00, 113);
INSERT INTO PEPISODES (premium_charge, episode_id) VALUES (19.99, 102);

CREATE TABLE PRATES(
	promotion_rate_id NUMBER DEFAULT idprate_seq.NEXTVAL,
	promotion_rate decimal(5, 2) NOT NULL,
	PRIMARY KEY (promotion_rate_id)
);

INSERT INTO PRATES (promotion_rate) VALUES (0.10);
INSERT INTO PRATES (promotion_rate) VALUES (0.15);
INSERT INTO PRATES (promotion_rate) VALUES (0.20);
INSERT INTO PRATES (promotion_rate) VALUES (0.25);
INSERT INTO PRATES (promotion_rate) VALUES (0.30);
INSERT INTO PRATES (promotion_rate) VALUES (0.35);
INSERT INTO PRATES (promotion_rate) VALUES (0.40);
INSERT INTO PRATES (promotion_rate) VALUES (0.50);

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

INSERT INTO PEPISODES_PRATES (paid_episode_id, promotion_rate_id, start_time, end_time) VALUES 
			(100, 100, TO_TIMESTAMP('2022-10-11 00:00:00', 'YYYY-MM-DD HH24:MI:SS'), 
						TO_TIMESTAMP('2023-06-01 00:00:00', 'YYYY-MM-DD HH24:MI:SS'));
INSERT INTO PEPISODES_PRATES (paid_episode_id, promotion_rate_id, start_time, end_time) VALUES 
			(100, 102, TO_TIMESTAMP('2023-06-01 00:00:00', 'YYYY-MM-DD HH24:MI:SS'), 
						TO_TIMESTAMP('2024-03-03 00:00:00', 'YYYY-MM-DD HH24:MI:SS'));
INSERT INTO PEPISODES_PRATES (paid_episode_id, promotion_rate_id, start_time, end_time) VALUES 
			(100, 104, TO_TIMESTAMP('2024-03-03 00:00:00', 'YYYY-MM-DD HH24:MI:SS'), NULL);

INSERT INTO PEPISODES_PRATES (paid_episode_id, promotion_rate_id, start_time, end_time) VALUES 
			(101, 101, TO_TIMESTAMP('2021-02-22 00:00:00', 'YYYY-MM-DD HH24:MI:SS'), 
						TO_TIMESTAMP('2024-01-11 00:00:00', 'YYYY-MM-DD HH24:MI:SS'));
INSERT INTO PEPISODES_PRATES (paid_episode_id, promotion_rate_id, start_time, end_time) VALUES 
			(101, 103, TO_TIMESTAMP('2024-01-11 00:00:00', 'YYYY-MM-DD HH24:MI:SS'), NULL);

INSERT INTO PEPISODES_PRATES (paid_episode_id, promotion_rate_id, start_time, end_time) VALUES 
			(102, 102, TO_TIMESTAMP('2023-07-08 00:00:00', 'YYYY-MM-DD HH24:MI:SS'), 
						TO_TIMESTAMP('2023-12-20 00:00:00', 'YYYY-MM-DD HH24:MI:SS'));
INSERT INTO PEPISODES_PRATES (paid_episode_id, promotion_rate_id, start_time, end_time) VALUES 
			(102, 104, TO_TIMESTAMP('2023-12-20 00:00:00', 'YYYY-MM-DD HH24:MI:SS'), NULL);

INSERT INTO PEPISODES_PRATES (paid_episode_id, promotion_rate_id, start_time, end_time) VALUES 
			(103, 105, TO_TIMESTAMP('2023-04-06 00:00:00', 'YYYY-MM-DD HH24:MI:SS'), 
						TO_TIMESTAMP('2023-12-31 00:00:00', 'YYYY-MM-DD HH24:MI:SS'));
INSERT INTO PEPISODES_PRATES (paid_episode_id, promotion_rate_id, start_time, end_time) VALUES 
			(103, 101, TO_TIMESTAMP('2023-12-31 00:00:00', 'YYYY-MM-DD HH24:MI:SS'), NULL);

INSERT INTO PEPISODES_PRATES (paid_episode_id, promotion_rate_id, start_time, end_time) VALUES 
			(104, 104, TO_TIMESTAMP('2023-03-15 00:00:00', 'YYYY-MM-DD HH24:MI:SS'), 
						TO_TIMESTAMP('2024-03-15 00:00:00', 'YYYY-MM-DD HH24:MI:SS'));
INSERT INTO PEPISODES_PRATES (paid_episode_id, promotion_rate_id, start_time, end_time) VALUES 
			(104, 100, TO_TIMESTAMP('2024-03-15 00:00:00', 'YYYY-MM-DD HH24:MI:SS'), NULL);


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
-- Create views
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
-- Stored procedures for use by triggers
--
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
	ELSIF DELETING THEN -- no show exist after deleting
		var_idshow := :OLD.show_id;
	ELSIF UPDATING THEN
		var_idshow := :OLD.show_id;
		var_sdes := :NEW.show_description;
	END IF;
	
	sp_change_sdescription (var_idshow, var_sdes);
END;
/

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
	ELSIF DELETING THEN -- no episode exist after deleting
		var_idepisode := :OLD.episode_id;
	ELSIF UPDATING THEN
		var_idepisode := :OLD.episode_id;
		var_pname := :NEW.participant_name;
		var_role := :NEW.role;
	END IF;
	
	sp_change_eparticipant (var_idepisode, var_role, var_pname);
END;
/

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
	ELSIF DELETING THEN -- no paid episode exist after deleting
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