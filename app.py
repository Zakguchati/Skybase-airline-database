"""
SkyBase Airline Management System
COMP1879: Database and Data Infrastructure
Intuitive-Solutions for Diamond Group
Flask + PostgreSQL CRUD Application
"""

from flask import Flask, render_template, request, redirect, url_for, flash, session
from functools import wraps
import psycopg2
import psycopg2.extras 

app = Flask(__name__)
app.secret_key = "skybase_secret_2026"

# ── CREDENTIALS ──────────────────────────────────────────────────────────────
# Simple staff login — username / password
USERS = {
    "admin": "skybase2026",
    "staff": "diamond2026",
}

# ── DATABASE CONNECTION ───────────────────────────────────────────────────────
DB_CONFIG = {
    "host":     "localhost",
    "port":     5432,
    "dbname":   "Skybase",
    "user":     "postgres",
    "password": "odyssey",
}

def get_db():
    conn = psycopg2.connect(**DB_CONFIG)
    conn.autocommit = False
    return conn


def query(sql, params=(), fetchone=False, fetchall=False, commit=False):
    """Helper to run a query and return results."""
    conn = get_db()
    try:
        cur = conn.cursor(cursor_factory=psycopg2.extras.RealDictCursor)
        cur.execute(sql, params)
        if commit:
            conn.commit()
            return cur.rowcount
        if fetchone:
            return cur.fetchone()
        if fetchall:
            return cur.fetchall()
    except Exception as e:
        conn.rollback()
        raise e
    finally:
        conn.close()


# ── LOGIN REQUIRED DECORATOR ─────────────────────────────────────────────────
def login_required(f):
    @wraps(f)
    def decorated(*args, **kwargs):
        if "user" not in session:
            flash("Please log in to access SkyBase.", "error")
            return redirect(url_for("login"))
        return f(*args, **kwargs)
    return decorated


# ── AUTH ROUTES ───────────────────────────────────────────────────────────────
@app.route("/login", methods=["GET", "POST"])
def login():
    if "user" in session:
        return redirect(url_for("dashboard"))
    if request.method == "POST":
        username = request.form.get("username", "").strip()
        password = request.form.get("password", "")
        if username in USERS and USERS[username] == password:
            session["user"] = username
            flash(f"Welcome, {username}.", "success")
            return redirect(url_for("dashboard"))
        flash("Invalid username or password.", "error")
    return render_template("login.html")


@app.route("/logout")
def logout():
    session.pop("user", None)
    flash("You have been logged out.", "success")
    return redirect(url_for("login"))


# ── DASHBOARD ─────────────────────────────────────────────────────────────────
@app.route("/")
@login_required
def dashboard():
    tables = ["passenger", "flight", "booking", "payment",
              "crew", "baggage", "aircraft", "airport", "seat", "crew_assignment"]
    stats = {}
    for t in tables:
        row = query(f"SELECT COUNT(*) AS cnt FROM {t}", fetchone=True)
        stats[t] = row["cnt"]

    recent = query("""
        SELECT b.booking_id,
               p.first_name || ' ' || p.last_name  AS passenger,
               f.flight_number,
               dep.iata_code || ' → ' || arr.iata_code AS route,
               b.seat_class, b.status
        FROM booking b
        JOIN passenger p  ON b.passenger_id = p.passenger_id
        JOIN flight f     ON b.flight_id    = f.flight_id
        JOIN airport dep  ON f.departure_airport_id = dep.airport_id
        JOIN airport arr  ON f.arrival_airport_id   = arr.airport_id
        ORDER BY b.booking_id DESC LIMIT 8
    """, fetchall=True)

    return render_template("dashboard.html", stats=stats, recent=recent)


# ── PASSENGERS ────────────────────────────────────────────────────────────────
@app.route("/passengers")
@login_required
def passengers():
    search = request.args.get("search", "").strip()
    if search:
        rows = query("""
            SELECT * FROM passenger
            WHERE first_name ILIKE %s OR last_name ILIKE %s
               OR email ILIKE %s OR passport_number ILIKE %s
            ORDER BY passenger_id DESC
        """, (f"%{search}%",) * 4, fetchall=True)
    else:
        rows = query("SELECT * FROM passenger ORDER BY passenger_id DESC", fetchall=True)
    return render_template("passengers.html", rows=rows, search=search)


@app.route("/passengers/add", methods=["GET", "POST"])
@login_required
def passenger_add():
    if request.method == "POST":
        try:
            query("""
                INSERT INTO passenger
                  (first_name, last_name, email, phone, date_of_birth,
                   passport_number, nationality, gender)
                VALUES (%s,%s,%s,%s,%s,%s,%s,%s)
            """, (
                request.form["first_name"].strip(),
                request.form["last_name"].strip(),
                request.form["email"].strip(),
                request.form["phone"].strip(),
                request.form["date_of_birth"],
                request.form["passport_number"].strip(),
                request.form["nationality"].strip(),
                request.form["gender"],
            ), commit=True)
            flash("Passenger added successfully.", "success")
            return redirect(url_for("passengers"))
        except Exception as e:
            flash(f"Error: {e}", "error")
    return render_template("passenger_form.html", row=None)


@app.route("/passengers/edit/<int:pid>", methods=["GET", "POST"])
@login_required
def passenger_edit(pid):
    if request.method == "POST":
        try:
            query("""
                UPDATE passenger SET
                  first_name=%s, last_name=%s, email=%s, phone=%s,
                  date_of_birth=%s, passport_number=%s, nationality=%s, gender=%s
                WHERE passenger_id=%s
            """, (
                request.form["first_name"].strip(),
                request.form["last_name"].strip(),
                request.form["email"].strip(),
                request.form["phone"].strip(),
                request.form["date_of_birth"],
                request.form["passport_number"].strip(),
                request.form["nationality"].strip(),
                request.form["gender"],
                pid,
            ), commit=True)
            flash("Passenger updated successfully.", "success")
            return redirect(url_for("passengers"))
        except Exception as e:
            flash(f"Error: {e}", "error")
    row = query("SELECT * FROM passenger WHERE passenger_id=%s", (pid,), fetchone=True)
    return render_template("passenger_form.html", row=row)


@app.route("/passengers/delete/<int:pid>")
@login_required
def passenger_delete(pid):
    try:
        query("DELETE FROM passenger WHERE passenger_id=%s", (pid,), commit=True)
        flash("Passenger deleted.", "success")
    except Exception:
        flash("Cannot delete: passenger has existing bookings.", "error")
    return redirect(url_for("passengers"))


# ── FLIGHTS ───────────────────────────────────────────────────────────────────
@app.route("/flights")
@login_required
def flights():
    rows = query("""
        SELECT f.flight_id, f.flight_number,
               dep.iata_code || ' (' || dep.city || ')' AS departure,
               arr.iata_code || ' (' || arr.city || ')' AS arrival,
               f.departure_time, f.arrival_time,
               ac.model AS aircraft, f.base_price, f.status,
               COUNT(b.booking_id) AS bookings
        FROM flight f
        JOIN airport dep ON f.departure_airport_id = dep.airport_id
        JOIN airport arr ON f.arrival_airport_id   = arr.airport_id
        JOIN aircraft ac ON f.aircraft_id           = ac.aircraft_id
        LEFT JOIN booking b ON b.flight_id = f.flight_id
        GROUP BY f.flight_id, dep.iata_code, dep.city,
                 arr.iata_code, arr.city, ac.model
        ORDER BY f.departure_time DESC
    """, fetchall=True)
    return render_template("flights.html", rows=rows)


# ── BOOKINGS ──────────────────────────────────────────────────────────────────
@app.route("/bookings")
@login_required
def bookings():
    rows = query("""
        SELECT b.booking_id,
               p.first_name || ' ' || p.last_name  AS passenger,
               f.flight_number,
               dep.iata_code || '→' || arr.iata_code AS route,
               b.seat_class, b.status, b.booking_date,
               pay.amount, pay.payment_method, pay.status AS payment_status
        FROM booking b
        JOIN passenger p  ON b.passenger_id = p.passenger_id
        JOIN flight f     ON b.flight_id    = f.flight_id
        JOIN airport dep  ON f.departure_airport_id = dep.airport_id
        JOIN airport arr  ON f.arrival_airport_id   = arr.airport_id
        LEFT JOIN payment pay ON pay.booking_id = b.booking_id
        ORDER BY b.booking_id DESC
    """, fetchall=True)
    return render_template("bookings.html", rows=rows)


@app.route("/bookings/add", methods=["GET", "POST"])
@login_required
def booking_add():
    if request.method == "POST":
        try:
            conn = get_db()
            cur  = conn.cursor(cursor_factory=psycopg2.extras.RealDictCursor)
            cur.execute("""
                INSERT INTO booking (passenger_id, flight_id, seat_class, status)
                VALUES (%s,%s,%s,'Confirmed') RETURNING booking_id
            """, (request.form["passenger_id"], request.form["flight_id"],
                  request.form["seat_class"]))
            new_id = cur.fetchone()["booking_id"]
            cur.execute("""
                INSERT INTO payment (booking_id, amount, currency, payment_method, status)
                VALUES (%s,%s,'GBP',%s,'Completed')
            """, (new_id, request.form["amount"], request.form["payment_method"]))
            conn.commit()
            conn.close()
            flash(f"Booking #{new_id} created with payment recorded.", "success")
            return redirect(url_for("bookings"))
        except Exception as e:
            flash(f"Error: {e}", "error")

    passengers_list = query(
        "SELECT passenger_id, first_name || ' ' || last_name AS name FROM passenger ORDER BY last_name",
        fetchall=True)
    flights_list = query("""
        SELECT f.flight_id,
               f.flight_number || ' — ' || dep.iata_code || '→' || arr.iata_code
               || '  (' || TO_CHAR(f.departure_time,'DD Mon HH24:MI') || ')' AS label
        FROM flight f
        JOIN airport dep ON f.departure_airport_id = dep.airport_id
        JOIN airport arr ON f.arrival_airport_id   = arr.airport_id
        ORDER BY f.departure_time
    """, fetchall=True)
    return render_template("booking_form.html",
                           passengers=passengers_list, flights=flights_list)


@app.route("/bookings/delete/<int:bid>")
@login_required
def booking_delete(bid):
    try:
        conn = get_db()
        cur  = conn.cursor()
        cur.execute("DELETE FROM payment WHERE booking_id=%s", (bid,))
        cur.execute("DELETE FROM baggage  WHERE booking_id=%s", (bid,))
        cur.execute("DELETE FROM booking  WHERE booking_id=%s", (bid,))
        conn.commit()
        conn.close()
        flash("Booking cancelled.", "success")
    except Exception as e:
        flash(f"Error: {e}", "error")
    return redirect(url_for("bookings"))


# ── REPORTS ───────────────────────────────────────────────────────────────────
@app.route("/reports")
@login_required
def reports():
    revenue = query("""
        SELECT dep.iata_code || ' → ' || arr.iata_code AS route,
               COUNT(b.booking_id)         AS bookings,
               COALESCE(SUM(pay.amount),0) AS total_revenue
        FROM flight f
        JOIN airport dep ON f.departure_airport_id = dep.airport_id
        JOIN airport arr ON f.arrival_airport_id   = arr.airport_id
        LEFT JOIN booking b  ON b.flight_id  = f.flight_id AND b.status='Confirmed'
        LEFT JOIN payment pay ON pay.booking_id = b.booking_id
        GROUP BY dep.iata_code, arr.iata_code
        ORDER BY total_revenue DESC
    """, fetchall=True)

    occupancy = query("""
        SELECT f.flight_number,
               dep.iata_code || '→' || arr.iata_code AS route,
               ac.total_seats,
               COUNT(b.booking_id) AS booked,
               ROUND((COUNT(b.booking_id)::DECIMAL / NULLIF(ac.total_seats,0))*100,1) AS pct
        FROM flight f
        JOIN aircraft ac ON f.aircraft_id = ac.aircraft_id
        JOIN airport dep ON f.departure_airport_id = dep.airport_id
        JOIN airport arr ON f.arrival_airport_id   = arr.airport_id
        LEFT JOIN booking b ON b.flight_id=f.flight_id AND b.status='Confirmed'
        GROUP BY f.flight_id, f.flight_number, dep.iata_code, arr.iata_code, ac.total_seats
        ORDER BY pct DESC NULLS LAST
    """, fetchall=True)

    crew_load = query("""
        SELECT cr.first_name || ' ' || cr.last_name AS crew_member,
               cr.role, COUNT(ca.assignment_id) AS total_flights
        FROM crew cr
        LEFT JOIN crew_assignment ca ON ca.crew_id = cr.crew_id
        GROUP BY cr.crew_id, cr.first_name, cr.last_name, cr.role
        ORDER BY total_flights DESC
    """, fetchall=True)

    payments = query("""
        SELECT payment_method,
               COUNT(*)          AS transactions,
               SUM(amount)       AS total,
               ROUND(AVG(amount),2) AS avg_amount
        FROM payment GROUP BY payment_method ORDER BY total DESC
    """, fetchall=True)

    max_rev = max((r["total_revenue"] for r in revenue), default=1) or 1

    return render_template("reports.html",
                           revenue=revenue, occupancy=occupancy,
                           crew_load=crew_load, payments=payments,
                           max_rev=max_rev)


if __name__ == "__main__":
    app.run(debug=True, port=5000)
