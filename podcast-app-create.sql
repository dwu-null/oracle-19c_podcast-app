-- 
-- ORACLE application database and associated users creation script for podcast application
--
-- Created by:  CST2355_24F_group2
--
-- should be run while connected as 'sqlplus / as sysdba'
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

INSERT INTO CHANNELS (channel_name) VALUES ('News Channel');
INSERT INTO CHANNELS (channel_name) VALUES ('Sports Channel');
INSERT INTO CHANNELS (channel_name) VALUES ('Music Channel');
INSERT INTO CHANNELS (channel_name) VALUES ('Educational Channel');


CREATE TABLE CATEGORIES(
	category_id int GENERATED ALWAYS AS IDENTITY (START WITH 1 INCREMENT BY 1) NOT NULL,
	category_name varchar(50) NOT NULL,
	PRIMARY KEY (category_id)
);

INSERT INTO CATEGORIES (category_name) VALUES ('Interview Podcasts');
INSERT INTO CATEGORIES (category_name) VALUES ('Monologue Podcasts');
INSERT INTO CATEGORIES (category_name) VALUES ('Investigative Podcasts');
INSERT INTO CATEGORIES (category_name) VALUES ('Conversational Podcasts');


CREATE TABLE SHOWS(
	show_id int GENERATED ALWAYS AS IDENTITY (START WITH 1 INCREMENT BY 1) NOT NULL,
	show_name varchar(50) NOT NULL,
	channel_id int NOT NULL,
	category_id int NOT NULL,
 	PRIMARY KEY (show_id),
	CONSTRAINT fk_s_ch1 FOREIGN KEY (channel_id) REFERENCES CHANNELS (channel_id),
  	CONSTRAINT fk_s_ca1 FOREIGN KEY (category_id) REFERENCES CATEGORIES (category_id)
);

INSERT INTO SHOWS (show_name, channel_id, category_id) VALUES ('Tech Talks', 1, 1); 
INSERT INTO SHOWS (show_name, channel_id, category_id) VALUES ('Daily News Brief', 1, 2); 
INSERT INTO SHOWS (show_name, channel_id, category_id) VALUES ('Game Highlights', 2, 2); 
INSERT INTO SHOWS (show_name, channel_id, category_id) VALUES ('Health Fitness', 2, 3); 
INSERT INTO SHOWS (show_name, channel_id, category_id) VALUES ('Musical Journey', 3, 2); 
INSERT INTO SHOWS (show_name, channel_id, category_id) VALUES ('Behind the Music', 3, 3); 
INSERT INTO SHOWS (show_name, channel_id, category_id) VALUES ('Science Explained', 4, 3);
INSERT INTO SHOWS (show_name, channel_id, category_id) VALUES ('Healthy Living', 4, 2); 




CREATE TABLE SHOW_NAMES(
	show_name_id int GENERATED ALWAYS AS IDENTITY (START WITH 1 INCREMENT BY 1) NOT NULL,
	show_name varchar(50) NOT NULL,
	PRIMARY KEY (show_name_id)
);

INSERT INTO SHOW_NAMES (show_name) VALUES ('Tech Insights');
INSERT INTO SHOW_NAMES (show_name) VALUES ('Morning News Roundup');
INSERT INTO SHOW_NAMES (show_name) VALUES ('Sports Recap');
INSERT INTO SHOW_NAMES (show_name) VALUES ('Music Legends');



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


-- CREARE A TRIGGER TO UPDATE THE SHOW START TIME AUTOMATICALLY
--https://stackoverflow.com/questions/1614233/is-there-an-automatic-modification-time-stamp-type-for-oracle-columns

create or replace
TRIGGER update_show
BEFORE INSERT ON SHOWS_SHOW_NAMES
FOR EACH ROW
BEGIN
    :new.start_time := SYSTIMESTAMP;
END;
/

INSERT INTO SHOWS_SHOW_NAMES (show_id, show_name_id, end_time, note) 
VALUES (1, 1, TO_DATE('2024-12-01', 'YYYY-MM-DD'), 'Initial airing');

INSERT INTO SHOWS_SHOW_NAMES (show_id, show_name_id, end_time, note) 
VALUES (2, 2, TO_DATE('2024-12-05', 'YYYY-MM-DD'), 'Revised episode');

INSERT INTO SHOWS_SHOW_NAMES (show_id, show_name_id, end_time, note) 
VALUES (3, 3, TO_DATE('2024-12-10', 'YYYY-MM-DD'), 'Special feature');

INSERT INTO SHOWS_SHOW_NAMES (show_id, show_name_id, end_time, note) 
VALUES (4, 4, TO_DATE('2024-12-15', 'YYYY-MM-DD'), 'Anniversary edition');


CREATE TABLE EPISODES(
	episode_id int GENERATED ALWAYS AS IDENTITY (START WITH 1 INCREMENT BY 1) NOT NULL,
	episode_name varchar(50) NOT NULL,
	show_id int NOT NULL,
	PRIMARY KEY (episode_id),
	CONSTRAINT fk_e_s1 FOREIGN KEY (show_id) REFERENCES SHOWS (show_id)
);

INSERT INTO EPISODES (episode_name, show_id) VALUES ('Introduction to AI', 1);
INSERT INTO EPISODES (episode_name, show_id) VALUES ('The Future of Blockchain', 1);
INSERT INTO EPISODES (episode_name, show_id) VALUES ('Tech Innovations in 2024', 1);
INSERT INTO EPISODES (episode_name, show_id) VALUES ('Top Headlines of the Day', 2);
INSERT INTO EPISODES (episode_name, show_id) VALUES ('Breaking News Analysis', 2);
INSERT INTO EPISODES (episode_name, show_id) VALUES ('Highlights from the Football World', 3);
INSERT INTO EPISODES (episode_name, show_id) VALUES ('Top 10 Basketball Moments', 3);
INSERT INTO EPISODES (episode_name, show_id) VALUES ('Cricket Match Recap', 3);
INSERT INTO EPISODES (episode_name, show_id) VALUES ('Morning Yoga Routine', 4);
INSERT INTO EPISODES (episode_name, show_id) VALUES ('Healthy Diet Tips', 4);
INSERT INTO EPISODES (episode_name, show_id) VALUES ('The Story of Classical Music', 5);
INSERT INTO EPISODES (episode_name, show_id) VALUES ('Evolution of Jazz', 5);
INSERT INTO EPISODES (episode_name, show_id) VALUES ('Behind the Scenes of Pop Hits', 6);
INSERT INTO EPISODES (episode_name, show_id) VALUES ('Uncovering Rock Anthems', 6);
INSERT INTO EPISODES (episode_name, show_id) VALUES ('The Physics of Everyday Life', 7);
INSERT INTO EPISODES (episode_name, show_id) VALUES ('Understanding Quantum Mechanics', 7);
INSERT INTO EPISODES (episode_name, show_id) VALUES ('Mental Health Matters', 8);
INSERT INTO EPISODES (episode_name, show_id) VALUES ('The Importance of Sleep', 8);


CREATE TABLE PARTICIPANTS(
	participant_id int GENERATED ALWAYS AS IDENTITY (START WITH 1 INCREMENT BY 1) NOT NULL,
	participant_name varchar(50) NOT NULL,
	PRIMARY KEY (participant_id)
);

-- Participants for Episode 1 (Introduction to AI)
INSERT INTO PARTICIPANTS (participant_name) VALUES ('Alice Johnson');
INSERT INTO PARTICIPANTS (participant_name) VALUES ('Dr. Emily Carter');

-- Participants for Episode 2 (The Future of Blockchain)
INSERT INTO PARTICIPANTS (participant_name) VALUES ('John Doe');
INSERT INTO PARTICIPANTS (participant_name) VALUES ('Sophia Chen');

-- Participants for Episode 3 (Tech Innovations in 2024)
INSERT INTO PARTICIPANTS (participant_name) VALUES ('Michael Brown');

-- Participants for Episode 4 (Top Headlines of the Day)
INSERT INTO PARTICIPANTS (participant_name) VALUES ('Rachel Green');
INSERT INTO PARTICIPANTS (participant_name) VALUES ('David Wilson');

-- Participants for Episode 5 (Breaking News Analysis)
INSERT INTO PARTICIPANTS (participant_name) VALUES ('Chris Johnson');

-- Participants for Episode 6 (Highlights from the Football World)
INSERT INTO PARTICIPANTS (participant_name) VALUES ('James Anderson');
INSERT INTO PARTICIPANTS (participant_name) VALUES ('Sarah White');

-- Participants for Episode 7 (Top 10 Basketball Moments)
INSERT INTO PARTICIPANTS (participant_name) VALUES ('Robert King');
INSERT INTO PARTICIPANTS (participant_name) VALUES ('Emma Taylor');

-- Participants for Episode 8 (Cricket Match Recap)
INSERT INTO PARTICIPANTS (participant_name) VALUES ('Thomas Clark');

-- Participants for Episode 9 (Morning Yoga Routine)
INSERT INTO PARTICIPANTS (participant_name) VALUES ('Olivia Brown');

-- Participants for Episode 10 (Healthy Diet Tips)
INSERT INTO PARTICIPANTS (participant_name) VALUES ('Jessica Moore');

-- Participants for Episode 11 (The Story of Classical Music)
INSERT INTO PARTICIPANTS (participant_name) VALUES ('Liam Hall');

-- Participants for Episode 12 (Evolution of Jazz)
INSERT INTO PARTICIPANTS (participant_name) VALUES ('Benjamin Wright');
INSERT INTO PARTICIPANTS (participant_name) VALUES ('Ella Davis');

-- Participants for Episode 13 (Behind the Scenes of Pop Hits)
INSERT INTO PARTICIPANTS (participant_name) VALUES ('Isabella Martinez');

-- Participants for Episode 14 (Uncovering Rock Anthems)
INSERT INTO PARTICIPANTS (participant_name) VALUES ('William Lee');
INSERT INTO PARTICIPANTS (participant_name) VALUES ('Chloe Adams');

-- Participants for Episode 15 (The Physics of Everyday Life)
INSERT INTO PARTICIPANTS (participant_name) VALUES ('Mason Thompson');

-- Participants for Episode 16 (Understanding Quantum Mechanics)
INSERT INTO PARTICIPANTS (participant_name) VALUES ('Emily Scott');
INSERT INTO PARTICIPANTS (participant_name) VALUES ('Lucas Evans');



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

-- Episode 1 (Introduction to AI)
INSERT INTO EPISODES_PARTICIPANTS (episode_id, participant_id, role, start_time, note) 
VALUES (1, 1, 'Host', SYSDATE, 'Lead discussion');
INSERT INTO EPISODES_PARTICIPANTS (episode_id, participant_id, role, start_time, note) 
VALUES (1, 2, 'Guest', SYSDATE, 'AI Expert');

-- Episode 2 (The Future of Blockchain)
INSERT INTO EPISODES_PARTICIPANTS (episode_id, participant_id, role, start_time, note) 
VALUES (2, 3, 'Host', SYSDATE, 'Moderates session');
INSERT INTO EPISODES_PARTICIPANTS (episode_id, participant_id, role, start_time, note) 
VALUES (2, 4, 'Guest', SYSDATE, 'Blockchain Specialist');

-- Episode 3 (Tech Innovations in 2024)
INSERT INTO EPISODES_PARTICIPANTS (episode_id, participant_id, role, start_time, note) 
VALUES (3, 5, 'Host', SYSDATE, 'Solo presentation');

-- Episode 4 (Top Headlines of the Day)
INSERT INTO EPISODES_PARTICIPANTS (episode_id, participant_id, role, start_time, note) 
VALUES (4, 6, 'Anchor', SYSDATE, 'Daily news update');
INSERT INTO EPISODES_PARTICIPANTS (episode_id, participant_id, role, start_time, note) 
VALUES (4, 7, 'Analyst', SYSDATE, 'Analysis and insights');

-- Episode 5 (Breaking News Analysis)
INSERT INTO EPISODES_PARTICIPANTS (episode_id, participant_id, role, start_time, note) 
VALUES (5, 8, 'Anchor', SYSDATE, 'Breaking news coverage');

-- Episode 6 (Highlights from the Football World)
INSERT INTO EPISODES_PARTICIPANTS (episode_id, participant_id, role, start_time, note) 
VALUES (6, 9, 'Commentator', SYSDATE, 'Football highlights');
INSERT INTO EPISODES_PARTICIPANTS (episode_id, participant_id, role, start_time, note) 
VALUES (6, 10, 'Analyst', SYSDATE, 'In-depth analysis');

-- Episode 7 (Top 10 Basketball Moments)
INSERT INTO EPISODES_PARTICIPANTS (episode_id, participant_id, role, start_time, note) 
VALUES (7, 11, 'Host', SYSDATE, 'Presents countdown');
INSERT INTO EPISODES_PARTICIPANTS (episode_id, participant_id, role, start_time, note) 
VALUES (7, 12, 'Guest', SYSDATE, 'Basketball expert');

-- Episode 8 (Cricket Match Recap)
INSERT INTO EPISODES_PARTICIPANTS (episode_id, participant_id, role, start_time, note) 
VALUES (8, 13, 'Host', SYSDATE, 'Recap presenter');

-- Episode 9 (Morning Yoga Routine)
INSERT INTO EPISODES_PARTICIPANTS (episode_id, participant_id, role, start_time, note) 
VALUES (9, 14, 'Instructor', SYSDATE, 'Yoga guide');

-- Episode 10 (Healthy Diet Tips)
INSERT INTO EPISODES_PARTICIPANTS (episode_id, participant_id, role, start_time, note) 
VALUES (10, 15, 'Nutritionist', SYSDATE, 'Diet advice');

-- Episode 11 (The Story of Classical Music)
INSERT INTO EPISODES_PARTICIPANTS (episode_id, participant_id, role, start_time, note) 
VALUES (11, 16, 'Host', SYSDATE, 'Explains classical music history');

-- Episode 12 (Evolution of Jazz)
INSERT INTO EPISODES_PARTICIPANTS (episode_id, participant_id, role, start_time, note) 
VALUES (12, 17, 'Host', SYSDATE, 'Discusses jazz origins');
INSERT INTO EPISODES_PARTICIPANTS (episode_id, participant_id, role, start_time, note) 
VALUES (12, 18, 'Guest', SYSDATE, 'Jazz musician');

-- Episode 13 (Behind the Scenes of Pop Hits)
INSERT INTO EPISODES_PARTICIPANTS (episode_id, participant_id, role, start_time, note) 
VALUES (13, 19, 'Host', SYSDATE, 'Explores pop hits production');

-- Episode 14 (Uncovering Rock Anthems)
INSERT INTO EPISODES_PARTICIPANTS (episode_id, participant_id, role, start_time, note) 
VALUES (14, 20, 'Host', SYSDATE, 'Discusses rock anthems');
INSERT INTO EPISODES_PARTICIPANTS (episode_id, participant_id, role, start_time, note) 
VALUES (14, 21, 'Guest', SYSDATE, 'Rock music expert');

-- Episode 15 (The Physics of Everyday Life)
INSERT INTO EPISODES_PARTICIPANTS (episode_id, participant_id, role, start_time, note) 
VALUES (15, 22, 'Host', SYSDATE, 'Explains physics concepts');

-- Episode 16 (Understanding Quantum Mechanics)
INSERT INTO EPISODES_PARTICIPANTS (episode_id, participant_id, role, start_time, note) 
VALUES (16, 23, 'Host', SYSDATE, 'Quantum physics discussion');
INSERT INTO EPISODES_PARTICIPANTS (episode_id, participant_id, role, start_time, note) 
VALUES (16, 24, 'Guest', SYSDATE, 'Quantum mechanics researcher');



CREATE TABLE FREE_EPISODES(
	free_episode_id int GENERATED ALWAYS AS IDENTITY (START WITH 1 INCREMENT BY 1) NOT NULL,
	ads_length_in_min int NOT NULL,
	episode_id int NOT NULL,
	PRIMARY KEY (free_episode_id),
	CONSTRAINT fk_f_e_e1 FOREIGN KEY (episode_id) REFERENCES EPISODES (episode_id)
);

-- Episode 1 (Introduction to AI)
INSERT INTO FREE_EPISODES (ads_length_in_min, episode_id) VALUES (5, 1);

-- Episode 4 (Top Headlines of the Day)
INSERT INTO FREE_EPISODES (ads_length_in_min, episode_id) VALUES (3, 4);

-- Episode 7 (Top 10 Basketball Moments)
INSERT INTO FREE_EPISODES (ads_length_in_min, episode_id) VALUES (6, 7);

-- Episode 9 (Morning Yoga Routine)
INSERT INTO FREE_EPISODES (ads_length_in_min, episode_id) VALUES (4, 9);

-- Episode 12 (Evolution of Jazz)
INSERT INTO FREE_EPISODES (ads_length_in_min, episode_id) VALUES (8, 12);

-- Episode 15 (The Physics of Everyday Life)
INSERT INTO FREE_EPISODES (ads_length_in_min, episode_id) VALUES (7, 15);



CREATE TABLE PAID_EPISODES(
	paid_episode_id int GENERATED ALWAYS AS IDENTITY (START WITH 1 INCREMENT BY 1) NOT NULL,
	episode_id int NOT NULL,
	PRIMARY KEY (paid_episode_id),
	CONSTRAINT fk_p_e_e1 FOREIGN KEY (episode_id) REFERENCES EPISODES (episode_id)
);

INSERT INTO PAID_EPISODES (episode_id) VALUES (2);
INSERT INTO PAID_EPISODES (episode_id) VALUES (6);
INSERT INTO PAID_EPISODES (episode_id) VALUES (10);
INSERT INTO PAID_EPISODES (episode_id) VALUES (14);


--CREATE A TRRIGER TO EXAMINE THAT A EPISODE CANNOT BE BOTH FREE AND PAID

CREATE OR REPLACE PROCEDURE sp_checkEpisodeFree(
    episode_id IN VARCHAR2, 
    isvalid OUT BOOLEAN,  
    errormessage OUT VARCHAR2
)
AS
    v_count NUMBER; -- Variable to store the count of matching rows
BEGIN
    -- Check if the episode_id exists in the FREE_EPISODES table
    SELECT COUNT(*)
    INTO v_count
    FROM FREE_EPISODES
    WHERE episode_id = sp_checkEpisodeFree.episode_id;

    -- Decision based on the count
    IF v_count > 0 THEN
        isvalid := FALSE;
        errormessage := 'The episode is a free episode, it can not be in the paid category!';
    ELSE
        isvalid := TRUE;
        errormessage := '';
    END IF;

END;
/

CREATE OR REPLACE TRIGGER checkEpisodeFree
BEFORE INSERT OR UPDATE 
ON PAID_EPISODES
FOR EACH ROW 
DECLARE 
    episode_id  VARCHAR2(50):=:NEW.episode_id;
    isvalid BOOLEAN;  
    errormessage VARCHAR2(500);
BEGIN
  
    sp_checkEpisodeFree( episode_id,isvalid ,errormessage);

    IF NOT isvalid THEN
        RAISE_APPLICATION_ERROR(-20004, errormessage);
    END IF;
END;
/


CREATE TABLE PREMIUM_CHARGES(
	premium_charge_id int GENERATED ALWAYS AS IDENTITY (START WITH 1 INCREMENT BY 1) NOT NULL,
	premium_charge decimal(5, 2) NOT NULL,
	PRIMARY KEY (premium_charge_id)
);

INSERT INTO PREMIUM_CHARGES (premium_charge) VALUES (9.99);
INSERT INTO PREMIUM_CHARGES (premium_charge) VALUES (14.99);
INSERT INTO PREMIUM_CHARGES (premium_charge) VALUES (19.99);
INSERT INTO PREMIUM_CHARGES (premium_charge) VALUES (24.99);


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


-- CREARE A TRIGGER TO UPDATE THE PAID_EPISODES_PREMIUM_CHARGES START TIME AUTOMATICALLY
create or replace
TRIGGER update_paid
BEFORE INSERT ON PAID_EPISODES_PREMIUM_CHARGES
FOR EACH ROW
BEGIN
    :new.start_time := SYSTIMESTAMP;
END;
/


INSERT INTO PAID_EPISODES_PREMIUM_CHARGES (paid_episode_id, premium_charge_id, start_time, note)
VALUES (1, 1, SYSDATE, 'Initial premium rate');

INSERT INTO PAID_EPISODES_PREMIUM_CHARGES (paid_episode_id, premium_charge_id, start_time, note)
VALUES (2, 2, SYSDATE, 'Holiday discount');

INSERT INTO PAID_EPISODES_PREMIUM_CHARGES (paid_episode_id, premium_charge_id, start_time, note)
VALUES (3, 3, SYSDATE, 'Season special rate');

INSERT INTO PAID_EPISODES_PREMIUM_CHARGES (paid_episode_id, premium_charge_id, start_time, note)
VALUES (4, 4, SYSDATE, 'High demand pricing');

--insert sample values into the tables










COMMIT;
-- End of File






