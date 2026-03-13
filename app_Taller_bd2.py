from flask import Flask, jsonify
import pymysql

app = Flask(__name__)

def get_con():
    return pymysql.connect(
        host="localhost", user="root", password="Aaron2600",
        database="taller1_clase_bd2", port=3306, charset="utf8mb4",
        cursorclass=pymysql.cursors.DictCursor
    )

# ── Usuarios ─────────────────────────────────────────────────
@app.route("/usuarios")
def usuarios():
    datos = query("""
        SELECT id, username, nombre_completo, titulo, email, rol, activo, created_at
        FROM usuarios
    """)
    return jsonify(datos)

# ── Aseguradoras ──────────────────────────────────────────────
@app.route("/aseguradoras")
def aseguradoras():
    datos = query("SELECT * FROM aseguradoras")
    return jsonify(datos)

# ── Juzgados ──────────────────────────────────────────────────
@app.route("/juzgados")
def juzgados():
    datos = query("SELECT * FROM juzgados")
    return jsonify(datos)

# ── Clientes ──────────────────────────────────────────────────
@app.route("/clientes")
def clientes():
    datos = query("SELECT * FROM clientes")
    return jsonify(datos)

# ── Expedientes ───────────────────────────────────────────────
@app.route("/expedientes")
def expedientes():
    datos = query("""
        SELECT
            e.id,
            e.numero_expediente,
            c.nombre            AS cliente,
            a.nombre            AS aseguradora,
            j.nombre            AS juzgado,
            u.nombre_completo   AS abogado,
            e.estado,
            e.descripcion,
            e.fecha_apertura,
            e.fecha_cierre
        FROM expedientes e
        JOIN clientes      c ON e.cliente_id          = c.id
        LEFT JOIN aseguradoras  a ON e.aseguradora_id      = a.id
        LEFT JOIN juzgados      j ON e.juzgado_id          = j.id
        JOIN usuarios      u ON e.usuario_asignado_id  = u.id
    """)
    return jsonify(datos)

if __name__ == "__main__":
    app.run(debug=True)


