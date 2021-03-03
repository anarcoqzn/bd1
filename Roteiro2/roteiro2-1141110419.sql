-- QUESTÃO 1

CREATE TABLE TAREFAS(
	cod INTEGER,
	tarefa TEXT,
	funcionario CHAR(11),
	atrb1 INTEGER,
	atrb2 CHAR(1)	
);
-- INSERÇÕES QUE DEVEM FUNCIONAR
INSERT INTO TAREFAS VALUES(2147483646,'limpar chão do corredor central', '98765432111', 0, 'F');

INSERT INTO TAREFAS VALUES(2147483647, 'limpar janelas da sala 203','98765432122', 1, 'F');

INSERT INTO TAREFAS VALUES(NULL, NULL, NULL, NULL, NULL, NULL);
-- INSERÇÕES QUE NÃO DEVEM FUNCIONAR

INSERT INTO TAREFAS VALUES(2147483644,'limpar chão do corredor superior', '987654323211',0,'F');]

	-- ERROR:  value too long for type character(11)

INSERT INTO TAREFAS VALUES(2147483643,'limpar chão do corredor superior', '98765432321',0, 'FF');
	-- ERROR:  value too long for type character(1)

---------- FIM QUESTAO 1



-- QUESTAO 2

INSERT INTO TAREFAS VALUES(2147483648, 'limpar portas do térreo', '32323232955',4, 'A');
 	-- COMANDOS 2: ERROR:  integer out of range

 -- MUDANDO O TIPO DE UMA COLUNA
ALTER TABLE TAREFAS ALTER COLUMN cod TYPE BIGINT;

INSERT INTO TAREFAS VALUES(2147483648, 'limpar portas do térreo', '32323232955',4, 'A');
	-- COMANDOS 2: INSERT 0 1
---------- FIM QUESTAO 2



---------- QUESTAO 3
ALTER TABLE TAREFAS ALTER COLUMN atrb1 TYPE SMALLINT;

INSERT INTO TAREFAS VALUES(2147483649, 'limpar portas da entrada principal', '32322525199', 32768,'A');]

	-- Comandos 3: ERROR:  smallint out of range

INSERT INTO TAREFAS VALUES(2147483650, 'limpar janelas da entrada principal', '32333233288', 32769,'A');

	-- Comandos 3: ERROR:  smallint out of range

INSERT INTO TAREFAS VALUES(2147483651, 'limpar portas do 1o andar', '32323232911', 32767, 'A');
	-- Comandos 4: INSERT 0 1

INSERT INTO TAREFAS VALUES(2147483652, 'limpar portas do 2o andar', '32323232911', 32766, 'A');
	-- Comandos 4: INSERT 0 1

---------- FIM QUESTAO 3


---------- QUESTÃO 4
DELETE FROM TAREFAS WHERE cod=null;

ALTER TABLE TAREFAS ALTER COLUMN cod SET NOT NULL;
ALTER TABLE TAREFAS ALTER COLUMN tarefa SET NOT NULL;
ALTER TABLE TAREFAS ALTER COLUMN funcionario SET NOT NULL;
ALTER TABLE TAREFAS ALTER COLUMN atrb1 SET NOT NULL;
ALTER TABLE TAREFAS ALTER COLUMN atrb2 SET NOT NULL;

ALTER TABLE TAREFAS RENAME COLUMN cod TO id; 
ALTER TABLE TAREFAS RENAME COLUMN tarefa TO descricao; 
ALTER TABLE TAREFAS RENAME COLUMN funcionario TO func_resp_cpf; 
ALTER TABLE TAREFAS RENAME COLUMN atrb1 TO prioridade; 
ALTER TABLE TAREFAS RENAME COLUMN atrb2 TO status; 

---------- FIM QUESTÃO 4

---------- QUESTAO 5

ALTER TABLE TAREFAS ADD CONSTRAINT id_unique UNIQUE(id);
 -- comandos 5: ALTER TABLE

INSERT INTO TAREFAS VALUES(2147483653, 'limpar portas 1o andar', '32323232911', 2, 'A');
	-- comandos 5: INSERT 0 1

INSERT INTO TAREFAS VALUES(2147483653, 'aparar a grama da área frontal', '32323232911', 3, 'A');
	-- comandos 5: ERROR:  duplicate key value violates unique 		   constraint "id_unique"
	-- DETAIL:  Key (id)=(2147483653) already exists.

---------- FIM QUESTAO 5


---------- QUESTAO 6
-- No create desta tabela, já foi definido essa constraint para o tamanho do cpf do funcionario.

 -- 6.A)

INSERT INTO TAREFAS VALUES(2147483675, 'limpar portas 1o andar', '323232329121', 2, 'A');
	-- COMANDOS 6: ERROR:  value too long for type character(11)

INSERT INTO TAREFAS VALUES(2147483675, 'limpar portas 1o andar','323', 2, 'A');
	-- para um cpf menor que 11, a inserção foi feita.
	-- COMANDOS 6: INSERT 0 1

DELETE FROM TAREFAS WHERE func_resp_cpf='323';
	-- DELETE 1

ALTER TABLE TAREFAS ADD CONSTRAINT length_cpf_func_chk CHECK(length(func_resp_cpf) = 11);
	-- ALTER TABLE

INSERT INTO TAREFAS VALUES(2147483675, 'limpar portas 1o andar', '323', 2, 'A');
	--ERROR:  new row for relation "tarefas" violates check 		  constraint "length_cpf_func_chk"
	--DETAIL:  Failing row contains (2147483675, limpar portas 1o 	         	   andar, 323, 2, A).

-- 6.B)

ALTER TABLE TAREFAS ADD CONSTRAINT status_chk CHECK(status ='P' OR status = 'E' OR status = 'C');
	-- ALTER TABLE TAREFAS ADD CONSTRAINT status_chk CHECK(status ='P' OR status = 'E' OR status = 'C');

UPDATE TAREFAS SET status = 'P' WHERE status='A';
	-- UPDATE 4
UPDATE TAREFAS SET status = 'E' WHERE status='R';
	-- UPDATE 0
UPDATE TAREFAS SET status = 'C' WHERE status='F';
	-- UPDATE 2

ALTER TABLE TAREFAS ADD CONSTRAINT status_chk CHECK(status ='P' OR status = 'E' OR status = 'C');
	-- ALTER TABLE

---------- FIM QUESTAO 6


---------- QUESTAO 7

UPDATE TAREFAS SET prioridade = 5 WHERE prioridade > 5;
	-- UPDATE 2

ALTER TABLE TAREFAS ADD CONSTRAINT prioridade_chk CHECK(prioridade >= 0 AND prioridade <= 5);
	-- ALTER TABLE

---------- FIM QUESTAO 7

---------- QUESTAO 8
CREATE TABLE FUNCIONARIO(
	cpf CHAR(11), 
	data_nasc DATE NOT NULL,
	nome VARCHAR(40) NOT NULL,
	funcao VARCHAR (11) NOT NULL,
	nivel CHAR(1) NOT NULL,
	superior_cpf CHAR(11),
	CONSTRAINT FUNCIONARIO_PKEY PRIMARY KEY(cpf), 
	CONSTRAINT FUNCIONARIO_SUP_FKEY FOREIGN KEY (superior_cpf) REFERENCES FUNCIONARIO(cpf), 
	CONSTRAINT FUNCIONARIO_FUNCAO_CHK CHECK(funcao='LIMPEZA' OR funcao='SUP_LIMPEZA'), 
	CONSTRAINT SUPERIOR_FUNCIONARIO_CHK CHECK((funcao='LIMPEZA' AND superior_cpf IS NOT NULL) OR funcao <> 'LIMPEZA'),
	CONSTRAINT NIVEL_CHK CHECK(nivel='J' OR nivel='P' OR nivel='S'), CONSTRAINT LENGTH_CPF_CHK CHECK(length(cpf)=11));
	--CREATE TABLE

-- INSERÇÕES QUE DEVEM FUNCIONAR

INSERT INTO funcionario(cpf,data_nasc,nome,funcao,nivel,superior_cpf) VALUES('12345678911', '1980-05-07','Pedro da Silva', 'SUP_LIMPEZA','S',null);
	-- INSERT 0 1
INSERT INTO FUNCIONARIO(cpf, data_nasc, nome, funcao, nivel, superior_cpf) VALUES ('12345678912','1980-03-08','Jose da Silva','LIMPEZA', 'J','12345678911');
	-- INSERT 0 1

-- INSERÇÕES QUE NÃO DEVEM FUNCIONAR

INSERT INTO FUNCIONARIO(cpf, data_nasc, nome, funcao, nivel, superior_cpf) VALUES ('12345678913','1980-04-09', 'joao da Silva', 'LIMPEZA', 'J',null);
	-- ERROR:  new row for relation "funcionario" violates check constraint "superior_funcionario_chk"
	-- DETAIL:  Failing row contains (12345678913, 1980-04-09, joao da Silva, LIMPEZA, J, null).

---------- FIM QUESTAO 8

---------- QUESTAO 9

	-- INSERTS QUE FUNCIONAM EM FUNCIONARIO
INSERT INTO funcionario(cpf,data_nasc,nome,funcao,nivel,superior_cpf) VALUES('01547932581', '1980-05-07','Pedro da Silva', 'SUP_LIMPEZA','S',null);

INSERT INTO FUNCIONARIO(cpf, data_nasc, nome, funcao, nivel, superior_cpf) VALUES ('44421356789','1980-03-08','Jose da Silva','LIMPEZA', 'J','12345678911');

INSERT INTO funcionario(cpf,data_nasc,nome,funcao,nivel,superior_cpf) VALUES('65123487329', '1980-05-07','Pedro da Silva', 'SUP_LIMPEZA','S',null);

INSERT INTO FUNCIONARIO(cpf, data_nasc, nome, funcao, nivel, superior_cpf) VALUES ('14523678902','1980-03-08','Silva','LIMPEZA', 'P','12345678911');

INSERT INTO funcionario(cpf,data_nasc,nome,funcao,nivel,superior_cpf) VALUES('38901204578', '1980-05-07','Pedro', 'SUP_LIMPEZA','S',null);

INSERT INTO FUNCIONARIO(cpf, data_nasc, nome, funcao, nivel, superior_cpf) VALUES ('60214378593','1981-09-08','Jose da Silva','LIMPEZA', 'P','12345678911');

INSERT INTO funcionario(cpf,data_nasc,nome,funcao,nivel,superior_cpf) VALUES('02314587934', '1980-12-07','Pedro da Silva', 'SUP_LIMPEZA','S',null);

INSERT INTO FUNCIONARIO(cpf, data_nasc, nome, funcao, nivel, superior_cpf) VALUES ('51023468972','1986-07-08','Jose da Silva','LIMPEZA', 'J','12345678911');

INSERT INTO funcionario(cpf,data_nasc,nome,funcao,nivel,superior_cpf) VALUES('20315468729', '1990-04-07','Pedro da Silva', 'SUP_LIMPEZA','S',null);

INSERT INTO FUNCIONARIO(cpf, data_nasc, nome, funcao, nivel, superior_cpf) VALUES ('40512032050','1980-03-08','Jose da Silva','LIMPEZA', 'P','12345678911');


	-- INSERÇÕES QUE NÃO DEVEM FUNCIONAR EM FUNCIONARIO

INSERT INTO FUNCIONARIO(cpf, data_nasc, nome, funcao, nivel, superior_cpf) VALUES ('410512032050','1980-03-08','Jose da Silva','LIMPEZA', 'P','12345678911'); -- CPF MAIOR QUE 11 ERROR:  value too long for type character(11)

INSERT INTO FUNCIONARIO(cpf, data_nasc, nome, funcao, nivel, superior_cpf) VALUES ('42032050','1980-03-08','Jose da Silva','LIMPEZA', 'P','12345678911'); -- CPF MENOR QUE 11 ERROR:  new row for relation "funcionario" violates check constraint "length_cpf_chk"
--DETAIL:  Failing row contains (42032050   , 1980-03-08, Jose da Silva, LIMPEZA, P, 12345678911).

INSERT INTO FUNCIONARIO(cpf, data_nasc, nome, funcao, nivel, superior_cpf) VALUES ('40512032050','1980-03-08','Jose da Silva','LIMPEZA', 'P','12345678911'); -- CPF JÁ EXISTENTE ERROR:  duplicate key value violates unique constraint "funcionario_pkey"
-- DETAIL:  Key (cpf)=(40512032050) already exists.

INSERT INTO FUNCIONARIO(cpf, data_nasc, nome, funcao, nivel, superior_cpf) VALUES ('20151023489','1980-03-08','Jose da Silva','LIMPEZA', 'P','00000000000');  -- CPF NÃO EXISTE NA CHAVE ESTRANGEIRA ERROR:  insert or update on table "funcionario" violates foreign key constraint "funcionario_sup_fkey"
-- DETAIL:  Key (superior_cpf)=(00000000000) is not present in table "funcionario".

INSERT INTO FUNCIONARIO(cpf, data_nasc, nome, funcao, nivel, superior_cpf) VALUES ('20151023489','1980-03-08','Jose da Silva','RECEPCAO', 'P','12345678911'); -- FUNÇÃO DIFERENTE DE LIMPEZA E SUP_LIMPEZA ERROR:  new row for relation "funcionario" violates check constraint "funcionario_funcao_chk"
-- DETAIL:  Failing row contains (20151023489, 1980-03-08, Jose da Silva, RECEPCAO, P, 12345678911).

INSERT INTO FUNCIONARIO(cpf, data_nasc, nome, funcao, nivel, superior_cpf) VALUES ('20151023489','1980-03-08','Jose da Silva','LIMPEZA', 'J','null'); -- VALOR NULL NO SUPERIOR_CPF QUANDO FUNCAO EH LIMPEZA: ERROR:  insert or update on table "funcionario" violates foreign key constraint "funcionario_sup_fkey"
-- DETAIL:  Key (superior_cpf)=(null       ) is not present in table "funcionario".

INSERT INTO FUNCIONARIO(cpf, data_nasc, nome, funcao, nivel, superior_cpf) VALUES ('20151023489','1980-03-08','Jose da Silva','LIMPEZA', 'C','12345678911'); -- NIVEL : ERROR:  new row for relation "funcionario" violates check constraint "nivel_chk"
-- DETAIL:  Failing row contains (20151023489, 1980-03-08, Jose da Silva, LIMPEZA, C, 12345678911).

---------- FIM QUESTAO 9

---------- QUESTAO 10
ALTER TABLE TAREFAS ADD CONSTRAINT TAREFAS_FUNC_RESP_CPF_FKEY FOREIGN KEY (func_resp_cpf) REFERENCES FUNCIONARIO(cpf) ON DELETE CASCADE;
--ERROR:  insert or update on table "tarefas" violates foreign key constraint "tarefas_func_resp_cpf"
--DETAIL:  Key (func_resp_cpf)=(32323232911) is not present in table "funcionario".

INSERT INTO FUNCIONARIO(cpf, data_nasc, nome, funcao, nivel, superior_cpf) VALUES ('32323232911','1980-04-09', 'joao da Silva', 'LIMPEZA', 'J','40512032050');

ALTER TABLE TAREFAS ADD CONSTRAINT TAREFAS_FUNC_RESP_CPF_FKEY FOREIGN KEY (func_resp_cpf) REFERENCES FUNCIONARIO(cpf) ON DELETE CASCADE;
--ERROR:  insert or update on table "tarefas" violates foreign key constraint "tarefas_func_resp_cpf"
--DETAIL:  Key (func_resp_cpf)=(32323232955) is not present in table "funcionario".

INSERT INTO FUNCIONARIO(cpf, data_nasc, nome, funcao, nivel, superior_cpf) VALUES ('32323232955','1980-04-09', 'Mario da Silva', 'LIMPEZA', 'J','40512032050');

ALTER TABLE TAREFAS ADD CONSTRAINT TAREFAS_FUNC_RESP_CPF_FKEY FOREIGN KEY (func_resp_cpf) REFERENCES FUNCIONARIO(cpf) ON DELETE CASCADE;
-- ERROR:  insert or update on table "tarefas" violates foreign key constraint "tarefas_func_resp_cpf"
-- DETAIL:  Key (func_resp_cpf)=(98765432111) is not present in table "funcionario".

INSERT INTO FUNCIONARIO(cpf, data_nasc, nome, funcao, nivel, superior_cpf) VALUES ('98765432111','1975-10-19', 'Tiago da Fonseca', 'LIMPEZA', 'S','40512032050');

ALTER TABLE TAREFAS ADD CONSTRAINT TAREFAS_FUNC_RESP_CPF_FKEY FOREIGN KEY (func_resp_cpf) REFERENCES FUNCIONARIO(cpf) ON DELETE CASCADE;
-- ERROR:  insert or update on table "tarefas" violates foreign key constraint "tarefas_func_resp_cpf"
-- DETAIL:  Key (func_resp_cpf)=(98765432122) is not present in table "funcionario".


INSERT INTO FUNCIONARIO(cpf, data_nasc, nome, funcao, nivel, superior_cpf) VALUES ('98765432122','1978-12-03', 'Fernando Gonçalo', 'LIMPEZA', 'P','40512032050');

ALTER TABLE TAREFAS ADD CONSTRAINT TAREFAS_FUNC_RESP_CPF_FKEY FOREIGN KEY (func_resp_cpf) REFERENCES FUNCIONARIO(cpf) ON DELETE CASCADE;
-- ALTER TABLE

--select * from tarefas;
--     id     |            descricao            | func_resp_cpf | prioridade | status 
------------+---------------------------------+---------------+------------+--------
-- 2147483653 | limpar portas 1o andar          | 32323232911   |          2 | P
-- 2147483648 | limpar portas do térreo         | 32323232955   |          4 | P
-- 2147483646 | limpar chão do corredor central | 98765432111   |          0 | C
-- 2147483647 | limpar janelas da sala 203      | 98765432122   |          1 | C
-- 2147483651 | limpar portas do 1o andar       | 32323232911   |          5 | P
-- 2147483652 | limpar portas do 2o andar       | 32323232911   |          5 | P
--(6 rows)
--

DELETE FROM FUNCIONARIO WHERE cpf='32323232911';

--select * from tarefas;
--     id     |            descricao            | func_resp_cpf | prioridade | status 
------------+---------------------------------+---------------+------------+--------
-- 2147483648 | limpar portas do térreo         | 32323232955   |          4 | P
-- 2147483646 | limpar chão do corredor central | 98765432111   |          0 | C
-- 2147483647 | limpar janelas da sala 203      | 98765432122   |          1 | C
--(3 rows)
--
ALTER TABLE TAREFAS DROP CONSTRAINT TAREFAS_FUNC_RESP_CPF_FKEY;
-- ALTER TABLE

ALTER TABLE TAREFAS ADD CONSTRAINT TAREFAS_FUNC_RESP_CPF_FKEY FOREIGN KEY (func_resp_cpf) REFERENCES FUNCIONARIO(cpf) ON DELETE RESTRICT;
-- ALTER TABLE

DELETE FROM FUNCIONARIO WHERE cpf='32323232955';
-- ERROR:  update or delete on table "funcionario" violates foreign key constraint "tarefas_func_resp_cpf_fkey" on table "tarefas"
-- DETAIL:  Key (cpf)=(32323232955) is still referenced from table "tarefas".

---------- FIM QUESTAO 10

---------- QUESTAO 11

ALTER TABLE TAREFAS ADD CONSTRAINT FUNC_RESP_CPF_CHK CHECK((status <> 'P' AND func_resp_cpf IS NOT NULL) OR status='P');
	-- ALTER TABLE

ALTER TABLE TAREFAS 
	DROP CONSTRAINT TAREFAS_FUNC_RESP_CPF_FKEY 
	ADD CONSTRAINT TAREFAS_FUNC_RESP_CPF_FKEY FOREIGN KEY (func_resp_cpf) REFERENCES FUNCIONARIO(cpf) ON DELETE SET NULL;

---------- FIM QUESTAO 11









































