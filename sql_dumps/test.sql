DROP SCHEMA IF EXISTS test CASCADE;

CREATE SCHEMA test;
SET search_path = test;


CREATE TABLE movie(
	--Stores the movie's name, title, year, and all four rating values
	id serial PRIMARY KEY,
	title varchar(25),
	year integer,
	RT_critic integer,
	RT_audience integer,
	metascore integer,
	imbd float 
);

INSERT INTO movie VALUES (DEFAULT,'A',2000,8, 5, 3, 8.0);
INSERT INTO movie VALUES (DEFAULT,'B',2001,9, 2, 5, 9.0);
INSERT INTO movie VALUES (DEFAULT,'C',2001,7, 7, 9, 9.0);
INSERT INTO movie VALUES (DEFAULT,'D',2001,10, 8, 4, 2.0);
INSERT INTO movie VALUES (DEFAULT,'E',2000,8, 5, 8, 8.0); 


CREATE TABLE genre(
	--stores a genre name
	genre_id serial PRIMARY KEY,
	genre varchar(25)
);

INSERT INTO genre VALUES(DEFAULT, 'comedy');
INSERT INTO genre VALUES(DEFAULT, 'action');
INSERT INTO genre VALUES(DEFAULT, 'horror');


CREATE TABLE movie_genre(
	--stores a movie id, and a genre id that corresponds to that movie
	movie_genre_id serial,
	movie_id integer REFERENCES movie(id),
	genre_id integer REFERENCES genre

);

INSERT INTO movie_genre VALUES(DEFAULT, 1, 1);
INSERT INTO movie_genre VALUES(DEFAULT, 1, 2);
INSERT INTO movie_genre VALUES(DEFAULT, 2, 3);
INSERT INTO movie_genre VALUES(DEFAULT, 2, 2);
INSERT INTO movie_genre VALUES(DEFAULT, 3, 1);

CREATE TABLE actor(
	--stores actor/actress names
	id serial PRIMARY KEY,
	name varchar(30)
);

INSERT INTO actor VALUES (DEFAULT, 'AA');
INSERT INTO actor VALUES (DEFAULT, 'BB');
INSERT INTO actor VALUES (DEFAULT, 'CC');

CREATE TABLE actor_in_movie(
	--stores an actor/actress id and the id of a movie he/she was in
	actor_id integer REFERENCES actor(id),
	movie_id integer REFERENCES movie(id),
	PRIMARY KEY(actor_id, movie_id)
);


INSERT INTO actor_in_movie VALUES (1,2);
INSERT INTO actor_in_movie VALUES (2,3);
INSERT INTO actor_in_movie VALUES (3,2);
INSERT INTO actor_in_movie VALUES (1,3);
INSERT INTO actor_in_movie VALUES (1,1);


CREATE TABLE director (
	--stores dictor names
	id serial PRIMARY KEY,
	name varchar(25)
);

INSERT INTO director VALUES (DEFAULT, 'Steven Spielberg');
INSERT INTO director VALUES (DEFAULT, 'Tom');

CREATE TABLE director_of_movie (
	--stores the id of a director and the id of a movie he/she directed
	movie_id integer REFERENCES movie(id),
    director_id integer REFERENCES director(id),
	PRIMARY KEY (movie_id, director_id)
);

INSERT INTO director_of_movie VALUES (1,2);
INSERT INTO director_of_movie VALUES (2,1); 


--updating queries 

/*query1: allows user to pick a genre, and returns the average rating of 
all the movies with that genre each year in between the selected start year and selected end year to represent its change in popularity*/
/*
SELECT year , avg(rating) FROM rating INNER JOIN movie USING(movie_id) WHERE genre = $1 AND year >= $2 AND year <= $3 GROUP BY year; 
*/
/*query2: Returns the movies that actors have acted in together*/ 
/*
SELECT DISTINCT ON (a1.title) a1.title FROM movie AS a1 INNER JOIN actor_in_movie AS a2 ON (a1.id=a2.movie_id) INNER JOIN actor AS a3 ON (a3.id=a2.actor_id) 
	WHERE a1.id=(
		SELECT table1.movie_id FROM actor_in_movie AS table1, actor_in_movie AS table2 
                	WHERE (table1.actor_id = (SELECT id FROM actor WHERE name = 'AA')) AND (table2.actor_id = (SELECT id FROM actor WHERE name = 'CC')) 
			AND (table1.movie_id=table2.movie_id)
	);

*/
/*query3: Returns the genres of movies that an actor has acted in, along with a count of movies per genre*/
/*
SELECT genre, count(genre) FROM movie AS a1 INNER JOIN actor_in_movie AS a2 ON (a1.id = a2.movie_id) INNER JOIN actor AS a3 ON (a3.id = a2.actor_id) 
	WHERE (a3.name = 'AA') GROUP BY genre; 
*/

/*query4: Returns the average rating of movies for genre an actor has acted in  */
/*
SELECT genre, AVG(rating) FROM movie AS a1 INNER JOIN actor_in_movie AS a2 ON (a1.id = a2.movie_id) INNER JOIN actor AS a3 ON (a3.id = a2.actor_id)
	WHERE (a3.name = 'AA') GROUP BY genre; 
 */
/*query5: Returns the movies that an actor and director have worked together on */
/*
CREATE VIEW table1 AS SELECT a1.movie_id AS movie_id1 FROM actor_in_movie AS a1 INNER JOIN actor AS a2 ON (a1.actor_id = a2.id) 
	WHERE (a2.name = 'AA');

CREATE VIEW table2 AS SELECT b1.movie_id AS movie_id2 FROM director_of_movie AS b1 INNER JOIN director AS b2 ON (b1.director_id = b2.id)
	WHERE (b2.name = 'Tom');

SELECT title FROM movie AS co left JOIN table1 ON (co.id = table1.movie_id1) left JOIN table2 ON (co.id = table2.movie_id2) 
	WHERE (table1.movie_id1 = table2.movie_id2);
*/