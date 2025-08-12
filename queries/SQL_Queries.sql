ALTER TABLE `possible-coast-463614-i9.raw_yellowtrips.trips` 
ADD COLUMN source_file STRING;

SELECT * FROM `possible-coast-463614-i9.raw_yellowtrips.trips` LIMIT 100;


SELECT COUNT(*) FROM `possible-coast-463614-i9.raw_yellowtrips.trips`;

SELECT DISTINCT source_file FROM `possible-coast-463614-i9.raw_yellowtrips.trips`;

UPDATE `possible-coast-463614-i9.raw_yellowtrips.trips`
SET source_file = 'yellow_tripdata_2022-01.parquet'
WHERE source_file IS NULL;


SELECT * FROM `possible-coast-463614-i9.raw_yellowtrips.trips` LIMIT 100;

SELECT DISTINCT source_file FROM `possible-coast-463614-i9.raw_yellowtrips.trips`;