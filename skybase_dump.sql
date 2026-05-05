--
-- PostgreSQL database dump
--

\restrict aPs3f9sRbneA74TjfJ2mMKoKK0mzAfRPXpSZPz2nykle09IHx3bbuzxs9et6NIy

-- Dumped from database version 18.3
-- Dumped by pg_dump version 18.3

-- Started on 2026-05-05 17:12:29

SET statement_timeout = 0;
SET lock_timeout = 0;
SET idle_in_transaction_session_timeout = 0;
SET transaction_timeout = 0;
SET client_encoding = 'UTF8';
SET standard_conforming_strings = on;
SELECT pg_catalog.set_config('search_path', '', false);
SET check_function_bodies = false;
SET xmloption = content;
SET client_min_messages = warning;
SET row_security = off;

SET default_tablespace = '';

SET default_table_access_method = heap;

--
-- TOC entry 222 (class 1259 OID 16882)
-- Name: aircraft; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.aircraft (
    aircraft_id integer NOT NULL,
    registration_number character varying(15) NOT NULL,
    model character varying(50) NOT NULL,
    manufacturer character varying(50) NOT NULL,
    total_seats integer NOT NULL,
    year_manufactured integer NOT NULL,
    status character varying(20) DEFAULT 'Active'::character varying NOT NULL,
    CONSTRAINT aircraft_status_check CHECK (((status)::text = ANY ((ARRAY['Active'::character varying, 'Grounded'::character varying, 'Maintenance'::character varying])::text[]))),
    CONSTRAINT aircraft_total_seats_check CHECK ((total_seats > 0)),
    CONSTRAINT aircraft_year_manufactured_check CHECK ((year_manufactured >= 1900))
);


ALTER TABLE public.aircraft OWNER TO postgres;

--
-- TOC entry 221 (class 1259 OID 16881)
-- Name: aircraft_aircraft_id_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE public.aircraft_aircraft_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER SEQUENCE public.aircraft_aircraft_id_seq OWNER TO postgres;

--
-- TOC entry 5168 (class 0 OID 0)
-- Dependencies: 221
-- Name: aircraft_aircraft_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE public.aircraft_aircraft_id_seq OWNED BY public.aircraft.aircraft_id;


--
-- TOC entry 220 (class 1259 OID 16867)
-- Name: airport; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.airport (
    airport_id integer NOT NULL,
    iata_code character(3) NOT NULL,
    name character varying(100) NOT NULL,
    city character varying(50) NOT NULL,
    country character varying(50) NOT NULL,
    timezone character varying(50) NOT NULL
);


ALTER TABLE public.airport OWNER TO postgres;

--
-- TOC entry 219 (class 1259 OID 16866)
-- Name: airport_airport_id_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE public.airport_airport_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER SEQUENCE public.airport_airport_id_seq OWNER TO postgres;

--
-- TOC entry 5169 (class 0 OID 0)
-- Dependencies: 219
-- Name: airport_airport_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE public.airport_airport_id_seq OWNED BY public.airport.airport_id;


--
-- TOC entry 236 (class 1259 OID 17058)
-- Name: baggage; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.baggage (
    baggage_id integer NOT NULL,
    booking_id integer NOT NULL,
    tag_number character varying(20) NOT NULL,
    weight_kg numeric(5,2) NOT NULL,
    baggage_type character varying(20) NOT NULL,
    status character varying(20) DEFAULT 'Checked-In'::character varying NOT NULL,
    CONSTRAINT baggage_baggage_type_check CHECK (((baggage_type)::text = ANY ((ARRAY['Carry-on'::character varying, 'Checked'::character varying, 'Oversized'::character varying])::text[]))),
    CONSTRAINT baggage_status_check CHECK (((status)::text = ANY ((ARRAY['Checked-In'::character varying, 'Loaded'::character varying, 'In-Transit'::character varying, 'Delivered'::character varying, 'Lost'::character varying])::text[]))),
    CONSTRAINT baggage_weight_kg_check CHECK ((weight_kg > (0)::numeric))
);


ALTER TABLE public.baggage OWNER TO postgres;

--
-- TOC entry 235 (class 1259 OID 17057)
-- Name: baggage_baggage_id_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE public.baggage_baggage_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER SEQUENCE public.baggage_baggage_id_seq OWNER TO postgres;

--
-- TOC entry 5170 (class 0 OID 0)
-- Dependencies: 235
-- Name: baggage_baggage_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE public.baggage_baggage_id_seq OWNED BY public.baggage.baggage_id;


--
-- TOC entry 232 (class 1259 OID 17001)
-- Name: booking; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.booking (
    booking_id integer NOT NULL,
    passenger_id integer NOT NULL,
    flight_id integer NOT NULL,
    seat_id integer,
    booking_date timestamp without time zone DEFAULT now() NOT NULL,
    seat_class character varying(20) NOT NULL,
    status character varying(20) DEFAULT 'Confirmed'::character varying NOT NULL,
    CONSTRAINT booking_seat_class_check CHECK (((seat_class)::text = ANY ((ARRAY['Economy'::character varying, 'Business'::character varying, 'First'::character varying])::text[]))),
    CONSTRAINT booking_status_check CHECK (((status)::text = ANY ((ARRAY['Confirmed'::character varying, 'Cancelled'::character varying, 'Checked-In'::character varying, 'Completed'::character varying])::text[])))
);


ALTER TABLE public.booking OWNER TO postgres;

--
-- TOC entry 231 (class 1259 OID 17000)
-- Name: booking_booking_id_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE public.booking_booking_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER SEQUENCE public.booking_booking_id_seq OWNER TO postgres;

--
-- TOC entry 5171 (class 0 OID 0)
-- Dependencies: 231
-- Name: booking_booking_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE public.booking_booking_id_seq OWNED BY public.booking.booking_id;


--
-- TOC entry 226 (class 1259 OID 16922)
-- Name: crew; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.crew (
    crew_id integer NOT NULL,
    first_name character varying(50) NOT NULL,
    last_name character varying(50) NOT NULL,
    email character varying(100) NOT NULL,
    phone character varying(20) NOT NULL,
    role character varying(50) NOT NULL,
    licence_number character varying(20),
    date_of_joining date NOT NULL,
    CONSTRAINT crew_role_check CHECK (((role)::text = ANY ((ARRAY['Pilot'::character varying, 'First Officer'::character varying, 'Cabin Crew'::character varying, 'Purser'::character varying, 'Ground Staff'::character varying])::text[])))
);


ALTER TABLE public.crew OWNER TO postgres;

--
-- TOC entry 238 (class 1259 OID 17082)
-- Name: crew_assignment; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.crew_assignment (
    assignment_id integer NOT NULL,
    crew_id integer NOT NULL,
    flight_id integer NOT NULL,
    role_on_flight character varying(50) NOT NULL,
    CONSTRAINT crew_assignment_role_on_flight_check CHECK (((role_on_flight)::text = ANY ((ARRAY['Captain'::character varying, 'First Officer'::character varying, 'Purser'::character varying, 'Cabin Crew'::character varying, 'Ground Staff'::character varying])::text[])))
);


ALTER TABLE public.crew_assignment OWNER TO postgres;

--
-- TOC entry 237 (class 1259 OID 17081)
-- Name: crew_assignment_assignment_id_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE public.crew_assignment_assignment_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER SEQUENCE public.crew_assignment_assignment_id_seq OWNER TO postgres;

--
-- TOC entry 5172 (class 0 OID 0)
-- Dependencies: 237
-- Name: crew_assignment_assignment_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE public.crew_assignment_assignment_id_seq OWNED BY public.crew_assignment.assignment_id;


--
-- TOC entry 225 (class 1259 OID 16921)
-- Name: crew_crew_id_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE public.crew_crew_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER SEQUENCE public.crew_crew_id_seq OWNER TO postgres;

--
-- TOC entry 5173 (class 0 OID 0)
-- Dependencies: 225
-- Name: crew_crew_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE public.crew_crew_id_seq OWNED BY public.crew.crew_id;


--
-- TOC entry 228 (class 1259 OID 16941)
-- Name: flight; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.flight (
    flight_id integer NOT NULL,
    flight_number character varying(10) NOT NULL,
    departure_airport_id integer NOT NULL,
    arrival_airport_id integer NOT NULL,
    aircraft_id integer NOT NULL,
    departure_time timestamp without time zone NOT NULL,
    arrival_time timestamp without time zone NOT NULL,
    status character varying(20) DEFAULT 'Scheduled'::character varying NOT NULL,
    base_price numeric(10,2) NOT NULL,
    CONSTRAINT chk_flight_times CHECK ((arrival_time > departure_time)),
    CONSTRAINT flight_base_price_check CHECK ((base_price >= (0)::numeric)),
    CONSTRAINT flight_status_check CHECK (((status)::text = ANY ((ARRAY['Scheduled'::character varying, 'Boarding'::character varying, 'Departed'::character varying, 'Arrived'::character varying, 'Cancelled'::character varying, 'Delayed'::character varying])::text[])))
);


ALTER TABLE public.flight OWNER TO postgres;

--
-- TOC entry 227 (class 1259 OID 16940)
-- Name: flight_flight_id_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE public.flight_flight_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER SEQUENCE public.flight_flight_id_seq OWNER TO postgres;

--
-- TOC entry 5174 (class 0 OID 0)
-- Dependencies: 227
-- Name: flight_flight_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE public.flight_flight_id_seq OWNED BY public.flight.flight_id;


--
-- TOC entry 224 (class 1259 OID 16902)
-- Name: passenger; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.passenger (
    passenger_id integer NOT NULL,
    first_name character varying(50) NOT NULL,
    last_name character varying(50) NOT NULL,
    email character varying(100) NOT NULL,
    phone character varying(20) NOT NULL,
    date_of_birth date NOT NULL,
    passport_number character varying(20),
    nationality character varying(50),
    gender character varying(10),
    created_at timestamp without time zone DEFAULT now() NOT NULL,
    CONSTRAINT passenger_gender_check CHECK (((gender)::text = ANY ((ARRAY['Male'::character varying, 'Female'::character varying, 'Other'::character varying])::text[])))
);


ALTER TABLE public.passenger OWNER TO postgres;

--
-- TOC entry 239 (class 1259 OID 17106)
-- Name: passenger_bookings; Type: VIEW; Schema: public; Owner: postgres
--

CREATE VIEW public.passenger_bookings AS
 SELECT p.first_name,
    p.last_name,
    f.flight_number,
    b.seat_class,
    b.status
   FROM ((public.passenger p
     JOIN public.booking b ON ((p.passenger_id = b.passenger_id)))
     JOIN public.flight f ON ((b.flight_id = f.flight_id)));


ALTER VIEW public.passenger_bookings OWNER TO postgres;

--
-- TOC entry 223 (class 1259 OID 16901)
-- Name: passenger_passenger_id_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE public.passenger_passenger_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER SEQUENCE public.passenger_passenger_id_seq OWNER TO postgres;

--
-- TOC entry 5175 (class 0 OID 0)
-- Dependencies: 223
-- Name: passenger_passenger_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE public.passenger_passenger_id_seq OWNED BY public.passenger.passenger_id;


--
-- TOC entry 234 (class 1259 OID 17033)
-- Name: payment; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.payment (
    payment_id integer NOT NULL,
    booking_id integer NOT NULL,
    amount numeric(10,2) NOT NULL,
    currency character(3) DEFAULT 'GBP'::bpchar NOT NULL,
    payment_method character varying(30) NOT NULL,
    payment_date timestamp without time zone DEFAULT now() NOT NULL,
    status character varying(20) DEFAULT 'Pending'::character varying NOT NULL,
    CONSTRAINT payment_amount_check CHECK ((amount > (0)::numeric)),
    CONSTRAINT payment_payment_method_check CHECK (((payment_method)::text = ANY ((ARRAY['Credit Card'::character varying, 'Debit Card'::character varying, 'PayPal'::character varying, 'Bank Transfer'::character varying])::text[]))),
    CONSTRAINT payment_status_check CHECK (((status)::text = ANY ((ARRAY['Pending'::character varying, 'Completed'::character varying, 'Refunded'::character varying, 'Failed'::character varying])::text[])))
);


ALTER TABLE public.payment OWNER TO postgres;

--
-- TOC entry 233 (class 1259 OID 17032)
-- Name: payment_payment_id_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE public.payment_payment_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER SEQUENCE public.payment_payment_id_seq OWNER TO postgres;

--
-- TOC entry 5176 (class 0 OID 0)
-- Dependencies: 233
-- Name: payment_payment_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE public.payment_payment_id_seq OWNED BY public.payment.payment_id;


--
-- TOC entry 230 (class 1259 OID 16978)
-- Name: seat; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.seat (
    seat_id integer NOT NULL,
    aircraft_id integer NOT NULL,
    seat_number character varying(5) NOT NULL,
    seat_class character varying(20) NOT NULL,
    is_window boolean DEFAULT false NOT NULL,
    is_aisle boolean DEFAULT false NOT NULL,
    CONSTRAINT seat_seat_class_check CHECK (((seat_class)::text = ANY ((ARRAY['Economy'::character varying, 'Business'::character varying, 'First'::character varying])::text[])))
);


ALTER TABLE public.seat OWNER TO postgres;

--
-- TOC entry 229 (class 1259 OID 16977)
-- Name: seat_seat_id_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE public.seat_seat_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER SEQUENCE public.seat_seat_id_seq OWNER TO postgres;

--
-- TOC entry 5177 (class 0 OID 0)
-- Dependencies: 229
-- Name: seat_seat_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE public.seat_seat_id_seq OWNED BY public.seat.seat_id;


--
-- TOC entry 4906 (class 2604 OID 16885)
-- Name: aircraft aircraft_id; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.aircraft ALTER COLUMN aircraft_id SET DEFAULT nextval('public.aircraft_aircraft_id_seq'::regclass);


--
-- TOC entry 4905 (class 2604 OID 16870)
-- Name: airport airport_id; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.airport ALTER COLUMN airport_id SET DEFAULT nextval('public.airport_airport_id_seq'::regclass);


--
-- TOC entry 4923 (class 2604 OID 17061)
-- Name: baggage baggage_id; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.baggage ALTER COLUMN baggage_id SET DEFAULT nextval('public.baggage_baggage_id_seq'::regclass);


--
-- TOC entry 4916 (class 2604 OID 17004)
-- Name: booking booking_id; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.booking ALTER COLUMN booking_id SET DEFAULT nextval('public.booking_booking_id_seq'::regclass);


--
-- TOC entry 4910 (class 2604 OID 16925)
-- Name: crew crew_id; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.crew ALTER COLUMN crew_id SET DEFAULT nextval('public.crew_crew_id_seq'::regclass);


--
-- TOC entry 4925 (class 2604 OID 17085)
-- Name: crew_assignment assignment_id; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.crew_assignment ALTER COLUMN assignment_id SET DEFAULT nextval('public.crew_assignment_assignment_id_seq'::regclass);


--
-- TOC entry 4911 (class 2604 OID 16944)
-- Name: flight flight_id; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.flight ALTER COLUMN flight_id SET DEFAULT nextval('public.flight_flight_id_seq'::regclass);


--
-- TOC entry 4908 (class 2604 OID 16905)
-- Name: passenger passenger_id; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.passenger ALTER COLUMN passenger_id SET DEFAULT nextval('public.passenger_passenger_id_seq'::regclass);


--
-- TOC entry 4919 (class 2604 OID 17036)
-- Name: payment payment_id; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.payment ALTER COLUMN payment_id SET DEFAULT nextval('public.payment_payment_id_seq'::regclass);


--
-- TOC entry 4913 (class 2604 OID 16981)
-- Name: seat seat_id; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.seat ALTER COLUMN seat_id SET DEFAULT nextval('public.seat_seat_id_seq'::regclass);


--
-- TOC entry 5146 (class 0 OID 16882)
-- Dependencies: 222
-- Data for Name: aircraft; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.aircraft (aircraft_id, registration_number, model, manufacturer, total_seats, year_manufactured, status) FROM stdin;
1	G-DIAM1	Airbus A320	Airbus	180	2018	Active
2	G-DIAM2	Boeing 777-300	Boeing	396	2017	Active
3	G-DIAM3	Airbus A380	Airbus	555	2019	Active
4	G-DIAM4	Boeing 737-800	Boeing	162	2016	Active
5	G-DIAM5	Airbus A350	Airbus	369	2020	Active
6	G-DIAM6	Boeing 787-9	Boeing	296	2021	Active
7	G-DIAM7	Airbus A321	Airbus	220	2019	Maintenance
8	G-DIAM8	Boeing 737 MAX	Boeing	178	2022	Active
9	G-DIAM9	Airbus A319	Airbus	124	2015	Active
10	G-DIAM0	Boeing 767-300	Boeing	269	2014	Grounded
\.


--
-- TOC entry 5144 (class 0 OID 16867)
-- Dependencies: 220
-- Data for Name: airport; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.airport (airport_id, iata_code, name, city, country, timezone) FROM stdin;
1	LHR	Heathrow Airport	London	United Kingdom	Europe/London
2	JFK	John F. Kennedy International	New York	United States	America/New_York
3	DXB	Dubai International Airport	Dubai	UAE	Asia/Dubai
4	CDG	Charles de Gaulle Airport	Paris	France	Europe/Paris
5	AMS	Amsterdam Schiphol Airport	Amsterdam	Netherlands	Europe/Amsterdam
6	SIN	Singapore Changi Airport	Singapore	Singapore	Asia/Singapore
7	HKG	Hong Kong International Airport	Hong Kong	China	Asia/Hong_Kong
8	LAX	Los Angeles International Airport	Los Angeles	United States	America/Los_Angeles
9	FRA	Frankfurt Airport	Frankfurt	Germany	Europe/Berlin
10	IST	Istanbul Airport	Istanbul	Turkey	Europe/Istanbul
\.


--
-- TOC entry 5160 (class 0 OID 17058)
-- Dependencies: 236
-- Data for Name: baggage; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.baggage (baggage_id, booking_id, tag_number, weight_kg, baggage_type, status) FROM stdin;
1	1	TAG-0001	22.50	Checked	Delivered
2	1	TAG-0002	7.00	Carry-on	Delivered
3	2	TAG-0003	18.00	Checked	Delivered
4	3	TAG-0004	25.00	Checked	Delivered
5	3	TAG-0005	12.00	Checked	Delivered
6	4	TAG-0006	20.00	Checked	Delivered
7	5	TAG-0007	30.00	Oversized	Delivered
8	6	TAG-0008	23.00	Checked	Delivered
9	7	TAG-0009	19.50	Checked	Delivered
10	8	TAG-0010	15.00	Checked	In-Transit
11	9	TAG-0011	21.00	Checked	In-Transit
12	10	TAG-0012	28.00	Checked	Checked-In
13	11	TAG-0013	24.00	Checked	Checked-In
14	12	TAG-0014	17.50	Checked	Checked-In
15	13	TAG-0015	8.00	Carry-on	Checked-In
16	14	TAG-0016	22.00	Checked	Checked-In
17	15	TAG-0017	16.00	Checked	Checked-In
18	16	TAG-0018	26.00	Checked	Checked-In
19	17	TAG-0019	13.50	Carry-on	Checked-In
20	18	TAG-0020	20.00	Checked	Checked-In
\.


--
-- TOC entry 5156 (class 0 OID 17001)
-- Dependencies: 232
-- Data for Name: booking; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.booking (booking_id, passenger_id, flight_id, seat_id, booking_date, seat_class, status) FROM stdin;
1	1	1	5	2026-03-01 10:00:00	Economy	Confirmed
2	2	1	6	2026-03-01 11:00:00	Economy	Confirmed
3	3	3	7	2026-03-02 09:30:00	First	Confirmed
4	4	2	5	2026-03-02 14:00:00	Economy	Confirmed
5	5	5	13	2026-03-03 08:00:00	First	Confirmed
6	6	1	3	2026-03-03 16:00:00	Business	Confirmed
7	7	6	15	2026-03-04 10:00:00	Business	Confirmed
8	8	7	21	2026-03-04 12:00:00	Economy	Confirmed
9	9	8	25	2026-03-05 09:00:00	Economy	Confirmed
10	10	3	8	2026-03-05 11:00:00	First	Confirmed
11	11	9	26	2026-03-06 13:00:00	First	Confirmed
12	12	10	28	2026-03-06 15:00:00	Economy	Confirmed
13	13	11	22	2026-03-07 08:30:00	Economy	Confirmed
14	14	12	24	2026-03-07 10:00:00	Business	Confirmed
15	15	13	\N	2026-03-08 14:00:00	Economy	Confirmed
16	1	14	\N	2026-03-08 16:00:00	Business	Confirmed
17	2	15	\N	2026-03-09 09:00:00	Economy	Confirmed
18	3	4	9	2026-03-09 11:00:00	Business	Confirmed
19	4	5	14	2026-03-10 08:00:00	Business	Confirmed
20	5	6	16	2026-03-10 10:00:00	Economy	Cancelled
\.


--
-- TOC entry 5150 (class 0 OID 16922)
-- Dependencies: 226
-- Data for Name: crew; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.crew (crew_id, first_name, last_name, email, phone, role, licence_number, date_of_joining) FROM stdin;
1	Robert	Brown	r.brown@skybase.com	+447700800001	Pilot	LIC-001	2015-06-01
2	Patricia	Davis	p.davis@skybase.com	+447700800002	First Officer	LIC-002	2017-03-15
3	Michael	Jones	m.jones@skybase.com	+447700800003	Pilot	LIC-003	2014-09-20
4	Linda	Taylor	l.taylor@skybase.com	+447700800004	Cabin Crew	\N	2019-01-10
5	William	Anderson	w.anderson@skybase.com	+447700800005	Purser	\N	2016-07-22
6	Barbara	Thomas	b.thomas@skybase.com	+447700800006	Cabin Crew	\N	2020-04-05
7	Richard	Jackson	r.jackson@skybase.com	+447700800007	Pilot	LIC-007	2013-11-30
8	Susan	White	s.white@skybase.com	+447700800008	First Officer	LIC-008	2018-08-17
9	Joseph	Harris	j.harris@skybase.com	+447700800009	Cabin Crew	\N	2021-02-28
10	Jessica	Martin	j.martin@skybase.com	+447700800010	Cabin Crew	\N	2020-11-14
11	Thomas	Garcia	t.garcia@skybase.com	+447700800011	Pilot	LIC-011	2012-05-09
12	Karen	Martinez	k.martinez@skybase.com	+447700800012	Purser	\N	2017-10-03
13	Charles	Robinson	c.robinson@skybase.com	+447700800013	First Officer	LIC-013	2019-06-25
14	Nancy	Clark	n.clark@skybase.com	+447700800014	Cabin Crew	\N	2022-01-17
15	Daniel	Lewis	d.lewis@skybase.com	+447700800015	Ground Staff	\N	2023-03-08
\.


--
-- TOC entry 5162 (class 0 OID 17082)
-- Dependencies: 238
-- Data for Name: crew_assignment; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.crew_assignment (assignment_id, crew_id, flight_id, role_on_flight) FROM stdin;
1	1	1	Captain
2	2	1	First Officer
3	4	1	Cabin Crew
4	5	1	Purser
5	3	2	Captain
6	8	2	First Officer
7	6	2	Cabin Crew
8	7	3	Captain
9	13	3	First Officer
10	4	3	Cabin Crew
11	12	3	Purser
12	11	4	Captain
13	2	4	First Officer
14	9	4	Cabin Crew
15	1	5	Captain
16	8	5	First Officer
17	10	5	Cabin Crew
18	3	6	Captain
19	13	6	First Officer
20	6	6	Cabin Crew
\.


--
-- TOC entry 5152 (class 0 OID 16941)
-- Dependencies: 228
-- Data for Name: flight; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.flight (flight_id, flight_number, departure_airport_id, arrival_airport_id, aircraft_id, departure_time, arrival_time, status, base_price) FROM stdin;
1	DG-1001	1	2	1	2026-04-01 08:00:00	2026-04-01 16:00:00	Scheduled	350.00
2	DG-1002	2	1	1	2026-04-02 10:00:00	2026-04-02 22:00:00	Scheduled	360.00
3	DG-1003	1	3	2	2026-04-03 06:30:00	2026-04-03 18:00:00	Scheduled	420.00
4	DG-1004	3	1	2	2026-04-04 14:00:00	2026-04-04 19:30:00	Scheduled	430.00
5	DG-1005	1	4	3	2026-04-05 09:00:00	2026-04-05 11:30:00	Scheduled	180.00
6	DG-1006	4	1	3	2026-04-06 13:00:00	2026-04-06 13:30:00	Scheduled	190.00
7	DG-1007	1	6	4	2026-04-07 22:00:00	2026-04-08 16:00:00	Scheduled	550.00
8	DG-1008	6	7	5	2026-04-08 07:00:00	2026-04-08 10:30:00	Scheduled	220.00
9	DG-1009	1	8	6	2026-04-09 11:00:00	2026-04-09 23:30:00	Scheduled	480.00
10	DG-1010	8	1	6	2026-04-10 14:00:00	2026-04-11 08:00:00	Scheduled	495.00
11	DG-1011	1	5	8	2026-04-11 07:30:00	2026-04-11 09:45:00	Scheduled	150.00
12	DG-1012	5	9	8	2026-04-12 12:00:00	2026-04-12 13:30:00	Scheduled	160.00
13	DG-1013	1	10	9	2026-04-13 16:00:00	2026-04-13 21:00:00	Scheduled	280.00
14	DG-1014	9	2	2	2026-04-14 08:00:00	2026-04-14 18:00:00	Scheduled	390.00
15	DG-1015	2	6	5	2026-04-15 20:00:00	2026-04-16 14:00:00	Scheduled	610.00
\.


--
-- TOC entry 5148 (class 0 OID 16902)
-- Dependencies: 224
-- Data for Name: passenger; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.passenger (passenger_id, first_name, last_name, email, phone, date_of_birth, passport_number, nationality, gender, created_at) FROM stdin;
1	James	Wilson	james.wilson@email.com	+447700900001	1985-03-12	P100001	British	Male	2026-03-26 18:10:11.795267
2	Sarah	Johnson	sarah.johnson@email.com	+447700900002	1990-07-24	P100002	British	Female	2026-03-26 18:10:11.795267
4	Emily	Chen	emily.chen@email.com	+16465550101	1995-02-18	P100004	American	Female	2026-03-26 18:10:11.795267
5	Oliver	Smith	oliver.smith@email.com	+447700900005	1988-09-30	P100005	British	Male	2026-03-26 18:10:11.795267
6	Aisha	Patel	aisha.patel@email.com	+447700900006	1993-04-15	P100006	British	Female	2026-03-26 18:10:11.795267
7	Lucas	Dubois	lucas.dubois@email.com	+33612345678	1982-12-01	P100007	French	Male	2026-03-26 18:10:11.795267
8	Yuki	Tanaka	yuki.tanaka@email.com	+81312345678	1991-06-22	P100008	Japanese	Female	2026-03-26 18:10:11.795267
9	Carlos	Martinez	carlos.m@email.com	+34612345678	1986-08-14	P100009	Spanish	Male	2026-03-26 18:10:11.795267
10	Fatima	Hassan	fatima.hassan@email.com	+971502345678	1997-01-09	P100010	Emirati	Female	2026-03-26 18:10:11.795267
11	David	Kim	david.kim@email.com	+821012345678	1984-05-27	P100011	South Korean	Male	2026-03-26 18:10:11.795267
12	Emma	Thompson	emma.t@email.com	+447700900012	1999-10-03	P100012	British	Female	2026-03-26 18:10:11.795267
13	Ravi	Sharma	ravi.sharma@email.com	+917012345678	1980-03-19	P100013	Indian	Male	2026-03-26 18:10:11.795267
14	Sofia	Rossi	sofia.rossi@email.com	+39312345678	1994-07-11	P100014	Italian	Female	2026-03-26 18:10:11.795267
16	Humaun	Johnson	humaun.johnson@email.com	07700900123	2002-01-27	PK123456	Pakistani	Male	2026-04-02 02:03:43.585804
17	risa	hussain	risa.hussain@email.com	07854356701	2003-01-10	CH123453	Chinese	Female	2026-04-02 02:52:07.104134
18	Anil	Turan	anil.turan@email.com	07624325375	1992-01-01	tk123475	Albanian	Male	2026-04-02 05:01:37.887695
15	Ahmed	Al-Farsi	ahmed.alfarsi@email.com	+971503456789	1975-02-28	P100015	Yemeni	Male	2026-03-26 18:10:11.795267
3	Mohammed	Al-Rashid	m.alrashid@email.com	+971501234567	1978-11-05	P100003	Palestinian	Male	2026-03-26 18:10:11.795267
\.


--
-- TOC entry 5158 (class 0 OID 17033)
-- Dependencies: 234
-- Data for Name: payment; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.payment (payment_id, booking_id, amount, currency, payment_method, payment_date, status) FROM stdin;
1	1	350.00	GBP	Credit Card	2026-03-01 10:05:00	Completed
2	2	350.00	GBP	Debit Card	2026-03-01 11:05:00	Completed
3	3	1260.00	GBP	Credit Card	2026-03-02 09:35:00	Completed
4	4	360.00	GBP	PayPal	2026-03-02 14:05:00	Completed
5	5	540.00	GBP	Credit Card	2026-03-03 08:05:00	Completed
6	6	700.00	GBP	Bank Transfer	2026-03-03 16:05:00	Completed
7	7	570.00	GBP	Credit Card	2026-03-04 10:05:00	Completed
8	8	550.00	GBP	Debit Card	2026-03-04 12:05:00	Completed
9	9	480.00	GBP	PayPal	2026-03-05 09:05:00	Completed
10	10	1260.00	GBP	Credit Card	2026-03-05 11:05:00	Completed
11	11	1440.00	GBP	Bank Transfer	2026-03-06 13:05:00	Completed
12	12	495.00	GBP	Credit Card	2026-03-06 15:05:00	Completed
13	13	150.00	GBP	Debit Card	2026-03-07 08:35:00	Completed
14	14	320.00	GBP	Credit Card	2026-03-07 10:05:00	Completed
15	15	280.00	GBP	PayPal	2026-03-08 14:05:00	Completed
16	16	780.00	GBP	Credit Card	2026-03-08 16:05:00	Completed
17	17	610.00	GBP	Debit Card	2026-03-09 09:05:00	Completed
18	18	860.00	GBP	Credit Card	2026-03-09 11:05:00	Completed
19	19	738.00	GBP	Bank Transfer	2026-03-10 08:05:00	Completed
20	20	190.00	GBP	Credit Card	2026-03-10 10:05:00	Refunded
\.


--
-- TOC entry 5154 (class 0 OID 16978)
-- Dependencies: 230
-- Data for Name: seat; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.seat (seat_id, aircraft_id, seat_number, seat_class, is_window, is_aisle) FROM stdin;
1	1	1A	First	t	f
2	1	1B	First	f	t
3	1	10A	Business	t	f
4	1	10B	Business	f	f
5	1	20A	Economy	t	f
6	1	20B	Economy	f	t
7	2	1A	First	t	f
8	2	1B	First	f	t
9	2	10A	Business	t	f
10	2	10B	Business	f	f
11	2	20A	Economy	t	f
12	2	20B	Economy	f	t
13	3	1A	First	t	f
14	3	1B	First	f	t
15	3	10A	Business	t	f
16	3	10B	Business	f	f
17	3	20A	Economy	t	f
18	3	20B	Economy	f	t
19	4	1A	First	t	f
20	4	10A	Business	t	f
21	4	20A	Economy	t	f
22	4	20B	Economy	f	t
23	5	1A	First	t	f
24	5	10A	Business	t	f
25	5	20A	Economy	t	f
26	6	1A	First	t	f
27	6	10A	Business	t	f
28	6	20A	Economy	t	f
29	7	1A	First	t	f
30	8	20A	Economy	t	f
\.


--
-- TOC entry 5178 (class 0 OID 0)
-- Dependencies: 221
-- Name: aircraft_aircraft_id_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public.aircraft_aircraft_id_seq', 10, true);


--
-- TOC entry 5179 (class 0 OID 0)
-- Dependencies: 219
-- Name: airport_airport_id_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public.airport_airport_id_seq', 10, true);


--
-- TOC entry 5180 (class 0 OID 0)
-- Dependencies: 235
-- Name: baggage_baggage_id_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public.baggage_baggage_id_seq', 20, true);


--
-- TOC entry 5181 (class 0 OID 0)
-- Dependencies: 231
-- Name: booking_booking_id_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public.booking_booking_id_seq', 20, true);


--
-- TOC entry 5182 (class 0 OID 0)
-- Dependencies: 237
-- Name: crew_assignment_assignment_id_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public.crew_assignment_assignment_id_seq', 20, true);


--
-- TOC entry 5183 (class 0 OID 0)
-- Dependencies: 225
-- Name: crew_crew_id_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public.crew_crew_id_seq', 15, true);


--
-- TOC entry 5184 (class 0 OID 0)
-- Dependencies: 227
-- Name: flight_flight_id_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public.flight_flight_id_seq', 15, true);


--
-- TOC entry 5185 (class 0 OID 0)
-- Dependencies: 223
-- Name: passenger_passenger_id_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public.passenger_passenger_id_seq', 18, true);


--
-- TOC entry 5186 (class 0 OID 0)
-- Dependencies: 233
-- Name: payment_payment_id_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public.payment_payment_id_seq', 20, true);


--
-- TOC entry 5187 (class 0 OID 0)
-- Dependencies: 229
-- Name: seat_seat_id_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public.seat_seat_id_seq', 30, true);


--
-- TOC entry 4949 (class 2606 OID 16898)
-- Name: aircraft aircraft_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.aircraft
    ADD CONSTRAINT aircraft_pkey PRIMARY KEY (aircraft_id);


--
-- TOC entry 4951 (class 2606 OID 16900)
-- Name: aircraft aircraft_registration_number_key; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.aircraft
    ADD CONSTRAINT aircraft_registration_number_key UNIQUE (registration_number);


--
-- TOC entry 4945 (class 2606 OID 16880)
-- Name: airport airport_iata_code_key; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.airport
    ADD CONSTRAINT airport_iata_code_key UNIQUE (iata_code);


--
-- TOC entry 4947 (class 2606 OID 16878)
-- Name: airport airport_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.airport
    ADD CONSTRAINT airport_pkey PRIMARY KEY (airport_id);


--
-- TOC entry 4977 (class 2606 OID 17073)
-- Name: baggage baggage_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.baggage
    ADD CONSTRAINT baggage_pkey PRIMARY KEY (baggage_id);


--
-- TOC entry 4979 (class 2606 OID 17075)
-- Name: baggage baggage_tag_number_key; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.baggage
    ADD CONSTRAINT baggage_tag_number_key UNIQUE (tag_number);


--
-- TOC entry 4973 (class 2606 OID 17016)
-- Name: booking booking_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.booking
    ADD CONSTRAINT booking_pkey PRIMARY KEY (booking_id);


--
-- TOC entry 4981 (class 2606 OID 17092)
-- Name: crew_assignment crew_assignment_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.crew_assignment
    ADD CONSTRAINT crew_assignment_pkey PRIMARY KEY (assignment_id);


--
-- TOC entry 4959 (class 2606 OID 16937)
-- Name: crew crew_email_key; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.crew
    ADD CONSTRAINT crew_email_key UNIQUE (email);


--
-- TOC entry 4961 (class 2606 OID 16939)
-- Name: crew crew_licence_number_key; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.crew
    ADD CONSTRAINT crew_licence_number_key UNIQUE (licence_number);


--
-- TOC entry 4963 (class 2606 OID 16935)
-- Name: crew crew_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.crew
    ADD CONSTRAINT crew_pkey PRIMARY KEY (crew_id);


--
-- TOC entry 4965 (class 2606 OID 16961)
-- Name: flight flight_flight_number_key; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.flight
    ADD CONSTRAINT flight_flight_number_key UNIQUE (flight_number);


--
-- TOC entry 4967 (class 2606 OID 16959)
-- Name: flight flight_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.flight
    ADD CONSTRAINT flight_pkey PRIMARY KEY (flight_id);


--
-- TOC entry 4953 (class 2606 OID 16918)
-- Name: passenger passenger_email_key; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.passenger
    ADD CONSTRAINT passenger_email_key UNIQUE (email);


--
-- TOC entry 4955 (class 2606 OID 16920)
-- Name: passenger passenger_passport_number_key; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.passenger
    ADD CONSTRAINT passenger_passport_number_key UNIQUE (passport_number);


--
-- TOC entry 4957 (class 2606 OID 16916)
-- Name: passenger passenger_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.passenger
    ADD CONSTRAINT passenger_pkey PRIMARY KEY (passenger_id);


--
-- TOC entry 4975 (class 2606 OID 17051)
-- Name: payment payment_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.payment
    ADD CONSTRAINT payment_pkey PRIMARY KEY (payment_id);


--
-- TOC entry 4969 (class 2606 OID 16992)
-- Name: seat seat_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.seat
    ADD CONSTRAINT seat_pkey PRIMARY KEY (seat_id);


--
-- TOC entry 4983 (class 2606 OID 17094)
-- Name: crew_assignment uq_crew_flight; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.crew_assignment
    ADD CONSTRAINT uq_crew_flight UNIQUE (crew_id, flight_id);


--
-- TOC entry 4971 (class 2606 OID 16994)
-- Name: seat uq_seat_per_aircraft; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.seat
    ADD CONSTRAINT uq_seat_per_aircraft UNIQUE (aircraft_id, seat_number);


--
-- TOC entry 4984 (class 2606 OID 16972)
-- Name: flight fk_aircraft; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.flight
    ADD CONSTRAINT fk_aircraft FOREIGN KEY (aircraft_id) REFERENCES public.aircraft(aircraft_id);


--
-- TOC entry 4985 (class 2606 OID 16967)
-- Name: flight fk_arrival_airport; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.flight
    ADD CONSTRAINT fk_arrival_airport FOREIGN KEY (arrival_airport_id) REFERENCES public.airport(airport_id);


--
-- TOC entry 4993 (class 2606 OID 17095)
-- Name: crew_assignment fk_assignment_crew; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.crew_assignment
    ADD CONSTRAINT fk_assignment_crew FOREIGN KEY (crew_id) REFERENCES public.crew(crew_id);


--
-- TOC entry 4994 (class 2606 OID 17100)
-- Name: crew_assignment fk_assignment_flight; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.crew_assignment
    ADD CONSTRAINT fk_assignment_flight FOREIGN KEY (flight_id) REFERENCES public.flight(flight_id);


--
-- TOC entry 4992 (class 2606 OID 17076)
-- Name: baggage fk_baggage_booking; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.baggage
    ADD CONSTRAINT fk_baggage_booking FOREIGN KEY (booking_id) REFERENCES public.booking(booking_id);


--
-- TOC entry 4988 (class 2606 OID 17022)
-- Name: booking fk_booking_flight; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.booking
    ADD CONSTRAINT fk_booking_flight FOREIGN KEY (flight_id) REFERENCES public.flight(flight_id);


--
-- TOC entry 4989 (class 2606 OID 17017)
-- Name: booking fk_booking_passenger; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.booking
    ADD CONSTRAINT fk_booking_passenger FOREIGN KEY (passenger_id) REFERENCES public.passenger(passenger_id);


--
-- TOC entry 4990 (class 2606 OID 17027)
-- Name: booking fk_booking_seat; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.booking
    ADD CONSTRAINT fk_booking_seat FOREIGN KEY (seat_id) REFERENCES public.seat(seat_id);


--
-- TOC entry 4986 (class 2606 OID 16962)
-- Name: flight fk_departure_airport; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.flight
    ADD CONSTRAINT fk_departure_airport FOREIGN KEY (departure_airport_id) REFERENCES public.airport(airport_id);


--
-- TOC entry 4991 (class 2606 OID 17052)
-- Name: payment fk_payment_booking; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.payment
    ADD CONSTRAINT fk_payment_booking FOREIGN KEY (booking_id) REFERENCES public.booking(booking_id);


--
-- TOC entry 4987 (class 2606 OID 16995)
-- Name: seat fk_seat_aircraft; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.seat
    ADD CONSTRAINT fk_seat_aircraft FOREIGN KEY (aircraft_id) REFERENCES public.aircraft(aircraft_id);


-- Completed on 2026-05-05 17:12:29

--
-- PostgreSQL database dump complete
--

\unrestrict aPs3f9sRbneA74TjfJ2mMKoKK0mzAfRPXpSZPz2nykle09IHx3bbuzxs9et6NIy

