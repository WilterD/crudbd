-- (2)
-- Listar los profesores que ingresaron el año pasado, con categoría “Instructor” a
-- dedicación “Medio Tiempo”.. El listado debe contener : Cédula, Nombre del profesor
-- y fecha de ingreso y debe estar ordenado ascendentemente por fecha de ingreso y
-- nombre del profesor.

SELECT
  CedulaProf, 
  nombreP, 
  FechaIng
FROM 
  PROFESORES
WHERE (
  (EXTRACT(YEAR FROM FechaIng) = (EXTRACT(YEAR FROM CURRENT_DATE) - 1)) 
    AND
  (categoria = 'I' AND dedicacion = 'MT')
)
ORDER BY
  FechaIng,
  nombreP;

-- (3)
-- Listar los profesores (Cédula y Nombre) que han dictado una asignatura de nombre
-- dado, en un lapso también dado. El listado debe estar ordenado ascendentemente
-- por nombre del profesor.

SELECT 
  p.CedulaProf, 
  p.nombreP
FROM 
  PROFESORES p
  INNER JOIN SECCIONES s ON p.CedulaProf = s.CedulaProf
  INNER JOIN ASIGNATURA a ON s.CodAsignatura = a.CodAsignatura
WHERE (a.NombreAsig = 'Base de Datos I' AND s.Lapso = '202325')
ORDER BY nombreP;

-- (4)
-- Listar, para cada Escuela, la cantidad de estudiantes activos, no inscritos y
-- retirados. El listado debe contener el código y nombre de la Escuela así como
-- cantidad de activos, no inscritos y retirados, y un total general de estudiantes (suma
-- de activos, no inscritos y retirados). Debe estar ordenado por total de estudiantes
-- de mayor a menor.

SELECT
  esc.CodEscuela,
  esc.NombreEsc,
  COUNT(CASE WHEN est.StatusEst IN ('Activo') THEN 1 END) activos, 
  COUNT(CASE WHEN est.StatusEst IN ('No inscrito') THEN 1 END) noInscritos,
  COUNT(CASE WHEN est.StatusEst IN ('Retirado') THEN 1 END) retirados,
  COUNT(CASE WHEN est.StatusEst IN ('Activo', 'No inscrito', 'Retirado') THEN 1 END) total
FROM 
  ESCUELA esc
  LEFT JOIN ESTUDIANTES est ON esc.CodEscuela = est.CodEscuela
GROUP BY 
  esc.CodEscuela,
  esc.NombreEsc
ORDER BY total DESC;

-- (5)
-- Listar los estudiantes que hayan cursado alguna asignatura de Taxonomía 9 el lapso
-- pasado y la hayan reprobado. El listado debe contener el Id y Nombre del estudiante,
-- el nombre de la asignatura y la calificación obtenida. Debe ordenar el listado por Id
-- del estudiante.

SELECT 
  est.IdEstudiante,
  est.NombreEst,
  asg.NombreAsig,
  cal.Calificacion
FROM 
  ESTUDIANTES est
  INNER JOIN CALIFICACIONES cal ON est.IdEstudiante = cal.IdEstudiante
  INNER JOIN SECCIONES sec ON cal.NRC = sec.NRC
  INNER JOIN ASIGNATURA asg ON sec.CodAsignatura = asg.CodAsignatura
WHERE 
  sec.Lapso = (
    SELECT DISTINCT Lapso 
    FROM 
      SECCIONES 
    ORDER BY Lapso DESC 
    LIMIT 1 OFFSET 1
  ) AND 
  asg.Taxonomia = 'TA9' AND cal.EstatusN IN ('R')
ORDER BY est.IdEstudiante;
  
-- (6)
-- Listar las asignaturas (Código, Nombre y Semestre) que ya están eliminada del
-- catálogo y la cantidad de estudiantes que la aprobaron. El listado debe estar
-- ordenado por semestre y la cantidad de estudiantes, ambos en forma descendente.

SELECT 
  asg.CodAsignatura,
  asg.NombreAsig,
  asg.Semestre,
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

-- (7)
-- Liste los estudiantes activos que hayan reprobado más de 5 asignaturas distintas y
-- que tengan más de 5 años de estudios. La salida debe mostrar : Id, nombre de
-- estudiante, total de asignaturas cursadas, total de asignaturas reprobadas ,
-- ordenados por total de asignaturas reprobadas en forma descendente.

SELECT 
  est.IdEstudiante, 
  est.NombreEst,
  COUNT(DISTINCT sec.CodAsignatura) asignaturas_cursadas,
  COUNT(
    DISTINCT CASE WHEN cal.EstatusN = 'R' THEN sec.CodAsignatura ELSE NULL END
  ) asignaturas_reprobadas
FROM 
  ESTUDIANTES est
  INNER JOIN calificaciones cal ON est.IdEstudiante = cal.IdEstudiante
  INNER JOIN secciones sec ON cal.NRC = sec.NRC
GROUP BY 
  est.IdEstudiante,
  est.NombreEst
HAVING (
  COUNT(DISTINCT sec.Lapso) > 10
  AND 
  COUNT(DISTINCT CASE WHEN cal.EstatusN = 'R' THEN sec.CodAsignatura ELSE NULL END) > 5
)
ORDER BY asignaturas_reprobadas DESC;

-- (8)
-- Actualizar el Estatus del profesor a “Retirado” y la fecha de egreso con “31-03-2023”,
-- si no tiene carga académica (no tiene asignada al menos un NRC) en el lapso 2023-
-- 25.

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

-- (9)
-- Eliminar los Profesores cuya Estatus sea “Retirado” y la fecha de egreso sea mayor
-- a 10 años, manteniendo la consistencia de la base de datos, y registrando todos los
-- datos contenidos en la tabla Profesores, en un archivo histórico denominado
-- HistoricoProfesor.   

BEGIN;

  CREATE TABLE HISTORICOPROFESOR (
    CedulaProfesor DOM_CEDULA PRIMARY KEY,
    NombreP DOM_NOMBRE,
    DireccionP VARCHAR(32) NOT NULL,
    TelefonoP DOM_TELEFONO,
    FechaIng DOM_FECHAS NOT NULL,
    FechaEgr DOM_FECHAS NOT NULL,
    CONSTRAINT CHK_FechaEgr CHECK (FechaEgr > FechaIng)
  );

  INSERT INTO HISTORICOPROFESOR(
    CedulaProf,
    nombreP,
    DireccionP,
    TelefonoP,
    FechaIng,
    FechaEgr
  )(

  SELECT 
    CedulaProf,
    nombreP,
    DireccionP,
    TelefonoP,
    FechaIng,
    FechaEgr
  FROM 
    PROFESORES
  WHERE(
    StatusP = 'R' 
    AND 
    EXTRACT(YEAR FROM CURRENT_DATE) - EXTRACT(YEAR FROM fecha_egreso) > 10
    AND 
    -- Se hace esta validación extra para asegurar que no se vaya a ingresar un
    -- profesor que ya exista en HISTORICOPROFESOR
    CedulaProf NOT IN (
      SELECT CedulaProf 
      FROM 
        HISTORICOPROFESOR
    )
  )
);

COMMIT;
