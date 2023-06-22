
-- ENUNCIADO 2:
-- Listar los profesores 
-- que ingresaron el año pasado, con categoría “Instructor” a dedicación “Medio Tiempo”..
-- El listado debe contener : Cédula, Nombre del profesor
-- y fecha de ingreso y debe estar 
-- ordenado ascendentemente por fecha de ingreso y
-- nombre del profesor.

SELECT
  CedulaProf, FechaIng, nombreP
FROM
  PROFESORES
WHERE (
  (dedicacion = 'MT' AND categoria = 'I')
  AND
  (DATE_PART('year', CURRENT_DATE) - 1 = DATE_PART('year', FechaIng))
)
ORDER BY
  FechaIng,
  nombreP;

-- ENUNCIADO 3:
-- Listar los profesores (Cédula y Nombre) que han dictado una asignatura de nombre
-- dado, en un lapso también dado. El listado debe estar ordenado ascendentemente
-- por nombre del profesor.

SELECT 
  PROFESORES.CedulaProf, PROFESORES.nombreP
FROM 
  PROFESORES
  INNER JOIN SECCIONES ON PROFESORES.CedulaProf = SECCIONES.CedulaProf
  INNER JOIN ASIGNATURA ON SECCIONES.CodAsignatura = ASIGNATURA.CodAsignatura
WHERE (ASIGNATURA.NombreAsig = 'Bases de datos' AND SECCIONES.Lapso = '202325')
ORDER BY nombreP;

-- ENUNCIADO 4:
-- Listar, para cada Escuela, la cantidad de estudiantes activos, no inscritos y
-- retirados. El listado debe contener el código y nombre de la Escuela así como
-- cantidad de activos, no inscritos y retirados, y un total general de estudiantes (suma
-- de activos, no inscritos y retirados). Debe estar ordenado por total de estudiantes
-- de mayor a menor.

SELECT
  ESCUELA.CodEscuela, ESCUELA.NombreEsc,
  COUNT(CASE WHEN ESTUDIANTES.StatusEst IN ('Activo') THEN 1 END) activos, 
  COUNT(CASE WHEN ESTUDIANTES.StatusEst IN ('No inscrito') THEN 1 END) noInscritos,
  COUNT(CASE WHEN ESTUDIANTES.StatusEst IN ('Retirado') THEN 1 END) retirados,
  COUNT(CASE WHEN ESTUDIANTES.StatusEst IN ('Egresado') THEN 1 END) egresado,
  COUNT(*) total
FROM 
  ESCUELA, ESTUDIANTES
WHERE
   ESCUELA.CodEscuela = ESTUDIANTES.CodEscuela
GROUP BY
  ESCUELA.CodEscuela,
  ESCUELA.NombreEsc
ORDER BY total DESC;

-- ENUNCIADO 5:
-- Listar los estudiantes que hayan cursado alguna asignatura de Taxonomía 9 el lapso
-- pasado y la hayan reprobado. El listado debe contener el Id y Nombre del estudiante,
-- el nombre de la asignatura y la calificación obtenida. Debe ordenar el listado por Id
-- del estudiante.

SELECT 
  E.IdEstudiante, E.NombreEst, MIN(CAL.Calificacion), MIN(ASIGN.NombreAsig)
FROM
  ESTUDIANTES E, CALIFICACIONES CAL, SECCIONES SECC, ASIGNATURA ASIGN
WHERE
  ASIGN.Taxonomia = 'TA9' AND CAL.EstatusN IN ('R')
  AND E.IdEstudiante = CAL.IdEstudiante
  AND CAL.NRC = SECC.NRC
  AND SECC.CodAsignatura = ASIGN.CodAsignatura
  AND SECC.Lapso = '202225'
GROUP BY E.IdEstudiante, E.NombreEst
ORDER BY E.IdEstudiante;

-- ENUNCIADO 6:
-- Listar las asignaturas (Código, Nombre y Semestre) 
-- que ya están eliminada del catálogo y la cantidad de 
-- estudiantes que la aprobaron. 
-- El listado debe estar ordenado por semestre y la cantidad de estudiantes
-- ambos en forma descendente.

SELECT
  ASG.CodAsignatura, ASG.NombreAsig, ASG.Semestre,
  COUNT(CASE WHEN CAL.EstatusN IN ('A') THEN 1 END) cantidadAprobados
FROM ASIGNATURA ASG, CALIFICACIONES cal, SECCIONES
WHERE 
  ASG.CodAsignatura = SECCIONES.CodAsignatura
  AND SECCIONES.NRC = cal.NRC
  AND ASG.StatusA = 'E'
GROUP BY 
  ASG.CodAsignatura,
  ASG.NombreAsig,
  ASG.Semestre
ORDER BY
  Semestre DESC,
  cantidadAprobados DESC;

-- ENUNCIADO 7:
-- Liste los estudiantes activos que hayan reprobado más de 5 asignaturas distintas y
-- que tengan más de 5 años de estudios. La salida debe mostrar : Id, nombre de
-- estudiante, total de asignaturas cursadas, total de asignaturas reprobadas ordenados por total de asignaturas reprobadas en forma descendente.

-- [DESARROLLAR]

-- ENUNCIADO 8:
-- Actualizar el Estatus del profesor a “Retirado” y la fecha de egreso con “31-03-2023”,
-- si no tiene carga académica (no tiene asignada al menos un NRC) en el lapso 202325.

UPDATE PROFESORES
SET 
  FechaEgr = '31-03-2023'
  StatusP = 'R',
WHERE (
  CedulaProf NOT IN (
    SELECT DISTINCT CedulaProf
    FROM SECCIONES WHERE Lapso = '202325';
  )
);

-- ENUNCIADO 9:
-- 9) Eliminar los Profesores cuya Estatus sea “Retirado” y la fecha de egreso sea mayor
-- a 10 años, manteniendo la consistencia de la base de datos, y registrando todos los
-- datos contenidos en la tabla Profesores, en un archivo histórico denominado HistoricoProfesor.

BEGIN:

  -- INSERTAR PROFESOR BORRADO PARA SUSTITUIR A LOS PROFESORES QUE SALGAN DE LA BD
  INSERT INTO PROFESORES (CedulaProf, nombreP, DireccionP, TelefonoP, Categoria, Dedicacion, FechaIng, FechaEgr, StatusP)
  VALUES ('000000000', 'Profesor Borrado', '', '', 'T', 'TV', '1980-1-1', NOW() - INTERVAL '10 YEARS', 'R');

  -- Crea la tabla historico profesor
  CREATE TABLE HistoricoProfesor (
      CedulaProf public.dom_cedula NOT NULL,
      nombreP public.dom_nombre NOT NULL,
      DireccionP CHAR(255) NOT NULL,
      TelefonoP public.dom_telefono,
      Categoria public.enum_categoria NOT NULL,
      Dedicacion public.enum_dedicacion NOT NULL,
      FechaIng public.dom_fechas NOT NULL,
      FechaEgr public.dom_fechas NOT NULL,
      StatusP public.enum_status_p NOT NULL,
      ----------------- Alteraciones
      PRIMARY KEY(CedulaProf),
      CONSTRAINT CHK_Historico_Categoria CHECK (Categoria IN('A', 'I', 'G', 'S', 'T')),
      CONSTRAINT CHK_Historico_Dedicacion CHECK (Dedicacion IN('TC', 'MT', 'TV')),
      CONSTRAINT CHK_Historico_StatusP CHECK (StatusP IN('A','R','P','J'))
  );

  -- Mete todo lo de profesores que cumpla los parametros en historico de profesor
  INSERT INTO HistoricoProfesor SELECT * FROM PROFESORES WHERE StatusP = 'R' AND FechaEgr < NOW() - INTERVAL '10 YEARS' AND PROFESORES.CedulaProf != '000000000';

  -- En seccoines pone el profesor borrado en las secciones que no tengan profesor
  UPDATE SECCIONES
  SET CedulaProf = '000000000'
  FROM PROFESORES
  WHERE SECCIONES.CedulaProf = PROFESORES.CedulaProf
    AND PROFESORES.StatusP = 'R'
    AND PROFESORES.FechaEgr < NOW() - INTERVAL '10 YEARS'
    AND SECCIONES.CedulaProf != '000000000';

  -- Elimina los profesores que cumplan los parametros
  DELETE FROM PROFESORES WHERE StatusP = 'R' AND FechaEgr < NOW() - INTERVAL '10 YEARS' AND PROFESORES.CedulaProf != '000000000';

COMMIT;
