
-- =====================================================
-- SISTEMA WEB DE INSCRIPCIONES Y NOTAS - INCOS EL ALTO
-- Gestor de base de datos: PostgreSQL
-- =====================================================

-- 1. TABLA ROL
CREATE TABLE rol (
    id_rol INTEGER GENERATED ALWAYS AS IDENTITY PRIMARY KEY,
    nombre VARCHAR(50)
);

-- 2. TABLA USUARIO
CREATE TABLE usuario (
    id_usuario INTEGER GENERATED ALWAYS AS IDENTITY PRIMARY KEY,
    id_rol INTEGER REFERENCES rol(id_rol),
    nombre_usuario VARCHAR(100),
    contrasena_hash VARCHAR(255),
    correo VARCHAR(150),
    estado VARCHAR(30)
);

-- 3. TABLA ESTUDIANTE
CREATE TABLE estudiante (
    id_estudiante INTEGER GENERATED ALWAYS AS IDENTITY PRIMARY KEY,
    id_usuario INTEGER REFERENCES usuario(id_usuario),
    ci VARCHAR(20),
    nombres VARCHAR(100),
    apellidos VARCHAR(100),
    fecha_nacimiento DATE,
    telefono VARCHAR(20),
    tiene_deuda BOOLEAN
);

-- 4. TABLA DOCENTE
CREATE TABLE docente (
    id_docente INTEGER GENERATED ALWAYS AS IDENTITY PRIMARY KEY,
    id_usuario INTEGER REFERENCES usuario(id_usuario),
    ci VARCHAR(20),
    nombres VARCHAR(100),
    apellidos VARCHAR(100),
    especialidad VARCHAR(100),
    telefono VARCHAR(20)
);

-- 5. TABLA CARRERA
CREATE TABLE carrera (
    id_carrera INTEGER GENERATED ALWAYS AS IDENTITY PRIMARY KEY,
    nombre VARCHAR(150),
    duracion_semestres INTEGER
);

-- 6. TABLA MATERIA
CREATE TABLE materia (
    id_materia INTEGER GENERATED ALWAYS AS IDENTITY PRIMARY KEY,
    id_carrera INTEGER REFERENCES carrera(id_carrera),
    codigo VARCHAR(30),
    nombre VARCHAR(150),
    semestre INTEGER
);

-- 7. TABLA PERIODO ACADEMICO
CREATE TABLE periodo_academico (
    id_periodo INTEGER GENERATED ALWAYS AS IDENTITY PRIMARY KEY,
    gestion INTEGER,
    nombre VARCHAR(100),
    fecha_inicio DATE,
    fecha_fin DATE,
    inscripcion_abierta BOOLEAN
);

-- 8. TABLA PARALELO
CREATE TABLE paralelo (
    id_paralelo INTEGER GENERATED ALWAYS AS IDENTITY PRIMARY KEY,
    id_materia INTEGER REFERENCES materia(id_materia),
    id_periodo INTEGER REFERENCES periodo_academico(id_periodo),
    id_docente INTEGER REFERENCES docente(id_docente),
    nombre VARCHAR(50),
    turno VARCHAR(50),
    cupo INTEGER
);

-- 9. TABLA INSCRIPCION
CREATE TABLE inscripcion (
    id_inscripcion INTEGER GENERATED ALWAYS AS IDENTITY PRIMARY KEY,
    id_estudiante INTEGER REFERENCES estudiante(id_estudiante),
    id_carrera INTEGER REFERENCES carrera(id_carrera),
    id_periodo INTEGER REFERENCES periodo_academico(id_periodo),
    semestre INTEGER,
    fecha_inscripcion DATE,
    estado VARCHAR(30),
    nro_comprobante VARCHAR(50),

    -- Un estudiante solo puede inscribirse
    -- una vez en cada periodo academico.
    CONSTRAINT uq_estudiante_periodo
    UNIQUE (id_estudiante, id_periodo)
);

-- 10. TABLA DETALLE_INSCRIPCION
CREATE TABLE detalle_inscripcion (
    id_detalle INTEGER GENERATED ALWAYS AS IDENTITY PRIMARY KEY,
    id_inscripcion INTEGER REFERENCES inscripcion(id_inscripcion),
    id_paralelo INTEGER REFERENCES paralelo(id_paralelo),

    -- Un paralelo no puede repetirse
    -- dentro de una misma inscripcion.
    CONSTRAINT uq_inscripcion_paralelo
    UNIQUE (id_inscripcion, id_paralelo)
);

-- 11. TABLA CALIFICACION
CREATE TABLE calificacion (
    id_calificacion INTEGER GENERATED ALWAYS AS IDENTITY PRIMARY KEY,
    id_detalle INTEGER UNIQUE REFERENCES detalle_inscripcion(id_detalle),
    nota_teoria NUMERIC(5,2),
    nota_practica NUMERIC(5,2),
    nota_final NUMERIC(5,2),
    estado VARCHAR(30),
    fecha_registro DATE,

    -- Las notas deben estar entre 0 y 100.
    CONSTRAINT chk_nota_teoria
    CHECK (nota_teoria BETWEEN 0 AND 100),

    CONSTRAINT chk_nota_practica
    CHECK (nota_practica BETWEEN 0 AND 100),

    CONSTRAINT chk_nota_final
    CHECK (nota_final BETWEEN 0 AND 100)
);
