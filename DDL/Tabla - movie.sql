DROP TABLE IF EXISTS tmp_movie;
-- ============ Tabla movie ====================
CREATE TABLE tmp_movie
SELECT  id, director, original_title, title, runtime, overview, revenue, release_date,homepage,
keywords,status,tagline,popularity,vote_count,vote_average,cast, budget
FROM movie_dataset_cleaned;
ALTER TABLE tmp_movie  ADD Primary Key (id) ;
EXPLAIN tmp_movie