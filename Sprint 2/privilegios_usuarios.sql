-- --------------------------------------
-- Usuario administrador de la aplicación
-- (para migraciones, cambios de esquema)
-- --------------------------------------
CREATE USER mantenimientos_app WITH ENCRYPTED PASSWORD 'ProyectoTic1';

-- Privilegios de conexión y creación
GRANT CONNECT ON DATABASE postgres TO mantenimientos_app;
GRANT CREATE ON DATABASE postgres TO mantenimientos_app;
GRANT CREATE, USAGE ON SCHEMA public TO mantenimientos_app;

-- Privilegios sobre tablas y secuencias existentes
GRANT ALL PRIVILEGES ON ALL TABLES IN SCHEMA public TO mantenimientos_app;
GRANT ALL PRIVILEGES ON ALL SEQUENCES IN SCHEMA public TO mantenimientos_app;

-- Privilegios sobre objetos futuros
ALTER DEFAULT PRIVILEGES IN SCHEMA public
    GRANT ALL PRIVILEGES ON TABLES TO mantenimientos_app;
ALTER DEFAULT PRIVILEGES IN SCHEMA public
    GRANT ALL PRIVILEGES ON SEQUENCES TO mantenimientos_app;

ALTER USER mantenimientos_app SET search_path TO public;

-- --------------------------------------
-- Usuario de la aplicación
-- (para operaciones del día a día)
-- --------------------------------------
CREATE USER mantenimientos_usr WITH ENCRYPTED PASSWORD 'ProyectoTic1';

-- Privilegios de conexión
GRANT CONNECT ON DATABASE postgres TO mantenimientos_usr;
GRANT USAGE ON SCHEMA public TO mantenimientos_usr;

-- Privilegios sobre tablas existentes
GRANT SELECT, INSERT, UPDATE, DELETE ON ALL TABLES IN SCHEMA public TO mantenimientos_usr;

-- Privilegios sobre secuencias existentes
GRANT USAGE, SELECT ON ALL SEQUENCES IN SCHEMA public TO mantenimientos_usr;

-- Privilegios sobre funciones y procedimientos existentes
GRANT EXECUTE ON ALL FUNCTIONS IN SCHEMA public TO mantenimientos_usr;
GRANT EXECUTE ON ALL PROCEDURES IN SCHEMA public TO mantenimientos_usr;

-- Privilegios sobre objetos futuros
ALTER DEFAULT PRIVILEGES IN SCHEMA public
    GRANT SELECT, INSERT, UPDATE, DELETE ON TABLES TO mantenimientos_usr;
ALTER DEFAULT PRIVILEGES IN SCHEMA public
    GRANT EXECUTE ON ROUTINES TO mantenimientos_usr;
ALTER DEFAULT PRIVILEGES IN SCHEMA public
    GRANT USAGE, SELECT ON SEQUENCES TO mantenimientos_usr;

ALTER USER mantenimientos_usr SET search_path TO public;