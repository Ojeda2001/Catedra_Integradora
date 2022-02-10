SELECT id,  JSON_KEYS (spoken_languages, '$[0]'), 	JSON_LENGTH(spoken_languages) 
FROM movie_dataset_cleaned	;

DROP PROCEDURE IF EXISTS Json2Relational_spoken_languages;
DELIMITER //
CREATE PROCEDURE Json2Relational_spoken_languages()
BEGIN
	DECLARE a INT Default 0 ;
DROP TABLE IF EXISTS tmp_spoken_languages ;
CREATE TABlE tmp_spoken_languages
	  (id_movie INT,name VARCHAR(200) , iso_639_1 VARCHAR (200));
simple_loop: LOOP
INSERT INTO tmp_spoken_languages (id_movie, name , iso_639_1)  
		SELECT id as id_movie, 
			JSON_EXTRACT(CONVERT(spoken_languages using utf8mb4), CONCAT("$[",a,"].name")) AS name,
			JSON_EXTRACT(CONVERT(spoken_languages using utf8mb4), CONCAT("$[",a,"].iso_639_1")) AS acronimo
			FROM movie_dataset_cleaned m 
            WHERE id IN (SELECT id FROM movie_dataset_cleaned WHERE a <= JSON_LENGTH (spoken_languages));
        SET a=a+1;	
     	 IF a=6 THEN
            LEAVE simple_loop;
      END IF;
   END LOOP simple_loop;
	 DELETE FROM tmp_spoken_languages WHERE name IS NULL ;	
  END //
  
DELIMITER ;
Call Json2Relational_spoken_languages();
ALTER TABLE  tmp_spoken_languages  ADD Primary Key (id_movie, iso_639_1) ;
explain tmp_spoken_languages
