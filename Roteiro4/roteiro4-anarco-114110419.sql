-- Q1
SELECT * FROM DEPARTMENT;

-- Q2
SELECT * FROM DEPENDENT;

-- Q3
SELECT * FROM DEPT_LOCATIONS;

-- Q5
SELECT * FROM PROJECT;

-- Q6
SELECT * FROM WORKS_ON;

-- Q7
SELECT fname, lname FROM EMPLOYEE WHERE sex='M';

-- Q8
SELECT fname FROM EMPLOYEE WHERE sex='M' AND superssn IS NULL;

-- Q9
SELECT E.fname, S.fname FROM EMPLOYEE AS E, EMPLOYEE AS S WHERE E.superssn IS NOT NULL AND E.superssn = S.ssn;

-- Q10
SELECT E.fname FROM EMPLOYEE AS E, EMPLOYEE AS S WHERE E.superssn IS NOT NULL AND E.superssn = S.ssn AND S.fname='Franklin';

-- Q11
SELECT D.dname, L.dlocation FROM DEPARTMENT AS D,DEPT_LOCATIONS AS L WHERE D.dnumber=L.dnumber;

-- Q12
SELECT D.dname FROM DEPARTMENT AS D,DEPT_LOCATIONS AS L WHERE D.dnumber=L.dnumber AND L.dlocation LIKE '%S%';

-- Q13
SELECT fname,lname, dependent_name FROM EMPLOYEE, DEPENDENT WHERE essn=ssn;

-- Q14
SELECT fname||minit||lname, salary FROM EMPLOYEE WHERE salary > 50000;

-- Q15
SELECT pname, dname FROM PROJECT, DEPARTMENT WHERE dnum=dnumber;

-- Q16
SELECT pname, fname FROM PROJECT, DEPARTMENT, EMPLOYEE WHERE dnum=dnumber AND mgrssn=ssn AND pnumber>30;

-- Q17
SELECT pname, fname FROM PROJECT, EMPLOYEE, WORKS_ON WHERE pnumber=pno AND essn=ssn;

-- Q18
SELECT fname, D.dependent_name, D.relationship FROM EMPLOYEE, DEPENDENT AS D,WORKS_ON AS W WHERE D.essn=ssn AND W.essn=ssn AND W.pno=91;
