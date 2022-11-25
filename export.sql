--
-- PostgreSQL database dump
--

-- Dumped from database version 14.1
-- Dumped by pg_dump version 14.1

-- Started on 2022-01-17 05:23:50

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

SET default_tablespace = '';

SET default_table_access_method = heap;

--
-- TOC entry 209 (class 1259 OID 16871)
-- Name: address; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.address (
    addr_uuid uuid NOT NULL,
    addr_line1 character varying(100) NOT NULL,
    addr_city character varying(60) NOT NULL,
    addr_state character varying(60) NOT NULL,
    addr_zip character varying(12) NOT NULL,
    addr_owner uuid NOT NULL,
    addr_is_patient boolean DEFAULT false NOT NULL
);


ALTER TABLE public.address OWNER TO postgres;

--
-- TOC entry 210 (class 1259 OID 16875)
-- Name: category; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.category (
    cate_id integer NOT NULL,
    cate_category character varying(60) NOT NULL
);


ALTER TABLE public.category OWNER TO postgres;

--
-- TOC entry 211 (class 1259 OID 16878)
-- Name: category_cate_id_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE public.category_cate_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.category_cate_id_seq OWNER TO postgres;

--
-- TOC entry 3556 (class 0 OID 0)
-- Dependencies: 211
-- Name: category_cate_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE public.category_cate_id_seq OWNED BY public.category.cate_id;


--
-- TOC entry 212 (class 1259 OID 16879)
-- Name: conversation; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.conversation (
    conv_uuid uuid NOT NULL,
    conv_user_a uuid NOT NULL,
    conv_user_b uuid NOT NULL
);


ALTER TABLE public.conversation OWNER TO postgres;

--
-- TOC entry 213 (class 1259 OID 16882)
-- Name: file; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.file (
    file_uuid uuid NOT NULL,
    file_title character varying(255) NOT NULL,
    file_name character varying(255) NOT NULL
);


ALTER TABLE public.file OWNER TO postgres;

--
-- TOC entry 242 (class 1259 OID 24588)
-- Name: hcfa; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.hcfa (
    hcfa_uuid uuid NOT NULL,
    hcfa_info json,
    hcfa_patient_id uuid
);


ALTER TABLE public.hcfa OWNER TO postgres;

--
-- TOC entry 214 (class 1259 OID 16887)
-- Name: home_screen; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.home_screen (
    hosc_uuid uuid NOT NULL,
    hosc_file character varying(60) NOT NULL,
    hosc_date timestamp without time zone DEFAULT CURRENT_TIMESTAMP NOT NULL,
    hosc_type character varying(20)
);


ALTER TABLE public.home_screen OWNER TO postgres;

--
-- TOC entry 215 (class 1259 OID 16891)
-- Name: main_text; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.main_text (
    mate_uuid uuid NOT NULL,
    mate_text character varying(500) NOT NULL,
    mate_text_b character varying(500)
);


ALTER TABLE public.main_text OWNER TO postgres;

--
-- TOC entry 216 (class 1259 OID 16896)
-- Name: medical_record; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.medical_record (
    mere_uuid uuid NOT NULL,
    mere_name character varying(60),
    mere_allergies text,
    mere_current_meds text,
    mere_medical_history text,
    mere_social_history text,
    mere_family_history text,
    mere_bp character varying(10),
    mere_pulse character varying(10),
    mere_resp_rate character varying(10),
    mere_temp character varying(10),
    mere_height double precision,
    mere_weight double precision,
    mere_chief_complaint text,
    mere_hpi text,
    mere_subject text,
    mere_objective text,
    mere_assessment text,
    mere_plan text,
    mere_owner uuid NOT NULL,
    mere_is_public boolean DEFAULT false NOT NULL,
    mere_date date,
    mere_sign text,
    mere_addendum text,
    mere_updated timestamp without time zone DEFAULT CURRENT_TIMESTAMP NOT NULL,
    mere_is_draft boolean DEFAULT true NOT NULL,
    mere_is_encounter boolean DEFAULT false NOT NULL
);


ALTER TABLE public.medical_record OWNER TO postgres;

--
-- TOC entry 217 (class 1259 OID 16905)
-- Name: medical_record_user; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.medical_record_user (
    mrus_uuid uuid NOT NULL,
    mrus_mere_uuid uuid NOT NULL,
    mrus_user_uuid uuid NOT NULL,
    mrus_date timestamp without time zone DEFAULT CURRENT_TIMESTAMP NOT NULL,
    mrus_updated timestamp without time zone DEFAULT CURRENT_TIMESTAMP NOT NULL
);


ALTER TABLE public.medical_record_user OWNER TO postgres;

--
-- TOC entry 218 (class 1259 OID 16910)
-- Name: messages; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.messages (
    mess_uuid uuid NOT NULL,
    mess_conv_uuid uuid NOT NULL,
    mess_sender uuid NOT NULL,
    mess_message text,
    mess_date timestamp without time zone DEFAULT CURRENT_TIMESTAMP NOT NULL,
    mess_file uuid,
    mess_read boolean DEFAULT false NOT NULL
);


ALTER TABLE public.messages OWNER TO postgres;

--
-- TOC entry 219 (class 1259 OID 16917)
-- Name: my_doctor; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.my_doctor (
    mydo_uuid uuid NOT NULL,
    mydo_owner uuid NOT NULL,
    mydo_user_uuid uuid NOT NULL
);


ALTER TABLE public.my_doctor OWNER TO postgres;

--
-- TOC entry 220 (class 1259 OID 16920)
-- Name: my_professionals; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.my_professionals (
    mypr_id integer NOT NULL,
    mypr_uuid uuid NOT NULL,
    mypr_proffesional uuid NOT NULL,
    mypr_allowed boolean DEFAULT false NOT NULL,
    mypr_date timestamp without time zone DEFAULT CURRENT_TIMESTAMP NOT NULL
);


ALTER TABLE public.my_professionals OWNER TO postgres;

--
-- TOC entry 221 (class 1259 OID 16925)
-- Name: my_professionals_mypr_id_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE public.my_professionals_mypr_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.my_professionals_mypr_id_seq OWNER TO postgres;

--
-- TOC entry 3557 (class 0 OID 0)
-- Dependencies: 221
-- Name: my_professionals_mypr_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE public.my_professionals_mypr_id_seq OWNED BY public.my_professionals.mypr_id;


--
-- TOC entry 222 (class 1259 OID 16926)
-- Name: notification; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.notification (
    noti_uuid uuid NOT NULL,
    noti_from uuid,
    noti_to uuid NOT NULL,
    noti_date timestamp without time zone DEFAULT CURRENT_TIMESTAMP NOT NULL,
    noti_noty_id integer
);


ALTER TABLE public.notification OWNER TO postgres;

--
-- TOC entry 223 (class 1259 OID 16930)
-- Name: notification_type; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.notification_type (
    noty_id integer NOT NULL,
    noty_en character varying(255) NOT NULL,
    noty_es character varying(255) NOT NULL,
    noty_key character varying(30) NOT NULL
);


ALTER TABLE public.notification_type OWNER TO postgres;

--
-- TOC entry 224 (class 1259 OID 16935)
-- Name: notification_type_noty_id_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE public.notification_type_noty_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.notification_type_noty_id_seq OWNER TO postgres;

--
-- TOC entry 3558 (class 0 OID 0)
-- Dependencies: 224
-- Name: notification_type_noty_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE public.notification_type_noty_id_seq OWNED BY public.notification_type.noty_id;


--
-- TOC entry 225 (class 1259 OID 16936)
-- Name: page; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.page (
    page_uuid uuid NOT NULL,
    page_title character varying(160) NOT NULL,
    page_slug character varying(160) NOT NULL,
    page_keywords character varying(160) NOT NULL,
    page_content text,
    "page_createdAt" timestamp without time zone DEFAULT CURRENT_TIMESTAMP NOT NULL,
    page_updated_at timestamp without time zone DEFAULT CURRENT_TIMESTAMP NOT NULL
);


ALTER TABLE public.page OWNER TO postgres;

--
-- TOC entry 226 (class 1259 OID 16943)
-- Name: previous_conversation; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.previous_conversation (
    prco_uuid uuid NOT NULL,
    prco_user_a uuid NOT NULL,
    prco_user_b uuid NOT NULL,
    prco_pdf character varying(30) NOT NULL,
    prco_date timestamp without time zone DEFAULT CURRENT_TIMESTAMP NOT NULL
);


ALTER TABLE public.previous_conversation OWNER TO postgres;

--
-- TOC entry 227 (class 1259 OID 16947)
-- Name: privacy_policy; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.privacy_policy (
    prpo_id integer NOT NULL,
    prpo_text text NOT NULL
);


ALTER TABLE public.privacy_policy OWNER TO postgres;

--
-- TOC entry 228 (class 1259 OID 16952)
-- Name: privacy_policy_prpo_id_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE public.privacy_policy_prpo_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.privacy_policy_prpo_id_seq OWNER TO postgres;

--
-- TOC entry 3559 (class 0 OID 0)
-- Dependencies: 228
-- Name: privacy_policy_prpo_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE public.privacy_policy_prpo_id_seq OWNED BY public.privacy_policy.prpo_id;


--
-- TOC entry 229 (class 1259 OID 16953)
-- Name: professional; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.professional (
    profe_uuid uuid NOT NULL,
    profe_cate_id integer NOT NULL,
    profe_user_uuid uuid NOT NULL,
    profe_is_active boolean DEFAULT false,
    profe_created_at timestamp without time zone DEFAULT CURRENT_TIMESTAMP NOT NULL,
    profe_update_at timestamp without time zone DEFAULT CURRENT_TIMESTAMP NOT NULL,
    profe_npi character varying(10) NOT NULL,
    profe_pin character varying(7),
    profe_specialty character varying(60),
    profe_practice_name character varying(60),
    profe_medical_license character varying(12),
    profe_license_state character varying(30),
    profe_credentials character varying(60),
    profe_email_sent boolean DEFAULT false NOT NULL,
    profe_pin_set boolean DEFAULT false NOT NULL,
    profe_spec_id integer
);


ALTER TABLE public.professional OWNER TO postgres;

--
-- TOC entry 230 (class 1259 OID 16961)
-- Name: refresh_token; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.refresh_token (
    reto_uuid uuid NOT NULL,
    reto_user_uuid uuid NOT NULL,
    reto_refresh_token uuid NOT NULL,
    reto_created_at timestamp without time zone DEFAULT CURRENT_TIMESTAMP NOT NULL,
    reto_ip_address character varying(40)
);


ALTER TABLE public.refresh_token OWNER TO postgres;

--
-- TOC entry 231 (class 1259 OID 16965)
-- Name: specialty; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.specialty (
    spec_id integer NOT NULL,
    spec_cate_id integer NOT NULL,
    spec_specialty character varying(30) NOT NULL
);


ALTER TABLE public.specialty OWNER TO postgres;

--
-- TOC entry 232 (class 1259 OID 16968)
-- Name: specialty_spec_id_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE public.specialty_spec_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.specialty_spec_id_seq OWNER TO postgres;

--
-- TOC entry 3560 (class 0 OID 0)
-- Dependencies: 232
-- Name: specialty_spec_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE public.specialty_spec_id_seq OWNED BY public.specialty.spec_id;


--
-- TOC entry 233 (class 1259 OID 16969)
-- Name: terms_conditions; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.terms_conditions (
    teco_id integer NOT NULL,
    teco_text text NOT NULL
);


ALTER TABLE public.terms_conditions OWNER TO postgres;

--
-- TOC entry 234 (class 1259 OID 16974)
-- Name: terms_conditions_teco_id_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE public.terms_conditions_teco_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.terms_conditions_teco_id_seq OWNER TO postgres;

--
-- TOC entry 3561 (class 0 OID 0)
-- Dependencies: 234
-- Name: terms_conditions_teco_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE public.terms_conditions_teco_id_seq OWNED BY public.terms_conditions.teco_id;


--
-- TOC entry 235 (class 1259 OID 16975)
-- Name: user; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public."user" (
    user_uuid uuid NOT NULL,
    user_email character varying(150),
    user_first_name character varying(30) NOT NULL,
    user_last_name character varying(30) NOT NULL,
    user_date_of_birth date,
    user_password character varying(100),
    user_usro_id integer NOT NULL,
    user_email_verified boolean DEFAULT false NOT NULL,
    user_deleted boolean DEFAULT false NOT NULL,
    user_blocked boolean DEFAULT false NOT NULL,
    user_mrn integer NOT NULL,
    user_owner uuid,
    user_country_code character varying(3),
    user_phone_no character varying(15),
    user_picture character varying(60)
);


ALTER TABLE public."user" OWNER TO postgres;

--
-- TOC entry 236 (class 1259 OID 16981)
-- Name: user_role; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.user_role (
    usro_id integer NOT NULL,
    usro_role character varying(12) NOT NULL,
    usro_key character varying(9) NOT NULL
);


ALTER TABLE public.user_role OWNER TO postgres;

--
-- TOC entry 237 (class 1259 OID 16984)
-- Name: user_role_usro_id_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE public.user_role_usro_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.user_role_usro_id_seq OWNER TO postgres;

--
-- TOC entry 3562 (class 0 OID 0)
-- Dependencies: 237
-- Name: user_role_usro_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE public.user_role_usro_id_seq OWNED BY public.user_role.usro_id;


--
-- TOC entry 238 (class 1259 OID 16985)
-- Name: user_user_mrn_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE public.user_user_mrn_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.user_user_mrn_seq OWNER TO postgres;

--
-- TOC entry 3563 (class 0 OID 0)
-- Dependencies: 238
-- Name: user_user_mrn_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE public.user_user_mrn_seq OWNED BY public."user".user_mrn;


--
-- TOC entry 239 (class 1259 OID 16986)
-- Name: user_user_usro_id_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE public.user_user_usro_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.user_user_usro_id_seq OWNER TO postgres;

--
-- TOC entry 3564 (class 0 OID 0)
-- Dependencies: 239
-- Name: user_user_usro_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE public.user_user_usro_id_seq OWNED BY public."user".user_usro_id;


--
-- TOC entry 240 (class 1259 OID 16987)
-- Name: verification_code; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.verification_code (
    veco_id integer NOT NULL,
    veco_code character varying(9) NOT NULL,
    veco_user_uuid uuid NOT NULL,
    veco_reset_password boolean DEFAULT false NOT NULL,
    veco_type character varying(15) DEFAULT 'PASSWORD'::character varying NOT NULL,
    veco_date timestamp without time zone DEFAULT CURRENT_DATE NOT NULL
);


ALTER TABLE public.verification_code OWNER TO postgres;

--
-- TOC entry 241 (class 1259 OID 16993)
-- Name: verification_code_veco_id_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE public.verification_code_veco_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.verification_code_veco_id_seq OWNER TO postgres;

--
-- TOC entry 3565 (class 0 OID 0)
-- Dependencies: 241
-- Name: verification_code_veco_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE public.verification_code_veco_id_seq OWNED BY public.verification_code.veco_id;


--
-- TOC entry 3266 (class 2604 OID 16994)
-- Name: category cate_id; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.category ALTER COLUMN cate_id SET DEFAULT nextval('public.category_cate_id_seq'::regclass);


--
-- TOC entry 3278 (class 2604 OID 16995)
-- Name: my_professionals mypr_id; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.my_professionals ALTER COLUMN mypr_id SET DEFAULT nextval('public.my_professionals_mypr_id_seq'::regclass);


--
-- TOC entry 3280 (class 2604 OID 16996)
-- Name: notification_type noty_id; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.notification_type ALTER COLUMN noty_id SET DEFAULT nextval('public.notification_type_noty_id_seq'::regclass);


--
-- TOC entry 3284 (class 2604 OID 16997)
-- Name: privacy_policy prpo_id; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.privacy_policy ALTER COLUMN prpo_id SET DEFAULT nextval('public.privacy_policy_prpo_id_seq'::regclass);


--
-- TOC entry 3291 (class 2604 OID 16998)
-- Name: specialty spec_id; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.specialty ALTER COLUMN spec_id SET DEFAULT nextval('public.specialty_spec_id_seq'::regclass);


--
-- TOC entry 3292 (class 2604 OID 16999)
-- Name: terms_conditions teco_id; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.terms_conditions ALTER COLUMN teco_id SET DEFAULT nextval('public.terms_conditions_teco_id_seq'::regclass);


--
-- TOC entry 3296 (class 2604 OID 17000)
-- Name: user user_usro_id; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public."user" ALTER COLUMN user_usro_id SET DEFAULT nextval('public.user_user_usro_id_seq'::regclass);


--
-- TOC entry 3297 (class 2604 OID 17001)
-- Name: user user_mrn; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public."user" ALTER COLUMN user_mrn SET DEFAULT nextval('public.user_user_mrn_seq'::regclass);


--
-- TOC entry 3298 (class 2604 OID 17002)
-- Name: user_role usro_id; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.user_role ALTER COLUMN usro_id SET DEFAULT nextval('public.user_role_usro_id_seq'::regclass);


--
-- TOC entry 3302 (class 2604 OID 17003)
-- Name: verification_code veco_id; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.verification_code ALTER COLUMN veco_id SET DEFAULT nextval('public.verification_code_veco_id_seq'::regclass);


--
-- TOC entry 3517 (class 0 OID 16871)
-- Dependencies: 209
-- Data for Name: address; Type: TABLE DATA; Schema: public; Owner: postgres
--

INSERT INTO public.address (addr_uuid, addr_line1, addr_city, addr_state, addr_zip, addr_owner, addr_is_patient) VALUES ('ff0c03c6-f568-4f66-ad7c-2f7092f3dd8e', '4620 Pheasant Ridge Road', 'Doylestown!', 'Pennsylvania', '18901', 'ebb602d1-35ef-45a1-b9f2-18576c2b3ad5', false);
INSERT INTO public.address (addr_uuid, addr_line1, addr_city, addr_state, addr_zip, addr_owner, addr_is_patient) VALUES ('6edb3d41-6a55-480c-8c27-b50c12adbe88', 'User address', 'Utha', 'alsdjf', '324878', 'dff20fc6-9d71-436e-81fc-70707b2ad39c', true);
INSERT INTO public.address (addr_uuid, addr_line1, addr_city, addr_state, addr_zip, addr_owner, addr_is_patient) VALUES ('9ae40c29-7b17-4668-ab2e-a609523675e6', 'This is my address', 'ksdljf', 'kljdslkjf', '892340923', '5f4c2888-0c8c-47d2-a935-fb1cf8e28be1', false);
INSERT INTO public.address (addr_uuid, addr_line1, addr_city, addr_state, addr_zip, addr_owner, addr_is_patient) VALUES ('2e962581-cac4-4664-8f9e-ea2776b0de1d', 'St san jose no 1', 'City Banamex', 'Statrus', '23454', 'dff20fc6-9d71-436e-81fc-70707b2ad39c', false);
INSERT INTO public.address (addr_uuid, addr_line1, addr_city, addr_state, addr_zip, addr_owner, addr_is_patient) VALUES ('a13ff601-9e21-413f-aad9-0a7403709b92', 'Line one of user ad', 'U City updated', 'Sate', '238094', 'e4769679-df90-49f0-8921-817db992e182', true);
INSERT INTO public.address (addr_uuid, addr_line1, addr_city, addr_state, addr_zip, addr_owner, addr_is_patient) VALUES ('0da81bf8-b227-4742-98bb-f7e3c709d695', 'After 10 years', 'City name', 'state name', '03344', '6524e8f2-ac32-4512-873d-8e0bb667be80', true);
INSERT INTO public.address (addr_uuid, addr_line1, addr_city, addr_state, addr_zip, addr_owner, addr_is_patient) VALUES ('7157b542-9672-4719-9abc-6991e7d2fad7', 'Smithsoniano', 'test', 'low', '2343', 'c71f7e00-8408-4cb8-98dc-ad9a27a76c14', true);


--
-- TOC entry 3518 (class 0 OID 16875)
-- Dependencies: 210
-- Data for Name: category; Type: TABLE DATA; Schema: public; Owner: postgres
--

INSERT INTO public.category (cate_id, cate_category) VALUES (2, 'Support');
INSERT INTO public.category (cate_id, cate_category) VALUES (1, 'Neurology!');
INSERT INTO public.category (cate_id, cate_category) VALUES (3, 'This is the category name');


--
-- TOC entry 3520 (class 0 OID 16879)
-- Dependencies: 212
-- Data for Name: conversation; Type: TABLE DATA; Schema: public; Owner: postgres
--

INSERT INTO public.conversation (conv_uuid, conv_user_a, conv_user_b) VALUES ('b79ffe1a-6721-467c-9b69-d57936fc0b92', 'dff20fc6-9d71-436e-81fc-70707b2ad39c', 'ebb602d1-35ef-45a1-b9f2-18576c2b3ad5');
INSERT INTO public.conversation (conv_uuid, conv_user_a, conv_user_b) VALUES ('41dba86a-fce2-49f4-8e38-36b0c3b7aa78', 'dff20fc6-9d71-436e-81fc-70707b2ad39c', '5f4c2888-0c8c-47d2-a935-fb1cf8e28be1');
INSERT INTO public.conversation (conv_uuid, conv_user_a, conv_user_b) VALUES ('3a30992d-9aae-415d-b6cd-82a129147bde', 'dff20fc6-9d71-436e-81fc-70707b2ad39c', 'e4769679-df90-49f0-8921-817db992e182');
INSERT INTO public.conversation (conv_uuid, conv_user_a, conv_user_b) VALUES ('c6954ed3-5c17-4157-987f-a5f5afd57d7d', 'dff20fc6-9d71-436e-81fc-70707b2ad39c', 'c71f7e00-8408-4cb8-98dc-ad9a27a76c14');
INSERT INTO public.conversation (conv_uuid, conv_user_a, conv_user_b) VALUES ('ce5ce3f1-4900-4f0f-8c7f-493266a8b315', 'dff20fc6-9d71-436e-81fc-70707b2ad39c', 'dff20fc6-9d71-436e-81fc-70707b2ad39c');


--
-- TOC entry 3521 (class 0 OID 16882)
-- Dependencies: 213
-- Data for Name: file; Type: TABLE DATA; Schema: public; Owner: postgres
--

INSERT INTO public.file (file_uuid, file_title, file_name) VALUES ('950c01c1-9ac6-4917-a3cb-2fc5421dc4f0', '1307-Con-logo-8.jpg', '06b5174a-96a8-4fa7-a520-82de8a89f2f2.jpg');
INSERT INTO public.file (file_uuid, file_title, file_name) VALUES ('3e9baefc-be64-4340-b6b6-364c79caf339', '1303-4.jpg', 'fea7d181-735b-48f9-98af-581356d1781d.jpg');


--
-- TOC entry 3550 (class 0 OID 24588)
-- Dependencies: 242
-- Data for Name: hcfa; Type: TABLE DATA; Schema: public; Owner: postgres
--

INSERT INTO public.hcfa (hcfa_uuid, hcfa_info, hcfa_patient_id) VALUES ('ebb602d1-35ef-45a1-b9f2-18576c2b3ad5', '{"number1":[0,0,0,0,0,0,1,"asdfasdf"],"number2":{"patientName":""},"number3":{"mm":"","dd":"","yy":"","sex":{"male":0,"female":0}},"number4":{"insuredName":""},"number5":{"patientAddress":"","patientCity":"","patientState":"","patientZipcode":"","patientTelephone":""},"number6":[0,0,0,0],"number7":{"insuredAddress":"","insuredCity":"","insuredState":"","insuredZipcode":"","insuredTelephone":""},"number8":[0,0,0,0,0,0],"number9":{"value":"","a":"","b":{"mm":"","dd":"","yy":"","sex":{"male":0,"female":0}},"c":"","d":""},"number10":{"value":"","a":{"yes":0,"no":0},"b":{"yes":0,"no":0,"place":""},"c":{"yes":0,"no":0},"d":""},"number11":{"value":"","a":{"mm":"","dd":"","yy":"","sex":{"male":0,"female":0}},"b":"","c":"","d":{"yes":0,"no":0}},"number12":{"signed":"","date":""},"number13":{"value":""},"number14":{"mm":"","dd":"","yy":"","sex":{"male":0,"female":0}},"number15":{"mm":"","dd":"","yy":"","sex":{"male":0,"female":0}},"number16":{"from":{"mm":"","dd":"","yy":"","sex":{"male":0,"female":0}},"to":{"mm":"","dd":"","yy":"","sex":{"male":0,"female":0}}},"number17":{"value":"","a":{"first":"","second":""},"b":""},"number18":{"from":{"mm":"","dd":"","yy":"","sex":{"male":0,"female":0}},"to":{"mm":"","dd":"","yy":"","sex":{"male":0,"female":0}}},"number19":{"value":""},"number20":{"yes":0,"no":0,"charges":{"first":"","second":""}},"number25":{"value":"","ssn":0,"ein":0},"number26":{"value":""},"number27":{"yes":0,"no":0},"number28":{"value":""},"number29":{"value":""},"number30":{"value":""},"number31":{"value":""},"number32":{"value":"","a":"","b":""},"number33":{"value":"","a":"","b":""}}', '5f4c2888-0c8c-47d2-a935-fb1cf8e28be1');
INSERT INTO public.hcfa (hcfa_uuid, hcfa_info, hcfa_patient_id) VALUES ('ebb602d1-35ef-45a1-b9f2-18576c2b3ad5', '{"number1":[0,1,0,0,0,0,0,""],"number2":{"patientName":"asdfasdfasdf"},"number3":{"mm":"","dd":"","yy":"","sex":{"male":0,"female":0}},"number4":{"insuredName":""},"number5":{"patientAddress":"","patientCity":"","patientState":"","patientZipcode":"","patientTelephone":""},"number6":[0,0,0,0],"number7":{"insuredAddress":"","insuredCity":"","insuredState":"","insuredZipcode":"","insuredTelephone":""},"number8":[0,0,0,0,0,0],"number9":{"value":"","a":"","b":{"mm":"","dd":"","yy":"","sex":{"male":0,"female":0}},"c":"","d":""},"number10":{"value":"","a":{"yes":0,"no":0},"b":{"yes":0,"no":0,"place":""},"c":{"yes":0,"no":0},"d":""},"number11":{"value":"","a":{"mm":"","dd":"","yy":"","sex":{"male":0,"female":0}},"b":"","c":"","d":{"yes":0,"no":0}},"number12":{"signed":"","date":""},"number13":{"value":""},"number14":{"mm":"","dd":"","yy":"","sex":{"male":0,"female":0}},"number15":{"mm":"","dd":"","yy":"","sex":{"male":0,"female":0}},"number16":{"from":{"mm":"","dd":"","yy":"","sex":{"male":0,"female":0}},"to":{"mm":"","dd":"","yy":"","sex":{"male":0,"female":0}}},"number17":{"value":"","a":{"first":"","second":""},"b":""},"number18":{"from":{"mm":"","dd":"","yy":"","sex":{"male":0,"female":0}},"to":{"mm":"","dd":"","yy":"","sex":{"male":0,"female":0}}},"number19":{"value":""},"number20":{"yes":0,"no":0,"charges":{"first":"","second":""}},"number25":{"value":"","ssn":0,"ein":0},"number26":{"value":""},"number27":{"yes":0,"no":0},"number28":{"value":""},"number29":{"value":""},"number30":{"value":""},"number31":{"value":""},"number32":{"value":"","a":"","b":""},"number33":{"value":"","a":"","b":""}}', 'dff20fc6-9d71-436e-81fc-70707b2ad39c');
INSERT INTO public.hcfa (hcfa_uuid, hcfa_info, hcfa_patient_id) VALUES ('ebb602d1-35ef-45a1-b9f2-18576c2b3ad5', '{"number1":[0,0,1,0,0,0,0,"sasdfsdf"],"number2":{"patientName":""},"number3":{"mm":"","dd":"","yy":"","sex":{"male":1,"female":0}},"number4":{"insuredName":""},"number5":{"patientAddress":"","patientCity":"","patientState":"","patientZipcode":"","patientTelephone":""},"number6":[0,0,0,0],"number7":{"insuredAddress":"","insuredCity":"","insuredState":"","insuredZipcode":"","insuredTelephone":""},"number8":[0,0,0,0,0,0],"number9":{"value":"","a":"","b":{"mm":"","dd":"","yy":"","sex":{"male":0,"female":0}},"c":"","d":""},"number10":{"value":"","a":{"yes":0,"no":0},"b":{"yes":0,"no":0,"place":""},"c":{"yes":0,"no":0},"d":""},"number11":{"value":"","a":{"mm":"","dd":"","yy":"","sex":{"male":0,"female":0}},"b":"","c":"","d":{"yes":0,"no":0}},"number12":{"signed":"","date":""},"number13":{"value":""},"number14":{"mm":"","dd":"","yy":"","sex":{"male":0,"female":0}},"number15":{"mm":"","dd":"","yy":"","sex":{"male":0,"female":0}},"number16":{"from":{"mm":"","dd":"","yy":"","sex":{"male":0,"female":0}},"to":{"mm":"","dd":"","yy":"","sex":{"male":0,"female":0}}},"number17":{"value":"","a":{"first":"","second":""},"b":""},"number18":{"from":{"mm":"","dd":"","yy":"","sex":{"male":0,"female":0}},"to":{"mm":"","dd":"","yy":"","sex":{"male":0,"female":0}}},"number19":{"value":""},"number20":{"yes":0,"no":0,"charges":{"first":"","second":""}},"number25":{"value":"","ssn":0,"ein":0},"number26":{"value":""},"number27":{"yes":0,"no":0},"number28":{"value":""},"number29":{"value":""},"number30":{"value":""},"number31":{"value":""},"number32":{"value":"","a":"","b":""},"number33":{"value":"","a":"","b":""}}', 'ebb602d1-35ef-45a1-b9f2-18576c2b3ad5');


--
-- TOC entry 3522 (class 0 OID 16887)
-- Dependencies: 214
-- Data for Name: home_screen; Type: TABLE DATA; Schema: public; Owner: postgres
--

INSERT INTO public.home_screen (hosc_uuid, hosc_file, hosc_date, hosc_type) VALUES ('1f566bd1-e1d2-4cdd-8e88-1871d5e07f68', 'sign-up.png', '2021-12-12 20:04:18.221866', 'sign-up');
INSERT INTO public.home_screen (hosc_uuid, hosc_file, hosc_date, hosc_type) VALUES ('e70f4f58-4cbe-4ea1-8f4e-8d37baee2667', 'sign-in.png', '2021-12-12 20:04:24.893475', 'sign-in');


--
-- TOC entry 3523 (class 0 OID 16891)
-- Dependencies: 215
-- Data for Name: main_text; Type: TABLE DATA; Schema: public; Owner: postgres
--

INSERT INTO public.main_text (mate_uuid, mate_text, mate_text_b) VALUES ('29ab2863-3512-4514-9483-bc549a10898c', '<p>Left side text!	</p><p><em>C:</em></p><ol><li><em> One</em></li><li><em>Two</em></li><li><em>Three</em></li></ol>', '<p>Right side text</p><p><strong><em><s>Rick Flair</s></em></strong></p>');


--
-- TOC entry 3524 (class 0 OID 16896)
-- Dependencies: 216
-- Data for Name: medical_record; Type: TABLE DATA; Schema: public; Owner: postgres
--

INSERT INTO public.medical_record (mere_uuid, mere_name, mere_allergies, mere_current_meds, mere_medical_history, mere_social_history, mere_family_history, mere_bp, mere_pulse, mere_resp_rate, mere_temp, mere_height, mere_weight, mere_chief_complaint, mere_hpi, mere_subject, mere_objective, mere_assessment, mere_plan, mere_owner, mere_is_public, mere_date, mere_sign, mere_addendum, mere_updated, mere_is_draft, mere_is_encounter) VALUES ('ab84520a-40a3-4784-9746-2ff644f8c892', '', 'Allergies', 'Current meds', 'medical history', 'Social history', 'Family history', '', '120', '193', '103', 110, 230, 'Chief complaint', 'El de la H', 'Subject', 'Objective', 'Assessment', 'Plan', 'dff20fc6-9d71-436e-81fc-70707b2ad39c', false, '2021-12-18', 'Sign', 'addendum', '2021-12-17 19:01:51.898832', false, true);
INSERT INTO public.medical_record (mere_uuid, mere_name, mere_allergies, mere_current_meds, mere_medical_history, mere_social_history, mere_family_history, mere_bp, mere_pulse, mere_resp_rate, mere_temp, mere_height, mere_weight, mere_chief_complaint, mere_hpi, mere_subject, mere_objective, mere_assessment, mere_plan, mere_owner, mere_is_public, mere_date, mere_sign, mere_addendum, mere_updated, mere_is_draft, mere_is_encounter) VALUES ('1a232c50-aaaa-4386-a1e4-2d31a0c59da3', 'This is a template', 'asdfasdf', '', '', '', '', '', '', '', '', 0, 0, '', '', '', '', '', '', 'dff20fc6-9d71-436e-81fc-70707b2ad39c', false, '2021-12-28', '', 'New Template draft', '2021-12-17 19:12:11.193007', false, false);


--
-- TOC entry 3525 (class 0 OID 16905)
-- Dependencies: 217
-- Data for Name: medical_record_user; Type: TABLE DATA; Schema: public; Owner: postgres
--

INSERT INTO public.medical_record_user (mrus_uuid, mrus_mere_uuid, mrus_user_uuid, mrus_date, mrus_updated) VALUES ('36b95196-fc90-4015-ac84-61fc7235e5c9', 'ab84520a-40a3-4784-9746-2ff644f8c892', '6b72a04a-7f20-48d0-b74c-4e8ea539b6d3', '2021-12-17 17:35:47.010247', '2021-12-17 17:35:47.010247');


--
-- TOC entry 3526 (class 0 OID 16910)
-- Dependencies: 218
-- Data for Name: messages; Type: TABLE DATA; Schema: public; Owner: postgres
--

INSERT INTO public.messages (mess_uuid, mess_conv_uuid, mess_sender, mess_message, mess_date, mess_file, mess_read) VALUES ('69c8f6f9-b700-4e53-8725-3d21799eedcb', '41dba86a-fce2-49f4-8e38-36b0c3b7aa78', 'dff20fc6-9d71-436e-81fc-70707b2ad39c', 'Hello buddy!', '2021-12-27 12:55:38.432713', NULL, false);
INSERT INTO public.messages (mess_uuid, mess_conv_uuid, mess_sender, mess_message, mess_date, mess_file, mess_read) VALUES ('6a8938af-da21-4892-b402-5ce009a41ec4', '41dba86a-fce2-49f4-8e38-36b0c3b7aa78', '5f4c2888-0c8c-47d2-a935-fb1cf8e28be1', 'Hello Chester', '2021-12-27 12:58:35.306976', NULL, false);
INSERT INTO public.messages (mess_uuid, mess_conv_uuid, mess_sender, mess_message, mess_date, mess_file, mess_read) VALUES ('d9dba3c4-23c6-45f8-8333-0a13c587bbc5', '41dba86a-fce2-49f4-8e38-36b0c3b7aa78', '5f4c2888-0c8c-47d2-a935-fb1cf8e28be1', 'How are you?', '2021-12-27 12:58:38.171392', NULL, false);
INSERT INTO public.messages (mess_uuid, mess_conv_uuid, mess_sender, mess_message, mess_date, mess_file, mess_read) VALUES ('55ac84e6-2061-4dad-a866-1ff9b24f20dc', '41dba86a-fce2-49f4-8e38-36b0c3b7aa78', 'dff20fc6-9d71-436e-81fc-70707b2ad39c', 'Im good', '2021-12-27 12:58:41.387363', NULL, false);
INSERT INTO public.messages (mess_uuid, mess_conv_uuid, mess_sender, mess_message, mess_date, mess_file, mess_read) VALUES ('e2eb3cd7-6f46-4a5d-8640-bca3092a52e1', '41dba86a-fce2-49f4-8e38-36b0c3b7aa78', '5f4c2888-0c8c-47d2-a935-fb1cf8e28be1', 'Long', '2021-12-27 13:30:22.841151', NULL, false);
INSERT INTO public.messages (mess_uuid, mess_conv_uuid, mess_sender, mess_message, mess_date, mess_file, mess_read) VALUES ('0c7a144b-9c82-4504-9ee7-b7a814aeca7e', '41dba86a-fce2-49f4-8e38-36b0c3b7aa78', '5f4c2888-0c8c-47d2-a935-fb1cf8e28be1', 'messages', '2021-12-27 13:30:24.508369', NULL, false);
INSERT INTO public.messages (mess_uuid, mess_conv_uuid, mess_sender, mess_message, mess_date, mess_file, mess_read) VALUES ('f130bedc-134d-431b-9583-095a3ab09352', '41dba86a-fce2-49f4-8e38-36b0c3b7aa78', '5f4c2888-0c8c-47d2-a935-fb1cf8e28be1', 'really', '2021-12-27 13:30:26.347334', NULL, false);
INSERT INTO public.messages (mess_uuid, mess_conv_uuid, mess_sender, mess_message, mess_date, mess_file, mess_read) VALUES ('7a39ad6d-4281-4c7f-a94d-b46814035192', '41dba86a-fce2-49f4-8e38-36b0c3b7aa78', '5f4c2888-0c8c-47d2-a935-fb1cf8e28be1', 'long', '2021-12-27 13:30:27.096971', NULL, false);
INSERT INTO public.messages (mess_uuid, mess_conv_uuid, mess_sender, mess_message, mess_date, mess_file, mess_read) VALUES ('c61cc9fd-bb74-48c1-b1e3-a1ff00fa079a', '41dba86a-fce2-49f4-8e38-36b0c3b7aa78', '5f4c2888-0c8c-47d2-a935-fb1cf8e28be1', 'messages', '2021-12-27 13:30:28.436512', NULL, false);
INSERT INTO public.messages (mess_uuid, mess_conv_uuid, mess_sender, mess_message, mess_date, mess_file, mess_read) VALUES ('322e86ec-06a9-4cad-88a3-30f597ebf8fe', '41dba86a-fce2-49f4-8e38-36b0c3b7aa78', '5f4c2888-0c8c-47d2-a935-fb1cf8e28be1', 'hello', '2021-12-27 13:30:29.860529', NULL, false);
INSERT INTO public.messages (mess_uuid, mess_conv_uuid, mess_sender, mess_message, mess_date, mess_file, mess_read) VALUES ('58dd9cd2-2bc5-4c5f-854a-3d3d7c184ee8', '41dba86a-fce2-49f4-8e38-36b0c3b7aa78', '5f4c2888-0c8c-47d2-a935-fb1cf8e28be1', 'long', '2021-12-27 13:30:30.649569', NULL, false);
INSERT INTO public.messages (mess_uuid, mess_conv_uuid, mess_sender, mess_message, mess_date, mess_file, mess_read) VALUES ('fb0879be-dc06-4a8d-a222-ea086600f91f', '41dba86a-fce2-49f4-8e38-36b0c3b7aa78', '5f4c2888-0c8c-47d2-a935-fb1cf8e28be1', 'messages', '2021-12-27 13:30:32.54896', NULL, false);
INSERT INTO public.messages (mess_uuid, mess_conv_uuid, mess_sender, mess_message, mess_date, mess_file, mess_read) VALUES ('436ef754-f819-4f97-9f08-643dca1ac027', '41dba86a-fce2-49f4-8e38-36b0c3b7aa78', '5f4c2888-0c8c-47d2-a935-fb1cf8e28be1', 'hello', '2021-12-27 13:30:33.894755', NULL, false);
INSERT INTO public.messages (mess_uuid, mess_conv_uuid, mess_sender, mess_message, mess_date, mess_file, mess_read) VALUES ('58da3071-0c4c-4a48-90b1-7891cfed7270', '41dba86a-fce2-49f4-8e38-36b0c3b7aa78', '5f4c2888-0c8c-47d2-a935-fb1cf8e28be1', 'hi', '2021-12-27 13:30:34.872142', NULL, false);
INSERT INTO public.messages (mess_uuid, mess_conv_uuid, mess_sender, mess_message, mess_date, mess_file, mess_read) VALUES ('c385f71e-00e6-4a76-b9b3-be028005513f', '41dba86a-fce2-49f4-8e38-36b0c3b7aa78', '5f4c2888-0c8c-47d2-a935-fb1cf8e28be1', 'hey', '2021-12-27 13:30:35.716094', NULL, false);
INSERT INTO public.messages (mess_uuid, mess_conv_uuid, mess_sender, mess_message, mess_date, mess_file, mess_read) VALUES ('35b428a4-0fea-4549-820c-1cc523ea2298', '41dba86a-fce2-49f4-8e38-36b0c3b7aa78', '5f4c2888-0c8c-47d2-a935-fb1cf8e28be1', 'yo', '2021-12-27 13:30:36.65245', NULL, false);
INSERT INTO public.messages (mess_uuid, mess_conv_uuid, mess_sender, mess_message, mess_date, mess_file, mess_read) VALUES ('7c100c02-befc-459c-a22a-489774d979f4', '41dba86a-fce2-49f4-8e38-36b0c3b7aa78', 'dff20fc6-9d71-436e-81fc-70707b2ad39c', 'Hello', '2021-12-28 12:52:31.156485', NULL, false);
INSERT INTO public.messages (mess_uuid, mess_conv_uuid, mess_sender, mess_message, mess_date, mess_file, mess_read) VALUES ('3f1a9c0b-21d4-4579-bc9e-e67a0187e7e5', 'b79ffe1a-6721-467c-9b69-d57936fc0b92', 'dff20fc6-9d71-436e-81fc-70707b2ad39c', 'Hello', '2021-12-16 22:59:25.654433', NULL, true);
INSERT INTO public.messages (mess_uuid, mess_conv_uuid, mess_sender, mess_message, mess_date, mess_file, mess_read) VALUES ('35028cf3-a928-4fdd-8c73-aec9c0d3acd8', 'b79ffe1a-6721-467c-9b69-d57936fc0b92', 'dff20fc6-9d71-436e-81fc-70707b2ad39c', '?', '2021-12-17 01:58:38.125393', NULL, true);
INSERT INTO public.messages (mess_uuid, mess_conv_uuid, mess_sender, mess_message, mess_date, mess_file, mess_read) VALUES ('9a35c90d-e583-480d-9a01-1d8884bb8e9a', 'b79ffe1a-6721-467c-9b69-d57936fc0b92', 'dff20fc6-9d71-436e-81fc-70707b2ad39c', 'are you there=', '2021-12-17 01:58:41.146797', NULL, true);
INSERT INTO public.messages (mess_uuid, mess_conv_uuid, mess_sender, mess_message, mess_date, mess_file, mess_read) VALUES ('85f6a1e6-8b5d-4dab-969a-ac15e0b104d7', 'b79ffe1a-6721-467c-9b69-d57936fc0b92', 'dff20fc6-9d71-436e-81fc-70707b2ad39c', '?', '2021-12-17 01:58:42.060524', NULL, true);
INSERT INTO public.messages (mess_uuid, mess_conv_uuid, mess_sender, mess_message, mess_date, mess_file, mess_read) VALUES ('bab4bc1e-e2d8-43d0-8840-a55f8eee858e', 'c6954ed3-5c17-4157-987f-a5f5afd57d7d', 'dff20fc6-9d71-436e-81fc-70707b2ad39c', 'are you there?', '2022-01-03 21:25:10.069075', NULL, true);
INSERT INTO public.messages (mess_uuid, mess_conv_uuid, mess_sender, mess_message, mess_date, mess_file, mess_read) VALUES ('f9845408-e51d-4c7e-b06c-29f823d26f6c', 'c6954ed3-5c17-4157-987f-a5f5afd57d7d', 'dff20fc6-9d71-436e-81fc-70707b2ad39c', 'vidal', '2022-01-04 11:33:45.781898', NULL, true);
INSERT INTO public.messages (mess_uuid, mess_conv_uuid, mess_sender, mess_message, mess_date, mess_file, mess_read) VALUES ('dc8beabe-de2a-46cc-888e-63db844a1bdd', 'c6954ed3-5c17-4157-987f-a5f5afd57d7d', 'dff20fc6-9d71-436e-81fc-70707b2ad39c', 'u there?', '2022-01-04 11:33:47.546389', NULL, true);
INSERT INTO public.messages (mess_uuid, mess_conv_uuid, mess_sender, mess_message, mess_date, mess_file, mess_read) VALUES ('56c473c4-9c6b-49a7-89de-4760deabe3af', 'b79ffe1a-6721-467c-9b69-d57936fc0b92', 'dff20fc6-9d71-436e-81fc-70707b2ad39c', 'hey', '2021-12-17 01:58:46.538095', NULL, true);
INSERT INTO public.messages (mess_uuid, mess_conv_uuid, mess_sender, mess_message, mess_date, mess_file, mess_read) VALUES ('a3a986fd-1d4f-45f5-9b96-2d3015d601ad', '3a30992d-9aae-415d-b6cd-82a129147bde', 'dff20fc6-9d71-436e-81fc-70707b2ad39c', 'yo', '2021-12-31 02:54:30.455641', NULL, true);
INSERT INTO public.messages (mess_uuid, mess_conv_uuid, mess_sender, mess_message, mess_date, mess_file, mess_read) VALUES ('f11fa840-dd68-455a-bb50-cdeec260e496', '3a30992d-9aae-415d-b6cd-82a129147bde', 'dff20fc6-9d71-436e-81fc-70707b2ad39c', 'this message', '2021-12-31 02:54:32.940359', NULL, true);
INSERT INTO public.messages (mess_uuid, mess_conv_uuid, mess_sender, mess_message, mess_date, mess_file, mess_read) VALUES ('32146b5b-089e-4470-bf4e-3b6743426c87', '3a30992d-9aae-415d-b6cd-82a129147bde', 'dff20fc6-9d71-436e-81fc-70707b2ad39c', 'if for you', '2021-12-31 02:54:35.772622', NULL, true);
INSERT INTO public.messages (mess_uuid, mess_conv_uuid, mess_sender, mess_message, mess_date, mess_file, mess_read) VALUES ('cc880b3a-bae3-4ce0-b718-69d5bda0de81', '3a30992d-9aae-415d-b6cd-82a129147bde', 'e4769679-df90-49f0-8921-817db992e182', 'Could ', '2021-12-31 03:46:32.004811', NULL, true);
INSERT INTO public.messages (mess_uuid, mess_conv_uuid, mess_sender, mess_message, mess_date, mess_file, mess_read) VALUES ('e3734504-2e43-43f7-9c08-d928b2a1b90e', '3a30992d-9aae-415d-b6cd-82a129147bde', 'e4769679-df90-49f0-8921-817db992e182', 'it ', '2021-12-31 03:46:33.507433', NULL, true);
INSERT INTO public.messages (mess_uuid, mess_conv_uuid, mess_sender, mess_message, mess_date, mess_file, mess_read) VALUES ('77b75021-eb88-4efc-883c-174acd2513b5', '3a30992d-9aae-415d-b6cd-82a129147bde', 'e4769679-df90-49f0-8921-817db992e182', 'have', '2021-12-31 03:46:34.315082', NULL, true);
INSERT INTO public.messages (mess_uuid, mess_conv_uuid, mess_sender, mess_message, mess_date, mess_file, mess_read) VALUES ('15cc0a51-76a2-4f19-96e1-1e602f8bd69b', '3a30992d-9aae-415d-b6cd-82a129147bde', 'e4769679-df90-49f0-8921-817db992e182', 'been ', '2021-12-31 03:46:35.315212', NULL, true);
INSERT INTO public.messages (mess_uuid, mess_conv_uuid, mess_sender, mess_message, mess_date, mess_file, mess_read) VALUES ('260002a0-3c5d-4be8-9b05-a171efeaf69d', '3a30992d-9aae-415d-b6cd-82a129147bde', 'e4769679-df90-49f0-8921-817db992e182', 'a ', '2021-12-31 03:46:36.239393', NULL, true);
INSERT INTO public.messages (mess_uuid, mess_conv_uuid, mess_sender, mess_message, mess_date, mess_file, mess_read) VALUES ('039072c7-e193-4a13-bdd1-3ae15e867bf6', '3a30992d-9aae-415d-b6cd-82a129147bde', 'e4769679-df90-49f0-8921-817db992e182', 'bug?', '2021-12-31 03:46:38.837688', NULL, true);
INSERT INTO public.messages (mess_uuid, mess_conv_uuid, mess_sender, mess_message, mess_date, mess_file, mess_read) VALUES ('5b978cb1-c891-4461-a1f6-3bd8cda1d073', '3a30992d-9aae-415d-b6cd-82a129147bde', 'e4769679-df90-49f0-8921-817db992e182', 'a', '2021-12-31 03:42:41.020493', NULL, true);
INSERT INTO public.messages (mess_uuid, mess_conv_uuid, mess_sender, mess_message, mess_date, mess_file, mess_read) VALUES ('b0521c83-d503-41a2-8c92-2ffb8d8cb1e8', '3a30992d-9aae-415d-b6cd-82a129147bde', 'e4769679-df90-49f0-8921-817db992e182', 'a', '2021-12-31 03:29:28.078118', NULL, true);
INSERT INTO public.messages (mess_uuid, mess_conv_uuid, mess_sender, mess_message, mess_date, mess_file, mess_read) VALUES ('b1c57647-4e69-4662-81e0-98382a886f90', '3a30992d-9aae-415d-b6cd-82a129147bde', 'e4769679-df90-49f0-8921-817db992e182', 'a', '2021-12-31 03:06:09.59374', NULL, true);
INSERT INTO public.messages (mess_uuid, mess_conv_uuid, mess_sender, mess_message, mess_date, mess_file, mess_read) VALUES ('32e1e907-fa34-465c-a5c2-100519055623', '3a30992d-9aae-415d-b6cd-82a129147bde', 'e4769679-df90-49f0-8921-817db992e182', 'test', '2021-12-31 02:50:05.528916', NULL, true);
INSERT INTO public.messages (mess_uuid, mess_conv_uuid, mess_sender, mess_message, mess_date, mess_file, mess_read) VALUES ('5b65d0f4-3167-4da6-8e0d-1832e3e3cbd4', '3a30992d-9aae-415d-b6cd-82a129147bde', 'e4769679-df90-49f0-8921-817db992e182', 'f', '2021-12-30 22:31:42.360218', NULL, true);
INSERT INTO public.messages (mess_uuid, mess_conv_uuid, mess_sender, mess_message, mess_date, mess_file, mess_read) VALUES ('a9c5db41-50a0-47bd-90df-2cee8868378f', '3a30992d-9aae-415d-b6cd-82a129147bde', 'e4769679-df90-49f0-8921-817db992e182', 'smith', '2021-12-30 21:53:17.665258', NULL, true);
INSERT INTO public.messages (mess_uuid, mess_conv_uuid, mess_sender, mess_message, mess_date, mess_file, mess_read) VALUES ('75aae466-e2da-43c5-b8af-6eeb7ec0396b', '3a30992d-9aae-415d-b6cd-82a129147bde', 'e4769679-df90-49f0-8921-817db992e182', 'amapola', '2021-12-30 23:15:50.360418', NULL, true);
INSERT INTO public.messages (mess_uuid, mess_conv_uuid, mess_sender, mess_message, mess_date, mess_file, mess_read) VALUES ('882a7366-12f9-4c16-a871-a3e6c3b54fa1', 'b79ffe1a-6721-467c-9b69-d57936fc0b92', 'ebb602d1-35ef-45a1-b9f2-18576c2b3ad5', 'This has to go to messenger', '2022-01-04 19:04:39.017971', NULL, true);
INSERT INTO public.messages (mess_uuid, mess_conv_uuid, mess_sender, mess_message, mess_date, mess_file, mess_read) VALUES ('72c9a3aa-9735-47bf-bc2f-7054322eea20', 'b79ffe1a-6721-467c-9b69-d57936fc0b92', 'ebb602d1-35ef-45a1-b9f2-18576c2b3ad5', 'No wait', '2022-01-04 19:04:47.881903', NULL, true);
INSERT INTO public.messages (mess_uuid, mess_conv_uuid, mess_sender, mess_message, mess_date, mess_file, mess_read) VALUES ('0a93bc54-118f-46cf-94c5-3edbd96ff03d', '3a30992d-9aae-415d-b6cd-82a129147bde', 'e4769679-df90-49f0-8921-817db992e182', 'hey', '2021-12-31 02:35:28.06467', NULL, true);
INSERT INTO public.messages (mess_uuid, mess_conv_uuid, mess_sender, mess_message, mess_date, mess_file, mess_read) VALUES ('c91fc6c0-f51e-4e73-a578-d085fe3506bc', '3a30992d-9aae-415d-b6cd-82a129147bde', 'e4769679-df90-49f0-8921-817db992e182', 's', '2021-12-31 02:36:30.585487', NULL, true);
INSERT INTO public.messages (mess_uuid, mess_conv_uuid, mess_sender, mess_message, mess_date, mess_file, mess_read) VALUES ('3aa36c00-751a-4d63-9c70-6d61b226fee5', '3a30992d-9aae-415d-b6cd-82a129147bde', 'e4769679-df90-49f0-8921-817db992e182', 'maña', '2021-12-31 02:51:42.607494', NULL, true);
INSERT INTO public.messages (mess_uuid, mess_conv_uuid, mess_sender, mess_message, mess_date, mess_file, mess_read) VALUES ('41072893-038d-4c14-8511-74e80b37071c', '3a30992d-9aae-415d-b6cd-82a129147bde', 'e4769679-df90-49f0-8921-817db992e182', 'im doing well', '2021-12-30 22:31:26.82428', NULL, true);
INSERT INTO public.messages (mess_uuid, mess_conv_uuid, mess_sender, mess_message, mess_date, mess_file, mess_read) VALUES ('fa842d11-9839-4b15-a972-f5544773c9ee', '3a30992d-9aae-415d-b6cd-82a129147bde', 'e4769679-df90-49f0-8921-817db992e182', 'im test', '2021-12-31 01:08:52.20509', NULL, true);
INSERT INTO public.messages (mess_uuid, mess_conv_uuid, mess_sender, mess_message, mess_date, mess_file, mess_read) VALUES ('33708d5e-4159-4378-b84f-033162daeef6', '3a30992d-9aae-415d-b6cd-82a129147bde', 'e4769679-df90-49f0-8921-817db992e182', 'im the sernder', '2021-12-31 01:08:55.523718', NULL, true);
INSERT INTO public.messages (mess_uuid, mess_conv_uuid, mess_sender, mess_message, mess_date, mess_file, mess_read) VALUES ('a7f5ab7a-c7e5-4063-889a-f95183fb1059', '3a30992d-9aae-415d-b6cd-82a129147bde', 'e4769679-df90-49f0-8921-817db992e182', 'a', '2021-12-31 03:40:15.951232', NULL, true);
INSERT INTO public.messages (mess_uuid, mess_conv_uuid, mess_sender, mess_message, mess_date, mess_file, mess_read) VALUES ('93705022-3bd2-47d0-9ddf-5c8e8776856a', '3a30992d-9aae-415d-b6cd-82a129147bde', 'e4769679-df90-49f0-8921-817db992e182', 's', '2021-12-31 03:33:33.289627', NULL, true);
INSERT INTO public.messages (mess_uuid, mess_conv_uuid, mess_sender, mess_message, mess_date, mess_file, mess_read) VALUES ('4c3cc610-b0e0-46e1-a857-3f525ab228e4', '3a30992d-9aae-415d-b6cd-82a129147bde', 'e4769679-df90-49f0-8921-817db992e182', 'd', '2021-12-31 03:33:34.316625', NULL, true);
INSERT INTO public.messages (mess_uuid, mess_conv_uuid, mess_sender, mess_message, mess_date, mess_file, mess_read) VALUES ('b17e5e09-8b97-4e3a-8506-87480a9b29c4', '3a30992d-9aae-415d-b6cd-82a129147bde', 'e4769679-df90-49f0-8921-817db992e182', 'f', '2021-12-31 03:33:35.008297', NULL, true);
INSERT INTO public.messages (mess_uuid, mess_conv_uuid, mess_sender, mess_message, mess_date, mess_file, mess_read) VALUES ('07437c34-bdf4-4895-a032-ae6b748e3836', '3a30992d-9aae-415d-b6cd-82a129147bde', 'e4769679-df90-49f0-8921-817db992e182', 'd', '2021-12-31 03:44:41.97696', NULL, true);
INSERT INTO public.messages (mess_uuid, mess_conv_uuid, mess_sender, mess_message, mess_date, mess_file, mess_read) VALUES ('2e829162-3af6-4f45-8542-03153d046a69', '3a30992d-9aae-415d-b6cd-82a129147bde', 'e4769679-df90-49f0-8921-817db992e182', 'd', '2021-12-31 03:33:35.67981', NULL, true);
INSERT INTO public.messages (mess_uuid, mess_conv_uuid, mess_sender, mess_message, mess_date, mess_file, mess_read) VALUES ('af6054ca-87b1-4a46-9765-37e15ab58482', '3a30992d-9aae-415d-b6cd-82a129147bde', 'e4769679-df90-49f0-8921-817db992e182', 'f', '2021-12-31 03:33:36.178938', NULL, true);
INSERT INTO public.messages (mess_uuid, mess_conv_uuid, mess_sender, mess_message, mess_date, mess_file, mess_read) VALUES ('735183b4-2458-487c-9f13-c099022b25f9', '3a30992d-9aae-415d-b6cd-82a129147bde', 'e4769679-df90-49f0-8921-817db992e182', 'c', '2021-12-31 03:39:54.619736', NULL, true);
INSERT INTO public.messages (mess_uuid, mess_conv_uuid, mess_sender, mess_message, mess_date, mess_file, mess_read) VALUES ('d38687ad-7b6c-4d68-90f5-e40ff9a87233', 'c6954ed3-5c17-4157-987f-a5f5afd57d7d', 'dff20fc6-9d71-436e-81fc-70707b2ad39c', 'Yes, ', '2022-01-03 21:25:23.624759', NULL, true);
INSERT INTO public.messages (mess_uuid, mess_conv_uuid, mess_sender, mess_message, mess_date, mess_file, mess_read) VALUES ('9a81c5bd-3a2a-409f-be34-19ff530150bd', 'c6954ed3-5c17-4157-987f-a5f5afd57d7d', 'c71f7e00-8408-4cb8-98dc-ad9a27a76c14', 'Yo', '2022-01-03 16:33:41.788478', NULL, true);
INSERT INTO public.messages (mess_uuid, mess_conv_uuid, mess_sender, mess_message, mess_date, mess_file, mess_read) VALUES ('36b2ba28-c030-435a-844c-53674e210a94', 'c6954ed3-5c17-4157-987f-a5f5afd57d7d', 'c71f7e00-8408-4cb8-98dc-ad9a27a76c14', 'yes', '2022-01-03 21:25:12.515247', NULL, true);
INSERT INTO public.messages (mess_uuid, mess_conv_uuid, mess_sender, mess_message, mess_date, mess_file, mess_read) VALUES ('8a08c698-0d3e-4d7b-8c32-ef4f59cb986b', 'c6954ed3-5c17-4157-987f-a5f5afd57d7d', 'c71f7e00-8408-4cb8-98dc-ad9a27a76c14', 'can you call me?', '2022-01-03 21:25:18.509847', NULL, true);
INSERT INTO public.messages (mess_uuid, mess_conv_uuid, mess_sender, mess_message, mess_date, mess_file, mess_read) VALUES ('4c2b4486-4095-49ac-8e62-6c96058aefaa', '3a30992d-9aae-415d-b6cd-82a129147bde', 'e4769679-df90-49f0-8921-817db992e182', 'c', '2021-12-31 03:33:36.654682', NULL, true);
INSERT INTO public.messages (mess_uuid, mess_conv_uuid, mess_sender, mess_message, mess_date, mess_file, mess_read) VALUES ('74bcdbeb-aa5e-4b39-ba13-9e4e0080b7bb', '3a30992d-9aae-415d-b6cd-82a129147bde', 'e4769679-df90-49f0-8921-817db992e182', 'd', '2021-12-31 03:33:37.473135', NULL, true);
INSERT INTO public.messages (mess_uuid, mess_conv_uuid, mess_sender, mess_message, mess_date, mess_file, mess_read) VALUES ('a182fa96-29d4-4a5f-aa3e-f3107ee2c92c', '3a30992d-9aae-415d-b6cd-82a129147bde', 'e4769679-df90-49f0-8921-817db992e182', 'e', '2021-12-31 03:33:37.774747', NULL, true);
INSERT INTO public.messages (mess_uuid, mess_conv_uuid, mess_sender, mess_message, mess_date, mess_file, mess_read) VALUES ('52f224a6-bdb6-48da-a52c-a80335c57de8', '3a30992d-9aae-415d-b6cd-82a129147bde', 'e4769679-df90-49f0-8921-817db992e182', 'f', '2021-12-31 03:33:38.504142', NULL, true);
INSERT INTO public.messages (mess_uuid, mess_conv_uuid, mess_sender, mess_message, mess_date, mess_file, mess_read) VALUES ('414969a7-fae2-461f-9b33-08e4d4704dd3', '3a30992d-9aae-415d-b6cd-82a129147bde', 'e4769679-df90-49f0-8921-817db992e182', 'todo hay', '2021-12-31 02:51:41.528083', NULL, true);
INSERT INTO public.messages (mess_uuid, mess_conv_uuid, mess_sender, mess_message, mess_date, mess_file, mess_read) VALUES ('d56e6234-ea21-494d-90e8-6e3a52a9cfc7', '3a30992d-9aae-415d-b6cd-82a129147bde', 'e4769679-df90-49f0-8921-817db992e182', 'hey´', '2021-12-30 21:44:44.680262', NULL, true);
INSERT INTO public.messages (mess_uuid, mess_conv_uuid, mess_sender, mess_message, mess_date, mess_file, mess_read) VALUES ('52025848-f036-46b5-a957-df5a8ea0b971', '3a30992d-9aae-415d-b6cd-82a129147bde', 'e4769679-df90-49f0-8921-817db992e182', 'Hello', '2021-12-30 21:47:53.429311', NULL, true);
INSERT INTO public.messages (mess_uuid, mess_conv_uuid, mess_sender, mess_message, mess_date, mess_file, mess_read) VALUES ('b20a0b11-9357-446b-a424-9397315d95ac', '3a30992d-9aae-415d-b6cd-82a129147bde', 'e4769679-df90-49f0-8921-817db992e182', 'G400', '2021-12-30 23:16:19.520622', NULL, true);
INSERT INTO public.messages (mess_uuid, mess_conv_uuid, mess_sender, mess_message, mess_date, mess_file, mess_read) VALUES ('f5acb09b-b2be-41dc-ae46-cb7bbb7c776f', '3a30992d-9aae-415d-b6cd-82a129147bde', 'e4769679-df90-49f0-8921-817db992e182', 'weed', '2021-12-31 01:06:21.841002', NULL, true);
INSERT INTO public.messages (mess_uuid, mess_conv_uuid, mess_sender, mess_message, mess_date, mess_file, mess_read) VALUES ('319314f6-2a0a-454e-b0e7-5df19d46746e', '3a30992d-9aae-415d-b6cd-82a129147bde', 'e4769679-df90-49f0-8921-817db992e182', '22%', '2021-12-31 01:06:48.937139', NULL, true);
INSERT INTO public.messages (mess_uuid, mess_conv_uuid, mess_sender, mess_message, mess_date, mess_file, mess_read) VALUES ('c28a833d-94f4-420e-ad9e-c80f6ea017a8', '3a30992d-9aae-415d-b6cd-82a129147bde', 'e4769679-df90-49f0-8921-817db992e182', 'the sender', '2021-12-31 01:08:24.850396', NULL, true);
INSERT INTO public.messages (mess_uuid, mess_conv_uuid, mess_sender, mess_message, mess_date, mess_file, mess_read) VALUES ('a807c57c-1495-4c00-a066-56660161072a', '3a30992d-9aae-415d-b6cd-82a129147bde', 'e4769679-df90-49f0-8921-817db992e182', 'new', '2021-12-31 01:09:43.782577', NULL, true);
INSERT INTO public.messages (mess_uuid, mess_conv_uuid, mess_sender, mess_message, mess_date, mess_file, mess_read) VALUES ('a2895d9e-fe85-401b-9a93-c52a0c859763', '3a30992d-9aae-415d-b6cd-82a129147bde', 'e4769679-df90-49f0-8921-817db992e182', 'sa', '2021-12-31 02:28:22.410305', NULL, true);
INSERT INTO public.messages (mess_uuid, mess_conv_uuid, mess_sender, mess_message, mess_date, mess_file, mess_read) VALUES ('791cda29-0554-4559-b91a-1cb0ca11416b', '3a30992d-9aae-415d-b6cd-82a129147bde', 'e4769679-df90-49f0-8921-817db992e182', 's', '2021-12-31 02:28:56.665398', NULL, true);
INSERT INTO public.messages (mess_uuid, mess_conv_uuid, mess_sender, mess_message, mess_date, mess_file, mess_read) VALUES ('fdb55c89-8fa6-44f6-8a30-4439a776ba80', '3a30992d-9aae-415d-b6cd-82a129147bde', 'e4769679-df90-49f0-8921-817db992e182', 'a', '2021-12-31 02:29:21.745682', NULL, true);
INSERT INTO public.messages (mess_uuid, mess_conv_uuid, mess_sender, mess_message, mess_date, mess_file, mess_read) VALUES ('013d66b7-899d-4b18-b2dc-2e0a5821277b', '3a30992d-9aae-415d-b6cd-82a129147bde', 'e4769679-df90-49f0-8921-817db992e182', 'positive', '2021-12-31 02:29:55.121961', NULL, true);
INSERT INTO public.messages (mess_uuid, mess_conv_uuid, mess_sender, mess_message, mess_date, mess_file, mess_read) VALUES ('4502435b-641e-4fbc-a203-967ba72a5eb0', '3a30992d-9aae-415d-b6cd-82a129147bde', 'dff20fc6-9d71-436e-81fc-70707b2ad39c', 's', '2021-12-30 22:32:55.847568', NULL, true);
INSERT INTO public.messages (mess_uuid, mess_conv_uuid, mess_sender, mess_message, mess_date, mess_file, mess_read) VALUES ('74be4231-c63b-4340-b004-1957a7d0a007', '3a30992d-9aae-415d-b6cd-82a129147bde', 'dff20fc6-9d71-436e-81fc-70707b2ad39c', 'im', '2021-12-31 01:08:07.386114', NULL, true);
INSERT INTO public.messages (mess_uuid, mess_conv_uuid, mess_sender, mess_message, mess_date, mess_file, mess_read) VALUES ('486c2351-1d6e-4fa2-8a79-72c8aa2a932e', '3a30992d-9aae-415d-b6cd-82a129147bde', 'dff20fc6-9d71-436e-81fc-70707b2ad39c', 'mmm', '2021-12-31 01:39:30.465493', NULL, true);
INSERT INTO public.messages (mess_uuid, mess_conv_uuid, mess_sender, mess_message, mess_date, mess_file, mess_read) VALUES ('62140225-1482-47c1-8eed-a1c96b5bda63', '3a30992d-9aae-415d-b6cd-82a129147bde', 'dff20fc6-9d71-436e-81fc-70707b2ad39c', 'e', '2021-12-31 01:39:42.344133', NULL, true);
INSERT INTO public.messages (mess_uuid, mess_conv_uuid, mess_sender, mess_message, mess_date, mess_file, mess_read) VALUES ('743ad2be-c436-4fb5-948f-4916f83f76e9', '3a30992d-9aae-415d-b6cd-82a129147bde', 'dff20fc6-9d71-436e-81fc-70707b2ad39c', 'motaaa', '2021-12-30 22:43:28.60932', NULL, true);
INSERT INTO public.messages (mess_uuid, mess_conv_uuid, mess_sender, mess_message, mess_date, mess_file, mess_read) VALUES ('3522cdd5-7cb2-45c6-ab6c-8d56d85b25de', '3a30992d-9aae-415d-b6cd-82a129147bde', 'dff20fc6-9d71-436e-81fc-70707b2ad39c', 'una nueve', '2021-12-30 22:40:47.012157', NULL, true);
INSERT INTO public.messages (mess_uuid, mess_conv_uuid, mess_sender, mess_message, mess_date, mess_file, mess_read) VALUES ('bbcb0236-1f04-4986-8b09-20435f2aa4ab', '3a30992d-9aae-415d-b6cd-82a129147bde', 'dff20fc6-9d71-436e-81fc-70707b2ad39c', 'y la fiesta', '2021-12-30 22:42:57.195397', NULL, true);
INSERT INTO public.messages (mess_uuid, mess_conv_uuid, mess_sender, mess_message, mess_date, mess_file, mess_read) VALUES ('0018fbdf-2695-40b3-940f-343f343839d2', '3a30992d-9aae-415d-b6cd-82a129147bde', 'dff20fc6-9d71-436e-81fc-70707b2ad39c', 'Y la fiesta empieza otra vez', '2021-12-30 22:43:16.601985', NULL, true);
INSERT INTO public.messages (mess_uuid, mess_conv_uuid, mess_sender, mess_message, mess_date, mess_file, mess_read) VALUES ('857cf453-bbba-4a5d-a051-5417c6447399', '3a30992d-9aae-415d-b6cd-82a129147bde', 'dff20fc6-9d71-436e-81fc-70707b2ad39c', 'lorem', '2021-12-30 22:43:55.679013', NULL, true);
INSERT INTO public.messages (mess_uuid, mess_conv_uuid, mess_sender, mess_message, mess_date, mess_file, mess_read) VALUES ('10685d77-e49e-4bf9-bd60-428b07c0fbc1', '3a30992d-9aae-415d-b6cd-82a129147bde', 'dff20fc6-9d71-436e-81fc-70707b2ad39c', 's', '2021-12-31 01:06:27.604804', NULL, true);
INSERT INTO public.messages (mess_uuid, mess_conv_uuid, mess_sender, mess_message, mess_date, mess_file, mess_read) VALUES ('36757ea3-d0fc-4634-882e-014b9a788bc3', '3a30992d-9aae-415d-b6cd-82a129147bde', 'dff20fc6-9d71-436e-81fc-70707b2ad39c', '22%', '2021-12-31 01:06:53.991214', NULL, true);
INSERT INTO public.messages (mess_uuid, mess_conv_uuid, mess_sender, mess_message, mess_date, mess_file, mess_read) VALUES ('4b12c84e-11a6-47de-bc44-84cc5ce5c617', '3a30992d-9aae-415d-b6cd-82a129147bde', 'dff20fc6-9d71-436e-81fc-70707b2ad39c', 'hey', '2021-12-31 02:28:07.622722', NULL, true);
INSERT INTO public.messages (mess_uuid, mess_conv_uuid, mess_sender, mess_message, mess_date, mess_file, mess_read) VALUES ('ceaacebf-453e-4eb2-a7a6-65997c8deb45', '3a30992d-9aae-415d-b6cd-82a129147bde', 'dff20fc6-9d71-436e-81fc-70707b2ad39c', 'a', '2021-12-31 02:47:51.840393', NULL, true);
INSERT INTO public.messages (mess_uuid, mess_conv_uuid, mess_sender, mess_message, mess_date, mess_file, mess_read) VALUES ('6ba825fd-0ca1-4d77-933c-bf14caf6edeb', '3a30992d-9aae-415d-b6cd-82a129147bde', 'dff20fc6-9d71-436e-81fc-70707b2ad39c', 'this is cool', '2021-12-31 02:51:52.565978', NULL, true);
INSERT INTO public.messages (mess_uuid, mess_conv_uuid, mess_sender, mess_message, mess_date, mess_file, mess_read) VALUES ('06099802-ac51-424a-95fe-9621d2914236', '3a30992d-9aae-415d-b6cd-82a129147bde', 'dff20fc6-9d71-436e-81fc-70707b2ad39c', 'cool', '2021-12-31 02:51:56.104644', NULL, true);
INSERT INTO public.messages (mess_uuid, mess_conv_uuid, mess_sender, mess_message, mess_date, mess_file, mess_read) VALUES ('23133b6a-fa76-4ed3-af60-b50d49aa89f0', 'b79ffe1a-6721-467c-9b69-d57936fc0b92', 'dff20fc6-9d71-436e-81fc-70707b2ad39c', 'This is still ', '2022-01-04 19:05:01.348474', NULL, true);
INSERT INTO public.messages (mess_uuid, mess_conv_uuid, mess_sender, mess_message, mess_date, mess_file, mess_read) VALUES ('8e33fd0a-60f1-4170-b7dd-9d5ebc8729d7', 'b79ffe1a-6721-467c-9b69-d57936fc0b92', 'dff20fc6-9d71-436e-81fc-70707b2ad39c', 'the normal caht', '2022-01-04 19:05:04.248351', NULL, true);
INSERT INTO public.messages (mess_uuid, mess_conv_uuid, mess_sender, mess_message, mess_date, mess_file, mess_read) VALUES ('01f8944a-6eee-4b5a-8896-608e5b340e5f', '3a30992d-9aae-415d-b6cd-82a129147bde', 'e4769679-df90-49f0-8921-817db992e182', 'me', '2021-12-31 01:11:13.889167', NULL, true);
INSERT INTO public.messages (mess_uuid, mess_conv_uuid, mess_sender, mess_message, mess_date, mess_file, mess_read) VALUES ('5f65922e-fbca-44d2-b6d9-e5e3779755aa', '3a30992d-9aae-415d-b6cd-82a129147bde', 'e4769679-df90-49f0-8921-817db992e182', 'me', '2021-12-31 01:39:05.928294', NULL, true);
INSERT INTO public.messages (mess_uuid, mess_conv_uuid, mess_sender, mess_message, mess_date, mess_file, mess_read) VALUES ('2e28cfd8-0c69-49fd-8dd5-229cd9a17839', '3a30992d-9aae-415d-b6cd-82a129147bde', 'e4769679-df90-49f0-8921-817db992e182', 'this is me', '2021-12-31 01:39:09.507326', NULL, true);
INSERT INTO public.messages (mess_uuid, mess_conv_uuid, mess_sender, mess_message, mess_date, mess_file, mess_read) VALUES ('b41581c0-0227-40e5-9f65-97c8c7089183', '3a30992d-9aae-415d-b6cd-82a129147bde', 'e4769679-df90-49f0-8921-817db992e182', 'pa', '2021-12-31 02:51:38.396606', NULL, true);
INSERT INTO public.messages (mess_uuid, mess_conv_uuid, mess_sender, mess_message, mess_date, mess_file, mess_read) VALUES ('47ac56ae-857e-47cb-ac62-ce0cac2864bd', '3a30992d-9aae-415d-b6cd-82a129147bde', 'e4769679-df90-49f0-8921-817db992e182', 'cookies en las pipas', '2021-12-31 02:25:51.557908', NULL, true);
INSERT INTO public.messages (mess_uuid, mess_conv_uuid, mess_sender, mess_message, mess_date, mess_file, mess_read) VALUES ('4b2f3442-5838-427c-bc2e-acd74bba9ac1', '3a30992d-9aae-415d-b6cd-82a129147bde', 'e4769679-df90-49f0-8921-817db992e182', 'a', '2021-12-31 02:27:03.334737', NULL, true);
INSERT INTO public.messages (mess_uuid, mess_conv_uuid, mess_sender, mess_message, mess_date, mess_file, mess_read) VALUES ('17df98e4-1302-401e-be3e-9fe46aecaa12', '3a30992d-9aae-415d-b6cd-82a129147bde', 'e4769679-df90-49f0-8921-817db992e182', 'start', '2021-12-31 02:27:23.284456', NULL, true);
INSERT INTO public.messages (mess_uuid, mess_conv_uuid, mess_sender, mess_message, mess_date, mess_file, mess_read) VALUES ('645854ac-87da-4b0b-9299-c75b2dd33ce4', '3a30992d-9aae-415d-b6cd-82a129147bde', 'e4769679-df90-49f0-8921-817db992e182', 'sdf', '2021-12-31 02:27:54.800883', NULL, true);
INSERT INTO public.messages (mess_uuid, mess_conv_uuid, mess_sender, mess_message, mess_date, mess_file, mess_read) VALUES ('293f1a8c-7d10-461f-986d-7c86721ef31f', '3a30992d-9aae-415d-b6cd-82a129147bde', 'e4769679-df90-49f0-8921-817db992e182', 'at', '2021-12-31 03:36:09.247572', NULL, true);
INSERT INTO public.messages (mess_uuid, mess_conv_uuid, mess_sender, mess_message, mess_date, mess_file, mess_read) VALUES ('14a699fe-62c3-4590-b349-5293736d0036', '3a30992d-9aae-415d-b6cd-82a129147bde', 'e4769679-df90-49f0-8921-817db992e182', 'd', '2021-12-31 03:43:55.370844', NULL, true);
INSERT INTO public.messages (mess_uuid, mess_conv_uuid, mess_sender, mess_message, mess_date, mess_file, mess_read) VALUES ('2f4372e4-56fe-4d5b-b97e-b0f2ff29db5c', '3a30992d-9aae-415d-b6cd-82a129147bde', 'e4769679-df90-49f0-8921-817db992e182', 'great', '2021-12-31 03:45:09.229525', NULL, true);
INSERT INTO public.messages (mess_uuid, mess_conv_uuid, mess_sender, mess_message, mess_date, mess_file, mess_read) VALUES ('f131ca2a-dd1c-462d-8191-852d8ea912ef', '3a30992d-9aae-415d-b6cd-82a129147bde', 'e4769679-df90-49f0-8921-817db992e182', 'mm...', '2021-12-31 03:47:10.638567', NULL, true);
INSERT INTO public.messages (mess_uuid, mess_conv_uuid, mess_sender, mess_message, mess_date, mess_file, mess_read) VALUES ('87dec5b4-5984-4ff5-8bef-31d45b96cf8a', '3a30992d-9aae-415d-b6cd-82a129147bde', 'e4769679-df90-49f0-8921-817db992e182', 'Yo quiero fumaaar', '2021-12-30 22:43:24.53132', NULL, true);
INSERT INTO public.messages (mess_uuid, mess_conv_uuid, mess_sender, mess_message, mess_date, mess_file, mess_read) VALUES ('9da27aee-85ce-457d-946d-e70ce4edc114', '3a30992d-9aae-415d-b6cd-82a129147bde', 'e4769679-df90-49f0-8921-817db992e182', 's', '2021-12-30 22:43:51.678354', NULL, true);
INSERT INTO public.messages (mess_uuid, mess_conv_uuid, mess_sender, mess_message, mess_date, mess_file, mess_read) VALUES ('df21217f-2395-4b40-99d5-c5d99f045b03', '3a30992d-9aae-415d-b6cd-82a129147bde', 'e4769679-df90-49f0-8921-817db992e182', 'motaaa', '2021-12-30 23:14:53.374117', NULL, true);
INSERT INTO public.messages (mess_uuid, mess_conv_uuid, mess_sender, mess_message, mess_date, mess_file, mess_read) VALUES ('a6eed34c-92ed-4014-a90a-6816cba1988e', 'b79ffe1a-6721-467c-9b69-d57936fc0b92', 'dff20fc6-9d71-436e-81fc-70707b2ad39c', 'hey', '2022-01-05 15:25:52.052842', NULL, true);
INSERT INTO public.messages (mess_uuid, mess_conv_uuid, mess_sender, mess_message, mess_date, mess_file, mess_read) VALUES ('cad8049c-4d84-4e27-bec7-0afd12ae12d4', 'b79ffe1a-6721-467c-9b69-d57936fc0b92', 'ebb602d1-35ef-45a1-b9f2-18576c2b3ad5', 'Hello', '2022-01-05 15:25:59.688412', NULL, true);
INSERT INTO public.messages (mess_uuid, mess_conv_uuid, mess_sender, mess_message, mess_date, mess_file, mess_read) VALUES ('7280f743-1718-4cea-a770-9c70163509d7', '3a30992d-9aae-415d-b6cd-82a129147bde', 'dff20fc6-9d71-436e-81fc-70707b2ad39c', 'maybe', '2021-12-31 03:47:05.768188', NULL, true);
INSERT INTO public.messages (mess_uuid, mess_conv_uuid, mess_sender, mess_message, mess_date, mess_file, mess_read) VALUES ('ce800c23-464c-4d10-b3f9-6b1d268e6599', '3a30992d-9aae-415d-b6cd-82a129147bde', 'dff20fc6-9d71-436e-81fc-70707b2ad39c', 'test', '2021-12-31 02:35:21.841858', NULL, true);
INSERT INTO public.messages (mess_uuid, mess_conv_uuid, mess_sender, mess_message, mess_date, mess_file, mess_read) VALUES ('68ec68a7-839c-4464-9a8e-af372384d011', '3a30992d-9aae-415d-b6cd-82a129147bde', 'dff20fc6-9d71-436e-81fc-70707b2ad39c', 'stgtbt', '2021-12-31 02:39:11.155209', NULL, true);
INSERT INTO public.messages (mess_uuid, mess_conv_uuid, mess_sender, mess_message, mess_date, mess_file, mess_read) VALUES ('eece86e5-2f67-4ed4-8d4f-1293738e799e', '3a30992d-9aae-415d-b6cd-82a129147bde', 'dff20fc6-9d71-436e-81fc-70707b2ad39c', 'grat!', '2021-12-31 02:51:48.674057', NULL, true);
INSERT INTO public.messages (mess_uuid, mess_conv_uuid, mess_sender, mess_message, mess_date, mess_file, mess_read) VALUES ('91703357-72fe-4d9e-8a17-617b3ef0dfeb', '3a30992d-9aae-415d-b6cd-82a129147bde', 'dff20fc6-9d71-436e-81fc-70707b2ad39c', 'cool', '2021-12-31 02:51:55.289047', NULL, true);
INSERT INTO public.messages (mess_uuid, mess_conv_uuid, mess_sender, mess_message, mess_date, mess_file, mess_read) VALUES ('1158dbe8-5c7d-42eb-80ba-04fe9daedaa5', '3a30992d-9aae-415d-b6cd-82a129147bde', 'dff20fc6-9d71-436e-81fc-70707b2ad39c', 'cool', '2021-12-31 02:51:57.065015', NULL, true);
INSERT INTO public.messages (mess_uuid, mess_conv_uuid, mess_sender, mess_message, mess_date, mess_file, mess_read) VALUES ('924359f9-b872-4343-b290-532426408a44', '3a30992d-9aae-415d-b6cd-82a129147bde', 'e4769679-df90-49f0-8921-817db992e182', 's', '2021-12-30 21:48:13.675376', NULL, true);
INSERT INTO public.messages (mess_uuid, mess_conv_uuid, mess_sender, mess_message, mess_date, mess_file, mess_read) VALUES ('046124da-f90a-4e7e-8f50-ced351041214', '3a30992d-9aae-415d-b6cd-82a129147bde', 'e4769679-df90-49f0-8921-817db992e182', 'sup', '2021-12-30 22:30:53.096639', NULL, true);
INSERT INTO public.messages (mess_uuid, mess_conv_uuid, mess_sender, mess_message, mess_date, mess_file, mess_read) VALUES ('9bab5544-649c-4835-9427-8aab5353d9e9', '3a30992d-9aae-415d-b6cd-82a129147bde', 'e4769679-df90-49f0-8921-817db992e182', 'd', '2021-12-31 03:32:37.265494', NULL, true);
INSERT INTO public.messages (mess_uuid, mess_conv_uuid, mess_sender, mess_message, mess_date, mess_file, mess_read) VALUES ('4c668e54-8753-42bd-8a3a-9c4599c28211', '3a30992d-9aae-415d-b6cd-82a129147bde', 'e4769679-df90-49f0-8921-817db992e182', '😫', '2021-12-31 02:07:58.83632', NULL, true);
INSERT INTO public.messages (mess_uuid, mess_conv_uuid, mess_sender, mess_message, mess_date, mess_file, mess_read) VALUES ('efe7b4e0-d666-4b86-b1a0-cb07dc41ad71', '3a30992d-9aae-415d-b6cd-82a129147bde', 'e4769679-df90-49f0-8921-817db992e182', 'and weson', '2021-12-30 21:53:20.257561', NULL, true);
INSERT INTO public.messages (mess_uuid, mess_conv_uuid, mess_sender, mess_message, mess_date, mess_file, mess_read) VALUES ('a9e9b68e-84e4-4348-bfd4-5a9ccb3515ea', '3a30992d-9aae-415d-b6cd-82a129147bde', 'e4769679-df90-49f0-8921-817db992e182', 'Hello', '2021-12-30 16:51:35.245384', NULL, true);
INSERT INTO public.messages (mess_uuid, mess_conv_uuid, mess_sender, mess_message, mess_date, mess_file, mess_read) VALUES ('72309c4d-7280-4b72-b4b5-56c855332186', '3a30992d-9aae-415d-b6cd-82a129147bde', 'e4769679-df90-49f0-8921-817db992e182', 'How are you?', '2021-12-30 16:52:11.658384', NULL, true);
INSERT INTO public.messages (mess_uuid, mess_conv_uuid, mess_sender, mess_message, mess_date, mess_file, mess_read) VALUES ('85dc56b8-1232-40a5-b344-7c6a7f64916a', '3a30992d-9aae-415d-b6cd-82a129147bde', 'e4769679-df90-49f0-8921-817db992e182', 'una super', '2021-12-30 22:33:02.823855', NULL, true);
INSERT INTO public.messages (mess_uuid, mess_conv_uuid, mess_sender, mess_message, mess_date, mess_file, mess_read) VALUES ('cddec681-d903-4b3a-8558-75b06bf01e64', '3a30992d-9aae-415d-b6cd-82a129147bde', 'e4769679-df90-49f0-8921-817db992e182', 'ya la conecte', '2021-12-30 22:42:50.79214', NULL, true);
INSERT INTO public.messages (mess_uuid, mess_conv_uuid, mess_sender, mess_message, mess_date, mess_file, mess_read) VALUES ('a62e6f7e-178f-4405-9ea0-2c0be40d2fcc', '3a30992d-9aae-415d-b6cd-82a129147bde', 'e4769679-df90-49f0-8921-817db992e182', 'a', '2021-12-31 02:40:08.236461', NULL, true);
INSERT INTO public.messages (mess_uuid, mess_conv_uuid, mess_sender, mess_message, mess_date, mess_file, mess_read) VALUES ('2003192f-f601-4c7d-a921-26857d73c3c9', '3a30992d-9aae-415d-b6cd-82a129147bde', 'dff20fc6-9d71-436e-81fc-70707b2ad39c', 's', '2021-12-31 02:47:34.859167', NULL, true);
INSERT INTO public.messages (mess_uuid, mess_conv_uuid, mess_sender, mess_message, mess_date, mess_file, mess_read) VALUES ('e636aaf2-ae2d-4c4c-9712-7a2a79be9f7d', '3a30992d-9aae-415d-b6cd-82a129147bde', 'dff20fc6-9d71-436e-81fc-70707b2ad39c', ',,,', '2021-12-30 22:31:36.853733', NULL, true);
INSERT INTO public.messages (mess_uuid, mess_conv_uuid, mess_sender, mess_message, mess_date, mess_file, mess_read) VALUES ('1438ee7f-c8d3-41ba-b63b-a0e4083a0f2e', '3a30992d-9aae-415d-b6cd-82a129147bde', 'dff20fc6-9d71-436e-81fc-70707b2ad39c', 'Hey', '2021-12-30 21:42:21.858596', NULL, true);
INSERT INTO public.messages (mess_uuid, mess_conv_uuid, mess_sender, mess_message, mess_date, mess_file, mess_read) VALUES ('a785f297-d51e-4a06-9508-fff9de2e12bd', '3a30992d-9aae-415d-b6cd-82a129147bde', 'dff20fc6-9d71-436e-81fc-70707b2ad39c', 'YO', '2021-12-30 21:45:41.505384', NULL, true);
INSERT INTO public.messages (mess_uuid, mess_conv_uuid, mess_sender, mess_message, mess_date, mess_file, mess_read) VALUES ('56909cd0-b37d-4fa7-bfca-3bf52b2ed462', '3a30992d-9aae-415d-b6cd-82a129147bde', 'dff20fc6-9d71-436e-81fc-70707b2ad39c', 's', '2021-12-30 21:48:16.832749', NULL, true);
INSERT INTO public.messages (mess_uuid, mess_conv_uuid, mess_sender, mess_message, mess_date, mess_file, mess_read) VALUES ('1f8d2b70-6e0d-46aa-9348-c7bf9fa9dec4', '3a30992d-9aae-415d-b6cd-82a129147bde', 'dff20fc6-9d71-436e-81fc-70707b2ad39c', 'hey!', '2021-12-30 22:31:07.991112', NULL, true);
INSERT INTO public.messages (mess_uuid, mess_conv_uuid, mess_sender, mess_message, mess_date, mess_file, mess_read) VALUES ('1ab7a4f6-0cff-4b45-bce2-7796f028720e', '3a30992d-9aae-415d-b6cd-82a129147bde', 'dff20fc6-9d71-436e-81fc-70707b2ad39c', 'how are you doing?', '2021-12-30 22:31:13.127112', NULL, true);
INSERT INTO public.messages (mess_uuid, mess_conv_uuid, mess_sender, mess_message, mess_date, mess_file, mess_read) VALUES ('9cb8b3d4-d937-48cb-a5a6-99764f711b5a', '3a30992d-9aae-415d-b6cd-82a129147bde', 'dff20fc6-9d71-436e-81fc-70707b2ad39c', 'seen', '2021-12-31 02:51:59.346958', NULL, true);
INSERT INTO public.messages (mess_uuid, mess_conv_uuid, mess_sender, mess_message, mess_date, mess_file, mess_read) VALUES ('140956a2-5bb0-4a34-8497-5421ce77058b', '3a30992d-9aae-415d-b6cd-82a129147bde', 'e4769679-df90-49f0-8921-817db992e182', 'd', '2021-12-31 03:32:27.603412', NULL, true);
INSERT INTO public.messages (mess_uuid, mess_conv_uuid, mess_sender, mess_message, mess_date, mess_file, mess_read) VALUES ('a888f92e-b59c-4473-a732-3e8edc7b21fc', '3a30992d-9aae-415d-b6cd-82a129147bde', 'e4769679-df90-49f0-8921-817db992e182', 'add', '2021-12-31 03:45:20.002435', NULL, true);
INSERT INTO public.messages (mess_uuid, mess_conv_uuid, mess_sender, mess_message, mess_date, mess_file, mess_read) VALUES ('35f6b3d7-3d21-443f-9d37-d646c37885dc', '3a30992d-9aae-415d-b6cd-82a129147bde', 'e4769679-df90-49f0-8921-817db992e182', 'a', '2021-12-31 03:39:43.488093', NULL, true);
INSERT INTO public.messages (mess_uuid, mess_conv_uuid, mess_sender, mess_message, mess_date, mess_file, mess_read) VALUES ('25ab11c4-17d6-4d48-83ac-fe9be91c733b', '3a30992d-9aae-415d-b6cd-82a129147bde', 'e4769679-df90-49f0-8921-817db992e182', 'sdf', '2021-12-31 03:45:32.503091', NULL, true);
INSERT INTO public.messages (mess_uuid, mess_conv_uuid, mess_sender, mess_message, mess_date, mess_file, mess_read) VALUES ('a00ce691-ed5a-4426-8596-dadb9c008a3a', '3a30992d-9aae-415d-b6cd-82a129147bde', 'e4769679-df90-49f0-8921-817db992e182', 'sdf', '2021-12-31 03:45:33.109613', NULL, true);


--
-- TOC entry 3527 (class 0 OID 16917)
-- Dependencies: 219
-- Data for Name: my_doctor; Type: TABLE DATA; Schema: public; Owner: postgres
--

INSERT INTO public.my_doctor (mydo_uuid, mydo_owner, mydo_user_uuid) VALUES ('7b95803b-e03c-459e-a8fc-472abb5ea739', 'ebb602d1-35ef-45a1-b9f2-18576c2b3ad5', 'c4aacec4-dd1f-4ded-b76e-8d3897afe6b5');
INSERT INTO public.my_doctor (mydo_uuid, mydo_owner, mydo_user_uuid) VALUES ('9d362e6f-0e27-4f4e-8ba8-699eac4ea038', 'ebb602d1-35ef-45a1-b9f2-18576c2b3ad5', 'cc244d90-46dc-42f9-9458-016d10852165');
INSERT INTO public.my_doctor (mydo_uuid, mydo_owner, mydo_user_uuid) VALUES ('e44be8b8-a932-4029-b4f5-0e6cf4c056bb', 'ebb602d1-35ef-45a1-b9f2-18576c2b3ad5', '37da8033-d907-411a-8b29-c70a3cf1fad4');
INSERT INTO public.my_doctor (mydo_uuid, mydo_owner, mydo_user_uuid) VALUES ('d08c6e9b-03cc-4b44-8ec3-28bec76a81b2', 'dff20fc6-9d71-436e-81fc-70707b2ad39c', 'c4aacec4-dd1f-4ded-b76e-8d3897afe6b5');
INSERT INTO public.my_doctor (mydo_uuid, mydo_owner, mydo_user_uuid) VALUES ('a7cea3ff-5bfa-48d2-808c-eef072993063', 'dff20fc6-9d71-436e-81fc-70707b2ad39c', '37da8033-d907-411a-8b29-c70a3cf1fad4');
INSERT INTO public.my_doctor (mydo_uuid, mydo_owner, mydo_user_uuid) VALUES ('f4cda7e5-d6b0-4e5c-8890-c2fdd7ee2759', 'e35a8a27-2d8b-4c74-955b-731c76a99b72', 'dff20fc6-9d71-436e-81fc-70707b2ad39c');
INSERT INTO public.my_doctor (mydo_uuid, mydo_owner, mydo_user_uuid) VALUES ('562af01d-1885-4571-a92d-6c202200b373', 'e35a8a27-2d8b-4c74-955b-731c76a99b72', 'cc244d90-46dc-42f9-9458-016d10852165');
INSERT INTO public.my_doctor (mydo_uuid, mydo_owner, mydo_user_uuid) VALUES ('0316559d-9c00-49aa-b316-55cf89b1c508', 'e35a8a27-2d8b-4c74-955b-731c76a99b72', 'c4aacec4-dd1f-4ded-b76e-8d3897afe6b5');
INSERT INTO public.my_doctor (mydo_uuid, mydo_owner, mydo_user_uuid) VALUES ('a28e375d-0547-4c16-8752-1fbc3d3b7eb8', 'e35a8a27-2d8b-4c74-955b-731c76a99b72', '5f4c2888-0c8c-47d2-a935-fb1cf8e28be1');
INSERT INTO public.my_doctor (mydo_uuid, mydo_owner, mydo_user_uuid) VALUES ('dfee484b-ab53-453f-93e5-4b6aa4d3db7e', 'e35a8a27-2d8b-4c74-955b-731c76a99b72', '37da8033-d907-411a-8b29-c70a3cf1fad4');
INSERT INTO public.my_doctor (mydo_uuid, mydo_owner, mydo_user_uuid) VALUES ('2779e4b9-14e2-4e76-bf9d-5047054e51d1', '5f4c2888-0c8c-47d2-a935-fb1cf8e28be1', 'dff20fc6-9d71-436e-81fc-70707b2ad39c');
INSERT INTO public.my_doctor (mydo_uuid, mydo_owner, mydo_user_uuid) VALUES ('6fa21e72-fcd2-43ab-beae-fc57829883ac', 'dff20fc6-9d71-436e-81fc-70707b2ad39c', '5f4c2888-0c8c-47d2-a935-fb1cf8e28be1');
INSERT INTO public.my_doctor (mydo_uuid, mydo_owner, mydo_user_uuid) VALUES ('c9e3e520-be4d-4670-8d4e-eac1c7fd6fa1', 'dff20fc6-9d71-436e-81fc-70707b2ad39c', 'dff20fc6-9d71-436e-81fc-70707b2ad39c');
INSERT INTO public.my_doctor (mydo_uuid, mydo_owner, mydo_user_uuid) VALUES ('876c9930-4979-4437-b0ea-d03cb077b280', 'e4769679-df90-49f0-8921-817db992e182', 'dff20fc6-9d71-436e-81fc-70707b2ad39c');
INSERT INTO public.my_doctor (mydo_uuid, mydo_owner, mydo_user_uuid) VALUES ('b0dbf4e3-99fd-44b4-80e3-a208b29fbe2b', 'ebb602d1-35ef-45a1-b9f2-18576c2b3ad5', 'dff20fc6-9d71-436e-81fc-70707b2ad39c');


--
-- TOC entry 3528 (class 0 OID 16920)
-- Dependencies: 220
-- Data for Name: my_professionals; Type: TABLE DATA; Schema: public; Owner: postgres
--

INSERT INTO public.my_professionals (mypr_id, mypr_uuid, mypr_proffesional, mypr_allowed, mypr_date) VALUES (22, 'e35a8a27-2d8b-4c74-955b-731c76a99b72', 'dff20fc6-9d71-436e-81fc-70707b2ad39c', false, '2021-12-22 03:03:38.029102');
INSERT INTO public.my_professionals (mypr_id, mypr_uuid, mypr_proffesional, mypr_allowed, mypr_date) VALUES (23, 'e35a8a27-2d8b-4c74-955b-731c76a99b72', '37da8033-d907-411a-8b29-c70a3cf1fad4', false, '2021-12-22 03:05:43.703285');
INSERT INTO public.my_professionals (mypr_id, mypr_uuid, mypr_proffesional, mypr_allowed, mypr_date) VALUES (24, 'e35a8a27-2d8b-4c74-955b-731c76a99b72', 'cc244d90-46dc-42f9-9458-016d10852165', false, '2021-12-22 03:06:21.074408');
INSERT INTO public.my_professionals (mypr_id, mypr_uuid, mypr_proffesional, mypr_allowed, mypr_date) VALUES (25, 'e35a8a27-2d8b-4c74-955b-731c76a99b72', 'c4aacec4-dd1f-4ded-b76e-8d3897afe6b5', false, '2021-12-22 03:06:29.399374');
INSERT INTO public.my_professionals (mypr_id, mypr_uuid, mypr_proffesional, mypr_allowed, mypr_date) VALUES (26, '5f4c2888-0c8c-47d2-a935-fb1cf8e28be1', 'dff20fc6-9d71-436e-81fc-70707b2ad39c', true, '2021-12-27 12:55:26.427537');
INSERT INTO public.my_professionals (mypr_id, mypr_uuid, mypr_proffesional, mypr_allowed, mypr_date) VALUES (27, 'dff20fc6-9d71-436e-81fc-70707b2ad39c', '5f4c2888-0c8c-47d2-a935-fb1cf8e28be1', false, '2021-12-28 12:02:46.274409');
INSERT INTO public.my_professionals (mypr_id, mypr_uuid, mypr_proffesional, mypr_allowed, mypr_date) VALUES (30, 'e4769679-df90-49f0-8921-817db992e182', 'dff20fc6-9d71-436e-81fc-70707b2ad39c', true, '2021-12-30 16:50:12.722748');
INSERT INTO public.my_professionals (mypr_id, mypr_uuid, mypr_proffesional, mypr_allowed, mypr_date) VALUES (31, 'e4769679-df90-49f0-8921-817db992e182', '37da8033-d907-411a-8b29-c70a3cf1fad4', false, '2021-12-31 04:05:45.263855');
INSERT INTO public.my_professionals (mypr_id, mypr_uuid, mypr_proffesional, mypr_allowed, mypr_date) VALUES (32, '6524e8f2-ac32-4512-873d-8e0bb667be80', 'dff20fc6-9d71-436e-81fc-70707b2ad39c', false, '2022-01-02 11:29:15.399261');
INSERT INTO public.my_professionals (mypr_id, mypr_uuid, mypr_proffesional, mypr_allowed, mypr_date) VALUES (33, 'c71f7e00-8408-4cb8-98dc-ad9a27a76c14', 'dff20fc6-9d71-436e-81fc-70707b2ad39c', true, '2022-01-03 16:33:28.586668');
INSERT INTO public.my_professionals (mypr_id, mypr_uuid, mypr_proffesional, mypr_allowed, mypr_date) VALUES (34, 'ebb602d1-35ef-45a1-b9f2-18576c2b3ad5', 'dff20fc6-9d71-436e-81fc-70707b2ad39c', true, '2022-01-04 19:04:17.833658');
INSERT INTO public.my_professionals (mypr_id, mypr_uuid, mypr_proffesional, mypr_allowed, mypr_date) VALUES (28, 'dff20fc6-9d71-436e-81fc-70707b2ad39c', 'dff20fc6-9d71-436e-81fc-70707b2ad39c', true, '2021-12-28 12:09:26.633534');


--
-- TOC entry 3530 (class 0 OID 16926)
-- Dependencies: 222
-- Data for Name: notification; Type: TABLE DATA; Schema: public; Owner: postgres
--



--
-- TOC entry 3531 (class 0 OID 16930)
-- Dependencies: 223
-- Data for Name: notification_type; Type: TABLE DATA; Schema: public; Owner: postgres
--



--
-- TOC entry 3533 (class 0 OID 16936)
-- Dependencies: 225
-- Data for Name: page; Type: TABLE DATA; Schema: public; Owner: postgres
--

INSERT INTO public.page (page_uuid, page_title, page_slug, page_keywords, page_content, "page_createdAt", page_updated_at) VALUES ('79a0dd09-4750-4c00-937c-0d7353f5766a', 'Test', 'test-page-slug', 'keyword, slug, name, its', '<p>asdfasfasfdgasdf</p><p><strong><em>This is great!</em></strong></p>', '2021-12-09 17:06:05.034619', '2021-12-10 01:08:02.379');


--
-- TOC entry 3534 (class 0 OID 16943)
-- Dependencies: 226
-- Data for Name: previous_conversation; Type: TABLE DATA; Schema: public; Owner: postgres
--

INSERT INTO public.previous_conversation (prco_uuid, prco_user_a, prco_user_b, prco_pdf, prco_date) VALUES ('d830a7d0-5d5a-4fdf-b092-fad87e19cada', 'dff20fc6-9d71-436e-81fc-70707b2ad39c', 'a52f116c-edc3-453f-b306-a69d0698f061', 'chat20211201022151.pdf', '2021-12-01 00:22:31.480731');
INSERT INTO public.previous_conversation (prco_uuid, prco_user_a, prco_user_b, prco_pdf, prco_date) VALUES ('40071784-a3f1-4615-a3a9-3a8a7fb28f7e', 'dff20fc6-9d71-436e-81fc-70707b2ad39c', 'a52f116c-edc3-453f-b306-a69d0698f061', 'chat20211201022417.pdf', '2021-12-01 00:24:17.808742');
INSERT INTO public.previous_conversation (prco_uuid, prco_user_a, prco_user_b, prco_pdf, prco_date) VALUES ('07d1f1b7-c399-4145-8f5a-414f36ec0475', 'dff20fc6-9d71-436e-81fc-70707b2ad39c', 'a52f116c-edc3-453f-b306-a69d0698f061', 'chat20211201022632.pdf', '2021-12-01 00:26:32.334607');
INSERT INTO public.previous_conversation (prco_uuid, prco_user_a, prco_user_b, prco_pdf, prco_date) VALUES ('0551671b-aff4-4793-9faa-63aeff6752a9', 'dff20fc6-9d71-436e-81fc-70707b2ad39c', 'ebb602d1-35ef-45a1-b9f2-18576c2b3ad5', 'chat20211216221549.pdf', '2021-12-16 22:15:49.984741');
INSERT INTO public.previous_conversation (prco_uuid, prco_user_a, prco_user_b, prco_pdf, prco_date) VALUES ('bf0d37bc-d335-48fd-b989-601a2e1aa397', 'dff20fc6-9d71-436e-81fc-70707b2ad39c', 'ebb602d1-35ef-45a1-b9f2-18576c2b3ad5', 'chat20211216221851.pdf', '2021-12-16 22:18:51.854537');
INSERT INTO public.previous_conversation (prco_uuid, prco_user_a, prco_user_b, prco_pdf, prco_date) VALUES ('82da848f-c53f-41ce-ba43-e5b21c4245e2', 'dff20fc6-9d71-436e-81fc-70707b2ad39c', 'e4769679-df90-49f0-8921-817db992e182', 'chat20211230133425.pdf', '2021-12-30 13:34:25.934533');


--
-- TOC entry 3535 (class 0 OID 16947)
-- Dependencies: 227
-- Data for Name: privacy_policy; Type: TABLE DATA; Schema: public; Owner: postgres
--

INSERT INTO public.privacy_policy (prpo_id, prpo_text) VALUES (2, '<h1>Privacy policy</h1><p><br></p><p>This is the privacy policy.</p><p><br></p><p>asfasdf</p>');


--
-- TOC entry 3537 (class 0 OID 16953)
-- Dependencies: 229
-- Data for Name: professional; Type: TABLE DATA; Schema: public; Owner: postgres
--

INSERT INTO public.professional (profe_uuid, profe_cate_id, profe_user_uuid, profe_is_active, profe_created_at, profe_update_at, profe_npi, profe_pin, profe_specialty, profe_practice_name, profe_medical_license, profe_license_state, profe_credentials, profe_email_sent, profe_pin_set, profe_spec_id) VALUES ('2aafcaba-6418-41b4-a2ac-3a4bf3b9739e', 1, '6b72a04a-7f20-48d0-b74c-4e8ea539b6d3', false, '2021-12-06 16:39:29.708022', '2021-12-06 16:39:29.708022', '3423423423', NULL, NULL, NULL, NULL, NULL, NULL, false, false, NULL);
INSERT INTO public.professional (profe_uuid, profe_cate_id, profe_user_uuid, profe_is_active, profe_created_at, profe_update_at, profe_npi, profe_pin, profe_specialty, profe_practice_name, profe_medical_license, profe_license_state, profe_credentials, profe_email_sent, profe_pin_set, profe_spec_id) VALUES ('0c8ce357-f019-4b04-b702-ab21b7c9bf66', 1, '20a3f8ca-2850-46c1-b97a-4817c9c9a085', false, '2021-12-06 17:00:36.831757', '2021-12-06 17:00:36.831757', '5645646545', NULL, NULL, NULL, NULL, NULL, NULL, false, false, NULL);
INSERT INTO public.professional (profe_uuid, profe_cate_id, profe_user_uuid, profe_is_active, profe_created_at, profe_update_at, profe_npi, profe_pin, profe_specialty, profe_practice_name, profe_medical_license, profe_license_state, profe_credentials, profe_email_sent, profe_pin_set, profe_spec_id) VALUES ('3f3868c7-b351-46f5-a334-98b7e7088fe5', 2, 'ace5e503-3d20-4ae9-95d3-879cb9890eaf', false, '2021-12-07 17:14:05.33374', '2021-12-07 17:14:05.33374', '6656654654', NULL, NULL, NULL, NULL, NULL, NULL, false, false, NULL);
INSERT INTO public.professional (profe_uuid, profe_cate_id, profe_user_uuid, profe_is_active, profe_created_at, profe_update_at, profe_npi, profe_pin, profe_specialty, profe_practice_name, profe_medical_license, profe_license_state, profe_credentials, profe_email_sent, profe_pin_set, profe_spec_id) VALUES ('44283f06-5d52-482b-9d70-2b958becbf9b', 2, 'cc244d90-46dc-42f9-9458-016d10852165', true, '2021-12-08 12:09:11.76869', '2021-12-08 12:09:11.76869', '3423423423', '123456', 'Neurology', 'Practice name', '43ZA00283800', 'AL', 'sdafasdf', true, true, NULL);
INSERT INTO public.professional (profe_uuid, profe_cate_id, profe_user_uuid, profe_is_active, profe_created_at, profe_update_at, profe_npi, profe_pin, profe_specialty, profe_practice_name, profe_medical_license, profe_license_state, profe_credentials, profe_email_sent, profe_pin_set, profe_spec_id) VALUES ('0fa90159-c330-477a-9879-59bc821d4a3b', 1, 'c4aacec4-dd1f-4ded-b76e-8d3897afe6b5', true, '2021-12-08 19:17:30.288898', '2021-12-08 19:17:30.288898', '4243423423', '123456', 'Neurology', 'Practice name', '43ZA00283800', 'JA', 'MMBB', true, true, NULL);
INSERT INTO public.professional (profe_uuid, profe_cate_id, profe_user_uuid, profe_is_active, profe_created_at, profe_update_at, profe_npi, profe_pin, profe_specialty, profe_practice_name, profe_medical_license, profe_license_state, profe_credentials, profe_email_sent, profe_pin_set, profe_spec_id) VALUES ('2fce4098-70cb-43f5-89d7-6ac5cbd44bb8', 1, '37da8033-d907-411a-8b29-c70a3cf1fad4', true, '2021-12-03 18:45:40.433403', '2021-12-03 18:45:40.433403', '2342342342', '123456', 'dasfasdfasdf', 'test', 'test', 'test', 'test', true, true, NULL);
INSERT INTO public.professional (profe_uuid, profe_cate_id, profe_user_uuid, profe_is_active, profe_created_at, profe_update_at, profe_npi, profe_pin, profe_specialty, profe_practice_name, profe_medical_license, profe_license_state, profe_credentials, profe_email_sent, profe_pin_set, profe_spec_id) VALUES ('21e455ee-acfa-42d9-b3e0-7faa8f7dae1a', 2, '9ec04bf2-922e-4a53-980b-2b79a8b32448', true, '2021-12-10 15:13:09.383047', '2021-12-10 15:13:09.383047', '3423423423', '584244', '', 'sadfsadfdasfdsa', 'sdaf324234', 'State', '324324234', true, false, NULL);
INSERT INTO public.professional (profe_uuid, profe_cate_id, profe_user_uuid, profe_is_active, profe_created_at, profe_update_at, profe_npi, profe_pin, profe_specialty, profe_practice_name, profe_medical_license, profe_license_state, profe_credentials, profe_email_sent, profe_pin_set, profe_spec_id) VALUES ('187fdd5f-9ce0-4f05-868a-31af76c089f8', 2, 'ebb602d1-35ef-45a1-b9f2-18576c2b3ad5', true, '2021-12-14 11:40:56.736478', '2021-12-14 11:40:56.736478', '3453453454', '542298', 'Specialty', 'Practice name', 'Medical Lic', 'California', 'MD', true, false, NULL);
INSERT INTO public.professional (profe_uuid, profe_cate_id, profe_user_uuid, profe_is_active, profe_created_at, profe_update_at, profe_npi, profe_pin, profe_specialty, profe_practice_name, profe_medical_license, profe_license_state, profe_credentials, profe_email_sent, profe_pin_set, profe_spec_id) VALUES ('e7e8d9ea-0884-4275-896b-265f1daa0dec', 1, '5f4c2888-0c8c-47d2-a935-fb1cf8e28be1', true, '2021-12-22 03:33:47.121536', '2021-12-22 03:33:47.121536', '3453453454', '123456', 'Chester', 'Chetos', '903248209484', 'Envi', 'MBBS', true, true, NULL);
INSERT INTO public.professional (profe_uuid, profe_cate_id, profe_user_uuid, profe_is_active, profe_created_at, profe_update_at, profe_npi, profe_pin, profe_specialty, profe_practice_name, profe_medical_license, profe_license_state, profe_credentials, profe_email_sent, profe_pin_set, profe_spec_id) VALUES ('9c216621-b5a5-4ae9-8a39-7265b37ec7e0', 1, 'dff20fc6-9d71-436e-81fc-70707b2ad39c', true, '2021-12-05 05:51:10.549681', '2021-12-05 05:51:10.549681', '5646545656', '123456', '10', 'Practice name', '43ZA00283800', 'AL', 'M.B.B.S', true, true, 12);


--
-- TOC entry 3538 (class 0 OID 16961)
-- Dependencies: 230
-- Data for Name: refresh_token; Type: TABLE DATA; Schema: public; Owner: postgres
--

INSERT INTO public.refresh_token (reto_uuid, reto_user_uuid, reto_refresh_token, reto_created_at, reto_ip_address) VALUES ('d5a3f01c-bf49-4e3b-951e-ed79f88fcd87', 'ebb602d1-35ef-45a1-b9f2-18576c2b3ad5', 'd0442d3d-a0ca-44e0-83a6-7b9a16093cf9', '2022-01-04 19:38:02.892816', '::1');
INSERT INTO public.refresh_token (reto_uuid, reto_user_uuid, reto_refresh_token, reto_created_at, reto_ip_address) VALUES ('534984da-462c-4c04-9105-5394374afedb', 'e4769679-df90-49f0-8921-817db992e182', '9b2462e5-7694-4ec8-800a-91ac8559c9a6', '2021-12-30 21:25:46.124489', '::1');
INSERT INTO public.refresh_token (reto_uuid, reto_user_uuid, reto_refresh_token, reto_created_at, reto_ip_address) VALUES ('19f67870-6ad8-45c0-9ffd-d114f790f80a', '9bf0a119-6d85-4654-8768-db1f9144df98', 'f476412f-e72e-4839-84ac-9fae927541d2', '2021-12-28 14:13:29.568384', '::1');
INSERT INTO public.refresh_token (reto_uuid, reto_user_uuid, reto_refresh_token, reto_created_at, reto_ip_address) VALUES ('af50fa57-e20e-44d3-8d5b-ae0143bd65ec', '9bf0a119-6d85-4654-8768-db1f9144df98', '1b73351e-f1dd-482d-b7df-e58a32d8f9f0', '2022-01-05 17:47:24.297519', '::ffff:127.0.0.1');
INSERT INTO public.refresh_token (reto_uuid, reto_user_uuid, reto_refresh_token, reto_created_at, reto_ip_address) VALUES ('7722bb25-db6c-4c25-8146-117c8d7cff57', 'dff20fc6-9d71-436e-81fc-70707b2ad39c', '35eb20ee-725f-450c-881c-185a3cf88787', '2021-12-28 00:19:30.611234', '::1');
INSERT INTO public.refresh_token (reto_uuid, reto_user_uuid, reto_refresh_token, reto_created_at, reto_ip_address) VALUES ('d9d50bac-92e3-4a6c-be11-ce096b39a8a6', '6524e8f2-ac32-4512-873d-8e0bb667be80', 'be3aaa30-cc65-4c49-8444-9ace9d20c9da', '2022-01-02 12:11:14.560308', '::1');
INSERT INTO public.refresh_token (reto_uuid, reto_user_uuid, reto_refresh_token, reto_created_at, reto_ip_address) VALUES ('508206cb-6b96-431e-9fe2-307e487ad655', 'e4769679-df90-49f0-8921-817db992e182', 'a9ed615d-7229-4fd8-890d-28a7d93a203b', '2021-12-31 04:04:19.55219', '::1');
INSERT INTO public.refresh_token (reto_uuid, reto_user_uuid, reto_refresh_token, reto_created_at, reto_ip_address) VALUES ('5f0e7fda-10e0-463b-b2b3-bbf47dfa9b9d', 'dff20fc6-9d71-436e-81fc-70707b2ad39c', '669dca9b-c5bc-4874-a295-e4168281926c', '2021-12-30 21:35:23.322138', '::ffff:127.0.0.1');
INSERT INTO public.refresh_token (reto_uuid, reto_user_uuid, reto_refresh_token, reto_created_at, reto_ip_address) VALUES ('8da02710-209c-45c5-a7da-401556537dea', 'e4769679-df90-49f0-8921-817db992e182', 'd519c183-0009-4596-8da7-1d8780e67d10', '2021-12-30 21:35:32.980302', '::1');
INSERT INTO public.refresh_token (reto_uuid, reto_user_uuid, reto_refresh_token, reto_created_at, reto_ip_address) VALUES ('e725b72c-07af-4276-8da0-0f94cf7e41de', 'dff20fc6-9d71-436e-81fc-70707b2ad39c', '1106c161-6bd9-4309-b2a0-4034f1de965f', '2021-12-28 12:42:24.054812', '::1');
INSERT INTO public.refresh_token (reto_uuid, reto_user_uuid, reto_refresh_token, reto_created_at, reto_ip_address) VALUES ('82e9b14d-07e9-4ccc-8f1c-bf271568f8d1', 'dff20fc6-9d71-436e-81fc-70707b2ad39c', '9081de91-23bc-4a78-aaee-ca5403e18d11', '2021-12-28 14:18:49.270929', '::1');
INSERT INTO public.refresh_token (reto_uuid, reto_user_uuid, reto_refresh_token, reto_created_at, reto_ip_address) VALUES ('326e587f-ca11-4b5f-ad4e-dce1944d9a7c', '5f4c2888-0c8c-47d2-a935-fb1cf8e28be1', 'be6101fb-9085-4826-97d4-cc35cce6d3af', '2021-12-27 15:08:20.242062', '::1');
INSERT INTO public.refresh_token (reto_uuid, reto_user_uuid, reto_refresh_token, reto_created_at, reto_ip_address) VALUES ('3e1d7e4f-bcd0-4b28-89c3-9b065efd4035', 'e4769679-df90-49f0-8921-817db992e182', '7017dc9d-f8e1-4e84-ad68-416deb4f2273', '2021-12-31 02:49:36.449841', '::1');
INSERT INTO public.refresh_token (reto_uuid, reto_user_uuid, reto_refresh_token, reto_created_at, reto_ip_address) VALUES ('b6e89a52-ed49-4765-b316-db96f1c1ec0b', 'ebb602d1-35ef-45a1-b9f2-18576c2b3ad5', 'c021af6b-8d17-4b0a-9c53-12f47329ae87', '2022-01-05 17:06:29.845774', '::1');
INSERT INTO public.refresh_token (reto_uuid, reto_user_uuid, reto_refresh_token, reto_created_at, reto_ip_address) VALUES ('c0eca26d-4e08-4614-abea-8c390f1d213d', 'e4769679-df90-49f0-8921-817db992e182', 'caf7d252-0986-4b15-965c-298349638ba8', '2021-12-30 22:42:43.507227', '::1');
INSERT INTO public.refresh_token (reto_uuid, reto_user_uuid, reto_refresh_token, reto_created_at, reto_ip_address) VALUES ('58645ecb-1d9c-4afd-a8a6-ddde30184882', 'c71f7e00-8408-4cb8-98dc-ad9a27a76c14', '7269f34b-b228-4e7d-9c8f-5f2d054ae7fd', '2022-01-03 21:15:12.563198', '::1');
INSERT INTO public.refresh_token (reto_uuid, reto_user_uuid, reto_refresh_token, reto_created_at, reto_ip_address) VALUES ('f0133d78-69f6-4ae1-a7cf-35704873e3a4', 'c71f7e00-8408-4cb8-98dc-ad9a27a76c14', '8ca744e4-5086-428f-b4e5-152739a783d8', '2022-01-03 22:38:40.379211', '::1');
INSERT INTO public.refresh_token (reto_uuid, reto_user_uuid, reto_refresh_token, reto_created_at, reto_ip_address) VALUES ('d0676f28-1269-4152-8f54-7a1a9f78dbe6', 'e4769679-df90-49f0-8921-817db992e182', 'f6dc5052-330d-4dbf-ac46-ec0487813961', '2021-12-30 13:39:12.095882', '::1');
INSERT INTO public.refresh_token (reto_uuid, reto_user_uuid, reto_refresh_token, reto_created_at, reto_ip_address) VALUES ('d4bce169-06bd-4115-b988-4d2b31fcf684', 'c71f7e00-8408-4cb8-98dc-ad9a27a76c14', 'fdb57776-5b5d-4bf1-975c-16aa40375ebe', '2022-01-04 11:33:15.478918', '::1');
INSERT INTO public.refresh_token (reto_uuid, reto_user_uuid, reto_refresh_token, reto_created_at, reto_ip_address) VALUES ('1b2ee204-1854-4c8b-b0be-69aef91021f8', 'c71f7e00-8408-4cb8-98dc-ad9a27a76c14', 'bdadb381-1fc1-4ed1-8e8f-3ea44c9853f7', '2022-01-04 11:33:27.622584', '::1');
INSERT INTO public.refresh_token (reto_uuid, reto_user_uuid, reto_refresh_token, reto_created_at, reto_ip_address) VALUES ('b2a50936-41e2-4365-bd68-66c4a3ce4eb4', 'ebb602d1-35ef-45a1-b9f2-18576c2b3ad5', 'd0e5b17f-2ab8-473c-aa4f-4f8cfa0ac585', '2022-01-15 04:57:47.871382', '::1');
INSERT INTO public.refresh_token (reto_uuid, reto_user_uuid, reto_refresh_token, reto_created_at, reto_ip_address) VALUES ('054beaba-63b0-45e5-9d4a-bca5c1c85517', 'ebb602d1-35ef-45a1-b9f2-18576c2b3ad5', 'a3ea51ad-380b-4df7-827a-173354ed65db', '2022-01-14 21:36:19.989983', '::1');
INSERT INTO public.refresh_token (reto_uuid, reto_user_uuid, reto_refresh_token, reto_created_at, reto_ip_address) VALUES ('ffac34d7-bcea-43c2-a4d2-cdfe996931f2', '82d4540d-89e8-45bd-9860-bbfbfd0be635', '031ec414-74e6-4745-9b63-39824ba1fd5e', '2022-01-06 22:51:08.296222', '::1');


--
-- TOC entry 3539 (class 0 OID 16965)
-- Dependencies: 231
-- Data for Name: specialty; Type: TABLE DATA; Schema: public; Owner: postgres
--

INSERT INTO public.specialty (spec_id, spec_cate_id, spec_specialty) VALUES (8, 2, 'Specialt!');
INSERT INTO public.specialty (spec_id, spec_cate_id, spec_specialty) VALUES (9, 3, 'This is the specialty name');
INSERT INTO public.specialty (spec_id, spec_cate_id, spec_specialty) VALUES (10, 1, 'sub neuro');
INSERT INTO public.specialty (spec_id, spec_cate_id, spec_specialty) VALUES (11, 2, 'Just a test');
INSERT INTO public.specialty (spec_id, spec_cate_id, spec_specialty) VALUES (12, 1, 'random data');
INSERT INTO public.specialty (spec_id, spec_cate_id, spec_specialty) VALUES (13, 3, 'ING');


--
-- TOC entry 3541 (class 0 OID 16969)
-- Dependencies: 233
-- Data for Name: terms_conditions; Type: TABLE DATA; Schema: public; Owner: postgres
--

INSERT INTO public.terms_conditions (teco_id, teco_text) VALUES (2, '<h1>Terms and conditions.</h1><p><br></p><p>This is the terms and conditions that were written from the text editor.</p><p>This is using the new editor.</p>');


--
-- TOC entry 3543 (class 0 OID 16975)
-- Dependencies: 235
-- Data for Name: user; Type: TABLE DATA; Schema: public; Owner: postgres
--

INSERT INTO public."user" (user_uuid, user_email, user_first_name, user_last_name, user_date_of_birth, user_password, user_usro_id, user_email_verified, user_deleted, user_blocked, user_mrn, user_owner, user_country_code, user_phone_no, user_picture) VALUES ('cc244d90-46dc-42f9-9458-016d10852165', 'text@gmail.com', 'Text', 'text', '1990-10-10', '$2a$10$Cwd3Nun0JiurmROdhmfdXuvtOv/5RxPbFDqVDkSSW/mN4LclhneLO', 4, true, false, false, 9, NULL, NULL, NULL, 'bb41ada0-f032-4a5d-ab27-02ac1f123da8.jpg');
INSERT INTO public."user" (user_uuid, user_email, user_first_name, user_last_name, user_date_of_birth, user_password, user_usro_id, user_email_verified, user_deleted, user_blocked, user_mrn, user_owner, user_country_code, user_phone_no, user_picture) VALUES ('c4aacec4-dd1f-4ded-b76e-8d3897afe6b5', 'testx@gmail.com', 'Tom', 'Jason', '1990-10-10', '$2a$10$IxEWbk5kS6zYyZDjyrYOxOWHv5EiLcwuzrMrDt2saJEOBDftNM4lC', 4, true, false, false, 10, '9bf0a119-6d85-4654-8768-db1f9144df98', NULL, NULL, '');
INSERT INTO public."user" (user_uuid, user_email, user_first_name, user_last_name, user_date_of_birth, user_password, user_usro_id, user_email_verified, user_deleted, user_blocked, user_mrn, user_owner, user_country_code, user_phone_no, user_picture) VALUES ('6b72a04a-7f20-48d0-b74c-4e8ea539b6d3', 'not@gmail.com', 'Matt', 'Smith', '1990-10-10', '$2a$10$qf5IzcopbLbRPgwQzBi1jexoL7Y6iFjcqHuCCmIqe5FCdFs1tJLHq', 3, true, false, false, 6, NULL, NULL, NULL, NULL);
INSERT INTO public."user" (user_uuid, user_email, user_first_name, user_last_name, user_date_of_birth, user_password, user_usro_id, user_email_verified, user_deleted, user_blocked, user_mrn, user_owner, user_country_code, user_phone_no, user_picture) VALUES ('20a3f8ca-2850-46c1-b97a-4817c9c9a085', 't@gmail.com', 'John', 'Wick', '1990-10-10', '$2a$10$jw4XX48zC0w5Z1SWRAWAke8gSfjlzMh4ptMHHeotpHZXoSs/q8XVK', 3, true, false, false, 7, NULL, NULL, NULL, NULL);
INSERT INTO public."user" (user_uuid, user_email, user_first_name, user_last_name, user_date_of_birth, user_password, user_usro_id, user_email_verified, user_deleted, user_blocked, user_mrn, user_owner, user_country_code, user_phone_no, user_picture) VALUES ('ace5e503-3d20-4ae9-95d3-879cb9890eaf', 'j@gmail.com', 'Johan', 'Elite', '1990-10-10', '$2a$10$l/rDisblzJr.H.yFCkZtEu6otulRPYJQhior0ApMO83x0zJj6YGde', 3, true, false, false, 8, '6b72a04a-7f20-48d0-b74c-4e8ea539b6d3', NULL, NULL, NULL);
INSERT INTO public."user" (user_uuid, user_email, user_first_name, user_last_name, user_date_of_birth, user_password, user_usro_id, user_email_verified, user_deleted, user_blocked, user_mrn, user_owner, user_country_code, user_phone_no, user_picture) VALUES ('a52f116c-edc3-453f-b306-a69d0698f061', 'user2@gmail.com', 'John', 'Manson', '1989-05-10', '$2a$10$/hzmxqzEqf/A8MmHzL2xHOf8dF9jQZt1lrgHdOxHcyO0HRlhcd3Ia', 3, true, true, false, 4, 'dff20fc6-9d71-436e-81fc-70707b2ad39c', NULL, NULL, NULL);
INSERT INTO public."user" (user_uuid, user_email, user_first_name, user_last_name, user_date_of_birth, user_password, user_usro_id, user_email_verified, user_deleted, user_blocked, user_mrn, user_owner, user_country_code, user_phone_no, user_picture) VALUES ('37da8033-d907-411a-8b29-c70a3cf1fad4', 'new2@gmail.com', 'Manuel', 'López', '1990-10-10', '$2a$10$MKWu25aioBXguGfS1wR/X.UUTP/OAuNYHxUE68TVdZMf5lHj1OuL2', 4, true, false, false, 5, 'dff20fc6-9d71-436e-81fc-70707b2ad39c', '33', '2342342342', '5e397407-ccc5-4e82-9f74-4406b3218081.jpg');
INSERT INTO public."user" (user_uuid, user_email, user_first_name, user_last_name, user_date_of_birth, user_password, user_usro_id, user_email_verified, user_deleted, user_blocked, user_mrn, user_owner, user_country_code, user_phone_no, user_picture) VALUES ('3b251b39-2874-45ab-a765-14801849810d', 'heribertojuarezj@gmail.com', 'Joan', 'Elite', '1990-10-10', '$2a$10$zQlXSlVXKta3TvD3rQ7lU.2XVNWN2/qn/JRvq2aH22dqRnn92sX8G', 3, true, false, false, 12, NULL, NULL, NULL, NULL);
INSERT INTO public."user" (user_uuid, user_email, user_first_name, user_last_name, user_date_of_birth, user_password, user_usro_id, user_email_verified, user_deleted, user_blocked, user_mrn, user_owner, user_country_code, user_phone_no, user_picture) VALUES ('e4769679-df90-49f0-8921-817db992e182', 'test@example.com', 'Example', 'Test LN', '1990-10-10', '$2a$10$0OtjMfI1JK/zYQIx0.O9z.vlgkfaMKs0FV8jKn24V4YDQf5fwben2', 3, true, false, false, 18, NULL, '444', '3242342342', NULL);
INSERT INTO public."user" (user_uuid, user_email, user_first_name, user_last_name, user_date_of_birth, user_password, user_usro_id, user_email_verified, user_deleted, user_blocked, user_mrn, user_owner, user_country_code, user_phone_no, user_picture) VALUES ('6524e8f2-ac32-4512-873d-8e0bb667be80', 'dawih17492@xxyxi.com', 'Charles', 'Darkin', '1998-10-10', '$2a$10$CxgMErKkg01zCfa032RV1.1i.nlGkWkDvszO9RRzIOfxh7C8gp5fa', 3, true, false, false, 19, NULL, '', '5566778899', NULL);
INSERT INTO public."user" (user_uuid, user_email, user_first_name, user_last_name, user_date_of_birth, user_password, user_usro_id, user_email_verified, user_deleted, user_blocked, user_mrn, user_owner, user_country_code, user_phone_no, user_picture) VALUES ('849cba98-7b09-449e-91fa-17a895bf8fdc', 'froid@xxyxi.com', 'Smith', 'Vidal', NULL, '$2a$10$HtWMxnjQ4HF4M4atC5.1vOh.Yu5adr9myE8hMEwm7GNKmYXXS22ym', 3, false, false, false, 20, NULL, '334', '8923749823', NULL);
INSERT INTO public."user" (user_uuid, user_email, user_first_name, user_last_name, user_date_of_birth, user_password, user_usro_id, user_email_verified, user_deleted, user_blocked, user_mrn, user_owner, user_country_code, user_phone_no, user_picture) VALUES ('dff20fc6-9d71-436e-81fc-70707b2ad39c', 'professional@gmail.com', 'John', 'Doe', '1990-10-10', '$2a$10$MppkNbaCLLfGKV1YT.VwiuB8He/jmvTfG1RzG1mtNf.lnMHydLXHK', 4, true, false, false, 2, NULL, '52', '5583948564', 'badeb93a-d6a2-461e-ab24-e5b4ee9ef5f7.jpg');
INSERT INTO public."user" (user_uuid, user_email, user_first_name, user_last_name, user_date_of_birth, user_password, user_usro_id, user_email_verified, user_deleted, user_blocked, user_mrn, user_owner, user_country_code, user_phone_no, user_picture) VALUES ('2566fa27-6786-408c-974d-d99aea92fe5b', 'slobotzki@gmail.com', 'Hector', 'Slobotzki', '1990-10-10', '$2a$10$BzQBrbPNfXXZYL5.jBiFX.IvQqF3jglaDwSzdta5riDCMUPxu2Vzq', 3, true, false, false, 13, 'dff20fc6-9d71-436e-81fc-70707b2ad39c', NULL, NULL, NULL);
INSERT INTO public."user" (user_uuid, user_email, user_first_name, user_last_name, user_date_of_birth, user_password, user_usro_id, user_email_verified, user_deleted, user_blocked, user_mrn, user_owner, user_country_code, user_phone_no, user_picture) VALUES ('fed31f97-f53b-43de-96b2-1b9218b68aa8', 'COCONAUT@GMAIL.COM', 'Coco', 'Naut', '1990-10-10', '$2a$10$qBdxq0t3EO9H6TeVjJjc1.aqr92z32Ajx/QMQ/0T/YtTX6XKLZPki', 3, false, false, false, 14, '2566fa27-6786-408c-974d-d99aea92fe5b', NULL, NULL, NULL);
INSERT INTO public."user" (user_uuid, user_email, user_first_name, user_last_name, user_date_of_birth, user_password, user_usro_id, user_email_verified, user_deleted, user_blocked, user_mrn, user_owner, user_country_code, user_phone_no, user_picture) VALUES ('e35a8a27-2d8b-4c74-955b-731c76a99b72', 'espaniol@gmail.com', 'Espaniol', 'Gsj', '1990-10-10', '$2a$10$3/uVk1XPtoq0mFGgzNPhe.OHF2NRL5nPkt3an0weCn6kb7CL1C1TW', 3, true, false, false, 16, '5f4c2888-0c8c-47d2-a935-fb1cf8e28be1', NULL, NULL, NULL);
INSERT INTO public."user" (user_uuid, user_email, user_first_name, user_last_name, user_date_of_birth, user_password, user_usro_id, user_email_verified, user_deleted, user_blocked, user_mrn, user_owner, user_country_code, user_phone_no, user_picture) VALUES ('cec9640f-85e4-41df-8ab8-a104069d6b57', 'froid2@xxyxi.com', 'Smith', 'Vidal', NULL, '$2a$10$Embbvl7Xu.fwKVlR7VKZwOuF9l8QoOcxnEvqQAHYDVgXnc0/vFl9q', 3, false, false, false, 21, NULL, '334', '8923749823', NULL);
INSERT INTO public."user" (user_uuid, user_email, user_first_name, user_last_name, user_date_of_birth, user_password, user_usro_id, user_email_verified, user_deleted, user_blocked, user_mrn, user_owner, user_country_code, user_phone_no, user_picture) VALUES ('9ec04bf2-922e-4a53-980b-2b79a8b32448', 'heribertojuarezj2@gmail.com', 'Professional', 'Person', '1990-10-10', '$2a$10$h0uwZSxESubYg7MOWZ6mFOK.VlF99DiPPIjw2T9YJGc.hU7cGSFPG', 4, true, false, false, 11, NULL, NULL, NULL, NULL);
INSERT INTO public."user" (user_uuid, user_email, user_first_name, user_last_name, user_date_of_birth, user_password, user_usro_id, user_email_verified, user_deleted, user_blocked, user_mrn, user_owner, user_country_code, user_phone_no, user_picture) VALUES ('ebb602d1-35ef-45a1-b9f2-18576c2b3ad5', 'user@gmail.com', 'Samantha', 'Williams', '1990-10-10', '$2a$10$.yi7RuHQCyzHk80yDFzKvu4ceHR7vvVcC27X3GkcJNFQskPcAaiyS', 4, true, false, false, 3, 'dff20fc6-9d71-436e-81fc-70707b2ad39c', '524', '6622334445', '83001793-7c59-42dc-96a4-8a2d7aaa0123.jpg');
INSERT INTO public."user" (user_uuid, user_email, user_first_name, user_last_name, user_date_of_birth, user_password, user_usro_id, user_email_verified, user_deleted, user_blocked, user_mrn, user_owner, user_country_code, user_phone_no, user_picture) VALUES ('5f4c2888-0c8c-47d2-a935-fb1cf8e28be1', 'chetos@test.com', 'Chetos', 'Chester', '1990-10-10', '$2a$10$jZDVM5K1HEmdRaa0juzGeumoZBmDVQJrGRSEKpj0m/Bq7qm.b4fMK', 4, true, false, false, 15, 'fed31f97-f53b-43de-96b2-1b9218b68aa8', NULL, NULL, 'ceb2a9d6-dc35-430e-b019-8732022f25e5.jpeg');
INSERT INTO public."user" (user_uuid, user_email, user_first_name, user_last_name, user_date_of_birth, user_password, user_usro_id, user_email_verified, user_deleted, user_blocked, user_mrn, user_owner, user_country_code, user_phone_no, user_picture) VALUES ('be32b6bb-edfe-4913-84d2-2fc06f7386d1', 'test@bold.com', 'Johan', 'Elite', '1990-10-10', '$2a$10$P3kMBcqihf7zZ8aQE3LIXOHy2XKq2SeCI7.ncZ6AXyLjkxb0ovgay', 3, false, false, false, 17, NULL, NULL, NULL, NULL);
INSERT INTO public."user" (user_uuid, user_email, user_first_name, user_last_name, user_date_of_birth, user_password, user_usro_id, user_email_verified, user_deleted, user_blocked, user_mrn, user_owner, user_country_code, user_phone_no, user_picture) VALUES ('9bf0a119-6d85-4654-8768-db1f9144df98', 'thmstr01@gmail.com', 'Heriberto', 'Juarez', '1990-10-10', '$2a$10$GAODxDBOZyKYnFrl.WLvGOZyYZTAYlCIf/9cWGXM1hs30KPByklPS', 2, true, false, false, 1, NULL, '1', '1122334455', '6883e5d9-f79a-4ef8-82e3-2d5fa8bc8464.jpeg');
INSERT INTO public."user" (user_uuid, user_email, user_first_name, user_last_name, user_date_of_birth, user_password, user_usro_id, user_email_verified, user_deleted, user_blocked, user_mrn, user_owner, user_country_code, user_phone_no, user_picture) VALUES ('c71f7e00-8408-4cb8-98dc-ad9a27a76c14', 'froid24@xxyxi.com', 'Smith', 'Vidal', NULL, '$2a$10$xlrd2F4yN.Afs5ZprZPYpOkgAYnLMj06F/KtkgpfU3yqeGMcidJZ6', 3, true, false, false, 22, NULL, '334', '8923749823', NULL);
INSERT INTO public."user" (user_uuid, user_email, user_first_name, user_last_name, user_date_of_birth, user_password, user_usro_id, user_email_verified, user_deleted, user_blocked, user_mrn, user_owner, user_country_code, user_phone_no, user_picture) VALUES ('be749100-dfe7-4671-b9f6-e4cfc1e845a7', NULL, 'Guest', 'user', NULL, NULL, 3, false, false, false, 23, NULL, NULL, NULL, NULL);
INSERT INTO public."user" (user_uuid, user_email, user_first_name, user_last_name, user_date_of_birth, user_password, user_usro_id, user_email_verified, user_deleted, user_blocked, user_mrn, user_owner, user_country_code, user_phone_no, user_picture) VALUES ('51cb2983-627b-4098-9b38-90f2af742c72', 'admin@admin.com', 'tom', 'tom', NULL, '$2a$10$ZYk62Fk/JI3Fru59LiX.subwnPledtL1T2n61OAEanekoNNdVYI8S', 3, false, false, false, 24, NULL, '', '1919191919', NULL);
INSERT INTO public."user" (user_uuid, user_email, user_first_name, user_last_name, user_date_of_birth, user_password, user_usro_id, user_email_verified, user_deleted, user_blocked, user_mrn, user_owner, user_country_code, user_phone_no, user_picture) VALUES ('82d4540d-89e8-45bd-9860-bbfbfd0be635', 'venus9023gold@mail.ru', 'venus', 'venus', NULL, '$2a$10$kjJrpDZSCMebc1fIi.skt.Ac1aI0IVnyMlz5xgjgWMoTA3f0EManK', 3, false, false, false, 25, '51cb2983-627b-4098-9b38-90f2af742c72', '798', '1919191919', NULL);


--
-- TOC entry 3544 (class 0 OID 16981)
-- Dependencies: 236
-- Data for Name: user_role; Type: TABLE DATA; Schema: public; Owner: postgres
--

INSERT INTO public.user_role (usro_id, usro_role, usro_key) VALUES (1, 'Super Admin', 'SUPER');
INSERT INTO public.user_role (usro_id, usro_role, usro_key) VALUES (2, 'Admin', 'ADMIN');
INSERT INTO public.user_role (usro_id, usro_role, usro_key) VALUES (3, 'User', 'USER');
INSERT INTO public.user_role (usro_id, usro_role, usro_key) VALUES (4, 'Professional', 'MODERATOR');


--
-- TOC entry 3548 (class 0 OID 16987)
-- Dependencies: 240
-- Data for Name: verification_code; Type: TABLE DATA; Schema: public; Owner: postgres
--

INSERT INTO public.verification_code (veco_id, veco_code, veco_user_uuid, veco_reset_password, veco_type, veco_date) VALUES (25, '597250974', 'be32b6bb-edfe-4913-84d2-2fc06f7386d1', false, 'PASSWORD', '2021-12-22 00:00:00');
INSERT INTO public.verification_code (veco_id, veco_code, veco_user_uuid, veco_reset_password, veco_type, veco_date) VALUES (29, '692166803', '51cb2983-627b-4098-9b38-90f2af742c72', false, 'PASSWORD', '2022-01-06 00:00:00');
INSERT INTO public.verification_code (veco_id, veco_code, veco_user_uuid, veco_reset_password, veco_type, veco_date) VALUES (30, '293581088', '82d4540d-89e8-45bd-9860-bbfbfd0be635', false, 'PASSWORD', '2022-01-06 00:00:00');


--
-- TOC entry 3566 (class 0 OID 0)
-- Dependencies: 211
-- Name: category_cate_id_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public.category_cate_id_seq', 3, true);


--
-- TOC entry 3567 (class 0 OID 0)
-- Dependencies: 221
-- Name: my_professionals_mypr_id_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public.my_professionals_mypr_id_seq', 34, true);


--
-- TOC entry 3568 (class 0 OID 0)
-- Dependencies: 224
-- Name: notification_type_noty_id_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public.notification_type_noty_id_seq', 1, false);


--
-- TOC entry 3569 (class 0 OID 0)
-- Dependencies: 228
-- Name: privacy_policy_prpo_id_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public.privacy_policy_prpo_id_seq', 2, true);


--
-- TOC entry 3570 (class 0 OID 0)
-- Dependencies: 232
-- Name: specialty_spec_id_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public.specialty_spec_id_seq', 13, true);


--
-- TOC entry 3571 (class 0 OID 0)
-- Dependencies: 234
-- Name: terms_conditions_teco_id_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public.terms_conditions_teco_id_seq', 2, true);


--
-- TOC entry 3572 (class 0 OID 0)
-- Dependencies: 237
-- Name: user_role_usro_id_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public.user_role_usro_id_seq', 4, true);


--
-- TOC entry 3573 (class 0 OID 0)
-- Dependencies: 238
-- Name: user_user_mrn_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public.user_user_mrn_seq', 25, true);


--
-- TOC entry 3574 (class 0 OID 0)
-- Dependencies: 239
-- Name: user_user_usro_id_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public.user_user_usro_id_seq', 1, false);


--
-- TOC entry 3575 (class 0 OID 0)
-- Dependencies: 241
-- Name: verification_code_veco_id_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public.verification_code_veco_id_seq', 30, true);


--
-- TOC entry 3305 (class 2606 OID 17005)
-- Name: address address_pk; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.address
    ADD CONSTRAINT address_pk PRIMARY KEY (addr_uuid);


--
-- TOC entry 3308 (class 2606 OID 17007)
-- Name: category category_pk; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.category
    ADD CONSTRAINT category_pk PRIMARY KEY (cate_id);


--
-- TOC entry 3310 (class 2606 OID 17009)
-- Name: conversation conversation_pk; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.conversation
    ADD CONSTRAINT conversation_pk PRIMARY KEY (conv_uuid);


--
-- TOC entry 3313 (class 2606 OID 17011)
-- Name: file file_pk; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.file
    ADD CONSTRAINT file_pk PRIMARY KEY (file_uuid);


--
-- TOC entry 3315 (class 2606 OID 17013)
-- Name: medical_record medical_record_pk; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.medical_record
    ADD CONSTRAINT medical_record_pk PRIMARY KEY (mere_uuid);


--
-- TOC entry 3318 (class 2606 OID 17015)
-- Name: medical_record_user medical_record_user_pk; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.medical_record_user
    ADD CONSTRAINT medical_record_user_pk PRIMARY KEY (mrus_uuid);


--
-- TOC entry 3321 (class 2606 OID 17017)
-- Name: messages messages_pk; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.messages
    ADD CONSTRAINT messages_pk PRIMARY KEY (mess_uuid);


--
-- TOC entry 3324 (class 2606 OID 17019)
-- Name: my_doctor my_doctor_pk; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.my_doctor
    ADD CONSTRAINT my_doctor_pk PRIMARY KEY (mydo_uuid);


--
-- TOC entry 3329 (class 2606 OID 17021)
-- Name: notification_type notification_type_pk; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.notification_type
    ADD CONSTRAINT notification_type_pk PRIMARY KEY (noty_id);


--
-- TOC entry 3332 (class 2606 OID 17023)
-- Name: page page_pk; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.page
    ADD CONSTRAINT page_pk PRIMARY KEY (page_uuid);


--
-- TOC entry 3334 (class 2606 OID 17025)
-- Name: privacy_policy privacy_policy_pk; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.privacy_policy
    ADD CONSTRAINT privacy_policy_pk PRIMARY KEY (prpo_id);


--
-- TOC entry 3337 (class 2606 OID 17027)
-- Name: professional professional_pk; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.professional
    ADD CONSTRAINT professional_pk PRIMARY KEY (profe_uuid);


--
-- TOC entry 3340 (class 2606 OID 17029)
-- Name: refresh_token refresh_token_pk; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.refresh_token
    ADD CONSTRAINT refresh_token_pk PRIMARY KEY (reto_uuid);


--
-- TOC entry 3343 (class 2606 OID 17031)
-- Name: specialty specialty_pk; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.specialty
    ADD CONSTRAINT specialty_pk PRIMARY KEY (spec_id);


--
-- TOC entry 3346 (class 2606 OID 17033)
-- Name: terms_conditions terms_conditions_pk; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.terms_conditions
    ADD CONSTRAINT terms_conditions_pk PRIMARY KEY (teco_id);


--
-- TOC entry 3349 (class 2606 OID 17035)
-- Name: user user_pk; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public."user"
    ADD CONSTRAINT user_pk UNIQUE (user_uuid);


--
-- TOC entry 3353 (class 2606 OID 17037)
-- Name: user_role user_role_pk; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.user_role
    ADD CONSTRAINT user_role_pk PRIMARY KEY (usro_id);


--
-- TOC entry 3358 (class 2606 OID 17039)
-- Name: verification_code verification_code_pk; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.verification_code
    ADD CONSTRAINT verification_code_pk PRIMARY KEY (veco_id);


--
-- TOC entry 3303 (class 1259 OID 17040)
-- Name: address_addr_uuid_uindex; Type: INDEX; Schema: public; Owner: postgres
--

CREATE UNIQUE INDEX address_addr_uuid_uindex ON public.address USING btree (addr_uuid);


--
-- TOC entry 3306 (class 1259 OID 17041)
-- Name: category_cate_category_uindex; Type: INDEX; Schema: public; Owner: postgres
--

CREATE UNIQUE INDEX category_cate_category_uindex ON public.category USING btree (cate_category);


--
-- TOC entry 3311 (class 1259 OID 17042)
-- Name: file_file_uuid_uindex; Type: INDEX; Schema: public; Owner: postgres
--

CREATE UNIQUE INDEX file_file_uuid_uindex ON public.file USING btree (file_uuid);


--
-- TOC entry 3316 (class 1259 OID 17043)
-- Name: medical_record_user_mrus_uuid_uindex; Type: INDEX; Schema: public; Owner: postgres
--

CREATE UNIQUE INDEX medical_record_user_mrus_uuid_uindex ON public.medical_record_user USING btree (mrus_uuid);


--
-- TOC entry 3319 (class 1259 OID 17044)
-- Name: messages_mess_uuid_uindex; Type: INDEX; Schema: public; Owner: postgres
--

CREATE UNIQUE INDEX messages_mess_uuid_uindex ON public.messages USING btree (mess_uuid);


--
-- TOC entry 3322 (class 1259 OID 17045)
-- Name: my_doctor_mydo_uuid_uindex; Type: INDEX; Schema: public; Owner: postgres
--

CREATE UNIQUE INDEX my_doctor_mydo_uuid_uindex ON public.my_doctor USING btree (mydo_uuid);


--
-- TOC entry 3325 (class 1259 OID 17046)
-- Name: notification_noti_uuid_uindex; Type: INDEX; Schema: public; Owner: postgres
--

CREATE UNIQUE INDEX notification_noti_uuid_uindex ON public.notification USING btree (noti_uuid);


--
-- TOC entry 3326 (class 1259 OID 17047)
-- Name: notification_type_noty_id_uindex; Type: INDEX; Schema: public; Owner: postgres
--

CREATE UNIQUE INDEX notification_type_noty_id_uindex ON public.notification_type USING btree (noty_id);


--
-- TOC entry 3327 (class 1259 OID 17048)
-- Name: notification_type_noty_key_uindex; Type: INDEX; Schema: public; Owner: postgres
--

CREATE UNIQUE INDEX notification_type_noty_key_uindex ON public.notification_type USING btree (noty_key);


--
-- TOC entry 3330 (class 1259 OID 17049)
-- Name: page_page_uuid_uindex; Type: INDEX; Schema: public; Owner: postgres
--

CREATE UNIQUE INDEX page_page_uuid_uindex ON public.page USING btree (page_uuid);


--
-- TOC entry 3335 (class 1259 OID 17050)
-- Name: privacy_policy_prpo_id_uindex; Type: INDEX; Schema: public; Owner: postgres
--

CREATE UNIQUE INDEX privacy_policy_prpo_id_uindex ON public.privacy_policy USING btree (prpo_id);


--
-- TOC entry 3338 (class 1259 OID 17051)
-- Name: professional_profe_uuid_uindex; Type: INDEX; Schema: public; Owner: postgres
--

CREATE UNIQUE INDEX professional_profe_uuid_uindex ON public.professional USING btree (profe_uuid);


--
-- TOC entry 3341 (class 1259 OID 17052)
-- Name: refresh_token_reto_uuid_uindex; Type: INDEX; Schema: public; Owner: postgres
--

CREATE UNIQUE INDEX refresh_token_reto_uuid_uindex ON public.refresh_token USING btree (reto_uuid);


--
-- TOC entry 3344 (class 1259 OID 17053)
-- Name: specialty_spec_id_uindex; Type: INDEX; Schema: public; Owner: postgres
--

CREATE UNIQUE INDEX specialty_spec_id_uindex ON public.specialty USING btree (spec_id);


--
-- TOC entry 3347 (class 1259 OID 17054)
-- Name: terms_conditions_teco_id_uindex; Type: INDEX; Schema: public; Owner: postgres
--

CREATE UNIQUE INDEX terms_conditions_teco_id_uindex ON public.terms_conditions USING btree (teco_id);


--
-- TOC entry 3354 (class 1259 OID 17055)
-- Name: user_role_usro_id_uindex; Type: INDEX; Schema: public; Owner: postgres
--

CREATE UNIQUE INDEX user_role_usro_id_uindex ON public.user_role USING btree (usro_id);


--
-- TOC entry 3355 (class 1259 OID 17056)
-- Name: user_role_usro_key_uindex; Type: INDEX; Schema: public; Owner: postgres
--

CREATE UNIQUE INDEX user_role_usro_key_uindex ON public.user_role USING btree (usro_key);


--
-- TOC entry 3356 (class 1259 OID 17057)
-- Name: user_role_usro_role_uindex; Type: INDEX; Schema: public; Owner: postgres
--

CREATE UNIQUE INDEX user_role_usro_role_uindex ON public.user_role USING btree (usro_role);


--
-- TOC entry 3350 (class 1259 OID 17058)
-- Name: user_user_mrn_uindex; Type: INDEX; Schema: public; Owner: postgres
--

CREATE UNIQUE INDEX user_user_mrn_uindex ON public."user" USING btree (user_mrn);


--
-- TOC entry 3351 (class 1259 OID 17059)
-- Name: user_user_uuid_uindex; Type: INDEX; Schema: public; Owner: postgres
--

CREATE UNIQUE INDEX user_user_uuid_uindex ON public."user" USING btree (user_uuid);


--
-- TOC entry 3359 (class 1259 OID 17060)
-- Name: verification_code_veco_id_uindex; Type: INDEX; Schema: public; Owner: postgres
--

CREATE UNIQUE INDEX verification_code_veco_id_uindex ON public.verification_code USING btree (veco_id);


--
-- TOC entry 3360 (class 2606 OID 17061)
-- Name: address address_user_user_uuid_fk; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.address
    ADD CONSTRAINT address_user_user_uuid_fk FOREIGN KEY (addr_owner) REFERENCES public."user"(user_uuid) ON UPDATE CASCADE ON DELETE CASCADE;


--
-- TOC entry 3362 (class 2606 OID 17066)
-- Name: medical_record_user medical_record_user_medical_record_mere_uuid_fk; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.medical_record_user
    ADD CONSTRAINT medical_record_user_medical_record_mere_uuid_fk FOREIGN KEY (mrus_mere_uuid) REFERENCES public.medical_record(mere_uuid) ON UPDATE CASCADE ON DELETE CASCADE;


--
-- TOC entry 3363 (class 2606 OID 17071)
-- Name: medical_record_user medical_record_user_user_user_uuid_fk; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.medical_record_user
    ADD CONSTRAINT medical_record_user_user_user_uuid_fk FOREIGN KEY (mrus_user_uuid) REFERENCES public."user"(user_uuid) ON UPDATE CASCADE ON DELETE CASCADE;


--
-- TOC entry 3361 (class 2606 OID 17076)
-- Name: medical_record medical_record_user_user_uuid_fk; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.medical_record
    ADD CONSTRAINT medical_record_user_user_uuid_fk FOREIGN KEY (mere_owner) REFERENCES public."user"(user_uuid) ON UPDATE CASCADE ON DELETE RESTRICT;


--
-- TOC entry 3364 (class 2606 OID 17081)
-- Name: messages messages_conversation_conv_uuid_fk; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.messages
    ADD CONSTRAINT messages_conversation_conv_uuid_fk FOREIGN KEY (mess_conv_uuid) REFERENCES public.conversation(conv_uuid) ON UPDATE CASCADE ON DELETE CASCADE;


--
-- TOC entry 3365 (class 2606 OID 17086)
-- Name: messages messages_file_file_uuid_fk; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.messages
    ADD CONSTRAINT messages_file_file_uuid_fk FOREIGN KEY (mess_file) REFERENCES public.file(file_uuid) ON UPDATE CASCADE ON DELETE CASCADE;


--
-- TOC entry 3366 (class 2606 OID 17091)
-- Name: messages messages_user_user_uuid_fk; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.messages
    ADD CONSTRAINT messages_user_user_uuid_fk FOREIGN KEY (mess_sender) REFERENCES public."user"(user_uuid) ON UPDATE CASCADE ON DELETE CASCADE;


--
-- TOC entry 3367 (class 2606 OID 17096)
-- Name: my_doctor my_doctor_user_user_uuid_fk; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.my_doctor
    ADD CONSTRAINT my_doctor_user_user_uuid_fk FOREIGN KEY (mydo_owner) REFERENCES public."user"(user_uuid) ON UPDATE CASCADE ON DELETE CASCADE;


--
-- TOC entry 3368 (class 2606 OID 17101)
-- Name: my_doctor my_doctor_user_user_uuid_fk_2; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.my_doctor
    ADD CONSTRAINT my_doctor_user_user_uuid_fk_2 FOREIGN KEY (mydo_user_uuid) REFERENCES public."user"(user_uuid) ON UPDATE CASCADE ON DELETE CASCADE;


--
-- TOC entry 3369 (class 2606 OID 17106)
-- Name: my_professionals my_proffessionals_user_user_uuid_fk; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.my_professionals
    ADD CONSTRAINT my_proffessionals_user_user_uuid_fk FOREIGN KEY (mypr_uuid) REFERENCES public."user"(user_uuid);


--
-- TOC entry 3370 (class 2606 OID 17111)
-- Name: my_professionals my_proffessionals_user_user_uuid_fk_2; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.my_professionals
    ADD CONSTRAINT my_proffessionals_user_user_uuid_fk_2 FOREIGN KEY (mypr_proffesional) REFERENCES public."user"(user_uuid);


--
-- TOC entry 3371 (class 2606 OID 17116)
-- Name: notification notification_notification_type_noty_id_fk; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.notification
    ADD CONSTRAINT notification_notification_type_noty_id_fk FOREIGN KEY (noti_noty_id) REFERENCES public.notification_type(noty_id) ON DELETE RESTRICT;


--
-- TOC entry 3372 (class 2606 OID 17121)
-- Name: professional professional_specialty_spec_id_fk; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.professional
    ADD CONSTRAINT professional_specialty_spec_id_fk FOREIGN KEY (profe_spec_id) REFERENCES public.specialty(spec_id) ON UPDATE SET NULL ON DELETE SET NULL;


--
-- TOC entry 3373 (class 2606 OID 17126)
-- Name: refresh_token refresh_token_user_user_uuid_fk; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.refresh_token
    ADD CONSTRAINT refresh_token_user_user_uuid_fk FOREIGN KEY (reto_user_uuid) REFERENCES public."user"(user_uuid) ON UPDATE CASCADE ON DELETE CASCADE;


--
-- TOC entry 3374 (class 2606 OID 17131)
-- Name: specialty specialty_category_cate_id_fk; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.specialty
    ADD CONSTRAINT specialty_category_cate_id_fk FOREIGN KEY (spec_cate_id) REFERENCES public.category(cate_id) ON UPDATE CASCADE ON DELETE CASCADE;


--
-- TOC entry 3375 (class 2606 OID 17136)
-- Name: user user_user_role_usro_id_fk; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public."user"
    ADD CONSTRAINT user_user_role_usro_id_fk FOREIGN KEY (user_usro_id) REFERENCES public.user_role(usro_id) ON UPDATE CASCADE ON DELETE RESTRICT;


--
-- TOC entry 3376 (class 2606 OID 17141)
-- Name: user user_user_user_uuid_fk; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public."user"
    ADD CONSTRAINT user_user_user_uuid_fk FOREIGN KEY (user_owner) REFERENCES public."user"(user_uuid);


--
-- TOC entry 3377 (class 2606 OID 17146)
-- Name: verification_code verification_code_user_user_uuid_fk; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.verification_code
    ADD CONSTRAINT verification_code_user_user_uuid_fk FOREIGN KEY (veco_user_uuid) REFERENCES public."user"(user_uuid) ON UPDATE CASCADE ON DELETE CASCADE;


-- Completed on 2022-01-17 05:23:51

--
-- PostgreSQL database dump complete
--

