-- INGENIER�A INFORM�TICA - SISTEMAS DE BASES DE DATOS
-- EVALUACI�N PARCIAL N� 3 - 25-06-2024

/* -----------------------------------------------------------------------------------------------------------------------------------
   Una instituci�n educativa ha implementado una base de datos para sistematizar las actividades acad�micas. 
   Se registra la siguiente informaci�n:

   - Alumnos: Con sus datos personales
   - Carreras: Cada carrera tendr� configurada la cantidad m�xima de aplazos que puede tener un alumno para cada 
     materia cursada y la cantidad de a�os que dura la regularidad conseguida en cada cursado
   - Matr�culas: Donde se registra las carreras que cursa cada alumno y su a�o de ingreso a la misma
   - Materias: Donde se registra cada materia de cada carrera indicando si es obligatoria o no y si corresponde al trabajo final de la 
     carrera o no
   - Cursados: Son los cursados que ha realizado cada alumno en cada materia, indicando el a�o en el cual curs� la materia y su situaci�n 
     final (regular o libre)
   - Ex�menes finales: Se registra las inscripciones a ex�menes finales indicando el cursado al cual corresponde el examen, el nro. de libro 
     y acta donde fue registrada la nota, y la nota obtenida (null si estuvo ausente). 
   - Los alumnos solo pueden rendir materias que hayan cursado. No se permite el examen en condici�n libre

   Se implement� una base de datos a trav�s del script siguiente:
*/

drop table examenes
drop table cursados
drop table matriculas
drop table alumnos
drop table materias
drop table carreras
go

create table carreras
(
 cod_carrera		smallint		not null,
 nom_carrera		varchar(100)	not null,
 nota_aprobacion	tinyint			not null,
 cant_max_aplazos	tinyint			not null,
 a�os_regularidad	tinyint			not null,
 duracion_carrera	tinyint			not null,
 primary key (cod_carrera)
)
go

create table materias
(
 cod_carrera		smallint		not null,
 cod_materia		char(4)			not null,
 nom_materia		varchar(100)	not null,
 a�o_materia		smallint		not null,
 obligatoria		char(1)			not null,
 trabajo_final		char(1)			not null,
 primary key (cod_carrera, cod_materia),
 foreign key (cod_carrera) references carreras,
 check (obligatoria in ('S','N')),
 check (trabajo_final in ('S','N'))
)
go

create table alumnos 
(
 nro_alumno			integer			not null,
 nom_alumno			varchar(40)		not null,
 tipo_doc_alumno	varchar(3)		not null,
 nro_doc_alumno		integer			not null,
 primary key (nro_alumno)
)
go

create table matriculas
(
 nro_alumno			integer			not null, 
 cod_carrera		smallint		not null,
 a�o_ingreso		smallint		not null,
 primary key (nro_alumno, cod_carrera),
 foreign key (nro_alumno) references alumnos,
 foreign key (cod_carrera) references carreras
)
go

create table cursados
(
 cod_carrera		smallint		not null,
 cod_materia		char(4)			not null,
 a�o_cursado		smallint		not null,
 nro_alumno			integer			not null,
 regular			char(1)			not null,
 primary key (cod_carrera, cod_materia, a�o_cursado, nro_alumno),
 foreign key (nro_alumno, cod_carrera) references matriculas,
 foreign key (cod_carrera, cod_materia) references materias, 
 check (regular in ('S','N'))
)
go

create table examenes
(
 fecha_examen		smalldatetime	not null,
 cod_carrera		smallint		not null,
 cod_materia		char(4)			not null,
 a�o_cursado		smallint		not null,
 nro_alumno			integer			not null,
 nro_libro			smallint		not null,
 nro_acta			smallint		not null,
 nota_examen		tinyint			null,
 primary key (nro_alumno, cod_carrera, cod_materia, fecha_examen),
 foreign key (cod_carrera, cod_materia, a�o_cursado, nro_alumno) references cursados
)
go


-- CARRERAS
insert into carreras (cod_carrera, nom_carrera, nota_aprobacion, cant_max_aplazos, a�os_regularidad, duracion_carrera)
values (1,'CARRERA 1',4,3,2,4),
       (2,'CARRERA 2',5,2,3,5),
       (3,'CARRERA 3',4,3,2,6),
       (4,'CARRERA 4',5,2,3,4),
       (5,'CARRERA 5',4,3,2,5)
go

-- MATERIAS

insert into materias (cod_carrera, cod_materia, nom_materia, a�o_materia, obligatoria, trabajo_final)
values (1,'0101','MATERIA 1-0101',1,'S','N'),
       (1,'0102','MATERIA 1-0102',1,'S','N'),
       (1,'0201','MATERIA 1-0201',2,'S','N'),
       (1,'0202','MATERIA 1-0202',2,'N','N'),
       (1,'0301','MATERIA 1-0301',3,'S','N'),
       (1,'0302','MATERIA 1-0302',3,'S','N'),
       (1,'0401','MATERIA 1-0401',4,'S','N'),
       (1,'0402','MATERIA 1-0402',4,'S','S')
go

insert into materias (cod_carrera, cod_materia, nom_materia, a�o_materia, obligatoria, trabajo_final)
values (2,'0101','MATERIA 2-0101',1,'S','N'),
       (2,'0102','MATERIA 2-0102',1,'S','N'),
       (2,'0201','MATERIA 2-0201',2,'S','N'),
       (2,'0202','MATERIA 2-0202',2,'N','N'),
       (2,'0301','MATERIA 2-0301',3,'S','N'),
       (2,'0302','MATERIA 2-0302',3,'S','N'),
       (2,'0401','MATERIA 2-0401',4,'S','N'),
       (2,'0402','MATERIA 2-0402',4,'S','N'),
       (2,'0403','MATERIA 2-0403',4,'S','N'),
       (2,'0404','MATERIA 2-0404',4,'S','N'),
       (2,'0501','MATERIA 2-0501',5,'N','N'),
       (2,'0502','MATERIA 2-0502',5,'S','N'),
       (2,'0503','MATERIA 2-0503',5,'N','N'),
       (2,'0504','MATERIA 2-0504',5,'S','N')
go

insert into materias (cod_carrera, cod_materia, nom_materia, a�o_materia, obligatoria, trabajo_final)
values (3,'0101','MATERIA 3-0101',1,'S','N'),
       (3,'0102','MATERIA 3-0102',1,'S','N'),
       (3,'0201','MATERIA 3-0201',2,'S','N'),
       (3,'0202','MATERIA 3-0202',2,'N','N'),
       (3,'0301','MATERIA 3-0301',3,'S','N'),
       (3,'0302','MATERIA 3-0302',3,'S','N'),
       (3,'0401','MATERIA 3-0401',4,'S','N'),
       (3,'0402','MATERIA 3-0402',4,'S','N'),
       (3,'0501','MATERIA 3-0501',5,'S','N'),
       (3,'0502','MATERIA 3-0502',5,'S','N'),
       (3,'0601','MATERIA 3-0601',6,'N','N'),
       (3,'0602','MATERIA 3-0602',6,'S','N')
go

insert into materias (cod_carrera, cod_materia, nom_materia, a�o_materia, obligatoria, trabajo_final)
values (4,'0101','MATERIA 4-0101',1,'S','N'),
       (4,'0102','MATERIA 4-0102',1,'S','N'),
       (4,'0201','MATERIA 4-0201',2,'S','N'),
       (4,'0202','MATERIA 4-0202',2,'N','N'),
       (4,'0301','MATERIA 4-0301',3,'S','N'),
       (4,'0302','MATERIA 4-0302',3,'S','N'),
       (4,'0401','MATERIA 4-0401',4,'S','N'),
       (4,'0402','MATERIA 4-0402',4,'S','S'),
       (4,'0403','MATERIA 2-0403',4,'S','N'),
       (4,'0404','MATERIA 2-0404',4,'S','S'),
       (4,'0405','MATERIA 2-0405',5,'S','N'),
       (4,'0406','MATERIA 2-0406',5,'S','S')
go

insert into materias (cod_carrera, cod_materia, nom_materia, a�o_materia, obligatoria, trabajo_final)
values (5,'0101','MATERIA 5-0101',1,'S','N'),
       (5,'0102','MATERIA 5-0102',1,'S','N'),
       (5,'0201','MATERIA 5-0201',2,'S','N'),
       (5,'0202','MATERIA 5-0202',2,'N','N'),
       (5,'0301','MATERIA 5-0301',3,'S','N'),
       (5,'0302','MATERIA 5-0302',3,'S','N'),
       (5,'0401','MATERIA 5-0401',4,'S','N'),
       (5,'0402','MATERIA 5-0402',4,'S','N'),
       (5,'0501','MATERIA 5-0501',5,'N','N'),
       (5,'0502','MATERIA 5-0502',5,'S','N')
go

-- ALUMNOS

insert into alumnos (nro_alumno, nom_alumno, tipo_doc_alumno, nro_doc_alumno)
values (1,'ALUMNO 1','DNI',1),
       (2,'ALUMNO 2','DNI',2),
       (3,'ALUMNO 3','DNI',3),
       (4,'ALUMNO 4','DNI',4),
       (5,'ALUMNO 5','DNI',5),
       (6,'ALUMNO 6','DNI',6),
       (7,'ALUMNO 7','DNI',7),
       (8,'ALUMNO 8','DNI',8),
       (9,'ALUMNO 9','DNI',9),
       (10,'ALUMNO 10','DNI',10)
go

-- MATRICULAS
insert into matriculas (nro_alumno, cod_carrera, a�o_ingreso)
values (1,1,1996),
       (2,1,1998),
       (3,2,1995),
       (4,2,1997),
       (5,3,1999),
       (6,3,1996),
       (7,4,2000),
       (8,4,1998),
       (9,5,2000),
       (10,5,2001)
go

-- CURSADOS

insert into cursados (cod_carrera, cod_materia, a�o_cursado, nro_alumno, regular)
values (1,'0101',1996,1,'S'),
       (1,'0102',1996,1,'S'),
       (1,'0201',1997,1,'S'),
       (1,'0301',1998,1,'S'),
       (1,'0302',1998,1,'S'),
       (1,'0401',1999,1,'S')
go

insert into cursados (cod_carrera, cod_materia, a�o_cursado, nro_alumno, regular)
values (1,'0101',1998,2,'S'),
       (1,'0102',1998,2,'N'),
       (1,'0102',1999,2,'S'),
       (1,'0201',1999,2,'S'),
       (1,'0301',2000,2,'S'),
       (1,'0302',2000,2,'S'),
       (1,'0401',2001,2,'S')
go

insert into cursados (cod_carrera, cod_materia, a�o_cursado, nro_alumno, regular)
values (2,'0101',1995,3,'S'),
       (2,'0102',1995,3,'S'),
       (2,'0201',1996,3,'S'),
       (2,'0202',1996,3,'S')
go

insert into cursados (cod_carrera, cod_materia, a�o_cursado, nro_alumno, regular)
values (2,'0101',1997,4,'S'),
       (2,'0102',1997,4,'S'),
       (2,'0201',1998,4,'S'),
       (2,'0202',1998,4,'S'),
       (2,'0301',1999,4,'S'),
       (2,'0302',1999,4,'S'),
       (2,'0403',2000,4,'S'),
       (2,'0404',2000,4,'N'),
       (2,'0404',2001,4,'S'),
       (2,'0503',2001,4,'S')
go

insert into cursados (cod_carrera, cod_materia, a�o_cursado, nro_alumno, regular)
values (3,'0101',1999,5,'S'),
       (3,'0102',1999,5,'S'),
       (3,'0201',2000,5,'S'),
       (3,'0202',2000,5,'S'),
       (3,'0301',2001,5,'S'),
       (3,'0302',2001,5,'S')
go

insert into cursados (cod_carrera, cod_materia, a�o_cursado, nro_alumno, regular)
values (3,'0101',1996,6,'S'),
       (3,'0102',1997,6,'S'),
       (3,'0201',1998,6,'S'),
       (3,'0202',1999,6,'S'),
       (3,'0301',2000,6,'S'),
       (3,'0302',2001,6,'S')
go

insert into cursados (cod_carrera, cod_materia, a�o_cursado, nro_alumno, regular)
values (4,'0101',2000,7,'S'),
       (4,'0102',2000,7,'S'),
       (4,'0201',2001,7,'S'),
       (4,'0202',2001,7,'S')
go

insert into cursados (cod_carrera, cod_materia, a�o_cursado, nro_alumno, regular)
values (4,'0101',1998,8,'S'),
       (4,'0102',1998,8,'S'),
       (4,'0201',1999,8,'S'),
       (4,'0301',2000,8,'S'),
       (4,'0302',2000,8,'S'),
       (4,'0405',2001,8,'S')
go

insert into cursados (cod_carrera, cod_materia, a�o_cursado, nro_alumno, regular)
values (5,'0101',2000,9,'S'),
       (5,'0102',2000,9,'S'),
       (5,'0201',2001,9,'S')
go

insert into cursados (cod_carrera, cod_materia, a�o_cursado, nro_alumno, regular)
values (5,'0101',2001,10,'N'),
       (5,'0102',2001,10,'N')
go

-- EXAMENES
insert into examenes (fecha_examen, cod_carrera, cod_materia, a�o_cursado, nro_alumno, nro_libro, nro_acta, nota_examen)
values ('1996-12-20',1,'0101',1996,1,1,1,5),
       ('1996-12-27',1,'0102',1996,1,1,2,4),
       ('1997-12-15',1,'0201',1997,1,2,1,3),
       ('1998-02-15',1,'0201',1997,1,2,2,7),
       ('1998-12-17',1,'0301',1998,1,3,1,6),
       ('1998-12-28',1,'0302',1998,1,3,2,8),
       ('1999-11-18',1,'0401',1999,1,4,2,2),
       ('1999-12-10',1,'0401',1999,1,4,1,null)
go

insert into examenes (fecha_examen, cod_carrera, cod_materia, a�o_cursado, nro_alumno, nro_libro, nro_acta, nota_examen)
values ('1998-12-20',1,'0101',1998,2,1,1,5),
       ('1999-12-07',1,'0102',1999,2,1,2,4),
       ('1999-12-15',1,'0201',1999,2,2,1,3),
       ('2000-02-15',1,'0201',1999,2,2,2,7),
       ('2000-12-17',1,'0301',2000,2,3,1,null),
       ('2000-12-28',1,'0302',2000,2,3,2,3)
go

insert into examenes (fecha_examen, cod_carrera, cod_materia, a�o_cursado, nro_alumno, nro_libro, nro_acta, nota_examen)
values ('1995-12-20',2,'0101',1995,3,1,1,4),
       ('1995-12-29',2,'0102',1995,3,1,2,2),
       ('1996-02-20',2,'0102',1995,3,1,3,1)
go

insert into examenes (fecha_examen, cod_carrera, cod_materia, a�o_cursado, nro_alumno, nro_libro, nro_acta, nota_examen)
values ('1997-12-02',2,'0101',1997,4,1,1,5),
       ('1998-02-02',2,'0101',1997,4,1,3,null),
       ('1997-12-10',2,'0102',1997,4,1,2,7),
       ('1998-12-12',2,'0201',1998,4,1,1,8),
       ('1998-12-22',2,'0202',1998,4,1,2,9),
       ('1999-12-04',2,'0301',1999,4,1,1,10),
       ('1999-12-05',2,'0302',1999,4,1,2,7),
       ('2000-12-11',2,'0403',2000,4,1,1,8),
       ('2001-12-12',2,'0404',2000,4,1,1,3),
       ('2001-12-18',2,'0404',2000,4,1,3,8)
go

insert into examenes (fecha_examen, cod_carrera, cod_materia, a�o_cursado, nro_alumno, nro_libro, nro_acta, nota_examen)
values ('1999-12-13',3,'0101',1999,5,1,1,5),
       ('1999-12-16',3,'0102',1999,5,1,2,7),
       ('2000-12-11',3,'0201',2000,5,1,1,8),
       ('2000-12-22',3,'0202',2000,5,1,2,10),
       ('2001-12-12',3,'0301',2001,5,1,1,9),
       ('2001-12-23',3,'0302',2001,5,1,2,10)
go

insert into examenes (fecha_examen, cod_carrera, cod_materia, a�o_cursado, nro_alumno, nro_libro, nro_acta, nota_examen)
values ('1996-12-10',3,'0101',1996,6,1,1,6),
       ('1997-12-11',3,'0102',1997,6,1,1,7),
       ('1998-12-13',3,'0201',1998,6,1,1,8),
       ('1999-12-12',3,'0202',1999,6,1,1,2),
       ('2000-12-13',3,'0301',2000,6,1,1,1),
       ('2001-02-13',3,'0301',2000,6,1,1,2),
       ('2001-07-13',3,'0301',2000,6,1,1,2),
       ('2001-12-12',3,'0302',2001,6,1,1,7)
go

insert into examenes (fecha_examen, cod_carrera, cod_materia, a�o_cursado, nro_alumno, nro_libro, nro_acta, nota_examen)
values ('2000-12-15',4,'0101',2000,7,1,1,7),
       ('2000-12-20',4,'0102',2000,7,1,2,6),
       ('2001-12-13',4,'0201',2001,7,1,1,6),
       ('2001-12-19',4,'0202',2001,7,1,2,7)
go

insert into examenes (fecha_examen, cod_carrera, cod_materia, a�o_cursado, nro_alumno, nro_libro, nro_acta, nota_examen)
values ('1998-12-10',4,'0101',1998,8,1,1,6),
       ('1998-12-12',4,'0102',1998,8,1,2,10),
       ('1999-12-13',4,'0201',1999,8,1,1,10),
       ('2000-12-14',4,'0301',2000,8,1,1,9),
       ('2000-12-21',4,'0302',2000,8,1,2,7),
       ('2001-12-12',4,'0405',2001,8,1,1,1),
       ('2001-12-22',4,'0405',2001,8,1,2,8)
go

insert into examenes (fecha_examen, cod_carrera, cod_materia, a�o_cursado, nro_alumno, nro_libro, nro_acta, nota_examen)
values ('2000-12-15',5,'0101',2000,9,1,1,10),
       ('2000-12-27',5,'0102',2000,9,1,2,9),
       ('2001-12-12',5,'0201',2001,9,1,1,8)
go

/*

1. Programar todos los triggers necesarios para asegurar la siguiente regla de integridad: (50)

   "Un alumno no puede inscribirse al examen de una materia para un cursado que ya tiene 
   la cantidad m�xima de aplazos"
*/

-- 1. Consulta para determinar registros con problemas
--profe
select e.cod_carrera, e.cod_materia, e.a�o_cursado, e.nro_alumno
  from examenes e
       join carreras c
	     on e.cod_carrera = c.cod_carrera
 where e.nota_examen < c.nota_aprobacion
 group by e.cod_carrera, e.cod_materia, e.a�o_cursado, e.nro_alumno, c.cant_max_aplazos--el group by es necesario pq sino te va a mostrar todos los registror de un alumno en una materia/carrera/a�o
having count(*) > c.cant_max_aplazos-- tiene que ser por > y no por >= ya que si se intenta agregar un examen y le queda una oportunidad y falla este no podra ser agregado
/*having count(*) >= c.cant_max_aplazos*/
--yo
select e.cod_carrera,e.cod_materia,e.nro_alumno,e.a�o_cursado,c.cant_max_aplazos, count(e.nota_examen) as aplazos
	from examenes e
		join carreras c 
			on e.cod_carrera = c.cod_carrera
    where e.nota_examen < c.nota_aprobacion
    group by e.cod_carrera,e.cod_materia,e.nro_alumno,e.a�o_cursado,c.cant_max_aplazos
    having count(e.nota_examen) >= c.cant_max_aplazos
	/*having count(e.nota_examen) > c.cant_max_aplazos*/
-- 2. tablas y operaciones que afectan 
----------------------------------------------------------------------------------------------
-- tabla				insert			delete			update
----------------------------------------------------------------------------------------------
-- examenes				SI				NO				SI
----------------------------------------------------------------------------------------------
-- carreras				NO				NO				SI
----------------------------------------------------------------------------------------------

-- 3. programaci�n de triggers
create or alter trigger tiu_ri_examenes
on examenes
for insert, update
as
begin
   if exists (select e.cod_carrera, e.cod_materia, e.a�o_cursado, e.nro_alumno--obten estas columnas
                from examenes e
                     join carreras c --del join de examenes y carreras
	                   on e.cod_carrera = c.cod_carrera --sobre cod_carrera
               where e.nota_examen < c.nota_aprobacion --donde la nota del examen sea menor a la nota de aprobacion
			     -- restringir a ex�menes del mismo cursado que los ex�menes insertados
				 and exists (select *
				               from inserted i
							  where e.cod_carrera = i.cod_carrera
								and e.cod_materia = i.cod_materia
								and e.a�o_cursado = i.a�o_cursado
								and e.nro_alumno  = i.nro_alumno) --y donde exista un intento de insercion sobre examenes
               group by e.cod_carrera, e.cod_materia, e.a�o_cursado, e.nro_alumno 
              having count(*) > c.cant_max_aplazos) --que tenga una cantidad de columna mayor a la cant_max_aplazos
      begin
	     raiserror('Hay m�s aplazos que la cantidad permitida', 16, 1)
		 rollback
	  end
end
go

create or alter trigger tu_ri_carreras
on carreras
for update
as
begin
   -- para poder hacer el join entre inserted y deleted controlar que no se modifique la pk
   if update (cod_carrera)
      begin
	     raiserror('No se puede modificar el identificador de la carrera', 16, 1)
		 rollback
	  end

   if exists (select e.cod_carrera, e.cod_materia, e.a�o_cursado, e.nro_alumno --(5)
                from examenes e --obtiene los examenes existentes (1)
                     join inserted i -- restringir a las carreras modificadas
	                   on e.cod_carrera = i.cod_carrera --joine con las carreras que se estan modificando
					 join deleted d
					   on i.cod_carrera = d.cod_carrera--y joinea con las carreras que fueron eliminadas por la modificacion
               where -- esto es para ser m�s espec�fico en el an�lisis (2)
			         (
			          i.cant_max_aplazos < d.cant_max_aplazos -- si baja la cantidad m�xima de aplazos
					  or
					  i.nota_aprobacion  > d.nota_aprobacion  -- si sube la nota de aprobaci�n m�nima
					 )
			     and e.nota_examen < i.nota_aprobacion  --y la nota del examen existentes es menor a la nota de aprobacion que se esta ingresando
               group by e.cod_carrera, e.cod_materia, e.a�o_cursado, e.nro_alumno --(3)
              having count(*) > i.cant_max_aplazos) --donde la cantidad maxima de aplazos que se esta ingresando sea menor que la cantidad de examenes (4)

			  /*Obten de la tabla examenes, union con insercion de carreras y eliminacion de carreras, 
			  DONDE si la cantidad maxima de aplazos insertada es menor a la cantidad maxima de aplazos eliminad 
			  O si la nota de aprobacion insertada es mayora a la nota de aprobacion eliminada 
			  Y si las notas de los examenes son menores a las de aprobacion insertadas
			  Teniendo una cantidad max aplazos insertados menor a lo que se obtenga*/
      begin
	     raiserror('Hay m�s aplazos que la cantidad permitida', 16, 1)
		 rollback
	  end
end
go

2. Programar un procedimiento almacenado que reciba como argumento el identificador de una materia y 
   la fecha de examen, y muestre los alumnos que pueden rendirla en esa fecha (50)

   Un alumno puede rendir una materia en una fecha determinada si:

   a. Est� regular en la misma, lo que implica:
     - Tiene un registro en cursado con regular = 'S'
     - Para ese registro tiene menos aplazos que la cantidad m�xima definida para la carrera
     - Esa regularidad no est� vencida (el a�o de cursado + a�os de regularidad definidos para la carrera 
	   es mayor al a�o de la fecha de examen)
   
   b. La materia no est� aprobada

   Mostrar: Nro. de alumno, apellido y nombres, y el a�o de cursado en estado regular
   ------------------------------------------------------------
	nro. alumno		apellido y nombres			a�o cursado
   ------------------------------------------------------------
     xxxxx			xxxxxxxxxxxxxxxxxxxxxxxxx		xxxx
     xxxxx			xxxxxxxxxxxxxxxxxxxxxxxxx		xxxx
     xxxxx			xxxxxxxxxxxxxxxxxxxxxxxxx		xxxx
     xxxxx			xxxxxxxxxxxxxxxxxxxxxxxxx		xxxx

*/

create or alter procedure get_alumnos_pueden_rendir
(
 @cod_carrera		smallint		null,
 @cod_materia		char(4)			null,
 @fecha_examen		smalldatetime	null
)
as
begin
   select a.nro_alumno, a.nom_alumno, cu.a�o_cursado
     from cursados cu
	      join alumnos a
		    on cu.nro_alumno = a.nro_alumno
		  join carreras ca
		    on cu.cod_carrera = ca.cod_carrera
    where cu.regular = 'S' --trae todos los alumnos regulares
	  and ca.cant_max_aplazos > (select count(*)
	                               from examenes e
								  where cu.cod_carrera = e.cod_carrera
								    and cu.cod_materia = e.cod_materia
									and cu.a�o_cursado = e.a�o_cursado
									and cu.nro_alumno  = e.nro_alumno -- donde cantidad maxima de aplazos sea mayor a la cantidad de examenes con una nota de examen menor a la nota aprobacion
									and e.nota_examen  < ca.nota_aprobacion) --verifica que la materia que esta cursando no tiene la cantidad de aplazos maxima
      and cu.a�o_cursado + ca.a�os_regularidad >= year(@fecha_examen) -- verifica que el a�o que consulta sea menor a la regularidad del alumno,esto te va a mostrar a�os anteriores a la regularidad
      and not exists (select *
                        from examenes e
                       where cu.cod_carrera = e.cod_carrera
                         and cu.cod_materia = e.cod_materia
                      	 and cu.nro_alumno  = e.nro_alumno
                     	 and e.nota_examen >= ca.nota_aprobacion) --verifica que la materia no este aprobada, donde no exista un examen con la materia de la carrera del curasado aprobada
	 and cu.cod_carrera=@cod_carrera 
	 and cu.cod_materia=@cod_materia
	 and cu.a�o_cursado<=year(@fecha_examen)
end
go

select * from cursados

execute get_alumnos_pueden_rendir @cod_carrera=1, @cod_materia='0401', @fecha_examen='2001-08-01'