# Sistema de Gestión Legal - API REST

Aplicación Flask + SQLite que expone una API REST para gestionar expedientes legales,
audiencias, aseguradoras y juzgados, basada en el prototipo de "Agenda del Día".

## Estructura del Proyecto

```
proyecto_legal/
├── app/
│   └── app.py            # Aplicación Flask principal
├── database/
│   └── schema.sql        # Esquema + datos de prueba
├── requirements.txt
└── README.md
```

## Instalación

```bash
# Crear entorno virtual
python -m venv venv
source venv/bin/activate        # Windows: venv\Scripts\activate

# Instalar dependencias
pip install -r requirements.txt

# Ejecutar (la BD se crea automáticamente al primer inicio)
cd app
python app.py
```

La API queda disponible en `http://localhost:5000`

## Endpoints

### Autenticación
| Método | Ruta | Descripción |
|--------|------|-------------|
| POST | `/api/auth/login` | Obtener token JWT |

**Body login:**
```json
{ "username": "admin", "password": "admin123" }
```

Incluir el token en todas las peticiones:
```
Authorization: Bearer <token>
```

### Agenda
| Método | Ruta | Descripción |
|--------|------|-------------|
| GET | `/api/agenda?fecha=YYYY-MM-DD` | Audiencias del día + estadísticas |

### Expedientes
| Método | Ruta | Descripción |
|--------|------|-------------|
| GET | `/api/expedientes` | Listar expedientes (paginado) |
| GET | `/api/expedientes/{id}` | Detalle de expediente |
| POST | `/api/expedientes` | Crear expediente |
| PUT | `/api/expedientes/{id}` | Actualizar expediente |
| DELETE | `/api/expedientes/{id}` | Eliminar expediente |

**Filtros GET /api/expedientes:**
- `?estado=pendiente|en_curso|cerrado`
- `?page=1&per_page=20`

### Audiencias
| Método | Ruta | Descripción |
|--------|------|-------------|
| POST | `/api/audiencias` | Agendar audiencia |

### Catálogos
| Método | Ruta |
|--------|------|
| GET | `/api/aseguradoras` |
| GET | `/api/juzgados` |
| GET | `/api/usuarios` |

### Reportes
| Método | Ruta | Descripción |
|--------|------|-------------|
| GET | `/api/reportes/resumen` | Totales por estado y aseguradora |

## Ejemplo de Respuesta — Agenda del Día

```json
{
  "fecha": "2019-01-07",
  "audiencias": [
    {
      "asegurado": "ANTHONY TREJOS",
      "aseguradora": "ASSA",
      "juzgado": "JUZGADO 5TO (PEDREGAL)",
      "hora": "09:00",
      "tipo": "Audiencia oral"
    }
  ],
  "estadisticas": {
    "pendientes": 102,
    "en_curso": 72,
    "cerrados": 204
  }
}
```
