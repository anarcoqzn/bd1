CREATE TYPE ESTADO AS ENUM('AC', 'AL', 'AP','AM', 'BA','CE', 'ES','DF', 'GO', 'MA', 'MT','MS','MG','PA','PB','PR','PE','PI'
		 	   ,'RJ','RN','RS','RO','RR','SC','SP','SE','TO');

CREATE TYPE CARGO AS ENUM('FARMACEUTICO','ADMINISTRADOR','VENDEDOR','ENTREGADOR','CAIXA');


CREATE TABLE CLIENTES(
	cpf CHAR(11),
	nome VARCHAR(40) NOT NULL,
	data_nasc DATE NOT NULL,
	telefone VARCHAR(15) NOT NULL,
	CONSTRAINT CLIENTES_PKEY PRIMARY KEY (cpf),
	CONSTRAINT CPF_LENGTH CHECK(length(cpf)=11),
	CONSTRAINT DATA_NASC_MAIOR CHECK(extract(YEAR FROM age(data_nasc)) >= 18));

CREATE TABLE ENDERECO(
	id SERIAL,
	cpf_cliente CHAR(11) NOT NULL,
	estado ESTADO NOT NULL,
	cidade VARCHAR(20) NOT NULL,
	bairro VARCHAR(20) NOT NULL,
	rua VARCHAR(20) NOT NULL,
	numero INTEGER NOT NULL,
	tipo VARCHAR(10) NOT NULL,
	CONSTRAINT ENDERECO_PKEY PRIMARY KEY (id),
	CONSTRAINT ENDERECO_CPF_CLIENTE_FKEY FOREIGN KEY (cpf_cliente) REFERENCES CLIENTES(cpf),
	CONSTRAINT TIPO_CHK CHECK(tipo='RESIDENCIA' OR tipo='TRABALHO' OR TIPO='OUTRO'));

CREATE TABLE MEDICAMENTOS(
	id SERIAL,
	nome VARCHAR(40) NOT NULL,
	data_validade DATE NOT NULL,
	venda_exclusiva BOOLEAN NOT NULL,
	CONSTRAINT MEDICAMENTOS_PKEY PRIMARY KEY (id));

CREATE TABLE FARMACIA(                                                                                          
	id SERIAL,
	nome VARCHAR(40) NOT NULL,
	estado ESTADO NOT NULL,
	cidade VARCHAR(40) NOT NULL,
	bairro VARCHAR(40) NOT NULL,
	tipo VARCHAR(6) NOT NULL,
	CONSTRAINT FARMACIA_PKEY PRIMARY KEY (id),
	CONSTRAINT TIPO_CHK CHECK(tipo = 'SEDE' or tipo = 'FILIAL'),
	CONSTRAINT EXCLUDE_BAIRRO EXCLUDE USING gist(bairro WITH = , cidade WITH =),
	CONSTRAINT EXCLUDE_TIPO EXCLUDE USING gist(tipo WITH =) WHERE(tipo='SEDE'));

CREATE TABLE FUNCIONARIOS(
	cpf CHAR(11),
	nome VARCHAR(40) NOT NULL,
	data_nasc DATE NOT NULL,
	cargo CARGO NOT NULL,
	farmacia INTEGER ,
	CONSTRAINT FUNCIONARIOS_PKEY PRIMARY KEY (cpf),
	CONSTRAINT CPF_LENGTH CHECK(length(cpf)=11),
	CONSTRAINT FUNCIONARIOS_FARMACIA_FKEY FOREIGN KEY (farmacia) REFERENCES FARMACIA(id));

CREATE FUNCTION get_cargo_func(cpf_func CHAR(11))
	RETURNS CARGO
	LANGUAGE plpgsql
	AS
	$$
	DECLARE
		cargo_func CARGO;
	BEGIN
		SELECT INTO cargo_func cargo FROM FUNCIONARIOS WHERE cpf = cpf_func;
		RETURN cargo_func;
	END;
	$$;

ALTER TABLE FARMACIA ADD COLUMN gerente CHAR(11) NOT NULL REFERENCES FUNCIONARIOS(cpf);
ALTER TABLE FARMACIA ADD CONSTRAINT cargo_gerente_chk CHECK(get_cargo_func(gerente)='FARMACEUTICO' OR get_cargo_func(gerente)='ADMINISTRADOR');

CREATE FUNCTION is_med_exclusivo(med_id INTEGER)
	RETURNS BOOLEAN
	LANGUAGE plpgsql
	AS
	$$
	DECLARE
		is_exclusivo BOOLEAN;
	BEGIN
		SELECT INTO is_exclusivo venda_exclusiva FROM MEDICAMENTOS WHERE id = med_id;
		RETURN is_exclusivo;
	END;
	$$;

CREATE TABLE VENDAS(
	id SERIAL,
	funcionario CHAR(11) NOT NULL,
	medicamento INTEGER NOT NULL,
	cliente CHAR(11),
	data DATE NOT NULL,
	CONSTRAINT VENDAS_PKEY PRIMARY KEY (id),
	CONSTRAINT VENDAS_FUNCIONARIO_FKEY FOREIGN KEY (funcionario) REFERENCES FUNCIONARIOS(cpf) ON DELETE RESTRICT,
	CONSTRAINT VENDA_MEDICAMENTO_FKEY FOREIGN KEY (medicamento) REFERENCES MEDICAMENTOS(id) ON DELETE RESTRICT,
	CONSTRAINT VENDA_CLIENTE_FKEY FOREIGN KEY (cliente) REFERENCES CLIENTES(cpf),
	CONSTRAINT CARGO_FUNC_CHK CHECK(get_cargo_func(funcionario)='VENDEDOR'),
	CONSTRAINT VENDA_MEDICAMENTO_CHK CHECK((is_med_exclusivo(medicamento) AND cliente IS NOT NULL) OR is_med_exclusivo(medicamento)=false));

CREATE FUNCTION get_cli_end(this_cpf_cliente CHAR(11))
	RETURNS INTEGER
	LANGUAGE plpgsql
	AS
	$$
	DECLARE
		cli_endereco INTEGER;
	BEGIN
		SELECT INTO cli_endereco id FROM ENDERECO WHERE cpf_cliente = this_cpf_cliente;
		RETURN cli_endereco;
	END;
	$$;

CREATE TABLE ENTREGAS(
	id SERIAL,
	cliente CHAR(11) NOT NULL,
	funcionario CHAR(11) NOT NULL,
	endereco INTEGER NOT NULL,
	medicamento INTEGER NOT NULL,
	CONSTRAINT ENTREGAS_PKEY PRIMARY KEY (id),
	CONSTRAINT ENTREGAS_CLIENTE_FKEY FOREIGN KEY (cliente) REFERENCES CLIENTES(cpf),
	CONSTRAINT ENTREGAS_FUNCIONARIO_FKEY FOREIGN KEY (funcionario) REFERENCES FUNCIONARIOS(cpf),
	CONSTRAINT ENTREGAS_ENDERECO_FKEY FOREIGN KEY (endereco) REFERENCES ENDERECO(id),
	CONSTRAINT ENTREGAS_MEDICAMENTO_FKEY FOREIGN KEY (medicamento) REFERENCES MEDICAMENTOS(id),
	CONSTRAINT ENTREGAS_CHK_FUNC_CARGO CHECK(get_cargo_func(funcionario)='ENTREGADOR'),
	CONSTRAINT ENTREGAS_ENDERECO_CHK CHECK(get_cli_end(cliente) IS NOT NULL));



































	
	
