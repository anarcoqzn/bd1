-- Q1
SELECT COUNT(*) FROM EMPLOYEE WHERE sex='F';
-- Q2
SELECT AVG(SALARY) FROM EMPLOYEE WHERE address LIKE '%TX' AND sex='M';
-- Q3
SELECT superssn, COUNT(*) FROM EMPLOYEE GROUP BY superssn; 
-- Q4
SELECT fname AS nome_supervisor, COUNT(*) AS qtd_supervisionados FROM (EMPLOYEE AS E JOIN (SELECT superssn FROM EMPLOYEE) AS S ON E.ssn=S.superssn) GROUP BY fname ORDER BY qtd_supervisionados;
-- Q5
SELECT fname AS nome_supervisor, qtd AS qtd_supervisionados FROM (EMPLOYEE AS E RIGHT OUTER JOIN (SELECT superssn AS ssn, count(*) AS qtd FROM EMPLOYEE GROUP BY (superssn) ORDER BY qtd) AS S ON E.ssn=S.ssn);
-- Q6
SELECT MIN(qtd) AS qtd FROM (SELECT pno, COUNT(*) AS qtd FROM WORKS_ON GROUP BY pno) AS S;
-- Q7
SELECT pno AS num_projeto,qtd AS qtd_func FROM ((SELECT pno,COUNT(*) AS qtd FROM WORKS_ON GROUP BY pno) AS Q JOIN (SELECT MIN(qtd) FROM (SELECT pno,COUNT(*) AS qtd FROM WORKS_ON GROUP BY pno) AS S) AS F ON Q.qtd=F.min);
-- Q8
SELECT pno AS num_proj,AVG(salary) AS media_sal FROM (WORKS_ON AS W JOIN EMPLOYEE AS E ON W.essn=E.ssn) GROUP BY pno;
-- Q9
SELECT num_proj, pname AS proj_name, media_sal FROM (SELECT pno AS num_proj,AVG(salary) AS media_sal FROM (WORKS_ON AS W JOIN EMPLOYEE AS E ON W.essn=E.ssn) GROUP BY pno) AS S JOIN PROJECT ON S.num_proj=PROJECT.pnumber;
-- Q10
SELECT * FROM (SELECT MAX(media_sal) FROM (SELECT pno AS num_proj,AVG(salary) AS media_sal FROM (WORKS_ON AS W JOIN EMPLOYEE AS E ON W.essn=E.ssn) GROUP BY pno) AS S) AS Q JOIN S ON S.media_sal=Q.max;


-- Q11
-- Q12
-- Q13
-- Q14
-- Q15
-- Q16
