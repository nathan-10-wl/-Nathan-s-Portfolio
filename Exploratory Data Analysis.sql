-- Exploratory Data Analysis 

SELECT *
FROM layoffs_staging2 
;

SELECT MAX(total_laid_off)
FROM layoffs_staging2 ;

ALTER TABLE layoffs_staging2
MODIFY COLUMN total_laid_off int ;

ALTER TABLE layoffs_staging2
MODIFY COLUMN funds_raised_millions int; 

UPDATE layoffs_staging2
SET funds_raised_millions = NULL
WHERE funds_raised_millions = 'None'
OR '';

ALTER TABLE layoffs_staging2
MODIFY COLUMN percentage_laid_off int; 


SELECT MAX(total_laid_off), MAX(percentage_laid_off)
FROM layoffs_staging2 
;

SELECT * 
FROM layoffs_staging2
WHERE percentage_laid_off = 1 
ORDER BY funds_raised_millions DESC
;

SELECT company, SUM(total_laid_off)
FROM layoffs_staging2
GROUP BY company
ORDER BY SUM(total_laid_off) DESC
;

SELECT MIN(`date`), MAX(`date`) 
FROM layoffs_staging2
;

SELECT industry, SUM(total_laid_off)
FROM layoffs_staging2
GROUP BY industry
ORDER BY SUM(total_laid_off) DESC
;

SELECT country, SUM(total_laid_off)
FROM layoffs_staging2
GROUP BY country
ORDER BY 2 DESC 
;

SELECT YEAR(`date`), SUM(total_laid_off)
FROM layoffs_staging2
GROUP BY YEAR(`date`)
ORDER BY 1 DESC
;

SELECT stage, SUM(total_laid_off)
FROM layoffs_staging2
GROUP BY stage
ORDER BY 2 ;

SELECT *
FROM layoffs_staging2; 

SELECT SUBSTRING(`date`, 1, 7) AS `MONTH`, SUM(total_laid_off)
FROM layoffs_staging2
WHERE SUBSTRING(`date`, 1, 7) IS NOT NULL
GROUP BY `MONTH` 
ORDER BY 1
;

SELECT *
FROM layoffs_staging2; 
;
WITH Rolling_total AS 
(
SELECT SUBSTRING(`date`, 1, 7) AS `MONTH`, SUM(total_laid_off) AS total_off
FROM layoffs_staging2
WHERE SUBSTRING(`date`, 1, 7) IS NOT NULL
GROUP BY `MONTH` 
ORDER BY 1
)
SELECT `MONTH`, total_off,
SUM(total_off) OVER(ORDER BY `MONTH`) AS rolling_total
FROM Rolling_total ;

SELECT company, SUM(total_laid_off)
FROM layoffs_staging2
GROUP BY company
ORDER BY 2 DESC 
;

SELECT company, YEAR(`date`),  SUM(total_laid_off)
FROM layoffs_staging2
GROUP BY company, YEAR(`date`)
ORDER BY 3 DESC 
;

WITH Company_Year (company, years, total_laid_off) AS 
(SELECT company, YEAR(`date`), SUM(total_laid_off)
FROM layoffs_staging2
GROUP BY company, YEAR(`date`)
)
SELECT *, dense_rank() OVER(PARTITION BY years ORDER BY total_laid_off DESC) AS Ranking
FROM Company_Year
WHERE years IS NOT NULL 
ORDER BY Ranking ASC 
;

WITH Company_Year (company, years, total_laid_off) AS 
(SELECT company, YEAR(`date`), SUM(total_laid_off)
FROM layoffs_staging2
GROUP BY company, YEAR(`date`)
),
Company_Year_Rank AS 
(
SELECT *, dense_rank() OVER(PARTITION BY years ORDER BY total_laid_off DESC) AS Ranking
FROM Company_Year
WHERE years IS NOT NULL 
)
SELECT * 
FROM Company_Year_Rank
WHERE Ranking <= 5  
;

SELECT * 
FROM layoffs_staging2 ;

SELECT industry, SUM(total_laid_off) AS total_laid_off, YEAR(`date`) AS `Year`
FROM layoffs_staging2 
group by industry, YEAR(`date`)
ORDER BY 2 DESC 
;

SELECT *
FROM layoffs_staging2 
WHERE location = 'London'
;

SELECT company, location, industry, SUM(total_laid_off)
FROM layoffs_staging2 
WHERE location = 'London'
GROUP BY company, location, industry















