-- 
-- ORACLE application database and associated users creation script for podcast application
--
-- Created by:  CST2355_24F_group2
--
-- should be run while connected as 'sys as sysdba'
--

-- Cleanup for podcast-app

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

GRANT applicationAdmin TO podcastAdmin;
GRANT applicationUser TO podcastUser;

-- Connect as the podcastAppAdmin and create the stored procedures, tables, and triggers

CONNECT podcastAdmin/adminPassword;

--
-- Stored procedures for use by triggers
--

--
-- DDL for Tables
--
CREATE TABLE CHANNELS(
	channel_id int GENERATED ALWAYS AS IDENTITY (START WITH 1 INCREMENT BY 1) NOT NULL,
	channel_name varchar(50) NOT NULL,
	PRIMARY KEY (channel_id)
);

CREATE TABLE CATEGORIES(
	category_id int GENERATED ALWAYS AS IDENTITY (START WITH 1 INCREMENT BY 1) NOT NULL,
	category_name varchar(50) NOT NULL,
	PRIMARY KEY (category_id)
);

CREATE TABLE SHOWS(
	show_id int GENERATED ALWAYS AS IDENTITY (START WITH 1 INCREMENT BY 1) NOT NULL,
	show_name varchar(50) NOT NULL,
	channel_id int NOT NULL,
	category_id int NOT NULL,
 	PRIMARY KEY (show_id),
	CONSTRAINT fk_s_ch1 FOREIGN KEY (channel_id) REFERENCES CHANNELS (channel_id),
  	CONSTRAINT fk_s_ca1 FOREIGN KEY (category_id) REFERENCES CATEGORIES (category_id)
);

CREATE TABLE SHOW_NAMES(
	show_name_id int GENERATED ALWAYS AS IDENTITY (START WITH 1 INCREMENT BY 1) NOT NULL,
	show_name varchar(50) NOT NULL,
	PRIMARY KEY (show_name_id)
);

CREATE TABLE SHOWS_SHOW_NAMES(
	show_id int NOT NULL,
	show_name_id int NOT NULL,
	start_time date NOT NULL,
	end_time date,
	note varchar(50),
 	PRIMARY KEY (show_id, show_name_id),
	CONSTRAINT fk_s_s_n_s1 FOREIGN KEY (show_id) REFERENCES SHOWS (show_id),
  	CONSTRAINT fk_s_s_n_sn1 FOREIGN KEY (show_name_id) REFERENCES SHOW_NAMES (show_name_id)
);

CREATE TABLE EPISODES(
	episode_id int GENERATED ALWAYS AS IDENTITY (START WITH 1 INCREMENT BY 1) NOT NULL,
	episode_name varchar(50) NOT NULL,
	show_id int NOT NULL,
	PRIMARY KEY (episode_id),
	CONSTRAINT fk_e_s1 FOREIGN KEY (show_id) REFERENCES SHOWS (show_id)
);

CREATE TABLE PARTICIPANTS(
	participant_id int GENERATED ALWAYS AS IDENTITY (START WITH 1 INCREMENT BY 1) NOT NULL,
	participant_name varchar(50) NOT NULL,
	PRIMARY KEY (participant_id)
);

CREATE TABLE EPISODES_PARTICIPANTS(
	episode_id int NOT NULL,
	participant_id int NOT NULL,
	role varchar(50) NOT NULL,
	start_time date NOT NULL,
	end_time date,
	note varchar(50),
	PRIMARY KEY (episode_id, participant_id),
	CONSTRAINT fk_e_p_e1 FOREIGN KEY (episode_id) REFERENCES EPISODES (episode_id),
	CONSTRAINT fk_e_p_p1 FOREIGN KEY (participant_id) REFERENCES PARTICIPANTS (participant_id)
);

CREATE TABLE FREE_EPISODES(
	free_episode_id int GENERATED ALWAYS AS IDENTITY (START WITH 1 INCREMENT BY 1) NOT NULL,
	ads_length_in_min int NOT NULL,
	episode_id int NOT NULL,
	PRIMARY KEY (free_episode_id),
	CONSTRAINT fk_f_e_e1 FOREIGN KEY (episode_id) REFERENCES EPISODES (episode_id)
);

CREATE TABLE PAID_EPISODES(
	paid_episode_id int GENERATED ALWAYS AS IDENTITY (START WITH 1 INCREMENT BY 1) NOT NULL,
	episode_id int NOT NULL,
	PRIMARY KEY (paid_episode_id),
	CONSTRAINT fk_p_e_e1 FOREIGN KEY (episode_id) REFERENCES EPISODES (episode_id)
);

CREATE TABLE PREMIUM_CHARGES(
	premium_charge_id int GENERATED ALWAYS AS IDENTITY (START WITH 1 INCREMENT BY 1) NOT NULL,
	premium_charge decimal(5, 2) NOT NULL,
	PRIMARY KEY (premium_charge_id)
);

CREATE TABLE PAID_EPISODES_PREMIUM_CHARGES(
	paid_episode_id int NOT NULL,
	premium_charge_id int NOT NULL,
	start_time date NOT NULL,
	end_time date,
	note varchar(50),
	PRIMARY KEY (paid_episode_id, premium_charge_id),
	CONSTRAINT fk_p_e_p_c_pe1 FOREIGN KEY (paid_episode_id) REFERENCES PAID_EPISODES (paid_episode_id),
	CONSTRAINT fk_p_e_p_c_pc1 FOREIGN KEY (premium_charge_id) REFERENCES PREMIUM_CHARGES (premium_charge_id)
);


COMMIT;
-- End of File