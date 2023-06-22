--
-- PostgreSQL database dump
--

-- Dumped from database version 15.2 (Debian 15.2-1.pgdg110+1)
-- Dumped by pg_dump version 15.2 (Debian 15.2-1.pgdg110+1)

SET statement_timeout = 0;
SET lock_timeout = 0;
SET idle_in_transaction_session_timeout = 0;
SET client_encoding = 'UTF8';
SET standard_conforming_strings = on;
SELECT pg_catalog.set_config('search_path', '', false);
SET check_function_bodies = false;
SET xmloption = content;
SET client_min_messages = warning;
SET row_security = off;

--
-- Name: cod_escuela; Type: DOMAIN; Schema: public; Owner: -
--

CREATE DOMAIN public.cod_escuela AS character(4);


--
-- Name: dom_cedula; Type: DOMAIN; Schema: public; Owner: -
--

CREATE DOMAIN public.dom_cedula AS character varying(10);


--
-- Name: dom_fechas; Type: DOMAIN; Schema: public; Owner: -
--

CREATE DOMAIN public.dom_fechas AS date
	CONSTRAINT dom_fechas_check CHECK (((VALUE >= '1950-01-01'::date) AND (VALUE <= '2050-12-31'::date)));


--
-- Name: dom_nombre; Type: DOMAIN; Schema: public; Owner: -
--

CREATE DOMAIN public.dom_nombre AS character varying(60);


--
-- Name: dom_telefono; Type: DOMAIN; Schema: public; Owner: -
--

CREATE DOMAIN public.dom_telefono AS character varying(13);


--
-- Name: enum_categoria; Type: TYPE; Schema: public; Owner: -
--

CREATE TYPE public.enum_categoria AS ENUM (
    'A',
    'I',
    'G',
    'S',
    'T'
);


--
-- Name: enum_dedicacion; Type: TYPE; Schema: public; Owner: -
--

CREATE TYPE public.enum_dedicacion AS ENUM (
    'TC',
    'MT',
    'TV'
);


--
-- Name: enum_estatus_n; Type: TYPE; Schema: public; Owner: -
--

CREATE TYPE public.enum_estatus_n AS ENUM (
    'A',
    'R',
    'E',
    'X'
);


--
-- Name: enum_semestre; Type: TYPE; Schema: public; Owner: -
--

CREATE TYPE public.enum_semestre AS ENUM (
    '1',
    '2',
    '3',
    '4',
    '5',
    '6',
    '7',
    '8',
    '9',
    '10'
);


--
-- Name: enum_status_a; Type: TYPE; Schema: public; Owner: -
--

CREATE TYPE public.enum_status_a AS ENUM (
    'V',
    'R',
    'E'
);


--
-- Name: enum_status_est; Type: TYPE; Schema: public; Owner: -
--

CREATE TYPE public.enum_status_est AS ENUM (
    'Activo',
    'Retirado',
    'No inscrito',
    'Egresado'
);


--
-- Name: enum_status_p; Type: TYPE; Schema: public; Owner: -
--

CREATE TYPE public.enum_status_p AS ENUM (
    'A',
    'R',
    'P',
    'J'
);


--
-- Name: enum_taxonomia; Type: TYPE; Schema: public; Owner: -
--

CREATE TYPE public.enum_taxonomia AS ENUM (
    'TA1',
    'TA2',
    'TA3',
    'TA4',
    'TA5',
    'TA6',
    'TA7',
    'TA8',
    'TA9'
);


--
-- Name: enum_tipo_moneda; Type: TYPE; Schema: public; Owner: -
--

CREATE TYPE public.enum_tipo_moneda AS ENUM (
    'B',
    'D',
    'P'
);


--
-- Name: enum_tipo_pago; Type: TYPE; Schema: public; Owner: -
--

CREATE TYPE public.enum_tipo_pago AS ENUM (
    'T',
    'J',
    'D'
);


SET default_tablespace = '';

SET default_table_access_method = heap;

--
-- Name: asignatura; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.asignatura (
    codasignatura character(5) NOT NULL,
    nombreasig character(40) NOT NULL,
    uc smallint NOT NULL,
    semestre public.enum_semestre NOT NULL,
    taxonomia public.enum_taxonomia NOT NULL,
    statusa public.enum_status_a NOT NULL,
    CONSTRAINT chk_semestre CHECK ((semestre = ANY (ARRAY['1'::public.enum_semestre, '2'::public.enum_semestre, '3'::public.enum_semestre, '4'::public.enum_semestre, '5'::public.enum_semestre, '6'::public.enum_semestre, '7'::public.enum_semestre, '8'::public.enum_semestre, '9'::public.enum_semestre, '10'::public.enum_semestre]))),
    CONSTRAINT chk_statusa CHECK ((statusa = ANY (ARRAY['V'::public.enum_status_a, 'R'::public.enum_status_a, 'E'::public.enum_status_a]))),
    CONSTRAINT chk_taxonomia CHECK ((taxonomia = ANY (ARRAY['TA1'::public.enum_taxonomia, 'TA2'::public.enum_taxonomia, 'TA3'::public.enum_taxonomia, 'TA4'::public.enum_taxonomia, 'TA5'::public.enum_taxonomia, 'TA6'::public.enum_taxonomia, 'TA7'::public.enum_taxonomia, 'TA8'::public.enum_taxonomia, 'TA9'::public.enum_taxonomia])))
);


--
-- Name: calificaciones; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.calificaciones (
    idestudiante integer NOT NULL,
    nrc character(5) NOT NULL,
    calificacion smallint NOT NULL,
    estatusn public.enum_estatus_n NOT NULL,
    CONSTRAINT chk_estatusn CHECK ((estatusn = ANY (ARRAY['A'::public.enum_estatus_n, 'R'::public.enum_estatus_n, 'E'::public.enum_estatus_n, 'X'::public.enum_estatus_n])))
);


--
-- Name: escuela; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.escuela (
    codescuela public.cod_escuela NOT NULL,
    nombreesc character(20) NOT NULL,
    fechacreacion public.dom_fechas NOT NULL
);


--
-- Name: estudiantes; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.estudiantes (
    idestudiante integer NOT NULL,
    cedula public.dom_cedula NOT NULL,
    nombreest public.dom_nombre NOT NULL,
    direccionest character(40),
    telefonoest public.dom_telefono,
    fechanac public.dom_fechas NOT NULL,
    statusest public.enum_status_est NOT NULL,
    codescuela public.cod_escuela NOT NULL,
    CONSTRAINT chk_statusest CHECK ((statusest = ANY (ARRAY['Activo'::public.enum_status_est, 'Retirado'::public.enum_status_est, 'No inscrito'::public.enum_status_est, 'Egresado'::public.enum_status_est])))
);


--
-- Name: estudiantes_idestudiante_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE public.estudiantes_idestudiante_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: estudiantes_idestudiante_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE public.estudiantes_idestudiante_seq OWNED BY public.estudiantes.idestudiante;


--
-- Name: pagos_realizados; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.pagos_realizados (
    numfactura integer NOT NULL,
    idestudiante integer NOT NULL,
    fechaemision public.dom_fechas NOT NULL,
    tipopago public.enum_tipo_pago NOT NULL,
    tipomoneda public.enum_tipo_moneda NOT NULL,
    monto double precision NOT NULL,
    CONSTRAINT chk_monto CHECK ((monto > (0)::double precision)),
    CONSTRAINT chk_tipomoneda CHECK ((tipomoneda = ANY (ARRAY['B'::public.enum_tipo_moneda, 'D'::public.enum_tipo_moneda, 'P'::public.enum_tipo_moneda]))),
    CONSTRAINT chk_tipopago CHECK ((tipopago = ANY (ARRAY['T'::public.enum_tipo_pago, 'J'::public.enum_tipo_pago, 'D'::public.enum_tipo_pago])))
);


--
-- Name: profesores; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.profesores (
    cedulaprof public.dom_cedula NOT NULL,
    nombrep public.dom_nombre NOT NULL,
    direccionp character(255) NOT NULL,
    telefonop public.dom_telefono,
    categoria public.enum_categoria NOT NULL,
    dedicacion public.enum_dedicacion NOT NULL,
    fechaing public.dom_fechas NOT NULL,
    fechaegr public.dom_fechas NOT NULL,
    statusp public.enum_status_p NOT NULL,
    CONSTRAINT chk_categoria CHECK ((categoria = ANY (ARRAY['A'::public.enum_categoria, 'I'::public.enum_categoria, 'G'::public.enum_categoria, 'S'::public.enum_categoria, 'T'::public.enum_categoria]))),
    CONSTRAINT chk_dedicacion CHECK ((dedicacion = ANY (ARRAY['TC'::public.enum_dedicacion, 'MT'::public.enum_dedicacion, 'TV'::public.enum_dedicacion]))),
    CONSTRAINT chk_statusp CHECK ((statusp = ANY (ARRAY['A'::public.enum_status_p, 'R'::public.enum_status_p, 'P'::public.enum_status_p, 'J'::public.enum_status_p])))
);


--
-- Name: secciones; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.secciones (
    nrc character(5) NOT NULL,
    codasignatura character(5) NOT NULL,
    lapso character(6) NOT NULL,
    cedulaprof public.dom_cedula NOT NULL
);


--
-- Name: estudiantes idestudiante; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.estudiantes ALTER COLUMN idestudiante SET DEFAULT nextval('public.estudiantes_idestudiante_seq'::regclass);


--
-- Name: asignatura asignatura_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.asignatura
    ADD CONSTRAINT asignatura_pkey PRIMARY KEY (codasignatura);


--
-- Name: calificaciones calificaciones_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.calificaciones
    ADD CONSTRAINT calificaciones_pkey PRIMARY KEY (idestudiante, nrc);


--
-- Name: escuela escuela_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.escuela
    ADD CONSTRAINT escuela_pkey PRIMARY KEY (codescuela);


--
-- Name: estudiantes estudiantes_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.estudiantes
    ADD CONSTRAINT estudiantes_pkey PRIMARY KEY (idestudiante);


--
-- Name: pagos_realizados pagos_realizados_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.pagos_realizados
    ADD CONSTRAINT pagos_realizados_pkey PRIMARY KEY (numfactura);


--
-- Name: profesores profesores_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.profesores
    ADD CONSTRAINT profesores_pkey PRIMARY KEY (cedulaprof);


--
-- Name: secciones secciones_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.secciones
    ADD CONSTRAINT secciones_pkey PRIMARY KEY (nrc);


--
-- Name: estudiantes uq_cedula; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.estudiantes
    ADD CONSTRAINT uq_cedula UNIQUE (cedula);


--
-- Name: asignatura uq_nombreasig; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.asignatura
    ADD CONSTRAINT uq_nombreasig UNIQUE (nombreasig);


--
-- Name: escuela uq_nombreesc; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.escuela
    ADD CONSTRAINT uq_nombreesc UNIQUE (nombreesc);


--
-- Name: idx_asignatura_semestre; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX idx_asignatura_semestre ON public.asignatura USING btree (semestre);


--
-- Name: idx_estudiantes_nombreest; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX idx_estudiantes_nombreest ON public.estudiantes USING btree (nombreest);


--
-- Name: idx_pagos_realizados_idestudiante; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX idx_pagos_realizados_idestudiante ON public.pagos_realizados USING btree (idestudiante);


--
-- Name: idx_secciones_codasignatura_lapso_cedulaprof; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX idx_secciones_codasignatura_lapso_cedulaprof ON public.secciones USING btree (codasignatura, lapso, cedulaprof);


--
-- Name: idx_secciones_lapso; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX idx_secciones_lapso ON public.secciones USING btree (lapso);


--
-- Name: calificaciones calificaciones_idestudiante_fkey; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.calificaciones
    ADD CONSTRAINT calificaciones_idestudiante_fkey FOREIGN KEY (idestudiante) REFERENCES public.estudiantes(idestudiante) ON UPDATE CASCADE ON DELETE RESTRICT;


--
-- Name: calificaciones calificaciones_nrc_fkey; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.calificaciones
    ADD CONSTRAINT calificaciones_nrc_fkey FOREIGN KEY (nrc) REFERENCES public.secciones(nrc) ON UPDATE CASCADE ON DELETE RESTRICT;


--
-- Name: secciones fk_codasignatura; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.secciones
    ADD CONSTRAINT fk_codasignatura FOREIGN KEY (codasignatura) REFERENCES public.asignatura(codasignatura) ON UPDATE CASCADE ON DELETE RESTRICT;


--
-- Name: estudiantes fk_codeescuela; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.estudiantes
    ADD CONSTRAINT fk_codeescuela FOREIGN KEY (codescuela) REFERENCES public.escuela(codescuela);


--
-- Name: pagos_realizados fk_idestudiante; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.pagos_realizados
    ADD CONSTRAINT fk_idestudiante FOREIGN KEY (idestudiante) REFERENCES public.estudiantes(idestudiante) ON UPDATE CASCADE ON DELETE RESTRICT;


--
-- PostgreSQL database dump complete
--

