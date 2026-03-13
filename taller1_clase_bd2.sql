-- ============================================================
-- SISTEMA DE GESTIÓN LEGAL - ESQUEMA DE BASE DE DATOS
-- Basado en prototipo: Agenda del Día / Gestión de Expedientes
-- ============================================================

-- Tabla de Aseguradoras
CREATE TABLE aseguradoras (
    id INTEGER PRIMARY KEY AUTOINCREMENT,
    nombre VARCHAR(100) NOT NULL UNIQUE,
    telefono VARCHAR(20),
    email VARCHAR(100),
    direccion VARCHAR(200),
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

-- Tabla de Juzgados
CREATE TABLE juzgados (
    id INTEGER PRIMARY KEY AUTOINCREMENT,
    nombre VARCHAR(150) NOT NULL UNIQUE,
    ubicacion VARCHAR(150),
    tipo VARCHAR(50),
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

-- Tabla de Usuarios (abogados/personal)
CREATE TABLE usuarios (
    id INTEGER PRIMARY KEY AUTOINCREMENT,
    username VARCHAR(50) NOT NULL UNIQUE,
    password_hash VARCHAR(256) NOT NULL,
    nombre_completo VARCHAR(150) NOT NULL,
    titulo VARCHAR(50),  -- e.g., "Lic.", "Dr."
    email VARCHAR(100) UNIQUE,
    rol VARCHAR(30) DEFAULT 'usuario',  -- admin, usuario
    activo BOOLEAN DEFAULT 1,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

-- Tabla de Clientes (asegurados/particulares)
CREATE TABLE clientes (
    id INTEGER PRIMARY KEY AUTOINCREMENT,
    nombre VARCHAR(150) NOT NULL,
    cedula VARCHAR(20) UNIQUE,
    telefono VARCHAR(20),
    email VARCHAR(100),
    direccion VARCHAR(200),
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

-- Tabla de Expedientes
CREATE TABLE expedientes (
    id INTEGER PRIMARY KEY AUTOINCREMENT,
    numero_expediente VARCHAR(50) UNIQUE NOT NULL,
    cliente_id INTEGER NOT NULL,
    aseguradora_id INTEGER,          -- NULL si es particular
    juzgado_id INTEGER,
    usuario_asignado_id INTEGER NOT NULL,
    estado VARCHAR(20) NOT NULL DEFAULT 'pendiente',  -- pendiente, en_curso, cerrado
    descripcion TEXT,
    fecha_apertura DATE NOT NULL DEFAULT CURRENT_DATE,
    fecha_cierre DATE,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    FOREIGN KEY (cliente_id) REFERENCES clientes(id),
    FOREIGN KEY (aseguradora_id) REFERENCES aseguradoras(id),
    FOREIGN KEY (juzgado_id) REFERENCES juzgados(id),
    FOREIGN KEY (usuario_asignado_id) REFERENCES usuarios(id)
);

-- Tabla de Audiencias / Agenda
CREATE TABLE audiencias (
    id INTEGER PRIMARY KEY AUTOINCREMENT,
    expediente_id INTEGER NOT NULL,
    juzgado_id INTEGER NOT NULL,
    fecha DATE NOT NULL,
    hora TIME,
    tipo VARCHAR(80),
    notas TEXT,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    FOREIGN KEY (expediente_id) REFERENCES expedientes(id),
    FOREIGN KEY (juzgado_id) REFERENCES juzgados(id)
);

-- ============================================================
-- DATOS DE PRUEBA
-- ============================================================

INSERT INTO aseguradoras (nombre) VALUES
    ('ASSA'),
    ('ANCON'),
    ('CONANCE'),
    ('PARTICULAR'),
    ('INTEROCEANICA');

INSERT INTO juzgados (nombre, ubicacion) VALUES
    ('JUZGADO 5TO (PEDREGAL)', 'Pedregal'),
    ('JUZGADO 4TO (PEDREGAL)', 'Pedregal'),
    ('JUZGADO 1RO (PEDREGAL)', 'Pedregal'),
    ('JUZGADO 3RO (PEDREGAL)', 'Pedregal'),
    ('ALCALDIA DE PANAMA', 'Ciudad de Panamá'),
    ('CHITRE', 'Chitre');

INSERT INTO usuarios (username, password_hash, nombre_completo, titulo, rol) VALUES
    ('admin', 'pbkdf2:sha256:hashed_admin', 'Juan Pérez', 'Lic.', 'admin');

INSERT INTO clientes (nombre) VALUES
    ('ANTHONY TREJOS'),
    ('LUIS MOLINA'),
    ('KATHERINE KENT'),
    ('MARTIN ALVARADO'),
    ('JOEL ARAUZ RODRIGUEZ'),
    ('MICHELLE VEGA'),
    ('CANDICE HENRY');

INSERT INTO expedientes (numero_expediente, cliente_id, aseguradora_id, juzgado_id, usuario_asignado_id, estado) VALUES
    ('EXP-001', 1, 1, 1, 1, 'en_curso'),
    ('EXP-002', 2, 2, 2, 1, 'pendiente'),
    ('EXP-003', 3, 1, 1, 1, 'en_curso'),
    ('EXP-004', 4, 3, 3, 1, 'pendiente'),
    ('EXP-005', 5, 4, 4, 1, 'cerrado'),
    ('EXP-006', 6, 5, 5, 1, 'en_curso'),
    ('EXP-007', 7, 2, 6, 1, 'cerrado');

INSERT INTO audiencias (expediente_id, juzgado_id, fecha, hora, tipo) VALUES
    (1, 1, '2019-01-07', '09:00', 'Audiencia oral'),
    (2, 2, '2019-01-07', '10:30', 'Conciliación'),
    (3, 1, '2019-01-07', '11:00', 'Audiencia oral'),
    (4, 3, '2019-01-07', '14:00', 'Presentación pruebas'),
    (5, 4, '2019-01-07', '15:00', 'Sentencia'),
    (6, 5, '2019-01-07', '09:30', 'Mediación'),
    (7, 6, '2019-01-07', '08:00', 'Audiencia oral');
