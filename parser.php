<?php
$conn = pg_connect('dbhost-pgsql.cs.missouri.edu'." ".'djb8tc'." ".'djb8tc'." ".'vKTwkRSj') or die('Could not connect: ' . pg_last_error());
//Insert genres first
$g_id = 1;
$genres = ['Action', 'Adventure', 'Animation', 'Biography', 'Comedy', 'Crime', 'Documentary', 'Drama', 'Family',
  'Fantasy', 'Film-Noir', 'History', 'Horror', 'Music', 'Musical', 'Mystery', 'Romance', 'Sci-Fi', 'Sport', 
  'Thriller', 'War', 'Western'];
foreach ($genres as $value) {
	pg_query_params('INSERT INTO genre VALUES ($1, $2)', array($g_id, $value)) or die('Query failed: ' . pg_last_error());
}
//Define genre_id array for ease of use later
genre_id = array (
	"Action" => 1,
	"Adventure" => 2,
	"Animation" => 3,
	"Biography" => 4,
	"Comedy" => 5,
	"Crime" => 6,
	"Documentary" => 7,
	"Drama" => 8,
	"Family" => 9,
	"Fantasy" => 10,
	"Film-Noir" => 11,
	"History" => 12,
	"Horror" => 13,
	"Music" => 14,
	"Musical" => 15,
	"Mystery" => 16,
	"Romance" => 17,
	"Sci-Fi" => 18,
	"Sport" => 19,
	"Thriller" => 20,
	"War" => 21,
	"Western" => 22	
);
$i;
$m_id = 1;
//Iterate through each csv file
for ($i = 1980; $i < 2015; ++i) {
	$filepath = sprintf('/BoxOfficeData/%d.csv', i);
	$csv= fopen(filepath, "r");
	while(($data = fgetcsv($csv, 0, ",")) != FALSE) {
		//Pull data from Rotten Tomatoes
		$rtjson = file_get_contents(sprintf('http://api.rottentomatoes.com/api/public/v1.0/movies.json?apikey=bv7gsaaa3f6mgumrq7djbdgf&q=%d&page_limit=1', $data[1]));
		$rt = json_decode($rtjson, true);
		//Pull data from IMDB
		$imdbjson = file_get_contents(sprintf('http://www.omdbapi.com/?t=%d&y=&plot=short&r=json', rt[movies][title]));
		$imdb = json_decode($imdbjson, true);
		//Insert data into movie table
		pg_query_params('INSERT INTO movie VALUES ($1, $2, $3, $4, $5, $6, $7, $8, $9, $10, $11, $12)', array([m_id, rt[movies][title], imdb[Year], 
		rt[movies][mpaa_rating], rt[movies][runtime], rt[movies][release_dates][theater], imdb[plot], $data[3], rt[movies][ratings][critics_score], 
		rt[movies][ratings][audience_score], imdb[Metascore], imdb[imdbRating])) or die('Query failed: ' . pg_last_error());
		//Insert data into movie_genre table
		
	}
}
?>