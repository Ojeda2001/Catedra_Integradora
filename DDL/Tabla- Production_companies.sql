SELECT id,  JSON_KEYS (production_companies, '$[0]'), 	JSON_LENGTH(production_companies) 
FROM movie_dataset_cleaned	;
DROP PROCEDURE IF EXISTS Json2Relational_production_companies;
DELIMITER //

CREATE PROCEDURE Json2Relational_production_companies()
BEGIN
	DECLARE a INT Default 0 ;
DROP TABLE IF EXISTS tmp_production_companies ;
CREATE TABlE tmp_production_companies
	  (id_movie INT,id_production_companies INT, name VARCHAR (200));
simple_loop: LOOP
INSERT INTO tmp_production_companies (id_movie, id_production_companies, name)  
		SELECT id as id_movie, 
			JSON_EXTRACT(CONVERT(production_companies using utf8mb4), CONCAT("$[",a,"].id")) AS id_prodution_companies,
			JSON_EXTRACT(CONVERT(production_companies using utf8mb4), CONCAT("$[",a,"].name")) AS name
			FROM movie_dataset_cleaned m 
            WHERE id IN (SELECT id FROM movie_dataset_cleaned WHERE a <= JSON_LENGTH (production_companies));
        SET a=a+1;	
     	 IF a=6 THEN
            LEAVE simple_loop;
      END IF;
   END LOOP simple_loop;
	 DELETE FROM tmp_production_companies WHERE id_production_companies IS NULL ;	
  END //
DELIMITER ;

Call Json2Relational_production_companies();
ALTER TABLE  tmp_production_companies  ADD Primary Key (id_movie,id_production_companies) ;
EXPLAIN tmp_production_companies