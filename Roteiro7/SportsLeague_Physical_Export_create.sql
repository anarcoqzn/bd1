-- Created by Vertabelo (http://vertabelo.com)
-- Last modification date: 2021-05-01 02:12:23.375

-- tables
-- Table: Equipe
CREATE TABLE Equipe (
    nome varchar(40)  NOT NULL,
    tecnico varchar(40)  NOT NULL,
    CONSTRAINT Equipe_pk PRIMARY KEY (nome)
);

-- Table: Jogador
CREATE TABLE Jogador (
    cpf char(11)  NOT NULL,
    nome varchar(40)  NULL,
    altura int  NULL,
    total_rebotes int  NULL,
    total_pontos int  NULL,
    total_assist int  NULL,
    CONSTRAINT Jogador_pk PRIMARY KEY (cpf)
);

-- Table: Participa
CREATE TABLE Participa (
    Jogador_cpf char(11)  NOT NULL,
    Partida_num int  NOT NULL,
    pontos int  NULL,
    rebotes int  NULL,
    assistencias int  NULL,
    posicao varchar(10)  NULL,
    CONSTRAINT Participa_pk PRIMARY KEY (Jogador_cpf,Partida_num)
);

-- Table: Partida
CREATE TABLE Partida (
    num int  NOT NULL,
    eqp1 varchar(40)  NOT NULL,
    eqp2 varchar(40)  NOT NULL,
    placar_eqp1 int  NOT NULL,
    placar_eqp2 int  NOT NULL,
    duracao time  NOT NULL,
    Equipe_nome varchar(40)  NOT NULL,
    CONSTRAINT Partida_pk PRIMARY KEY (num)
);

-- Table: Torneio
CREATE TABLE Torneio (
    nome varchar(40)  NOT NULL,
    CONSTRAINT Torneio_pk PRIMARY KEY (nome)
);

-- Table: Torneio_Partida
CREATE TABLE Torneio_Partida (
    Torneio_nome varchar(40)  NOT NULL,
    Partida_num int  NOT NULL,
    CONSTRAINT Torneio_Partida_pk PRIMARY KEY (Torneio_nome,Partida_num)
);

-- Table: contem
CREATE TABLE contem (
    Torneio_nome varchar(40)  NOT NULL,
    Equipe_nome varchar(40)  NOT NULL,
    classififcacao int  NOT NULL,
    chave char(1)  NOT NULL,
    CONSTRAINT contem_pk PRIMARY KEY (Torneio_nome,Equipe_nome)
);

-- Table: integra
CREATE TABLE integra (
    Jogador_cpf char(11)  NOT NULL,
    Equipe_nome varchar(40)  NOT NULL,
    CONSTRAINT integra_pk PRIMARY KEY (Jogador_cpf,Equipe_nome)
);

-- foreign keys
-- Reference: Equipe_Jogador (table: integra)
ALTER TABLE integra ADD CONSTRAINT Equipe_Jogador
    FOREIGN KEY (Equipe_nome)
    REFERENCES Equipe (nome)  
    NOT DEFERRABLE 
    INITIALLY IMMEDIATE
;

-- Reference: Equipe_Torneio (table: contem)
ALTER TABLE contem ADD CONSTRAINT Equipe_Torneio
    FOREIGN KEY (Equipe_nome)
    REFERENCES Equipe (nome)  
    NOT DEFERRABLE 
    INITIALLY IMMEDIATE
;

-- Reference: Jogador_Equipe (table: integra)
ALTER TABLE integra ADD CONSTRAINT Jogador_Equipe
    FOREIGN KEY (Jogador_cpf)
    REFERENCES Jogador (cpf)  
    NOT DEFERRABLE 
    INITIALLY IMMEDIATE
;

-- Reference: Jogador_Partida (table: Participa)
ALTER TABLE Participa ADD CONSTRAINT Jogador_Partida
    FOREIGN KEY (Jogador_cpf)
    REFERENCES Jogador (cpf)  
    NOT DEFERRABLE 
    INITIALLY IMMEDIATE
;

-- Reference: Partida_Equipe (table: Partida)
ALTER TABLE Partida ADD CONSTRAINT Partida_Equipe
    FOREIGN KEY (Equipe_nome)
    REFERENCES Equipe (nome)  
    NOT DEFERRABLE 
    INITIALLY IMMEDIATE
;

-- Reference: Partida_Jogador (table: Participa)
ALTER TABLE Participa ADD CONSTRAINT Partida_Jogador
    FOREIGN KEY (Partida_num)
    REFERENCES Partida (num)  
    NOT DEFERRABLE 
    INITIALLY IMMEDIATE
;

-- Reference: Torneio_Equipe (table: contem)
ALTER TABLE contem ADD CONSTRAINT Torneio_Equipe
    FOREIGN KEY (Torneio_nome)
    REFERENCES Torneio (nome)  
    NOT DEFERRABLE 
    INITIALLY IMMEDIATE
;

-- Reference: Torneio_Partida_Partida (table: Torneio_Partida)
ALTER TABLE Torneio_Partida ADD CONSTRAINT Torneio_Partida_Partida
    FOREIGN KEY (Partida_num)
    REFERENCES Partida (num)  
    NOT DEFERRABLE 
    INITIALLY IMMEDIATE
;

-- Reference: Torneio_Partida_Torneio (table: Torneio_Partida)
ALTER TABLE Torneio_Partida ADD CONSTRAINT Torneio_Partida_Torneio
    FOREIGN KEY (Torneio_nome)
    REFERENCES Torneio (nome)  
    NOT DEFERRABLE 
    INITIALLY IMMEDIATE
;

-- ALTER TABLES adicionados por mim.
ALTER TABLE PARTIDA ADD CONSTRAINT PARTIDA_EQUIPE_FK FOREIGN KEY (eqp1) REFERENCES EQUIPE(NOME);
ALTER TABLE PARTIDA ADD CONSTRAINT PARTIDA_EQUIPE2_FK FOREIGN KEY (eqp2) REFERENCES EQUIPE(NOME);
ALTER TABLE PARTIDA ADD CONSTRAINT EQUIPES_CHK CHECK (eqp1<>eqp2);
ALTER TABLE PARTIDA DROP COLUMN EQUIPE_NOME;

-- sequences
-- Sequence: Partida_seq
CREATE SEQUENCE Partida_seq
      INCREMENT BY 1
      NO MINVALUE
      NO MAXVALUE
      START WITH 1
      NO CYCLE
;

-- COMANDOS INSERT
INSERT INTO TORNEIO(nome) VALUES ('NBA');
INSERT INTO TORNEIO(nome) VALUES('OLIMPIADA');

INSERT INTO EQUIPE(nome, tecnico) VALUES('CHICAGO BULLS','FULANO');
INSERT INTO EQUIPE(nome, tecnico) VALUES('BOSTON CELTICS','CICRANO');
INSERT INTO EQUIPE(nome, tecnico) VALUES('ROCKET','JOAO');
INSERT INTO EQUIPE(nome, tecnico) VALUES('MIAMI HEAT','JOSE');
INSERT INTO EQUIPE(nome, tecnico) VALUES('SPURS','VANIA');

INSERT INTO JOGADOR(cpf, nome, altura) VALUES ('12345678910','SILVA', 189);
INSERT INTO JOGADOR(cpf, nome, altura) VALUES ('41310435057','Weoza', 189);
INSERT INTO JOGADOR(cpf, nome, altura) VALUES ('30613554051','Orins', 189);
INSERT INTO JOGADOR(cpf, nome, altura) VALUES ('52599824010','Waore', 189);
INSERT INTO JOGADOR(cpf, nome, altura) VALUES ('68235096005','Lixu', 189);
INSERT INTO JOGADOR(cpf, nome, altura) VALUES ('48667867012','Nouvu', 189);
INSERT INTO JOGADOR(cpf, nome, altura) VALUES ('49869039006','Rotai', 189);
INSERT INTO JOGADOR(cpf, nome, altura) VALUES ('86261653070','Muwau', 189);
INSERT INTO JOGADOR(cpf, nome, altura) VALUES ('12728762090','Invodye', 189);
INSERT INTO JOGADOR(cpf, nome, altura) VALUES ('65031940050','Tuilaypu', 189);
INSERT INTO JOGADOR(cpf, nome, altura) VALUES ('29301278057','Byubucya', 189);
INSERT INTO JOGADOR(cpf, nome, altura) VALUES ('01881943046','Mufos', 189);
INSERT INTO JOGADOR(cpf, nome, altura) VALUES ('07051386077','Seolamoa', 189);
INSERT INTO JOGADOR(cpf, nome, altura) VALUES ('92869117000','Puveu', 189);
INSERT INTO JOGADOR(cpf, nome, altura) VALUES ('22557178080','Miuwe', 189);
INSERT INTO JOGADOR(cpf, nome, altura) VALUES ('69614810009','Masyu', 189);
INSERT INTO JOGADOR(cpf, nome, altura) VALUES ('42860484035','Enfo', 189);
INSERT INTO JOGADOR(cpf, nome, altura) VALUES ('63399683090','Wauerr', 189);
INSERT INTO JOGADOR(cpf, nome, altura) VALUES ('68473243099','Onzay', 189);
INSERT INTO JOGADOR(cpf, nome, altura) VALUES ('52761268016','Liawo', 189);
INSERT INTO JOGADOR(cpf, nome, altura) VALUES ('33520162083','Tiaze', 189);
INSERT INTO JOGADOR(cpf, nome, altura) VALUES ('07058203008','Armar', 189);
INSERT INTO JOGADOR(cpf, nome, altura) VALUES ('48173822018','Zucewela', 189);
INSERT INTO JOGADOR(cpf, nome, altura) VALUES ('70861633091','Myaga', 189);
INSERT INTO JOGADOR(cpf, nome, altura) VALUES ('80706975049','Fediusir', 189);
INSERT INTO JOGADOR(cpf, nome, altura) VALUES ('73970380006','Cuias', 189);
INSERT INTO JOGADOR(cpf, nome, altura) VALUES ('11786610086','Faol', 189);
INSERT INTO JOGADOR(cpf, nome, altura) VALUES ('55337598082','Bekou', 189);
INSERT INTO JOGADOR(cpf, nome, altura) VALUES ('18290963033','Xozari', 189);
INSERT INTO JOGADOR(cpf, nome, altura) VALUES ('00864659024','Riopi', 189);
INSERT INTO JOGADOR(cpf, nome, altura) VALUES ('30011900008','Cyumey', 189);
INSERT INTO JOGADOR(cpf, nome, altura) VALUES ('17840069045','Geaxar', 189);
INSERT INTO JOGADOR(cpf, nome, altura) VALUES ('87837567013','Tiobe', 189);
INSERT INTO JOGADOR(cpf, nome, altura) VALUES ('56290035002','Zoike', 189);
INSERT INTO JOGADOR(cpf, nome, altura) VALUES ('35345088071','Unbegu', 189);
INSERT INTO JOGADOR(cpf, nome, altura) VALUES ('26030741055','Dulyo', 189);
INSERT INTO JOGADOR(cpf, nome, altura) VALUES ('46428413000','Waebo', 189);
INSERT INTO JOGADOR(cpf, nome, altura) VALUES ('19189178092','Duaes', 189);

INSERT INTO INTEGRA(jogador_cpf, equipe_nome) VALUES('12345678910','CHICAGO BULLS');
INSERT INTO INTEGRA(jogador_cpf, equipe_nome) VALUES('41310435057','CHICAGO BULLS');
INSERT INTO INTEGRA(jogador_cpf, equipe_nome) VALUES('30613554051','CHICAGO BULLS');
INSERT INTO INTEGRA(jogador_cpf, equipe_nome) VALUES('52599824010','CHICAGO BULLS');
INSERT INTO INTEGRA(jogador_cpf, equipe_nome) VALUES('68235096005','CHICAGO BULLS');
INSERT INTO INTEGRA(jogador_cpf, equipe_nome) VALUES('48667867012','CHICAGO BULLS');
INSERT INTO INTEGRA(jogador_cpf, equipe_nome) VALUES('49869039006','BOSTON CELTICS');
INSERT INTO INTEGRA(jogador_cpf, equipe_nome) VALUES('86261653070','BOSTON CELTICS');
INSERT INTO INTEGRA(jogador_cpf, equipe_nome) VALUES('12728762090','BOSTON CELTICS');
INSERT INTO INTEGRA(jogador_cpf, equipe_nome) VALUES('65031940050','BOSTON CELTICS');
INSERT INTO INTEGRA(jogador_cpf, equipe_nome) VALUES('29301278057','BOSTON CELTICS');
INSERT INTO INTEGRA(jogador_cpf, equipe_nome) VALUES('01881943046','BOSTON CELTICS');
INSERT INTO INTEGRA(jogador_cpf, equipe_nome) VALUES('07051386077','ROCKET');
INSERT INTO INTEGRA(jogador_cpf, equipe_nome) VALUES('92869117000','ROCKET');
INSERT INTO INTEGRA(jogador_cpf, equipe_nome) VALUES('22557178080','ROCKET');
INSERT INTO INTEGRA(jogador_cpf, equipe_nome) VALUES('69614810009','ROCKET');
INSERT INTO INTEGRA(jogador_cpf, equipe_nome) VALUES('42860484035','ROCKET');
INSERT INTO INTEGRA(jogador_cpf, equipe_nome) VALUES('63399683090','ROCKET');
INSERT INTO INTEGRA(jogador_cpf, equipe_nome) VALUES('68473243099','MIAMI HEAT');
INSERT INTO INTEGRA(jogador_cpf, equipe_nome) VALUES('52761268016','MIAMI HEAT');
INSERT INTO INTEGRA(jogador_cpf, equipe_nome) VALUES('33520162083','MIAMI HEAT');
INSERT INTO INTEGRA(jogador_cpf, equipe_nome) VALUES('07058203008','MIAMI HEAT');
INSERT INTO INTEGRA(jogador_cpf, equipe_nome) VALUES('48173822018','MIAMI HEAT');
INSERT INTO INTEGRA(jogador_cpf, equipe_nome) VALUES('70861633091','MIAMI HEAT');
INSERT INTO INTEGRA(jogador_cpf, equipe_nome) VALUES('80706975049','SPURS');
INSERT INTO INTEGRA(jogador_cpf, equipe_nome) VALUES('73970380006','SPURS');
INSERT INTO INTEGRA(jogador_cpf, equipe_nome) VALUES('11786610086','SPURS');
INSERT INTO INTEGRA(jogador_cpf, equipe_nome) VALUES('55337598082','SPURS');
INSERT INTO INTEGRA(jogador_cpf, equipe_nome) VALUES('18290963033','SPURS');
INSERT INTO INTEGRA(jogador_cpf, equipe_nome) VALUES('00864659024','SPURS');
INSERT INTO INTEGRA(jogador_cpf, equipe_nome) VALUES('30011900008','SPURS');
INSERT INTO INTEGRA(jogador_cpf, equipe_nome) VALUES('17840069045','SPURS');
INSERT INTO INTEGRA(jogador_cpf, equipe_nome) VALUES('87837567013','BOSTON CELTICS');
INSERT INTO INTEGRA(jogador_cpf, equipe_nome) VALUES('56290035002','BOSTON CELTICS');
INSERT INTO INTEGRA(jogador_cpf, equipe_nome) VALUES('35345088071','MIAMI HEAT');
INSERT INTO INTEGRA(jogador_cpf, equipe_nome) VALUES('26030741055','MIAMI HEAT');
INSERT INTO INTEGRA(jogador_cpf, equipe_nome) VALUES('46428413000','BOSTON CELTICS');
INSERT INTO INTEGRA(jogador_cpf, equipe_nome) VALUES('19189178092','BOSTON CELTICS');
INSERT INTO INTEGRA(jogador_cpf, equipe_nome) VALUES('12345678910','CHICAGO BULLS');
INSERT INTO INTEGRA(jogador_cpf, equipe_nome) VALUES('41310435057','CHICAGO BULLS');
INSERT INTO INTEGRA(jogador_cpf, equipe_nome) VALUES('30613554051','CHICAGO BULLS');
INSERT INTO INTEGRA(jogador_cpf, equipe_nome) VALUES('52599824010','CHICAGO BULLS');
INSERT INTO INTEGRA(jogador_cpf, equipe_nome) VALUES('68235096005','CHICAGO BULLS');
INSERT INTO INTEGRA(jogador_cpf, equipe_nome) VALUES('48667867012','CHICAGO BULLS');
INSERT INTO INTEGRA(jogador_cpf, equipe_nome) VALUES('49869039006','BOSTON CELTICS');
INSERT INTO INTEGRA(jogador_cpf, equipe_nome) VALUES('86261653070','BOSTON CELTICS');
INSERT INTO INTEGRA(jogador_cpf, equipe_nome) VALUES('12728762090','BOSTON CELTICS');
INSERT INTO INTEGRA(jogador_cpf, equipe_nome) VALUES('65031940050','BOSTON CELTICS');
INSERT INTO INTEGRA(jogador_cpf, equipe_nome) VALUES('29301278057','BOSTON CELTICS');
INSERT INTO INTEGRA(jogador_cpf, equipe_nome) VALUES('01881943046','BOSTON CELTICS');
INSERT INTO INTEGRA(jogador_cpf, equipe_nome) VALUES('07051386077','ROCKET');
INSERT INTO INTEGRA(jogador_cpf, equipe_nome) VALUES('92869117000','ROCKET');
INSERT INTO INTEGRA(jogador_cpf, equipe_nome) VALUES('22557178080','ROCKET');
INSERT INTO INTEGRA(jogador_cpf, equipe_nome) VALUES('69614810009','ROCKET');
INSERT INTO INTEGRA(jogador_cpf, equipe_nome) VALUES('42860484035','ROCKET');
INSERT INTO INTEGRA(jogador_cpf, equipe_nome) VALUES('63399683090','ROCKET');
INSERT INTO INTEGRA(jogador_cpf, equipe_nome) VALUES('68473243099','MIAMI HEAT');
INSERT INTO INTEGRA(jogador_cpf, equipe_nome) VALUES('52761268016','MIAMI HEAT');
INSERT INTO INTEGRA(jogador_cpf, equipe_nome) VALUES('33520162083','MIAMI HEAT');
INSERT INTO INTEGRA(jogador_cpf, equipe_nome) VALUES('07058203008','MIAMI HEAT');
INSERT INTO INTEGRA(jogador_cpf, equipe_nome) VALUES('48173822018','MIAMI HEAT');
INSERT INTO INTEGRA(jogador_cpf, equipe_nome) VALUES('70861633091','MIAMI HEAT');
INSERT INTO INTEGRA(jogador_cpf, equipe_nome) VALUES('80706975049','SPURS');
INSERT INTO INTEGRA(jogador_cpf, equipe_nome) VALUES('73970380006','SPURS');
INSERT INTO INTEGRA(jogador_cpf, equipe_nome) VALUES('11786610086','SPURS');
INSERT INTO INTEGRA(jogador_cpf, equipe_nome) VALUES('55337598082','SPURS');
INSERT INTO INTEGRA(jogador_cpf, equipe_nome) VALUES('18290963033','SPURS');
INSERT INTO INTEGRA(jogador_cpf, equipe_nome) VALUES('00864659024','SPURS');
INSERT INTO INTEGRA(jogador_cpf, equipe_nome) VALUES('30011900008','SPURS');
INSERT INTO INTEGRA(jogador_cpf, equipe_nome) VALUES('17840069045','SPURS');
INSERT INTO INTEGRA(jogador_cpf, equipe_nome) VALUES('87837567013','BOSTON CELTICS');
INSERT INTO INTEGRA(jogador_cpf, equipe_nome) VALUES('56290035002','BOSTON CELTICS');
INSERT INTO INTEGRA(jogador_cpf, equipe_nome) VALUES('35345088071','MIAMI HEAT');
INSERT INTO INTEGRA(jogador_cpf, equipe_nome) VALUES('26030741055','MIAMI HEAT');
INSERT INTO INTEGRA(jogador_cpf, equipe_nome) VALUES('46428413000','BOSTON CELTICS');
INSERT INTO INTEGRA(jogador_cpf, equipe_nome) VALUES('19189178092','BOSTON CELTICS');

INSERT INTO CONTEM(torneio_nome,equipe_nome,classififcacao, chave) VALUES('NBA','CHICAGO BULLS',1,'A');
INSERT INTO CONTEM(torneio_nome,equipe_nome,classififcacao, chave) VALUES('NBA','BOSTON CELTICS'2,'A');
INSERT INTO CONTEM(torneio_nome,equipe_nome,classififcacao, chave) VALUES('NBA','MIAMI HEAT',3,'A');
INSERT INTO CONTEM(torneio_nome,equipe_nome,classififcacao, chave) VALUES('NBA','SPURS',4,'A');
INSERT INTO CONTEM(torneio_nome,equipe_nome,classififcacao, chave) VALUES('NBA','ROCKET'5,'A');
INSERT INTO CONTEM(torneio_nome,equipe_nome,classififcacao, chave) VALUES('OLIMPIADAS','CHICAGO BULLS',3,'A');
INSERT INTO CONTEM(torneio_nome,equipe_nome,classififcacao, chave) VALUES('OLIMPIADAS','BOSTON CELTICS',1,'A');
INSERT INTO CONTEM(torneio_nome,equipe_nome,classififcacao, chave) VALUES('OLIMPIADAS','MIAMI HEAT',5,'A');
INSERT INTO CONTEM(torneio_nome,equipe_nome,classififcacao, chave) VALUES('OLIMPIADAS','SPURS',4,'A');
INSERT INTO CONTEM(torneio_nome,equipe_nome,classififcacao, chave) VALUES('OLIMPIADAS','ROCKET',2,'A');

INSERT INTO PARTIDA(num, eqp1, eqp2, placar_eqp1, placar_eqp2, duracao) VALUES(0,'CHICAGO BULLS','ROCKET',80,90,'2016-06-22 19:10:25-07');
INSERT INTO PARTIDA(num, eqp1, eqp2, placar_eqp1, placar_eqp2, duracao) VALUES(1,'BOSTON CELTICS','SPURS',110,95,'2016-06-22 19:10:25-07');
INSERT INTO PARTIDA(num, eqp1, eqp2, placar_eqp1, placar_eqp2, duracao) VALUES(2,'MIAMI HEAT','BOSTON CELTICS',70,85,'2016-06-22 19:10:25-07');
INSERT INTO PARTIDA(num, eqp1, eqp2, placar_eqp1, placar_eqp2, duracao) VALUES(3,'SPURS','CHICAGO BULLS',98,84,'2016-06-22 19:10:25-07');
INSERT INTO PARTIDA(num, eqp1, eqp2, placar_eqp1, placar_eqp2, duracao) VALUES(4,'ROCKET','MIAMI HEAT',64,120,'2016-06-22 19:10:25-07');

INSERT INTO PARTICIPA(jogador_cpf,partida_num,pontos,rebotes,assistencias,posicao) VALUES ('55337598082',0,7,3,0,'armador');
INSERT INTO PARTICIPA(jogador_cpf,partida_num,pontos,rebotes,assistencias,posicao) VALUES ('18290963033',1,26,5,5,'armador');
INSERT INTO PARTICIPA(jogador_cpf,partida_num,pontos,rebotes,assistencias,posicao) VALUES ('00864659024',2,10,8,6,'pivo');
INSERT INTO PARTICIPA(jogador_cpf,partida_num,pontos,rebotes,assistencias,posicao) VALUES ('30011900008',3,25,20,4,'pivo');
INSERT INTO PARTICIPA(jogador_cpf,partida_num,pontos,rebotes,assistencias,posicao) VALUES ('17840069045',4,8,10,8,'ala');
INSERT INTO PARTICIPA(jogador_cpf,partida_num,pontos,rebotes,assistencias,posicao) VALUES ('87837567013',0,4,14,7,'armador');
INSERT INTO PARTICIPA(jogador_cpf,partida_num,pontos,rebotes,assistencias,posicao) VALUES ('56290035002',1,6,9,9,'armador');
INSERT INTO PARTICIPA(jogador_cpf,partida_num,pontos,rebotes,assistencias,posicao) VALUES ('35345088071',2,5,6,10,'pivo');
INSERT INTO PARTICIPA(jogador_cpf,partida_num,pontos,rebotes,assistencias,posicao) VALUES ('26030741055',3,12,16,15,'ala-pivo');
INSERT INTO PARTICIPA(jogador_cpf,partida_num,pontos,rebotes,assistencias,posicao) VALUES ('46428413000',4,10,6,4,'ala-pivo');
INSERT INTO PARTICIPA(jogador_cpf,partida_num,pontos,rebotes,assistencias,posicao) VALUES ('19189178092',0,20,14,5,'ALA');

INSERT INTO TORNEIO_PARTIDA(Torneio_nome, partida_num) VALUES('NBA',0);
INSERT INTO TORNEIO_PARTIDA(Torneio_nome, partida_num) VALUES('NBA',1);
INSERT INTO TORNEIO_PARTIDA(Torneio_nome, partida_num) VALUES('NBA',2);
INSERT INTO TORNEIO_PARTIDA(Torneio_nome, partida_num) VALUES('OLIMPIADAS',3);
INSERT INTO TORNEIO_PARTIDA(Torneio_nome, partida_num) VALUES('OLIMPIADAS',4);
-- End of file.

