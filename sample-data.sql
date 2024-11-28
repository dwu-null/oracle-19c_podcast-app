--
-- Sample data for podcast application database
--

-- Connect as the podcastAppAdmin
CONNECT podcastAdmin/adminPassword;

-- Cleanup table data
DELETE FROM PEPISODES_PRATES;
DELETE FROM PRATES;
DELETE FROM PEPISODES;
DELETE FROM FEPISODES;
DELETE FROM EPISODES_PARTICIPANTS;
DELETE FROM PARTICIPANTS;
DELETE FROM EPISODES;
DELETE FROM SHOWS_SDESCRIPTIONS;
DELETE FROM SDESCRIPTIONS;
DELETE FROM SHOWS;
DELETE FROM CATEGORIES;
DELETE FROM CHANNELS;

-- Reset sequence
ALTER SEQUENCE idchannel_seq RESTART START WITH 100;
ALTER SEQUENCE idcategory_seq RESTART START WITH 100;
ALTER SEQUENCE idshow_seq RESTART START WITH 100;
ALTER SEQUENCE idsdecription_seq RESTART START WITH 100;
ALTER SEQUENCE idshow_sdescription_seq RESTART START WITH 100;
ALTER SEQUENCE idepisode_seq RESTART START WITH 100;
ALTER SEQUENCE idparticipant_seq RESTART START WITH 100;
ALTER SEQUENCE idepisode_participant_seq RESTART START WITH 100;
ALTER SEQUENCE idfepisode_seq RESTART START WITH 100;
ALTER SEQUENCE idpepisode_seq RESTART START WITH 100;
ALTER SEQUENCE idprate_seq RESTART START WITH 100;
ALTER SEQUENCE idpepisode_prate_seq RESTART START WITH 100;

-- Insert sample data into CHANNELS
INSERT INTO CHANNELS (channel_name) VALUES ('News Channel');
INSERT INTO CHANNELS (channel_name) VALUES ('Sports Channel');
INSERT INTO CHANNELS (channel_name) VALUES ('Music Channel');
INSERT INTO CHANNELS (channel_name) VALUES ('Educational Channel');

-- Insert sample data into CATEGORIES
INSERT INTO CATEGORIES (category_name) VALUES ('Interview Podcasts');
INSERT INTO CATEGORIES (category_name) VALUES ('Monologue Podcasts');
INSERT INTO CATEGORIES (category_name) VALUES ('Investigative Podcasts');
INSERT INTO CATEGORIES (category_name) VALUES ('Conversational Podcasts');

-- Insert sample data into SHOWS
INSERT INTO SHOWS (show_name, channel_id, category_id) VALUES ('Tech Insights', 100, 100); 
INSERT INTO SHOWS (show_name, channel_id, category_id) VALUES ('Morning News Roundup', 100, 101); 
INSERT INTO SHOWS (show_name, channel_id, category_id) VALUES ('Sports Recap', 101, 103); 
INSERT INTO SHOWS (show_name, channel_id, category_id) VALUES ('Tech Talks', 101, 102); 
INSERT INTO SHOWS (show_name, channel_id, category_id) VALUES ('Daily News Brief', 102, 101); 
INSERT INTO SHOWS (show_name, channel_id, category_id) VALUES ('Game Highlights', 102, 102); 
INSERT INTO SHOWS (show_name, channel_id, category_id) VALUES ('Music Legends', 103, 102);
INSERT INTO SHOWS (show_name, channel_id, category_id) VALUES ('Behind the Music', 103, 101);

-- Insert sample data into SDESCRIPTIONS
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

-- Insert sample data into SHOWS_SDESCRIPTIONS
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
								
-- Insert sample data into EPISODES
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

-- Insert sample data into PARTICIPANTS
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

-- Insert sample data into EPISODES_PARTICIPANTS
INSERT INTO EPISODES_PARTICIPANTS (episode_id, participant_id, role, start_time, end_time, note) 
							VALUES (100, 100, 'Host', TO_TIMESTAMP('2012-03-05 00:00:00', 'YYYY-MM-DD HH24:MI:SS'), 
									TO_TIMESTAMP('2018-09-12 00:00:00', 'YYYY-MM-DD HH24:MI:SS'), 'Lead discussion');
INSERT INTO EPISODES_PARTICIPANTS (episode_id, participant_id, role, start_time, end_time, note) 
							VALUES (100, 101, 'Host', TO_TIMESTAMP('2018-09-12 00:00:00', 'YYYY-MM-DD HH24:MI:SS'), 
									NULL, 'AI Expert');

INSERT INTO EPISODES_PARTICIPANTS (episode_id, participant_id, role, start_time, end_time, note) 
							VALUES (101, 102, 'Guest', TO_TIMESTAMP('2015-05-15 00:00:00', 'YYYY-MM-DD HH24:MI:SS'), 
									TO_TIMESTAMP('2016-09-13 00:00:00', 'YYYY-MM-DD HH24:MI:SS'), 'Moderates session');
INSERT INTO EPISODES_PARTICIPANTS (episode_id, participant_id, role, start_time, end_time, note) 
							VALUES (101, 103, 'Guest', TO_TIMESTAMP('2016-09-13 00:00:00', 'YYYY-MM-DD HH24:MI:SS'), 
									NULL, 'Blockchain Specialist');

INSERT INTO EPISODES_PARTICIPANTS (episode_id, participant_id, role, start_time, end_time, note) 
							VALUES (102, 104, 'Host', TO_TIMESTAMP('2023-08-20 00:00:00', 'YYYY-MM-DD HH24:MI:SS'), 
									NULL, 'Solo presentation');

INSERT INTO EPISODES_PARTICIPANTS (episode_id, participant_id, role, start_time, end_time, note) 
							VALUES (103, 105, 'Analyst', TO_TIMESTAMP('2011-03-10 00:00:00', 'YYYY-MM-DD HH24:MI:SS'), 
									TO_TIMESTAMP('2019-10-11 00:00:00', 'YYYY-MM-DD HH24:MI:SS'), 'Daily news update');
INSERT INTO EPISODES_PARTICIPANTS (episode_id, participant_id, role, start_time, end_time, note) 
							VALUES (103, 106, 'Analyst', TO_TIMESTAMP('2019-10-11 00:00:00', 'YYYY-MM-DD HH24:MI:SS'), 
									NULL, 'Analysis and insights');

INSERT INTO EPISODES_PARTICIPANTS (episode_id, participant_id, role, start_time, end_time, note)
							VALUES (104, 107, 'Anchor', TO_TIMESTAMP('2017-12-14 00:00:00', 'YYYY-MM-DD HH24:MI:SS'), 
									NULL, 'Breaking news coverage');

INSERT INTO EPISODES_PARTICIPANTS (episode_id, participant_id, role, start_time, end_time, note) 
							VALUES (105, 108, 'Commentator', TO_TIMESTAMP('2009-03-08 00:00:00', 'YYYY-MM-DD HH24:MI:SS'), 
									TO_TIMESTAMP('2011-10-19 00:00:00', 'YYYY-MM-DD HH24:MI:SS'), 'Football highlights');
INSERT INTO EPISODES_PARTICIPANTS (episode_id, participant_id, role, start_time, end_time, note)
							VALUES (105, 109, 'Commentator', TO_TIMESTAMP('2011-10-19 00:00:00', 'YYYY-MM-DD HH24:MI:SS'), 
									NULL, 'In-depth analysis');

INSERT INTO EPISODES_PARTICIPANTS (episode_id, participant_id, role, start_time, end_time, note) 
							VALUES (106, 110, 'Host', TO_TIMESTAMP('2007-04-04 00:00:00', 'YYYY-MM-DD HH24:MI:SS'), 
									TO_TIMESTAMP('2015-10-25 00:00:00', 'YYYY-MM-DD HH24:MI:SS'), 'Presents countdown');
INSERT INTO EPISODES_PARTICIPANTS (episode_id, participant_id, role, start_time, end_time, note)
							VALUES (106, 111, 'Host', TO_TIMESTAMP('2015-10-25 00:00:00', 'YYYY-MM-DD HH24:MI:SS'), 
									NULL, 'Basketball expert');

INSERT INTO EPISODES_PARTICIPANTS (episode_id, participant_id, role, start_time, end_time, note)
							VALUES (107, 112, 'Host', TO_TIMESTAMP('2016-12-21 00:00:00', 'YYYY-MM-DD HH24:MI:SS'), 
									NULL, 'Recap presenter');

INSERT INTO EPISODES_PARTICIPANTS (episode_id, participant_id, role, start_time, end_time, note)
							VALUES (108, 113, 'Instructor', TO_TIMESTAMP('2023-11-21 00:00:00', 'YYYY-MM-DD HH24:MI:SS'), 
									NULL, 'Yoga guide');

INSERT INTO EPISODES_PARTICIPANTS (episode_id, participant_id, role, start_time, end_time, note)
							VALUES (109, 114, 'Nutritionist', TO_TIMESTAMP('2020-05-25 00:00:00', 'YYYY-MM-DD HH24:MI:SS'), 
									NULL, 'Diet advice');

INSERT INTO EPISODES_PARTICIPANTS (episode_id, participant_id, role, start_time, end_time, note)
							VALUES (110, 115, 'Host', TO_TIMESTAMP('2017-09-03 00:00:00', 'YYYY-MM-DD HH24:MI:SS'), 
									NULL, 'Explains classical music history');

INSERT INTO EPISODES_PARTICIPANTS (episode_id, participant_id, role, start_time, end_time, note) 
							VALUES (111, 116, 'Host', TO_TIMESTAMP('2004-03-03 00:00:00', 'YYYY-MM-DD HH24:MI:SS'), 
									TO_TIMESTAMP('2014-02-08 00:00:00', 'YYYY-MM-DD HH24:MI:SS'), 'Discusses jazz origins');
INSERT INTO EPISODES_PARTICIPANTS (episode_id, participant_id, role, start_time, end_time, note)
							VALUES (111, 117, 'Host', TO_TIMESTAMP('2014-02-08 00:00:00', 'YYYY-MM-DD HH24:MI:SS'), 
									NULL, 'Jazz musician');

INSERT INTO EPISODES_PARTICIPANTS (episode_id, participant_id, role, start_time, end_time, note)
							VALUES (112, 118, 'Host', TO_TIMESTAMP('2011-03-01 00:00:00', 'YYYY-MM-DD HH24:MI:SS'), 
									NULL, 'Explores pop hits production');

INSERT INTO EPISODES_PARTICIPANTS (episode_id, participant_id, role, start_time, end_time, note)
							VALUES (113, 119, 'Guest', TO_TIMESTAMP('2002-02-02 00:00:00', 'YYYY-MM-DD HH24:MI:SS'), 
									TO_TIMESTAMP('2010-10-10 00:00:00', 'YYYY-MM-DD HH24:MI:SS'), 'Discusses rock anthems');
INSERT INTO EPISODES_PARTICIPANTS (episode_id, participant_id, role, start_time, end_time, note)
							VALUES (113, 120, 'Guest', TO_TIMESTAMP('2010-10-10 00:00:00', 'YYYY-MM-DD HH24:MI:SS'), 
									NULL, 'Rock music expert');

INSERT INTO EPISODES_PARTICIPANTS (episode_id, participant_id, role, start_time, end_time, note)
							VALUES (114, 121, 'Host', TO_TIMESTAMP('2010-12-12 00:00:00', 'YYYY-MM-DD HH24:MI:SS'), 
									NULL, 'Explains physics concepts');

INSERT INTO EPISODES_PARTICIPANTS (episode_id, participant_id, role, start_time, end_time, note)
							VALUES (115, 122, 'Host', TO_TIMESTAMP('2005-06-03 00:00:00', 'YYYY-MM-DD HH24:MI:SS'), 
									TO_TIMESTAMP('2010-06-03 00:00:00', 'YYYY-MM-DD HH24:MI:SS'), 'Quantum physics discussion');
INSERT INTO EPISODES_PARTICIPANTS (episode_id, participant_id, role, start_time, end_time, note)
							VALUES (115, 123, 'Host', TO_TIMESTAMP('2010-06-03 00:00:00', 'YYYY-MM-DD HH24:MI:SS'), 
									NULL, 'Quantum mechanics researcher');

-- Insert sample data into FEPISODES
INSERT INTO FEPISODES (ads_length_in_min, episode_id) VALUES (5, 100);
INSERT INTO FEPISODES (ads_length_in_min, episode_id) VALUES (3, 103);
INSERT INTO FEPISODES (ads_length_in_min, episode_id) VALUES (6, 106);
INSERT INTO FEPISODES (ads_length_in_min, episode_id) VALUES (4, 108);
INSERT INTO FEPISODES (ads_length_in_min, episode_id) VALUES (8, 111);
INSERT INTO FEPISODES (ads_length_in_min, episode_id) VALUES (7, 114);

-- Insert sample data into PEPISODES
INSERT INTO PEPISODES (premium_charge, episode_id) VALUES (24.56, 101);
INSERT INTO PEPISODES (premium_charge, episode_id) VALUES (32.45, 105);
INSERT INTO PEPISODES (premium_charge, episode_id) VALUES (11.09, 109);
INSERT INTO PEPISODES (premium_charge, episode_id) VALUES (20.00, 113);
INSERT INTO PEPISODES (premium_charge, episode_id) VALUES (19.99, 102);

-- Insert sample data into PRATES
INSERT INTO PRATES (promotion_rate) VALUES (0.10);
INSERT INTO PRATES (promotion_rate) VALUES (0.15);
INSERT INTO PRATES (promotion_rate) VALUES (0.20);
INSERT INTO PRATES (promotion_rate) VALUES (0.25);
INSERT INTO PRATES (promotion_rate) VALUES (0.30);
INSERT INTO PRATES (promotion_rate) VALUES (0.35);
INSERT INTO PRATES (promotion_rate) VALUES (0.40);
INSERT INTO PRATES (promotion_rate) VALUES (0.50);

-- Insert sample data into PEPISODES_PRATES
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

COMMIT;
-- End of File