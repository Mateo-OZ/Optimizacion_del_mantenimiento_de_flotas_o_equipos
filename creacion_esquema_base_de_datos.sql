-- =========================
-- TABLA: Equipos
-- =========================
CREATE TABLE equipos (
    id_equipo SERIAL PRIMARY KEY,
    nombre VARCHAR(100) NOT NULL,
    fabricante VARCHAR(100),
    marca VARCHAR(100),
    modelo VARCHAR(100),
    anio INT
);
-- =========================
-- TABLA: Tecnicos
-- =========================
CREATE TABLE tecnicos (
    id_tecnico SERIAL PRIMARY KEY,
    nombre VARCHAR(100) NOT NULL,
    entidad VARCHAR(100)
);
-- =========================
-- TABLA: Tipo Novedad
-- =========================
CREATE TABLE tipo_novedad (
    id_tipo SERIAL PRIMARY KEY,
    nombre VARCHAR(100) NOT NULL
);
-- =========================
-- TABLA: Repuestos
-- =========================
CREATE TABLE repuestos (
    id_repuesto SERIAL PRIMARY KEY,
    nombre_repuesto VARCHAR(100) NOT NULL,
    referencia VARCHAR(100),
    descripcion TEXT
);
-- =========================
-- TABLA: Componentes
-- =========================
CREATE TABLE componentes (
    id_componente SERIAL PRIMARY KEY,
    fk_id_equipo INT NOT NULL,
    nombre_componente VARCHAR(100) NOT NULL,
    datos_tecnicos TEXT,
    CONSTRAINT fk_equipo
        FOREIGN KEY (fk_id_equipo)
        REFERENCES equipos(id_equipo)
        ON DELETE CASCADE
);
-- =========================
-- TABLA: Intervenciones
-- =========================
CREATE TABLE intervenciones (
    id_intervencion SERIAL PRIMARY KEY,
    fk_id_equipo INT,                        -- NULL: hay intervenciones sin equipo asignado
    fk_id_tipo_novedad INT NOT NULL,
    fecha DATE,                              -- NULL: hay registros sin fecha
    hora_parada TEXT,                        -- TEXT: contiene valores como "27 minutos", "2 horas"
    descripcion TEXT,
    CONSTRAINT fk_equipo_intervencion
        FOREIGN KEY (fk_id_equipo)
        REFERENCES equipos(id_equipo),
    CONSTRAINT fk_tipo_novedad
        FOREIGN KEY (fk_id_tipo_novedad)
        REFERENCES tipo_novedad(id_tipo)
);
-- =========================
-- TABLA: Intervencion_Tecnico
-- =========================
CREATE TABLE intervencion_tecnico (
    id_intervencion_tecnico SERIAL PRIMARY KEY,
    fk_id_intervencion INT NOT NULL,
    fk_id_tecnico INT,                       -- NULL: hay intervenciones sin técnico asignado
    CONSTRAINT fk_intervencion
        FOREIGN KEY (fk_id_intervencion)
        REFERENCES intervenciones(id_intervencion)
        ON DELETE CASCADE,
    CONSTRAINT fk_tecnico
        FOREIGN KEY (fk_id_tecnico)
        REFERENCES tecnicos(id_tecnico)
);
-- =========================
-- TABLA: Detalle Intervencion
-- =========================
CREATE TABLE detalle_intervencion (
    id_detalle SERIAL PRIMARY KEY,
    fk_id_intervencion INT NOT NULL,
    fk_id_componente INT,                    -- NULL: hay detalles sin componente asignado
    fk_id_repuesto INT,
    cantidad_usada INT,
    CONSTRAINT fk_intervencion_detalle
        FOREIGN KEY (fk_id_intervencion)
        REFERENCES intervenciones(id_intervencion)
        ON DELETE CASCADE,
    CONSTRAINT fk_componente
        FOREIGN KEY (fk_id_componente)
        REFERENCES componentes(id_componente),
    CONSTRAINT fk_repuesto
        FOREIGN KEY (fk_id_repuesto)
        REFERENCES repuestos(id_repuesto)
);
