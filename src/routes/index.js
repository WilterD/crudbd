import express from 'express';
const router = express.Router();

import conexion from "../database/db.js";
import * as mycrud from "../controllers/crud.js";

router.get('/', (req, res) => {
  res.send('¡Hola, mundo!');
});

router.get('/editar', (req, res) => {
    res.render('editar');
  });
  
  router.get('/crear', (req, res) => {
    const sql = 'SELECT * FROM profesores';
    conexion.query(sql, (error, results) => {
      if (error) {
        throw error;
      }
      console.log(results)
      res.render('crear', { results: results.rows });
    });
  });
  
  router.get('/crear2', (req, res) => {
    res.render('crear2');
  });

router.post('/saveProfesor', (req, res) => {
    const data = req.body;
    mycrud.crearRegistroProfesor(data)
      .then(result => {
        res.json(result);
      })
      .catch(error => {
        console.error(error);
        res.status(500).send('Error interno del servidor');
      });
  });
router.post('/savePruebas', (req, res) => {
    const data = req.body;
    mycrud.crearRegistroPruebas(data)
      .then(result => {
        res.json(result);
      })
      .catch(error => {
        console.error(error);
        res.status(500).send('Error interno del servidor');
      });
  });

export default router;