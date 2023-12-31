INSERT INTO PROFESORES (CedulaProf, nombreP, DireccionP, TelefonoP, Categoria, Dedicacion, FechaIng, FechaEgr, StatusP) 
VALUES 
    ('1234567890', 'Juan PErez', 'Calle 123', '555-5555', 'A', 'TC', '2011-12-31', '2008-12-20', 'P'),
    ('2345678901', 'María Gomez', 'Avenida 456', '555-5556', 'I', 'MT', '2010-01-15', '2009-12-19', 'R'),
    ('3456789012', 'Pedro Torres', 'Calle 789', '555-5557', 'S', 'TC', '2009-06-30', '2012-12-11', 'R'),
    ('4567890123', 'Ana Garcia', 'Avenida 012', '555-5558', 'I', 'MT', '2008-03-12', '2011-10-10', 'R'),
    ('5678901034', 'Carlos Hernandez', 'Calle 345', '555-5559', 'G', 'TC', '2011-09-22', '2015-10-29', 'J'),
    ('6789012345', 'Luisa Martinez', 'Avenida 678', '555-5560', 'I', 'MT', '2012-11-18', '2024-12-16', 'P'),
    ('7890123456', 'Diego Sanchez', 'Calle 901', '555-5561', 'A', 'TV', '2013-05-01', '2024-12-15', 'A'),
    ('8901234567', 'Laura Rodriguez', 'Avenida 234', '555-5562', 'G', 'TV', '2004-07-09', '2005-10-14', 'R'),
    ('9011345678', 'Santiago Perez', 'Calle 567', '555-5563', 'T', 'TC', '2016-02-28', '2024-10-12', 'P'),
    ('0123456789', 'Carolina Gomez', 'Avenida 890', '555-5564', 'G', 'TV', '2015-10-17', '2024-12-25', 'J'),
    ('312399913', 'Carolina Paez', 'Avenida 890', '555-5564', 'I', 'MT', '2022-10-17', '2024-5-24', 'J'),
    ('312399914', 'Hector Sanchez', 'Avenida 290', '5534-5564', 'I', 'MT', '2022-9-17', '2024-4-22', 'A'),
    ('312393943', 'Maria Sanchez', 'Avenida 290', '5534-5564', 'I', 'MT', '2022-8-17', '2024-2-24', 'A');

-----------

INSERT INTO ASIGNATURA (CodAsignatura, NombreAsig, UC, Semestre, Taxonomia, StatusA)
VALUES ('ASG1', 'Matemáticas', 4, '1', 'TA1', 'V'),
('ASG2', 'Historia', 3, '2', 'TA3', 'R'),
('ASG3', 'Fisica', 3, '4', 'TA3', 'R'),
('ASG4', 'Ecologia', 5, '4', 'TA9', 'R'),
('ASG5', 'Cultura', 1, '4', 'TA5', 'E'),
('ASG6', 'Geografia', 1, '4', 'TA9', 'E'),
('ASG7', 'Premilitar', 2, '4', 'TA9', 'E'),
('ASG8', 'Programacion II', 4, '4', 'TA9', 'V'),
('ASG9', 'Castellano', 2, '4', 'TA8', 'E'),
('ASG10', 'Ingles', 2, '4', 'TA7', 'E'),
('ASG11', 'Sistemas Operativos', 9, '9', 'TA9', 'E'),
('ASG12', 'Sistemas Distribuido', 9, '9', 'TA9', 'E'),
('ASG13', 'Bases de datos', 9, '9', 'TA9', 'E');


-----------------------

INSERT INTO SECCIONES (NRC, CodAsignatura, Lapso, CedulaProf)
VALUES ('12431', 'ASG1', '201015', '123456789'),
       ('12453', 'ASG2', '201025', '987654321'),
       ('19323', 'ASG3', '201115', '111222333'),
       ('13454', 'ASG4', '201315', '4567890123'),
       ('13455', 'ASG5', '201325', '5678901034'),
       ('13456', 'ASG6', '201415', '4567890123'),
       ('13457', 'ASG7', '201425', '111222333'),
       ('13458', 'ASG8', '201515', '5678901034'),
       ('13459', 'ASG9', '201525', '9011345678'),
       ('12312', 'ASG10', '201125', '123456789'),
       ('12213', 'ASG11', '201215', '987654321'),
       ('13414', 'ASG12', '202225', '9011345678'),
       ('13412', 'ASG13', '202325', '9011345678'),
       ('13413', 'ASG13', '202325', '312399913');


----------------------
INSERT INTO ESCUELA (CodEscuela, NombreEsc, FechaCreacion)
VALUES ('COD1', 'San Agustin', '2021-01-01'),
       ('COD2', 'Monte Carmelo', '2022-03-15'),
       ('COD3', 'Santisima Trinidad', '2023-05-10');

------------

INSERT INTO ESTUDIANTES (IdEstudiante,Cedula, NombreEst, CodEscuela, DireccionEst, TelefonoEst, FechaNac, StatusEst)
VALUES (1,'28339421', 'Luis Hernandez', 'COD1', 'Unare 2', '5555555555', '2004-03-03', 'Egresado'),
       (2,'28339452', 'Alejandro Rosas', 'COD1', 'Caujaro', '5555555555', '2005-03-03', 'No inscrito'),
       (3,'28339453', 'Wiston Diaz', 'COD2', 'Caujaro', '5555555555', '2006-03-03', 'Retirado'),
       (4,'28339454', 'Hector Garcia', 'COD2', 'Caujaro', '5555555555', '2001-03-03', 'Activo'),
       (5,'28339455', 'Jesus Ortiz', 'COD2', 'Alta Vista', '5555555555', '2002-03-03', 'Activo'),
       (6,'28339456', 'Ana String', 'COD3', 'Alta Vista', '5555555555', '2003-03-03', 'Activo'),
       (7,'28339457', 'Franklin Gonzalez', 'COD3', 'Olivos', '5555555555', '2001-03-03', 'Activo'),
       (8,'28339458', 'Victor Ordaz', 'COD3', 'Olivos', '5555555555', '2002-03-03', 'Activo'),
       (9,'28332458', 'Victor freitas', 'COD3', 'Olivos', '5555555555', '2002-03-03', 'Activo'),
       (10,'28322258', 'Angel Guevara', 'COD3', 'Olivos', '5555555555', '2002-03-03', 'Activo'),
       (11,'28322259', 'Angel Perez', 'COD3', 'Olivos', '5555555555', '2001-03-03', 'Activo');

-----------

INSERT INTO CALIFICACIONES (IdEstudiante, NRC, Calificacion, EstatusN)
VALUES (1, '12431', 14, 'A'),
       (2, '12453', 12, 'R'),
       (3, '19323', 12, 'E'),
       (4, '13454', 12, 'R'),
       (5, '13455', 12, 'A'),
       (6, '13456', 12, 'A'),
       (7, '13457', 12, 'A'),
       (8, '13458', 12, 'R'),
       (9, '13459', 18, 'E'),
       (10, '12431', 8, 'R'),
       (10, '12453', 6, 'R'),
       (10, '19323', 5, 'R'),
       (10, '13454', 9, 'R'),
       (10, '13455', 8, 'R'),
       (11, '12431', 8, 'R'),
       (11, '12453', 4, 'R'),
       (11, '19323', 5, 'R'),
       (11, '13454', 7, 'R'),
       (11, '13455', 8, 'R'),
       (1, '12453', 7, 'R'),
       (1, '19323', 15, 'A'),
       (1, '13454', 9, 'R'),
       (1, '13455', 11, 'A'),
       (2, '19323', 11, 'A'),
       (2, '12431', 11, 'A'),
       (2, '13457', 11, 'A'),
       (2, '13455', 9, 'R'),
       (2, '13459', 9, 'R'),
       (3, '13455', 12, 'A'),
       (3, '13414', 12, 'A'),
       (4, '13455', 9, 'R'),
       (4, '19323', 8, 'R'),
       (4, '12453', 9, 'R'),
       (4, '13457', 12, 'A'),
       (5, '13459', 12, 'A'),
       (5, '13454', 9, 'R'),
       (1, '13412', 9, 'R'),
       (2, '13412', 12, 'A'),
       (3, '13412', 12, 'A'),
       (4, '13412', 9, 'R');

---------

INSERT INTO PAGOS_REALIZADOS (NumFactura, IdEstudiante, FechaEmision, TipoPago, TipoMoneda, Monto)
VALUES (1, 1, '2023-06-15', 'T', 'B', 100),
       (2, 2, '2023-06-16', 'J', 'D', 150),
       (3, 3, '2023-06-17', 'D', 'P', 75);
