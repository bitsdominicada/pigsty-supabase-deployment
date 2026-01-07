-- ============================================
-- MIGRACIÓN DE ESQUEMA: Origen -> Staging
-- Fecha: 2024-12-26
-- Origen: 194.163.149.70 (REFERENCIA)
-- Destino: 167.114.2.209 (STAGING)
-- ============================================

BEGIN;

-- ============================================
-- PARTE 1: CREAR ENUMs FALTANTES
-- ============================================

DO $$ BEGIN
    CREATE TYPE public.day_status AS ENUM ('pending', 'calculated', 'approved', 'disputed', 'finalized', 'paid');
EXCEPTION WHEN duplicate_object THEN NULL; END $$;

DO $$ BEGIN
    CREATE TYPE public.identification_document_type AS ENUM ('cedula', 'passport', 'rnc', 'license', 'nss', 'foreign_id', 'tax_id', 'work_permit', 'residence_permit', 'other');
EXCEPTION WHEN duplicate_object THEN NULL; END $$;

DO $$ BEGIN
    CREATE TYPE public.insurance_policy_type AS ENUM ('health', 'dental', 'vision', 'life', 'disability', 'accident', 'travel', 'vehicle', 'property', 'liability', 'workers_comp', 'supplemental', 'other');
EXCEPTION WHEN duplicate_object THEN NULL; END $$;

DO $$ BEGIN
    CREATE TYPE public.org_type AS ENUM ('company', 'branch');
EXCEPTION WHEN duplicate_object THEN NULL; END $$;

DO $$ BEGIN
    CREATE TYPE public.shift_type AS ENUM ('regular', 'overtime', 'split', 'on_call', 'flexible');
EXCEPTION WHEN duplicate_object THEN NULL; END $$;

DO $$ BEGIN
    CREATE TYPE public.time_entry_source AS ENUM ('mobile_app', 'web', 'kiosk', 'biometric', 'manual', 'system', 'geofence', 'api');
EXCEPTION WHEN duplicate_object THEN NULL; END $$;

DO $$ BEGIN
    CREATE TYPE public.time_entry_type AS ENUM ('clock_in', 'clock_out', 'break_start', 'break_end', 'manual_adjustment', 'system_correction');
EXCEPTION WHEN duplicate_object THEN NULL; END $$;

DO $$ BEGIN
    CREATE TYPE public.verification_method AS ENUM ('biometric_fingerprint', 'biometric_face', 'biometric_iris', 'pin', 'photo', 'qr_code', 'nfc', 'badge', 'gps', 'wifi', 'none');
EXCEPTION WHEN duplicate_object THEN NULL; END $$;

-- ============================================
-- PARTE 2: FUNCIONES DE TRIGGER
-- ============================================

CREATE OR REPLACE FUNCTION public.calculate_department_path()
 RETURNS trigger
 LANGUAGE plpgsql
AS $function$
DECLARE
    parent_path TEXT[];
    parent_level INTEGER;
BEGIN
    IF NEW.parent_department_id IS NULL THEN
        NEW.path := ARRAY[NEW.code];
        NEW.level := 1;
    ELSE
        SELECT path, level INTO parent_path, parent_level
        FROM departments
        WHERE id = NEW.parent_department_id;

        NEW.path := parent_path || NEW.code;
        NEW.level := COALESCE(parent_level, 0) + 1;
    END IF;

    RETURN NEW;
END;
$function$;

CREATE OR REPLACE FUNCTION public.ensure_single_primary_document()
 RETURNS trigger
 LANGUAGE plpgsql
AS $function$
BEGIN
    IF NEW.is_primary = true THEN
        UPDATE entity_identification_documents
        SET is_primary = false, updated_at = now()
        WHERE entity_id = NEW.entity_id AND document_type = NEW.document_type
          AND id != NEW.id AND is_primary = true AND deleted_at IS NULL;
    END IF;
    RETURN NEW;
END;
$function$;

CREATE OR REPLACE FUNCTION public.ensure_single_primary_insurance()
 RETURNS trigger
 LANGUAGE plpgsql
AS $function$
BEGIN
    IF NEW.is_primary = true THEN
        UPDATE entity_insurance_policies
        SET is_primary = false, updated_at = now()
        WHERE entity_id = NEW.entity_id AND policy_type = NEW.policy_type
          AND id != NEW.id AND is_primary = true AND deleted_at IS NULL;
    END IF;
    RETURN NEW;
END;
$function$;

CREATE OR REPLACE FUNCTION public.queue_time_summary_recalculation()
 RETURNS trigger
 LANGUAGE plpgsql
AS $function$
BEGIN
    IF TG_OP = 'INSERT' OR TG_OP = 'UPDATE' THEN
        UPDATE daily_time_summary
        SET status = 'pending'
        WHERE employee_id = NEW.employee_id
        AND summary_date = NEW.entry_date
        AND status NOT IN ('finalized', 'paid');

        RETURN NEW;
    END IF;

    RETURN NULL;
END;
$function$;

CREATE OR REPLACE FUNCTION public.set_time_entry_derived_fields()
 RETURNS trigger
 LANGUAGE plpgsql
AS $function$
BEGIN
    NEW.entry_date := (NEW.entry_timestamp AT TIME ZONE 'America/Santo_Domingo')::date;
    NEW.entry_time := (NEW.entry_timestamp AT TIME ZONE 'America/Santo_Domingo')::time;
    RETURN NEW;
END;
$function$;

CREATE OR REPLACE FUNCTION public.update_daily_time_summary_timestamp()
 RETURNS trigger
 LANGUAGE plpgsql
AS $function$
BEGIN
    NEW.updated_at = NOW();
    RETURN NEW;
END;
$function$;

CREATE OR REPLACE FUNCTION public.update_departments_timestamp()
 RETURNS trigger
 LANGUAGE plpgsql
AS $function$
BEGIN
    NEW.updated_at = NOW();
    RETURN NEW;
END;
$function$;

CREATE OR REPLACE FUNCTION public.update_entity_party_updated_at()
 RETURNS trigger
 LANGUAGE plpgsql
AS $function$
BEGIN
    NEW.updated_at = now();
    RETURN NEW;
END;
$function$;

CREATE OR REPLACE FUNCTION public.update_heuristic_rules_timestamp()
 RETURNS trigger
 LANGUAGE plpgsql
AS $function$
BEGIN
    NEW.updated_at = NOW();
    RETURN NEW;
END;
$function$;

CREATE OR REPLACE FUNCTION public.update_jobs_timestamp()
 RETURNS trigger
 LANGUAGE plpgsql
AS $function$
BEGIN
    NEW.updated_at = NOW();
    RETURN NEW;
END;
$function$;

CREATE OR REPLACE FUNCTION public.update_leave_balances_timestamp()
 RETURNS trigger
 LANGUAGE plpgsql
AS $function$
BEGIN
    NEW.updated_at = NOW();
    RETURN NEW;
END;
$function$;

CREATE OR REPLACE FUNCTION public.update_leave_requests_timestamp()
 RETURNS trigger
 LANGUAGE plpgsql
AS $function$
BEGIN
    NEW.updated_at = NOW();
    RETURN NEW;
END;
$function$;

CREATE OR REPLACE FUNCTION public.update_leave_types_timestamp()
 RETURNS trigger
 LANGUAGE plpgsql
AS $function$
BEGIN
    NEW.updated_at = NOW();
    RETURN NEW;
END;
$function$;

CREATE OR REPLACE FUNCTION public.update_scheduled_shifts_timestamp()
 RETURNS trigger
 LANGUAGE plpgsql
AS $function$
BEGIN
    NEW.updated_at = NOW();
    RETURN NEW;
END;
$function$;

CREATE OR REPLACE FUNCTION public.update_shift_templates_timestamp()
 RETURNS trigger
 LANGUAGE plpgsql
AS $function$
BEGIN
    NEW.updated_at = NOW();
    RETURN NEW;
END;
$function$;

-- ============================================
-- PARTE 3: COLUMNAS NUEVAS EN employees
-- ============================================

ALTER TABLE public.employees ADD COLUMN IF NOT EXISTS addresses jsonb DEFAULT '[]'::jsonb;
ALTER TABLE public.employees ADD COLUMN IF NOT EXISTS ai_insights jsonb DEFAULT '{}'::jsonb;
ALTER TABLE public.employees ADD COLUMN IF NOT EXISTS ai_performance_metrics jsonb DEFAULT '{}'::jsonb;
ALTER TABLE public.employees ADD COLUMN IF NOT EXISTS bank_account_type text;
ALTER TABLE public.employees ADD COLUMN IF NOT EXISTS commission_structure jsonb DEFAULT '{}'::jsonb;
ALTER TABLE public.employees ADD COLUMN IF NOT EXISTS date_of_birth date;
ALTER TABLE public.employees ADD COLUMN IF NOT EXISTS department_id uuid;
ALTER TABLE public.employees ADD COLUMN IF NOT EXISTS emails jsonb DEFAULT '[]'::jsonb;
ALTER TABLE public.employees ADD COLUMN IF NOT EXISTS first_name text;
ALTER TABLE public.employees ADD COLUMN IF NOT EXISTS gender gender_enum;
ALTER TABLE public.employees ADD COLUMN IF NOT EXISTS general_notes text;
ALTER TABLE public.employees ADD COLUMN IF NOT EXISTS internal_notes text;
ALTER TABLE public.employees ADD COLUMN IF NOT EXISTS job_id uuid;
ALTER TABLE public.employees ADD COLUMN IF NOT EXISTS last_name text;
ALTER TABLE public.employees ADD COLUMN IF NOT EXISTS manager_id uuid;
ALTER TABLE public.employees ADD COLUMN IF NOT EXISTS marital_status marital_status;
ALTER TABLE public.employees ADD COLUMN IF NOT EXISTS metadata jsonb DEFAULT '{}'::jsonb;
ALTER TABLE public.employees ADD COLUMN IF NOT EXISTS middle_name text;
ALTER TABLE public.employees ADD COLUMN IF NOT EXISTS nationality text;
ALTER TABLE public.employees ADD COLUMN IF NOT EXISTS pay_frequency text DEFAULT 'monthly'::text;
ALTER TABLE public.employees ADD COLUMN IF NOT EXISTS phones jsonb DEFAULT '[]'::jsonb;
ALTER TABLE public.employees ADD COLUMN IF NOT EXISTS photo_url text;
ALTER TABLE public.employees ADD COLUMN IF NOT EXISTS position text;
ALTER TABLE public.employees ADD COLUMN IF NOT EXISTS position_id uuid;
ALTER TABLE public.employees ADD COLUMN IF NOT EXISTS probation_end_date date;
ALTER TABLE public.employees ADD COLUMN IF NOT EXISTS referral_source text;
ALTER TABLE public.employees ADD COLUMN IF NOT EXISTS source text;
ALTER TABLE public.employees ADD COLUMN IF NOT EXISTS tags text[] DEFAULT '{}'::text[];
ALTER TABLE public.employees ADD COLUMN IF NOT EXISTS termination_reason text;
ALTER TABLE public.employees ADD COLUMN IF NOT EXISTS vertical_data jsonb DEFAULT '{}'::jsonb;
ALTER TABLE public.employees ADD COLUMN IF NOT EXISTS work_schedule jsonb DEFAULT '{}'::jsonb;

-- ============================================
-- PARTE 4: COLUMNAS NUEVAS EN organizations
-- ============================================

ALTER TABLE public.organizations ADD COLUMN IF NOT EXISTS addresses jsonb DEFAULT '[]'::jsonb;
ALTER TABLE public.organizations ADD COLUMN IF NOT EXISTS business_hours jsonb DEFAULT '{}'::jsonb;
ALTER TABLE public.organizations ADD COLUMN IF NOT EXISTS contacts jsonb DEFAULT '[]'::jsonb;
ALTER TABLE public.organizations ADD COLUMN IF NOT EXISTS country text DEFAULT 'DO'::text;
ALTER TABLE public.organizations ADD COLUMN IF NOT EXISTS currency text DEFAULT 'DOP'::text;
ALTER TABLE public.organizations ADD COLUMN IF NOT EXISTS description text;
ALTER TABLE public.organizations ADD COLUMN IF NOT EXISTS email text;
ALTER TABLE public.organizations ADD COLUMN IF NOT EXISTS emails jsonb DEFAULT '[]'::jsonb;
ALTER TABLE public.organizations ADD COLUMN IF NOT EXISTS industry text;
ALTER TABLE public.organizations ADD COLUMN IF NOT EXISTS legal_name text;
ALTER TABLE public.organizations ADD COLUMN IF NOT EXISTS locale text DEFAULT 'es'::text;
ALTER TABLE public.organizations ADD COLUMN IF NOT EXISTS logo_url text;
ALTER TABLE public.organizations ADD COLUMN IF NOT EXISTS metadata jsonb DEFAULT '{}'::jsonb;
ALTER TABLE public.organizations ADD COLUMN IF NOT EXISTS org_type org_type DEFAULT 'company'::org_type;
ALTER TABLE public.organizations ADD COLUMN IF NOT EXISTS parent_id uuid;
ALTER TABLE public.organizations ADD COLUMN IF NOT EXISTS phone text;
ALTER TABLE public.organizations ADD COLUMN IF NOT EXISTS phones jsonb DEFAULT '[]'::jsonb;
ALTER TABLE public.organizations ADD COLUMN IF NOT EXISTS rnc text;
ALTER TABLE public.organizations ADD COLUMN IF NOT EXISTS settings jsonb DEFAULT '{}'::jsonb;
ALTER TABLE public.organizations ADD COLUMN IF NOT EXISTS social_links jsonb DEFAULT '{}'::jsonb;
ALTER TABLE public.organizations ADD COLUMN IF NOT EXISTS tax_info jsonb;
ALTER TABLE public.organizations ADD COLUMN IF NOT EXISTS timezone text DEFAULT 'America/Santo_Domingo'::text;
ALTER TABLE public.organizations ADD COLUMN IF NOT EXISTS trade_name text;
ALTER TABLE public.organizations ADD COLUMN IF NOT EXISTS website text;



-- ============================================
-- PARTE 5: TABLAS NUEVAS
-- ============================================

CREATE TABLE pgmq.a_embedding_jobs (
    msg_id bigint NOT NULL,
    read_ct integer DEFAULT 0 NOT NULL,
    enqueued_at timestamp with time zone DEFAULT now() NOT NULL,
    archived_at timestamp with time zone DEFAULT now() NOT NULL,
    vt timestamp with time zone NOT NULL,
    message jsonb,
    headers jsonb
);
CREATE TABLE pgmq.q_embedding_jobs (
    msg_id bigint NOT NULL,
    read_ct integer DEFAULT 0 NOT NULL,
    enqueued_at timestamp with time zone DEFAULT now() NOT NULL,
    vt timestamp with time zone NOT NULL,
    message jsonb,
    headers jsonb
);
ALTER TABLE pgmq.q_embedding_jobs ALTER COLUMN msg_id ADD GENERATED ALWAYS AS IDENTITY (
    SEQUENCE NAME pgmq.q_embedding_jobs_msg_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1
);
CREATE TABLE public.daily_time_summary (
    id uuid DEFAULT gen_random_uuid() NOT NULL,
    organization_id uuid NOT NULL,
    employee_id uuid NOT NULL,
    summary_date date NOT NULL,
    status public.day_status DEFAULT 'pending'::public.day_status NOT NULL,
    scheduled_minutes integer DEFAULT 0,
    worked_minutes integer DEFAULT 0,
    regular_minutes integer DEFAULT 0,
    overtime_minutes integer DEFAULT 0,
    double_time_minutes integer DEFAULT 0,
    break_minutes integer DEFAULT 0,
    paid_break_minutes integer DEFAULT 0,
    unpaid_break_minutes integer DEFAULT 0,
    variance_minutes integer GENERATED ALWAYS AS ((worked_minutes - scheduled_minutes)) STORED,
    first_clock_in timestamp with time zone,
    last_clock_out timestamp with time zone,
    is_present boolean DEFAULT false,
    is_absent boolean DEFAULT false,
    is_late boolean DEFAULT false,
    late_minutes integer DEFAULT 0,
    is_early_leave boolean DEFAULT false,
    early_leave_minutes integer DEFAULT 0,
    leave_type character varying(50),
    leave_minutes integer DEFAULT 0,
    is_paid_leave boolean,
    pay_code character varying(50),
    base_pay_amount numeric(12,2),
    overtime_pay_amount numeric(12,2),
    total_pay_amount numeric(12,2),
    exceptions jsonb DEFAULT '[]'::jsonb,
    notes text,
    department_id uuid,
    approved_by uuid,
    approved_at timestamp with time zone,
    finalized_by uuid,
    finalized_at timestamp with time zone,
    last_calculated_at timestamp with time zone,
    calculation_version integer DEFAULT 1,
    created_at timestamp with time zone DEFAULT now() NOT NULL,
    updated_at timestamp with time zone DEFAULT now() NOT NULL
);
COMMENT ON TABLE public.daily_time_summary IS 'Pre-calculated daily totals for fast reporting and payroll';
CREATE TABLE public.departments (
    id uuid DEFAULT gen_random_uuid() NOT NULL,
    organization_id uuid NOT NULL,
    code character varying(50) NOT NULL,
    name character varying(200) NOT NULL,
    description text,
    parent_department_id uuid,
    level integer DEFAULT 1,
    path text[],
    manager_employee_id uuid,
    cost_center character varying(50),
    location_id uuid,
    location_name character varying(200),
    config jsonb DEFAULT '{}'::jsonb,
    is_active boolean DEFAULT true,
    effective_date date DEFAULT CURRENT_DATE,
    end_date date,
    created_at timestamp with time zone DEFAULT now() NOT NULL,
    updated_at timestamp with time zone DEFAULT now() NOT NULL,
    created_by uuid,
    updated_by uuid
);
COMMENT ON TABLE public.departments IS 'Organizational units with hierarchical structure';
CREATE TABLE public.entity_identification_documents (
    id uuid DEFAULT gen_random_uuid() NOT NULL,
    organization_id uuid NOT NULL,
    entity_id uuid NOT NULL,
    document_type public.identification_document_type NOT NULL,
    document_number character varying(50) NOT NULL,
    document_number_normalized character varying(50) GENERATED ALWAYS AS (upper(regexp_replace((document_number)::text, '[-\s]'::text, ''::text, 'g'::text))) STORED NOT NULL,
    issuing_country character(2) DEFAULT 'DO'::bpchar,
    issuing_authority character varying(100),
    issued_at date,
    expires_at date,
    is_primary boolean DEFAULT false NOT NULL,
    is_verified boolean DEFAULT false NOT NULL,
    verified_at timestamp with time zone,
    verification_method character varying(50),
    image_url_front text,
    image_url_back text,
    label character varying(100),
    notes text,
    custom_fields jsonb DEFAULT '{}'::jsonb,
    created_at timestamp with time zone DEFAULT now() NOT NULL,
    created_by uuid,
    updated_at timestamp with time zone DEFAULT now() NOT NULL,
    updated_by uuid,
    deleted_at timestamp with time zone,
    deleted_by uuid,
    CONSTRAINT ck_doc_dates_valid CHECK (((expires_at IS NULL) OR (issued_at IS NULL) OR (expires_at > issued_at)))
);
CREATE TABLE public.entity_insurance_policies (
    id uuid DEFAULT gen_random_uuid() NOT NULL,
    organization_id uuid NOT NULL,
    entity_id uuid NOT NULL,
    provider_entity_id uuid,
    provider_code character varying(50),
    provider_name character varying(200),
    policy_type public.insurance_policy_type DEFAULT 'health'::public.insurance_policy_type NOT NULL,
    policy_number character varying(100) NOT NULL,
    policy_number_normalized character varying(100) GENERATED ALWAYS AS (upper(regexp_replace((policy_number)::text, '[-\s]'::text, ''::text, 'g'::text))) STORED NOT NULL,
    plan_code character varying(50),
    plan_name character varying(200),
    group_number character varying(50),
    subscriber_id character varying(100),
    subscriber_name character varying(200),
    subscriber_relationship character varying(50) DEFAULT 'self'::character varying,
    nss character varying(50),
    effective_date date,
    expiration_date date,
    copay numeric(10,2),
    deductible numeric(10,2),
    out_of_pocket_max numeric(10,2),
    coverage_details jsonb DEFAULT '{}'::jsonb,
    is_primary boolean DEFAULT false NOT NULL,
    is_active boolean DEFAULT true NOT NULL,
    is_verified boolean DEFAULT false NOT NULL,
    verified_at timestamp with time zone,
    card_image_url_front text,
    card_image_url_back text,
    notes text,
    custom_fields jsonb DEFAULT '{}'::jsonb,
    created_at timestamp with time zone DEFAULT now() NOT NULL,
    created_by uuid,
    updated_at timestamp with time zone DEFAULT now() NOT NULL,
    updated_by uuid,
    deleted_at timestamp with time zone,
    deleted_by uuid,
    CONSTRAINT ck_policy_dates_valid CHECK (((expiration_date IS NULL) OR (effective_date IS NULL) OR (expiration_date >= effective_date)))
);
CREATE TABLE public.jobs (
    id uuid DEFAULT gen_random_uuid() NOT NULL,
    organization_id uuid NOT NULL,
    code character varying(50) NOT NULL,
    title character varying(200) NOT NULL,
    description text,
    job_family character varying(100),
    job_level integer,
    is_exempt boolean DEFAULT false,
    is_supervisory boolean DEFAULT false,
    pay_grade character varying(50),
    min_salary numeric(15,2),
    max_salary numeric(15,2),
    salary_currency character varying(3) DEFAULT 'DOP'::character varying,
    requirements jsonb DEFAULT '{}'::jsonb,
    default_schedule jsonb DEFAULT '{}'::jsonb,
    benefits_eligibility jsonb DEFAULT '{}'::jsonb,
    is_active boolean DEFAULT true,
    effective_date date,
    end_date date,
    created_at timestamp with time zone DEFAULT now() NOT NULL,
    updated_at timestamp with time zone DEFAULT now() NOT NULL,
    created_by uuid,
    updated_by uuid,
    CONSTRAINT jobs_check CHECK (((min_salary IS NULL) OR (max_salary IS NULL) OR (min_salary <= max_salary))),
    CONSTRAINT jobs_job_level_check CHECK (((job_level >= 1) AND (job_level <= 20)))
);
COMMENT ON TABLE public.jobs IS 'Position templates with pay grades, requirements, and benefit eligibility';
CREATE TABLE public.leave_balances (
    id uuid DEFAULT gen_random_uuid() NOT NULL,
    organization_id uuid NOT NULL,
    employee_id uuid NOT NULL,
    leave_type_id uuid NOT NULL,
    year integer DEFAULT EXTRACT(year FROM CURRENT_DATE) NOT NULL,
    entitled_days numeric(5,2) DEFAULT 0,
    accrued_days numeric(5,2) DEFAULT 0,
    used_days numeric(5,2) DEFAULT 0,
    pending_days numeric(5,2) DEFAULT 0,
    carried_over_days numeric(5,2) DEFAULT 0,
    available_days numeric(5,2) GENERATED ALWAYS AS ((((accrued_days + carried_over_days) - used_days) - pending_days)) STORED,
    last_accrual_date date,
    created_at timestamp with time zone DEFAULT now() NOT NULL,
    updated_at timestamp with time zone DEFAULT now() NOT NULL
);
COMMENT ON TABLE public.leave_balances IS 'Employee leave balances per type per year';
CREATE TABLE public.leave_requests (
    id uuid DEFAULT gen_random_uuid() NOT NULL,
    organization_id uuid NOT NULL,
    employee_id uuid NOT NULL,
    leave_type_id uuid NOT NULL,
    start_date date NOT NULL,
    end_date date NOT NULL,
    is_half_day_start boolean DEFAULT false,
    is_half_day_end boolean DEFAULT false,
    total_days numeric(5,2) NOT NULL,
    reason text,
    documentation_url text,
    status character varying(50) DEFAULT 'pending'::character varying NOT NULL,
    approved_by uuid,
    approved_at timestamp with time zone,
    rejection_reason text,
    shifts_affected integer DEFAULT 0,
    coverage_arranged boolean DEFAULT false,
    created_at timestamp with time zone DEFAULT now() NOT NULL,
    updated_at timestamp with time zone DEFAULT now() NOT NULL,
    created_by uuid,
    CONSTRAINT leave_requests_check CHECK ((end_date >= start_date)),
    CONSTRAINT leave_requests_total_days_check CHECK ((total_days > (0)::numeric))
);
COMMENT ON TABLE public.leave_requests IS 'Employee leave requests with approval workflow';
CREATE TABLE public.leave_types (
    id uuid DEFAULT gen_random_uuid() NOT NULL,
    organization_id uuid NOT NULL,
    code character varying(50) NOT NULL,
    name character varying(200) NOT NULL,
    description text,
    is_paid boolean DEFAULT true,
    affects_accrual boolean DEFAULT true,
    requires_approval boolean DEFAULT true,
    requires_documentation boolean DEFAULT false,
    min_notice_days integer DEFAULT 0,
    max_consecutive_days integer,
    accrual_rate numeric(5,2),
    accrual_frequency character varying(20),
    max_balance numeric(5,2),
    carryover_limit numeric(5,2),
    pay_percentage numeric(5,2) DEFAULT 100,
    color character varying(7) DEFAULT '#10B981'::character varying,
    is_active boolean DEFAULT true,
    created_at timestamp with time zone DEFAULT now() NOT NULL,
    updated_at timestamp with time zone DEFAULT now() NOT NULL
);
COMMENT ON TABLE public.leave_types IS 'Types of leave with accrual rules and pay configuration';
CREATE TABLE public.nlu_heuristic_rules (
    id uuid DEFAULT gen_random_uuid() NOT NULL,
    rule_name text NOT NULL,
    intent text NOT NULL,
    required_keywords text[] DEFAULT '{}'::text[],
    optional_keywords text[] DEFAULT '{}'::text[],
    excluded_keywords text[] DEFAULT '{}'::text[],
    required_patterns text[] DEFAULT '{}'::text[],
    optional_patterns text[] DEFAULT '{}'::text[],
    required_slots text[] DEFAULT '{}'::text[],
    excluded_slots text[] DEFAULT '{}'::text[],
    priority integer DEFAULT 100,
    score double precision DEFAULT 4.0,
    stop_processing boolean DEFAULT true,
    organization_id uuid,
    description text,
    enabled boolean DEFAULT true,
    created_at timestamp with time zone DEFAULT now(),
    updated_at timestamp with time zone DEFAULT now()
);
CREATE TABLE public.positions (
    id uuid DEFAULT gen_random_uuid() NOT NULL,
    organization_id uuid NOT NULL,
    code character varying(50) NOT NULL,
    title character varying(200) NOT NULL,
    job_id uuid,
    department_id uuid,
    reports_to_position_id uuid,
    headcount integer DEFAULT 1,
    filled_count integer DEFAULT 0,
    salary_override numeric(15,2),
    schedule_override jsonb,
    is_active boolean DEFAULT true,
    is_open boolean DEFAULT false,
    created_at timestamp with time zone DEFAULT now() NOT NULL,
    updated_at timestamp with time zone DEFAULT now() NOT NULL
);
COMMENT ON TABLE public.positions IS 'Specific roles linking jobs to departments, can be filled by employees';
CREATE TABLE public.scheduled_shifts (
    id uuid DEFAULT gen_random_uuid() NOT NULL,
    organization_id uuid NOT NULL,
    employee_id uuid NOT NULL,
    shift_date date NOT NULL,
    start_time time without time zone NOT NULL,
    end_time time without time zone NOT NULL,
    shift_template_id uuid,
    breaks jsonb DEFAULT '[]'::jsonb,
    status character varying(50) DEFAULT 'scheduled'::character varying NOT NULL,
    department_id uuid,
    location_name character varying(200),
    notes text,
    is_published boolean DEFAULT false,
    published_at timestamp with time zone,
    published_by uuid,
    acknowledged_at timestamp with time zone,
    original_employee_id uuid,
    swap_reason text,
    created_at timestamp with time zone DEFAULT now() NOT NULL,
    updated_at timestamp with time zone DEFAULT now() NOT NULL,
    created_by uuid
);
COMMENT ON TABLE public.scheduled_shifts IS 'Specific shifts assigned to employees for particular dates';
CREATE TABLE public.shift_templates (
    id uuid DEFAULT gen_random_uuid() NOT NULL,
    organization_id uuid NOT NULL,
    code character varying(50) NOT NULL,
    name character varying(200) NOT NULL,
    description text,
    shift_type public.shift_type DEFAULT 'regular'::public.shift_type NOT NULL,
    start_time time without time zone NOT NULL,
    end_time time without time zone NOT NULL,
    duration_minutes integer GENERATED ALWAYS AS (((EXTRACT(epoch FROM
CASE
    WHEN (end_time > start_time) THEN (end_time - start_time)
    ELSE ((end_time + '24:00:00'::interval) - start_time)
END))::integer / 60)) STORED,
    breaks jsonb DEFAULT '[]'::jsonb,
    pay_code character varying(50),
    is_overnight boolean DEFAULT false,
    overtime_threshold_minutes integer,
    color character varying(7) DEFAULT '#6366F1'::character varying,
    is_active boolean DEFAULT true,
    created_at timestamp with time zone DEFAULT now() NOT NULL,
    updated_at timestamp with time zone DEFAULT now() NOT NULL,
    CONSTRAINT shift_templates_check CHECK ((end_time <> start_time))
);
COMMENT ON TABLE public.shift_templates IS 'Reusable shift patterns with break configurations';
CREATE TABLE public.time_entries (
    id uuid DEFAULT gen_random_uuid() NOT NULL,
    organization_id uuid NOT NULL,
    employee_id uuid NOT NULL,
    entry_timestamp timestamp with time zone NOT NULL,
    entry_date date,
    entry_time time without time zone,
    entry_type public.time_entry_type NOT NULL,
    source public.time_entry_source DEFAULT 'web'::public.time_entry_source NOT NULL,
    verification_method public.verification_method DEFAULT 'none'::public.verification_method,
    device_id character varying(100),
    location_data jsonb,
    photo_url text,
    photo_verified boolean DEFAULT false,
    department_id uuid,
    project_id uuid,
    task_id uuid,
    job_code character varying(50),
    notes text,
    is_processed boolean DEFAULT false,
    processed_at timestamp with time zone,
    is_late boolean,
    is_early_leave boolean,
    is_overtime boolean,
    requires_approval boolean DEFAULT false,
    is_approved boolean,
    approved_by uuid,
    approved_at timestamp with time zone,
    original_entry_id uuid,
    is_correction boolean DEFAULT false,
    correction_reason text,
    created_at timestamp with time zone DEFAULT now() NOT NULL,
    created_by uuid,
    deleted_at timestamp with time zone,
    deleted_by uuid,
    deletion_reason text
);
COMMENT ON TABLE public.time_entries IS 'Immutable time punch events - Event Sourcing pattern for T&A';
CREATE TABLE public.time_entry_modifications (
    id uuid DEFAULT gen_random_uuid() NOT NULL,
    time_entry_id uuid NOT NULL,
    modification_type character varying(50) NOT NULL,
    field_name character varying(100),
    old_value text,
    new_value text,
    reason text NOT NULL,
    modified_by uuid NOT NULL,
    modified_at timestamp with time zone DEFAULT now() NOT NULL,
    ip_address inet,
    user_agent text
);
COMMENT ON TABLE public.time_entry_modifications IS 'Audit trail for all time entry modifications';
ALTER TABLE ONLY pgmq.a_embedding_jobs
    ADD CONSTRAINT a_embedding_jobs_pkey PRIMARY KEY (msg_id);
ALTER TABLE ONLY pgmq.q_embedding_jobs
    ADD CONSTRAINT q_embedding_jobs_pkey PRIMARY KEY (msg_id);
ALTER TABLE ONLY public.daily_time_summary
    ADD CONSTRAINT daily_time_summary_employee_id_summary_date_key UNIQUE (employee_id, summary_date);
ALTER TABLE ONLY public.daily_time_summary
    ADD CONSTRAINT daily_time_summary_pkey PRIMARY KEY (id);
ALTER TABLE ONLY public.departments
    ADD CONSTRAINT departments_organization_id_code_key UNIQUE (organization_id, code);
ALTER TABLE ONLY public.departments
    ADD CONSTRAINT departments_pkey PRIMARY KEY (id);
ALTER TABLE ONLY public.entity_identification_documents
    ADD CONSTRAINT entity_identification_documents_pkey PRIMARY KEY (id);
ALTER TABLE ONLY public.entity_insurance_policies
    ADD CONSTRAINT entity_insurance_policies_pkey PRIMARY KEY (id);
ALTER TABLE ONLY public.jobs
    ADD CONSTRAINT jobs_organization_id_code_key UNIQUE (organization_id, code);
ALTER TABLE ONLY public.jobs
    ADD CONSTRAINT jobs_pkey PRIMARY KEY (id);
ALTER TABLE ONLY public.leave_balances
    ADD CONSTRAINT leave_balances_employee_id_leave_type_id_year_key UNIQUE (employee_id, leave_type_id, year);
ALTER TABLE ONLY public.leave_balances
    ADD CONSTRAINT leave_balances_pkey PRIMARY KEY (id);
ALTER TABLE ONLY public.leave_requests
    ADD CONSTRAINT leave_requests_pkey PRIMARY KEY (id);
ALTER TABLE ONLY public.leave_types
    ADD CONSTRAINT leave_types_organization_id_code_key UNIQUE (organization_id, code);
ALTER TABLE ONLY public.leave_types
    ADD CONSTRAINT leave_types_pkey PRIMARY KEY (id);
ALTER TABLE ONLY public.nlu_heuristic_rules
    ADD CONSTRAINT nlu_heuristic_rules_pkey PRIMARY KEY (id);
ALTER TABLE ONLY public.positions
    ADD CONSTRAINT positions_organization_id_code_key UNIQUE (organization_id, code);
ALTER TABLE ONLY public.positions
    ADD CONSTRAINT positions_pkey PRIMARY KEY (id);
ALTER TABLE ONLY public.scheduled_shifts
    ADD CONSTRAINT scheduled_shifts_employee_id_shift_date_start_time_key UNIQUE (employee_id, shift_date, start_time);
ALTER TABLE ONLY public.scheduled_shifts
    ADD CONSTRAINT scheduled_shifts_pkey PRIMARY KEY (id);
ALTER TABLE ONLY public.shift_templates
    ADD CONSTRAINT shift_templates_organization_id_code_key UNIQUE (organization_id, code);
ALTER TABLE ONLY public.shift_templates
    ADD CONSTRAINT shift_templates_pkey PRIMARY KEY (id);
ALTER TABLE ONLY public.time_entries
    ADD CONSTRAINT time_entries_pkey PRIMARY KEY (id);
ALTER TABLE ONLY public.time_entry_modifications
    ADD CONSTRAINT time_entry_modifications_pkey PRIMARY KEY (id);
ALTER TABLE ONLY public.nlu_heuristic_rules
    ADD CONSTRAINT unique_rule_name_per_org UNIQUE (rule_name, organization_id);
ALTER TABLE ONLY public.entity_identification_documents
    ADD CONSTRAINT uq_org_document_normalized UNIQUE (organization_id, document_number_normalized);
ALTER TABLE ONLY public.entity_insurance_policies
    ADD CONSTRAINT uq_org_provider_policy UNIQUE (organization_id, provider_code, policy_number_normalized);
CREATE INDEX archived_at_idx_embedding_jobs ON pgmq.a_embedding_jobs USING btree (archived_at);
CREATE INDEX q_embedding_jobs_vt_idx ON pgmq.q_embedding_jobs USING btree (vt);
CREATE INDEX idx_daily_summary_absent ON public.daily_time_summary USING btree (organization_id, summary_date) WHERE (is_absent = true);
CREATE INDEX idx_daily_summary_dept_date ON public.daily_time_summary USING btree (department_id, summary_date);
CREATE INDEX idx_daily_summary_employee_date ON public.daily_time_summary USING btree (employee_id, summary_date);
CREATE INDEX idx_daily_summary_exceptions ON public.daily_time_summary USING gin (exceptions) WHERE (exceptions <> '[]'::jsonb);
CREATE INDEX idx_daily_summary_late ON public.daily_time_summary USING btree (organization_id, summary_date) WHERE (is_late = true);
CREATE INDEX idx_daily_summary_org_date ON public.daily_time_summary USING btree (organization_id, summary_date);
CREATE INDEX idx_daily_summary_status ON public.daily_time_summary USING btree (status, organization_id, summary_date);
CREATE INDEX idx_departments_manager ON public.departments USING btree (manager_employee_id);
CREATE INDEX idx_departments_org ON public.departments USING btree (organization_id) WHERE (is_active = true);
CREATE INDEX idx_departments_parent ON public.departments USING btree (parent_department_id);
CREATE INDEX idx_departments_path ON public.departments USING gin (path);
CREATE INDEX idx_entity_docs_entity ON public.entity_identification_documents USING btree (entity_id) WHERE (deleted_at IS NULL);
CREATE INDEX idx_entity_docs_expires ON public.entity_identification_documents USING btree (organization_id, expires_at) WHERE ((deleted_at IS NULL) AND (expires_at IS NOT NULL));
CREATE INDEX idx_entity_docs_org_normalized ON public.entity_identification_documents USING btree (organization_id, document_number_normalized) WHERE (deleted_at IS NULL);
CREATE INDEX idx_entity_docs_type ON public.entity_identification_documents USING btree (organization_id, document_type) WHERE (deleted_at IS NULL);
CREATE INDEX idx_entity_insurance_active ON public.entity_insurance_policies USING btree (organization_id, is_active) WHERE ((deleted_at IS NULL) AND (is_active = true));
CREATE INDEX idx_entity_insurance_entity ON public.entity_insurance_policies USING btree (entity_id) WHERE (deleted_at IS NULL);
CREATE INDEX idx_entity_insurance_expires ON public.entity_insurance_policies USING btree (organization_id, expiration_date) WHERE ((deleted_at IS NULL) AND (expiration_date IS NOT NULL));
CREATE INDEX idx_entity_insurance_policy_num ON public.entity_insurance_policies USING btree (organization_id, policy_number_normalized) WHERE (deleted_at IS NULL);
CREATE INDEX idx_entity_insurance_provider ON public.entity_insurance_policies USING btree (organization_id, provider_code) WHERE (deleted_at IS NULL);
CREATE INDEX idx_heuristic_rules_enabled ON public.nlu_heuristic_rules USING btree (enabled, priority DESC) WHERE (enabled = true);
CREATE INDEX idx_heuristic_rules_org ON public.nlu_heuristic_rules USING btree (organization_id) WHERE (organization_id IS NOT NULL);
CREATE INDEX idx_jobs_family ON public.jobs USING btree (job_family, organization_id);
CREATE INDEX idx_jobs_level ON public.jobs USING btree (job_level, organization_id);
CREATE INDEX idx_jobs_org ON public.jobs USING btree (organization_id) WHERE (is_active = true);
CREATE INDEX idx_jobs_search ON public.jobs USING gin (to_tsvector('spanish'::regconfig, (((title)::text || ' '::text) || COALESCE(description, ''::text))));
CREATE INDEX idx_leave_balances_employee ON public.leave_balances USING btree (employee_id, year);
CREATE INDEX idx_leave_balances_type ON public.leave_balances USING btree (leave_type_id, year);
CREATE INDEX idx_leave_requests_dates ON public.leave_requests USING btree (organization_id, start_date, end_date);
CREATE INDEX idx_leave_requests_employee ON public.leave_requests USING btree (employee_id, start_date);
CREATE INDEX idx_leave_requests_pending ON public.leave_requests USING btree (organization_id) WHERE ((status)::text = 'pending'::text);
CREATE INDEX idx_leave_requests_status ON public.leave_requests USING btree (status, organization_id);
CREATE INDEX idx_leave_types_org ON public.leave_types USING btree (organization_id) WHERE (is_active = true);
CREATE INDEX idx_positions_dept ON public.positions USING btree (department_id);
CREATE INDEX idx_positions_job ON public.positions USING btree (job_id);
CREATE INDEX idx_positions_open ON public.positions USING btree (organization_id, is_open) WHERE (is_open = true);
CREATE INDEX idx_positions_org ON public.positions USING btree (organization_id) WHERE (is_active = true);
CREATE INDEX idx_positions_reports_to ON public.positions USING btree (reports_to_position_id);
CREATE INDEX idx_scheduled_shifts_dept_date ON public.scheduled_shifts USING btree (department_id, shift_date);
CREATE INDEX idx_scheduled_shifts_employee_date ON public.scheduled_shifts USING btree (employee_id, shift_date);
CREATE INDEX idx_scheduled_shifts_org_date ON public.scheduled_shifts USING btree (organization_id, shift_date);
CREATE INDEX idx_scheduled_shifts_template ON public.scheduled_shifts USING btree (shift_template_id);
CREATE INDEX idx_scheduled_shifts_unpublished ON public.scheduled_shifts USING btree (organization_id, shift_date) WHERE (is_published = false);
CREATE INDEX idx_shift_templates_org ON public.shift_templates USING btree (organization_id) WHERE (is_active = true);
CREATE INDEX idx_shift_templates_type ON public.shift_templates USING btree (shift_type, organization_id);
CREATE INDEX idx_time_entries_date_type ON public.time_entries USING btree (entry_date, entry_type) WHERE (deleted_at IS NULL);
CREATE INDEX idx_time_entries_department ON public.time_entries USING btree (department_id, entry_date) WHERE (deleted_at IS NULL);
CREATE INDEX idx_time_entries_employee_date ON public.time_entries USING btree (employee_id, entry_date) WHERE (deleted_at IS NULL);
CREATE INDEX idx_time_entries_needs_approval ON public.time_entries USING btree (organization_id, entry_date) WHERE ((requires_approval = true) AND (is_approved IS NULL) AND (deleted_at IS NULL));
CREATE INDEX idx_time_entries_org_date ON public.time_entries USING btree (organization_id, entry_date) WHERE (deleted_at IS NULL);
CREATE INDEX idx_time_entries_unprocessed ON public.time_entries USING btree (employee_id, entry_date) WHERE ((is_processed = false) AND (deleted_at IS NULL));
CREATE INDEX idx_time_entry_mods_date ON public.time_entry_modifications USING btree (modified_at);
CREATE INDEX idx_time_entry_mods_entry ON public.time_entry_modifications USING btree (time_entry_id);
CREATE INDEX idx_time_entry_mods_user ON public.time_entry_modifications USING btree (modified_by);
CREATE TRIGGER heuristic_rules_updated_at BEFORE UPDATE ON public.nlu_heuristic_rules FOR EACH ROW EXECUTE FUNCTION public.update_heuristic_rules_timestamp();
CREATE TRIGGER trg_daily_time_summary_updated BEFORE UPDATE ON public.daily_time_summary FOR EACH ROW EXECUTE FUNCTION public.update_daily_time_summary_timestamp();
CREATE TRIGGER trg_departments_path BEFORE INSERT OR UPDATE OF parent_department_id ON public.departments FOR EACH ROW EXECUTE FUNCTION public.calculate_department_path();
CREATE TRIGGER trg_departments_updated BEFORE UPDATE ON public.departments FOR EACH ROW EXECUTE FUNCTION public.update_departments_timestamp();
CREATE TRIGGER trg_entity_docs_updated BEFORE UPDATE ON public.entity_identification_documents FOR EACH ROW EXECUTE FUNCTION public.update_entity_party_updated_at();
CREATE TRIGGER trg_entity_insurance_updated BEFORE UPDATE ON public.entity_insurance_policies FOR EACH ROW EXECUTE FUNCTION public.update_entity_party_updated_at();
CREATE TRIGGER trg_jobs_updated BEFORE UPDATE ON public.jobs FOR EACH ROW EXECUTE FUNCTION public.update_jobs_timestamp();
CREATE TRIGGER trg_leave_balances_updated BEFORE UPDATE ON public.leave_balances FOR EACH ROW EXECUTE FUNCTION public.update_leave_balances_timestamp();
CREATE TRIGGER trg_leave_requests_updated BEFORE UPDATE ON public.leave_requests FOR EACH ROW EXECUTE FUNCTION public.update_leave_requests_timestamp();
CREATE TRIGGER trg_leave_types_updated BEFORE UPDATE ON public.leave_types FOR EACH ROW EXECUTE FUNCTION public.update_leave_types_timestamp();
CREATE TRIGGER trg_scheduled_shifts_updated BEFORE UPDATE ON public.scheduled_shifts FOR EACH ROW EXECUTE FUNCTION public.update_scheduled_shifts_timestamp();
CREATE TRIGGER trg_shift_templates_updated BEFORE UPDATE ON public.shift_templates FOR EACH ROW EXECUTE FUNCTION public.update_shift_templates_timestamp();
CREATE TRIGGER trg_single_primary_doc BEFORE INSERT OR UPDATE OF is_primary ON public.entity_identification_documents FOR EACH ROW WHEN ((new.is_primary = true)) EXECUTE FUNCTION public.ensure_single_primary_document();
CREATE TRIGGER trg_single_primary_insurance BEFORE INSERT OR UPDATE OF is_primary ON public.entity_insurance_policies FOR EACH ROW WHEN ((new.is_primary = true)) EXECUTE FUNCTION public.ensure_single_primary_insurance();
CREATE TRIGGER trg_time_entry_derived BEFORE INSERT OR UPDATE OF entry_timestamp ON public.time_entries FOR EACH ROW EXECUTE FUNCTION public.set_time_entry_derived_fields();
CREATE TRIGGER trg_time_entry_recalc AFTER INSERT OR UPDATE ON public.time_entries FOR EACH ROW EXECUTE FUNCTION public.queue_time_summary_recalculation();
ALTER TABLE ONLY public.daily_time_summary
    ADD CONSTRAINT daily_time_summary_approved_by_fkey FOREIGN KEY (approved_by) REFERENCES public.profiles(user_id);
ALTER TABLE ONLY public.daily_time_summary
    ADD CONSTRAINT daily_time_summary_department_id_fkey FOREIGN KEY (department_id) REFERENCES public.departments(id);
ALTER TABLE ONLY public.daily_time_summary
    ADD CONSTRAINT daily_time_summary_employee_id_fkey FOREIGN KEY (employee_id) REFERENCES public.employees(id) ON DELETE CASCADE;
ALTER TABLE ONLY public.daily_time_summary
    ADD CONSTRAINT daily_time_summary_finalized_by_fkey FOREIGN KEY (finalized_by) REFERENCES public.profiles(user_id);
ALTER TABLE ONLY public.daily_time_summary
    ADD CONSTRAINT daily_time_summary_organization_id_fkey FOREIGN KEY (organization_id) REFERENCES public.organizations(id) ON DELETE CASCADE;
ALTER TABLE ONLY public.departments
    ADD CONSTRAINT departments_created_by_fkey FOREIGN KEY (created_by) REFERENCES public.profiles(user_id);
ALTER TABLE ONLY public.departments
    ADD CONSTRAINT departments_organization_id_fkey FOREIGN KEY (organization_id) REFERENCES public.organizations(id) ON DELETE CASCADE;
ALTER TABLE ONLY public.departments
    ADD CONSTRAINT departments_parent_department_id_fkey FOREIGN KEY (parent_department_id) REFERENCES public.departments(id) ON DELETE SET NULL;
ALTER TABLE ONLY public.departments
    ADD CONSTRAINT departments_updated_by_fkey FOREIGN KEY (updated_by) REFERENCES public.profiles(user_id);
ALTER TABLE ONLY public.entity_identification_documents
    ADD CONSTRAINT entity_identification_documents_created_by_fkey FOREIGN KEY (created_by) REFERENCES auth.users(id);
ALTER TABLE ONLY public.entity_identification_documents
    ADD CONSTRAINT entity_identification_documents_deleted_by_fkey FOREIGN KEY (deleted_by) REFERENCES auth.users(id);
ALTER TABLE ONLY public.entity_identification_documents
    ADD CONSTRAINT entity_identification_documents_entity_id_fkey FOREIGN KEY (entity_id) REFERENCES public.entities(id) ON DELETE CASCADE;
ALTER TABLE ONLY public.entity_identification_documents
    ADD CONSTRAINT entity_identification_documents_organization_id_fkey FOREIGN KEY (organization_id) REFERENCES public.organizations(id) ON DELETE CASCADE;
ALTER TABLE ONLY public.entity_identification_documents
    ADD CONSTRAINT entity_identification_documents_updated_by_fkey FOREIGN KEY (updated_by) REFERENCES auth.users(id);
ALTER TABLE ONLY public.entity_insurance_policies
    ADD CONSTRAINT entity_insurance_policies_created_by_fkey FOREIGN KEY (created_by) REFERENCES auth.users(id);
ALTER TABLE ONLY public.entity_insurance_policies
    ADD CONSTRAINT entity_insurance_policies_deleted_by_fkey FOREIGN KEY (deleted_by) REFERENCES auth.users(id);
ALTER TABLE ONLY public.entity_insurance_policies
    ADD CONSTRAINT entity_insurance_policies_entity_id_fkey FOREIGN KEY (entity_id) REFERENCES public.entities(id) ON DELETE CASCADE;
ALTER TABLE ONLY public.entity_insurance_policies
    ADD CONSTRAINT entity_insurance_policies_organization_id_fkey FOREIGN KEY (organization_id) REFERENCES public.organizations(id) ON DELETE CASCADE;
ALTER TABLE ONLY public.entity_insurance_policies
    ADD CONSTRAINT entity_insurance_policies_provider_entity_id_fkey FOREIGN KEY (provider_entity_id) REFERENCES public.entities(id);
ALTER TABLE ONLY public.entity_insurance_policies
    ADD CONSTRAINT entity_insurance_policies_updated_by_fkey FOREIGN KEY (updated_by) REFERENCES auth.users(id);
ALTER TABLE ONLY public.departments
    ADD CONSTRAINT fk_departments_manager FOREIGN KEY (manager_employee_id) REFERENCES public.employees(id) ON DELETE SET NULL;
ALTER TABLE ONLY public.jobs
    ADD CONSTRAINT jobs_created_by_fkey FOREIGN KEY (created_by) REFERENCES public.profiles(user_id);
ALTER TABLE ONLY public.jobs
    ADD CONSTRAINT jobs_organization_id_fkey FOREIGN KEY (organization_id) REFERENCES public.organizations(id) ON DELETE CASCADE;
ALTER TABLE ONLY public.jobs
    ADD CONSTRAINT jobs_updated_by_fkey FOREIGN KEY (updated_by) REFERENCES public.profiles(user_id);
ALTER TABLE ONLY public.leave_balances
    ADD CONSTRAINT leave_balances_employee_id_fkey FOREIGN KEY (employee_id) REFERENCES public.employees(id) ON DELETE CASCADE;
ALTER TABLE ONLY public.leave_balances
    ADD CONSTRAINT leave_balances_leave_type_id_fkey FOREIGN KEY (leave_type_id) REFERENCES public.leave_types(id) ON DELETE CASCADE;
ALTER TABLE ONLY public.leave_balances
    ADD CONSTRAINT leave_balances_organization_id_fkey FOREIGN KEY (organization_id) REFERENCES public.organizations(id) ON DELETE CASCADE;
ALTER TABLE ONLY public.leave_requests
    ADD CONSTRAINT leave_requests_approved_by_fkey FOREIGN KEY (approved_by) REFERENCES public.profiles(user_id);
ALTER TABLE ONLY public.leave_requests
    ADD CONSTRAINT leave_requests_created_by_fkey FOREIGN KEY (created_by) REFERENCES public.profiles(user_id);
ALTER TABLE ONLY public.leave_requests
    ADD CONSTRAINT leave_requests_employee_id_fkey FOREIGN KEY (employee_id) REFERENCES public.employees(id) ON DELETE CASCADE;
ALTER TABLE ONLY public.leave_requests
    ADD CONSTRAINT leave_requests_leave_type_id_fkey FOREIGN KEY (leave_type_id) REFERENCES public.leave_types(id) ON DELETE CASCADE;
ALTER TABLE ONLY public.leave_requests
    ADD CONSTRAINT leave_requests_organization_id_fkey FOREIGN KEY (organization_id) REFERENCES public.organizations(id) ON DELETE CASCADE;
ALTER TABLE ONLY public.leave_types
    ADD CONSTRAINT leave_types_organization_id_fkey FOREIGN KEY (organization_id) REFERENCES public.organizations(id) ON DELETE CASCADE;
ALTER TABLE ONLY public.nlu_heuristic_rules
    ADD CONSTRAINT nlu_heuristic_rules_organization_id_fkey FOREIGN KEY (organization_id) REFERENCES public.organizations(id) ON DELETE CASCADE;
ALTER TABLE ONLY public.positions
    ADD CONSTRAINT positions_department_id_fkey FOREIGN KEY (department_id) REFERENCES public.departments(id) ON DELETE SET NULL;
ALTER TABLE ONLY public.positions
    ADD CONSTRAINT positions_job_id_fkey FOREIGN KEY (job_id) REFERENCES public.jobs(id) ON DELETE SET NULL;
ALTER TABLE ONLY public.positions
    ADD CONSTRAINT positions_organization_id_fkey FOREIGN KEY (organization_id) REFERENCES public.organizations(id) ON DELETE CASCADE;
ALTER TABLE ONLY public.positions
    ADD CONSTRAINT positions_reports_to_position_id_fkey FOREIGN KEY (reports_to_position_id) REFERENCES public.positions(id) ON DELETE SET NULL;
ALTER TABLE ONLY public.scheduled_shifts
    ADD CONSTRAINT scheduled_shifts_created_by_fkey FOREIGN KEY (created_by) REFERENCES public.profiles(user_id);
ALTER TABLE ONLY public.scheduled_shifts
    ADD CONSTRAINT scheduled_shifts_department_id_fkey FOREIGN KEY (department_id) REFERENCES public.departments(id) ON DELETE SET NULL;
ALTER TABLE ONLY public.scheduled_shifts
    ADD CONSTRAINT scheduled_shifts_employee_id_fkey FOREIGN KEY (employee_id) REFERENCES public.employees(id) ON DELETE CASCADE;
ALTER TABLE ONLY public.scheduled_shifts
    ADD CONSTRAINT scheduled_shifts_organization_id_fkey FOREIGN KEY (organization_id) REFERENCES public.organizations(id) ON DELETE CASCADE;
ALTER TABLE ONLY public.scheduled_shifts
    ADD CONSTRAINT scheduled_shifts_original_employee_id_fkey FOREIGN KEY (original_employee_id) REFERENCES public.employees(id);
ALTER TABLE ONLY public.scheduled_shifts
    ADD CONSTRAINT scheduled_shifts_published_by_fkey FOREIGN KEY (published_by) REFERENCES public.profiles(user_id);
ALTER TABLE ONLY public.scheduled_shifts
    ADD CONSTRAINT scheduled_shifts_shift_template_id_fkey FOREIGN KEY (shift_template_id) REFERENCES public.shift_templates(id) ON DELETE SET NULL;
ALTER TABLE ONLY public.shift_templates
    ADD CONSTRAINT shift_templates_organization_id_fkey FOREIGN KEY (organization_id) REFERENCES public.organizations(id) ON DELETE CASCADE;
ALTER TABLE ONLY public.time_entries
    ADD CONSTRAINT time_entries_approved_by_fkey FOREIGN KEY (approved_by) REFERENCES public.profiles(user_id);
ALTER TABLE ONLY public.time_entries
    ADD CONSTRAINT time_entries_created_by_fkey FOREIGN KEY (created_by) REFERENCES public.profiles(user_id);
ALTER TABLE ONLY public.time_entries
    ADD CONSTRAINT time_entries_deleted_by_fkey FOREIGN KEY (deleted_by) REFERENCES public.profiles(user_id);
ALTER TABLE ONLY public.time_entries
    ADD CONSTRAINT time_entries_department_id_fkey FOREIGN KEY (department_id) REFERENCES public.departments(id);
ALTER TABLE ONLY public.time_entries
    ADD CONSTRAINT time_entries_employee_id_fkey FOREIGN KEY (employee_id) REFERENCES public.employees(id) ON DELETE CASCADE;
ALTER TABLE ONLY public.time_entries
    ADD CONSTRAINT time_entries_organization_id_fkey FOREIGN KEY (organization_id) REFERENCES public.organizations(id) ON DELETE CASCADE;
ALTER TABLE ONLY public.time_entries
    ADD CONSTRAINT time_entries_original_entry_id_fkey FOREIGN KEY (original_entry_id) REFERENCES public.time_entries(id);
ALTER TABLE ONLY public.time_entry_modifications
    ADD CONSTRAINT time_entry_modifications_modified_by_fkey FOREIGN KEY (modified_by) REFERENCES public.profiles(user_id);
ALTER TABLE ONLY public.time_entry_modifications
    ADD CONSTRAINT time_entry_modifications_time_entry_id_fkey FOREIGN KEY (time_entry_id) REFERENCES public.time_entries(id) ON DELETE CASCADE;
ALTER TABLE public.daily_time_summary ENABLE ROW LEVEL SECURITY;
CREATE POLICY daily_time_summary_insert_policy ON public.daily_time_summary FOR INSERT WITH CHECK (((organization_id = public.current_org_id()) OR (auth.role() = 'service_role'::text)));
CREATE POLICY daily_time_summary_select_policy ON public.daily_time_summary FOR SELECT USING (((organization_id = public.current_org_id()) OR (auth.role() = 'service_role'::text)));
CREATE POLICY daily_time_summary_update_policy ON public.daily_time_summary FOR UPDATE USING (((organization_id = public.current_org_id()) OR (auth.role() = 'service_role'::text))) WITH CHECK (((organization_id = public.current_org_id()) OR (auth.role() = 'service_role'::text)));
ALTER TABLE public.departments ENABLE ROW LEVEL SECURITY;
CREATE POLICY departments_delete_policy ON public.departments FOR DELETE TO authenticated USING (((organization_id IN ( SELECT m.organization_id
   FROM public.memberships m
  WHERE ((m.user_id = auth.uid()) AND (m.status = 'active'::text)))) OR (auth.role() = 'service_role'::text)));
CREATE POLICY departments_insert_policy ON public.departments FOR INSERT TO authenticated WITH CHECK (((organization_id IN ( SELECT m.organization_id
   FROM public.memberships m
  WHERE ((m.user_id = auth.uid()) AND (m.status = 'active'::text)))) OR (auth.role() = 'service_role'::text)));
CREATE POLICY departments_select_policy ON public.departments FOR SELECT TO authenticated USING (((organization_id IN ( SELECT m.organization_id
   FROM public.memberships m
  WHERE ((m.user_id = auth.uid()) AND (m.status = 'active'::text)))) OR (auth.role() = 'service_role'::text)));
CREATE POLICY departments_update_policy ON public.departments FOR UPDATE TO authenticated USING (((organization_id IN ( SELECT m.organization_id
   FROM public.memberships m
  WHERE ((m.user_id = auth.uid()) AND (m.status = 'active'::text)))) OR (auth.role() = 'service_role'::text))) WITH CHECK (((organization_id IN ( SELECT m.organization_id
   FROM public.memberships m
  WHERE ((m.user_id = auth.uid()) AND (m.status = 'active'::text)))) OR (auth.role() = 'service_role'::text)));
CREATE POLICY docs_delete_org ON public.entity_identification_documents FOR DELETE USING ((organization_id IN ( SELECT memberships.organization_id
   FROM public.memberships
  WHERE (memberships.user_id = auth.uid()))));
CREATE POLICY docs_insert_org ON public.entity_identification_documents FOR INSERT WITH CHECK ((organization_id IN ( SELECT memberships.organization_id
   FROM public.memberships
  WHERE (memberships.user_id = auth.uid()))));
CREATE POLICY docs_select_org ON public.entity_identification_documents FOR SELECT USING ((organization_id IN ( SELECT memberships.organization_id
   FROM public.memberships
  WHERE (memberships.user_id = auth.uid()))));
CREATE POLICY docs_update_org ON public.entity_identification_documents FOR UPDATE USING ((organization_id IN ( SELECT memberships.organization_id
   FROM public.memberships
  WHERE (memberships.user_id = auth.uid()))));
ALTER TABLE public.entity_identification_documents ENABLE ROW LEVEL SECURITY;
ALTER TABLE public.entity_insurance_policies ENABLE ROW LEVEL SECURITY;
CREATE POLICY insurance_delete_org ON public.entity_insurance_policies FOR DELETE USING ((organization_id IN ( SELECT memberships.organization_id
   FROM public.memberships
  WHERE (memberships.user_id = auth.uid()))));
CREATE POLICY insurance_insert_org ON public.entity_insurance_policies FOR INSERT WITH CHECK ((organization_id IN ( SELECT memberships.organization_id
   FROM public.memberships
  WHERE (memberships.user_id = auth.uid()))));
CREATE POLICY insurance_select_org ON public.entity_insurance_policies FOR SELECT USING ((organization_id IN ( SELECT memberships.organization_id
   FROM public.memberships
  WHERE (memberships.user_id = auth.uid()))));
CREATE POLICY insurance_update_org ON public.entity_insurance_policies FOR UPDATE USING ((organization_id IN ( SELECT memberships.organization_id
   FROM public.memberships
  WHERE (memberships.user_id = auth.uid()))));
ALTER TABLE public.jobs ENABLE ROW LEVEL SECURITY;
CREATE POLICY jobs_delete_policy ON public.jobs FOR DELETE TO authenticated USING (((organization_id IN ( SELECT m.organization_id
   FROM public.memberships m
  WHERE ((m.user_id = auth.uid()) AND (m.status = 'active'::text)))) OR (auth.role() = 'service_role'::text)));
CREATE POLICY jobs_insert_policy ON public.jobs FOR INSERT TO authenticated WITH CHECK (((organization_id IN ( SELECT m.organization_id
   FROM public.memberships m
  WHERE ((m.user_id = auth.uid()) AND (m.status = 'active'::text)))) OR (auth.role() = 'service_role'::text)));
CREATE POLICY jobs_select_policy ON public.jobs FOR SELECT TO authenticated USING (((organization_id IN ( SELECT m.organization_id
   FROM public.memberships m
  WHERE ((m.user_id = auth.uid()) AND (m.status = 'active'::text)))) OR (auth.role() = 'service_role'::text)));
CREATE POLICY jobs_update_policy ON public.jobs FOR UPDATE TO authenticated USING (((organization_id IN ( SELECT m.organization_id
   FROM public.memberships m
  WHERE ((m.user_id = auth.uid()) AND (m.status = 'active'::text)))) OR (auth.role() = 'service_role'::text))) WITH CHECK (((organization_id IN ( SELECT m.organization_id
   FROM public.memberships m
  WHERE ((m.user_id = auth.uid()) AND (m.status = 'active'::text)))) OR (auth.role() = 'service_role'::text)));
ALTER TABLE public.leave_balances ENABLE ROW LEVEL SECURITY;
CREATE POLICY leave_balances_insert_policy ON public.leave_balances FOR INSERT WITH CHECK (((organization_id = public.current_org_id()) OR (auth.role() = 'service_role'::text)));
CREATE POLICY leave_balances_select_policy ON public.leave_balances FOR SELECT USING (((organization_id = public.current_org_id()) OR (auth.role() = 'service_role'::text)));
CREATE POLICY leave_balances_update_policy ON public.leave_balances FOR UPDATE USING (((organization_id = public.current_org_id()) OR (auth.role() = 'service_role'::text)));
ALTER TABLE public.leave_requests ENABLE ROW LEVEL SECURITY;
CREATE POLICY leave_requests_insert_policy ON public.leave_requests FOR INSERT WITH CHECK (((organization_id = public.current_org_id()) OR (auth.role() = 'service_role'::text)));
CREATE POLICY leave_requests_select_policy ON public.leave_requests FOR SELECT USING (((organization_id = public.current_org_id()) OR (auth.role() = 'service_role'::text)));
CREATE POLICY leave_requests_update_policy ON public.leave_requests FOR UPDATE USING (((organization_id = public.current_org_id()) OR (auth.role() = 'service_role'::text)));
ALTER TABLE public.leave_types ENABLE ROW LEVEL SECURITY;
CREATE POLICY leave_types_delete_policy ON public.leave_types FOR DELETE USING (((organization_id = public.current_org_id()) OR (auth.role() = 'service_role'::text)));
CREATE POLICY leave_types_insert_policy ON public.leave_types FOR INSERT WITH CHECK (((organization_id = public.current_org_id()) OR (auth.role() = 'service_role'::text)));
CREATE POLICY leave_types_select_policy ON public.leave_types FOR SELECT USING (((organization_id = public.current_org_id()) OR (auth.role() = 'service_role'::text)));
CREATE POLICY leave_types_update_policy ON public.leave_types FOR UPDATE USING (((organization_id = public.current_org_id()) OR (auth.role() = 'service_role'::text)));
ALTER TABLE public.positions ENABLE ROW LEVEL SECURITY;
CREATE POLICY positions_delete_policy ON public.positions FOR DELETE USING (((organization_id = public.current_org_id()) OR (auth.role() = 'service_role'::text)));
CREATE POLICY positions_insert_policy ON public.positions FOR INSERT WITH CHECK (((organization_id = public.current_org_id()) OR (auth.role() = 'service_role'::text)));
CREATE POLICY positions_select_policy ON public.positions FOR SELECT USING (((organization_id = public.current_org_id()) OR (auth.role() = 'service_role'::text)));
CREATE POLICY positions_update_policy ON public.positions FOR UPDATE USING (((organization_id = public.current_org_id()) OR (auth.role() = 'service_role'::text))) WITH CHECK (((organization_id = public.current_org_id()) OR (auth.role() = 'service_role'::text)));
ALTER TABLE public.scheduled_shifts ENABLE ROW LEVEL SECURITY;
CREATE POLICY scheduled_shifts_delete_policy ON public.scheduled_shifts FOR DELETE USING (((organization_id = public.current_org_id()) OR (auth.role() = 'service_role'::text)));
CREATE POLICY scheduled_shifts_insert_policy ON public.scheduled_shifts FOR INSERT WITH CHECK (((organization_id = public.current_org_id()) OR (auth.role() = 'service_role'::text)));
CREATE POLICY scheduled_shifts_select_policy ON public.scheduled_shifts FOR SELECT USING (((organization_id = public.current_org_id()) OR (auth.role() = 'service_role'::text)));
CREATE POLICY scheduled_shifts_update_policy ON public.scheduled_shifts FOR UPDATE USING (((organization_id = public.current_org_id()) OR (auth.role() = 'service_role'::text)));
ALTER TABLE public.shift_templates ENABLE ROW LEVEL SECURITY;
CREATE POLICY shift_templates_delete_policy ON public.shift_templates FOR DELETE USING (((organization_id = public.current_org_id()) OR (auth.role() = 'service_role'::text)));
CREATE POLICY shift_templates_insert_policy ON public.shift_templates FOR INSERT WITH CHECK (((organization_id = public.current_org_id()) OR (auth.role() = 'service_role'::text)));
CREATE POLICY shift_templates_select_policy ON public.shift_templates FOR SELECT USING (((organization_id = public.current_org_id()) OR (auth.role() = 'service_role'::text)));
CREATE POLICY shift_templates_update_policy ON public.shift_templates FOR UPDATE USING (((organization_id = public.current_org_id()) OR (auth.role() = 'service_role'::text)));
ALTER TABLE public.time_entries ENABLE ROW LEVEL SECURITY;
CREATE POLICY time_entries_insert_policy ON public.time_entries FOR INSERT WITH CHECK (((organization_id = public.current_org_id()) OR (auth.role() = 'service_role'::text)));
CREATE POLICY time_entries_select_policy ON public.time_entries FOR SELECT USING (((organization_id = public.current_org_id()) OR (auth.role() = 'service_role'::text)));
CREATE POLICY time_entries_update_policy ON public.time_entries FOR UPDATE USING (((organization_id = public.current_org_id()) OR (auth.role() = 'service_role'::text))) WITH CHECK (((organization_id = public.current_org_id()) OR (auth.role() = 'service_role'::text)));
ALTER TABLE public.time_entry_modifications ENABLE ROW LEVEL SECURITY;
CREATE POLICY time_entry_mods_insert_policy ON public.time_entry_modifications FOR INSERT WITH CHECK ((EXISTS ( SELECT 1
   FROM public.time_entries te
  WHERE ((te.id = time_entry_modifications.time_entry_id) AND ((te.organization_id = public.current_org_id()) OR (auth.role() = 'service_role'::text))))));
CREATE POLICY time_entry_mods_select_policy ON public.time_entry_modifications FOR SELECT USING ((EXISTS ( SELECT 1
   FROM public.time_entries te
  WHERE ((te.id = time_entry_modifications.time_entry_id) AND ((te.organization_id = public.current_org_id()) OR (auth.role() = 'service_role'::text))))));
COMMIT;
