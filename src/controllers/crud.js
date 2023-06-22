import conexion from '../database/db.js';

export const crearRegistroProfesor = async (data) => {
  try {
    const query = 'INSERT INTO profesores (cedulaprof, nombrep, direccionp, telefonop, categoria, dedicacion, fechaing, fechaegr, statusp) VALUES ($1, $2, $3, $4, $5, $6, $7, $8, $9) RETURNING *';
    const values = [
      data.cedulaprof,
      data.nombrep,
      data.direccionp,
      data.telefonop,
      data.categoria,
      data.dedicacion,
      data.fechaing,
      data.fechaegr,
      data.statusp
    ];
    const result = await conexion.query(query, values);
    return result.rows[0];
  } catch (error) {
    throw new Error(error.message);
  }
};

export const actualizarRegistroProfesor = async (data) => {
  try {
    const query = 'UPDATE profesores SET nombrep = $1, direccionp = $2, telefonop = $3, categoria = $4, dedicacion = $5, fechaing = $6, fechaegr = $7, statusp = $8 WHERE cedulaprof = $9 RETURNING *';
    const values = [
      data.nombrep,
      data.direccionp,
      data.telefonop,
      data.categoria,
      data.dedicacion,
      data.fechaing,
      data.fechaegr,
      data.statusp,
      data.cedulaprof
    ];
    const result = await conexion.query(query, values);
    return result.rows[0];
  } catch (error) {
    throw new Error(error.message);
  }
};

export const crearRegistroAsignatura = async (data) => {
  try {
    const query = 'INSERT INTO asignatura (codasignatura, nombreasig, uc, semestre, taxonomia, statusa) VALUES ($1, $2, $3, $4, $5, $6) RETURNING *';
    const values = [
      data.codasignatura,
      data.nombreasig,
      data.uc,
      data.semestre,
      data.taxonomia,
      data.statusa
    ];
    const result = await conexion.query(query, values);
    return result.rows[0];
  } catch (error) {
    throw new Error(error.message);
  }
};

export const actualizarRegistroAsignatura = async (data) => {
  try {
    const query = 'UPDATE asignatura SET codasignatura = $1, nombreasig = $2, uc = $3, semestre = $4, taxonomia = $5, statusa = $6 WHERE codasignatura = $1 RETURNING *';
    const values = [
      data.codasignatura,
      data.nombreasig,
      data.uc,
      data.semestre,
      data.taxonomia,
      data.statusa
    ];
    const result = await conexion.query(query, values);
    return result.rows[0];
  } catch (error) {
    throw new Error(error.message);
  }
};

