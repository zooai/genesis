--
-- PostgreSQL database dump
--

-- Dumped from database version 15.8 (Debian 15.8-1.pgdg120+1)
-- Dumped by pg_dump version 16.9 (Ubuntu 16.9-0ubuntu0.24.04.1)

-- Started on 2025-06-24 21:31:19 UTC

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

--
-- TOC entry 5 (class 3079 OID 18154)
-- Name: btree_gin; Type: EXTENSION; Schema: -; Owner: -
--

CREATE EXTENSION IF NOT EXISTS btree_gin WITH SCHEMA public;


--
-- TOC entry 4642 (class 0 OID 0)
-- Dependencies: 5
-- Name: EXTENSION btree_gin; Type: COMMENT; Schema: -; Owner: 
--

COMMENT ON EXTENSION btree_gin IS 'support for indexing common datatypes in GIN';


--
-- TOC entry 2 (class 3079 OID 16579)
-- Name: btree_gist; Type: EXTENSION; Schema: -; Owner: -
--

CREATE EXTENSION IF NOT EXISTS btree_gist WITH SCHEMA public;


--
-- TOC entry 4643 (class 0 OID 0)
-- Dependencies: 2
-- Name: EXTENSION btree_gist; Type: COMMENT; Schema: -; Owner: 
--

COMMENT ON EXTENSION btree_gist IS 'support for indexing common datatypes in GiST';


--
-- TOC entry 3 (class 3079 OID 17375)
-- Name: citext; Type: EXTENSION; Schema: -; Owner: -
--

CREATE EXTENSION IF NOT EXISTS citext WITH SCHEMA public;


--
-- TOC entry 4644 (class 0 OID 0)
-- Dependencies: 3
-- Name: EXTENSION citext; Type: COMMENT; Schema: -; Owner: 
--

COMMENT ON EXTENSION citext IS 'data type for case-insensitive character strings';


--
-- TOC entry 4 (class 3079 OID 17609)
-- Name: pg_trgm; Type: EXTENSION; Schema: -; Owner: -
--

CREATE EXTENSION IF NOT EXISTS pg_trgm WITH SCHEMA public;


--
-- TOC entry 4645 (class 0 OID 0)
-- Dependencies: 4
-- Name: EXTENSION pg_trgm; Type: COMMENT; Schema: -; Owner: 
--

COMMENT ON EXTENSION pg_trgm IS 'text similarity measurement and index searching based on trigrams';


--
-- TOC entry 1460 (class 1247 OID 18775)
-- Name: metadata_tag_record; Type: TYPE; Schema: public; Owner: blockscout
--

CREATE TYPE public.metadata_tag_record AS (
	id integer,
	address_hash bytea,
	metadata jsonb,
	addresses_index integer
);


ALTER TYPE public.metadata_tag_record OWNER TO blockscout;

--
-- TOC entry 1445 (class 1247 OID 18685)
-- Name: proxy_type; Type: TYPE; Schema: public; Owner: blockscout
--

CREATE TYPE public.proxy_type AS ENUM (
    'eip1167',
    'eip1967',
    'eip1822',
    'eip930',
    'master_copy',
    'basic_implementation',
    'basic_get_implementation',
    'comptroller',
    'eip2535',
    'clone_with_immutable_arguments',
    'eip7702',
    'unknown'
);


ALTER TYPE public.proxy_type OWNER TO blockscout;

--
-- TOC entry 1397 (class 1247 OID 18012)
-- Name: transaction_actions_protocol; Type: TYPE; Schema: public; Owner: blockscout
--

CREATE TYPE public.transaction_actions_protocol AS ENUM (
    'uniswap_v3',
    'opensea_v1_1',
    'wrapping',
    'approval',
    'zkbob',
    'aave_v3'
);


ALTER TYPE public.transaction_actions_protocol OWNER TO blockscout;

--
-- TOC entry 1400 (class 1247 OID 18024)
-- Name: transaction_actions_type; Type: TYPE; Schema: public; Owner: blockscout
--

CREATE TYPE public.transaction_actions_type AS ENUM (
    'mint_nft',
    'mint',
    'burn',
    'collect',
    'swap',
    'sale',
    'cancel',
    'transfer',
    'wrap',
    'unwrap',
    'approve',
    'revoke',
    'withdraw',
    'deposit',
    'borrow',
    'supply',
    'repay',
    'flash_loan',
    'enable_collateral',
    'disable_collateral',
    'liquidation_call'
);


ALTER TYPE public.transaction_actions_type OWNER TO blockscout;

--
-- TOC entry 668 (class 1255 OID 18939)
-- Name: convert(text[]); Type: FUNCTION; Schema: public; Owner: blockscout
--

CREATE FUNCTION public.convert(text[]) RETURNS bytea[]
    LANGUAGE plpgsql
    AS $_$
  DECLARE
    s bytea[] := ARRAY[]::bytea[];
    x text;
  BEGIN
    FOREACH x IN ARRAY $1
    LOOP
      s := array_append(s, decode(replace(x, '0x', ''), 'hex'));
    END LOOP;
    RETURN s;
  END;
  $_$;


ALTER FUNCTION public.convert(text[]) OWNER TO blockscout;

SET default_tablespace = '';

SET default_table_access_method = heap;

--
-- TOC entry 300 (class 1259 OID 18889)
-- Name: account_api_keys; Type: TABLE; Schema: public; Owner: blockscout
--

CREATE TABLE public.account_api_keys (
    identity_id bigint NOT NULL,
    name character varying(255) NOT NULL,
    value uuid NOT NULL,
    inserted_at timestamp(0) without time zone NOT NULL,
    updated_at timestamp(0) without time zone NOT NULL
);


ALTER TABLE public.account_api_keys OWNER TO blockscout;

--
-- TOC entry 299 (class 1259 OID 18882)
-- Name: account_api_plans; Type: TABLE; Schema: public; Owner: blockscout
--

CREATE TABLE public.account_api_plans (
    id integer NOT NULL,
    max_req_per_second smallint,
    name character varying(255) NOT NULL,
    inserted_at timestamp(0) without time zone NOT NULL,
    updated_at timestamp(0) without time zone NOT NULL
);


ALTER TABLE public.account_api_plans OWNER TO blockscout;

--
-- TOC entry 298 (class 1259 OID 18881)
-- Name: account_api_plans_id_seq; Type: SEQUENCE; Schema: public; Owner: blockscout
--

CREATE SEQUENCE public.account_api_plans_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER SEQUENCE public.account_api_plans_id_seq OWNER TO blockscout;

--
-- TOC entry 4646 (class 0 OID 0)
-- Dependencies: 298
-- Name: account_api_plans_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: blockscout
--

ALTER SEQUENCE public.account_api_plans_id_seq OWNED BY public.account_api_plans.id;


--
-- TOC entry 302 (class 1259 OID 18907)
-- Name: account_custom_abis; Type: TABLE; Schema: public; Owner: blockscout
--

CREATE TABLE public.account_custom_abis (
    id integer NOT NULL,
    identity_id bigint NOT NULL,
    abi jsonb NOT NULL,
    inserted_at timestamp(0) without time zone NOT NULL,
    updated_at timestamp(0) without time zone NOT NULL,
    address_hash_hash bytea,
    address_hash bytea,
    name bytea,
    user_created boolean DEFAULT true
);


ALTER TABLE public.account_custom_abis OWNER TO blockscout;

--
-- TOC entry 301 (class 1259 OID 18906)
-- Name: account_custom_abis_id_seq; Type: SEQUENCE; Schema: public; Owner: blockscout
--

CREATE SEQUENCE public.account_custom_abis_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER SEQUENCE public.account_custom_abis_id_seq OWNER TO blockscout;

--
-- TOC entry 4647 (class 0 OID 0)
-- Dependencies: 301
-- Name: account_custom_abis_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: blockscout
--

ALTER SEQUENCE public.account_custom_abis_id_seq OWNED BY public.account_custom_abis.id;


--
-- TOC entry 287 (class 1259 OID 18780)
-- Name: account_identities; Type: TABLE; Schema: public; Owner: blockscout
--

CREATE TABLE public.account_identities (
    id bigint NOT NULL,
    inserted_at timestamp(0) without time zone NOT NULL,
    updated_at timestamp(0) without time zone NOT NULL,
    plan_id bigint DEFAULT 1,
    uid bytea,
    uid_hash bytea,
    email bytea,
    avatar bytea,
    verification_email_sent_at timestamp without time zone,
    otp_sent_at timestamp without time zone
);


ALTER TABLE public.account_identities OWNER TO blockscout;

--
-- TOC entry 286 (class 1259 OID 18779)
-- Name: account_identities_id_seq; Type: SEQUENCE; Schema: public; Owner: blockscout
--

CREATE SEQUENCE public.account_identities_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER SEQUENCE public.account_identities_id_seq OWNER TO blockscout;

--
-- TOC entry 4648 (class 0 OID 0)
-- Dependencies: 286
-- Name: account_identities_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: blockscout
--

ALTER SEQUENCE public.account_identities_id_seq OWNED BY public.account_identities.id;


--
-- TOC entry 304 (class 1259 OID 18923)
-- Name: account_public_tags_requests; Type: TABLE; Schema: public; Owner: blockscout
--

CREATE TABLE public.account_public_tags_requests (
    id bigint NOT NULL,
    identity_id bigint,
    company character varying(255),
    website character varying(255),
    tags character varying(255),
    description text,
    additional_comment character varying(255),
    request_type character varying(255),
    is_owner boolean,
    remove_reason text,
    request_id character varying(255),
    inserted_at timestamp(0) without time zone NOT NULL,
    updated_at timestamp(0) without time zone NOT NULL,
    addresses bytea[],
    email bytea,
    full_name bytea
);


ALTER TABLE public.account_public_tags_requests OWNER TO blockscout;

--
-- TOC entry 303 (class 1259 OID 18922)
-- Name: account_public_tags_requests_id_seq; Type: SEQUENCE; Schema: public; Owner: blockscout
--

CREATE SEQUENCE public.account_public_tags_requests_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER SEQUENCE public.account_public_tags_requests_id_seq OWNER TO blockscout;

--
-- TOC entry 4649 (class 0 OID 0)
-- Dependencies: 303
-- Name: account_public_tags_requests_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: blockscout
--

ALTER SEQUENCE public.account_public_tags_requests_id_seq OWNED BY public.account_public_tags_requests.id;


--
-- TOC entry 295 (class 1259 OID 18850)
-- Name: account_tag_addresses; Type: TABLE; Schema: public; Owner: blockscout
--

CREATE TABLE public.account_tag_addresses (
    id bigint NOT NULL,
    identity_id bigint,
    inserted_at timestamp(0) without time zone NOT NULL,
    updated_at timestamp(0) without time zone NOT NULL,
    address_hash_hash bytea,
    name bytea,
    address_hash bytea,
    user_created boolean DEFAULT true
);


ALTER TABLE public.account_tag_addresses OWNER TO blockscout;

--
-- TOC entry 294 (class 1259 OID 18849)
-- Name: account_tag_addresses_id_seq; Type: SEQUENCE; Schema: public; Owner: blockscout
--

CREATE SEQUENCE public.account_tag_addresses_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER SEQUENCE public.account_tag_addresses_id_seq OWNER TO blockscout;

--
-- TOC entry 4650 (class 0 OID 0)
-- Dependencies: 294
-- Name: account_tag_addresses_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: blockscout
--

ALTER SEQUENCE public.account_tag_addresses_id_seq OWNED BY public.account_tag_addresses.id;


--
-- TOC entry 297 (class 1259 OID 18866)
-- Name: account_tag_transactions; Type: TABLE; Schema: public; Owner: blockscout
--

CREATE TABLE public.account_tag_transactions (
    id bigint NOT NULL,
    identity_id bigint,
    inserted_at timestamp(0) without time zone NOT NULL,
    updated_at timestamp(0) without time zone NOT NULL,
    transaction_hash_hash bytea,
    name bytea,
    transaction_hash bytea,
    user_created boolean DEFAULT true
);


ALTER TABLE public.account_tag_transactions OWNER TO blockscout;

--
-- TOC entry 296 (class 1259 OID 18865)
-- Name: account_tag_transactions_id_seq; Type: SEQUENCE; Schema: public; Owner: blockscout
--

CREATE SEQUENCE public.account_tag_transactions_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER SEQUENCE public.account_tag_transactions_id_seq OWNER TO blockscout;

--
-- TOC entry 4651 (class 0 OID 0)
-- Dependencies: 296
-- Name: account_tag_transactions_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: blockscout
--

ALTER SEQUENCE public.account_tag_transactions_id_seq OWNED BY public.account_tag_transactions.id;


--
-- TOC entry 291 (class 1259 OID 18802)
-- Name: account_watchlist_addresses; Type: TABLE; Schema: public; Owner: blockscout
--

CREATE TABLE public.account_watchlist_addresses (
    id bigint NOT NULL,
    watchlist_id bigint,
    watch_coin_input boolean DEFAULT true,
    watch_coin_output boolean DEFAULT true,
    watch_erc_20_input boolean DEFAULT true,
    watch_erc_20_output boolean DEFAULT true,
    watch_erc_721_input boolean DEFAULT true,
    watch_erc_721_output boolean DEFAULT true,
    watch_erc_1155_input boolean DEFAULT true,
    watch_erc_1155_output boolean DEFAULT true,
    notify_email boolean DEFAULT true,
    notify_epns boolean DEFAULT false,
    notify_feed boolean DEFAULT true,
    notify_inapp boolean DEFAULT false,
    inserted_at timestamp(0) without time zone NOT NULL,
    updated_at timestamp(0) without time zone NOT NULL,
    address_hash_hash bytea,
    name bytea,
    address_hash bytea,
    watch_erc_404_input boolean DEFAULT true,
    watch_erc_404_output boolean DEFAULT true,
    user_created boolean DEFAULT true
);


ALTER TABLE public.account_watchlist_addresses OWNER TO blockscout;

--
-- TOC entry 290 (class 1259 OID 18801)
-- Name: account_watchlist_addresses_id_seq; Type: SEQUENCE; Schema: public; Owner: blockscout
--

CREATE SEQUENCE public.account_watchlist_addresses_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER SEQUENCE public.account_watchlist_addresses_id_seq OWNER TO blockscout;

--
-- TOC entry 4652 (class 0 OID 0)
-- Dependencies: 290
-- Name: account_watchlist_addresses_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: blockscout
--

ALTER SEQUENCE public.account_watchlist_addresses_id_seq OWNED BY public.account_watchlist_addresses.id;


--
-- TOC entry 293 (class 1259 OID 18830)
-- Name: account_watchlist_notifications; Type: TABLE; Schema: public; Owner: blockscout
--

CREATE TABLE public.account_watchlist_notifications (
    id bigint NOT NULL,
    watchlist_address_id bigint,
    direction character varying(255),
    type character varying(255),
    method character varying(255),
    block_number integer,
    amount numeric,
    transaction_fee numeric,
    viewed_at timestamp without time zone,
    inserted_at timestamp without time zone NOT NULL,
    updated_at timestamp without time zone NOT NULL,
    name bytea,
    subject bytea,
    from_address_hash bytea,
    to_address_hash bytea,
    transaction_hash bytea,
    subject_hash bytea,
    from_address_hash_hash bytea,
    to_address_hash_hash bytea,
    transaction_hash_hash bytea,
    watchlist_id bigint NOT NULL
);


ALTER TABLE public.account_watchlist_notifications OWNER TO blockscout;

--
-- TOC entry 292 (class 1259 OID 18829)
-- Name: account_watchlist_notifications_id_seq; Type: SEQUENCE; Schema: public; Owner: blockscout
--

CREATE SEQUENCE public.account_watchlist_notifications_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER SEQUENCE public.account_watchlist_notifications_id_seq OWNER TO blockscout;

--
-- TOC entry 4653 (class 0 OID 0)
-- Dependencies: 292
-- Name: account_watchlist_notifications_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: blockscout
--

ALTER SEQUENCE public.account_watchlist_notifications_id_seq OWNED BY public.account_watchlist_notifications.id;


--
-- TOC entry 305 (class 1259 OID 18951)
-- Name: account_watchlist_notifications_watchlist_id_seq; Type: SEQUENCE; Schema: public; Owner: blockscout
--

CREATE SEQUENCE public.account_watchlist_notifications_watchlist_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER SEQUENCE public.account_watchlist_notifications_watchlist_id_seq OWNER TO blockscout;

--
-- TOC entry 4654 (class 0 OID 0)
-- Dependencies: 305
-- Name: account_watchlist_notifications_watchlist_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: blockscout
--

ALTER SEQUENCE public.account_watchlist_notifications_watchlist_id_seq OWNED BY public.account_watchlist_notifications.watchlist_id;


--
-- TOC entry 289 (class 1259 OID 18788)
-- Name: account_watchlists; Type: TABLE; Schema: public; Owner: blockscout
--

CREATE TABLE public.account_watchlists (
    id bigint NOT NULL,
    name character varying(255) DEFAULT 'default'::character varying,
    identity_id bigint,
    inserted_at timestamp(0) without time zone NOT NULL,
    updated_at timestamp(0) without time zone NOT NULL
);


ALTER TABLE public.account_watchlists OWNER TO blockscout;

--
-- TOC entry 288 (class 1259 OID 18787)
-- Name: account_watchlists_id_seq; Type: SEQUENCE; Schema: public; Owner: blockscout
--

CREATE SEQUENCE public.account_watchlists_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER SEQUENCE public.account_watchlists_id_seq OWNER TO blockscout;

--
-- TOC entry 4655 (class 0 OID 0)
-- Dependencies: 288
-- Name: account_watchlists_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: blockscout
--

ALTER SEQUENCE public.account_watchlists_id_seq OWNED BY public.account_watchlists.id;


--
-- TOC entry 235 (class 1259 OID 17283)
-- Name: address_coin_balances; Type: TABLE; Schema: public; Owner: blockscout
--

CREATE TABLE public.address_coin_balances (
    address_hash bytea NOT NULL,
    block_number bigint NOT NULL,
    value numeric(100,0) DEFAULT NULL::numeric,
    value_fetched_at timestamp without time zone,
    inserted_at timestamp without time zone NOT NULL,
    updated_at timestamp without time zone NOT NULL
);


ALTER TABLE public.address_coin_balances OWNER TO blockscout;

--
-- TOC entry 254 (class 1259 OID 17831)
-- Name: address_coin_balances_daily; Type: TABLE; Schema: public; Owner: blockscout
--

CREATE TABLE public.address_coin_balances_daily (
    address_hash bytea NOT NULL,
    day date NOT NULL,
    value numeric(100,0) DEFAULT NULL::numeric,
    inserted_at timestamp without time zone NOT NULL,
    updated_at timestamp without time zone NOT NULL
);


ALTER TABLE public.address_coin_balances_daily OWNER TO blockscout;

--
-- TOC entry 279 (class 1259 OID 18665)
-- Name: address_contract_code_fetch_attempts; Type: TABLE; Schema: public; Owner: blockscout
--

CREATE TABLE public.address_contract_code_fetch_attempts (
    address_hash bytea NOT NULL,
    retries_number smallint,
    inserted_at timestamp without time zone NOT NULL,
    updated_at timestamp without time zone NOT NULL
);


ALTER TABLE public.address_contract_code_fetch_attempts OWNER TO blockscout;

--
-- TOC entry 244 (class 1259 OID 17493)
-- Name: address_current_token_balances; Type: TABLE; Schema: public; Owner: blockscout
--

CREATE TABLE public.address_current_token_balances (
    id bigint NOT NULL,
    address_hash bytea NOT NULL,
    block_number bigint NOT NULL,
    token_contract_address_hash bytea NOT NULL,
    value numeric,
    value_fetched_at timestamp without time zone,
    inserted_at timestamp without time zone NOT NULL,
    updated_at timestamp without time zone NOT NULL,
    old_value numeric,
    token_id numeric(78,0),
    token_type character varying(255)
);


ALTER TABLE public.address_current_token_balances OWNER TO blockscout;

--
-- TOC entry 243 (class 1259 OID 17492)
-- Name: address_current_token_balances_id_seq; Type: SEQUENCE; Schema: public; Owner: blockscout
--

CREATE SEQUENCE public.address_current_token_balances_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER SEQUENCE public.address_current_token_balances_id_seq OWNER TO blockscout;

--
-- TOC entry 4656 (class 0 OID 0)
-- Dependencies: 243
-- Name: address_current_token_balances_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: blockscout
--

ALTER SEQUENCE public.address_current_token_balances_id_seq OWNED BY public.address_current_token_balances.id;


--
-- TOC entry 238 (class 1259 OID 17317)
-- Name: address_names; Type: TABLE; Schema: public; Owner: blockscout
--

CREATE TABLE public.address_names (
    address_hash bytea NOT NULL,
    name character varying(255) NOT NULL,
    "primary" boolean DEFAULT false NOT NULL,
    inserted_at timestamp without time zone NOT NULL,
    updated_at timestamp without time zone NOT NULL,
    metadata jsonb,
    id integer NOT NULL
);


ALTER TABLE public.address_names OWNER TO blockscout;

--
-- TOC entry 263 (class 1259 OID 17983)
-- Name: address_names_id_seq; Type: SEQUENCE; Schema: public; Owner: blockscout
--

CREATE SEQUENCE public.address_names_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER SEQUENCE public.address_names_id_seq OWNER TO blockscout;

--
-- TOC entry 4657 (class 0 OID 0)
-- Dependencies: 263
-- Name: address_names_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: blockscout
--

ALTER SEQUENCE public.address_names_id_seq OWNED BY public.address_names.id;


--
-- TOC entry 259 (class 1259 OID 17876)
-- Name: address_tags; Type: TABLE; Schema: public; Owner: blockscout
--

CREATE TABLE public.address_tags (
    id integer NOT NULL,
    label character varying(255) NOT NULL,
    inserted_at timestamp without time zone NOT NULL,
    updated_at timestamp without time zone NOT NULL,
    display_name character varying(255)
);


ALTER TABLE public.address_tags OWNER TO blockscout;

--
-- TOC entry 258 (class 1259 OID 17875)
-- Name: address_tags_id_seq; Type: SEQUENCE; Schema: public; Owner: blockscout
--

CREATE SEQUENCE public.address_tags_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER SEQUENCE public.address_tags_id_seq OWNER TO blockscout;

--
-- TOC entry 4658 (class 0 OID 0)
-- Dependencies: 258
-- Name: address_tags_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: blockscout
--

ALTER SEQUENCE public.address_tags_id_seq OWNED BY public.address_tags.id;


--
-- TOC entry 261 (class 1259 OID 17883)
-- Name: address_to_tags; Type: TABLE; Schema: public; Owner: blockscout
--

CREATE TABLE public.address_to_tags (
    id bigint NOT NULL,
    address_hash bytea NOT NULL,
    tag_id integer NOT NULL,
    inserted_at timestamp without time zone NOT NULL,
    updated_at timestamp without time zone NOT NULL
);


ALTER TABLE public.address_to_tags OWNER TO blockscout;

--
-- TOC entry 260 (class 1259 OID 17882)
-- Name: address_to_tags_id_seq; Type: SEQUENCE; Schema: public; Owner: blockscout
--

CREATE SEQUENCE public.address_to_tags_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER SEQUENCE public.address_to_tags_id_seq OWNER TO blockscout;

--
-- TOC entry 4659 (class 0 OID 0)
-- Dependencies: 260
-- Name: address_to_tags_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: blockscout
--

ALTER SEQUENCE public.address_to_tags_id_seq OWNED BY public.address_to_tags.id;


--
-- TOC entry 237 (class 1259 OID 17297)
-- Name: address_token_balances; Type: TABLE; Schema: public; Owner: blockscout
--

CREATE TABLE public.address_token_balances (
    id bigint NOT NULL,
    address_hash bytea NOT NULL,
    block_number bigint NOT NULL,
    token_contract_address_hash bytea NOT NULL,
    value numeric,
    value_fetched_at timestamp without time zone,
    inserted_at timestamp without time zone NOT NULL,
    updated_at timestamp without time zone NOT NULL,
    token_id numeric(78,0),
    token_type character varying(255),
    refetch_after timestamp without time zone,
    retries_count smallint
);


ALTER TABLE public.address_token_balances OWNER TO blockscout;

--
-- TOC entry 236 (class 1259 OID 17296)
-- Name: address_token_balances_id_seq; Type: SEQUENCE; Schema: public; Owner: blockscout
--

CREATE SEQUENCE public.address_token_balances_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER SEQUENCE public.address_token_balances_id_seq OWNER TO blockscout;

--
-- TOC entry 4660 (class 0 OID 0)
-- Dependencies: 236
-- Name: address_token_balances_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: blockscout
--

ALTER SEQUENCE public.address_token_balances_id_seq OWNED BY public.address_token_balances.id;


--
-- TOC entry 219 (class 1259 OID 16394)
-- Name: addresses; Type: TABLE; Schema: public; Owner: blockscout
--

CREATE TABLE public.addresses (
    fetched_coin_balance numeric(100,0),
    fetched_coin_balance_block_number bigint,
    hash bytea NOT NULL,
    contract_code bytea,
    inserted_at timestamp without time zone NOT NULL,
    updated_at timestamp without time zone NOT NULL,
    nonce integer,
    decompiled boolean,
    verified boolean,
    gas_used bigint,
    transactions_count integer,
    token_transfers_count integer
);


ALTER TABLE public.addresses OWNER TO blockscout;

--
-- TOC entry 242 (class 1259 OID 17362)
-- Name: administrators; Type: TABLE; Schema: public; Owner: blockscout
--

CREATE TABLE public.administrators (
    id bigint NOT NULL,
    role character varying(255) NOT NULL,
    user_id bigint NOT NULL,
    inserted_at timestamp without time zone NOT NULL,
    updated_at timestamp without time zone NOT NULL
);


ALTER TABLE public.administrators OWNER TO blockscout;

--
-- TOC entry 241 (class 1259 OID 17361)
-- Name: administrators_id_seq; Type: SEQUENCE; Schema: public; Owner: blockscout
--

CREATE SEQUENCE public.administrators_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER SEQUENCE public.administrators_id_seq OWNER TO blockscout;

--
-- TOC entry 4661 (class 0 OID 0)
-- Dependencies: 241
-- Name: administrators_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: blockscout
--

ALTER SEQUENCE public.administrators_id_seq OWNED BY public.administrators.id;


--
-- TOC entry 245 (class 1259 OID 17524)
-- Name: block_rewards; Type: TABLE; Schema: public; Owner: blockscout
--

CREATE TABLE public.block_rewards (
    address_hash bytea NOT NULL,
    address_type character varying(255) NOT NULL,
    block_hash bytea NOT NULL,
    reward numeric(100,0),
    inserted_at timestamp(0) without time zone NOT NULL,
    updated_at timestamp(0) without time zone NOT NULL
);


ALTER TABLE public.block_rewards OWNER TO blockscout;

--
-- TOC entry 239 (class 1259 OID 17325)
-- Name: block_second_degree_relations; Type: TABLE; Schema: public; Owner: blockscout
--

CREATE TABLE public.block_second_degree_relations (
    nephew_hash bytea NOT NULL,
    uncle_hash bytea NOT NULL,
    uncle_fetched_at timestamp without time zone,
    index integer
);


ALTER TABLE public.block_second_degree_relations OWNER TO blockscout;

--
-- TOC entry 220 (class 1259 OID 16401)
-- Name: blocks; Type: TABLE; Schema: public; Owner: blockscout
--

CREATE TABLE public.blocks (
    consensus boolean NOT NULL,
    difficulty numeric(50,0),
    gas_limit numeric(100,0) NOT NULL,
    gas_used numeric(100,0) NOT NULL,
    hash bytea NOT NULL,
    miner_hash bytea NOT NULL,
    nonce bytea NOT NULL,
    number bigint NOT NULL,
    parent_hash bytea NOT NULL,
    size integer,
    "timestamp" timestamp without time zone NOT NULL,
    total_difficulty numeric(50,0),
    inserted_at timestamp without time zone NOT NULL,
    updated_at timestamp without time zone NOT NULL,
    refetch_needed boolean DEFAULT false,
    base_fee_per_gas numeric(100,0),
    is_empty boolean
);


ALTER TABLE public.blocks OWNER TO blockscout;

--
-- TOC entry 272 (class 1259 OID 18109)
-- Name: constants; Type: TABLE; Schema: public; Owner: blockscout
--

CREATE TABLE public.constants (
    key character varying(255) NOT NULL,
    value character varying(255),
    inserted_at timestamp without time zone NOT NULL,
    updated_at timestamp without time zone NOT NULL
);


ALTER TABLE public.constants OWNER TO blockscout;

--
-- TOC entry 247 (class 1259 OID 17544)
-- Name: contract_methods; Type: TABLE; Schema: public; Owner: blockscout
--

CREATE TABLE public.contract_methods (
    id bigint NOT NULL,
    identifier integer NOT NULL,
    abi jsonb NOT NULL,
    type character varying(255) NOT NULL,
    inserted_at timestamp without time zone NOT NULL,
    updated_at timestamp without time zone NOT NULL
);


ALTER TABLE public.contract_methods OWNER TO blockscout;

--
-- TOC entry 246 (class 1259 OID 17543)
-- Name: contract_methods_id_seq; Type: SEQUENCE; Schema: public; Owner: blockscout
--

CREATE SEQUENCE public.contract_methods_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER SEQUENCE public.contract_methods_id_seq OWNER TO blockscout;

--
-- TOC entry 4662 (class 0 OID 0)
-- Dependencies: 246
-- Name: contract_methods_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: blockscout
--

ALTER SEQUENCE public.contract_methods_id_seq OWNED BY public.contract_methods.id;


--
-- TOC entry 262 (class 1259 OID 17924)
-- Name: contract_verification_status; Type: TABLE; Schema: public; Owner: blockscout
--

CREATE TABLE public.contract_verification_status (
    uid character varying(64) NOT NULL,
    status smallint NOT NULL,
    address_hash bytea NOT NULL,
    inserted_at timestamp without time zone NOT NULL,
    updated_at timestamp without time zone NOT NULL
);


ALTER TABLE public.contract_verification_status OWNER TO blockscout;

--
-- TOC entry 249 (class 1259 OID 17594)
-- Name: decompiled_smart_contracts; Type: TABLE; Schema: public; Owner: blockscout
--

CREATE TABLE public.decompiled_smart_contracts (
    id bigint NOT NULL,
    decompiler_version character varying(255) NOT NULL,
    decompiled_source_code text NOT NULL,
    address_hash bytea NOT NULL,
    inserted_at timestamp without time zone NOT NULL,
    updated_at timestamp without time zone NOT NULL
);


ALTER TABLE public.decompiled_smart_contracts OWNER TO blockscout;

--
-- TOC entry 248 (class 1259 OID 17593)
-- Name: decompiled_smart_contracts_id_seq; Type: SEQUENCE; Schema: public; Owner: blockscout
--

CREATE SEQUENCE public.decompiled_smart_contracts_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER SEQUENCE public.decompiled_smart_contracts_id_seq OWNER TO blockscout;

--
-- TOC entry 4663 (class 0 OID 0)
-- Dependencies: 248
-- Name: decompiled_smart_contracts_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: blockscout
--

ALTER SEQUENCE public.decompiled_smart_contracts_id_seq OWNED BY public.decompiled_smart_contracts.id;


--
-- TOC entry 232 (class 1259 OID 17229)
-- Name: emission_rewards; Type: TABLE; Schema: public; Owner: blockscout
--

CREATE TABLE public.emission_rewards (
    block_range int8range NOT NULL,
    reward numeric
);


ALTER TABLE public.emission_rewards OWNER TO blockscout;

--
-- TOC entry 265 (class 1259 OID 17996)
-- Name: event_notifications; Type: TABLE; Schema: public; Owner: blockscout
--

CREATE TABLE public.event_notifications (
    id bigint NOT NULL,
    data text NOT NULL
);


ALTER TABLE public.event_notifications OWNER TO blockscout;

--
-- TOC entry 264 (class 1259 OID 17995)
-- Name: event_notifications_id_seq; Type: SEQUENCE; Schema: public; Owner: blockscout
--

CREATE SEQUENCE public.event_notifications_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER SEQUENCE public.event_notifications_id_seq OWNER TO blockscout;

--
-- TOC entry 4664 (class 0 OID 0)
-- Dependencies: 264
-- Name: event_notifications_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: blockscout
--

ALTER SEQUENCE public.event_notifications_id_seq OWNED BY public.event_notifications.id;


--
-- TOC entry 223 (class 1259 OID 16491)
-- Name: internal_transactions; Type: TABLE; Schema: public; Owner: blockscout
--

CREATE TABLE public.internal_transactions (
    call_type character varying(255),
    created_contract_code bytea,
    error character varying(255),
    gas numeric(100,0),
    gas_used numeric(100,0),
    index integer NOT NULL,
    init bytea,
    input bytea,
    output bytea,
    trace_address integer[] NOT NULL,
    type character varying(255) NOT NULL,
    value numeric(100,0) NOT NULL,
    inserted_at timestamp without time zone NOT NULL,
    updated_at timestamp without time zone NOT NULL,
    created_contract_address_hash bytea,
    from_address_hash bytea,
    to_address_hash bytea,
    transaction_hash bytea NOT NULL,
    block_number integer,
    transaction_index integer,
    block_hash bytea NOT NULL,
    block_index integer NOT NULL,
    CONSTRAINT call_has_error_or_result CHECK ((((type)::text <> 'call'::text) OR ((gas IS NOT NULL) AND (((error IS NULL) AND (gas_used IS NOT NULL) AND (output IS NOT NULL)) OR ((error IS NOT NULL) AND (output IS NULL)))))),
    CONSTRAINT create_has_error_or_result CHECK ((((type)::text <> 'create'::text) OR ((gas IS NOT NULL) AND (((error IS NULL) AND (created_contract_address_hash IS NOT NULL) AND (created_contract_code IS NOT NULL) AND (gas_used IS NOT NULL)) OR ((error IS NOT NULL) AND (created_contract_address_hash IS NULL) AND (created_contract_code IS NULL) AND (gas_used IS NULL))))))
);


ALTER TABLE public.internal_transactions OWNER TO blockscout;

--
-- TOC entry 255 (class 1259 OID 17843)
-- Name: last_fetched_counters; Type: TABLE; Schema: public; Owner: blockscout
--

CREATE TABLE public.last_fetched_counters (
    counter_type character varying(255) NOT NULL,
    value numeric(100,0),
    inserted_at timestamp without time zone NOT NULL,
    updated_at timestamp without time zone NOT NULL
);


ALTER TABLE public.last_fetched_counters OWNER TO blockscout;

--
-- TOC entry 222 (class 1259 OID 16463)
-- Name: logs; Type: TABLE; Schema: public; Owner: blockscout
--

CREATE TABLE public.logs (
    data bytea NOT NULL,
    index integer NOT NULL,
    first_topic bytea,
    second_topic bytea,
    third_topic bytea,
    fourth_topic bytea,
    inserted_at timestamp without time zone NOT NULL,
    updated_at timestamp without time zone NOT NULL,
    address_hash bytea,
    transaction_hash bytea NOT NULL,
    block_hash bytea NOT NULL,
    block_number integer
);


ALTER TABLE public.logs OWNER TO blockscout;

--
-- TOC entry 225 (class 1259 OID 16528)
-- Name: market_history; Type: TABLE; Schema: public; Owner: blockscout
--

CREATE TABLE public.market_history (
    id bigint NOT NULL,
    date date NOT NULL,
    closing_price numeric,
    opening_price numeric,
    market_cap numeric,
    tvl numeric,
    secondary_coin boolean DEFAULT false
);


ALTER TABLE public.market_history OWNER TO blockscout;

--
-- TOC entry 224 (class 1259 OID 16527)
-- Name: market_history_id_seq; Type: SEQUENCE; Schema: public; Owner: blockscout
--

CREATE SEQUENCE public.market_history_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER SEQUENCE public.market_history_id_seq OWNER TO blockscout;

--
-- TOC entry 4665 (class 0 OID 0)
-- Dependencies: 224
-- Name: market_history_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: blockscout
--

ALTER SEQUENCE public.market_history_id_seq OWNED BY public.market_history.id;


--
-- TOC entry 278 (class 1259 OID 18655)
-- Name: massive_blocks; Type: TABLE; Schema: public; Owner: blockscout
--

CREATE TABLE public.massive_blocks (
    number bigint NOT NULL,
    inserted_at timestamp without time zone NOT NULL,
    updated_at timestamp without time zone NOT NULL
);


ALTER TABLE public.massive_blocks OWNER TO blockscout;

--
-- TOC entry 274 (class 1259 OID 18147)
-- Name: migrations_status; Type: TABLE; Schema: public; Owner: blockscout
--

CREATE TABLE public.migrations_status (
    migration_name character varying(255) NOT NULL,
    status character varying(255),
    inserted_at timestamp without time zone NOT NULL,
    updated_at timestamp without time zone NOT NULL,
    meta jsonb
);


ALTER TABLE public.migrations_status OWNER TO blockscout;

--
-- TOC entry 281 (class 1259 OID 18708)
-- Name: missing_balance_of_tokens; Type: TABLE; Schema: public; Owner: blockscout
--

CREATE TABLE public.missing_balance_of_tokens (
    token_contract_address_hash bytea NOT NULL,
    block_number bigint,
    inserted_at timestamp without time zone NOT NULL,
    updated_at timestamp without time zone NOT NULL,
    currently_implemented boolean
);


ALTER TABLE public.missing_balance_of_tokens OWNER TO blockscout;

--
-- TOC entry 270 (class 1259 OID 18082)
-- Name: missing_block_ranges; Type: TABLE; Schema: public; Owner: blockscout
--

CREATE TABLE public.missing_block_ranges (
    id bigint NOT NULL,
    from_number integer,
    to_number integer
);


ALTER TABLE public.missing_block_ranges OWNER TO blockscout;

--
-- TOC entry 269 (class 1259 OID 18081)
-- Name: missing_block_ranges_id_seq; Type: SEQUENCE; Schema: public; Owner: blockscout
--

CREATE SEQUENCE public.missing_block_ranges_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER SEQUENCE public.missing_block_ranges_id_seq OWNER TO blockscout;

--
-- TOC entry 4666 (class 0 OID 0)
-- Dependencies: 269
-- Name: missing_block_ranges_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: blockscout
--

ALTER SEQUENCE public.missing_block_ranges_id_seq OWNED BY public.missing_block_ranges.id;


--
-- TOC entry 253 (class 1259 OID 17751)
-- Name: pending_block_operations; Type: TABLE; Schema: public; Owner: blockscout
--

CREATE TABLE public.pending_block_operations (
    block_hash bytea NOT NULL,
    inserted_at timestamp without time zone NOT NULL,
    updated_at timestamp without time zone NOT NULL,
    block_number integer
);


ALTER TABLE public.pending_block_operations OWNER TO blockscout;

--
-- TOC entry 280 (class 1259 OID 18677)
-- Name: proxy_implementations; Type: TABLE; Schema: public; Owner: blockscout
--

CREATE TABLE public.proxy_implementations (
    proxy_address_hash bytea NOT NULL,
    address_hashes bytea[] NOT NULL,
    names character varying(255)[] NOT NULL,
    inserted_at timestamp without time zone NOT NULL,
    updated_at timestamp without time zone NOT NULL,
    proxy_type public.proxy_type
);


ALTER TABLE public.proxy_implementations OWNER TO blockscout;

--
-- TOC entry 275 (class 1259 OID 18617)
-- Name: proxy_smart_contract_verification_statuses; Type: TABLE; Schema: public; Owner: blockscout
--

CREATE TABLE public.proxy_smart_contract_verification_statuses (
    uid character varying(64) NOT NULL,
    status smallint NOT NULL,
    contract_address_hash bytea,
    inserted_at timestamp without time zone NOT NULL,
    updated_at timestamp without time zone NOT NULL
);


ALTER TABLE public.proxy_smart_contract_verification_statuses OWNER TO blockscout;

--
-- TOC entry 284 (class 1259 OID 18740)
-- Name: scam_address_badge_mappings; Type: TABLE; Schema: public; Owner: blockscout
--

CREATE TABLE public.scam_address_badge_mappings (
    address_hash bytea NOT NULL,
    inserted_at timestamp without time zone NOT NULL,
    updated_at timestamp without time zone NOT NULL
);


ALTER TABLE public.scam_address_badge_mappings OWNER TO blockscout;

--
-- TOC entry 218 (class 1259 OID 16389)
-- Name: schema_migrations; Type: TABLE; Schema: public; Owner: blockscout
--

CREATE TABLE public.schema_migrations (
    version bigint NOT NULL,
    inserted_at timestamp(0) without time zone
);


ALTER TABLE public.schema_migrations OWNER TO blockscout;

--
-- TOC entry 283 (class 1259 OID 18727)
-- Name: signed_authorizations; Type: TABLE; Schema: public; Owner: blockscout
--

CREATE TABLE public.signed_authorizations (
    transaction_hash bytea NOT NULL,
    index integer NOT NULL,
    chain_id bigint NOT NULL,
    address bytea NOT NULL,
    nonce integer NOT NULL,
    v integer NOT NULL,
    r numeric(100,0) NOT NULL,
    s numeric(100,0) NOT NULL,
    authority bytea,
    inserted_at timestamp without time zone NOT NULL,
    updated_at timestamp without time zone NOT NULL
);


ALTER TABLE public.signed_authorizations OWNER TO blockscout;

--
-- TOC entry 277 (class 1259 OID 18630)
-- Name: smart_contract_audit_reports; Type: TABLE; Schema: public; Owner: blockscout
--

CREATE TABLE public.smart_contract_audit_reports (
    id bigint NOT NULL,
    address_hash bytea NOT NULL,
    is_approved boolean DEFAULT false,
    submitter_name character varying(255) NOT NULL,
    submitter_email character varying(255) NOT NULL,
    is_project_owner boolean DEFAULT false,
    project_name character varying(255) NOT NULL,
    project_url character varying(255) NOT NULL,
    audit_company_name character varying(255) NOT NULL,
    audit_report_url character varying(255) NOT NULL,
    audit_publish_date date NOT NULL,
    request_id character varying(255),
    comment text,
    inserted_at timestamp without time zone NOT NULL,
    updated_at timestamp without time zone NOT NULL
);


ALTER TABLE public.smart_contract_audit_reports OWNER TO blockscout;

--
-- TOC entry 276 (class 1259 OID 18629)
-- Name: smart_contract_audit_reports_id_seq; Type: SEQUENCE; Schema: public; Owner: blockscout
--

CREATE SEQUENCE public.smart_contract_audit_reports_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER SEQUENCE public.smart_contract_audit_reports_id_seq OWNER TO blockscout;

--
-- TOC entry 4667 (class 0 OID 0)
-- Dependencies: 276
-- Name: smart_contract_audit_reports_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: blockscout
--

ALTER SEQUENCE public.smart_contract_audit_reports_id_seq OWNED BY public.smart_contract_audit_reports.id;


--
-- TOC entry 231 (class 1259 OID 16565)
-- Name: smart_contracts; Type: TABLE; Schema: public; Owner: blockscout
--

CREATE TABLE public.smart_contracts (
    id bigint NOT NULL,
    name character varying(255) NOT NULL,
    compiler_version character varying(255) NOT NULL,
    optimization boolean NOT NULL,
    contract_source_code text NOT NULL,
    abi jsonb,
    address_hash bytea NOT NULL,
    inserted_at timestamp without time zone NOT NULL,
    updated_at timestamp without time zone NOT NULL,
    constructor_arguments text,
    optimization_runs bigint,
    evm_version character varying(255),
    external_libraries jsonb[] DEFAULT ARRAY[]::jsonb[],
    verified_via_sourcify boolean,
    is_vyper_contract boolean,
    partially_verified boolean,
    file_path text,
    is_changed_bytecode boolean DEFAULT false,
    bytecode_checked_at timestamp without time zone DEFAULT ((now() AT TIME ZONE 'utc'::text) - '1 day'::interval),
    contract_code_md5 character varying(255) NOT NULL,
    compiler_settings jsonb,
    verified_via_eth_bytecode_db boolean,
    license_type smallint DEFAULT 1 NOT NULL,
    verified_via_verifier_alliance boolean,
    certified boolean,
    is_blueprint boolean,
    language smallint
);


ALTER TABLE public.smart_contracts OWNER TO blockscout;

--
-- TOC entry 257 (class 1259 OID 17861)
-- Name: smart_contracts_additional_sources; Type: TABLE; Schema: public; Owner: blockscout
--

CREATE TABLE public.smart_contracts_additional_sources (
    id bigint NOT NULL,
    file_name character varying(255) NOT NULL,
    contract_source_code text NOT NULL,
    address_hash bytea NOT NULL,
    inserted_at timestamp without time zone NOT NULL,
    updated_at timestamp without time zone NOT NULL
);


ALTER TABLE public.smart_contracts_additional_sources OWNER TO blockscout;

--
-- TOC entry 256 (class 1259 OID 17860)
-- Name: smart_contracts_additional_sources_id_seq; Type: SEQUENCE; Schema: public; Owner: blockscout
--

CREATE SEQUENCE public.smart_contracts_additional_sources_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER SEQUENCE public.smart_contracts_additional_sources_id_seq OWNER TO blockscout;

--
-- TOC entry 4668 (class 0 OID 0)
-- Dependencies: 256
-- Name: smart_contracts_additional_sources_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: blockscout
--

ALTER SEQUENCE public.smart_contracts_additional_sources_id_seq OWNED BY public.smart_contracts_additional_sources.id;


--
-- TOC entry 230 (class 1259 OID 16564)
-- Name: smart_contracts_id_seq; Type: SEQUENCE; Schema: public; Owner: blockscout
--

CREATE SEQUENCE public.smart_contracts_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER SEQUENCE public.smart_contracts_id_seq OWNER TO blockscout;

--
-- TOC entry 4669 (class 0 OID 0)
-- Dependencies: 230
-- Name: smart_contracts_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: blockscout
--

ALTER SEQUENCE public.smart_contracts_id_seq OWNED BY public.smart_contracts.id;


--
-- TOC entry 282 (class 1259 OID 18716)
-- Name: token_instance_metadata_refetch_attempts; Type: TABLE; Schema: public; Owner: blockscout
--

CREATE TABLE public.token_instance_metadata_refetch_attempts (
    token_contract_address_hash bytea NOT NULL,
    token_id numeric(78,0) NOT NULL,
    retries_number smallint,
    inserted_at timestamp without time zone NOT NULL,
    updated_at timestamp without time zone NOT NULL
);


ALTER TABLE public.token_instance_metadata_refetch_attempts OWNER TO blockscout;

--
-- TOC entry 252 (class 1259 OID 17734)
-- Name: token_instances; Type: TABLE; Schema: public; Owner: blockscout
--

CREATE TABLE public.token_instances (
    token_id numeric(78,0) NOT NULL,
    token_contract_address_hash bytea NOT NULL,
    metadata jsonb,
    inserted_at timestamp without time zone NOT NULL,
    updated_at timestamp without time zone NOT NULL,
    error character varying(255),
    owner_address_hash bytea,
    owner_updated_at_block bigint,
    owner_updated_at_log_index integer,
    refetch_after timestamp without time zone,
    retries_count smallint DEFAULT 0 NOT NULL,
    thumbnails jsonb,
    media_type character varying(255),
    cdn_upload_error character varying(255),
    is_banned boolean DEFAULT false
);


ALTER TABLE public.token_instances OWNER TO blockscout;

--
-- TOC entry 268 (class 1259 OID 18068)
-- Name: token_transfer_token_id_migrator_progress; Type: TABLE; Schema: public; Owner: blockscout
--

CREATE TABLE public.token_transfer_token_id_migrator_progress (
    id bigint NOT NULL,
    last_processed_block_number integer,
    inserted_at timestamp without time zone NOT NULL,
    updated_at timestamp without time zone NOT NULL
);


ALTER TABLE public.token_transfer_token_id_migrator_progress OWNER TO blockscout;

--
-- TOC entry 267 (class 1259 OID 18067)
-- Name: token_transfer_token_id_migrator_progress_id_seq; Type: SEQUENCE; Schema: public; Owner: blockscout
--

CREATE SEQUENCE public.token_transfer_token_id_migrator_progress_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER SEQUENCE public.token_transfer_token_id_migrator_progress_id_seq OWNER TO blockscout;

--
-- TOC entry 4670 (class 0 OID 0)
-- Dependencies: 267
-- Name: token_transfer_token_id_migrator_progress_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: blockscout
--

ALTER SEQUENCE public.token_transfer_token_id_migrator_progress_id_seq OWNED BY public.token_transfer_token_id_migrator_progress.id;


--
-- TOC entry 234 (class 1259 OID 17249)
-- Name: token_transfers; Type: TABLE; Schema: public; Owner: blockscout
--

CREATE TABLE public.token_transfers (
    transaction_hash bytea NOT NULL,
    log_index integer NOT NULL,
    from_address_hash bytea NOT NULL,
    to_address_hash bytea NOT NULL,
    amount numeric,
    token_contract_address_hash bytea NOT NULL,
    inserted_at timestamp without time zone NOT NULL,
    updated_at timestamp without time zone NOT NULL,
    block_number integer,
    block_hash bytea NOT NULL,
    amounts numeric[],
    token_ids numeric(78,0)[],
    token_type character varying(255),
    block_consensus boolean DEFAULT true
);


ALTER TABLE public.token_transfers OWNER TO blockscout;

--
-- TOC entry 233 (class 1259 OID 17236)
-- Name: tokens; Type: TABLE; Schema: public; Owner: blockscout
--

CREATE TABLE public.tokens (
    name text,
    symbol text,
    total_supply numeric,
    decimals numeric,
    type character varying(255) NOT NULL,
    cataloged boolean DEFAULT false,
    contract_address_hash bytea NOT NULL,
    inserted_at timestamp without time zone NOT NULL,
    updated_at timestamp without time zone NOT NULL,
    holder_count integer,
    skip_metadata boolean,
    fiat_value numeric,
    circulating_market_cap numeric,
    total_supply_updated_at_block bigint,
    icon_url character varying(255),
    is_verified_via_admin_panel boolean DEFAULT false,
    volume_24h numeric,
    metadata_updated_at timestamp without time zone
);


ALTER TABLE public.tokens OWNER TO blockscout;

--
-- TOC entry 266 (class 1259 OID 18053)
-- Name: transaction_actions; Type: TABLE; Schema: public; Owner: blockscout
--

CREATE TABLE public.transaction_actions (
    hash bytea NOT NULL,
    protocol public.transaction_actions_protocol NOT NULL,
    data jsonb DEFAULT '{}'::jsonb NOT NULL,
    type public.transaction_actions_type NOT NULL,
    log_index integer NOT NULL,
    inserted_at timestamp without time zone NOT NULL,
    updated_at timestamp without time zone NOT NULL
);


ALTER TABLE public.transaction_actions OWNER TO blockscout;

--
-- TOC entry 240 (class 1259 OID 17338)
-- Name: transaction_forks; Type: TABLE; Schema: public; Owner: blockscout
--

CREATE TABLE public.transaction_forks (
    hash bytea NOT NULL,
    index integer NOT NULL,
    uncle_hash bytea NOT NULL,
    inserted_at timestamp without time zone NOT NULL,
    updated_at timestamp without time zone NOT NULL
);


ALTER TABLE public.transaction_forks OWNER TO blockscout;

--
-- TOC entry 251 (class 1259 OID 17723)
-- Name: transaction_stats; Type: TABLE; Schema: public; Owner: blockscout
--

CREATE TABLE public.transaction_stats (
    id bigint NOT NULL,
    date date,
    number_of_transactions integer,
    gas_used numeric(100,0),
    total_fee numeric(100,0)
);


ALTER TABLE public.transaction_stats OWNER TO blockscout;

--
-- TOC entry 250 (class 1259 OID 17722)
-- Name: transaction_stats_id_seq; Type: SEQUENCE; Schema: public; Owner: blockscout
--

CREATE SEQUENCE public.transaction_stats_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER SEQUENCE public.transaction_stats_id_seq OWNER TO blockscout;

--
-- TOC entry 4671 (class 0 OID 0)
-- Dependencies: 250
-- Name: transaction_stats_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: blockscout
--

ALTER SEQUENCE public.transaction_stats_id_seq OWNED BY public.transaction_stats.id;


--
-- TOC entry 221 (class 1259 OID 16416)
-- Name: transactions; Type: TABLE; Schema: public; Owner: blockscout
--

CREATE TABLE public.transactions (
    cumulative_gas_used numeric(100,0),
    error character varying(255),
    gas numeric(100,0) NOT NULL,
    gas_price numeric(100,0),
    gas_used numeric(100,0),
    hash bytea NOT NULL,
    index integer,
    input bytea NOT NULL,
    nonce integer NOT NULL,
    r numeric(100,0) NOT NULL,
    s numeric(100,0) NOT NULL,
    status integer,
    v numeric(100,0) NOT NULL,
    value numeric(100,0) NOT NULL,
    inserted_at timestamp without time zone NOT NULL,
    updated_at timestamp without time zone NOT NULL,
    block_hash bytea,
    block_number integer,
    from_address_hash bytea NOT NULL,
    to_address_hash bytea,
    created_contract_address_hash bytea,
    created_contract_code_indexed_at timestamp without time zone,
    earliest_processing_start timestamp without time zone,
    old_block_hash bytea,
    revert_reason text,
    max_priority_fee_per_gas numeric(100,0),
    max_fee_per_gas numeric(100,0),
    type integer,
    has_error_in_internal_transactions boolean,
    block_timestamp timestamp without time zone,
    block_consensus boolean DEFAULT true,
    CONSTRAINT collated_block_number CHECK (((block_hash IS NULL) OR (block_number IS NOT NULL))),
    CONSTRAINT collated_cumalative_gas_used CHECK (((block_hash IS NULL) OR (cumulative_gas_used IS NOT NULL))),
    CONSTRAINT collated_gas_price CHECK (((block_hash IS NULL) OR (gas_price IS NOT NULL))),
    CONSTRAINT collated_gas_used CHECK (((block_hash IS NULL) OR (gas_used IS NOT NULL))),
    CONSTRAINT collated_index CHECK (((block_hash IS NULL) OR (index IS NOT NULL))),
    CONSTRAINT error CHECK (((status = 0) OR ((status <> 0) AND (error IS NULL)))),
    CONSTRAINT pending_block_number CHECK (((block_hash IS NOT NULL) OR (block_number IS NULL))),
    CONSTRAINT pending_cumalative_gas_used CHECK (((block_hash IS NOT NULL) OR (cumulative_gas_used IS NULL))),
    CONSTRAINT pending_gas_used CHECK (((block_hash IS NOT NULL) OR (gas_used IS NULL))),
    CONSTRAINT pending_index CHECK (((block_hash IS NOT NULL) OR (index IS NULL))),
    CONSTRAINT status CHECK ((((block_hash IS NULL) AND (status IS NULL)) OR (block_hash IS NOT NULL) OR ((status = 0) AND ((error)::text = 'dropped/replaced'::text))))
);


ALTER TABLE public.transactions OWNER TO blockscout;

--
-- TOC entry 229 (class 1259 OID 16548)
-- Name: user_contacts; Type: TABLE; Schema: public; Owner: blockscout
--

CREATE TABLE public.user_contacts (
    id bigint NOT NULL,
    email public.citext NOT NULL,
    user_id bigint NOT NULL,
    "primary" boolean DEFAULT false,
    verified boolean DEFAULT false,
    inserted_at timestamp without time zone NOT NULL,
    updated_at timestamp without time zone NOT NULL
);


ALTER TABLE public.user_contacts OWNER TO blockscout;

--
-- TOC entry 228 (class 1259 OID 16547)
-- Name: user_contacts_id_seq; Type: SEQUENCE; Schema: public; Owner: blockscout
--

CREATE SEQUENCE public.user_contacts_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER SEQUENCE public.user_contacts_id_seq OWNER TO blockscout;

--
-- TOC entry 4672 (class 0 OID 0)
-- Dependencies: 228
-- Name: user_contacts_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: blockscout
--

ALTER SEQUENCE public.user_contacts_id_seq OWNED BY public.user_contacts.id;


--
-- TOC entry 227 (class 1259 OID 16538)
-- Name: users; Type: TABLE; Schema: public; Owner: blockscout
--

CREATE TABLE public.users (
    id bigint NOT NULL,
    username public.citext NOT NULL,
    password_hash character varying(255) NOT NULL,
    inserted_at timestamp without time zone NOT NULL,
    updated_at timestamp without time zone NOT NULL
);


ALTER TABLE public.users OWNER TO blockscout;

--
-- TOC entry 226 (class 1259 OID 16537)
-- Name: users_id_seq; Type: SEQUENCE; Schema: public; Owner: blockscout
--

CREATE SEQUENCE public.users_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER SEQUENCE public.users_id_seq OWNER TO blockscout;

--
-- TOC entry 4673 (class 0 OID 0)
-- Dependencies: 226
-- Name: users_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: blockscout
--

ALTER SEQUENCE public.users_id_seq OWNED BY public.users.id;


--
-- TOC entry 273 (class 1259 OID 18116)
-- Name: validators; Type: TABLE; Schema: public; Owner: blockscout
--

CREATE TABLE public.validators (
    address_hash bytea NOT NULL,
    is_validator boolean,
    payout_key_hash bytea,
    info_updated_at_block bigint,
    inserted_at timestamp without time zone NOT NULL,
    updated_at timestamp without time zone NOT NULL
);


ALTER TABLE public.validators OWNER TO blockscout;

--
-- TOC entry 271 (class 1259 OID 18090)
-- Name: withdrawals; Type: TABLE; Schema: public; Owner: blockscout
--

CREATE TABLE public.withdrawals (
    index integer NOT NULL,
    validator_index integer NOT NULL,
    amount numeric(100,0) NOT NULL,
    inserted_at timestamp without time zone NOT NULL,
    updated_at timestamp without time zone NOT NULL,
    address_hash bytea NOT NULL,
    block_hash bytea NOT NULL
);


ALTER TABLE public.withdrawals OWNER TO blockscout;

--
-- TOC entry 4093 (class 2604 OID 18885)
-- Name: account_api_plans id; Type: DEFAULT; Schema: public; Owner: blockscout
--

ALTER TABLE ONLY public.account_api_plans ALTER COLUMN id SET DEFAULT nextval('public.account_api_plans_id_seq'::regclass);


--
-- TOC entry 4094 (class 2604 OID 18910)
-- Name: account_custom_abis id; Type: DEFAULT; Schema: public; Owner: blockscout
--

ALTER TABLE ONLY public.account_custom_abis ALTER COLUMN id SET DEFAULT nextval('public.account_custom_abis_id_seq'::regclass);


--
-- TOC entry 4067 (class 2604 OID 18783)
-- Name: account_identities id; Type: DEFAULT; Schema: public; Owner: blockscout
--

ALTER TABLE ONLY public.account_identities ALTER COLUMN id SET DEFAULT nextval('public.account_identities_id_seq'::regclass);


--
-- TOC entry 4096 (class 2604 OID 18926)
-- Name: account_public_tags_requests id; Type: DEFAULT; Schema: public; Owner: blockscout
--

ALTER TABLE ONLY public.account_public_tags_requests ALTER COLUMN id SET DEFAULT nextval('public.account_public_tags_requests_id_seq'::regclass);


--
-- TOC entry 4089 (class 2604 OID 18853)
-- Name: account_tag_addresses id; Type: DEFAULT; Schema: public; Owner: blockscout
--

ALTER TABLE ONLY public.account_tag_addresses ALTER COLUMN id SET DEFAULT nextval('public.account_tag_addresses_id_seq'::regclass);


--
-- TOC entry 4091 (class 2604 OID 18869)
-- Name: account_tag_transactions id; Type: DEFAULT; Schema: public; Owner: blockscout
--

ALTER TABLE ONLY public.account_tag_transactions ALTER COLUMN id SET DEFAULT nextval('public.account_tag_transactions_id_seq'::regclass);


--
-- TOC entry 4071 (class 2604 OID 18805)
-- Name: account_watchlist_addresses id; Type: DEFAULT; Schema: public; Owner: blockscout
--

ALTER TABLE ONLY public.account_watchlist_addresses ALTER COLUMN id SET DEFAULT nextval('public.account_watchlist_addresses_id_seq'::regclass);


--
-- TOC entry 4087 (class 2604 OID 18833)
-- Name: account_watchlist_notifications id; Type: DEFAULT; Schema: public; Owner: blockscout
--

ALTER TABLE ONLY public.account_watchlist_notifications ALTER COLUMN id SET DEFAULT nextval('public.account_watchlist_notifications_id_seq'::regclass);


--
-- TOC entry 4088 (class 2604 OID 18952)
-- Name: account_watchlist_notifications watchlist_id; Type: DEFAULT; Schema: public; Owner: blockscout
--

ALTER TABLE ONLY public.account_watchlist_notifications ALTER COLUMN watchlist_id SET DEFAULT nextval('public.account_watchlist_notifications_watchlist_id_seq'::regclass);


--
-- TOC entry 4069 (class 2604 OID 18791)
-- Name: account_watchlists id; Type: DEFAULT; Schema: public; Owner: blockscout
--

ALTER TABLE ONLY public.account_watchlists ALTER COLUMN id SET DEFAULT nextval('public.account_watchlists_id_seq'::regclass);


--
-- TOC entry 4050 (class 2604 OID 17496)
-- Name: address_current_token_balances id; Type: DEFAULT; Schema: public; Owner: blockscout
--

ALTER TABLE ONLY public.address_current_token_balances ALTER COLUMN id SET DEFAULT nextval('public.address_current_token_balances_id_seq'::regclass);


--
-- TOC entry 4048 (class 2604 OID 17984)
-- Name: address_names id; Type: DEFAULT; Schema: public; Owner: blockscout
--

ALTER TABLE ONLY public.address_names ALTER COLUMN id SET DEFAULT nextval('public.address_names_id_seq'::regclass);


--
-- TOC entry 4058 (class 2604 OID 17879)
-- Name: address_tags id; Type: DEFAULT; Schema: public; Owner: blockscout
--

ALTER TABLE ONLY public.address_tags ALTER COLUMN id SET DEFAULT nextval('public.address_tags_id_seq'::regclass);


--
-- TOC entry 4059 (class 2604 OID 17886)
-- Name: address_to_tags id; Type: DEFAULT; Schema: public; Owner: blockscout
--

ALTER TABLE ONLY public.address_to_tags ALTER COLUMN id SET DEFAULT nextval('public.address_to_tags_id_seq'::regclass);


--
-- TOC entry 4046 (class 2604 OID 17300)
-- Name: address_token_balances id; Type: DEFAULT; Schema: public; Owner: blockscout
--

ALTER TABLE ONLY public.address_token_balances ALTER COLUMN id SET DEFAULT nextval('public.address_token_balances_id_seq'::regclass);


--
-- TOC entry 4049 (class 2604 OID 17365)
-- Name: administrators id; Type: DEFAULT; Schema: public; Owner: blockscout
--

ALTER TABLE ONLY public.administrators ALTER COLUMN id SET DEFAULT nextval('public.administrators_id_seq'::regclass);


--
-- TOC entry 4051 (class 2604 OID 17547)
-- Name: contract_methods id; Type: DEFAULT; Schema: public; Owner: blockscout
--

ALTER TABLE ONLY public.contract_methods ALTER COLUMN id SET DEFAULT nextval('public.contract_methods_id_seq'::regclass);


--
-- TOC entry 4052 (class 2604 OID 17597)
-- Name: decompiled_smart_contracts id; Type: DEFAULT; Schema: public; Owner: blockscout
--

ALTER TABLE ONLY public.decompiled_smart_contracts ALTER COLUMN id SET DEFAULT nextval('public.decompiled_smart_contracts_id_seq'::regclass);


--
-- TOC entry 4060 (class 2604 OID 17999)
-- Name: event_notifications id; Type: DEFAULT; Schema: public; Owner: blockscout
--

ALTER TABLE ONLY public.event_notifications ALTER COLUMN id SET DEFAULT nextval('public.event_notifications_id_seq'::regclass);


--
-- TOC entry 4031 (class 2604 OID 16531)
-- Name: market_history id; Type: DEFAULT; Schema: public; Owner: blockscout
--

ALTER TABLE ONLY public.market_history ALTER COLUMN id SET DEFAULT nextval('public.market_history_id_seq'::regclass);


--
-- TOC entry 4063 (class 2604 OID 18085)
-- Name: missing_block_ranges id; Type: DEFAULT; Schema: public; Owner: blockscout
--

ALTER TABLE ONLY public.missing_block_ranges ALTER COLUMN id SET DEFAULT nextval('public.missing_block_ranges_id_seq'::regclass);


--
-- TOC entry 4064 (class 2604 OID 18633)
-- Name: smart_contract_audit_reports id; Type: DEFAULT; Schema: public; Owner: blockscout
--

ALTER TABLE ONLY public.smart_contract_audit_reports ALTER COLUMN id SET DEFAULT nextval('public.smart_contract_audit_reports_id_seq'::regclass);


--
-- TOC entry 4037 (class 2604 OID 16568)
-- Name: smart_contracts id; Type: DEFAULT; Schema: public; Owner: blockscout
--

ALTER TABLE ONLY public.smart_contracts ALTER COLUMN id SET DEFAULT nextval('public.smart_contracts_id_seq'::regclass);


--
-- TOC entry 4057 (class 2604 OID 17864)
-- Name: smart_contracts_additional_sources id; Type: DEFAULT; Schema: public; Owner: blockscout
--

ALTER TABLE ONLY public.smart_contracts_additional_sources ALTER COLUMN id SET DEFAULT nextval('public.smart_contracts_additional_sources_id_seq'::regclass);


--
-- TOC entry 4062 (class 2604 OID 18071)
-- Name: token_transfer_token_id_migrator_progress id; Type: DEFAULT; Schema: public; Owner: blockscout
--

ALTER TABLE ONLY public.token_transfer_token_id_migrator_progress ALTER COLUMN id SET DEFAULT nextval('public.token_transfer_token_id_migrator_progress_id_seq'::regclass);


--
-- TOC entry 4053 (class 2604 OID 17726)
-- Name: transaction_stats id; Type: DEFAULT; Schema: public; Owner: blockscout
--

ALTER TABLE ONLY public.transaction_stats ALTER COLUMN id SET DEFAULT nextval('public.transaction_stats_id_seq'::regclass);


--
-- TOC entry 4034 (class 2604 OID 16551)
-- Name: user_contacts id; Type: DEFAULT; Schema: public; Owner: blockscout
--

ALTER TABLE ONLY public.user_contacts ALTER COLUMN id SET DEFAULT nextval('public.user_contacts_id_seq'::regclass);


--
-- TOC entry 4033 (class 2604 OID 16541)
-- Name: users id; Type: DEFAULT; Schema: public; Owner: blockscout
--

ALTER TABLE ONLY public.users ALTER COLUMN id SET DEFAULT nextval('public.users_id_seq'::regclass);


--
-- TOC entry 4631 (class 0 OID 18889)
-- Dependencies: 300
-- Data for Name: account_api_keys; Type: TABLE DATA; Schema: public; Owner: blockscout
--

COPY public.account_api_keys (identity_id, name, value, inserted_at, updated_at) FROM stdin;
\.


--
-- TOC entry 4630 (class 0 OID 18882)
-- Dependencies: 299
-- Data for Name: account_api_plans; Type: TABLE DATA; Schema: public; Owner: blockscout
--

COPY public.account_api_plans (id, max_req_per_second, name, inserted_at, updated_at) FROM stdin;
1	10	Free Plan	2025-06-24 21:23:37	2025-06-24 21:23:37
\.


--
-- TOC entry 4633 (class 0 OID 18907)
-- Dependencies: 302
-- Data for Name: account_custom_abis; Type: TABLE DATA; Schema: public; Owner: blockscout
--

COPY public.account_custom_abis (id, identity_id, abi, inserted_at, updated_at, address_hash_hash, address_hash, name, user_created) FROM stdin;
\.


--
-- TOC entry 4618 (class 0 OID 18780)
-- Dependencies: 287
-- Data for Name: account_identities; Type: TABLE DATA; Schema: public; Owner: blockscout
--

COPY public.account_identities (id, inserted_at, updated_at, plan_id, uid, uid_hash, email, avatar, verification_email_sent_at, otp_sent_at) FROM stdin;
\.


--
-- TOC entry 4635 (class 0 OID 18923)
-- Dependencies: 304
-- Data for Name: account_public_tags_requests; Type: TABLE DATA; Schema: public; Owner: blockscout
--

COPY public.account_public_tags_requests (id, identity_id, company, website, tags, description, additional_comment, request_type, is_owner, remove_reason, request_id, inserted_at, updated_at, addresses, email, full_name) FROM stdin;
\.


--
-- TOC entry 4626 (class 0 OID 18850)
-- Dependencies: 295
-- Data for Name: account_tag_addresses; Type: TABLE DATA; Schema: public; Owner: blockscout
--

COPY public.account_tag_addresses (id, identity_id, inserted_at, updated_at, address_hash_hash, name, address_hash, user_created) FROM stdin;
\.


--
-- TOC entry 4628 (class 0 OID 18866)
-- Dependencies: 297
-- Data for Name: account_tag_transactions; Type: TABLE DATA; Schema: public; Owner: blockscout
--

COPY public.account_tag_transactions (id, identity_id, inserted_at, updated_at, transaction_hash_hash, name, transaction_hash, user_created) FROM stdin;
\.


--
-- TOC entry 4622 (class 0 OID 18802)
-- Dependencies: 291
-- Data for Name: account_watchlist_addresses; Type: TABLE DATA; Schema: public; Owner: blockscout
--

COPY public.account_watchlist_addresses (id, watchlist_id, watch_coin_input, watch_coin_output, watch_erc_20_input, watch_erc_20_output, watch_erc_721_input, watch_erc_721_output, watch_erc_1155_input, watch_erc_1155_output, notify_email, notify_epns, notify_feed, notify_inapp, inserted_at, updated_at, address_hash_hash, name, address_hash, watch_erc_404_input, watch_erc_404_output, user_created) FROM stdin;
\.


--
-- TOC entry 4624 (class 0 OID 18830)
-- Dependencies: 293
-- Data for Name: account_watchlist_notifications; Type: TABLE DATA; Schema: public; Owner: blockscout
--

COPY public.account_watchlist_notifications (id, watchlist_address_id, direction, type, method, block_number, amount, transaction_fee, viewed_at, inserted_at, updated_at, name, subject, from_address_hash, to_address_hash, transaction_hash, subject_hash, from_address_hash_hash, to_address_hash_hash, transaction_hash_hash, watchlist_id) FROM stdin;
\.


--
-- TOC entry 4620 (class 0 OID 18788)
-- Dependencies: 289
-- Data for Name: account_watchlists; Type: TABLE DATA; Schema: public; Owner: blockscout
--

COPY public.account_watchlists (id, name, identity_id, inserted_at, updated_at) FROM stdin;
\.


--
-- TOC entry 4567 (class 0 OID 17283)
-- Dependencies: 235
-- Data for Name: address_coin_balances; Type: TABLE DATA; Schema: public; Owner: blockscout
--

COPY public.address_coin_balances (address_hash, block_number, value, value_fetched_at, inserted_at, updated_at) FROM stdin;
\.


--
-- TOC entry 4586 (class 0 OID 17831)
-- Dependencies: 254
-- Data for Name: address_coin_balances_daily; Type: TABLE DATA; Schema: public; Owner: blockscout
--

COPY public.address_coin_balances_daily (address_hash, day, value, inserted_at, updated_at) FROM stdin;
\.


--
-- TOC entry 4611 (class 0 OID 18665)
-- Dependencies: 279
-- Data for Name: address_contract_code_fetch_attempts; Type: TABLE DATA; Schema: public; Owner: blockscout
--

COPY public.address_contract_code_fetch_attempts (address_hash, retries_number, inserted_at, updated_at) FROM stdin;
\.


--
-- TOC entry 4576 (class 0 OID 17493)
-- Dependencies: 244
-- Data for Name: address_current_token_balances; Type: TABLE DATA; Schema: public; Owner: blockscout
--

COPY public.address_current_token_balances (id, address_hash, block_number, token_contract_address_hash, value, value_fetched_at, inserted_at, updated_at, old_value, token_id, token_type) FROM stdin;
\.


--
-- TOC entry 4570 (class 0 OID 17317)
-- Dependencies: 238
-- Data for Name: address_names; Type: TABLE DATA; Schema: public; Owner: blockscout
--

COPY public.address_names (address_hash, name, "primary", inserted_at, updated_at, metadata, id) FROM stdin;
\.


--
-- TOC entry 4591 (class 0 OID 17876)
-- Dependencies: 259
-- Data for Name: address_tags; Type: TABLE DATA; Schema: public; Owner: blockscout
--

COPY public.address_tags (id, label, inserted_at, updated_at, display_name) FROM stdin;
\.


--
-- TOC entry 4593 (class 0 OID 17883)
-- Dependencies: 261
-- Data for Name: address_to_tags; Type: TABLE DATA; Schema: public; Owner: blockscout
--

COPY public.address_to_tags (id, address_hash, tag_id, inserted_at, updated_at) FROM stdin;
\.


--
-- TOC entry 4569 (class 0 OID 17297)
-- Dependencies: 237
-- Data for Name: address_token_balances; Type: TABLE DATA; Schema: public; Owner: blockscout
--

COPY public.address_token_balances (id, address_hash, block_number, token_contract_address_hash, value, value_fetched_at, inserted_at, updated_at, token_id, token_type, refetch_after, retries_count) FROM stdin;
\.


--
-- TOC entry 4551 (class 0 OID 16394)
-- Dependencies: 219
-- Data for Name: addresses; Type: TABLE DATA; Schema: public; Owner: blockscout
--

COPY public.addresses (fetched_coin_balance, fetched_coin_balance_block_number, hash, contract_code, inserted_at, updated_at, nonce, decompiled, verified, gas_used, transactions_count, token_transfers_count) FROM stdin;
\.


--
-- TOC entry 4574 (class 0 OID 17362)
-- Dependencies: 242
-- Data for Name: administrators; Type: TABLE DATA; Schema: public; Owner: blockscout
--

COPY public.administrators (id, role, user_id, inserted_at, updated_at) FROM stdin;
\.


--
-- TOC entry 4577 (class 0 OID 17524)
-- Dependencies: 245
-- Data for Name: block_rewards; Type: TABLE DATA; Schema: public; Owner: blockscout
--

COPY public.block_rewards (address_hash, address_type, block_hash, reward, inserted_at, updated_at) FROM stdin;
\.


--
-- TOC entry 4571 (class 0 OID 17325)
-- Dependencies: 239
-- Data for Name: block_second_degree_relations; Type: TABLE DATA; Schema: public; Owner: blockscout
--

COPY public.block_second_degree_relations (nephew_hash, uncle_hash, uncle_fetched_at, index) FROM stdin;
\.


--
-- TOC entry 4552 (class 0 OID 16401)
-- Dependencies: 220
-- Data for Name: blocks; Type: TABLE DATA; Schema: public; Owner: blockscout
--

COPY public.blocks (consensus, difficulty, gas_limit, gas_used, hash, miner_hash, nonce, number, parent_hash, size, "timestamp", total_difficulty, inserted_at, updated_at, refetch_needed, base_fee_per_gas, is_empty) FROM stdin;
\.


--
-- TOC entry 4604 (class 0 OID 18109)
-- Dependencies: 272
-- Data for Name: constants; Type: TABLE DATA; Schema: public; Owner: blockscout
--

COPY public.constants (key, value, inserted_at, updated_at) FROM stdin;
\.


--
-- TOC entry 4579 (class 0 OID 17544)
-- Dependencies: 247
-- Data for Name: contract_methods; Type: TABLE DATA; Schema: public; Owner: blockscout
--

COPY public.contract_methods (id, identifier, abi, type, inserted_at, updated_at) FROM stdin;
\.


--
-- TOC entry 4594 (class 0 OID 17924)
-- Dependencies: 262
-- Data for Name: contract_verification_status; Type: TABLE DATA; Schema: public; Owner: blockscout
--

COPY public.contract_verification_status (uid, status, address_hash, inserted_at, updated_at) FROM stdin;
\.


--
-- TOC entry 4581 (class 0 OID 17594)
-- Dependencies: 249
-- Data for Name: decompiled_smart_contracts; Type: TABLE DATA; Schema: public; Owner: blockscout
--

COPY public.decompiled_smart_contracts (id, decompiler_version, decompiled_source_code, address_hash, inserted_at, updated_at) FROM stdin;
\.


--
-- TOC entry 4564 (class 0 OID 17229)
-- Dependencies: 232
-- Data for Name: emission_rewards; Type: TABLE DATA; Schema: public; Owner: blockscout
--

COPY public.emission_rewards (block_range, reward) FROM stdin;
\.


--
-- TOC entry 4597 (class 0 OID 17996)
-- Dependencies: 265
-- Data for Name: event_notifications; Type: TABLE DATA; Schema: public; Owner: blockscout
--

COPY public.event_notifications (id, data) FROM stdin;
\.


--
-- TOC entry 4555 (class 0 OID 16491)
-- Dependencies: 223
-- Data for Name: internal_transactions; Type: TABLE DATA; Schema: public; Owner: blockscout
--

COPY public.internal_transactions (call_type, created_contract_code, error, gas, gas_used, index, init, input, output, trace_address, type, value, inserted_at, updated_at, created_contract_address_hash, from_address_hash, to_address_hash, transaction_hash, block_number, transaction_index, block_hash, block_index) FROM stdin;
\.


--
-- TOC entry 4587 (class 0 OID 17843)
-- Dependencies: 255
-- Data for Name: last_fetched_counters; Type: TABLE DATA; Schema: public; Owner: blockscout
--

COPY public.last_fetched_counters (counter_type, value, inserted_at, updated_at) FROM stdin;
min_missing_block_number	0	2025-06-24 21:23:34.761306	2025-06-24 21:23:34.761306
contracts_counter	0	2025-06-24 21:29:45.911339	2025-06-24 21:29:45.911339
new_verified_contracts_counter	0	2025-06-24 21:29:45.912381	2025-06-24 21:29:45.912381
verified_contracts_counter	0	2025-06-24 21:29:45.913038	2025-06-24 21:29:45.913038
withdrawals_sum	0	2025-06-24 21:29:45.912965	2025-06-24 21:29:45.912965
new_contracts_counter	0	2025-06-24 21:29:45.913063	2025-06-24 21:29:45.913063
pending_transaction_count_30min	0	2025-06-24 21:29:45.912844	2025-06-24 21:29:45.912844
transaction_count_24h	0	2025-06-24 21:29:45.916063	2025-06-24 21:29:45.916063
transaction_fee_sum_24h	\N	2025-06-24 21:29:45.918798	2025-06-24 21:29:45.918798
transaction_fee_average_24h	\N	2025-06-24 21:29:45.92102	2025-06-24 21:29:45.92102
\.


--
-- TOC entry 4554 (class 0 OID 16463)
-- Dependencies: 222
-- Data for Name: logs; Type: TABLE DATA; Schema: public; Owner: blockscout
--

COPY public.logs (data, index, first_topic, second_topic, third_topic, fourth_topic, inserted_at, updated_at, address_hash, transaction_hash, block_hash, block_number) FROM stdin;
\.


--
-- TOC entry 4557 (class 0 OID 16528)
-- Dependencies: 225
-- Data for Name: market_history; Type: TABLE DATA; Schema: public; Owner: blockscout
--

COPY public.market_history (id, date, closing_price, opening_price, market_cap, tvl, secondary_coin) FROM stdin;
\.


--
-- TOC entry 4610 (class 0 OID 18655)
-- Dependencies: 278
-- Data for Name: massive_blocks; Type: TABLE DATA; Schema: public; Owner: blockscout
--

COPY public.massive_blocks (number, inserted_at, updated_at) FROM stdin;
\.


--
-- TOC entry 4606 (class 0 OID 18147)
-- Dependencies: 274
-- Data for Name: migrations_status; Type: TABLE DATA; Schema: public; Owner: blockscout
--

COPY public.migrations_status (migration_name, status, inserted_at, updated_at, meta) FROM stdin;
tb_token_type	completed	2025-06-24 21:23:44.914084	2025-06-24 21:23:44.920081	\N
tt_denormalization	completed	2025-06-24 21:23:44.914251	2025-06-24 21:23:44.920518	\N
ctb_token_type	completed	2025-06-24 21:23:44.914681	2025-06-24 21:23:44.921288	\N
sanitize_replaced_transactions	completed	2025-06-24 21:23:44.914747	2025-06-24 21:23:44.921919	\N
denormalization	completed	2025-06-24 21:23:44.913829	2025-06-24 21:23:44.921583	\N
sanitize_missing_token_balances	completed	2025-06-24 21:23:44.915198	2025-06-24 21:23:44.923844	\N
transactions_block_consensus	completed	2025-06-24 21:23:44.914644	2025-06-24 21:23:44.924187	\N
token_transfers_block_consensus	completed	2025-06-24 21:23:44.914614	2025-06-24 21:23:44.924014	\N
reindex_internal_transactions_with_incompatible_status	completed	2025-06-24 21:23:44.914429	2025-06-24 21:23:44.925434	\N
sanitize_incorrect_nft	completed	2025-06-24 21:23:44.914202	2025-06-24 21:23:44.931596	\N
backfill_erc721	completed	2025-06-24 21:23:44.966977	2025-06-24 21:23:44.973376	\N
backfill_erc1155	completed	2025-06-24 21:23:44.967327	2025-06-24 21:23:44.975081	\N
sanitize_missing_ranges	completed	2025-06-24 21:23:44.914425	2025-06-24 21:23:45.290036	\N
heavy_indexes_drop_token_transfers_block_number_asc_log_index_asc_index	completed	2025-06-24 21:23:44.925009	2025-06-24 21:24:43.439127	\N
heavy_indexes_drop_logs_block_number_asc__index_asc_index	completed	2025-06-24 21:23:44.924041	2025-06-24 21:24:43.439067	\N
heavy_indexes_drop_internal_transactions_from_address_hash_index	completed	2025-06-24 21:23:44.92475	2025-06-24 21:24:43.439292	\N
heavy_indexes_create_addresses_verified_index	completed	2025-06-24 21:23:44.925373	2025-06-24 21:24:43.440303	\N
sanitize_incorrect_weth_transfers	started	2025-06-24 21:23:44.914453	2025-06-24 21:29:45.912827	\N
heavy_indexes_create_internal_transactions_block_number_desc_transaction_index_desc_index_desc_index	started	2025-06-24 21:29:45.925049	2025-06-24 21:29:45.925049	\N
heavy_indexes_drop_token_transfers_from_address_hash_transaction_hash_index	started	2025-06-24 21:29:45.925367	2025-06-24 21:29:45.925367	\N
heavy_indexes_create_logs_block_hash_index	started	2025-06-24 21:29:45.925439	2025-06-24 21:29:45.925439	\N
\.


--
-- TOC entry 4613 (class 0 OID 18708)
-- Dependencies: 281
-- Data for Name: missing_balance_of_tokens; Type: TABLE DATA; Schema: public; Owner: blockscout
--

COPY public.missing_balance_of_tokens (token_contract_address_hash, block_number, inserted_at, updated_at, currently_implemented) FROM stdin;
\.


--
-- TOC entry 4602 (class 0 OID 18082)
-- Dependencies: 270
-- Data for Name: missing_block_ranges; Type: TABLE DATA; Schema: public; Owner: blockscout
--

COPY public.missing_block_ranges (id, from_number, to_number) FROM stdin;
\.


--
-- TOC entry 4585 (class 0 OID 17751)
-- Dependencies: 253
-- Data for Name: pending_block_operations; Type: TABLE DATA; Schema: public; Owner: blockscout
--

COPY public.pending_block_operations (block_hash, inserted_at, updated_at, block_number) FROM stdin;
\.


--
-- TOC entry 4612 (class 0 OID 18677)
-- Dependencies: 280
-- Data for Name: proxy_implementations; Type: TABLE DATA; Schema: public; Owner: blockscout
--

COPY public.proxy_implementations (proxy_address_hash, address_hashes, names, inserted_at, updated_at, proxy_type) FROM stdin;
\.


--
-- TOC entry 4607 (class 0 OID 18617)
-- Dependencies: 275
-- Data for Name: proxy_smart_contract_verification_statuses; Type: TABLE DATA; Schema: public; Owner: blockscout
--

COPY public.proxy_smart_contract_verification_statuses (uid, status, contract_address_hash, inserted_at, updated_at) FROM stdin;
\.


--
-- TOC entry 4616 (class 0 OID 18740)
-- Dependencies: 284
-- Data for Name: scam_address_badge_mappings; Type: TABLE DATA; Schema: public; Owner: blockscout
--

COPY public.scam_address_badge_mappings (address_hash, inserted_at, updated_at) FROM stdin;
\.


--
-- TOC entry 4550 (class 0 OID 16389)
-- Dependencies: 218
-- Data for Name: schema_migrations; Type: TABLE DATA; Schema: public; Owner: blockscout
--

COPY public.schema_migrations (version, inserted_at) FROM stdin;
20180117221921	2025-06-24 21:23:32
20180117221922	2025-06-24 21:23:32
20180117221923	2025-06-24 21:23:32
20180212222309	2025-06-24 21:23:33
20180221001948	2025-06-24 21:23:33
20180424203101	2025-06-24 21:23:33
20180508183700	2025-06-24 21:23:33
20180508191045	2025-06-24 21:23:33
20180518221256	2025-06-24 21:23:33
20180522154252	2025-06-24 21:23:33
20180522154253	2025-06-24 21:23:33
20180606135149	2025-06-24 21:23:33
20180606135150	2025-06-24 21:23:33
20180626143840	2025-06-24 21:23:33
20180717204948	2025-06-24 21:23:33
20180817021704	2025-06-24 21:23:33
20180821142139	2025-06-24 21:23:33
20180917182319	2025-06-24 21:23:33
20180918200001	2025-06-24 21:23:33
20180919175123	2025-06-24 21:23:33
20181008195723	2025-06-24 21:23:33
20181011193212	2025-06-24 21:23:33
20181015173318	2025-06-24 21:23:33
20181015173319	2025-06-24 21:23:33
20181016163236	2025-06-24 21:23:33
20181017141409	2025-06-24 21:23:33
20181024141113	2025-06-24 21:23:33
20181024164623	2025-06-24 21:23:33
20181024172010	2025-06-24 21:23:33
20181026180921	2025-06-24 21:23:33
20181029174420	2025-06-24 21:23:33
20181106152300	2025-06-24 21:23:33
20181107164103	2025-06-24 21:23:33
20181108205650	2025-06-24 21:23:33
20181121170616	2025-06-24 21:23:33
20181126203826	2025-06-24 21:23:33
20181206200140	2025-06-24 21:23:33
20181206200312	2025-06-24 21:23:33
20181212115448	2025-06-24 21:23:33
20181213111656	2025-06-24 21:23:33
20181221143000	2025-06-24 21:23:33
20181221145054	2025-06-24 21:23:33
20190102141900	2025-06-24 21:23:33
20190114204640	2025-06-24 21:23:33
20190116082843	2025-06-24 21:23:33
20190118040301	2025-06-24 21:23:33
20190118152240	2025-06-24 21:23:33
20190122125815	2025-06-24 21:23:33
20190124082812	2025-06-24 21:23:33
20190208113202	2025-06-24 21:23:33
20190208143201	2025-06-24 21:23:33
20190213180502	2025-06-24 21:23:33
20190214135850	2025-06-24 21:23:33
20190215080049	2025-06-24 21:23:33
20190215093358	2025-06-24 21:23:33
20190215105501	2025-06-24 21:23:33
20190219082636	2025-06-24 21:23:33
20190228102650	2025-06-24 21:23:33
20190228152333	2025-06-24 21:23:33
20190228220746	2025-06-24 21:23:33
20190301095620	2025-06-24 21:23:33
20190301120328	2025-06-24 21:23:33
20190305095926	2025-06-24 21:23:33
20190313085740	2025-06-24 21:23:34
20190313103912	2025-06-24 21:23:34
20190314084907	2025-06-24 21:23:34
20190318151809	2025-06-24 21:23:34
20190319081821	2025-06-24 21:23:34
20190321185644	2025-06-24 21:23:34
20190325081658	2025-06-24 21:23:34
20190403080447	2025-06-24 21:23:34
20190421143300	2025-06-24 21:23:34
20190424170833	2025-06-24 21:23:34
20190508152922	2025-06-24 21:23:34
20190513134025	2025-06-24 21:23:34
20190516140202	2025-06-24 21:23:34
20190516160535	2025-06-24 21:23:34
20190521104412	2025-06-24 21:23:34
20190523112839	2025-06-24 21:23:34
20190613065856	2025-06-24 21:23:34
20190619154943	2025-06-24 21:23:34
20190625085852	2025-06-24 21:23:34
20190709043832	2025-06-24 21:23:34
20190709103104	2025-06-24 21:23:34
20190807111216	2025-06-24 21:23:34
20190807113117	2025-06-24 21:23:34
20190827120224	2025-06-24 21:23:34
20190905083522	2025-06-24 21:23:34
20190910170703	2025-06-24 21:23:34
20191007082500	2025-06-24 21:23:34
20191009121635	2025-06-24 21:23:34
20191010075740	2025-06-24 21:23:34
20191018120546	2025-06-24 21:23:34
20191018140054	2025-06-24 21:23:34
20191121064805	2025-06-24 21:23:34
20191122062035	2025-06-24 21:23:34
20191128124415	2025-06-24 21:23:34
20191203112646	2025-06-24 21:23:34
20191208135613	2025-06-24 21:23:34
20191218120138	2025-06-24 21:23:34
20191220113006	2025-06-24 21:23:34
20200214152058	2025-06-24 21:23:34
20200410115841	2025-06-24 21:23:34
20200410141202	2025-06-24 21:23:34
20200421102450	2025-06-24 21:23:34
20200424070607	2025-06-24 21:23:34
20200518075748	2025-06-24 21:23:34
20200521090250	2025-06-24 21:23:34
20200521170002	2025-06-24 21:23:34
20200525115811	2025-06-24 21:23:34
20200527144742	2025-06-24 21:23:34
20200608075122	2025-06-24 21:23:34
20200806125649	2025-06-24 21:23:34
20200807064700	2025-06-24 21:23:34
20200812143050	2025-06-24 21:23:34
20200904075501	2025-06-24 21:23:34
20200929075625	2025-06-24 21:23:34
20201026093652	2025-06-24 21:23:34
20201214203532	2025-06-24 21:23:34
20210219080523	2025-06-24 21:23:34
20210226154732	2025-06-24 21:23:34
20210309104122	2025-06-24 21:23:34
20210331074008	2025-06-24 21:23:34
20210422115740	2025-06-24 21:23:34
20210423084253	2025-06-24 21:23:34
20210423091652	2025-06-24 21:23:34
20210423094801	2025-06-24 21:23:34
20210423115108	2025-06-24 21:23:34
20210524165427	2025-06-24 21:23:34
20210527093756	2025-06-24 21:23:34
20210616120552	2025-06-24 21:23:34
20210701084814	2025-06-24 21:23:34
20210811140837	2025-06-24 21:23:34
20210823144531	2025-06-24 21:23:34
20210916194004	2025-06-24 21:23:34
20211006121008	2025-06-24 21:23:34
20211013190346	2025-06-24 21:23:34
20211017135545	2025-06-24 21:23:34
20211018072347	2025-06-24 21:23:34
20211018073652	2025-06-24 21:23:34
20211018164843	2025-06-24 21:23:34
20211018170533	2025-06-24 21:23:34
20211018170638	2025-06-24 21:23:34
20211029085117	2025-06-24 21:23:34
20211115164817	2025-06-24 21:23:34
20211203115010	2025-06-24 21:23:34
20211204184037	2025-06-24 21:23:34
20211206071033	2025-06-24 21:23:34
20211210184136	2025-06-24 21:23:34
20211217201759	2025-06-24 21:23:34
20220111085751	2025-06-24 21:23:34
20220303083252	2025-06-24 21:23:35
20220306091504	2025-06-24 21:23:35
20220527131249	2025-06-24 21:23:35
20220622114402	2025-06-24 21:23:35
20220622140604	2025-06-24 21:23:35
20220706101103	2025-06-24 21:23:35
20220706102257	2025-06-24 21:23:35
20220706102504	2025-06-24 21:23:35
20220706102746	2025-06-24 21:23:35
20220706105925	2025-06-24 21:23:35
20220706111510	2025-06-24 21:23:35
20220804114005	2025-06-24 21:23:35
20220902083436	2025-06-24 21:23:35
20220902103213	2025-06-24 21:23:35
20220902103527	2025-06-24 21:23:35
20220919105140	2025-06-24 21:23:35
20220926122620	2025-06-24 21:23:35
20221104091552	2025-06-24 21:23:35
20221104104635	2025-06-24 21:23:35
20221114113853	2025-06-24 21:23:35
20221114121811	2025-06-24 21:23:35
20221117075456	2025-06-24 21:23:35
20221117080657	2025-06-24 21:23:35
20221120184715	2025-06-24 21:23:35
20221125074820	2025-06-24 21:23:35
20221126103223	2025-06-24 21:23:35
20221209123459	2025-06-24 21:23:35
20221212093406	2025-06-24 21:23:35
20221219151744	2025-06-24 21:23:35
20221223151234	2025-06-24 21:23:35
20221223214711	2025-06-24 21:23:35
20230126205627	2025-06-24 21:23:35
20230214104917	2025-06-24 21:23:35
20230217095226	2025-06-24 21:23:35
20230328100414	2025-06-24 21:23:35
20230417093914	2025-06-24 21:23:35
20230425185941	2025-06-24 21:23:35
20230522130735	2025-06-24 21:23:35
20230530074105	2025-06-24 21:23:35
20230605080138	2025-06-24 21:23:35
20230606091935	2025-06-24 21:23:35
20230613181244	2025-06-24 21:23:35
20230615130940	2025-06-24 21:23:35
20230719160318	2025-06-24 21:23:35
20230809134253	2025-06-24 21:23:35
20230815131151	2025-06-24 21:23:35
20230816061723	2025-06-24 21:23:35
20230817061317	2025-06-24 21:23:35
20230818094455	2025-06-24 21:23:35
20230821120625	2025-06-24 21:23:35
20230831122819	2025-06-24 21:23:35
20230905085809	2025-06-24 21:23:35
20231003093553	2025-06-24 21:23:35
20231212101547	2025-06-24 21:23:35
20231212102127	2025-06-24 21:23:35
20231213085254	2025-06-24 21:23:35
20240114181404	2025-06-24 21:23:35
20240122102141	2025-06-24 21:23:35
20240224112210	2025-06-24 21:23:35
20240226074456	2025-06-24 21:23:35
20240226151331	2025-06-24 21:23:35
20240227115149	2025-06-24 21:23:35
20240313195728	2025-06-24 21:23:35
20240322115647	2025-06-24 21:23:35
20240325195446	2025-06-24 21:23:35
20240403151126	2025-06-24 21:23:36
20240404102511	2025-06-24 21:23:36
20240417141515	2025-06-24 21:23:36
20240418140425	2025-06-24 21:23:36
20240419095711	2025-06-24 21:23:36
20240419101821	2025-06-24 21:23:36
20240419102345	2025-06-24 21:23:36
20240425091614	2025-06-24 21:23:36
20240425185705	2025-06-24 21:23:36
20240501131140	2025-06-24 21:23:36
20240502064431	2025-06-24 21:23:36
20240503091708	2025-06-24 21:23:36
20240509014500	2025-06-24 21:23:36
20240520075414	2025-06-24 21:23:36
20240527152734	2025-06-24 21:23:36
20240708152519	2025-06-24 21:23:36
20240718150123	2025-06-24 21:23:36
20240806162644	2025-06-24 21:23:36
20240828140638	2025-06-24 21:23:36
20240830142652	2025-06-24 21:23:36
20240904161254	2025-06-24 21:23:36
20240910095635	2025-06-24 21:23:36
20240918104231	2025-06-24 21:23:36
20240923135258	2025-06-24 21:23:36
20240923173516	2025-06-24 21:23:36
20241002125432	2025-06-24 21:23:36
20241015140214	2025-06-24 21:23:36
20241022133006	2025-06-24 21:23:36
20241111200520	2025-06-24 21:23:36
20241216112656	2025-06-24 21:23:36
20241219102223	2025-06-24 21:23:36
20250119145532	2025-06-24 21:23:36
20250121142849	2025-06-24 21:23:36
20250128081221	2025-06-24 21:23:36
20250214102221	2025-06-24 21:23:36
20231213090140	2025-06-24 21:23:35
20231213101235	2025-06-24 21:23:35
20231213152332	2025-06-24 21:23:35
20231215094615	2025-06-24 21:23:35
20231215104320	2025-06-24 21:23:35
20231215115638	2025-06-24 21:23:35
20231215132609	2025-06-24 21:23:35
20231225113850	2025-06-24 21:23:35
20231225115026	2025-06-24 21:23:35
20231225115100	2025-06-24 21:23:35
20231227170848	2025-06-24 21:23:35
20231229120232	2025-06-24 21:23:35
20240103094720	2025-06-24 21:23:35
20240123102336	2025-06-24 21:23:35
20240129112623	2025-06-24 21:23:35
20240219143204	2025-06-24 21:23:35
20240219152810	2025-06-24 21:23:35
20240308123508	2025-06-24 21:23:35
20240403151125	2025-06-24 21:23:35
20240404102510	2025-06-24 21:23:36
20240418135458	2025-06-24 21:23:36
20211031164954	2025-06-24 21:23:36
20211105114502	2025-06-24 21:23:36
20211105130907	2025-06-24 21:23:36
20211127212336	2025-06-24 21:23:36
20211205220414	2025-06-24 21:23:36
20220212222222	2025-06-24 21:23:36
20220313133333	2025-06-24 21:23:36
20220324213333	2025-06-24 21:23:36
20220407134152	2025-06-24 21:23:36
20220510094118	2025-06-24 21:23:36
20220606194836	2025-06-24 21:23:36
20220620182600	2025-06-24 21:23:36
20220624142547	2025-06-24 21:23:36
20220705195240	2025-06-24 21:23:37
20220706114430	2025-06-24 21:23:37
20220706153506	2025-06-24 21:23:37
20220706211444	2025-06-24 21:23:37
20220905195203	2025-06-24 21:23:37
20230502083519	2025-06-24 21:23:37
20231207201701	2025-06-24 21:23:37
20240219152220	2025-06-24 21:23:37
20240913194307	2025-06-24 21:23:37
20241015091450	2025-06-24 21:23:37
20241121140138	2025-06-24 21:23:37
20241128100836	2025-06-24 21:23:37
20241204093817	2025-06-24 21:23:37
\.


--
-- TOC entry 4615 (class 0 OID 18727)
-- Dependencies: 283
-- Data for Name: signed_authorizations; Type: TABLE DATA; Schema: public; Owner: blockscout
--

COPY public.signed_authorizations (transaction_hash, index, chain_id, address, nonce, v, r, s, authority, inserted_at, updated_at) FROM stdin;
\.


--
-- TOC entry 4609 (class 0 OID 18630)
-- Dependencies: 277
-- Data for Name: smart_contract_audit_reports; Type: TABLE DATA; Schema: public; Owner: blockscout
--

COPY public.smart_contract_audit_reports (id, address_hash, is_approved, submitter_name, submitter_email, is_project_owner, project_name, project_url, audit_company_name, audit_report_url, audit_publish_date, request_id, comment, inserted_at, updated_at) FROM stdin;
\.


--
-- TOC entry 4563 (class 0 OID 16565)
-- Dependencies: 231
-- Data for Name: smart_contracts; Type: TABLE DATA; Schema: public; Owner: blockscout
--

COPY public.smart_contracts (id, name, compiler_version, optimization, contract_source_code, abi, address_hash, inserted_at, updated_at, constructor_arguments, optimization_runs, evm_version, external_libraries, verified_via_sourcify, is_vyper_contract, partially_verified, file_path, is_changed_bytecode, bytecode_checked_at, contract_code_md5, compiler_settings, verified_via_eth_bytecode_db, license_type, verified_via_verifier_alliance, certified, is_blueprint, language) FROM stdin;
\.


--
-- TOC entry 4589 (class 0 OID 17861)
-- Dependencies: 257
-- Data for Name: smart_contracts_additional_sources; Type: TABLE DATA; Schema: public; Owner: blockscout
--

COPY public.smart_contracts_additional_sources (id, file_name, contract_source_code, address_hash, inserted_at, updated_at) FROM stdin;
\.


--
-- TOC entry 4614 (class 0 OID 18716)
-- Dependencies: 282
-- Data for Name: token_instance_metadata_refetch_attempts; Type: TABLE DATA; Schema: public; Owner: blockscout
--

COPY public.token_instance_metadata_refetch_attempts (token_contract_address_hash, token_id, retries_number, inserted_at, updated_at) FROM stdin;
\.


--
-- TOC entry 4584 (class 0 OID 17734)
-- Dependencies: 252
-- Data for Name: token_instances; Type: TABLE DATA; Schema: public; Owner: blockscout
--

COPY public.token_instances (token_id, token_contract_address_hash, metadata, inserted_at, updated_at, error, owner_address_hash, owner_updated_at_block, owner_updated_at_log_index, refetch_after, retries_count, thumbnails, media_type, cdn_upload_error, is_banned) FROM stdin;
\.


--
-- TOC entry 4600 (class 0 OID 18068)
-- Dependencies: 268
-- Data for Name: token_transfer_token_id_migrator_progress; Type: TABLE DATA; Schema: public; Owner: blockscout
--

COPY public.token_transfer_token_id_migrator_progress (id, last_processed_block_number, inserted_at, updated_at) FROM stdin;
\.


--
-- TOC entry 4566 (class 0 OID 17249)
-- Dependencies: 234
-- Data for Name: token_transfers; Type: TABLE DATA; Schema: public; Owner: blockscout
--

COPY public.token_transfers (transaction_hash, log_index, from_address_hash, to_address_hash, amount, token_contract_address_hash, inserted_at, updated_at, block_number, block_hash, amounts, token_ids, token_type, block_consensus) FROM stdin;
\.


--
-- TOC entry 4565 (class 0 OID 17236)
-- Dependencies: 233
-- Data for Name: tokens; Type: TABLE DATA; Schema: public; Owner: blockscout
--

COPY public.tokens (name, symbol, total_supply, decimals, type, cataloged, contract_address_hash, inserted_at, updated_at, holder_count, skip_metadata, fiat_value, circulating_market_cap, total_supply_updated_at_block, icon_url, is_verified_via_admin_panel, volume_24h, metadata_updated_at) FROM stdin;
\.


--
-- TOC entry 4598 (class 0 OID 18053)
-- Dependencies: 266
-- Data for Name: transaction_actions; Type: TABLE DATA; Schema: public; Owner: blockscout
--

COPY public.transaction_actions (hash, protocol, data, type, log_index, inserted_at, updated_at) FROM stdin;
\.


--
-- TOC entry 4572 (class 0 OID 17338)
-- Dependencies: 240
-- Data for Name: transaction_forks; Type: TABLE DATA; Schema: public; Owner: blockscout
--

COPY public.transaction_forks (hash, index, uncle_hash, inserted_at, updated_at) FROM stdin;
\.


--
-- TOC entry 4583 (class 0 OID 17723)
-- Dependencies: 251
-- Data for Name: transaction_stats; Type: TABLE DATA; Schema: public; Owner: blockscout
--

COPY public.transaction_stats (id, date, number_of_transactions, gas_used, total_fee) FROM stdin;
1	2025-06-24	0	0	0
2	2025-06-23	0	0	0
3	2025-06-22	0	0	0
4	2025-06-21	0	0	0
5	2025-06-20	0	0	0
6	2025-06-19	0	0	0
7	2025-06-18	0	0	0
8	2025-06-17	0	0	0
9	2025-06-16	0	0	0
10	2025-06-15	0	0	0
\.


--
-- TOC entry 4553 (class 0 OID 16416)
-- Dependencies: 221
-- Data for Name: transactions; Type: TABLE DATA; Schema: public; Owner: blockscout
--

COPY public.transactions (cumulative_gas_used, error, gas, gas_price, gas_used, hash, index, input, nonce, r, s, status, v, value, inserted_at, updated_at, block_hash, block_number, from_address_hash, to_address_hash, created_contract_address_hash, created_contract_code_indexed_at, earliest_processing_start, old_block_hash, revert_reason, max_priority_fee_per_gas, max_fee_per_gas, type, has_error_in_internal_transactions, block_timestamp, block_consensus) FROM stdin;
\.


--
-- TOC entry 4561 (class 0 OID 16548)
-- Dependencies: 229
-- Data for Name: user_contacts; Type: TABLE DATA; Schema: public; Owner: blockscout
--

COPY public.user_contacts (id, email, user_id, "primary", verified, inserted_at, updated_at) FROM stdin;
\.


--
-- TOC entry 4559 (class 0 OID 16538)
-- Dependencies: 227
-- Data for Name: users; Type: TABLE DATA; Schema: public; Owner: blockscout
--

COPY public.users (id, username, password_hash, inserted_at, updated_at) FROM stdin;
\.


--
-- TOC entry 4605 (class 0 OID 18116)
-- Dependencies: 273
-- Data for Name: validators; Type: TABLE DATA; Schema: public; Owner: blockscout
--

COPY public.validators (address_hash, is_validator, payout_key_hash, info_updated_at_block, inserted_at, updated_at) FROM stdin;
\.


--
-- TOC entry 4603 (class 0 OID 18090)
-- Dependencies: 271
-- Data for Name: withdrawals; Type: TABLE DATA; Schema: public; Owner: blockscout
--

COPY public.withdrawals (index, validator_index, amount, inserted_at, updated_at, address_hash, block_hash) FROM stdin;
\.


--
-- TOC entry 4674 (class 0 OID 0)
-- Dependencies: 298
-- Name: account_api_plans_id_seq; Type: SEQUENCE SET; Schema: public; Owner: blockscout
--

SELECT pg_catalog.setval('public.account_api_plans_id_seq', 1, false);


--
-- TOC entry 4675 (class 0 OID 0)
-- Dependencies: 301
-- Name: account_custom_abis_id_seq; Type: SEQUENCE SET; Schema: public; Owner: blockscout
--

SELECT pg_catalog.setval('public.account_custom_abis_id_seq', 1, false);


--
-- TOC entry 4676 (class 0 OID 0)
-- Dependencies: 286
-- Name: account_identities_id_seq; Type: SEQUENCE SET; Schema: public; Owner: blockscout
--

SELECT pg_catalog.setval('public.account_identities_id_seq', 1, false);


--
-- TOC entry 4677 (class 0 OID 0)
-- Dependencies: 303
-- Name: account_public_tags_requests_id_seq; Type: SEQUENCE SET; Schema: public; Owner: blockscout
--

SELECT pg_catalog.setval('public.account_public_tags_requests_id_seq', 1, false);


--
-- TOC entry 4678 (class 0 OID 0)
-- Dependencies: 294
-- Name: account_tag_addresses_id_seq; Type: SEQUENCE SET; Schema: public; Owner: blockscout
--

SELECT pg_catalog.setval('public.account_tag_addresses_id_seq', 1, false);


--
-- TOC entry 4679 (class 0 OID 0)
-- Dependencies: 296
-- Name: account_tag_transactions_id_seq; Type: SEQUENCE SET; Schema: public; Owner: blockscout
--

SELECT pg_catalog.setval('public.account_tag_transactions_id_seq', 1, false);


--
-- TOC entry 4680 (class 0 OID 0)
-- Dependencies: 290
-- Name: account_watchlist_addresses_id_seq; Type: SEQUENCE SET; Schema: public; Owner: blockscout
--

SELECT pg_catalog.setval('public.account_watchlist_addresses_id_seq', 1, false);


--
-- TOC entry 4681 (class 0 OID 0)
-- Dependencies: 292
-- Name: account_watchlist_notifications_id_seq; Type: SEQUENCE SET; Schema: public; Owner: blockscout
--

SELECT pg_catalog.setval('public.account_watchlist_notifications_id_seq', 1, false);


--
-- TOC entry 4682 (class 0 OID 0)
-- Dependencies: 305
-- Name: account_watchlist_notifications_watchlist_id_seq; Type: SEQUENCE SET; Schema: public; Owner: blockscout
--

SELECT pg_catalog.setval('public.account_watchlist_notifications_watchlist_id_seq', 1, false);


--
-- TOC entry 4683 (class 0 OID 0)
-- Dependencies: 288
-- Name: account_watchlists_id_seq; Type: SEQUENCE SET; Schema: public; Owner: blockscout
--

SELECT pg_catalog.setval('public.account_watchlists_id_seq', 1, false);


--
-- TOC entry 4684 (class 0 OID 0)
-- Dependencies: 243
-- Name: address_current_token_balances_id_seq; Type: SEQUENCE SET; Schema: public; Owner: blockscout
--

SELECT pg_catalog.setval('public.address_current_token_balances_id_seq', 1, false);


--
-- TOC entry 4685 (class 0 OID 0)
-- Dependencies: 263
-- Name: address_names_id_seq; Type: SEQUENCE SET; Schema: public; Owner: blockscout
--

SELECT pg_catalog.setval('public.address_names_id_seq', 1, false);


--
-- TOC entry 4686 (class 0 OID 0)
-- Dependencies: 258
-- Name: address_tags_id_seq; Type: SEQUENCE SET; Schema: public; Owner: blockscout
--

SELECT pg_catalog.setval('public.address_tags_id_seq', 1, false);


--
-- TOC entry 4687 (class 0 OID 0)
-- Dependencies: 260
-- Name: address_to_tags_id_seq; Type: SEQUENCE SET; Schema: public; Owner: blockscout
--

SELECT pg_catalog.setval('public.address_to_tags_id_seq', 1, false);


--
-- TOC entry 4688 (class 0 OID 0)
-- Dependencies: 236
-- Name: address_token_balances_id_seq; Type: SEQUENCE SET; Schema: public; Owner: blockscout
--

SELECT pg_catalog.setval('public.address_token_balances_id_seq', 1, false);


--
-- TOC entry 4689 (class 0 OID 0)
-- Dependencies: 241
-- Name: administrators_id_seq; Type: SEQUENCE SET; Schema: public; Owner: blockscout
--

SELECT pg_catalog.setval('public.administrators_id_seq', 1, false);


--
-- TOC entry 4690 (class 0 OID 0)
-- Dependencies: 246
-- Name: contract_methods_id_seq; Type: SEQUENCE SET; Schema: public; Owner: blockscout
--

SELECT pg_catalog.setval('public.contract_methods_id_seq', 1, false);


--
-- TOC entry 4691 (class 0 OID 0)
-- Dependencies: 248
-- Name: decompiled_smart_contracts_id_seq; Type: SEQUENCE SET; Schema: public; Owner: blockscout
--

SELECT pg_catalog.setval('public.decompiled_smart_contracts_id_seq', 1, false);


--
-- TOC entry 4692 (class 0 OID 0)
-- Dependencies: 264
-- Name: event_notifications_id_seq; Type: SEQUENCE SET; Schema: public; Owner: blockscout
--

SELECT pg_catalog.setval('public.event_notifications_id_seq', 1, false);


--
-- TOC entry 4693 (class 0 OID 0)
-- Dependencies: 224
-- Name: market_history_id_seq; Type: SEQUENCE SET; Schema: public; Owner: blockscout
--

SELECT pg_catalog.setval('public.market_history_id_seq', 1, false);


--
-- TOC entry 4694 (class 0 OID 0)
-- Dependencies: 269
-- Name: missing_block_ranges_id_seq; Type: SEQUENCE SET; Schema: public; Owner: blockscout
--

SELECT pg_catalog.setval('public.missing_block_ranges_id_seq', 1, false);


--
-- TOC entry 4695 (class 0 OID 0)
-- Dependencies: 276
-- Name: smart_contract_audit_reports_id_seq; Type: SEQUENCE SET; Schema: public; Owner: blockscout
--

SELECT pg_catalog.setval('public.smart_contract_audit_reports_id_seq', 1, false);


--
-- TOC entry 4696 (class 0 OID 0)
-- Dependencies: 256
-- Name: smart_contracts_additional_sources_id_seq; Type: SEQUENCE SET; Schema: public; Owner: blockscout
--

SELECT pg_catalog.setval('public.smart_contracts_additional_sources_id_seq', 1, false);


--
-- TOC entry 4697 (class 0 OID 0)
-- Dependencies: 230
-- Name: smart_contracts_id_seq; Type: SEQUENCE SET; Schema: public; Owner: blockscout
--

SELECT pg_catalog.setval('public.smart_contracts_id_seq', 1, false);


--
-- TOC entry 4698 (class 0 OID 0)
-- Dependencies: 267
-- Name: token_transfer_token_id_migrator_progress_id_seq; Type: SEQUENCE SET; Schema: public; Owner: blockscout
--

SELECT pg_catalog.setval('public.token_transfer_token_id_migrator_progress_id_seq', 1, false);


--
-- TOC entry 4699 (class 0 OID 0)
-- Dependencies: 250
-- Name: transaction_stats_id_seq; Type: SEQUENCE SET; Schema: public; Owner: blockscout
--

SELECT pg_catalog.setval('public.transaction_stats_id_seq', 30, true);


--
-- TOC entry 4700 (class 0 OID 0)
-- Dependencies: 228
-- Name: user_contacts_id_seq; Type: SEQUENCE SET; Schema: public; Owner: blockscout
--

SELECT pg_catalog.setval('public.user_contacts_id_seq', 1, false);


--
-- TOC entry 4701 (class 0 OID 0)
-- Dependencies: 226
-- Name: users_id_seq; Type: SEQUENCE SET; Schema: public; Owner: blockscout
--

SELECT pg_catalog.setval('public.users_id_seq', 1, false);


--
-- TOC entry 4370 (class 2606 OID 18893)
-- Name: account_api_keys account_api_keys_pkey; Type: CONSTRAINT; Schema: public; Owner: blockscout
--

ALTER TABLE ONLY public.account_api_keys
    ADD CONSTRAINT account_api_keys_pkey PRIMARY KEY (value);


--
-- TOC entry 4367 (class 2606 OID 18887)
-- Name: account_api_plans account_api_plans_pkey; Type: CONSTRAINT; Schema: public; Owner: blockscout
--

ALTER TABLE ONLY public.account_api_plans
    ADD CONSTRAINT account_api_plans_pkey PRIMARY KEY (id);


--
-- TOC entry 4374 (class 2606 OID 18914)
-- Name: account_custom_abis account_custom_abis_pkey; Type: CONSTRAINT; Schema: public; Owner: blockscout
--

ALTER TABLE ONLY public.account_custom_abis
    ADD CONSTRAINT account_custom_abis_pkey PRIMARY KEY (id);


--
-- TOC entry 4338 (class 2606 OID 18785)
-- Name: account_identities account_identities_pkey; Type: CONSTRAINT; Schema: public; Owner: blockscout
--

ALTER TABLE ONLY public.account_identities
    ADD CONSTRAINT account_identities_pkey PRIMARY KEY (id);


--
-- TOC entry 4376 (class 2606 OID 18930)
-- Name: account_public_tags_requests account_public_tags_requests_pkey; Type: CONSTRAINT; Schema: public; Owner: blockscout
--

ALTER TABLE ONLY public.account_public_tags_requests
    ADD CONSTRAINT account_public_tags_requests_pkey PRIMARY KEY (id);


--
-- TOC entry 4359 (class 2606 OID 18857)
-- Name: account_tag_addresses account_tag_addresses_pkey; Type: CONSTRAINT; Schema: public; Owner: blockscout
--

ALTER TABLE ONLY public.account_tag_addresses
    ADD CONSTRAINT account_tag_addresses_pkey PRIMARY KEY (id);


--
-- TOC entry 4363 (class 2606 OID 18873)
-- Name: account_tag_transactions account_tag_transactions_pkey; Type: CONSTRAINT; Schema: public; Owner: blockscout
--

ALTER TABLE ONLY public.account_tag_transactions
    ADD CONSTRAINT account_tag_transactions_pkey PRIMARY KEY (id);


--
-- TOC entry 4345 (class 2606 OID 18821)
-- Name: account_watchlist_addresses account_watchlist_addresses_pkey; Type: CONSTRAINT; Schema: public; Owner: blockscout
--

ALTER TABLE ONLY public.account_watchlist_addresses
    ADD CONSTRAINT account_watchlist_addresses_pkey PRIMARY KEY (id);


--
-- TOC entry 4350 (class 2606 OID 18837)
-- Name: account_watchlist_notifications account_watchlist_notifications_pkey; Type: CONSTRAINT; Schema: public; Owner: blockscout
--

ALTER TABLE ONLY public.account_watchlist_notifications
    ADD CONSTRAINT account_watchlist_notifications_pkey PRIMARY KEY (id);


--
-- TOC entry 4342 (class 2606 OID 18794)
-- Name: account_watchlists account_watchlists_pkey; Type: CONSTRAINT; Schema: public; Owner: blockscout
--

ALTER TABLE ONLY public.account_watchlists
    ADD CONSTRAINT account_watchlists_pkey PRIMARY KEY (id);


--
-- TOC entry 4275 (class 2606 OID 17950)
-- Name: address_coin_balances_daily address_coin_balances_daily_pkey; Type: CONSTRAINT; Schema: public; Owner: blockscout
--

ALTER TABLE ONLY public.address_coin_balances_daily
    ADD CONSTRAINT address_coin_balances_daily_pkey PRIMARY KEY (address_hash, day);


--
-- TOC entry 4219 (class 2606 OID 17958)
-- Name: address_coin_balances address_coin_balances_pkey; Type: CONSTRAINT; Schema: public; Owner: blockscout
--

ALTER TABLE ONLY public.address_coin_balances
    ADD CONSTRAINT address_coin_balances_pkey PRIMARY KEY (address_hash, block_number);


--
-- TOC entry 4323 (class 2606 OID 18671)
-- Name: address_contract_code_fetch_attempts address_contract_code_fetch_attempts_pkey; Type: CONSTRAINT; Schema: public; Owner: blockscout
--

ALTER TABLE ONLY public.address_contract_code_fetch_attempts
    ADD CONSTRAINT address_contract_code_fetch_attempts_pkey PRIMARY KEY (address_hash);


--
-- TOC entry 4247 (class 2606 OID 17500)
-- Name: address_current_token_balances address_current_token_balances_pkey; Type: CONSTRAINT; Schema: public; Owner: blockscout
--

ALTER TABLE ONLY public.address_current_token_balances
    ADD CONSTRAINT address_current_token_balances_pkey PRIMARY KEY (id);


--
-- TOC entry 4232 (class 2606 OID 17986)
-- Name: address_names address_names_pkey; Type: CONSTRAINT; Schema: public; Owner: blockscout
--

ALTER TABLE ONLY public.address_names
    ADD CONSTRAINT address_names_pkey PRIMARY KEY (id);


--
-- TOC entry 4284 (class 2606 OID 18756)
-- Name: address_tags address_tags_pkey; Type: CONSTRAINT; Schema: public; Owner: blockscout
--

ALTER TABLE ONLY public.address_tags
    ADD CONSTRAINT address_tags_pkey PRIMARY KEY (label);


--
-- TOC entry 4287 (class 2606 OID 17890)
-- Name: address_to_tags address_to_tags_pkey; Type: CONSTRAINT; Schema: public; Owner: blockscout
--

ALTER TABLE ONLY public.address_to_tags
    ADD CONSTRAINT address_to_tags_pkey PRIMARY KEY (id);


--
-- TOC entry 4225 (class 2606 OID 17304)
-- Name: address_token_balances address_token_balances_pkey; Type: CONSTRAINT; Schema: public; Owner: blockscout
--

ALTER TABLE ONLY public.address_token_balances
    ADD CONSTRAINT address_token_balances_pkey PRIMARY KEY (id);


--
-- TOC entry 4120 (class 2606 OID 16400)
-- Name: addresses addresses_pkey; Type: CONSTRAINT; Schema: public; Owner: blockscout
--

ALTER TABLE ONLY public.addresses
    ADD CONSTRAINT addresses_pkey PRIMARY KEY (hash);


--
-- TOC entry 4242 (class 2606 OID 17367)
-- Name: administrators administrators_pkey; Type: CONSTRAINT; Schema: public; Owner: blockscout
--

ALTER TABLE ONLY public.administrators
    ADD CONSTRAINT administrators_pkey PRIMARY KEY (id);


--
-- TOC entry 4254 (class 2606 OID 17978)
-- Name: block_rewards block_rewards_pkey; Type: CONSTRAINT; Schema: public; Owner: blockscout
--

ALTER TABLE ONLY public.block_rewards
    ADD CONSTRAINT block_rewards_pkey PRIMARY KEY (address_hash, block_hash, address_type);


--
-- TOC entry 4235 (class 2606 OID 17558)
-- Name: block_second_degree_relations block_second_degree_relations_pkey; Type: CONSTRAINT; Schema: public; Owner: blockscout
--

ALTER TABLE ONLY public.block_second_degree_relations
    ADD CONSTRAINT block_second_degree_relations_pkey PRIMARY KEY (nephew_hash, uncle_hash);


--
-- TOC entry 4130 (class 2606 OID 16407)
-- Name: blocks blocks_pkey; Type: CONSTRAINT; Schema: public; Owner: blockscout
--

ALTER TABLE ONLY public.blocks
    ADD CONSTRAINT blocks_pkey PRIMARY KEY (hash);


--
-- TOC entry 4108 (class 2606 OID 17520)
-- Name: internal_transactions call_has_call_type; Type: CHECK CONSTRAINT; Schema: public; Owner: blockscout
--

ALTER TABLE public.internal_transactions
    ADD CONSTRAINT call_has_call_type CHECK ((((type)::text <> 'call'::text) OR (call_type IS NOT NULL))) NOT VALID;


--
-- TOC entry 4110 (class 2606 OID 17521)
-- Name: internal_transactions call_has_input; Type: CHECK CONSTRAINT; Schema: public; Owner: blockscout
--

ALTER TABLE public.internal_transactions
    ADD CONSTRAINT call_has_input CHECK ((((type)::text <> 'call'::text) OR (input IS NOT NULL))) NOT VALID;


--
-- TOC entry 4308 (class 2606 OID 18115)
-- Name: constants constants_pkey; Type: CONSTRAINT; Schema: public; Owner: blockscout
--

ALTER TABLE ONLY public.constants
    ADD CONSTRAINT constants_pkey PRIMARY KEY (key);


--
-- TOC entry 4258 (class 2606 OID 17551)
-- Name: contract_methods contract_methods_pkey; Type: CONSTRAINT; Schema: public; Owner: blockscout
--

ALTER TABLE ONLY public.contract_methods
    ADD CONSTRAINT contract_methods_pkey PRIMARY KEY (id);


--
-- TOC entry 4289 (class 2606 OID 17930)
-- Name: contract_verification_status contract_verification_status_pkey; Type: CONSTRAINT; Schema: public; Owner: blockscout
--

ALTER TABLE ONLY public.contract_verification_status
    ADD CONSTRAINT contract_verification_status_pkey PRIMARY KEY (uid);


--
-- TOC entry 4112 (class 2606 OID 17522)
-- Name: internal_transactions create_has_init; Type: CHECK CONSTRAINT; Schema: public; Owner: blockscout
--

ALTER TABLE public.internal_transactions
    ADD CONSTRAINT create_has_init CHECK ((((type)::text <> 'create'::text) OR (init IS NOT NULL))) NOT VALID;


--
-- TOC entry 4261 (class 2606 OID 17601)
-- Name: decompiled_smart_contracts decompiled_smart_contracts_pkey; Type: CONSTRAINT; Schema: public; Owner: blockscout
--

ALTER TABLE ONLY public.decompiled_smart_contracts
    ADD CONSTRAINT decompiled_smart_contracts_pkey PRIMARY KEY (id);


--
-- TOC entry 4194 (class 2606 OID 17982)
-- Name: emission_rewards emission_rewards_pkey; Type: CONSTRAINT; Schema: public; Owner: blockscout
--

ALTER TABLE ONLY public.emission_rewards
    ADD CONSTRAINT emission_rewards_pkey PRIMARY KEY (block_range);


--
-- TOC entry 4291 (class 2606 OID 18003)
-- Name: event_notifications event_notifications_pkey; Type: CONSTRAINT; Schema: public; Owner: blockscout
--

ALTER TABLE ONLY public.event_notifications
    ADD CONSTRAINT event_notifications_pkey PRIMARY KEY (id);


--
-- TOC entry 4174 (class 2606 OID 17766)
-- Name: internal_transactions internal_transactions_pkey; Type: CONSTRAINT; Schema: public; Owner: blockscout
--

ALTER TABLE ONLY public.internal_transactions
    ADD CONSTRAINT internal_transactions_pkey PRIMARY KEY (block_hash, block_index);


--
-- TOC entry 4277 (class 2606 OID 17847)
-- Name: last_fetched_counters last_fetched_counters_pkey; Type: CONSTRAINT; Schema: public; Owner: blockscout
--

ALTER TABLE ONLY public.last_fetched_counters
    ADD CONSTRAINT last_fetched_counters_pkey PRIMARY KEY (counter_type);


--
-- TOC entry 4165 (class 2606 OID 17779)
-- Name: logs logs_pkey; Type: CONSTRAINT; Schema: public; Owner: blockscout
--

ALTER TABLE ONLY public.logs
    ADD CONSTRAINT logs_pkey PRIMARY KEY (transaction_hash, block_hash, index);


--
-- TOC entry 4179 (class 2606 OID 16535)
-- Name: market_history market_history_pkey; Type: CONSTRAINT; Schema: public; Owner: blockscout
--

ALTER TABLE ONLY public.market_history
    ADD CONSTRAINT market_history_pkey PRIMARY KEY (id);


--
-- TOC entry 4320 (class 2606 OID 18659)
-- Name: massive_blocks massive_blocks_pkey; Type: CONSTRAINT; Schema: public; Owner: blockscout
--

ALTER TABLE ONLY public.massive_blocks
    ADD CONSTRAINT massive_blocks_pkey PRIMARY KEY (number);


--
-- TOC entry 4312 (class 2606 OID 18153)
-- Name: migrations_status migrations_status_pkey; Type: CONSTRAINT; Schema: public; Owner: blockscout
--

ALTER TABLE ONLY public.migrations_status
    ADD CONSTRAINT migrations_status_pkey PRIMARY KEY (migration_name);


--
-- TOC entry 4328 (class 2606 OID 18714)
-- Name: missing_balance_of_tokens missing_balance_of_tokens_pkey; Type: CONSTRAINT; Schema: public; Owner: blockscout
--

ALTER TABLE ONLY public.missing_balance_of_tokens
    ADD CONSTRAINT missing_balance_of_tokens_pkey PRIMARY KEY (token_contract_address_hash);


--
-- TOC entry 4300 (class 2606 OID 18725)
-- Name: missing_block_ranges missing_block_ranges_no_overlap; Type: CONSTRAINT; Schema: public; Owner: blockscout
--

ALTER TABLE ONLY public.missing_block_ranges
    ADD CONSTRAINT missing_block_ranges_no_overlap EXCLUDE USING gist (int4range(to_number, from_number, '[]'::text) WITH &&);


--
-- TOC entry 4302 (class 2606 OID 18087)
-- Name: missing_block_ranges missing_block_ranges_pkey; Type: CONSTRAINT; Schema: public; Owner: blockscout
--

ALTER TABLE ONLY public.missing_block_ranges
    ADD CONSTRAINT missing_block_ranges_pkey PRIMARY KEY (id);


--
-- TOC entry 4196 (class 2606 OID 17980)
-- Name: emission_rewards no_overlapping_ranges; Type: CONSTRAINT; Schema: public; Owner: blockscout
--

ALTER TABLE ONLY public.emission_rewards
    ADD CONSTRAINT no_overlapping_ranges EXCLUDE USING gist (block_range WITH &&);


--
-- TOC entry 4273 (class 2606 OID 17757)
-- Name: pending_block_operations pending_block_operations_pkey; Type: CONSTRAINT; Schema: public; Owner: blockscout
--

ALTER TABLE ONLY public.pending_block_operations
    ADD CONSTRAINT pending_block_operations_pkey PRIMARY KEY (block_hash);


--
-- TOC entry 4325 (class 2606 OID 18683)
-- Name: proxy_implementations proxy_implementations_pkey; Type: CONSTRAINT; Schema: public; Owner: blockscout
--

ALTER TABLE ONLY public.proxy_implementations
    ADD CONSTRAINT proxy_implementations_pkey PRIMARY KEY (proxy_address_hash);


--
-- TOC entry 4314 (class 2606 OID 18623)
-- Name: proxy_smart_contract_verification_statuses proxy_smart_contract_verification_statuses_pkey; Type: CONSTRAINT; Schema: public; Owner: blockscout
--

ALTER TABLE ONLY public.proxy_smart_contract_verification_statuses
    ADD CONSTRAINT proxy_smart_contract_verification_statuses_pkey PRIMARY KEY (uid);


--
-- TOC entry 4336 (class 2606 OID 18746)
-- Name: scam_address_badge_mappings scam_address_badge_mappings_pkey; Type: CONSTRAINT; Schema: public; Owner: blockscout
--

ALTER TABLE ONLY public.scam_address_badge_mappings
    ADD CONSTRAINT scam_address_badge_mappings_pkey PRIMARY KEY (address_hash);


--
-- TOC entry 4115 (class 2606 OID 16393)
-- Name: schema_migrations schema_migrations_pkey; Type: CONSTRAINT; Schema: public; Owner: blockscout
--

ALTER TABLE ONLY public.schema_migrations
    ADD CONSTRAINT schema_migrations_pkey PRIMARY KEY (version);


--
-- TOC entry 4113 (class 2606 OID 17519)
-- Name: internal_transactions selfdestruct_has_from_and_to_address; Type: CHECK CONSTRAINT; Schema: public; Owner: blockscout
--

ALTER TABLE public.internal_transactions
    ADD CONSTRAINT selfdestruct_has_from_and_to_address CHECK ((((type)::text <> 'selfdestruct'::text) OR ((from_address_hash IS NOT NULL) AND (gas IS NULL) AND (to_address_hash IS NOT NULL)))) NOT VALID;


--
-- TOC entry 4334 (class 2606 OID 18733)
-- Name: signed_authorizations signed_authorizations_pkey; Type: CONSTRAINT; Schema: public; Owner: blockscout
--

ALTER TABLE ONLY public.signed_authorizations
    ADD CONSTRAINT signed_authorizations_pkey PRIMARY KEY (transaction_hash, index);


--
-- TOC entry 4318 (class 2606 OID 18639)
-- Name: smart_contract_audit_reports smart_contract_audit_reports_pkey; Type: CONSTRAINT; Schema: public; Owner: blockscout
--

ALTER TABLE ONLY public.smart_contract_audit_reports
    ADD CONSTRAINT smart_contract_audit_reports_pkey PRIMARY KEY (id);


--
-- TOC entry 4280 (class 2606 OID 17868)
-- Name: smart_contracts_additional_sources smart_contracts_additional_sources_pkey; Type: CONSTRAINT; Schema: public; Owner: blockscout
--

ALTER TABLE ONLY public.smart_contracts_additional_sources
    ADD CONSTRAINT smart_contracts_additional_sources_pkey PRIMARY KEY (id);


--
-- TOC entry 4191 (class 2606 OID 16572)
-- Name: smart_contracts smart_contracts_pkey; Type: CONSTRAINT; Schema: public; Owner: blockscout
--

ALTER TABLE ONLY public.smart_contracts
    ADD CONSTRAINT smart_contracts_pkey PRIMARY KEY (id);


--
-- TOC entry 4330 (class 2606 OID 18722)
-- Name: token_instance_metadata_refetch_attempts token_instance_metadata_refetch_attempts_pkey; Type: CONSTRAINT; Schema: public; Owner: blockscout
--

ALTER TABLE ONLY public.token_instance_metadata_refetch_attempts
    ADD CONSTRAINT token_instance_metadata_refetch_attempts_pkey PRIMARY KEY (token_contract_address_hash, token_id);


--
-- TOC entry 4268 (class 2606 OID 17740)
-- Name: token_instances token_instances_pkey; Type: CONSTRAINT; Schema: public; Owner: blockscout
--

ALTER TABLE ONLY public.token_instances
    ADD CONSTRAINT token_instances_pkey PRIMARY KEY (token_id, token_contract_address_hash);


--
-- TOC entry 4296 (class 2606 OID 18073)
-- Name: token_transfer_token_id_migrator_progress token_transfer_token_id_migrator_progress_pkey; Type: CONSTRAINT; Schema: public; Owner: blockscout
--

ALTER TABLE ONLY public.token_transfer_token_id_migrator_progress
    ADD CONSTRAINT token_transfer_token_id_migrator_progress_pkey PRIMARY KEY (id);


--
-- TOC entry 4209 (class 2606 OID 17787)
-- Name: token_transfers token_transfers_pkey; Type: CONSTRAINT; Schema: public; Owner: blockscout
--

ALTER TABLE ONLY public.token_transfers
    ADD CONSTRAINT token_transfers_pkey PRIMARY KEY (transaction_hash, block_hash, log_index);


--
-- TOC entry 4199 (class 2606 OID 17556)
-- Name: tokens tokens_pkey; Type: CONSTRAINT; Schema: public; Owner: blockscout
--

ALTER TABLE ONLY public.tokens
    ADD CONSTRAINT tokens_pkey PRIMARY KEY (contract_address_hash);


--
-- TOC entry 4293 (class 2606 OID 18060)
-- Name: transaction_actions transaction_actions_pkey; Type: CONSTRAINT; Schema: public; Owner: blockscout
--

ALTER TABLE ONLY public.transaction_actions
    ADD CONSTRAINT transaction_actions_pkey PRIMARY KEY (hash, log_index);


--
-- TOC entry 4240 (class 2606 OID 17965)
-- Name: transaction_forks transaction_forks_pkey; Type: CONSTRAINT; Schema: public; Owner: blockscout
--

ALTER TABLE ONLY public.transaction_forks
    ADD CONSTRAINT transaction_forks_pkey PRIMARY KEY (uncle_hash, index);


--
-- TOC entry 4264 (class 2606 OID 17728)
-- Name: transaction_stats transaction_stats_pkey; Type: CONSTRAINT; Schema: public; Owner: blockscout
--

ALTER TABLE ONLY public.transaction_stats
    ADD CONSTRAINT transaction_stats_pkey PRIMARY KEY (id);


--
-- TOC entry 4151 (class 2606 OID 16422)
-- Name: transactions transactions_pkey; Type: CONSTRAINT; Schema: public; Owner: blockscout
--

ALTER TABLE ONLY public.transactions
    ADD CONSTRAINT transactions_pkey PRIMARY KEY (hash);


--
-- TOC entry 4186 (class 2606 OID 16555)
-- Name: user_contacts user_contacts_pkey; Type: CONSTRAINT; Schema: public; Owner: blockscout
--

ALTER TABLE ONLY public.user_contacts
    ADD CONSTRAINT user_contacts_pkey PRIMARY KEY (id);


--
-- TOC entry 4182 (class 2606 OID 16545)
-- Name: users users_pkey; Type: CONSTRAINT; Schema: public; Owner: blockscout
--

ALTER TABLE ONLY public.users
    ADD CONSTRAINT users_pkey PRIMARY KEY (id);


--
-- TOC entry 4310 (class 2606 OID 18122)
-- Name: validators validators_pkey; Type: CONSTRAINT; Schema: public; Owner: blockscout
--

ALTER TABLE ONLY public.validators
    ADD CONSTRAINT validators_pkey PRIMARY KEY (address_hash);


--
-- TOC entry 4306 (class 2606 OID 18096)
-- Name: withdrawals withdrawals_pkey; Type: CONSTRAINT; Schema: public; Owner: blockscout
--

ALTER TABLE ONLY public.withdrawals
    ADD CONSTRAINT withdrawals_pkey PRIMARY KEY (index);


--
-- TOC entry 4368 (class 1259 OID 18905)
-- Name: account_api_keys_identity_id_index; Type: INDEX; Schema: public; Owner: blockscout
--

CREATE INDEX account_api_keys_identity_id_index ON public.account_api_keys USING btree (identity_id);


--
-- TOC entry 4365 (class 1259 OID 18888)
-- Name: account_api_plans_id_max_req_per_second_name_index; Type: INDEX; Schema: public; Owner: blockscout
--

CREATE UNIQUE INDEX account_api_plans_id_max_req_per_second_name_index ON public.account_api_plans USING btree (id, max_req_per_second, name);


--
-- TOC entry 4371 (class 1259 OID 18970)
-- Name: account_custom_abis_identity_id_address_hash_hash_index; Type: INDEX; Schema: public; Owner: blockscout
--

CREATE UNIQUE INDEX account_custom_abis_identity_id_address_hash_hash_index ON public.account_custom_abis USING btree (identity_id, address_hash_hash) WHERE (user_created = true);


--
-- TOC entry 4372 (class 1259 OID 18921)
-- Name: account_custom_abis_identity_id_index; Type: INDEX; Schema: public; Owner: blockscout
--

CREATE INDEX account_custom_abis_identity_id_index ON public.account_custom_abis USING btree (identity_id);


--
-- TOC entry 4339 (class 1259 OID 18947)
-- Name: account_identities_uid_hash_index; Type: INDEX; Schema: public; Owner: blockscout
--

CREATE UNIQUE INDEX account_identities_uid_hash_index ON public.account_identities USING btree (uid_hash);


--
-- TOC entry 4355 (class 1259 OID 18948)
-- Name: account_tag_addresses_address_hash_hash_index; Type: INDEX; Schema: public; Owner: blockscout
--

CREATE INDEX account_tag_addresses_address_hash_hash_index ON public.account_tag_addresses USING btree (address_hash_hash);


--
-- TOC entry 4356 (class 1259 OID 18971)
-- Name: account_tag_addresses_identity_id_address_hash_hash_index; Type: INDEX; Schema: public; Owner: blockscout
--

CREATE UNIQUE INDEX account_tag_addresses_identity_id_address_hash_hash_index ON public.account_tag_addresses USING btree (identity_id, address_hash_hash) WHERE (user_created = true);


--
-- TOC entry 4357 (class 1259 OID 18863)
-- Name: account_tag_addresses_identity_id_index; Type: INDEX; Schema: public; Owner: blockscout
--

CREATE INDEX account_tag_addresses_identity_id_index ON public.account_tag_addresses USING btree (identity_id);


--
-- TOC entry 4360 (class 1259 OID 18879)
-- Name: account_tag_transactions_identity_id_index; Type: INDEX; Schema: public; Owner: blockscout
--

CREATE INDEX account_tag_transactions_identity_id_index ON public.account_tag_transactions USING btree (identity_id);


--
-- TOC entry 4361 (class 1259 OID 18972)
-- Name: account_tag_transactions_identity_id_tx_hash_hash_index; Type: INDEX; Schema: public; Owner: blockscout
--

CREATE UNIQUE INDEX account_tag_transactions_identity_id_tx_hash_hash_index ON public.account_tag_transactions USING btree (identity_id, transaction_hash_hash) WHERE (user_created = true);


--
-- TOC entry 4364 (class 1259 OID 18949)
-- Name: account_tag_transactions_tx_hash_hash_index; Type: INDEX; Schema: public; Owner: blockscout
--

CREATE INDEX account_tag_transactions_tx_hash_hash_index ON public.account_tag_transactions USING btree (transaction_hash_hash);


--
-- TOC entry 4343 (class 1259 OID 18950)
-- Name: account_watchlist_addresses_address_hash_hash_index; Type: INDEX; Schema: public; Owner: blockscout
--

CREATE INDEX account_watchlist_addresses_address_hash_hash_index ON public.account_watchlist_addresses USING btree (address_hash_hash);


--
-- TOC entry 4346 (class 1259 OID 18827)
-- Name: account_watchlist_addresses_watchlist_id_index; Type: INDEX; Schema: public; Owner: blockscout
--

CREATE INDEX account_watchlist_addresses_watchlist_id_index ON public.account_watchlist_addresses USING btree (watchlist_id);


--
-- TOC entry 4348 (class 1259 OID 18945)
-- Name: account_watchlist_notifications_from_address_hash_hash_index; Type: INDEX; Schema: public; Owner: blockscout
--

CREATE INDEX account_watchlist_notifications_from_address_hash_hash_index ON public.account_watchlist_notifications USING btree (from_address_hash_hash);


--
-- TOC entry 4351 (class 1259 OID 18946)
-- Name: account_watchlist_notifications_to_address_hash_hash_index; Type: INDEX; Schema: public; Owner: blockscout
--

CREATE INDEX account_watchlist_notifications_to_address_hash_hash_index ON public.account_watchlist_notifications USING btree (to_address_hash_hash);


--
-- TOC entry 4352 (class 1259 OID 18944)
-- Name: account_watchlist_notifications_transaction_hash_hash_index; Type: INDEX; Schema: public; Owner: blockscout
--

CREATE INDEX account_watchlist_notifications_transaction_hash_hash_index ON public.account_watchlist_notifications USING btree (transaction_hash_hash);


--
-- TOC entry 4353 (class 1259 OID 18843)
-- Name: account_watchlist_notifications_watchlist_address_id_index; Type: INDEX; Schema: public; Owner: blockscout
--

CREATE INDEX account_watchlist_notifications_watchlist_address_id_index ON public.account_watchlist_notifications USING btree (watchlist_address_id);


--
-- TOC entry 4354 (class 1259 OID 18963)
-- Name: account_watchlist_notifications_watchlist_id_index; Type: INDEX; Schema: public; Owner: blockscout
--

CREATE INDEX account_watchlist_notifications_watchlist_id_index ON public.account_watchlist_notifications USING btree (watchlist_id);


--
-- TOC entry 4340 (class 1259 OID 18800)
-- Name: account_watchlists_identity_id_index; Type: INDEX; Schema: public; Owner: blockscout
--

CREATE INDEX account_watchlists_identity_id_index ON public.account_watchlists USING btree (identity_id);


--
-- TOC entry 4217 (class 1259 OID 18140)
-- Name: address_coin_balances_block_number_index; Type: INDEX; Schema: public; Owner: blockscout
--

CREATE INDEX address_coin_balances_block_number_index ON public.address_coin_balances USING btree (block_number);


--
-- TOC entry 4220 (class 1259 OID 17572)
-- Name: address_coin_balances_value_fetched_at_index; Type: INDEX; Schema: public; Owner: blockscout
--

CREATE INDEX address_coin_balances_value_fetched_at_index ON public.address_coin_balances USING btree (value_fetched_at);


--
-- TOC entry 4321 (class 1259 OID 18672)
-- Name: address_contract_code_fetch_attempts_address_hash_index; Type: INDEX; Schema: public; Owner: blockscout
--

CREATE INDEX address_contract_code_fetch_attempts_address_hash_index ON public.address_contract_code_fetch_attempts USING btree (address_hash);


--
-- TOC entry 4245 (class 1259 OID 17567)
-- Name: address_cur_token_balances_index; Type: INDEX; Schema: public; Owner: blockscout
--

CREATE INDEX address_cur_token_balances_index ON public.address_current_token_balances USING btree (block_number);


--
-- TOC entry 4248 (class 1259 OID 18674)
-- Name: address_current_token_balances_token_contract_address_hash__val; Type: INDEX; Schema: public; Owner: blockscout
--

CREATE INDEX address_current_token_balances_token_contract_address_hash__val ON public.address_current_token_balances USING btree (token_contract_address_hash, value DESC, address_hash DESC) WHERE ((address_hash <> '\x0000000000000000000000000000000000000000'::bytea) AND (value > (0)::numeric));


--
-- TOC entry 4249 (class 1259 OID 17796)
-- Name: address_current_token_balances_token_contract_address_hash_valu; Type: INDEX; Schema: public; Owner: blockscout
--

CREATE INDEX address_current_token_balances_token_contract_address_hash_valu ON public.address_current_token_balances USING btree (token_contract_address_hash, value);


--
-- TOC entry 4250 (class 1259 OID 17902)
-- Name: address_current_token_balances_token_id_index; Type: INDEX; Schema: public; Owner: blockscout
--

CREATE INDEX address_current_token_balances_token_id_index ON public.address_current_token_balances USING btree (token_id);


--
-- TOC entry 4259 (class 1259 OID 17608)
-- Name: address_decompiler_version; Type: INDEX; Schema: public; Owner: blockscout
--

CREATE UNIQUE INDEX address_decompiler_version ON public.decompiled_smart_contracts USING btree (address_hash, decompiler_version);


--
-- TOC entry 4230 (class 1259 OID 17323)
-- Name: address_names_address_hash_index; Type: INDEX; Schema: public; Owner: blockscout
--

CREATE UNIQUE INDEX address_names_address_hash_index ON public.address_names USING btree (address_hash) WHERE ("primary" = true);


--
-- TOC entry 4281 (class 1259 OID 17880)
-- Name: address_tags_id_index; Type: INDEX; Schema: public; Owner: blockscout
--

CREATE UNIQUE INDEX address_tags_id_index ON public.address_tags USING btree (id);


--
-- TOC entry 4282 (class 1259 OID 18754)
-- Name: address_tags_label_index; Type: INDEX; Schema: public; Owner: blockscout
--

CREATE UNIQUE INDEX address_tags_label_index ON public.address_tags USING btree (label);


--
-- TOC entry 4285 (class 1259 OID 17901)
-- Name: address_to_tags_address_hash_tag_id_index; Type: INDEX; Schema: public; Owner: blockscout
--

CREATE UNIQUE INDEX address_to_tags_address_hash_tag_id_index ON public.address_to_tags USING btree (address_hash, tag_id);


--
-- TOC entry 4222 (class 1259 OID 17920)
-- Name: address_token_balances_address_hash_token_contract_address_hash; Type: INDEX; Schema: public; Owner: blockscout
--

CREATE INDEX address_token_balances_address_hash_token_contract_address_hash ON public.address_token_balances USING btree (address_hash, token_contract_address_hash, block_number);


--
-- TOC entry 4223 (class 1259 OID 17731)
-- Name: address_token_balances_block_number_address_hash_index; Type: INDEX; Schema: public; Owner: blockscout
--

CREATE INDEX address_token_balances_block_number_address_hash_index ON public.address_token_balances USING btree (block_number, address_hash);


--
-- TOC entry 4226 (class 1259 OID 17918)
-- Name: address_token_balances_token_contract_address_hash_index; Type: INDEX; Schema: public; Owner: blockscout
--

CREATE INDEX address_token_balances_token_contract_address_hash_index ON public.address_token_balances USING btree (token_contract_address_hash);


--
-- TOC entry 4227 (class 1259 OID 17795)
-- Name: address_token_balances_token_id_index; Type: INDEX; Schema: public; Owner: blockscout
--

CREATE INDEX address_token_balances_token_id_index ON public.address_token_balances USING btree (token_id);


--
-- TOC entry 4116 (class 1259 OID 17523)
-- Name: addresses_fetched_coin_balance_hash_index; Type: INDEX; Schema: public; Owner: blockscout
--

CREATE INDEX addresses_fetched_coin_balance_hash_index ON public.addresses USING btree (fetched_coin_balance DESC, hash) WHERE (fetched_coin_balance > (0)::numeric);


--
-- TOC entry 4117 (class 1259 OID 17566)
-- Name: addresses_fetched_coin_balance_index; Type: INDEX; Schema: public; Owner: blockscout
--

CREATE INDEX addresses_fetched_coin_balance_index ON public.addresses USING btree (fetched_coin_balance);


--
-- TOC entry 4118 (class 1259 OID 17592)
-- Name: addresses_inserted_at_index; Type: INDEX; Schema: public; Owner: blockscout
--

CREATE INDEX addresses_inserted_at_index ON public.addresses USING btree (inserted_at);


--
-- TOC entry 4121 (class 1259 OID 18979)
-- Name: addresses_verified_index; Type: INDEX; Schema: public; Owner: blockscout
--

CREATE INDEX addresses_verified_index ON public.addresses USING btree ((1)) WHERE (verified = true);


--
-- TOC entry 4243 (class 1259 OID 17374)
-- Name: administrators_user_id_index; Type: INDEX; Schema: public; Owner: blockscout
--

CREATE UNIQUE INDEX administrators_user_id_index ON public.administrators USING btree (user_id);


--
-- TOC entry 4315 (class 1259 OID 18646)
-- Name: audit_report_unique_index; Type: INDEX; Schema: public; Owner: blockscout
--

CREATE UNIQUE INDEX audit_report_unique_index ON public.smart_contract_audit_reports USING btree (address_hash, audit_report_url, audit_publish_date, audit_company_name);


--
-- TOC entry 4252 (class 1259 OID 17966)
-- Name: block_rewards_block_hash_index; Type: INDEX; Schema: public; Owner: blockscout
--

CREATE INDEX block_rewards_block_hash_index ON public.block_rewards USING btree (block_hash);


--
-- TOC entry 4122 (class 1259 OID 17571)
-- Name: blocks_consensus_index; Type: INDEX; Schema: public; Owner: blockscout
--

CREATE INDEX blocks_consensus_index ON public.blocks USING btree (consensus);


--
-- TOC entry 4123 (class 1259 OID 18141)
-- Name: blocks_date; Type: INDEX; Schema: public; Owner: blockscout
--

CREATE INDEX blocks_date ON public.blocks USING btree (date("timestamp"), number);


--
-- TOC entry 4124 (class 1259 OID 17282)
-- Name: blocks_inserted_at_index; Type: INDEX; Schema: public; Owner: blockscout
--

CREATE INDEX blocks_inserted_at_index ON public.blocks USING btree (inserted_at);


--
-- TOC entry 4125 (class 1259 OID 17909)
-- Name: blocks_is_empty_index; Type: INDEX; Schema: public; Owner: blockscout
--

CREATE INDEX blocks_is_empty_index ON public.blocks USING btree (is_empty);


--
-- TOC entry 4126 (class 1259 OID 17542)
-- Name: blocks_miner_hash_index; Type: INDEX; Schema: public; Owner: blockscout
--

CREATE INDEX blocks_miner_hash_index ON public.blocks USING btree (miner_hash);


--
-- TOC entry 4127 (class 1259 OID 17799)
-- Name: blocks_miner_hash_number_index; Type: INDEX; Schema: public; Owner: blockscout
--

CREATE INDEX blocks_miner_hash_number_index ON public.blocks USING btree (miner_hash, number);


--
-- TOC entry 4128 (class 1259 OID 17568)
-- Name: blocks_number_index; Type: INDEX; Schema: public; Owner: blockscout
--

CREATE INDEX blocks_number_index ON public.blocks USING btree (number);


--
-- TOC entry 4131 (class 1259 OID 16413)
-- Name: blocks_timestamp_index; Type: INDEX; Schema: public; Owner: blockscout
--

CREATE INDEX blocks_timestamp_index ON public.blocks USING btree ("timestamp");


--
-- TOC entry 4132 (class 1259 OID 18611)
-- Name: consensus_block_hashes_refetch_needed; Type: INDEX; Schema: public; Owner: blockscout
--

CREATE INDEX consensus_block_hashes_refetch_needed ON public.blocks USING btree (hash) WHERE (consensus AND refetch_needed);


--
-- TOC entry 4255 (class 1259 OID 17552)
-- Name: contract_methods_identifier_abi_index; Type: INDEX; Schema: public; Owner: blockscout
--

CREATE UNIQUE INDEX contract_methods_identifier_abi_index ON public.contract_methods USING btree (identifier, abi);


--
-- TOC entry 4256 (class 1259 OID 18726)
-- Name: contract_methods_inserted_at_index; Type: INDEX; Schema: public; Owner: blockscout
--

CREATE INDEX contract_methods_inserted_at_index ON public.contract_methods USING btree (inserted_at);


--
-- TOC entry 4183 (class 1259 OID 17483)
-- Name: email_unique_for_user; Type: INDEX; Schema: public; Owner: blockscout
--

CREATE UNIQUE INDEX email_unique_for_user ON public.user_contacts USING btree (user_id, email);


--
-- TOC entry 4133 (class 1259 OID 17917)
-- Name: empty_consensus_blocks; Type: INDEX; Schema: public; Owner: blockscout
--

CREATE INDEX empty_consensus_blocks ON public.blocks USING btree (consensus) WHERE (is_empty IS NULL);


--
-- TOC entry 4251 (class 1259 OID 18076)
-- Name: fetched_current_token_balances; Type: INDEX; Schema: public; Owner: blockscout
--

CREATE UNIQUE INDEX fetched_current_token_balances ON public.address_current_token_balances USING btree (address_hash, token_contract_address_hash, COALESCE(token_id, ('-1'::integer)::numeric));


--
-- TOC entry 4228 (class 1259 OID 18074)
-- Name: fetched_token_balances; Type: INDEX; Schema: public; Owner: blockscout
--

CREATE UNIQUE INDEX fetched_token_balances ON public.address_token_balances USING btree (address_hash, token_contract_address_hash, COALESCE(token_id, ('-1'::integer)::numeric), block_number);


--
-- TOC entry 4169 (class 1259 OID 18980)
-- Name: internal_transactions_block_number_DESC_transaction_index_DESC_; Type: INDEX; Schema: public; Owner: blockscout
--

CREATE INDEX "internal_transactions_block_number_DESC_transaction_index_DESC_" ON public.internal_transactions USING btree (block_number DESC, transaction_index DESC, index DESC);


--
-- TOC entry 4170 (class 1259 OID 16522)
-- Name: internal_transactions_created_contract_address_hash_index; Type: INDEX; Schema: public; Owner: blockscout
--

CREATE INDEX internal_transactions_created_contract_address_hash_index ON public.internal_transactions USING btree (created_contract_address_hash);


--
-- TOC entry 4171 (class 1259 OID 17791)
-- Name: internal_transactions_created_contract_address_hash_partial_ind; Type: INDEX; Schema: public; Owner: blockscout
--

CREATE INDEX internal_transactions_created_contract_address_hash_partial_ind ON public.internal_transactions USING btree (created_contract_address_hash, block_number DESC, transaction_index DESC, index DESC) WHERE ((((type)::text = 'call'::text) AND (index > 0)) OR ((type)::text <> 'call'::text));


--
-- TOC entry 4172 (class 1259 OID 17789)
-- Name: internal_transactions_from_address_hash_partial_index; Type: INDEX; Schema: public; Owner: blockscout
--

CREATE INDEX internal_transactions_from_address_hash_partial_index ON public.internal_transactions USING btree (from_address_hash, block_number DESC, transaction_index DESC, index DESC) WHERE ((((type)::text = 'call'::text) AND (index > 0)) OR ((type)::text <> 'call'::text));


--
-- TOC entry 4175 (class 1259 OID 17790)
-- Name: internal_transactions_to_address_hash_partial_index; Type: INDEX; Schema: public; Owner: blockscout
--

CREATE INDEX internal_transactions_to_address_hash_partial_index ON public.internal_transactions USING btree (to_address_hash, block_number DESC, transaction_index DESC, index DESC) WHERE ((((type)::text = 'call'::text) AND (index > 0)) OR ((type)::text <> 'call'::text));


--
-- TOC entry 4176 (class 1259 OID 17772)
-- Name: internal_transactions_transaction_hash_index_index; Type: INDEX; Schema: public; Owner: blockscout
--

CREATE INDEX internal_transactions_transaction_hash_index_index ON public.internal_transactions USING btree (transaction_hash, index);


--
-- TOC entry 4157 (class 1259 OID 16481)
-- Name: logs_address_hash_index; Type: INDEX; Schema: public; Owner: blockscout
--

CREATE INDEX logs_address_hash_index ON public.logs USING btree (address_hash);


--
-- TOC entry 4158 (class 1259 OID 17921)
-- Name: logs_address_hash_transaction_hash_index; Type: INDEX; Schema: public; Owner: blockscout
--

CREATE INDEX logs_address_hash_transaction_hash_index ON public.logs USING btree (address_hash, transaction_hash);


--
-- TOC entry 4159 (class 1259 OID 18981)
-- Name: logs_block_hash_index; Type: INDEX; Schema: public; Owner: blockscout
--

CREATE INDEX logs_block_hash_index ON public.logs USING btree (block_hash);


--
-- TOC entry 4160 (class 1259 OID 17793)
-- Name: logs_block_number_DESC__index_DESC_index; Type: INDEX; Schema: public; Owner: blockscout
--

CREATE INDEX "logs_block_number_DESC__index_DESC_index" ON public.logs USING btree (block_number DESC, index DESC);


--
-- TOC entry 4161 (class 1259 OID 18591)
-- Name: logs_first_topic_index; Type: INDEX; Schema: public; Owner: blockscout
--

CREATE INDEX logs_first_topic_index ON public.logs USING btree (first_topic);


--
-- TOC entry 4162 (class 1259 OID 18594)
-- Name: logs_fourth_topic_index; Type: INDEX; Schema: public; Owner: blockscout
--

CREATE INDEX logs_fourth_topic_index ON public.logs USING btree (fourth_topic);


--
-- TOC entry 4163 (class 1259 OID 16483)
-- Name: logs_index_index; Type: INDEX; Schema: public; Owner: blockscout
--

CREATE INDEX logs_index_index ON public.logs USING btree (index);


--
-- TOC entry 4166 (class 1259 OID 18592)
-- Name: logs_second_topic_index; Type: INDEX; Schema: public; Owner: blockscout
--

CREATE INDEX logs_second_topic_index ON public.logs USING btree (second_topic);


--
-- TOC entry 4167 (class 1259 OID 18593)
-- Name: logs_third_topic_index; Type: INDEX; Schema: public; Owner: blockscout
--

CREATE INDEX logs_third_topic_index ON public.logs USING btree (third_topic);


--
-- TOC entry 4168 (class 1259 OID 17780)
-- Name: logs_transaction_hash_index_index; Type: INDEX; Schema: public; Owner: blockscout
--

CREATE INDEX logs_transaction_hash_index_index ON public.logs USING btree (transaction_hash, index);


--
-- TOC entry 4177 (class 1259 OID 18661)
-- Name: market_history_date_secondary_coin_index; Type: INDEX; Schema: public; Owner: blockscout
--

CREATE UNIQUE INDEX market_history_date_secondary_coin_index ON public.market_history USING btree (date, secondary_coin);


--
-- TOC entry 4136 (class 1259 OID 18008)
-- Name: method_id; Type: INDEX; Schema: public; Owner: blockscout
--

CREATE INDEX method_id ON public.transactions USING btree (SUBSTRING(input FROM 1 FOR 4));


--
-- TOC entry 4297 (class 1259 OID 18088)
-- Name: missing_block_ranges_from_number_DESC_index; Type: INDEX; Schema: public; Owner: blockscout
--

CREATE INDEX "missing_block_ranges_from_number_DESC_index" ON public.missing_block_ranges USING btree (from_number DESC);


--
-- TOC entry 4298 (class 1259 OID 18089)
-- Name: missing_block_ranges_from_number_to_number_index; Type: INDEX; Schema: public; Owner: blockscout
--

CREATE UNIQUE INDEX missing_block_ranges_from_number_to_number_index ON public.missing_block_ranges USING btree (from_number, to_number);


--
-- TOC entry 4236 (class 1259 OID 17335)
-- Name: nephew_hash_to_uncle_hash; Type: INDEX; Schema: public; Owner: blockscout
--

CREATE UNIQUE INDEX nephew_hash_to_uncle_hash ON public.block_second_degree_relations USING btree (nephew_hash, uncle_hash);


--
-- TOC entry 4134 (class 1259 OID 16415)
-- Name: one_consensus_block_at_height; Type: INDEX; Schema: public; Owner: blockscout
--

CREATE UNIQUE INDEX one_consensus_block_at_height ON public.blocks USING btree (number) WHERE consensus;


--
-- TOC entry 4135 (class 1259 OID 16414)
-- Name: one_consensus_child_per_parent; Type: INDEX; Schema: public; Owner: blockscout
--

CREATE UNIQUE INDEX one_consensus_child_per_parent ON public.blocks USING btree (parent_hash) WHERE consensus;


--
-- TOC entry 4184 (class 1259 OID 16563)
-- Name: one_primary_per_user; Type: INDEX; Schema: public; Owner: blockscout
--

CREATE UNIQUE INDEX one_primary_per_user ON public.user_contacts USING btree (user_id) WHERE "primary";


--
-- TOC entry 4244 (class 1259 OID 17373)
-- Name: owner_role_limit; Type: INDEX; Schema: public; Owner: blockscout
--

CREATE UNIQUE INDEX owner_role_limit ON public.administrators USING btree (role) WHERE ((role)::text = 'owner'::text);


--
-- TOC entry 4271 (class 1259 OID 18654)
-- Name: pending_block_operations_block_number_index; Type: INDEX; Schema: public; Owner: blockscout
--

CREATE INDEX pending_block_operations_block_number_index ON public.pending_block_operations USING btree (block_number);


--
-- TOC entry 4137 (class 1259 OID 17798)
-- Name: pending_txs_index; Type: INDEX; Schema: public; Owner: blockscout
--

CREATE INDEX pending_txs_index ON public.transactions USING btree (inserted_at, hash) WHERE ((block_hash IS NULL) AND ((error IS NULL) OR ((error)::text <> 'dropped/replaced'::text)));


--
-- TOC entry 4326 (class 1259 OID 18703)
-- Name: proxy_implementations_proxy_type_index; Type: INDEX; Schema: public; Owner: blockscout
--

CREATE INDEX proxy_implementations_proxy_type_index ON public.proxy_implementations USING btree (proxy_type);


--
-- TOC entry 4332 (class 1259 OID 18739)
-- Name: signed_authorizations_authority_nonce_index; Type: INDEX; Schema: public; Owner: blockscout
--

CREATE INDEX signed_authorizations_authority_nonce_index ON public.signed_authorizations USING btree (authority, nonce);


--
-- TOC entry 4316 (class 1259 OID 18645)
-- Name: smart_contract_audit_reports_address_hash_index; Type: INDEX; Schema: public; Owner: blockscout
--

CREATE INDEX smart_contract_audit_reports_address_hash_index ON public.smart_contract_audit_reports USING btree (address_hash);


--
-- TOC entry 4278 (class 1259 OID 17874)
-- Name: smart_contracts_additional_sources_address_hash_index; Type: INDEX; Schema: public; Owner: blockscout
--

CREATE INDEX smart_contracts_additional_sources_address_hash_index ON public.smart_contracts_additional_sources USING btree (address_hash);


--
-- TOC entry 4187 (class 1259 OID 16578)
-- Name: smart_contracts_address_hash_index; Type: INDEX; Schema: public; Owner: blockscout
--

CREATE UNIQUE INDEX smart_contracts_address_hash_index ON public.smart_contracts USING btree (address_hash);


--
-- TOC entry 4188 (class 1259 OID 18675)
-- Name: smart_contracts_certified_index; Type: INDEX; Schema: public; Owner: blockscout
--

CREATE INDEX smart_contracts_certified_index ON public.smart_contracts USING btree (certified);


--
-- TOC entry 4189 (class 1259 OID 17943)
-- Name: smart_contracts_contract_code_md5_index; Type: INDEX; Schema: public; Owner: blockscout
--

CREATE INDEX smart_contracts_contract_code_md5_index ON public.smart_contracts USING btree (contract_code_md5);


--
-- TOC entry 4192 (class 1259 OID 18662)
-- Name: smart_contracts_trgm_idx; Type: INDEX; Schema: public; Owner: blockscout
--

CREATE INDEX smart_contracts_trgm_idx ON public.smart_contracts USING gin (to_tsvector('english'::regconfig, (name)::text));


--
-- TOC entry 4331 (class 1259 OID 18723)
-- Name: token_instance_metadata_refetch_attempts_token_contract_address; Type: INDEX; Schema: public; Owner: blockscout
--

CREATE INDEX token_instance_metadata_refetch_attempts_token_contract_address ON public.token_instance_metadata_refetch_attempts USING btree (token_contract_address_hash, token_id);


--
-- TOC entry 4265 (class 1259 OID 17750)
-- Name: token_instances_error_index; Type: INDEX; Schema: public; Owner: blockscout
--

CREATE INDEX token_instances_error_index ON public.token_instances USING btree (error);


--
-- TOC entry 4266 (class 1259 OID 18143)
-- Name: token_instances_owner_address_hash_index; Type: INDEX; Schema: public; Owner: blockscout
--

CREATE INDEX token_instances_owner_address_hash_index ON public.token_instances USING btree (owner_address_hash);


--
-- TOC entry 4269 (class 1259 OID 18006)
-- Name: token_instances_token_contract_address_hash_token_id_index; Type: INDEX; Schema: public; Owner: blockscout
--

CREATE INDEX token_instances_token_contract_address_hash_token_id_index ON public.token_instances USING btree (token_contract_address_hash, token_id);


--
-- TOC entry 4270 (class 1259 OID 18007)
-- Name: token_instances_token_id_index; Type: INDEX; Schema: public; Owner: blockscout
--

CREATE INDEX token_instances_token_id_index ON public.token_instances USING btree (token_id);


--
-- TOC entry 4204 (class 1259 OID 18653)
-- Name: token_transfers_block_consensus_index; Type: INDEX; Schema: public; Owner: blockscout
--

CREATE INDEX token_transfers_block_consensus_index ON public.token_transfers USING btree (block_consensus);


--
-- TOC entry 4205 (class 1259 OID 17749)
-- Name: token_transfers_block_number_DESC_log_index_DESC_index; Type: INDEX; Schema: public; Owner: blockscout
--

CREATE INDEX "token_transfers_block_number_DESC_log_index_DESC_index" ON public.token_transfers USING btree (block_number DESC, log_index DESC);


--
-- TOC entry 4206 (class 1259 OID 17747)
-- Name: token_transfers_block_number_index; Type: INDEX; Schema: public; Owner: blockscout
--

CREATE INDEX token_transfers_block_number_index ON public.token_transfers USING btree (block_number);


--
-- TOC entry 4207 (class 1259 OID 18663)
-- Name: token_transfers_from_address_hash_block_number_index; Type: INDEX; Schema: public; Owner: blockscout
--

CREATE INDEX token_transfers_from_address_hash_block_number_index ON public.token_transfers USING btree (from_address_hash, block_number);


--
-- TOC entry 4210 (class 1259 OID 18664)
-- Name: token_transfers_to_address_hash_block_number_index; Type: INDEX; Schema: public; Owner: blockscout
--

CREATE INDEX token_transfers_to_address_hash_block_number_index ON public.token_transfers USING btree (to_address_hash, block_number);


--
-- TOC entry 4211 (class 1259 OID 17278)
-- Name: token_transfers_to_address_hash_transaction_hash_index; Type: INDEX; Schema: public; Owner: blockscout
--

CREATE INDEX token_transfers_to_address_hash_transaction_hash_index ON public.token_transfers USING btree (to_address_hash, transaction_hash);


--
-- TOC entry 4212 (class 1259 OID 18673)
-- Name: token_transfers_token_contract_address_hash__block_number_DESC_; Type: INDEX; Schema: public; Owner: blockscout
--

CREATE INDEX "token_transfers_token_contract_address_hash__block_number_DESC_" ON public.token_transfers USING btree (token_contract_address_hash, block_number DESC, log_index DESC);


--
-- TOC entry 4213 (class 1259 OID 18590)
-- Name: token_transfers_token_contract_address_hash_token_ids_index; Type: INDEX; Schema: public; Owner: blockscout
--

CREATE INDEX token_transfers_token_contract_address_hash_token_ids_index ON public.token_transfers USING gin (token_contract_address_hash, token_ids);


--
-- TOC entry 4214 (class 1259 OID 17280)
-- Name: token_transfers_token_contract_address_hash_transaction_hash_in; Type: INDEX; Schema: public; Owner: blockscout
--

CREATE INDEX token_transfers_token_contract_address_hash_transaction_hash_in ON public.token_transfers USING btree (token_contract_address_hash, transaction_hash);


--
-- TOC entry 4215 (class 1259 OID 18649)
-- Name: token_transfers_token_type_index; Type: INDEX; Schema: public; Owner: blockscout
--

CREATE INDEX token_transfers_token_type_index ON public.token_transfers USING btree (token_type);


--
-- TOC entry 4216 (class 1259 OID 17788)
-- Name: token_transfers_transaction_hash_log_index_index; Type: INDEX; Schema: public; Owner: blockscout
--

CREATE INDEX token_transfers_transaction_hash_log_index_index ON public.token_transfers USING btree (transaction_hash, log_index);


--
-- TOC entry 4197 (class 1259 OID 17247)
-- Name: tokens_contract_address_hash_index; Type: INDEX; Schema: public; Owner: blockscout
--

CREATE UNIQUE INDEX tokens_contract_address_hash_index ON public.tokens USING btree (contract_address_hash);


--
-- TOC entry 4200 (class 1259 OID 18009)
-- Name: tokens_symbol_index; Type: INDEX; Schema: public; Owner: blockscout
--

CREATE INDEX tokens_symbol_index ON public.tokens USING btree (symbol);


--
-- TOC entry 4201 (class 1259 OID 18010)
-- Name: tokens_trgm_idx; Type: INDEX; Schema: public; Owner: blockscout
--

CREATE INDEX tokens_trgm_idx ON public.tokens USING gin (to_tsvector('english'::regconfig, ((symbol || ' '::text) || name)));


--
-- TOC entry 4202 (class 1259 OID 17748)
-- Name: tokens_type_index; Type: INDEX; Schema: public; Owner: blockscout
--

CREATE INDEX tokens_type_index ON public.tokens USING btree (type);


--
-- TOC entry 4294 (class 1259 OID 18066)
-- Name: transaction_actions_protocol_type_index; Type: INDEX; Schema: public; Owner: blockscout
--

CREATE INDEX transaction_actions_protocol_type_index ON public.transaction_actions USING btree (protocol, type);


--
-- TOC entry 4262 (class 1259 OID 17729)
-- Name: transaction_stats_date_index; Type: INDEX; Schema: public; Owner: blockscout
--

CREATE UNIQUE INDEX transaction_stats_date_index ON public.transaction_stats USING btree (date);


--
-- TOC entry 4138 (class 1259 OID 18146)
-- Name: transactions_block_consensus_index; Type: INDEX; Schema: public; Owner: blockscout
--

CREATE INDEX transactions_block_consensus_index ON public.transactions USING btree (block_consensus);


--
-- TOC entry 4139 (class 1259 OID 17562)
-- Name: transactions_block_hash_error_index; Type: INDEX; Schema: public; Owner: blockscout
--

CREATE INDEX transactions_block_hash_error_index ON public.transactions USING btree (block_hash, error);


--
-- TOC entry 4140 (class 1259 OID 16461)
-- Name: transactions_block_hash_index_index; Type: INDEX; Schema: public; Owner: blockscout
--

CREATE UNIQUE INDEX transactions_block_hash_index_index ON public.transactions USING btree (block_hash, index);


--
-- TOC entry 4141 (class 1259 OID 17919)
-- Name: transactions_block_number_index; Type: INDEX; Schema: public; Owner: blockscout
--

CREATE INDEX transactions_block_number_index ON public.transactions USING btree (block_number);


--
-- TOC entry 4142 (class 1259 OID 18145)
-- Name: transactions_block_timestamp_index; Type: INDEX; Schema: public; Owner: blockscout
--

CREATE INDEX transactions_block_timestamp_index ON public.transactions USING btree (block_timestamp);


--
-- TOC entry 4143 (class 1259 OID 18080)
-- Name: transactions_created_contract_address_hash_with_pending_index; Type: INDEX; Schema: public; Owner: blockscout
--

CREATE INDEX transactions_created_contract_address_hash_with_pending_index ON public.transactions USING btree (created_contract_address_hash, block_number DESC, index DESC, inserted_at DESC, hash);


--
-- TOC entry 4144 (class 1259 OID 18614)
-- Name: transactions_created_contract_address_hash_with_pending_index_a; Type: INDEX; Schema: public; Owner: blockscout
--

CREATE INDEX transactions_created_contract_address_hash_with_pending_index_a ON public.transactions USING btree (created_contract_address_hash, block_number, index, inserted_at, hash DESC);


--
-- TOC entry 4145 (class 1259 OID 17554)
-- Name: transactions_created_contract_code_indexed_at_index; Type: INDEX; Schema: public; Owner: blockscout
--

CREATE INDEX transactions_created_contract_code_indexed_at_index ON public.transactions USING btree (created_contract_code_indexed_at);


--
-- TOC entry 4146 (class 1259 OID 18078)
-- Name: transactions_from_address_hash_with_pending_index; Type: INDEX; Schema: public; Owner: blockscout
--

CREATE INDEX transactions_from_address_hash_with_pending_index ON public.transactions USING btree (from_address_hash, block_number DESC, index DESC, inserted_at DESC, hash);


--
-- TOC entry 4147 (class 1259 OID 18612)
-- Name: transactions_from_address_hash_with_pending_index_asc; Type: INDEX; Schema: public; Owner: blockscout
--

CREATE INDEX transactions_from_address_hash_with_pending_index_asc ON public.transactions USING btree (from_address_hash, block_number, index, inserted_at, hash DESC);


--
-- TOC entry 4148 (class 1259 OID 16454)
-- Name: transactions_inserted_at_index; Type: INDEX; Schema: public; Owner: blockscout
--

CREATE INDEX transactions_inserted_at_index ON public.transactions USING btree (inserted_at);


--
-- TOC entry 4149 (class 1259 OID 17561)
-- Name: transactions_nonce_from_address_hash_block_hash_index; Type: INDEX; Schema: public; Owner: blockscout
--

CREATE INDEX transactions_nonce_from_address_hash_block_hash_index ON public.transactions USING btree (nonce, from_address_hash, block_hash);


--
-- TOC entry 4152 (class 1259 OID 16457)
-- Name: transactions_recent_collated_index; Type: INDEX; Schema: public; Owner: blockscout
--

CREATE INDEX transactions_recent_collated_index ON public.transactions USING btree (block_number DESC, index DESC);


--
-- TOC entry 4153 (class 1259 OID 16456)
-- Name: transactions_status_index; Type: INDEX; Schema: public; Owner: blockscout
--

CREATE INDEX transactions_status_index ON public.transactions USING btree (status);


--
-- TOC entry 4154 (class 1259 OID 18079)
-- Name: transactions_to_address_hash_with_pending_index; Type: INDEX; Schema: public; Owner: blockscout
--

CREATE INDEX transactions_to_address_hash_with_pending_index ON public.transactions USING btree (to_address_hash, block_number DESC, index DESC, inserted_at DESC, hash);


--
-- TOC entry 4155 (class 1259 OID 18613)
-- Name: transactions_to_address_hash_with_pending_index_asc; Type: INDEX; Schema: public; Owner: blockscout
--

CREATE INDEX transactions_to_address_hash_with_pending_index_asc ON public.transactions USING btree (to_address_hash, block_number, index, inserted_at, hash DESC);


--
-- TOC entry 4156 (class 1259 OID 16455)
-- Name: transactions_updated_at_index; Type: INDEX; Schema: public; Owner: blockscout
--

CREATE INDEX transactions_updated_at_index ON public.transactions USING btree (updated_at);


--
-- TOC entry 4203 (class 1259 OID 18650)
-- Name: uncataloged_tokens; Type: INDEX; Schema: public; Owner: blockscout
--

CREATE INDEX uncataloged_tokens ON public.tokens USING btree (cataloged) WHERE (cataloged = false);


--
-- TOC entry 4237 (class 1259 OID 17337)
-- Name: uncle_hash_to_nephew_hash; Type: INDEX; Schema: public; Owner: blockscout
--

CREATE UNIQUE INDEX uncle_hash_to_nephew_hash ON public.block_second_degree_relations USING btree (uncle_hash, nephew_hash);


--
-- TOC entry 4229 (class 1259 OID 18676)
-- Name: unfetched_address_token_balances_v2_index; Type: INDEX; Schema: public; Owner: blockscout
--

CREATE INDEX unfetched_address_token_balances_v2_index ON public.address_token_balances USING btree (id) WHERE ((((address_hash <> '\x0000000000000000000000000000000000000000'::bytea) AND ((token_type)::text = 'ERC-721'::text)) OR ((token_type)::text = 'ERC-20'::text) OR ((token_type)::text = 'ERC-1155'::text) OR ((token_type)::text = 'ERC-404'::text)) AND ((value_fetched_at IS NULL) OR (value IS NULL)));


--
-- TOC entry 4221 (class 1259 OID 17951)
-- Name: unfetched_balances; Type: INDEX; Schema: public; Owner: blockscout
--

CREATE UNIQUE INDEX unfetched_balances ON public.address_coin_balances USING btree (address_hash, block_number) WHERE (value_fetched_at IS NULL);


--
-- TOC entry 4238 (class 1259 OID 17336)
-- Name: unfetched_uncles; Type: INDEX; Schema: public; Owner: blockscout
--

CREATE UNIQUE INDEX unfetched_uncles ON public.block_second_degree_relations USING btree (nephew_hash, uncle_hash) WHERE (uncle_fetched_at IS NULL);


--
-- TOC entry 4233 (class 1259 OID 17324)
-- Name: unique_address_names; Type: INDEX; Schema: public; Owner: blockscout
--

CREATE UNIQUE INDEX unique_address_names ON public.address_names USING btree (address_hash, name);


--
-- TOC entry 4180 (class 1259 OID 17480)
-- Name: unique_username; Type: INDEX; Schema: public; Owner: blockscout
--

CREATE UNIQUE INDEX unique_username ON public.users USING btree (username);


--
-- TOC entry 4347 (class 1259 OID 18973)
-- Name: unique_watchlist_id_address_hash_hash_index; Type: INDEX; Schema: public; Owner: blockscout
--

CREATE UNIQUE INDEX unique_watchlist_id_address_hash_hash_index ON public.account_watchlist_addresses USING btree (watchlist_id, address_hash_hash) WHERE (user_created = true);


--
-- TOC entry 4303 (class 1259 OID 18107)
-- Name: withdrawals_address_hash_index; Type: INDEX; Schema: public; Owner: blockscout
--

CREATE INDEX withdrawals_address_hash_index ON public.withdrawals USING btree (address_hash);


--
-- TOC entry 4304 (class 1259 OID 18108)
-- Name: withdrawals_block_hash_index; Type: INDEX; Schema: public; Owner: blockscout
--

CREATE INDEX withdrawals_block_hash_index ON public.withdrawals USING btree (block_hash);


--
-- TOC entry 4405 (class 2606 OID 18894)
-- Name: account_api_keys account_api_keys_identity_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: blockscout
--

ALTER TABLE ONLY public.account_api_keys
    ADD CONSTRAINT account_api_keys_identity_id_fkey FOREIGN KEY (identity_id) REFERENCES public.account_identities(id) ON DELETE CASCADE;


--
-- TOC entry 4406 (class 2606 OID 18915)
-- Name: account_custom_abis account_custom_abis_identity_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: blockscout
--

ALTER TABLE ONLY public.account_custom_abis
    ADD CONSTRAINT account_custom_abis_identity_id_fkey FOREIGN KEY (identity_id) REFERENCES public.account_identities(id) ON DELETE CASCADE;


--
-- TOC entry 4400 (class 2606 OID 18900)
-- Name: account_identities account_identities_plan_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: blockscout
--

ALTER TABLE ONLY public.account_identities
    ADD CONSTRAINT account_identities_plan_id_fkey FOREIGN KEY (plan_id) REFERENCES public.account_api_plans(id);


--
-- TOC entry 4407 (class 2606 OID 18931)
-- Name: account_public_tags_requests account_public_tags_requests_identity_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: blockscout
--

ALTER TABLE ONLY public.account_public_tags_requests
    ADD CONSTRAINT account_public_tags_requests_identity_id_fkey FOREIGN KEY (identity_id) REFERENCES public.account_identities(id);


--
-- TOC entry 4403 (class 2606 OID 18858)
-- Name: account_tag_addresses account_tag_addresses_identity_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: blockscout
--

ALTER TABLE ONLY public.account_tag_addresses
    ADD CONSTRAINT account_tag_addresses_identity_id_fkey FOREIGN KEY (identity_id) REFERENCES public.account_identities(id) ON DELETE CASCADE;


--
-- TOC entry 4404 (class 2606 OID 18874)
-- Name: account_tag_transactions account_tag_transactions_identity_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: blockscout
--

ALTER TABLE ONLY public.account_tag_transactions
    ADD CONSTRAINT account_tag_transactions_identity_id_fkey FOREIGN KEY (identity_id) REFERENCES public.account_identities(id) ON DELETE CASCADE;


--
-- TOC entry 4402 (class 2606 OID 18822)
-- Name: account_watchlist_addresses account_watchlist_addresses_watchlist_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: blockscout
--

ALTER TABLE ONLY public.account_watchlist_addresses
    ADD CONSTRAINT account_watchlist_addresses_watchlist_id_fkey FOREIGN KEY (watchlist_id) REFERENCES public.account_watchlists(id) ON DELETE CASCADE;


--
-- TOC entry 4401 (class 2606 OID 18795)
-- Name: account_watchlists account_watchlists_identity_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: blockscout
--

ALTER TABLE ONLY public.account_watchlists
    ADD CONSTRAINT account_watchlists_identity_id_fkey FOREIGN KEY (identity_id) REFERENCES public.account_identities(id) ON DELETE CASCADE;


--
-- TOC entry 4393 (class 2606 OID 17896)
-- Name: address_to_tags address_to_tags_tag_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: blockscout
--

ALTER TABLE ONLY public.address_to_tags
    ADD CONSTRAINT address_to_tags_tag_id_fkey FOREIGN KEY (tag_id) REFERENCES public.address_tags(id);


--
-- TOC entry 4388 (class 2606 OID 17368)
-- Name: administrators administrators_user_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: blockscout
--

ALTER TABLE ONLY public.administrators
    ADD CONSTRAINT administrators_user_id_fkey FOREIGN KEY (user_id) REFERENCES public.users(id) ON DELETE CASCADE;


--
-- TOC entry 4389 (class 2606 OID 17972)
-- Name: block_rewards block_rewards_block_hash_fkey; Type: FK CONSTRAINT; Schema: public; Owner: blockscout
--

ALTER TABLE ONLY public.block_rewards
    ADD CONSTRAINT block_rewards_block_hash_fkey FOREIGN KEY (block_hash) REFERENCES public.blocks(hash) ON DELETE CASCADE;


--
-- TOC entry 4385 (class 2606 OID 17330)
-- Name: block_second_degree_relations block_second_degree_relations_nephew_hash_fkey; Type: FK CONSTRAINT; Schema: public; Owner: blockscout
--

ALTER TABLE ONLY public.block_second_degree_relations
    ADD CONSTRAINT block_second_degree_relations_nephew_hash_fkey FOREIGN KEY (nephew_hash) REFERENCES public.blocks(hash);


--
-- TOC entry 4380 (class 2606 OID 17767)
-- Name: internal_transactions internal_transactions_block_hash_fkey; Type: FK CONSTRAINT; Schema: public; Owner: blockscout
--

ALTER TABLE ONLY public.internal_transactions
    ADD CONSTRAINT internal_transactions_block_hash_fkey FOREIGN KEY (block_hash) REFERENCES public.blocks(hash);


--
-- TOC entry 4381 (class 2606 OID 16514)
-- Name: internal_transactions internal_transactions_transaction_hash_fkey; Type: FK CONSTRAINT; Schema: public; Owner: blockscout
--

ALTER TABLE ONLY public.internal_transactions
    ADD CONSTRAINT internal_transactions_transaction_hash_fkey FOREIGN KEY (transaction_hash) REFERENCES public.transactions(hash) ON DELETE CASCADE;


--
-- TOC entry 4378 (class 2606 OID 17773)
-- Name: logs logs_block_hash_fkey; Type: FK CONSTRAINT; Schema: public; Owner: blockscout
--

ALTER TABLE ONLY public.logs
    ADD CONSTRAINT logs_block_hash_fkey FOREIGN KEY (block_hash) REFERENCES public.blocks(hash);


--
-- TOC entry 4379 (class 2606 OID 16476)
-- Name: logs logs_transaction_hash_fkey; Type: FK CONSTRAINT; Schema: public; Owner: blockscout
--

ALTER TABLE ONLY public.logs
    ADD CONSTRAINT logs_transaction_hash_fkey FOREIGN KEY (transaction_hash) REFERENCES public.transactions(hash) ON DELETE CASCADE;


--
-- TOC entry 4391 (class 2606 OID 17758)
-- Name: pending_block_operations pending_block_operations_block_hash_fkey; Type: FK CONSTRAINT; Schema: public; Owner: blockscout
--

ALTER TABLE ONLY public.pending_block_operations
    ADD CONSTRAINT pending_block_operations_block_hash_fkey FOREIGN KEY (block_hash) REFERENCES public.blocks(hash) ON DELETE CASCADE;


--
-- TOC entry 4396 (class 2606 OID 18624)
-- Name: proxy_smart_contract_verification_statuses proxy_smart_contract_verification_statuses_contract_address_has; Type: FK CONSTRAINT; Schema: public; Owner: blockscout
--

ALTER TABLE ONLY public.proxy_smart_contract_verification_statuses
    ADD CONSTRAINT proxy_smart_contract_verification_statuses_contract_address_has FOREIGN KEY (contract_address_hash) REFERENCES public.smart_contracts(address_hash) ON DELETE CASCADE;


--
-- TOC entry 4399 (class 2606 OID 18747)
-- Name: scam_address_badge_mappings scam_address_badge_mappings_address_hash_fkey; Type: FK CONSTRAINT; Schema: public; Owner: blockscout
--

ALTER TABLE ONLY public.scam_address_badge_mappings
    ADD CONSTRAINT scam_address_badge_mappings_address_hash_fkey FOREIGN KEY (address_hash) REFERENCES public.addresses(hash) ON DELETE CASCADE;


--
-- TOC entry 4398 (class 2606 OID 18734)
-- Name: signed_authorizations signed_authorizations_transaction_hash_fkey; Type: FK CONSTRAINT; Schema: public; Owner: blockscout
--

ALTER TABLE ONLY public.signed_authorizations
    ADD CONSTRAINT signed_authorizations_transaction_hash_fkey FOREIGN KEY (transaction_hash) REFERENCES public.transactions(hash) ON DELETE CASCADE;


--
-- TOC entry 4397 (class 2606 OID 18640)
-- Name: smart_contract_audit_reports smart_contract_audit_reports_address_hash_fkey; Type: FK CONSTRAINT; Schema: public; Owner: blockscout
--

ALTER TABLE ONLY public.smart_contract_audit_reports
    ADD CONSTRAINT smart_contract_audit_reports_address_hash_fkey FOREIGN KEY (address_hash) REFERENCES public.smart_contracts(address_hash) ON DELETE CASCADE;


--
-- TOC entry 4392 (class 2606 OID 17869)
-- Name: smart_contracts_additional_sources smart_contracts_additional_sources_address_hash_fkey; Type: FK CONSTRAINT; Schema: public; Owner: blockscout
--

ALTER TABLE ONLY public.smart_contracts_additional_sources
    ADD CONSTRAINT smart_contracts_additional_sources_address_hash_fkey FOREIGN KEY (address_hash) REFERENCES public.smart_contracts(address_hash) ON DELETE CASCADE;


--
-- TOC entry 4390 (class 2606 OID 17741)
-- Name: token_instances token_instances_token_contract_address_hash_fkey; Type: FK CONSTRAINT; Schema: public; Owner: blockscout
--

ALTER TABLE ONLY public.token_instances
    ADD CONSTRAINT token_instances_token_contract_address_hash_fkey FOREIGN KEY (token_contract_address_hash) REFERENCES public.tokens(contract_address_hash);


--
-- TOC entry 4383 (class 2606 OID 17781)
-- Name: token_transfers token_transfers_block_hash_fkey; Type: FK CONSTRAINT; Schema: public; Owner: blockscout
--

ALTER TABLE ONLY public.token_transfers
    ADD CONSTRAINT token_transfers_block_hash_fkey FOREIGN KEY (block_hash) REFERENCES public.blocks(hash);


--
-- TOC entry 4384 (class 2606 OID 17257)
-- Name: token_transfers token_transfers_transaction_hash_fkey; Type: FK CONSTRAINT; Schema: public; Owner: blockscout
--

ALTER TABLE ONLY public.token_transfers
    ADD CONSTRAINT token_transfers_transaction_hash_fkey FOREIGN KEY (transaction_hash) REFERENCES public.transactions(hash) ON DELETE CASCADE;


--
-- TOC entry 4394 (class 2606 OID 18061)
-- Name: transaction_actions transaction_actions_hash_fkey; Type: FK CONSTRAINT; Schema: public; Owner: blockscout
--

ALTER TABLE ONLY public.transaction_actions
    ADD CONSTRAINT transaction_actions_hash_fkey FOREIGN KEY (hash) REFERENCES public.transactions(hash) ON UPDATE CASCADE ON DELETE CASCADE;


--
-- TOC entry 4386 (class 2606 OID 17343)
-- Name: transaction_forks transaction_forks_hash_fkey; Type: FK CONSTRAINT; Schema: public; Owner: blockscout
--

ALTER TABLE ONLY public.transaction_forks
    ADD CONSTRAINT transaction_forks_hash_fkey FOREIGN KEY (hash) REFERENCES public.transactions(hash) ON DELETE CASCADE;


--
-- TOC entry 4387 (class 2606 OID 17959)
-- Name: transaction_forks transaction_forks_uncle_hash_fkey; Type: FK CONSTRAINT; Schema: public; Owner: blockscout
--

ALTER TABLE ONLY public.transaction_forks
    ADD CONSTRAINT transaction_forks_uncle_hash_fkey FOREIGN KEY (uncle_hash) REFERENCES public.blocks(hash) ON DELETE CASCADE;


--
-- TOC entry 4377 (class 2606 OID 16423)
-- Name: transactions transactions_block_hash_fkey; Type: FK CONSTRAINT; Schema: public; Owner: blockscout
--

ALTER TABLE ONLY public.transactions
    ADD CONSTRAINT transactions_block_hash_fkey FOREIGN KEY (block_hash) REFERENCES public.blocks(hash) ON DELETE CASCADE;


--
-- TOC entry 4382 (class 2606 OID 16556)
-- Name: user_contacts user_contacts_user_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: blockscout
--

ALTER TABLE ONLY public.user_contacts
    ADD CONSTRAINT user_contacts_user_id_fkey FOREIGN KEY (user_id) REFERENCES public.users(id) ON DELETE CASCADE;


--
-- TOC entry 4395 (class 2606 OID 18102)
-- Name: withdrawals withdrawals_block_hash_fkey; Type: FK CONSTRAINT; Schema: public; Owner: blockscout
--

ALTER TABLE ONLY public.withdrawals
    ADD CONSTRAINT withdrawals_block_hash_fkey FOREIGN KEY (block_hash) REFERENCES public.blocks(hash) ON DELETE CASCADE;


-- Completed on 2025-06-24 21:31:19 UTC

--
-- PostgreSQL database dump complete
--

