# SkyBase — Airline Management System

A full-stack airline management system built on a normalised PostgreSQL database with a Flask web interface, providing complete CRUD operations and multi-table SQL reporting for passengers, flights, bookings, crew, baggage and payments.

> Built as MSc Data Science coursework (University of Greenwich, COMP1879) — replacing three siloed legacy systems with a single normalised database for a fictional airline operator.

---

## Overview

The brief: a fictional airline holds flight schedules, passenger bookings and crew rosters across three separate systems with no shared data layer. Producing an occupancy report requires manual exports from all three and reconciling the results by hand — slow, error-prone, and a GDPR risk because passenger data sits in unprotected spreadsheets.

SkyBase replaces this with a single PostgreSQL database normalised to third normal form, accessed through a Flask web interface. Foreign key constraints enforce referential integrity at the database level, parameterised queries prevent SQL injection throughout the application, and staff can search, update and report through a browser without writing any SQL.

---

## Tech Stack

- **PostgreSQL 18** — relational database
- **Python 3** + **Flask** — web framework
- **psycopg2** — PostgreSQL adapter
- **python-dotenv** — environment configuration
- **HTML / CSS** — front-end (no JavaScript framework, kept deliberately simple)

---

## Key Features

- **Ten-entity normalised schema** (3NF) covering passengers, flights, bookings, payments, crew, aircraft, airports, seats, baggage and crew assignments
- **Full CRUD interface** for passengers and bookings, with read views for flights and crew
- **Operational reports page** powered by five multi-table SQL queries, including 5-table joins with aggregation
- **Authentication** with login-required decorator on every route
- **Parameterised queries throughout** — no string concatenation in SQL, no injection surface
- **Transaction handling** for multi-table writes (booking + payment recorded atomically)
- **Search** across passenger records by name, email or passport

---

## Database Design

The schema covers ten entities normalised to third normal form. The booking table acts as the central transactional entity, linking passenger to flight with optional seat assignment. Crew-to-flight is resolved through a junction table to handle the many-to-many. Airport is referenced twice on flight (departure and arrival) under separate foreign keys.

Design decisions worth flagging:
- **`NUMERIC(10,2)` over `FLOAT`** for monetary amounts to avoid floating-point rounding errors on payment calculations
- **`CHAR(3)` for IATA airport codes** which are always exactly three characters
- **Nullable `seat_id` on booking** because seat assignment happens at check-in rather than at the point of booking — reflecting a real operational rule
- **Surrogate `SERIAL` primary keys** on every entity to avoid dependency on natural keys that may change over time

📄 **[Read the full technical report](docs/SkyBase_Technical_Report.pdf)** — covers the requirements analysis, full ERDs, normalisation walkthrough from UNF through 1NF/2NF/3NF, and a research section on Big Data, Hadoop, NoSQL and NewSQL.

---

## Sample Query

The reports page is powered by SQL queries written directly against the schema. Here's the route revenue query — a 4-table join with aggregation:

```sql
SELECT dep.iata_code || ' → ' || arr.iata_code AS route,
       COUNT(b.booking_id)         AS bookings,
       COALESCE(SUM(pay.amount),0) AS total_revenue
FROM flight f
JOIN airport dep ON f.departure_airport_id = dep.airport_id
JOIN airport arr ON f.arrival_airport_id   = arr.airport_id
LEFT JOIN booking b   ON b.flight_id = f.flight_id AND b.status='Confirmed'
LEFT JOIN payment pay ON pay.booking_id = b.booking_id
GROUP BY dep.iata_code, arr.iata_code
ORDER BY total_revenue DESC;
```

`COALESCE` returns zero rather than `NULL` for routes with no confirmed bookings, keeping the result set complete and sortable.

---

## Setup

### Prerequisites
- Python 3.8 or later
- PostgreSQL 14 or later
- pgAdmin (recommended for database setup)

### Installation

1. Clone this repository
```bash
   git clone https://github.com/Zakguchati/skybase-airline-database.git
   cd skybase-airline-database
```

2. Install Python dependencies
```bash
   pip install -r requirements.txt
```

3. Create a PostgreSQL database called `Skybase`, then restore the dump:
```bash
   psql -U postgres -d Skybase -f skybase_dump.sql
```

4. Copy `.env.example` to `.env` and fill in your local credentials:
```bash
   cp .env.example .env
```

5. Run the application
```bash
   python app.py
```

6. Open `http://localhost:5000` in your browser. Log in using the credentials you set in `.env`.

---

## Project Structure