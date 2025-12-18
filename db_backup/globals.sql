--
-- PostgreSQL database cluster dump
--

\restrict Y4DAyNJ7mo80XMSc7Jz3pO50WwK3ELbc5hNoFfGzu80OiIf8RJ35WmRzIoG7v0H

SET default_transaction_read_only = off;

SET client_encoding = 'UTF8';
SET standard_conforming_strings = on;

--
-- Roles
--

CREATE ROLE anon;
ALTER ROLE anon WITH NOSUPERUSER INHERIT NOCREATEROLE NOCREATEDB NOLOGIN NOREPLICATION NOBYPASSRLS;
COMMENT ON ROLE anon IS 'business user anon';
CREATE ROLE authenticated;
ALTER ROLE authenticated WITH NOSUPERUSER INHERIT NOCREATEROLE NOCREATEDB NOLOGIN NOREPLICATION NOBYPASSRLS;
COMMENT ON ROLE authenticated IS 'business user authenticated';
CREATE ROLE authenticator;
ALTER ROLE authenticator WITH NOSUPERUSER NOINHERIT NOCREATEROLE NOCREATEDB LOGIN NOREPLICATION NOBYPASSRLS;
COMMENT ON ROLE authenticator IS 'business user authenticator';
CREATE ROLE dashboard_user;
ALTER ROLE dashboard_user WITH NOSUPERUSER INHERIT CREATEROLE CREATEDB NOLOGIN REPLICATION NOBYPASSRLS;
COMMENT ON ROLE dashboard_user IS 'business user dashboard_user';
CREATE ROLE dbrole_admin;
ALTER ROLE dbrole_admin WITH NOSUPERUSER INHERIT NOCREATEROLE NOCREATEDB NOLOGIN NOREPLICATION NOBYPASSRLS;
COMMENT ON ROLE dbrole_admin IS 'role for object creation';
CREATE ROLE dbrole_offline;
ALTER ROLE dbrole_offline WITH NOSUPERUSER INHERIT NOCREATEROLE NOCREATEDB NOLOGIN NOREPLICATION NOBYPASSRLS;
COMMENT ON ROLE dbrole_offline IS 'role for restricted read-only access';
CREATE ROLE dbrole_readonly;
ALTER ROLE dbrole_readonly WITH NOSUPERUSER INHERIT NOCREATEROLE NOCREATEDB NOLOGIN NOREPLICATION NOBYPASSRLS;
COMMENT ON ROLE dbrole_readonly IS 'role for global read-only access';
CREATE ROLE dbrole_readwrite;
ALTER ROLE dbrole_readwrite WITH NOSUPERUSER INHERIT NOCREATEROLE NOCREATEDB NOLOGIN NOREPLICATION NOBYPASSRLS;
COMMENT ON ROLE dbrole_readwrite IS 'role for global read-write access';
CREATE ROLE dbuser_dba;
ALTER ROLE dbuser_dba WITH SUPERUSER INHERIT NOCREATEROLE NOCREATEDB LOGIN NOREPLICATION NOBYPASSRLS;
COMMENT ON ROLE dbuser_dba IS 'pgsql admin user';
CREATE ROLE dbuser_monitor;
ALTER ROLE dbuser_monitor WITH NOSUPERUSER INHERIT NOCREATEROLE NOCREATEDB LOGIN NOREPLICATION NOBYPASSRLS;
COMMENT ON ROLE dbuser_monitor IS 'pgsql monitor user';
CREATE ROLE pgsodium_keyholder;
ALTER ROLE pgsodium_keyholder WITH NOSUPERUSER INHERIT NOCREATEROLE NOCREATEDB NOLOGIN NOREPLICATION NOBYPASSRLS;
CREATE ROLE pgsodium_keyiduser;
ALTER ROLE pgsodium_keyiduser WITH NOSUPERUSER INHERIT NOCREATEROLE NOCREATEDB NOLOGIN NOREPLICATION NOBYPASSRLS;
CREATE ROLE pgsodium_keymaker;
ALTER ROLE pgsodium_keymaker WITH NOSUPERUSER INHERIT NOCREATEROLE NOCREATEDB NOLOGIN NOREPLICATION NOBYPASSRLS;
CREATE ROLE pgtle_admin;
ALTER ROLE pgtle_admin WITH NOSUPERUSER INHERIT NOCREATEROLE NOCREATEDB NOLOGIN NOREPLICATION NOBYPASSRLS;
CREATE ROLE postgres;
ALTER ROLE postgres WITH SUPERUSER INHERIT CREATEROLE CREATEDB LOGIN REPLICATION BYPASSRLS;
COMMENT ON ROLE postgres IS 'system superuser';
CREATE ROLE replicator;
ALTER ROLE replicator WITH NOSUPERUSER INHERIT NOCREATEROLE NOCREATEDB LOGIN REPLICATION NOBYPASSRLS;
COMMENT ON ROLE replicator IS 'system replicator';
CREATE ROLE service_role;
ALTER ROLE service_role WITH NOSUPERUSER INHERIT NOCREATEROLE NOCREATEDB NOLOGIN NOREPLICATION BYPASSRLS;
COMMENT ON ROLE service_role IS 'business user service_role';
CREATE ROLE supabase_admin;
ALTER ROLE supabase_admin WITH SUPERUSER INHERIT CREATEROLE CREATEDB LOGIN REPLICATION BYPASSRLS;
COMMENT ON ROLE supabase_admin IS 'business user supabase_admin';
CREATE ROLE supabase_auth_admin;
ALTER ROLE supabase_auth_admin WITH NOSUPERUSER NOINHERIT CREATEROLE NOCREATEDB LOGIN NOREPLICATION NOBYPASSRLS;
COMMENT ON ROLE supabase_auth_admin IS 'business user supabase_auth_admin';
CREATE ROLE supabase_etl_admin;
ALTER ROLE supabase_etl_admin WITH NOSUPERUSER INHERIT NOCREATEROLE NOCREATEDB LOGIN REPLICATION NOBYPASSRLS;
COMMENT ON ROLE supabase_etl_admin IS 'business user supabase_etl_admin';
CREATE ROLE supabase_functions_admin;
ALTER ROLE supabase_functions_admin WITH NOSUPERUSER NOINHERIT CREATEROLE NOCREATEDB LOGIN NOREPLICATION NOBYPASSRLS;
COMMENT ON ROLE supabase_functions_admin IS 'business user supabase_functions_admin';
CREATE ROLE supabase_read_only_user;
ALTER ROLE supabase_read_only_user WITH NOSUPERUSER INHERIT NOCREATEROLE NOCREATEDB LOGIN NOREPLICATION BYPASSRLS;
COMMENT ON ROLE supabase_read_only_user IS 'business user supabase_read_only_user';
CREATE ROLE supabase_realtime_admin;
ALTER ROLE supabase_realtime_admin WITH NOSUPERUSER NOINHERIT NOCREATEROLE NOCREATEDB NOLOGIN NOREPLICATION NOBYPASSRLS;
CREATE ROLE supabase_replication_admin;
ALTER ROLE supabase_replication_admin WITH NOSUPERUSER INHERIT NOCREATEROLE NOCREATEDB LOGIN REPLICATION NOBYPASSRLS;
COMMENT ON ROLE supabase_replication_admin IS 'business user supabase_replication_admin';
CREATE ROLE supabase_storage_admin;
ALTER ROLE supabase_storage_admin WITH NOSUPERUSER NOINHERIT CREATEROLE NOCREATEDB LOGIN NOREPLICATION NOBYPASSRLS;
COMMENT ON ROLE supabase_storage_admin IS 'business user supabase_storage_admin';

--
-- User Configurations
--

--
-- User Config "anon"
--

ALTER ROLE anon SET statement_timeout TO '3s';

--
-- User Config "authenticated"
--

ALTER ROLE authenticated SET statement_timeout TO '8s';

--
-- User Config "authenticator"
--

ALTER ROLE authenticator SET session_preload_libraries TO 'safeupdate';
ALTER ROLE authenticator SET statement_timeout TO '8s';
ALTER ROLE authenticator SET lock_timeout TO '8s';

--
-- User Config "dbuser_monitor"
--

ALTER ROLE dbuser_monitor SET log_min_duration_statement TO '1000';
ALTER ROLE dbuser_monitor SET search_path TO 'monitor', 'public';

--
-- User Config "postgres"
--

ALTER ROLE postgres SET search_path TO E'\\$user', 'public', 'extensions';

--
-- User Config "supabase_admin"
--

ALTER ROLE supabase_admin SET search_path TO 'public', 'extensions';
ALTER ROLE supabase_admin SET log_statement TO 'none';

--
-- User Config "supabase_auth_admin"
--

ALTER ROLE supabase_auth_admin SET search_path TO 'auth', 'extensions', 'public';
ALTER ROLE supabase_auth_admin SET idle_in_transaction_session_timeout TO '60000';
ALTER ROLE supabase_auth_admin SET log_statement TO 'none';

--
-- User Config "supabase_functions_admin"
--

ALTER ROLE supabase_functions_admin SET search_path TO 'supabase_functions';

--
-- User Config "supabase_read_only_user"
--

ALTER ROLE supabase_read_only_user SET default_transaction_read_only TO 'on';

--
-- User Config "supabase_storage_admin"
--

ALTER ROLE supabase_storage_admin SET search_path TO 'storage', 'public';
ALTER ROLE supabase_storage_admin SET log_statement TO 'none';


--
-- Role memberships
--

GRANT anon TO authenticator WITH INHERIT FALSE GRANTED BY postgres;
GRANT anon TO postgres WITH ADMIN OPTION, INHERIT TRUE GRANTED BY postgres;
GRANT authenticated TO authenticator WITH INHERIT FALSE GRANTED BY postgres;
GRANT authenticated TO postgres WITH ADMIN OPTION, INHERIT TRUE GRANTED BY postgres;
GRANT authenticator TO postgres WITH ADMIN OPTION, INHERIT TRUE GRANTED BY postgres;
GRANT authenticator TO supabase_storage_admin WITH INHERIT FALSE GRANTED BY postgres;
GRANT dbrole_admin TO authenticator WITH INHERIT FALSE GRANTED BY postgres;
GRANT dbrole_admin TO dbuser_dba WITH INHERIT TRUE GRANTED BY postgres;
GRANT dbrole_admin TO supabase_admin WITH INHERIT TRUE GRANTED BY postgres;
GRANT dbrole_admin TO supabase_auth_admin WITH INHERIT FALSE GRANTED BY postgres;
GRANT dbrole_admin TO supabase_functions_admin WITH INHERIT FALSE GRANTED BY postgres;
GRANT dbrole_admin TO supabase_replication_admin WITH INHERIT TRUE GRANTED BY postgres;
GRANT dbrole_admin TO supabase_storage_admin WITH INHERIT FALSE GRANTED BY postgres;
GRANT dbrole_readonly TO dbrole_readwrite WITH INHERIT TRUE GRANTED BY postgres;
GRANT dbrole_readonly TO dbuser_monitor WITH INHERIT TRUE GRANTED BY postgres;
GRANT dbrole_readonly TO replicator WITH INHERIT TRUE GRANTED BY postgres;
GRANT dbrole_readonly TO supabase_read_only_user WITH INHERIT TRUE GRANTED BY postgres;
GRANT dbrole_readwrite TO dbrole_admin WITH INHERIT TRUE GRANTED BY postgres;
GRANT pg_create_subscription TO postgres WITH ADMIN OPTION, INHERIT TRUE GRANTED BY postgres;
GRANT pg_monitor TO dbrole_admin WITH INHERIT TRUE GRANTED BY postgres;
GRANT pg_monitor TO dbuser_monitor WITH INHERIT TRUE GRANTED BY postgres;
GRANT pg_monitor TO postgres WITH ADMIN OPTION, INHERIT TRUE GRANTED BY postgres;
GRANT pg_monitor TO replicator WITH INHERIT TRUE GRANTED BY postgres;
GRANT pg_monitor TO supabase_etl_admin WITH INHERIT TRUE GRANTED BY postgres;
GRANT pg_monitor TO supabase_read_only_user WITH INHERIT TRUE GRANTED BY postgres;
GRANT pg_read_all_data TO postgres WITH ADMIN OPTION, INHERIT TRUE GRANTED BY postgres;
GRANT pg_read_all_data TO supabase_etl_admin WITH INHERIT TRUE GRANTED BY postgres;
GRANT pg_read_all_data TO supabase_read_only_user WITH INHERIT TRUE GRANTED BY postgres;
GRANT pg_signal_backend TO postgres WITH ADMIN OPTION, INHERIT TRUE GRANTED BY postgres;
GRANT pgsodium_keyholder TO pgsodium_keymaker WITH INHERIT TRUE GRANTED BY postgres;
GRANT pgsodium_keyholder TO postgres WITH ADMIN OPTION, INHERIT TRUE GRANTED BY postgres;
GRANT pgsodium_keyholder TO service_role WITH INHERIT TRUE GRANTED BY postgres;
GRANT pgsodium_keyiduser TO pgsodium_keyholder WITH INHERIT TRUE GRANTED BY postgres;
GRANT pgsodium_keyiduser TO pgsodium_keymaker WITH INHERIT TRUE GRANTED BY postgres;
GRANT pgsodium_keyiduser TO postgres WITH ADMIN OPTION, INHERIT TRUE GRANTED BY postgres;
GRANT pgsodium_keymaker TO postgres WITH ADMIN OPTION, INHERIT TRUE GRANTED BY postgres;
GRANT service_role TO authenticator WITH INHERIT FALSE GRANTED BY postgres;
GRANT service_role TO postgres WITH ADMIN OPTION, INHERIT TRUE GRANTED BY postgres;
GRANT supabase_functions_admin TO postgres WITH INHERIT TRUE GRANTED BY postgres;
GRANT supabase_realtime_admin TO postgres WITH INHERIT TRUE GRANTED BY postgres;






\unrestrict Y4DAyNJ7mo80XMSc7Jz3pO50WwK3ELbc5hNoFfGzu80OiIf8RJ35WmRzIoG7v0H

--
-- PostgreSQL database cluster dump complete
--

