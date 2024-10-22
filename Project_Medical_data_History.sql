use project_medical_data_history;
show tables;
select * from admissions;
select * from doctors;
select * from  patients;
select * from province_names;


-- 1. Show first name, last name, and gender of patients who's gender is 'M'

select first_name, last_name, Gender
from patients 
where gender = "M";


--  2.Show first name and last name of patients who does not have allergies.


select first_name, last_name, allergies
from patients
where allergies is null;


-- 3. Show first name of patients that start with the letter 'C'


select first_name
from patients
where first_name like 'c%';


-- 4. Show first name and last name of patients that weight within the range of 100 to 120 (inclusive)


select first_name, last_name, weight
from patients
where weight between 100 and 120;


-- 5. Update the patients table for the allergies column. If the patient's allergies is null then replace it with 'NKA'


GRANT UPDATE ON patients TO dm_team4;
GRANT UPDATE ON patients TO 'dm_team4'@'18.136.157.135';
SHOW GRANTS FOR 'dm_team4'@'18.136.157.135';

update patients
set allergies = 'NKA'
where allergies = 'NULL';


-- 6 Show first name and last name concatenated into one column to show their full name.


SELECT CONCAT(first_name, ' ', last_name) AS Full_Name
FROM patients;


-- 7.Show first name, last name, and the full province name of each patient


SELECT 
    first_name,
    last_name,
    CONCAT(first_name, ' ', last_name) AS full_name
FROM 
    patients;
    
    
-- 8. Show how many patients have a birth_date with 2010 as the birth year.


SELECT COUNT(*) AS num_patients_with_birth_year_2010
FROM patients
WHERE YEAR(birth_date) = 2010;


-- 9. Show the first_name, last_name, and height of the patient with the greatest height.


SELECT first_name,last_name,height
FROM patients 
JOIN (
    SELECT MAX(height) AS max_height
    FROM patients
) AS max_height_query ON height = max_height_query.max_height;


-- 10. Show all columns for patients who have one of the following patient_ids: 1,45,534,879,1000


SELECT *
FROM admissions
WHERE patient_id IN (1, 45, 534, 879, 1000);


-- 11. Show the total number of admissions


SELECT COUNT(*) AS total_admissions
FROM admissions;


-- 12. Show all the columns from admissions where the patient was admitted and discharged on the same day.


SELECT *
FROM admissions
WHERE DATE(admission_date) = date(discharge_date);


-- 13. Show the total number of admissions for patient_id 579.


Select *
from admissions
where patient_id in (579);


-- 14. Based on the cities that our patients live in, show unique cities that are in province_id 'NS'?


select *
from province_names
where province_id like '%NS';


-- 15. Write a query to find the first_name, last name and birth date of patients who have height more than 160 and weight more than 70


select first_name, last_name, birth_date,height, weight
FROM patients
WHERE height > 160
  AND weight > 70;


-- 16. Show unique birth years from patients and order them by ascending.


SELECT DISTINCT first_name, last_name, YEAR(birth_date) AS BirthYear
FROM patients
ORDER BY BirthYear ASC;


--  17. Show unique first names from the patients table which only occurs once 


SELECT first_name
FROM patients
GROUP BY first_name
HAVING COUNT(*) = 1
ORDER BY first_name;


-- 18. Show patient_id and first_name from patients where their first_name start and ends with 's' and is at least 6 characters long.


SELECT patient_id, first_name
FROM patients
WHERE first_name LIKE 's%' AND first_name LIKE '%s' AND LENGTH(first_name) >= 6;


-- 19. Show patient_id, first_name, last_name from patients whos diagnosis is 'Dementia'.   Primary diagnosis is stored in the admissions table.


SELECT p.patient_id, p.first_name, p.last_name, diagnosis
FROM patients p
INNER JOIN admissions a ON p.patient_id = a.patient_id
WHERE diagnosis = 'Dementia';


-- 20. Display every patient's first_name. Order the list by the length of each name and then by alphbetically.


SELECT first_name
FROM patients
ORDER BY LENGTH(first_name), first_name;


-- 21. Show the total amount of male patients and the total amount of female patients in the patients table. Display the two results in the same row.


SELECT 
    SUM(CASE WHEN gender = 'M' THEN 1 ELSE 0 END) AS total_male_patients,
    SUM(CASE WHEN gender = 'F' THEN 1 ELSE 0 END) AS total_female_patients,
    COUNT(*) total_number_of_patients
FROM patients;


-- 23. Show patient_id, diagnosis from admissions. Find patients admitted multiple times for the same diagnosis.


SELECT patient_id, diagnosis
FROM admissions
WHERE patient_id IN (
    SELECT patient_id
    FROM admissions
    GROUP BY patient_id, diagnosis
    HAVING COUNT(*) > 1
)
ORDER BY patient_id, diagnosis;


-- 24. Show the city and the total number of patients in the city. Order from most to least patients and then by city name ascending.


SELECT city,
       COUNT(*) AS total_patients
FROM patients
GROUP BY city
ORDER BY total_patients DESC, city ASC;



-- 25. Show first name, last name and role of every person that is either patient or doctor.    The roles are either "Patient" or "Doctor"

SELECT first_name, last_name, 'Patient' AS role
FROM patients
UNION
SELECT first_name, last_name, 'Doctor' AS role
FROM doctors;


-- 26. Show all allergies ordered by popularity. Remove NULL values from query.


SELECT 
    allergies,
    COUNT(patient_id) AS popularity
FROM 
    patients
WHERE 
    allergies IS NOT NULL
GROUP BY 
    allergies
ORDER BY 
    popularity DESC;

    
-- 27. Show all patient's first_name, last_name, and birth_date who were born in the 1970s decade. Sort the list starting from the earliest birth_date.


SELECT 
    first_name,
    last_name,
    birth_date
FROM 
    patients
WHERE 
    birth_date >= '1970-01-01' AND birth_date < '1980-01-01'
ORDER BY 
    birth_date ASC;
    
    
-- 28. We want to display each patient's full name in a single column. Their last_name in all upper letters must appear first, then first_name in all lower case letters. Separate the last_name and first_name with a comma. Order the list by the first_name in decending order    EX: SMITH,jane    


SELECT CONCAT(UPPER(last_name), ',', LOWER(first_name)) AS full_name
FROM patients
ORDER BY LOWER(first_name) DESC;


-- 29. Show the province_id(s), sum of height; where the total sum of its patient's height is greater than or equal to 7,000.


SELECT province_id, SUM(height) AS total_height
FROM patients
GROUP BY province_id
HAVING SUM(height) >= 7000;	


-- 30. Show the difference between the largest weight and smallest weight for patients with the last name 'Maroni'

-- TYPE - 1

SELECT MAX(weight) - MIN(weight) AS weight_difference
FROM patients
WHERE last_name = 'Maroni';

-- TYPE - 2

SELECT last_name, first_name, 
       (SELECT MAX(weight) - MIN(weight)
        FROM patients
        WHERE last_name = 'Maroni') AS weight_difference
FROM patients
WHERE last_name = 'Maroni';


-- 31. Show all of the days of the month (1-31) and how many admission_dates occurred on that day. Sort by the day with most admissions to least admissions.


SELECT EXTRACT(DAY FROM admission_date) AS day_of_month,
       COUNT(*) AS admission_count
FROM admissions
GROUP BY EXTRACT(DAY FROM admission_date)
ORDER BY day_of_month ASC;


-- 32. Show all of the patients grouped into weight groups. Show the total amount of patients in each weight group. Order the list by the weight group decending. e.g. if they weight 100 to 109 they are placed in the 100 weight group, 110-119 = 110 weight group, etc.


SELECT first_name,
       last_name,
       FLOOR(weight / 10) * 10 AS weight_group,
       COUNT(*) AS total_patients
FROM patients
GROUP BY first_name, last_name, FLOOR(weight / 10) * 10
ORDER BY weight_group DESC;


-- 33. Show patient_id, weight, height, isObese from the patients table. Display isObese as a boolean 0 or 1. Obese is defined as weight(kg)/(height(m). Weight is in units kg. Height is in units cm.


SELECT patient_id,
       weight,
       height,
       CASE 
           WHEN weight / ((height / 100) * (height / 100)) >= 30 THEN 1
           ELSE 0
       END AS isObese
FROM patients;


-- 34. Show patient_id, first_name, last_name, and attending doctor's specialty. Show only the patients who has a diagnosis as 'Epilepsy' and the doctor's first name is 'Lisa'. Check patients, admissions, and doctors tables for required information.


SELECT p.patient_id,
       p.first_name,
       p.last_name,
       d.specialty
FROM patients p
JOIN admissions a ON p.patient_id = a.patient_id
JOIN doctors d ON a.attending_doctor_id = d.doctor_id
WHERE a.diagnosis = 'Epilepsy'
  AND LOWER(d.first_name) = 'lisa';
  

-- 35. All patients who have gone through admissions, can see their medical documents on our site. Those patients are given a temporary password after their first admission. Show the patient_id and temp_password


SELECT patient_id,
       CONCAT(patient_id, LENGTH(last_name), EXTRACT(YEAR FROM birth_date)) AS temp_password
FROM patients
WHERE patient_id IN (
    SELECT DISTINCT patient_id
    FROM admissions
);

-- Completed--



