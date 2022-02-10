SELECT id, genres, 
	CONCAT('["', REPLACE(REPLACE (genres, ' ', '","'), 'Science","Fiction', 'Science Fiction'), '"]'),
	JSON_VALID(CONCAT('["', REPLACE(REPLACE (genres, ' ', '","'), 'Science","Fiction', 'Science Fiction'), '"]'))
FROM movie_dataset_cleaned ;
-- Borrar si existe una versión anterior (re-crear el procedimiento)
DROP PROCEDURE IF EXISTS Json2Relational_genres ;
DELIMITER //
-- =============================================================================================================
-- Genres **
CREATE PROCEDURE Json2Relational_genres()
BEGIN
	DECLARE a INT Default 0 ;
	
	-- crear tabla temporal para almacenar datos de pdocuction_companies que están en JSON
	DROP TABLE IF EXISTS tmp_genres ;
	CREATE TABlE tmp_genres (id_movie INT, genres VARCHAR (100) );
	
	-- ["Action", "Thriller", "Science", "Fiction", "Adventure"]
	
	-- Aqui hacemos ciclo repetitivo para  poder ir cargando datos desde el arreglo JSON hacia la tabla temporal
  simple_loop: LOOP
-- cargando datos del objeto JSON en la tabla temporal 
		INSERT INTO tmp_genres (id_movie, genres)  
		SELECT id as id_Movie, 
			JSON_EXTRACT(CONCAT('["', REPLACE(REPLACE (genres, ' ', '","'), 'Science","Fiction', 'Science Fiction'), '"]'), CONCAT("$[",a,"]")) AS genre
		FROM movie_dataset_cleaned m ; 
			SET a=a+1;	
     	IF a=6 THEN
            LEAVE simple_loop;
      END IF;
   END LOOP simple_loop;
   -- limpieza de registros nulos
   -- xyz tuplas en tmp_spoken_languages
   DELETE FROM tmp_genres WHERE genres IS NULL ;
   -- xyz tuplas en tmp_spoken_languages
END //
DELIMITER ;
Call Json2Relational_genres();
ALTER TABLE tmp_genres  ADD Primary Key (id_movie,genres) ;
EXPLAIN tmp_genres