SELECT id,  JSON_KEYS (production_countries, '$[0]'), 	JSON_LENGTH(production_countries) 
FROM movie_dataset_cleaned	;
DROP PROCEDURE IF EXISTS Json2Relational_production_countries;
DELIMITER //
CREATE PROCEDURE Json2Relational_production_countries()
BEGIN
	DECLARE a INT Default 0 ;
DROP TABLE IF EXISTS tmp_production_countries ;
CREATE TABlE tmp_production_countries
	  (id_movie INT,name VARCHAR(200) , iso_3166_1 VARCHAR (200));
simple_loop: LOOP

INSERT INTO tmp_production_countries (id_movie, name , iso_3166_1)  
		SELECT id as id_movie, 
			JSON_EXTRACT(CONVERT(production_countries using utf8mb4), CONCAT("$[",a,"].name")) AS name,
			JSON_EXTRACT(CONVERT(production_countries using utf8mb4), CONCAT("$[",a,"].iso_3166_1")) AS acronimo
			FROM movie_dataset_cleaned m 
            WHERE id IN (SELECT id FROM movie_dataset_cleaned WHERE a <= JSON_LENGTH (production_countries));
        SET a=a+1;	
     	 IF a=6 THEN
            LEAVE simple_loop;
            
      END IF;
   END LOOP simple_loop;
	 DELETE FROM tmp_production_countries WHERE name IS NULL ;	
  END //
DELIMITER ;
Call Json2Relational_production_countries();
ALTER TABLE  tmp_production_countries  ADD Primary Key (id_movie,iso_3166_1) ;
EXPLAIN tmp_production_countries