Medical Data History - SQL Queries
This repository contains SQL queries used to analyze and manipulate patient data for a medical data history project. The database includes information on patients, admissions, doctors, and provinces, and these queries are designed to solve various problems related to the dataset.

Problem Queries
1. Show First Name, Last Name, and Gender of Male Patients
This query retrieves the first name, last name, and gender of all male patients from the database:
   
SELECT first_name, last_name, gender FROM patients WHERE gender = 'M';
   
3. Show Patients Without Allergies
To identify patients who do not have any recorded allergies, this query lists the first and last names of such patients:

SELECT first_name, last_name FROM patients WHERE allergies IS NULL;

3.Show Patients Whose First Name Starts with 'C'
This query fetches the first names of all patients whose first name begins with the letter 'C':

SELECT first_name FROM patients WHERE first_name LIKE 'C%';


   
  

