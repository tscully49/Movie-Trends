DROP SCHEMA IF EXISTS test CASCADE;

CREATE SCHEMA test;
SET search_path = test;

CREATE TABLE movie(
	id serial PRIMARY KEY,
	title varchar(25),
	genre varchar(15),
	year integer,
	rating integer
);

CREATE TABLE actor(
	id serial PRIMARY KEY,
	name varchar(30)
);


CREATE TABLE actor_in_movie(
	actor_id integer REFERENCES actor(id),
	movie_id integer REFERENCES movie(id),
	PRIMARY KEY(actor_id, movie_id)
);


CREATE TABLE director (
	id serial PRIMARY KEY,
	name varchar(25)
);


CREATE TABLE director_of_movie (
	movie_id integer REFERENCES movie(id),
        director_id integer REFERENCES director(id),
	PRIMARY KEY (movie_id, director_id)
);


INSERT INTO movie VALUES (DEFAULT,'A','comedy',2000,8);
INSERT INTO movie VALUES (DEFAULT,'B','action',2001,9);
INSERT INTO movie VALUES (DEFAULT,'C','comedy',2001,7);
INSERT INTO movie VALUES (DEFAULT,'D','comedy',2001,10);
INSERT INTO movie VALUES (DEFAULT,'E','comedy',2000,8); 

INSERT INTO actor VALUES (DEFAULT, 'AA');
INSERT INTO actor VALUES (DEFAULT, 'BB');
INSERT INTO actor VALUES (DEFAULT, 'CC');

INSERT INTO actor_in_movie VALUES (1,2);
INSERT INTO actor_in_movie VALUES (2,3);
INSERT INTO actor_in_movie VALUES (3,2);
INSERT INTO actor_in_movie VALUES (1,3);
INSERT INTO actor_in_movie VALUES (1,1);


INSERT INTO director VALUES (DEFAULT, 'Steven Spielberg');
INSERT INTO director VALUES (DEFAULT, 'Tom');

INSERT INTO director_of_movie VALUES (1,2);
INSERT INTO director_of_movie VALUES (2,1); 



/*query1: allows user to pick a genre, and returns the average rating of 
all the movies with that genre each year in between the selected start year and selected end year to represent its change in popularity*/

SELECT year , avg(rating) FROM rating INNER JOIN movie USING(movie_id) WHERE genre = $1 AND year >= $2 AND year <= $3 GROUP BY year; 

/*query2: Returns the movies that actors have acted in together*/ 
SELECT DISTINCT ON (a1.title) a1.title FROM movie AS a1 INNER JOIN actor_in_movie AS a2 ON (a1.id=a2.movie_id) INNER JOIN actor AS a3 ON (a3.id=a2.actor_id) 
	WHERE a1.id=(
		SELECT table1.movie_id FROM actor_in_movie AS table1, actor_in_movie AS table2 
                	WHERE (table1.actor_id = (SELECT id FROM actor WHERE name = 'AA')) AND (table2.actor_id = (SELECT id FROM actor WHERE name = 'CC')) 
			AND (table1.movie_id=table2.movie_id)
	);


/*query3: Returns the genres of movies that an actor has acted in, along with a count of movies per genre*/
SELECT genre, count(genre) FROM movie AS a1 INNER JOIN actor_in_movie AS a2 ON (a1.id = a2.movie_id) INNER JOIN actor AS a3 ON (a3.id = a2.actor_id) 
	WHERE (a3.name = 'AA') GROUP BY genre; 


/*query4: Returns the average rating of movies for genre an actor has acted in  */
SELECT genre, AVG(rating) FROM movie AS a1 INNER JOIN actor_in_movie AS a2 ON (a1.id = a2.movie_id) INNER JOIN actor AS a3 ON (a3.id = a2.actor_id)
	WHERE (a3.name = 'AA') GROUP BY genre; 
 
/*query5: Returns the movies that an actor and director have worked together on */
CREATE VIEW table1 AS SELECT a1.movie_id AS movie_id1 FROM actor_in_movie AS a1 INNER JOIN actor AS a2 ON (a1.actor_id = a2.id) 
	WHERE (a2.name = 'AA');

CREATE VIEW table2 AS SELECT b1.movie_id AS movie_id2 FROM director_of_movie AS b1 INNER JOIN director AS b2 ON (b1.director_id = b2.id)
	WHERE (b2.name = 'Tom');

SELECT title FROM movie AS co left JOIN table1 ON (co.id = table1.movie_id1) left JOIN table2 ON (co.id = table2.movie_id2) 
	WHERE (table1.movie_id1 = table2.movie_id2);
