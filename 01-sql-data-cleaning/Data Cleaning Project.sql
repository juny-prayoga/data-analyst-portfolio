-- DATA CLEANING

SELECT * 
FROM layoffs lr ;

-- 1. Delete Duplicate if exists
-- 2. Standardize the data
-- 3. Null Values or Blank Values
-- 4. Remove any columns

CREATE TABLE layoffs_staging
LIKE layoffs;

SELECT *
FROM layoffs_staging;

INSERT layoffs_staging
SELECT *
FROM layoffs;

SELECT *, ROW_NUMBER() OVER(
PARTITION BY company, industry, total_laid_off, percentage_laid_off, 'date', stage, country, funds_raised_millions) row_num
FROM layoffs_staging ls 
;

WITH duplicate_cte AS
(
	SELECT *, ROW_NUMBER() OVER(
	PARTITION BY company, location, industry, total_laid_off, percentage_laid_off, date, stage, country, funds_raised_millions) row_num
	FROM layoffs_staging ls 
)
SELECT *
FROM duplicate_cte
WHERE row_num > 1
;

SELECT *
FROM layoffs_staging ls 
WHERE company = 'Casper';

CREATE TABLE `layoffs_staging2` (
  `company` varchar(50) DEFAULT NULL,
  `location` varchar(50) DEFAULT NULL,
  `industry` varchar(50) DEFAULT NULL,
  `total_laid_off` varchar(50) DEFAULT NULL,
  `percentage_laid_off` varchar(50) DEFAULT NULL,
  `date` varchar(50) DEFAULT NULL,
  `stage` varchar(50) DEFAULT NULL,
  `country` varchar(50) DEFAULT NULL,
  `funds_raised_millions` varchar(50) DEFAULT NULL,
  `row_num` INT
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

SELECT *
FROM layoffs_staging2;

INSERT layoffs_staging2
SELECT *, ROW_NUMBER() OVER(
	PARTITION BY company, location, industry, total_laid_off, percentage_laid_off, date, stage, country, funds_raised_millions) row_num
	FROM layoffs_staging ls;
	
DELETE 
FROM layoffs_staging2
WHERE row_num > 1
;

SELECT *
FROM layoffs_staging2 ls
WHERE row_num > 1
;


-- STANDARDIZING DATA

SELECT * 
FROM layoffs_staging2 ls ;

SELECT DISTINCT company
FROM layoffs_staging2 ls;

SELECT DISTINCT company, TRIM(company)
FROM layoffs_staging2 ls;

UPDATE layoffs_staging2 
SET company = TRIM(company);

SELECT DISTINCT industry
FROM layoffs_staging2 ls;

SELECT * 
FROM layoffs_staging2 ls 
WHERE industry LIKE 'Crypto%';

UPDATE layoffs_staging2 
SET industry = 'Crypto'
WHERE industry LIKE 'Crypto%';

SELECT DISTINCT location
FROM layoffs_staging2 ls
ORDER BY 1;

SELECT DISTINCT country
FROM layoffs_staging2 ls
ORDER BY 1;

SELECT *
FROM layoffs_staging2 ls 
WHERE country LIKE 'United States%';

SELECT DISTINCT country, TRIM(TRAILING '.' FROM country)
FROM layoffs_staging2 ls;

UPDATE layoffs_staging2 
SET country = TRIM(TRAILING '.' FROM country)
WHERE country LIKE 'United States%';

SELECT date, STR_TO_DATE(date, '%m/%d/%Y')
FROM layoffs_staging2 ls;

UPDATE layoffs_staging2 
SET date = NULL 
WHERE date = 'NULL';

UPDATE layoffs_staging2 
SET date = STR_TO_DATE(date, '%m/%d/%Y');

ALTER TABLE layoffs_staging2 
MODIFY COLUMN date DATE;

ALTER TABLE layoffs_staging2
MODIFY COLUMN total_laid_off INT;

ALTER TABLE layoffs_staging2 
MODIFY COLUMN percentage_laid_off FLOAT;

ALTER TABLE layoffs_staging2 
MODIFY COLUMN funds_raised_millions FLOAT;

-- NULL OR BLANK VALUES

SELECT DISTINCT industry
FROM layoffs_staging2 ls ;

SELECT *
FROM layoffs_staging2 ls 
WHERE industry IS NULL
OR industry = '';

UPDATE layoffs_staging2 
SET industry = NULL
WHERE industry = 'NULL';

UPDATE layoffs_staging2 
SET industry = NULL
WHERE industry = '';

SELECT funds_raised_millions 
FROM layoffs_staging2 ls 
WHERE funds_raised_millions = 'NULL';

UPDATE layoffs_staging2
SET funds_raised_millions = NULL
WHERE funds_raised_millions = 'NULL';

SELECT *
FROM layoffs_staging2 ls 
WHERE company = 'Airbnb';

SELECT t1.industry, t2.industry 
FROM layoffs_staging2 t1
JOIN layoffs_staging2 t2
	ON t1.company = t2.company 
WHERE t1.industry IS NULL
AND t2.industry IS NOT NULL;

UPDATE layoffs_staging2 t1
JOIN layoffs_staging2 t2
	ON t1.company = t2.company
SET t1.industry = t2.industry 
WHERE t1.industry IS NULL
AND t2.industry IS NOT NULL;

SELECT *
FROM layoffs_staging2 ls 
WHERE industry IS NULL
OR industry = '';

SELECT *
FROM layoffs_staging2 ls 
WHERE company LIKE 'Bally%';

SELECT *
FROM layoffs_staging2 ls 
WHERE percentage_laid_off IS NULL
OR percentage_laid_off = ''
OR percentage_laid_off = 'NULL';

UPDATE layoffs_staging2 
SET percentage_laid_off = NULL 
WHERE percentage_laid_off = 'NULL';

-- untuk NULL VALUES di bagian percentage_laid_off dan total_laid_off tidak bisa di populasikan
-- kecuali jika kita memliki 1 kolom lagi seperti total employe
-- maka bisa kita populasikan untuk kedua kolom tersebut

-- REMOVE ANY COLUMNS

SELECT *
FROM layoffs_staging2 ls 
WHERE total_laid_off IS NULL
AND percentage_laid_off IS NULL;

DELETE 
FROM layoffs_staging2
WHERE total_laid_off IS NULL
AND percentage_laid_off IS NULL;

-- karena data tidak bisa dipopulasikan maka data yang total_laid_off dan percentage_laid_offnya kosong dihapus

SELECT *
FROM layoffs_staging2;

ALTER TABLE layoffs_staging2 
DROP COLUMN row_num;