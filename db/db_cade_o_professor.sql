CREATE DATABASE cade_o_professor CHARACTER SET utf8 COLLATE utf8_general_ci;

CREATE TABLE `alunos` (
	`id_aluno` INT NOT NULL AUTO_INCREMENT,
	`nome` varchar(200) NOT NULL,
	`email` varchar(200) NOT NULL UNIQUE,
	`senha` varchar(32) NOT NULL,
	`token` varchar(32),
	PRIMARY KEY (`id_aluno`)
);

CREATE TABLE `professores` (
	`id_professor` INT NOT NULL AUTO_INCREMENT,
	`nome_professor` varchar(200) NOT NULL,
	`email` varchar(200) NOT NULL,
	`status` enum("ausente", "presente", "em_aula" ) DEFAULT "ausente",
	`senha` varchar(32) NOT NULL,
	`token` varchar(32) NOT NULL,
	PRIMARY KEY (`id_professor`)
);

CREATE TABLE `disciplinas` (
	`id_disciplina` INT NOT NULL AUTO_INCREMENT,
	`nome_disciplina` varchar(200) NOT NULL,
	`descricao` varchar(2000),
	PRIMARY KEY (`id_disciplina`)
);

CREATE TABLE `segue` (
	`fk_turma` INT NOT NULL,
	`fk_aluno` INT NOT NULL,
	PRIMARY KEY (`fk_turma`,`fk_aluno`)
);

CREATE TABLE `horarios` (
	`id_horario` INT AUTO_INCREMENT NOT NULL,
	`fk_turma` INT NOT NULL,
	`dia_semana` varchar(30) NOT NULL,
	`hora` TIME NOT NULL,
	PRIMARY KEY (`id_horario`)

);

CREATE TABLE `alteracao_sala` (
	`fk_professor` INT NOT NULL,
	`fk_turma` INT NOT NULL,
	`data` TIMESTAMP NOT NULL,
	`bloco` varchar(5) NOT NULL,
	`sala` INT NOT NULL
);

CREATE TABLE `turmas` (
	`id_turma` INT NOT NULL AUTO_INCREMENT,
	`fk_professor` INT NOT NULL,
	`fk_disciplina` INT NOT NULL,
	`bloco` varchar(5) NOT NULL,
	`sala` INT NOT NULL,
	PRIMARY KEY (`id_turma`)
);

ALTER TABLE `segue` 		 ADD CONSTRAINT `segue_fk0` FOREIGN KEY (`fk_turma`) REFERENCES `turmas`(`id_turma`);
ALTER TABLE `segue` 		 ADD CONSTRAINT `segue_fk1` FOREIGN KEY (`fk_aluno`) REFERENCES `alunos`(`id_aluno`);
ALTER TABLE `horarios` 		 ADD CONSTRAINT `horarios_fk0` FOREIGN KEY (`fk_turma`) REFERENCES `disciplinas`(`id_disciplina`);
ALTER TABLE `alteracao_sala` ADD CONSTRAINT `alteracao_sala_fk0` FOREIGN KEY (`fk_professor`) REFERENCES `professores`(`id_professor`);
ALTER TABLE `alteracao_sala` ADD CONSTRAINT `alteracao_sala_fk1` FOREIGN KEY (`fk_turma`) REFERENCES `turmas`(`id_turma`);
ALTER TABLE `turmas` ADD CONSTRAINT `turma_fk0` FOREIGN KEY (`fk_professor`) REFERENCES `professores`(`id_professor`);
ALTER TABLE `turmas` ADD CONSTRAINT `turma_fk1` FOREIGN KEY (`fk_disciplina`) REFERENCES `disciplinas`(`id_disciplina`);

-- inserts demo

-- Alunos
INSERT INTO alunos(id_aluno, nome, email, senha, token) VALUES 
(DEFAULT, "Glauber Gonçalves", "glauber@mail.com.br", "123456","abcdef"),
(DEFAULT, "Tiago Ramos", "tiago@mail.com.br", "123456","abcdef"),
(DEFAULT, "Felipe Felix", "felipe@mail.com.br", "123456","abcdef"),
(DEFAULT, "Anderson Printes", "printes@mail.com.br", "123456","abcdef"),
(DEFAULT, "Juliana Gomes", "juliana@mail.com.br", "123456","abcdef"),
(DEFAULT, "Kezia Souza", "kezia@mail.com.br", "123456","abcdef"),
(DEFAULT, "Mark Gozz", "mark@mail.com.br", "123456","abcdef"),
(DEFAULT, "Amanda Albuquerque", "amanda@mail.com.br", "123456","abcdef"),
(DEFAULT, "Patricia Souza", "patricia@mail.com.br", "123456","abcdef"),
(DEFAULT, "Marcos Liz", "marcos@mail.com.br", "123456","abcdef");

-- Professores
INSERT INTO `professores` (id_professor, nome_professor, email, senha, token) VALUES
(DEFAULT, "Fabio",    "fabio@mail.com.br", 		"123456","abcdef"),
(DEFAULT, "Robaina",  "Robaina@mail.com.br", 	"123456","abcdef"),
(DEFAULT, "Mario",    "Mario@mail.com.br", 		"123456","abcdef"),
(DEFAULT, "Julio",    "julio@mail.com.br", 		"123456","abcdef"),
(DEFAULT, "Patrique", "patrique@mail.com.br", 	"123456","abcdef"),
(DEFAULT, "Claudia",  "claudia@mail.com.br", 	"123456","abcdef"),
(DEFAULT, "Amanda",   "amanda@mail.com.br", 	"123456","abcdef"),
(DEFAULT, "Leia",     "leia@mail.com.br", 		"123456","abcdef"),
(DEFAULT, "Joice",    "joicea@mail.com.br", 	"123456","abcdef"),
(DEFAULT, "Patricia", "patricia@mail.com.br", 	"123456","abcdef");

-- Disciplinas

INSERT INTO `disciplinas` (id_disciplina, nome_disciplina, descricao) VALUES 
(DEFAULT, "POO", "Programação Orientada a Objetos é um modelo de análise, projeto e programação de software baseado na composição e interação entre diversas unidades chamadas de 'objetos'. A POO é um dos 4 principais paradigmas de programação."),
(DEFAULT, "Estatistica", "Estatística é a ciência que utiliza-se das teorias probabilísticas para explicar a frequência da ocorrência de eventos, tanto em estudos observacionais quanto em experimentos para modelar a aleatoriedade e a incerteza de forma a estimar ou possibilitar a previsão de fenômenos futuros, conforme o caso."),
(DEFAULT, "Engenharia de Software", "Engenharia de software é uma área da computação voltada à especificação, desenvolvimento, manutenção e criação de software, com a aplicação de tecnologias e práticas de gerência de projetos e outras disciplinas, visando organização, produtividade e qualidade."),
(DEFAULT, "Estrutura de dados", "Estrutura de dados é o ramo da computação que estuda os diversos mecanismos de organização de dados para atender aos diferentes requisitos de processamento. "),
(DEFAULT, "Calculo I", "O cálculo diferencial e integral, ou simplesmente cálculo, é um ramo importante da matemática, desenvolvido a partir da Álgebra e da Geometria, que se dedica ao estudo de taxas de variação de grandezas e a acumulação de quantidades"),
(DEFAULT, "Banco de dados", "Bancos de dados ou bases de dados são um conjunto de arquivos relacionados entre si com registros sobre pessoas, lugares ou coisas. "),
(DEFAULT, "Gerencia de Projetos", "Gerenciamento de projetos é a aplicação de conhecimentos, habilidades, ferramentas e técnicas às atividades do projeto a fim de atender aos seus requisitos"),
(DEFAULT, "Programação de Computadores", "Programação é o processo de escrita, teste e manutenção de um programa de computador. O programa é escrito em uma linguagem de programação, embora seja possível, com alguma dificuldade, escrevê-lo diretamente em linguagem de máquina. Diferentes partes de um programa podem ser escritas em diferentes linguagens."),
(DEFAULT, "Análise de Sistemas", "Análise de sistemas é a atividade que tem como finalidade a realização de estudos de processos a fim de encontrar o melhor caminho racional para que a informação possa ser processada."),
(DEFAULT, "Sistemas distribuidos", "Os sistemas distribuídos estão em todo o lugar, ou melhor, acessíveis a partir de qualquer lugar. Segundo Tanenbaum, um sistema distribuído é um conjunto de computadores independentes entre si (e até diferentes), ligados através de uma rede de dados, que se apresentam aos utilizadores como um sistema único e coerente.");


-- Disciplina X Professor

INSERT INTO `turmas` (id_turma, fk_professor, fk_disciplina, bloco, sala) VALUES 
(DEFAULT, 1 , 1 ,  "A", 412),
(DEFAULT, 2 , 2 ,  "A", 512),
(DEFAULT, 3 , 3 ,  "A", 612),
(DEFAULT, 4 , 4 ,  "A", 712),
(DEFAULT, 5 , 5 ,  "A", 812),
(DEFAULT, 6 , 6 ,  "B", 1010),
(DEFAULT, 7 , 7 ,  "B", 1011),
(DEFAULT, 8 , 8 ,  "B", 1012),
(DEFAULT, 9 , 9 ,  "B", 1013),
(DEFAULT, 10 , 10, "B", 1014);


-- Aluno seguindo disciplina

INSERT INTO `segue` (fk_turma, fk_aluno) VALUES 
(1, 1),
(1, 2),
(1, 3),

(2, 4),
(2, 5),
(2, 6),

(3, 7),
(3, 8),
(3, 9);

-- horarios x disciplina
INSERT INTO `horarios`(`id_horario`, `fk_turma`, `dia_semana`, `hora`) VALUES 
(DEFAULT, 1,"Segunda-Feira","18:20:00"),
(DEFAULT,1,"Segunda-Feira","19:10:00"),
(DEFAULT,1,"Terça-Feira"  ,"20:20:00"),
(DEFAULT,2,"Sexta-Feira"  ,"20:20:00"),
(DEFAULT,2,"Sexta-Feira"  ,"21:10:00"),
(DEFAULT,3,"Quinta-Feira" ,"18:20:00"),
(DEFAULT,6,"Segunda-Feira","18:20:00"),
(DEFAULT,3,"Segunda-Feira","18:20:00"),
(DEFAULT,4,"Segunda-Feira","18:20:00");