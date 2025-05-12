ALTER TABLE nyc_crime_data.crime_records
ADD COLUMN IF NOT EXISTS year INT64,
ADD COLUMN IF NOT EXISTS month INT64,
ADD COLUMN IF NOT EXISTS weekday STRING,
ADD COLUMN IF NOT EXISTS hour INT64;

UPDATE nyc_crime_data.crime_records
SET
  year = EXTRACT(YEAR FROM cmplnt_fr_dt),
  month = EXTRACT(MONTH FROM cmplnt_fr_dt),
  weekday = FORMAT_DATE('%A', DATE(cmplnt_fr_dt)),
  hour = EXTRACT(HOUR FROM cmplnt_fr_tm)
WHERE year IS NULL OR month IS NULL OR weekday IS NULL OR hour IS NULL;

DELETE FROM nyc_crime_data.crime_records
WHERE EXTRACT(YEAR FROM cmplnt_fr_dt) < 1900
   OR EXTRACT(YEAR FROM cmplnt_fr_dt) > EXTRACT(YEAR FROM CURRENT_DATE());


DELETE FROM nyc_crime_data.crime_records
WHERE cmplnt_num IS NULL
   OR cmplnt_fr_dt IS NULL
   OR law_cat_cd IS NULL
   OR boro_nm IS NULL;


DELETE FROM nyc_crime_data.crime_records
WHERE latitude IS NULL OR longitude IS NULL
   OR latitude NOT BETWEEN 40.0 AND 41.0
   OR longitude NOT BETWEEN -75.0 AND -73.0;


SELECT MIN(year) AS start_year, MAX(year) AS end_year
FROM nyc_crime_data.crime_records;
  

SELECT
  latitude,
  longitude,
  CONCAT(CAST(latitude AS STRING), ",", CAST(longitude AS STRING)) AS lat_lon_string
FROM
  `nyc_crime_data.crime_records`
WHERE
  latitude IS NOT NULL
  AND longitude IS NOT NULL
  AND latitude != 0
  AND longitude != 0
LIMIT 100;


CREATE OR REPLACE TABLE `nyc_crime_data.crime_records` AS
SELECT *,
  
  -- Cleaned Victim Sex
  CASE 
    WHEN vic_sex = 'M' THEN 'Male'
    WHEN vic_sex = 'F' THEN 'Female'
    WHEN vic_sex = 'U' THEN 'Unknown'
    ELSE 'Other'
  END AS clean_vic_sex,

  -- Cleaned Suspect Sex
  CASE 
    WHEN susp_sex = 'M' THEN 'Male'
    WHEN susp_sex = 'F' THEN 'Female'
    WHEN susp_sex = 'U' THEN 'Unknown'
    ELSE 'Other'
  END AS clean_susp_sex,

  -- Cleaned Victim Race
  CASE 
    WHEN LOWER(vic_race) LIKE '%white%' THEN 'White'
    WHEN LOWER(vic_race) LIKE '%black%' THEN 'Black'
    WHEN LOWER(vic_race) LIKE '%asian%' THEN 'Asian'
    WHEN LOWER(vic_race) LIKE '%hispanic%' THEN 'Hispanic'
    WHEN LOWER(vic_race) LIKE '%native%' THEN 'Native American'
    WHEN LOWER(vic_race) LIKE '%other%' THEN 'Other'
    ELSE 'Unknown'
  END AS clean_vic_race,

  -- Cleaned Suspect Race
  CASE 
    WHEN LOWER(susp_race) LIKE '%white%' THEN 'White'
    WHEN LOWER(susp_race) LIKE '%black%' THEN 'Black'
    WHEN LOWER(susp_race) LIKE '%asian%' THEN 'Asian'
    WHEN LOWER(susp_race) LIKE '%hispanic%' THEN 'Hispanic'
    WHEN LOWER(susp_race) LIKE '%native%' THEN 'Native American'
    WHEN LOWER(susp_race) LIKE '%other%' THEN 'Other'
    ELSE 'Unknown'
  END AS clean_susp_race,

  -- Cleaned Victim Age Group
  CASE 
    WHEN vic_age_group IN ('<18', '18-24', '25-44', '45-64', '65+') THEN vic_age_group
    ELSE 'Unknown'
  END AS clean_vic_age_group,

  -- Cleaned Suspect Age Group
  CASE 
    WHEN susp_age_group IN ('<18', '18-24', '25-44', '45-64', '65+') THEN susp_age_group
    ELSE 'Unknown'
  END AS clean_susp_age_group

FROM
nyc_crime_data.crime_records
WHERE
  vic_sex IN ('M', 'F', 'U') AND
  susp_sex IN ('M', 'F', 'U') AND
  vic_age_group IS NOT NULL AND
  susp_age_group IS NOT NULL AND
  TRIM(vic_age_group) != '' AND
  TRIM(susp_age_group) != '';

