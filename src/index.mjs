import express from 'express';
import ejs from 'ejs';
import path from 'path';

import bodyParser from 'body-parser';



import dotenv from 'dotenv';
import indexRoutes from "../src/routes/index.js";
// Cargar las variables de entorno
dotenv.config();

import { fileURLToPath } from 'url';

const __filename = fileURLToPath(import.meta.url);
const __dirname = path.dirname(__filename);

const app = express();

app.use(express.static('public'));

app.use(bodyParser.json());
app.use(bodyParser.urlencoded({ extended: true }));

app.set('view engine', 'ejs');
app.set('views', path.join(__dirname, 'views'));


app.use("/", indexRoutes);


app.listen(3000, () => {
  console.log('El servidor está corriendo en el puerto 3000');
});