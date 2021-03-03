--COMENTÁRIOS:
-- ====== QUESTAO 2 ======

-- INSERT INTO TAREFAS VALUES(2147483648, 'limpar portas do térreo', '32323232955',4, 'A');
 	-- COMANDOS 2: ERROR:  integer out of range

 -- MUDANDO O TIPO DE UMA COLUNA
	--  ALTER TABLE TAREFAS ALTER COLUMN cod TYPE BIGINT;

-- ====== QUESTAO 5 ======
 -- AO INVES DE TORNAR O ATRIBUTO COMO CHAVE PRIMARIA, COLOQUEI COMO UNIQUE, JÁ QUE NÃO FOI ESPECIFICADO NA QUESTAO.
-- ALTER TABLE TAREFAS ADD CONSTRAINT id_unique UNIQUE(id);
 -- comandos 5: ALTER TABLE
-- INSERT INTO TAREFAS VALUES(2147483653, 'aparar a grama da área frontal', '32323232911', 3, 'A');
	-- comandos 5: ERROR:  duplicate key value violates unique 		   constraint "id_unique"
	-- DETAIL:  Key (id)=(2147483653) already exists.

-- ====== QUESTAO 6 =======
-- No create desta tabela, já foi definido essa constraint para o tamanho do cpf do funcionario.
-- porém, inserções com cpf tamanho menor que 11 são realizadas, sendo necessário criar uma constraint para checar o tamanho do cpf nos inserts	

-- INSERT INTO TAREFAS VALUES(2147483675, 'limpar portas 1o andar','323', 2, 'A');
	-- para um cpf menor que 11, a inserção foi feita.
	-- COMANDOS 6: INSERT 0 1

-- DELETE FROM TAREFAS WHERE func_resp_cpf='323';
	-- DELETE 1

-- ALTER TABLE TAREFAS ADD CONSTRAINT length_cpf_func_chk CHECK(length(func_resp_cpf) = 11);
	-- ALTER TABLE

-- INSERT INTO TAREFAS VALUES(2147483675, 'limpar portas 1o andar', '323', 2, 'A');
	--ERROR:  new row for relation "tarefas" violates check constraint "length_cpf_func_chk"
	--DETAIL:  Failing row contains (2147483675, limpar portas 1o andar, 323, 2, A).

-- ====== QUESTAO 10 =====
 -- na tentativa de adicionar a restrição de chave estrangeira em tarefas referenciando o atributo func_resp_cpf a FUNCIONARIO, tive que criar os funcionarios com os cpfs já inseridos em TAREFAS para depois adicionar a constraint. Um exemplo abaixo: 

-- ALTER TABLE TAREFAS ADD CONSTRAINT TAREFAS_FUNC_RESP_CPF_FKEY FOREIGN KEY (func_resp_cpf) REFERENCES FUNCIONARIO(cpf) ON DELETE CASCADE;
-- ERROR:  insert or update on table "tarefas" violates foreign key constraint "tarefas_func_resp_cpf"
-- DETAIL:  Key (func_resp_cpf)=(32323232911) is not present in table "funcionario".

-- INSERT INTO FUNCIONARIO(cpf, data_nasc, nome, funcao, nivel, superior_cpf) VALUES ('32323232911','1980-04-09', 'joao da Silva', 'LIMPEZA', 'J','40512032050');

-- após adicionar a restrição de chave estrangeira temos o seguinte fluxo de execução para um comando delete em FUNCIONARIO:

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

--DELETE FROM FUNCIONARIO WHERE cpf='32323232911';

--select * from tarefas;
--     id     |            descricao            | func_resp_cpf | prioridade | status 
------------+---------------------------------+---------------+------------+--------
-- 2147483648 | limpar portas do térreo         | 32323232955   |          4 | P
-- 2147483646 | limpar chão do corredor central | 98765432111   |          0 | C
-- 2147483647 | limpar janelas da sala 203      | 98765432122   |          1 | C
--(3 rows)
-- PostgreSQL database dump
--

-- Dumped from database version 9.5.23
-- Dumped by pg_dump version 9.5.23

SET statement_timeout = 0;
SET lock_timeout = 0;
SET client_encoding = 'UTF8';
SET standard_conforming_strings = on;
SELECT pg_catalog.set_config('search_path', '', false);
SET check_function_bodies = false;
SET xmloption = content;
SET client_min_messages = warning;
SET row_security = off;

ALTER TABLE ONLY public.tarefas DROP CONSTRAINT tarefas_func_resp_cpf_fkey;
ALTER TABLE ONLY public.funcionario DROP CONSTRAINT funcionario_sup_fkey;
ALTER TABLE ONLY public.tarefas DROP CONSTRAINT id_unique;
ALTER TABLE ONLY public.funcionario DROP CONSTRAINT funcionario_pkey;
DROP TABLE public.tarefas;
DROP TABLE public.funcionario;
SET default_tablespace = '';

SET default_with_oids = false;

--
-- Name: funcionario; Type: TABLE; Schema: public; Owner: anarcoqzn
--

CREATE TABLE public.funcionario (
    cpf character(11) NOT NULL,
    data_nasc date NOT NULL,
    nome character varying(40) NOT NULL,
    funcao character varying(11) NOT NULL,
    nivel character(1) NOT NULL,
    superior_cpf character(11),
    CONSTRAINT funcionario_funcao_chk CHECK ((((funcao)::text = 'LIMPEZA'::text) OR ((funcao)::text = 'SUP_LIMPEZA'::text))),
    CONSTRAINT length_cpf_chk CHECK ((length(cpf) = 11)),
    CONSTRAINT nivel_chk CHECK (((nivel = 'J'::bpchar) OR (nivel = 'P'::bpchar) OR (nivel = 'S'::bpchar))),
    CONSTRAINT superior_funcionario_chk CHECK (((((funcao)::text = 'LIMPEZA'::text) AND (superior_cpf IS NOT NULL)) OR ((funcao)::text <> 'LIMPEZA'::text)))
);


ALTER TABLE public.funcionario OWNER TO anarcoqzn;

--
-- Name: tarefas; Type: TABLE; Schema: public; Owner: anarcoqzn
--

CREATE TABLE public.tarefas (
    id bigint NOT NULL,
    descricao text NOT NULL,
    func_resp_cpf character(11) NOT NULL,
    prioridade smallint NOT NULL,
    status character(1) NOT NULL,
    CONSTRAINT func_resp_cpf_chk CHECK ((((status <> 'P'::bpchar) AND (func_resp_cpf IS NOT NULL)) OR (status = 'P'::bpchar))),
    CONSTRAINT length_cpf_func_chk CHECK ((length(func_resp_cpf) = 11)),
    CONSTRAINT prioridade_chk CHECK (((prioridade >= 0) AND (prioridade <= 5))),
    CONSTRAINT status_chk CHECK (((status = 'P'::bpchar) OR (status = 'E'::bpchar) OR (status = 'C'::bpchar)))
);


ALTER TABLE public.tarefas OWNER TO anarcoqzn;

--
-- Data for Name: funcionario; Type: TABLE DATA; Schema: public; Owner: anarcoqzn
--

INSERT INTO public.funcionario (cpf, data_nasc, nome, funcao, nivel, superior_cpf) VALUES ('12345678911', '1980-05-07', 'Pedro da Silva', 'SUP_LIMPEZA', 'S', NULL);
INSERT INTO public.funcionario (cpf, data_nasc, nome, funcao, nivel, superior_cpf) VALUES ('12345678912', '1980-03-08', 'Jose da Silva', 'LIMPEZA', 'J', '12345678911');
INSERT INTO public.funcionario (cpf, data_nasc, nome, funcao, nivel, superior_cpf) VALUES ('01547932581', '1980-05-07', 'Pedro da Silva', 'SUP_LIMPEZA', 'S', NULL);
INSERT INTO public.funcionario (cpf, data_nasc, nome, funcao, nivel, superior_cpf) VALUES ('44421356789', '1980-03-08', 'Jose da Silva', 'LIMPEZA', 'J', '12345678911');
INSERT INTO public.funcionario (cpf, data_nasc, nome, funcao, nivel, superior_cpf) VALUES ('65123487329', '1980-05-07', 'Pedro da Silva', 'SUP_LIMPEZA', 'S', NULL);
INSERT INTO public.funcionario (cpf, data_nasc, nome, funcao, nivel, superior_cpf) VALUES ('14523678902', '1980-03-08', 'Silva', 'LIMPEZA', 'P', '12345678911');
INSERT INTO public.funcionario (cpf, data_nasc, nome, funcao, nivel, superior_cpf) VALUES ('38901204578', '1980-05-07', 'Pedro', 'SUP_LIMPEZA', 'S', NULL);
INSERT INTO public.funcionario (cpf, data_nasc, nome, funcao, nivel, superior_cpf) VALUES ('60214378593', '1981-09-08', 'Jose da Silva', 'LIMPEZA', 'P', '12345678911');
INSERT INTO public.funcionario (cpf, data_nasc, nome, funcao, nivel, superior_cpf) VALUES ('02314587934', '1980-12-07', 'Pedro da Silva', 'SUP_LIMPEZA', 'S', NULL);
INSERT INTO public.funcionario (cpf, data_nasc, nome, funcao, nivel, superior_cpf) VALUES ('51023468972', '1986-07-08', 'Jose da Silva', 'LIMPEZA', 'J', '12345678911');
INSERT INTO public.funcionario (cpf, data_nasc, nome, funcao, nivel, superior_cpf) VALUES ('20315468729', '1990-04-07', 'Pedro da Silva', 'SUP_LIMPEZA', 'S', NULL);
INSERT INTO public.funcionario (cpf, data_nasc, nome, funcao, nivel, superior_cpf) VALUES ('40512032050', '1980-03-08', 'Jose da Silva', 'LIMPEZA', 'P', '12345678911');
INSERT INTO public.funcionario (cpf, data_nasc, nome, funcao, nivel, superior_cpf) VALUES ('98765432111', '1975-10-19', 'Tiago da Fonseca', 'LIMPEZA', 'S', '40512032050');
INSERT INTO public.funcionario (cpf, data_nasc, nome, funcao, nivel, superior_cpf) VALUES ('98765432122', '1978-12-03', 'Fernando Gonçalo', 'LIMPEZA', 'P', '40512032050');
INSERT INTO public.funcionario (cpf, data_nasc, nome, funcao, nivel, superior_cpf) VALUES ('32323232955', '1980-04-09', 'Mario da Silva', 'LIMPEZA', 'J', '40512032050');


--
-- Data for Name: tarefas; Type: TABLE DATA; Schema: public; Owner: anarcoqzn
--

INSERT INTO public.tarefas (id, descricao, func_resp_cpf, prioridade, status) VALUES (2147483648, 'limpar portas do térreo', '32323232955', 4, 'P');
INSERT INTO public.tarefas (id, descricao, func_resp_cpf, prioridade, status) VALUES (2147483646, 'limpar chão do corredor central', '98765432111', 0, 'C');
INSERT INTO public.tarefas (id, descricao, func_resp_cpf, prioridade, status) VALUES (2147483647, 'limpar janelas da sala 203', '98765432122', 1, 'C');


--
-- Name: funcionario_pkey; Type: CONSTRAINT; Schema: public; Owner: anarcoqzn
--

ALTER TABLE ONLY public.funcionario
    ADD CONSTRAINT funcionario_pkey PRIMARY KEY (cpf);


--
-- Name: id_unique; Type: CONSTRAINT; Schema: public; Owner: anarcoqzn
--

ALTER TABLE ONLY public.tarefas
    ADD CONSTRAINT id_unique UNIQUE (id);


--
-- Name: funcionario_sup_fkey; Type: FK CONSTRAINT; Schema: public; Owner: anarcoqzn
--

ALTER TABLE ONLY public.funcionario
    ADD CONSTRAINT funcionario_sup_fkey FOREIGN KEY (superior_cpf) REFERENCES public.funcionario(cpf);


--
-- Name: tarefas_func_resp_cpf_fkey; Type: FK CONSTRAINT; Schema: public; Owner: anarcoqzn
--

ALTER TABLE ONLY public.tarefas
    ADD CONSTRAINT tarefas_func_resp_cpf_fkey FOREIGN KEY (func_resp_cpf) REFERENCES public.funcionario(cpf) ON DELETE RESTRICT;

--
-- Name: tarefas_func_resp_cpf_fkey; Type: FK CONSTRAINT; Schema: public; Owner: anarcoqzn
--

ALTER TABLE ONLY public.tarefas
    DROP CONSTRAINT tarefas_func_resp_cpf_fkey;

--
-- Name: tarefas_func_resp_cpf_fkey; Type: FK CONSTRAINT; Schema: public; Owner: anarcoqzn
--

ALTER TABLE ONLY public.tarefas
    ADD CONSTRAINT tarefas_func_resp_cpf_chk CHECK(((((status)::text <> 'P'::text) AND (func_resp_cpf IS NOT NULL)) OR ((status)::text = 'P'::text)))

--
-- Name: tarefas_func_resp_cpf_fkey; Type: FK CONSTRAINT; Schema: public; Owner: anarcoqzn
--

ALTER TABLE ONLY public.tarefas
    ADD CONSTRAINT tarefas_func_resp_cpf_fkey FOREIGN KEY (func_resp_cpf) REFERENCES public.funcionario(cpf) ON DELETE SET NULL;

--
-- PostgreSQL database dump complete
--

