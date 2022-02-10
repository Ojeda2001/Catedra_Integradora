
DROP TABLE IF EXISTS movie_dataset_cleaned ;
CREATE TABLE movie_dataset_cleaned  AS
SELECT 
	`index`, budget, genres, homepage, id, keywords, original_language, original_title, overview, popularity, 
	 production_companies, production_countries, release_date, revenue, runtime, spoken_languages, `status`, 
	 tagline, title, vote_average, vote_count, cast, director,  
	CONVERT(REPLACE(REPLACE(REPLACE(REPLACE(REPLACE(REPLACE(Crew,
	 		"""", "'"), 
	 		"', '", """, """), 
	 		"': '", """: """), 
	 		"': ", """: "), 
	 		", '", ", """), 
	 		"{'", "{""") 
	 	using utf8mb4) AS Crew
		FROM movie_dataset ;
ALTER TABLE movie_dataset_cleaned  ADD Primary Key (id) ;

-- Directors
SELECT id, director
FROM movie_dataset_cleaned;


SELECT * 
FROM tmp_crew 
WHERE name LIKE '%Steve Oedekerk%';

--  PRODUCTO NATURAL  -  Tabla Movie y Personas
SELECT m.id, m.director AS Movie_id, c.*
FROM movie_dataset_cleaned m, crew c 
WHERE m.director = REPLACE(c.name, '"', '') ;

-- LEFT JOIN --  Debe existir una fila de movie, incluso si no hay un match con personas
SELECT m.id, m.director AS Movie_id, c.*
FROM movie_dataset_cleaned m LEFT JOIN tmp_crew c ON m.director = REPLACE(c.name, '"', '') ;

