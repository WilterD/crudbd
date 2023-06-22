
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
  E.IdEstudiante, E.NombreEst, ASIGN.NombreAsig, CAL.Calificacion
FROM 
  ESTUDIANTES E
  INNER JOIN CALIFICACIONES CAL ON E.IdEstudiante = CAL.IdEstudiante
  INNER JOIN SECCIONES SECC ON CAL.NRC = SECC.NRC
  INNER JOIN ASIGNATURA ASIGN ON SECC.CodAsignatura = ASIGN.CodAsignatura
WHERE 
  SECC.Lapso = (
    SELECT DISTINCT Lapso 
    FROM 
      SECCIONES 
    ORDER BY Lapso DESC 
    LIMIT 1 OFFSET 1
  ) AND 
  ASIGN.Taxonomia = 'TA9' AND CAL.EstatusN IN ('R')
ORDER BY E.IdEstudiante;

-- ENUNCIADO 6:
-- Listar las asignaturas (Código, Nombre y Semestre) 
-- que ya están eliminada del catálogo y la cantidad de estudiantes que la aprobaron. 
-- El listado debe estar ordenado por semestre y la cantidad de estudiantes, ambos en forma descendente.

SELECT 
  asg.CodAsignatura, asg.NombreAsig, asg.Semestre,
  COUNT(CASE WHEN cal.EstatusN = 'A' THEN 1 END) cantidadAprobados
FROM ASIGNATURA asg
LEFT JOIN SECCIONES sec ON asg.CodAsignatura = sec.CodAsignatura
LEFT JOIN CALIFICACIONES cal ON sec.NRC = cal.NRC
WHERE asg.StatusA = 'E'
GROUP BY 
  asg.CodAsignatura,
  asg.NombreAsig,
  asg.Semestre
ORDER BY 
  Semestre DESC, 
  cantidadAprobados DESC;

-- ENUNCIADO 7:
-- Liste los estudiantes activos que hayan reprobado más de 5 asignaturas distintas y
-- que tengan más de 5 años de estudios. La salida debe mostrar : Id, nombre de
-- estudiante, total de asignaturas cursadas, total de asignaturas reprobadas ordenados por total de asignaturas reprobadas en forma descendente.

SELECT 
  ESTUDIANTES.IdEstudiante, ESTUDIANTES.NombreEst,
  COUNT(DISTINCT SECCIONES.CodAsignatura) asignaturas_cursadas,
  COUNT(
    DISTINCT CASE WHEN CALIFICACIONES.EstatusN = 'R' THEN SECCIONES.CodAsignatura ELSE NULL END
  ) AsignaturasReprobadas
FROM 
  ESTUDIANTES
  INNER JOIN CALIFICACIONES ON ESTUDIANTES.IdEstudiante = CALIFICACIONES.IdEstudiante
  INNER JOIN SECCIONES ON CALIFICACIONES.NRC = SECCIONES.NRC
GROUP BY 
  ESTUDIANTES.IdEstudiante,
  ESTUDIANTES.NombreEst
HAVING (
  COUNT(DISTINCT SECCIONES.Lapso) > 10
  AND 
  COUNT(DISTINCT CASE WHEN CALIFICACIONES.EstatusN = 'R' THEN SECCIONES.CodAsignatura ELSE NULL END) > 5
)
ORDER BY AsignaturasReprobadas DESC;

-- ENUNCIADO 8:
-- Actualizar el Estatus del profesor a “Retirado” y la fecha de egreso con “31-03-2023”,
-- si no tiene carga académica (no tiene asignada al menos un NRC) en el lapso 202325.

UPDATE PROFESORES
SET 
  StatusP = 'R', 
  FechaEgr = '31-03-2023'
WHERE (
  CedulaProfesor NOT IN (
    SELECT DISTINCT CedulaProfesor
    FROM SECCIONES
    WHERE Lapso = '2023-25'
  )
  AND 
  -- Esto se hace para que no afecte a aquellos profesores ya retirados 
  -- que no tuvieron carga academica en el lapso 2023-25
  FechaEgr IS NULL 
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
