--
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

ALTER TABLE ONLY public.vendas DROP CONSTRAINT vendas_funcionario_fkey;
ALTER TABLE ONLY public.vendas DROP CONSTRAINT venda_medicamento_fkey;
ALTER TABLE ONLY public.vendas DROP CONSTRAINT venda_cliente_fkey;
ALTER TABLE ONLY public.funcionarios DROP CONSTRAINT funcionarios_farmacia_fkey;
ALTER TABLE ONLY public.farmacia DROP CONSTRAINT farmacia_gerente_fkey;
ALTER TABLE ONLY public.entregas DROP CONSTRAINT entregas_medicamento_fkey;
ALTER TABLE ONLY public.entregas DROP CONSTRAINT entregas_funcionario_fkey;
ALTER TABLE ONLY public.entregas DROP CONSTRAINT entregas_endereco_fkey;
ALTER TABLE ONLY public.entregas DROP CONSTRAINT entregas_cliente_fkey;
ALTER TABLE ONLY public.endereco DROP CONSTRAINT endereco_cpf_cliente_fkey;
ALTER TABLE ONLY public.vendas DROP CONSTRAINT vendas_pkey;
ALTER TABLE ONLY public.medicamentos DROP CONSTRAINT medicamentos_pkey;
ALTER TABLE ONLY public.funcionarios DROP CONSTRAINT funcionarios_pkey;
ALTER TABLE ONLY public.farmacia DROP CONSTRAINT farmacia_pkey;
ALTER TABLE ONLY public.farmacia DROP CONSTRAINT exclude_tipo;
ALTER TABLE ONLY public.farmacia DROP CONSTRAINT exclude_bairro;
ALTER TABLE ONLY public.entregas DROP CONSTRAINT entregas_pkey;
ALTER TABLE ONLY public.endereco DROP CONSTRAINT endereco_pkey;
ALTER TABLE ONLY public.clientes DROP CONSTRAINT clientes_pkey;
ALTER TABLE public.vendas ALTER COLUMN id DROP DEFAULT;
ALTER TABLE public.medicamentos ALTER COLUMN id DROP DEFAULT;
ALTER TABLE public.farmacia ALTER COLUMN id DROP DEFAULT;
ALTER TABLE public.entregas ALTER COLUMN id DROP DEFAULT;
ALTER TABLE public.endereco ALTER COLUMN id DROP DEFAULT;
DROP SEQUENCE public.vendas_id_seq;
DROP TABLE public.vendas;
DROP SEQUENCE public.medicamentos_id_seq;
DROP TABLE public.medicamentos;
DROP TABLE public.funcionarios;
DROP SEQUENCE public.farmacia_id_seq;
DROP TABLE public.farmacia;
DROP SEQUENCE public.entregas_id_seq;
DROP TABLE public.entregas;
DROP SEQUENCE public.endereco_id_seq;
DROP TABLE public.endereco;
DROP TABLE public.clientes;
DROP FUNCTION public.is_med_exclusivo(med_id integer);
DROP FUNCTION public.get_cli_end(this_cpf_cliente character);
DROP FUNCTION public.get_cargo_func(cpf_func character);
DROP TYPE public.estado;
DROP TYPE public.cargo;
DROP EXTENSION btree_gist;
DROP EXTENSION plpgsql;
DROP SCHEMA public;
--
-- Name: public; Type: SCHEMA; Schema: -; Owner: postgres
--

CREATE SCHEMA public;


ALTER SCHEMA public OWNER TO postgres;

--
-- Name: SCHEMA public; Type: COMMENT; Schema: -; Owner: postgres
--

COMMENT ON SCHEMA public IS 'standard public schema';


--
-- Name: plpgsql; Type: EXTENSION; Schema: -; Owner: 
--

CREATE EXTENSION IF NOT EXISTS plpgsql WITH SCHEMA pg_catalog;


--
-- Name: EXTENSION plpgsql; Type: COMMENT; Schema: -; Owner: 
--

COMMENT ON EXTENSION plpgsql IS 'PL/pgSQL procedural language';


--
-- Name: btree_gist; Type: EXTENSION; Schema: -; Owner: 
--

CREATE EXTENSION IF NOT EXISTS btree_gist WITH SCHEMA public;


--
-- Name: EXTENSION btree_gist; Type: COMMENT; Schema: -; Owner: 
--

COMMENT ON EXTENSION btree_gist IS 'support for indexing common datatypes in GiST';


--
-- Name: cargo; Type: TYPE; Schema: public; Owner: anarcoqzn
--

CREATE TYPE public.cargo AS ENUM (
    'FARMACEUTICO',
    'ADMINISTRADOR',
    'VENDEDOR',
    'ENTREGADOR',
    'CAIXA'
);


ALTER TYPE public.cargo OWNER TO anarcoqzn;

--
-- Name: estado; Type: TYPE; Schema: public; Owner: anarcoqzn
--

CREATE TYPE public.estado AS ENUM (
    'AC',
    'AL',
    'AP',
    'AM',
    'BA',
    'CE',
    'ES',
    'DF',
    'GO',
    'MA',
    'MT',
    'MS',
    'MG',
    'PA',
    'PB',
    'PR',
    'PE',
    'PI',
    'RJ',
    'RN',
    'RS',
    'RO',
    'RR',
    'SC',
    'SP',
    'SE',
    'TO'
);


ALTER TYPE public.estado OWNER TO anarcoqzn;

--
-- Name: get_cargo_func(character); Type: FUNCTION; Schema: public; Owner: anarcoqzn
--

CREATE FUNCTION public.get_cargo_func(cpf_func character) RETURNS public.cargo
    LANGUAGE plpgsql
    AS $$
DECLARE
cargo_func CARGO;
BEGIN
SELECT INTO cargo_func cargo FROM FUNCIONARIOS WHERE cpf = cpf_func;
RETURN cargo_func;
END;
$$;


ALTER FUNCTION public.get_cargo_func(cpf_func character) OWNER TO anarcoqzn;

--
-- Name: get_cli_end(character); Type: FUNCTION; Schema: public; Owner: anarcoqzn
--

CREATE FUNCTION public.get_cli_end(this_cpf_cliente character) RETURNS integer
    LANGUAGE plpgsql
    AS $$
DECLARE
cli_endereco INTEGER;
BEGIN
SELECT INTO cli_endereco id FROM ENDERECO WHERE cpf_cliente = this_cpf_cliente;
RETURN cli_endereco;
END;
$$;


ALTER FUNCTION public.get_cli_end(this_cpf_cliente character) OWNER TO anarcoqzn;

--
-- Name: is_med_exclusivo(integer); Type: FUNCTION; Schema: public; Owner: anarcoqzn
--

CREATE FUNCTION public.is_med_exclusivo(med_id integer) RETURNS boolean
    LANGUAGE plpgsql
    AS $$
DECLARE
is_exclusivo BOOLEAN;
BEGIN
SELECT INTO is_exclusivo venda_exclusiva FROM MEDICAMENTOS WHERE id = med_id;
RETURN is_exclusivo;
END;
$$;


ALTER FUNCTION public.is_med_exclusivo(med_id integer) OWNER TO anarcoqzn;

SET default_tablespace = '';

SET default_with_oids = false;

--
-- Name: clientes; Type: TABLE; Schema: public; Owner: anarcoqzn
--

CREATE TABLE public.clientes (
    cpf character(11) NOT NULL,
    nome character varying(40) NOT NULL,
    data_nasc date NOT NULL,
    telefone character varying(15) NOT NULL,
    CONSTRAINT cpf_length CHECK ((length(cpf) = 11)),
    CONSTRAINT data_nasc_maior CHECK ((date_part('year'::text, age((data_nasc)::timestamp with time zone)) >= (18)::double precision))
);


ALTER TABLE public.clientes OWNER TO anarcoqzn;

--
-- Name: endereco; Type: TABLE; Schema: public; Owner: anarcoqzn
--

CREATE TABLE public.endereco (
    id integer NOT NULL,
    cpf_cliente character(11) NOT NULL,
    estado public.estado NOT NULL,
    cidade character varying(20) NOT NULL,
    bairro character varying(20) NOT NULL,
    rua character varying(20) NOT NULL,
    numero integer NOT NULL,
    tipo character varying(10) NOT NULL,
    CONSTRAINT tipo_chk CHECK ((((tipo)::text = 'RESIDENCIA'::text) OR ((tipo)::text = 'TRABALHO'::text) OR ((tipo)::text = 'OUTRO'::text)))
);


ALTER TABLE public.endereco OWNER TO anarcoqzn;

--
-- Name: endereco_id_seq; Type: SEQUENCE; Schema: public; Owner: anarcoqzn
--

CREATE SEQUENCE public.endereco_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.endereco_id_seq OWNER TO anarcoqzn;

--
-- Name: endereco_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: anarcoqzn
--

ALTER SEQUENCE public.endereco_id_seq OWNED BY public.endereco.id;


--
-- Name: entregas; Type: TABLE; Schema: public; Owner: anarcoqzn
--

CREATE TABLE public.entregas (
    id integer NOT NULL,
    cliente character(11) NOT NULL,
    funcionario character(11) NOT NULL,
    endereco integer NOT NULL,
    medicamento integer NOT NULL,
    CONSTRAINT entregas_chk_func_cargo CHECK ((public.get_cargo_func(funcionario) = 'ENTREGADOR'::public.cargo)),
    CONSTRAINT entregas_endereco_chk CHECK ((public.get_cli_end(cliente) IS NOT NULL))
);


ALTER TABLE public.entregas OWNER TO anarcoqzn;

--
-- Name: entregas_id_seq; Type: SEQUENCE; Schema: public; Owner: anarcoqzn
--

CREATE SEQUENCE public.entregas_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.entregas_id_seq OWNER TO anarcoqzn;

--
-- Name: entregas_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: anarcoqzn
--

ALTER SEQUENCE public.entregas_id_seq OWNED BY public.entregas.id;


--
-- Name: farmacia; Type: TABLE; Schema: public; Owner: anarcoqzn
--

CREATE TABLE public.farmacia (
    id integer NOT NULL,
    nome character varying(40) NOT NULL,
    estado public.estado NOT NULL,
    cidade character varying(40) NOT NULL,
    bairro character varying(40) NOT NULL,
    tipo character varying(6) NOT NULL,
    gerente character(11) NOT NULL,
    CONSTRAINT cargo_gerente_chk CHECK (((public.get_cargo_func(gerente) = 'FARMACEUTICO'::public.cargo) OR (public.get_cargo_func(gerente) = 'ADMINISTRADOR'::public.cargo))),
    CONSTRAINT tipo_chk CHECK ((((tipo)::text = 'SEDE'::text) OR ((tipo)::text = 'FILIAL'::text)))
);


ALTER TABLE public.farmacia OWNER TO anarcoqzn;

--
-- Name: farmacia_id_seq; Type: SEQUENCE; Schema: public; Owner: anarcoqzn
--

CREATE SEQUENCE public.farmacia_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.farmacia_id_seq OWNER TO anarcoqzn;

--
-- Name: farmacia_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: anarcoqzn
--

ALTER SEQUENCE public.farmacia_id_seq OWNED BY public.farmacia.id;


--
-- Name: funcionarios; Type: TABLE; Schema: public; Owner: anarcoqzn
--

CREATE TABLE public.funcionarios (
    cpf character(11) NOT NULL,
    nome character varying(40) NOT NULL,
    data_nasc date NOT NULL,
    cargo public.cargo NOT NULL,
    farmacia integer,
    CONSTRAINT cpf_length CHECK ((length(cpf) = 11))
);


ALTER TABLE public.funcionarios OWNER TO anarcoqzn;

--
-- Name: medicamentos; Type: TABLE; Schema: public; Owner: anarcoqzn
--

CREATE TABLE public.medicamentos (
    id integer NOT NULL,
    nome character varying(40) NOT NULL,
    data_validade date NOT NULL,
    venda_exclusiva boolean NOT NULL
);


ALTER TABLE public.medicamentos OWNER TO anarcoqzn;

--
-- Name: medicamentos_id_seq; Type: SEQUENCE; Schema: public; Owner: anarcoqzn
--

CREATE SEQUENCE public.medicamentos_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.medicamentos_id_seq OWNER TO anarcoqzn;

--
-- Name: medicamentos_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: anarcoqzn
--

ALTER SEQUENCE public.medicamentos_id_seq OWNED BY public.medicamentos.id;


--
-- Name: vendas; Type: TABLE; Schema: public; Owner: anarcoqzn
--

CREATE TABLE public.vendas (
    id integer NOT NULL,
    funcionario character(11) NOT NULL,
    medicamento integer NOT NULL,
    cliente character(11),
    data date NOT NULL,
    CONSTRAINT cargo_func_chk CHECK ((public.get_cargo_func(funcionario) = 'VENDEDOR'::public.cargo)),
    CONSTRAINT venda_medicamento_chk CHECK (((public.is_med_exclusivo(medicamento) AND (cliente IS NOT NULL)) OR (public.is_med_exclusivo(medicamento) = false)))
);


ALTER TABLE public.vendas OWNER TO anarcoqzn;

--
-- Name: vendas_id_seq; Type: SEQUENCE; Schema: public; Owner: anarcoqzn
--

CREATE SEQUENCE public.vendas_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.vendas_id_seq OWNER TO anarcoqzn;

--
-- Name: vendas_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: anarcoqzn
--

ALTER SEQUENCE public.vendas_id_seq OWNED BY public.vendas.id;


--
-- Name: id; Type: DEFAULT; Schema: public; Owner: anarcoqzn
--

ALTER TABLE ONLY public.endereco ALTER COLUMN id SET DEFAULT nextval('public.endereco_id_seq'::regclass);


--
-- Name: id; Type: DEFAULT; Schema: public; Owner: anarcoqzn
--

ALTER TABLE ONLY public.entregas ALTER COLUMN id SET DEFAULT nextval('public.entregas_id_seq'::regclass);


--
-- Name: id; Type: DEFAULT; Schema: public; Owner: anarcoqzn
--

ALTER TABLE ONLY public.farmacia ALTER COLUMN id SET DEFAULT nextval('public.farmacia_id_seq'::regclass);


--
-- Name: id; Type: DEFAULT; Schema: public; Owner: anarcoqzn
--

ALTER TABLE ONLY public.medicamentos ALTER COLUMN id SET DEFAULT nextval('public.medicamentos_id_seq'::regclass);


--
-- Name: id; Type: DEFAULT; Schema: public; Owner: anarcoqzn
--

ALTER TABLE ONLY public.vendas ALTER COLUMN id SET DEFAULT nextval('public.vendas_id_seq'::regclass);


--
-- Data for Name: clientes; Type: TABLE DATA; Schema: public; Owner: anarcoqzn
--



--
-- Data for Name: endereco; Type: TABLE DATA; Schema: public; Owner: anarcoqzn
--



--
-- Name: endereco_id_seq; Type: SEQUENCE SET; Schema: public; Owner: anarcoqzn
--

SELECT pg_catalog.setval('public.endereco_id_seq', 1, false);


--
-- Data for Name: entregas; Type: TABLE DATA; Schema: public; Owner: anarcoqzn
--



--
-- Name: entregas_id_seq; Type: SEQUENCE SET; Schema: public; Owner: anarcoqzn
--

SELECT pg_catalog.setval('public.entregas_id_seq', 1, false);


--
-- Data for Name: farmacia; Type: TABLE DATA; Schema: public; Owner: anarcoqzn
--



--
-- Name: farmacia_id_seq; Type: SEQUENCE SET; Schema: public; Owner: anarcoqzn
--

SELECT pg_catalog.setval('public.farmacia_id_seq', 6, true);


--
-- Data for Name: funcionarios; Type: TABLE DATA; Schema: public; Owner: anarcoqzn
--

INSERT INTO public.funcionarios (cpf, nome, data_nasc, cargo, farmacia) VALUES ('12345678900', 'joao da silva', '1980-07-15', 'FARMACEUTICO', NULL);


--
-- Data for Name: medicamentos; Type: TABLE DATA; Schema: public; Owner: anarcoqzn
--



--
-- Name: medicamentos_id_seq; Type: SEQUENCE SET; Schema: public; Owner: anarcoqzn
--

SELECT pg_catalog.setval('public.medicamentos_id_seq', 1, false);


--
-- Data for Name: vendas; Type: TABLE DATA; Schema: public; Owner: anarcoqzn
--



--
-- Name: vendas_id_seq; Type: SEQUENCE SET; Schema: public; Owner: anarcoqzn
--

SELECT pg_catalog.setval('public.vendas_id_seq', 1, false);


--
-- Name: clientes_pkey; Type: CONSTRAINT; Schema: public; Owner: anarcoqzn
--

ALTER TABLE ONLY public.clientes
    ADD CONSTRAINT clientes_pkey PRIMARY KEY (cpf);


--
-- Name: endereco_pkey; Type: CONSTRAINT; Schema: public; Owner: anarcoqzn
--

ALTER TABLE ONLY public.endereco
    ADD CONSTRAINT endereco_pkey PRIMARY KEY (id);


--
-- Name: entregas_pkey; Type: CONSTRAINT; Schema: public; Owner: anarcoqzn
--

ALTER TABLE ONLY public.entregas
    ADD CONSTRAINT entregas_pkey PRIMARY KEY (id);


--
-- Name: exclude_bairro; Type: CONSTRAINT; Schema: public; Owner: anarcoqzn
--

ALTER TABLE ONLY public.farmacia
    ADD CONSTRAINT exclude_bairro EXCLUDE USING gist (bairro WITH =, cidade WITH =);


--
-- Name: exclude_tipo; Type: CONSTRAINT; Schema: public; Owner: anarcoqzn
--

ALTER TABLE ONLY public.farmacia
    ADD CONSTRAINT exclude_tipo EXCLUDE USING gist (tipo WITH =) WHERE (((tipo)::text = 'SEDE'::text));


--
-- Name: farmacia_pkey; Type: CONSTRAINT; Schema: public; Owner: anarcoqzn
--

ALTER TABLE ONLY public.farmacia
    ADD CONSTRAINT farmacia_pkey PRIMARY KEY (id);


--
-- Name: funcionarios_pkey; Type: CONSTRAINT; Schema: public; Owner: anarcoqzn
--

ALTER TABLE ONLY public.funcionarios
    ADD CONSTRAINT funcionarios_pkey PRIMARY KEY (cpf);


--
-- Name: medicamentos_pkey; Type: CONSTRAINT; Schema: public; Owner: anarcoqzn
--

ALTER TABLE ONLY public.medicamentos
    ADD CONSTRAINT medicamentos_pkey PRIMARY KEY (id);


--
-- Name: vendas_pkey; Type: CONSTRAINT; Schema: public; Owner: anarcoqzn
--

ALTER TABLE ONLY public.vendas
    ADD CONSTRAINT vendas_pkey PRIMARY KEY (id);


--
-- Name: endereco_cpf_cliente_fkey; Type: FK CONSTRAINT; Schema: public; Owner: anarcoqzn
--

ALTER TABLE ONLY public.endereco
    ADD CONSTRAINT endereco_cpf_cliente_fkey FOREIGN KEY (cpf_cliente) REFERENCES public.clientes(cpf);


--
-- Name: entregas_cliente_fkey; Type: FK CONSTRAINT; Schema: public; Owner: anarcoqzn
--

ALTER TABLE ONLY public.entregas
    ADD CONSTRAINT entregas_cliente_fkey FOREIGN KEY (cliente) REFERENCES public.clientes(cpf);


--
-- Name: entregas_endereco_fkey; Type: FK CONSTRAINT; Schema: public; Owner: anarcoqzn
--

ALTER TABLE ONLY public.entregas
    ADD CONSTRAINT entregas_endereco_fkey FOREIGN KEY (endereco) REFERENCES public.endereco(id);


--
-- Name: entregas_funcionario_fkey; Type: FK CONSTRAINT; Schema: public; Owner: anarcoqzn
--

ALTER TABLE ONLY public.entregas
    ADD CONSTRAINT entregas_funcionario_fkey FOREIGN KEY (funcionario) REFERENCES public.funcionarios(cpf);


--
-- Name: entregas_medicamento_fkey; Type: FK CONSTRAINT; Schema: public; Owner: anarcoqzn
--

ALTER TABLE ONLY public.entregas
    ADD CONSTRAINT entregas_medicamento_fkey FOREIGN KEY (medicamento) REFERENCES public.medicamentos(id);


--
-- Name: farmacia_gerente_fkey; Type: FK CONSTRAINT; Schema: public; Owner: anarcoqzn
--

ALTER TABLE ONLY public.farmacia
    ADD CONSTRAINT farmacia_gerente_fkey FOREIGN KEY (gerente) REFERENCES public.funcionarios(cpf);


--
-- Name: funcionarios_farmacia_fkey; Type: FK CONSTRAINT; Schema: public; Owner: anarcoqzn
--

ALTER TABLE ONLY public.funcionarios
    ADD CONSTRAINT funcionarios_farmacia_fkey FOREIGN KEY (farmacia) REFERENCES public.farmacia(id);


--
-- Name: venda_cliente_fkey; Type: FK CONSTRAINT; Schema: public; Owner: anarcoqzn
--

ALTER TABLE ONLY public.vendas
    ADD CONSTRAINT venda_cliente_fkey FOREIGN KEY (cliente) REFERENCES public.clientes(cpf);


--
-- Name: venda_medicamento_fkey; Type: FK CONSTRAINT; Schema: public; Owner: anarcoqzn
--

ALTER TABLE ONLY public.vendas
    ADD CONSTRAINT venda_medicamento_fkey FOREIGN KEY (medicamento) REFERENCES public.medicamentos(id) ON DELETE RESTRICT;


--
-- Name: vendas_funcionario_fkey; Type: FK CONSTRAINT; Schema: public; Owner: anarcoqzn
--

ALTER TABLE ONLY public.vendas
    ADD CONSTRAINT vendas_funcionario_fkey FOREIGN KEY (funcionario) REFERENCES public.funcionarios(cpf) ON DELETE RESTRICT;


--
-- Name: SCHEMA public; Type: ACL; Schema: -; Owner: postgres
--

REVOKE ALL ON SCHEMA public FROM PUBLIC;
REVOKE ALL ON SCHEMA public FROM postgres;
GRANT ALL ON SCHEMA public TO postgres;
GRANT ALL ON SCHEMA public TO PUBLIC;


--
-- PostgreSQL database dump complete
--

