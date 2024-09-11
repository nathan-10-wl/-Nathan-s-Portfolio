-- Data Cleaning Project 
-- Remove Duplicates 
-- Standardize the Data
-- Null Values or Blank Values 
--  Remove any Columns/Rows 

SELECT *
FROM layoffs;
 
-- Makign a Staging Database 

CREATE TABLE layoffs_staging
LIKE layoffs ;

SELECT *
FROM layoffs_staging ;

INSERT layoffs_staging 
SELECT *
FROM layoffs ;

SELECT *
FROM layoffs_staging ;

-- Removing Duplicates 

SELECT *
FROM layoffs_staging ;

SELECT *,
ROW_NUMBER() OVER(
PARTITION BY company, industry, total_laid_off, percentage_laid_off, `date`) AS row_num
FROM layoffs_staging ;

WITH duplicate_cte AS
(SELECT *,
ROW_NUMBER() OVER(
PARTITION BY company, industry, total_laid_off, percentage_laid_off, `date`) AS row_num
FROM layoffs_staging
)
SELECT * 
FROM duplicate_cte 
WHERE row_num > 1 ;

SELECT *
FROM layoffs_staging
WHERE company = 'Oda' ;

-- Do all categories to insure no false duplicates

-- Identifying duplicates

 WITH duplicate_cte AS 
 (SELECT * ,
 ROW_NUMBER() OVER (
 PARTITION BY company, location, industry, total_laid_off, percentage_laid_off, `date`, stage, country, funds_raised_millions) AS row_num
 FROM layoffs_staging
 )
 SELECT * 
 FROM duplicate_cte
 WHERE row_num > 1 
 ;
 
SELECT *
FROM layoffs_staging
WHERE company = 'yahoo' ;

-- deleting duplicates

CREATE TABLE `layoffs_staging2` (
  `company` text,
  `location` text,
  `industry` text,
  `total_laid_off` text,
  `percentage_laid_off` text,
  `date` text,
  `stage` text,
  `country` text,
  `funds_raised_millions` text, 
  `row_num` INT
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;

SELECT *
FROM layoffs_staging2 ; 

INSERT INTO layoffs_staging2
 (SELECT * ,
 ROW_NUMBER() OVER (
 PARTITION BY company, location, industry, total_laid_off, percentage_laid_off, `date`, stage, country, funds_raised_millions) AS row_num
 FROM layoffs_staging
 )
;

SELECT * 
FROM layoffs_staging2 
WHERE row_num > 1 
;

DELETE
FROM layoffs_staging2 
WHERE row_num > 1 
; 

SELECT * 
FROM layoffs_staging2 
WHERE row_num > 1 
;

-- Standardizing data 

SELECT * 
FROM layoffs_staging2 ;

SELECT company, TRIM(company) 
FROM layoffs_staging2 
;

UPDATE layoffs_staging2 
SET company = TRIM(company) ;


SELECT DISTINCT industry 
FROM layoffs_staging2
ORDER by 1
;

SELECT * 
FROM layoffs_staging2 
WHERE industry LIKE '%crypto%'
;

UPDATE layoffs_staging2
SET industry = 'Crypto'
WHERE industry LIKE '%crypto%' 
;

SELECT DISTINCT country
FROM layoffs_staging2 
ORDER BY country
;

SELECT DISTINCT *
FROM layoffs_staging2 
WHERE country LIKE 'United States%'
order by 1
;

SELECT DISTINCT country, TRIM(TRAILING '.' FROM country)
FROM layoffs_staging2
ORDER BY 1
;

UPDATE layoffs_staging2
SET country = TRIM(TRAILING '.' FROM country)
;

SELECT `date`, 
str_to_date(`date`, '%m/%d/%Y')
FROM layoffs_staging2 
;

UPDATE layoffs_staging2
SET `date` = str_to_date(`date`, '%m/%d/%Y');

ALTER TABLE layoffs_staging2
MODIFY COLUMN `date` DATE ;

SELECT * 
FROM layoffs_staging2
WHERE `date`  = 'None' 
;

UPDATE layoffs_staging2
SET `date` = null
WHERE `date` = 'None'
;

SELECT * 
FROM layoffs_staging2
;

-- Null and Blank Values 

SELECT *
FROM layoffs_staging2
WHERE company like 'Bally%' ;

SELECT * 
FROM layoffs_staging2
WHERE industry = 'None'
;

UPDATE layoffs_staging2
SET industry = null
WHERE industry = 'None'
;

SELECT *
FROM layoffs_staging2 
WHERE industry IS NULL
OR industry = '' ;

SELECT *
FROM layoffs_staging2 
WHERE company = 'Airbnb' ;

UPDATE layoffs_staging2
SET industry = NULL 
WHERE industry = ''
;

SELECT *
FROM layoffs_staging2 AS t1
JOIN layoffs_staging2 AS t2
	ON t1.company = t2.company
WHERE (t1.industry IS NULL)
AND t2.industry IS NOT NULL 
;

UPDATE layoffs_staging2 t1 
JOIN layoffs_staging2 t2
	ON t1.company = t2.company
SET t1.industry = t2.industry 
WHERE t1.industry IS NULL
AND t2.industry IS NOT NULL 
;

SELECT *
FROM layoffs_staging2 
WHERE industry IS NULL
OR industry = '' ;

SELECT * 
FROM layoffs_staging2 
WHERE company LIKE 'bally%' 
;

SELECT DISTINCT industry 
FROM layoffs_staging2 
;

SELECT * 
FROM layoffs_staging2
;

UPDATE layoffs_staging2
SET total_laid_off = NULL 
WHERE total_laid_off = 'None'
;

UPDATE layoffs_staging2
SET percentage_laid_off = NULL 
WHERE percentage_laid_off = 'None'
;


--  Deleting Rows   
 
SELECT * 
FROM layoffs_staging2
WHERE total_laid_off IS NULL 
AND percentage_laid_off IS NULL 
;

DELETE 
FROM layoffs_staging2 
WHERE total_laid_off IS NULL 
AND percentage_laid_off IS NULL 
;

SELECT * 
FROM layoffs_staging2 ;

ALTER TABLE layoffs_staging2
DROP COLUMN row_num 