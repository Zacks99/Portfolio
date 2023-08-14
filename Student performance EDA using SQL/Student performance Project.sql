CREATE DATABASE  STUDENT_PERFORMANCE ;

-- INICIAL EXPLORATION 

SELECT *
FROM studentsperformance 
LIMIT 10 ;

SELECT COUNT(*) FROM studentsperformance;
DESCRIBE studentsperformance ;

-- DATA CLEANNING 

-- RENAME THE COLUMNS 
ALTER TABLE studentsperformance 
RENAME COLUMN `race/ethnicity` TO race_ethnicity ,
RENAME COLUMN `parental level of education` TO parental_level_of_education,
RENAME COLUMN `math score` TO math_score ,
RENAME  COLUMN `reading score` TO reading_score ,
RENAME COLUMN `writing score` TO writing_score ;

SELECT *FROM studentsperformance
WHERE gender IS NULL OR race_ethnicity IS NULL OR parental_level_of_education IS NULL
OR LUNCH IS NULL OR test_preparation_course IS NULL OR math_score IS NULL OR reading_score IS NULL
OR writing_score IS NULL ;

-- THERE IS NO NULL DATA 

-- STATISTICAL SUMMURY 

-- CREATE THE TOP PERFORMERS STUDENT 

ALTER TABLE studentsperformance
ADD COLUMN total_score INT ;

select*from studentsperformance;

SET SQL_SAFE_UPDATES = 0;
update studentsperformance 
set total_score=math_score+reading_score+writing_score ;

select gender ,test_preparation_course, total_score from studentsperformance 
order by total_score desc ;

-- COUNT OF STUDENT MORE THAN AVG 

SELECT GENDER ,
COUNT(DISTINCT race_ethnicity) AS COUNT_OF_RACES FROM studentsperformance
group by 1 ;

-- FILTERING DATA 
select gender from studentsperformance
where gender="female"
order by total_score desc;

-- count of how manny male and female are in each group 

select gender , race_ethnicity,count(race_ethnicity)
from studentsperformance 
group by gender,race_ethnicity
order by 1,2 ;

-- satistical data 

select gender, avg(total_score) as avg_total_score 
from studentsperformance 
group by gender ;

-- we can see that the avg total score in females are higher than males 

-- AVERAGE SCORES FOR EACH GROUP 
SELECT race_ethnicity,avg(total_score) as avg_total_score
from studentsperformance 
group by race_ethnicity
order by 2 desc;
select * from studentsperformance;

-- how manny student pass the avg total score without taking the test_prepation 
select gender, count(*) as num_student_passed
from studentsperformance
where test_preparation_course='none'
and total_score >= (select avg(total_score) as avg_total_score from studentsperformance )
group by gender 
order by 2;