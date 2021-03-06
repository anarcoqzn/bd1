-- ====== QUESTAO 1A ======
  -- Primeiramente, executar consulta que retorne os dados de interesse:
  SELECT dnumber, fname, minit, lname FROM DEPARTMENT,EMPLOYEE WHERE mgrssn=ssn;
  -- Depois, criar a VIEW
  CREATE VIEW VW_DPTMGR AS SELECT dnumber, fname, minit, lname FROM DEPARTMENT,EMPLOYEE WHERE mgrssn=ssn;
  
-- ===========

-- ====== QUESTÃO 1B ======
  -- Primeiramente, executar consulta que retorne os dados de interesse:
  SELECT ssn, fname FROM EMPLOYEE WHERE address LIKE '%Houston%';
  -- Depois, criar a VIEW:
  CREATE VIEW VW_EMPL_HOUSTON AS SELECT ssn, fname FROM EMPLOYEE WHERE address LIKE '%Houston%';

-- ===========

-- ====== QUESTÃO 1C ======
  -- Primeiramente, executar consulta que retorne os dados de interesse:
  SELECT DNUMBER, DNAME, COUNT(*) AS QTY_EMP FROM EMPLOYEE, DEPARTMENT WHERE DNO=DNUMBER GROUP BY DNUMBER;
  -- Depois, criar a VIEW:
  CREATE VIEW VW_DEPSTATS AS SELECT DNUMBER, DNAME, COUNT(*) AS QTY_EMP FROM EMPLOYEE, DEPARTMENT WHERE DNO=DNUMBER GROUP BY DNUMBER;

-- ===========

-- ====== QUESTÃO 1D ======
  -- Primeiramente, executar consulta que retorne os dados de interesse:
  SELECT PNO, COUNT(*) AS QTY_EMP FROM WORKS_ON GROUP BY PNO;
  -- Depois, criar a VIEW:
  CREATE VIEW VW_PROJSTATS AS SELECT PNO, COUNT(*) AS QTY_EMP FROM WORKS_ON GROUP BY PNO;
-- ===========

-- ====== QUESTÃO 2 ======
  -- VW_DPTMGR
  SELECT VW.DNUMBER, E.SSN FROM VW_DPTMGR VW, EMPLOYEE E,DEPARTMENT D WHERE E.FNAME=VW.FNAME AND E.MINIT=VW.MINIT AND E.LNAME=VW.LNAME AND D.MGRSSN=SSN; -- checar se as linhas retornadas correspondem com select * from department;

  -- VW_EMPL_HOUSTON
  SELECT E.SSN, E.FNAME, E.ADDRESS FROM EMPLOYEE E, VW_EMPL_HOUSTON VW WHERE VW.SSN=E.SSN; -- checar os endereços completos e comparar o ssn do empregado com o que é exibido na view.

  -- VW_DEPSTATS ( SELECT * FROM VW_DEPSTATS )
   SELECT COUNT(*) FROM EMPLOYEE WHERE DNO=8; -- DEVE RETORNAR 14, COMO MOSTRADO NA VIEW.
   SELECT COUNT(*) FROM EMPLOYEE WHERE DNO=4; -- DEVE RETORNAR 3, COMO MOSTRADO NA VIEW.
   SELECT COUNT(*) FROM EMPLOYEE WHERE DNO=1; -- DEVE RETORNAR 1, COMO MOSTRADO NA VIEW.
   SELECT COUNT(*) FROM EMPLOYEE WHERE DNO=5; -- DEVE RETORNAR 5, COMO MOSTRADO NA VIEW.
   SELECT COUNT(*) FROM EMPLOYEE WHERE DNO=6; -- DEVE RETORNAR 8, COMO MOSTRADO NA VIEW.
   SELECT COUNT(*) FROM EMPLOYEE WHERE DNO=7; -- DEVE RETORNAR 10, COMO MOSTRADO NA VIEW.

  -- VW _PROJSTATS ( SELECT * FROM VW_PROJSTATS )
  SELECT COUNT(*) FROM WORKS_ON WHERE PNO=30; -- DEVE RETORNAR 3, COMO MOSTRADO NA VIEW.
  SELECT COUNT(*) FROM WORKS_ON WHERE PNO=62; -- DEVE RETORNAR 8, COMO MOSTRADO NA VIEW.
  -- FAZER CHECAGEM PARA OS OUTROS PROJETOS
-- ===========

-- ====== QUESTÃO 3 ======
  DROP VIEW VW_DPTMGR;
  DROP VIEW VW_EMPL_HOUSTON;
  DROP VIEW VW_DEPSTATS;
  DROP VIEW VW_PROJSTATS;
-- ===========

-- ====== QUESTÃO 4 ======
  -- ENCONTRAR CONSULTA QUE CALCULE E RETORNE A IDADE DOS FUNCIONARIOS:
  SELECT EXTRACT(YEAR FROM AGE(EMP.BDATE)) FROM EMPLOYEE EMP;
  -- CRIAR FUNÇÃO:
  CREATE OR REPLACE FUNCTION CHECK_AGE(EMP_SSN CHAR(9))
  RETURNS VARCHAR(7)
  LANGUAGE plpgsql
  AS
  $$
  DECLARE EMP_AGE INTEGER;
  DECLARE EMP_BDATE DATE;
  BEGIN
    SELECT INTO EMP_BDATE EMP.BDATE FROM EMPLOYEE EMP WHERE EMP.SSN=EMP_SSN;
    SELECT INTO EMP_AGE EXTRACT(YEAR FROM AGE(EMP.BDATE)) FROM EMPLOYEE EMP WHERE EMP.SSN=EMP_SSN;
    IF ( EMP_BDATE IS NULL ) THEN RETURN 'UNKNOWN';
    ELSIF ( EMP_AGE >= 50 ) THEN RETURN 'SENIOR';
    ELSIF ( EMP_AGE < 50 AND EMP_AGE >= 0 ) THEN RETURN 'YOUNG';
    ELSE RETURN 'INVALID';
    END IF;
  END;
  $$;
-- ===========

-- ====== QUESTÃO 5A ======

-- ===========

-- ====== QUESTÃO 5B ======
INSERT INTO department VALUES ('Test', 2, '999999999', now());
-- ===========

-- ====== QUESTÃO 5C ======
INSERT INTO employee VALUES ('Joao','A','Silva','999999999','10-OCT-1950','123 Peachtree, Atlanta, GA','M',85000,null,2);
INSERT INTO employee VALUES ('Jose','A','Santos','999999998','10-OCT-1950','123 Peachtree, Atlanta, GA','M',85000,'999999999',2);
-- ===========

-- ====== QUESTÃO 5D ======
  -- DEFINIR CONSULTAS PARA:
  -- 1 -> RETORNAR A QUANTIDADE DE SUBORDINADOS DO NOVO GERENTE
  -- SELECT COUNT(E.SSN) FROM EMPLOYEE E WHERE E.SUPERSSN=NEW.MGRSSN 
  -- 2 -> RETORNAR O DEPARTAMENTO ONDE O FUNCIONARIO ESTÁ ALOCADO
  -- SELECT DNO FROM EMPLOYEE WHERE SSN=NEW.MGRSSN

CREATE OR REPLACE FUNCTION CHECK_MGR() RETURNS TRIGGER AS $CHECK_MGR$
  DECLARE SUPERVISEE_QTY INTEGER;
  DECLARE EMP_DNO INTEGER;

  BEGIN
    SELECT INTO SUPERVISEE_QTY COUNT(E.SSN) FROM EMPLOYEE E WHERE E.SUPERSSN=NEW.MGRSSN ;
    SELECT INTO EMP_DNO DNO FROM EMPLOYEE WHERE SSN=NEW.MGRSSN;

    IF ( CHECK_AGE(NEW.MGRSSN) <> 'SENIOR' ) THEN RAISE EXCEPTION 'manager must be a SENIOR employee';
    ELSIF ( SUPERVISEE_QTY = 0 ) THEN RAISE EXCEPTION 'manager must have supervisees';
    ELSIF ( EMP_DNO <> NEW.DNUMBER ) THEN RAISE EXCEPTION 'manager must be a department''s employee';
    END IF;

    RETURN NEW;
  END;
  $CHECK_MGR$ LANGUAGE plpgsql;

  CREATE TRIGGER CHECK_MGR BEFORE INSERT OR UPDATE ON DEPARTMENT FOR EACH ROW EXECUTE PROCEDURE CHECK_MGR();
-- ===========

-- ====== QUESTÃO 5E ======
UPDATE department SET mgrssn = '999999999' WHERE dnumber=2;
 -- UPDATE 1
UPDATE department SET mgrssn = null WHERE dnumber=2;
  -- ERROR:  manager must be a SENIOR employee 
UPDATE department SET mgrssn = '999' WHERE dnumber=2;
  -- ERROR:  manager must be a SENIOR employee
UPDATE department SET mgrssn = '111111100' WHERE dnumber=2;
  -- ERROR:  manager must be a department's employee
UPDATE employee SET bdate = '10-OCT-2000' WHERE ssn = '999999999';
  -- UPDATE 1
UPDATE department SET mgrssn = '999999999' WHERE dnumber=2;
  -- ERROR:  manager must be a SENIOR employee
UPDATE employee SET bdate = '10-OCT-1950' WHERE ssn = '999999999';
  -- UPDATE 1
UPDATE department SET mgrssn = '999999999' WHERE dnumber=2;
  -- UPDATE 1
DELETE FROM employee WHERE superssn = '999999999';
  -- DELETE 1
UPDATE department SET mgrssn = '999999999' WHERE dnumber=2;
  -- ERROR:  manager must have supervisees
DELETE FROM employee WHERE ssn = '999999999';
  -- DELETE 1
DELETE FROM department where dnumber=2;
  -- DELETE 1