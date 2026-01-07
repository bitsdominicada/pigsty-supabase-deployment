-- ============================================
-- APP SCHEMA - Pigsty Supabase Deployment
-- ============================================
-- Este archivo contiene el schema de la aplicación
-- Se aplica DESPUÉS del baseline de Supabase
--
-- Generado automáticamente por: 14-sync-app-schema.sh
-- NO EDITAR MANUALMENTE - Los cambios se perderán
-- ============================================

-- Generado: 2025-12-27 15:35:27
-- Origen: 194.163.149.70

--
-- PostgreSQL database dump
--

\restrict p12L0QOdpdXbBKr98WuOiwqwK06CIeOtomGGVtCyttI4XMMJhem0frKXDbW7wGu

-- Dumped from database version 17.7 (Ubuntu 17.7-3.pgdg24.04+1)
-- Dumped by pg_dump version 17.7 (Ubuntu 17.7-3.pgdg24.04+1)

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

--
-- Name: app; Type: SCHEMA; Schema: -; Owner: -
--

CREATE SCHEMA app;


--
-- Name: SCHEMA app; Type: COMMENT; Schema: -; Owner: -
--

COMMENT ON SCHEMA app IS 'Application-specific functions and procedures';


--
-- Name: pgmq; Type: SCHEMA; Schema: -; Owner: -
--

CREATE SCHEMA pgmq;


--
-- Name: public; Type: SCHEMA; Schema: -; Owner: -
--

CREATE SCHEMA public;


--
-- Name: SCHEMA public; Type: COMMENT; Schema: -; Owner: -
--

COMMENT ON SCHEMA public IS 'standard public schema';


--
-- Name: tests; Type: SCHEMA; Schema: -; Owner: -
--

CREATE SCHEMA tests;


--
-- Name: util; Type: SCHEMA; Schema: -; Owner: -
--

CREATE SCHEMA util;


--
-- Name: ai_conversation_status; Type: TYPE; Schema: public; Owner: -
--

CREATE TYPE public.ai_conversation_status AS ENUM (
    'active',
    'completed',
    'archived'
);


--
-- Name: ai_embedding_status; Type: TYPE; Schema: public; Owner: -
--

CREATE TYPE public.ai_embedding_status AS ENUM (
    'pending',
    'processing',
    'completed',
    'failed'
);


--
-- Name: appointment_client_type; Type: TYPE; Schema: public; Owner: -
--

CREATE TYPE public.appointment_client_type AS ENUM (
    'patient',
    'customer',
    'beauty_client',
    'corporate_client',
    'other'
);


--
-- Name: appointment_location_type; Type: TYPE; Schema: public; Owner: -
--

CREATE TYPE public.appointment_location_type AS ENUM (
    'physical',
    'virtual',
    'mobile',
    'hybrid'
);


--
-- Name: appointment_reminder_preference; Type: TYPE; Schema: public; Owner: -
--

CREATE TYPE public.appointment_reminder_preference AS ENUM (
    'none',
    'email',
    'sms',
    'phone',
    'email_sms',
    'all'
);


--
-- Name: TYPE appointment_reminder_preference; Type: COMMENT; Schema: public; Owner: -
--

COMMENT ON TYPE public.appointment_reminder_preference IS 'Patient preference for appointment reminders.';


--
-- Name: appointment_resource_status; Type: TYPE; Schema: public; Owner: -
--

CREATE TYPE public.appointment_resource_status AS ENUM (
    'assigned',
    'confirmed',
    'in_use',
    'released',
    'cancelled'
);


--
-- Name: appointment_resource_type; Type: TYPE; Schema: public; Owner: -
--

CREATE TYPE public.appointment_resource_type AS ENUM (
    'healthcare_provider',
    'medical_equipment',
    'medical_room',
    'beauty_stylist',
    'beauty_technician',
    'beauty_station',
    'delivery_vehicle',
    'warehouse_space',
    'installation_tech',
    'heavy_equipment',
    'tool',
    'vehicle',
    'meeting_room',
    'workspace',
    'event_space',
    'person',
    'equipment',
    'space',
    'other'
);


--
-- Name: appointment_status; Type: TYPE; Schema: public; Owner: -
--

CREATE TYPE public.appointment_status AS ENUM (
    'pending',
    'scheduled',
    'confirmed',
    'in_progress',
    'completed',
    'cancelled',
    'no_show',
    'rescheduled'
);


--
-- Name: blood_type_enum; Type: TYPE; Schema: public; Owner: -
--

CREATE TYPE public.blood_type_enum AS ENUM (
    'A+',
    'A-',
    'B+',
    'B-',
    'AB+',
    'AB-',
    'O+',
    'O-',
    'unknown'
);


--
-- Name: TYPE blood_type_enum; Type: COMMENT; Schema: public; Owner: -
--

COMMENT ON TYPE public.blood_type_enum IS 'Blood type classification (ABO and Rh).';


--
-- Name: checkin_method; Type: TYPE; Schema: public; Owner: -
--

CREATE TYPE public.checkin_method AS ENUM (
    'staff_added',
    'kiosk_self_service',
    'web_self_service',
    'sms_link',
    'qr_code',
    'auto_detected'
);


--
-- Name: client_category; Type: TYPE; Schema: public; Owner: -
--

CREATE TYPE public.client_category AS ENUM (
    'new',
    'regular',
    'vip',
    'inactive'
);


--
-- Name: client_source; Type: TYPE; Schema: public; Owner: -
--

CREATE TYPE public.client_source AS ENUM (
    'walk_in',
    'referral',
    'social_media',
    'website',
    'whatsapp',
    'phone',
    'other'
);


--
-- Name: client_type; Type: TYPE; Schema: public; Owner: -
--

CREATE TYPE public.client_type AS ENUM (
    'individual',
    'business'
);


--
-- Name: day_status; Type: TYPE; Schema: public; Owner: -
--

CREATE TYPE public.day_status AS ENUM (
    'pending',
    'calculated',
    'approved',
    'disputed',
    'finalized',
    'paid'
);


--
-- Name: employment_status_enum; Type: TYPE; Schema: public; Owner: -
--

CREATE TYPE public.employment_status_enum AS ENUM (
    'active',
    'on_leave',
    'suspended',
    'terminated',
    'resigned',
    'retired',
    'deceased'
);


--
-- Name: TYPE employment_status_enum; Type: COMMENT; Schema: public; Owner: -
--

COMMENT ON TYPE public.employment_status_enum IS 'Employment status for employees - tracks current employment state';


--
-- Name: employment_type_enum; Type: TYPE; Schema: public; Owner: -
--

CREATE TYPE public.employment_type_enum AS ENUM (
    'full_time',
    'part_time',
    'contract',
    'temporary',
    'intern',
    'consultant',
    'seasonal'
);


--
-- Name: TYPE employment_type_enum; Type: COMMENT; Schema: public; Owner: -
--

COMMENT ON TYPE public.employment_type_enum IS 'Type of employment contract - defines working arrangement';


--
-- Name: entity_relationship_type; Type: TYPE; Schema: public; Owner: -
--

CREATE TYPE public.entity_relationship_type AS ENUM (
    'parent',
    'child',
    'spouse',
    'domestic_partner',
    'sibling',
    'grandparent',
    'grandchild',
    'legal_guardian',
    'dependent',
    'family_member',
    'primary_care_physician',
    'healthcare_specialist',
    'referring_physician',
    'caregiver',
    'healthcare_proxy',
    'emergency_contact',
    'employer',
    'employee',
    'manager',
    'direct_report',
    'colleague',
    'contractor',
    'freelancer',
    'mentor',
    'mentee',
    'business_client',
    'service_provider_rel',
    'vendor_rel',
    'business_customer',
    'business_partner',
    'investor_rel',
    'stakeholder_rel',
    'board_member',
    'shareholder',
    'teacher_rel',
    'student_rel',
    'tutor',
    'advisor',
    'landlord',
    'tenant',
    'property_manager',
    'homeowner',
    'attorney',
    'legal_representative',
    'financial_advisor',
    'accountant',
    'power_of_attorney',
    'executor',
    'referral',
    'friend',
    'acquaintance',
    'other'
);


--
-- Name: TYPE entity_relationship_type; Type: COMMENT; Schema: public; Owner: -
--

COMMENT ON TYPE public.entity_relationship_type IS 'Types of relationships between entities. Bidirectional - create both directions if needed.
Use custom_fields.relationship_detail for specific nuances.';


--
-- Name: entity_status; Type: TYPE; Schema: public; Owner: -
--

CREATE TYPE public.entity_status AS ENUM (
    'active',
    'inactive',
    'archived'
);


--
-- Name: entity_type; Type: TYPE; Schema: public; Owner: -
--

CREATE TYPE public.entity_type AS ENUM (
    'person',
    'organization'
);


--
-- Name: gender_enum; Type: TYPE; Schema: public; Owner: -
--

CREATE TYPE public.gender_enum AS ENUM (
    'male',
    'female'
);


--
-- Name: gender_identity; Type: TYPE; Schema: public; Owner: -
--

CREATE TYPE public.gender_identity AS ENUM (
    'male',
    'female',
    'non_binary',
    'transgender_male',
    'transgender_female',
    'genderqueer',
    'gender_fluid',
    'agender',
    'other',
    'prefer_not_to_say'
);


--
-- Name: TYPE gender_identity; Type: COMMENT; Schema: public; Owner: -
--

COMMENT ON TYPE public.gender_identity IS 'Gender identity (self-identified).';


--
-- Name: identification_document_type; Type: TYPE; Schema: public; Owner: -
--

CREATE TYPE public.identification_document_type AS ENUM (
    'cedula',
    'passport',
    'rnc',
    'license',
    'nss',
    'foreign_id',
    'tax_id',
    'work_permit',
    'residence_permit',
    'other'
);


--
-- Name: insurance_policy_type; Type: TYPE; Schema: public; Owner: -
--

CREATE TYPE public.insurance_policy_type AS ENUM (
    'health',
    'dental',
    'vision',
    'life',
    'disability',
    'accident',
    'travel',
    'vehicle',
    'property',
    'liability',
    'workers_comp',
    'supplemental',
    'other'
);


--
-- Name: knowledge_content_type; Type: TYPE; Schema: public; Owner: -
--

CREATE TYPE public.knowledge_content_type AS ENUM (
    'faq',
    'policy',
    'catalog',
    'procedure',
    'general_info',
    'promotion'
);


--
-- Name: marital_status; Type: TYPE; Schema: public; Owner: -
--

CREATE TYPE public.marital_status AS ENUM (
    'single',
    'married',
    'divorced',
    'widowed',
    'separated',
    'domestic_partnership',
    'other',
    'prefer_not_to_say'
);


--
-- Name: TYPE marital_status; Type: COMMENT; Schema: public; Owner: -
--

COMMENT ON TYPE public.marital_status IS 'Marital status.';


--
-- Name: notification_method; Type: TYPE; Schema: public; Owner: -
--

CREATE TYPE public.notification_method AS ENUM (
    'email',
    'sms',
    'push',
    'all'
);


--
-- Name: org_type; Type: TYPE; Schema: public; Owner: -
--

CREATE TYPE public.org_type AS ENUM (
    'company',
    'branch'
);


--
-- Name: organization_subtype; Type: TYPE; Schema: public; Owner: -
--

CREATE TYPE public.organization_subtype AS ENUM (
    'customer',
    'supplier',
    'partner',
    'healthcare_provider',
    'insurance_company',
    'government_agency',
    'other_organization',
    'insurance_provider'
);


--
-- Name: patient_category; Type: TYPE; Schema: public; Owner: -
--

CREATE TYPE public.patient_category AS ENUM (
    'regular',
    'vip',
    'insurance',
    'cash',
    'charity',
    'staff',
    'family',
    'referral'
);


--
-- Name: TYPE patient_category; Type: COMMENT; Schema: public; Owner: -
--

COMMENT ON TYPE public.patient_category IS 'Patient category for billing/treatment prioritization.';


--
-- Name: patient_status; Type: TYPE; Schema: public; Owner: -
--

CREATE TYPE public.patient_status AS ENUM (
    'active',
    'inactive',
    'new',
    'prospect',
    'discharged',
    'deceased',
    'transferred',
    'archived',
    'deleted'
);


--
-- Name: TYPE patient_status; Type: COMMENT; Schema: public; Owner: -
--

COMMENT ON TYPE public.patient_status IS 'Patient status in the system.';


--
-- Name: payment_method_enum; Type: TYPE; Schema: public; Owner: -
--

CREATE TYPE public.payment_method_enum AS ENUM (
    'bank_transfer',
    'check',
    'cash',
    'mobile_payment',
    'crypto'
);


--
-- Name: TYPE payment_method_enum; Type: COMMENT; Schema: public; Owner: -
--

COMMENT ON TYPE public.payment_method_enum IS 'Payment method for salary disbursement';


--
-- Name: person_subtype; Type: TYPE; Schema: public; Owner: -
--

CREATE TYPE public.person_subtype AS ENUM (
    'patient',
    'doctor',
    'nurse',
    'employee',
    'technician',
    'therapist',
    'admin',
    'receptionist',
    'other_person',
    'client'
);


--
-- Name: preferred_language; Type: TYPE; Schema: public; Owner: -
--

CREATE TYPE public.preferred_language AS ENUM (
    'es',
    'en',
    'fr',
    'pt',
    'de',
    'it',
    'zh',
    'ja',
    'ko',
    'ar',
    'ru',
    'hi',
    'other'
);


--
-- Name: TYPE preferred_language; Type: COMMENT; Schema: public; Owner: -
--

COMMENT ON TYPE public.preferred_language IS 'Preferred language for communication (ISO 639-1 codes).';


--
-- Name: proficiency_level; Type: TYPE; Schema: public; Owner: -
--

CREATE TYPE public.proficiency_level AS ENUM (
    'trainee',
    'junior',
    'intermediate',
    'senior',
    'expert',
    'master'
);


--
-- Name: provider_type; Type: TYPE; Schema: public; Owner: -
--

CREATE TYPE public.provider_type AS ENUM (
    'doctor',
    'nurse',
    'technician',
    'therapist',
    'employee',
    'other'
);


--
-- Name: relationship_status; Type: TYPE; Schema: public; Owner: -
--

CREATE TYPE public.relationship_status AS ENUM (
    'active',
    'inactive',
    'ended',
    'pending',
    'suspended'
);


--
-- Name: TYPE relationship_status; Type: COMMENT; Schema: public; Owner: -
--

COMMENT ON TYPE public.relationship_status IS 'Status of entity relationship over time.';


--
-- Name: salary_period_enum; Type: TYPE; Schema: public; Owner: -
--

CREATE TYPE public.salary_period_enum AS ENUM (
    'hourly',
    'daily',
    'weekly',
    'biweekly',
    'monthly',
    'annual'
);


--
-- Name: TYPE salary_period_enum; Type: COMMENT; Schema: public; Owner: -
--

COMMENT ON TYPE public.salary_period_enum IS 'Salary payment period - defines how salary is calculated';


--
-- Name: sex_assigned_at_birth; Type: TYPE; Schema: public; Owner: -
--

CREATE TYPE public.sex_assigned_at_birth AS ENUM (
    'male',
    'female',
    'intersex',
    'unknown',
    'prefer_not_to_say'
);


--
-- Name: TYPE sex_assigned_at_birth; Type: COMMENT; Schema: public; Owner: -
--

COMMENT ON TYPE public.sex_assigned_at_birth IS 'Biological sex assigned at birth (for medical purposes).';


--
-- Name: shift_type; Type: TYPE; Schema: public; Owner: -
--

CREATE TYPE public.shift_type AS ENUM (
    'regular',
    'overtime',
    'split',
    'on_call',
    'flexible'
);


--
-- Name: skill_category; Type: TYPE; Schema: public; Owner: -
--

CREATE TYPE public.skill_category AS ENUM (
    'sales',
    'purchase',
    'finance',
    'hr',
    'inventory',
    'healthcare',
    'appointments',
    'analytics',
    'communication',
    'general',
    'beauty',
    'retail',
    'fitness'
);


--
-- Name: skill_execution_status; Type: TYPE; Schema: public; Owner: -
--

CREATE TYPE public.skill_execution_status AS ENUM (
    'pending',
    'running',
    'completed',
    'failed',
    'cancelled',
    'pending_approval'
);


--
-- Name: time_entry_source; Type: TYPE; Schema: public; Owner: -
--

CREATE TYPE public.time_entry_source AS ENUM (
    'mobile_app',
    'web',
    'kiosk',
    'biometric',
    'manual',
    'system',
    'geofence',
    'api'
);


--
-- Name: time_entry_type; Type: TYPE; Schema: public; Owner: -
--

CREATE TYPE public.time_entry_type AS ENUM (
    'clock_in',
    'clock_out',
    'break_start',
    'break_end',
    'manual_adjustment',
    'system_correction'
);


--
-- Name: time_preference; Type: TYPE; Schema: public; Owner: -
--

CREATE TYPE public.time_preference AS ENUM (
    'anytime',
    'morning',
    'afternoon',
    'evening'
);


--
-- Name: user_role; Type: TYPE; Schema: public; Owner: -
--

CREATE TYPE public.user_role AS ENUM (
    'owner',
    'admin',
    'member',
    'viewer'
);


--
-- Name: verification_method; Type: TYPE; Schema: public; Owner: -
--

CREATE TYPE public.verification_method AS ENUM (
    'biometric_fingerprint',
    'biometric_face',
    'biometric_iris',
    'pin',
    'photo',
    'qr_code',
    'nfc',
    'badge',
    'gps',
    'wifi',
    'none'
);


--
-- Name: waitlist_priority; Type: TYPE; Schema: public; Owner: -
--

CREATE TYPE public.waitlist_priority AS ENUM (
    'first_in_line',
    'highest_value',
    'ai_optimized',
    'staff_picks'
);


--
-- Name: waitlist_status; Type: TYPE; Schema: public; Owner: -
--

CREATE TYPE public.waitlist_status AS ENUM (
    'waiting',
    'notified',
    'expired',
    'booked',
    'declined',
    'removed'
);


--
-- Name: walkin_status; Type: TYPE; Schema: public; Owner: -
--

CREATE TYPE public.walkin_status AS ENUM (
    'waiting',
    'called',
    'no_response',
    'serving',
    'completed',
    'walked_away',
    'cancelled'
);


--
-- Name: calculate_appointment_statistics(uuid, date, date); Type: FUNCTION; Schema: app; Owner: -
--

CREATE FUNCTION app.calculate_appointment_statistics(p_organization_id uuid, p_start_date date DEFAULT (CURRENT_DATE - '30 days'::interval), p_end_date date DEFAULT CURRENT_DATE) RETURNS jsonb
    LANGUAGE plpgsql STABLE
    AS $$
DECLARE
    v_stats jsonb;
BEGIN
    WITH stats AS (
        SELECT
            COUNT(*) AS total_appointments,
            COUNT(*) FILTER (WHERE status = 'completed') AS completed,
            COUNT(*) FILTER (WHERE status = 'cancelled') AS cancelled,
            COUNT(*) FILTER (WHERE status = 'no_show') AS no_shows,
            COUNT(*) FILTER (WHERE status IN ('scheduled', 'confirmed')) AS upcoming,
            ROUND(AVG(duration_minutes), 2) AS avg_duration_minutes,
            COUNT(DISTINCT client_entity_id) AS unique_clients,
            COUNT(DISTINCT resource_entity_id) AS unique_resources,
            COUNT(DISTINCT appointment_date) AS days_with_appointments,
            ROUND(
                COUNT(*) FILTER (WHERE status = 'no_show')::numeric / 
                NULLIF(COUNT(*) FILTER (WHERE status IN ('completed', 'no_show', 'cancelled')), 0) * 100,
                2
            ) AS no_show_rate_percent,
            ROUND(
                COUNT(*) FILTER (WHERE status = 'completed')::numeric / 
                NULLIF(COUNT(*) FILTER (WHERE status IN ('completed', 'no_show', 'cancelled')), 0) * 100,
                2
            ) AS completion_rate_percent
        FROM appointments
        WHERE organization_id = p_organization_id
          AND appointment_date BETWEEN p_start_date AND p_end_date
          AND deleted_at IS NULL
    ),
    by_resource_type AS (
        SELECT
            resource_type,
            COUNT(*) AS count,
            ROUND(AVG(duration_minutes), 2) AS avg_duration
        FROM appointments
        WHERE organization_id = p_organization_id
          AND appointment_date BETWEEN p_start_date AND p_end_date
          AND deleted_at IS NULL
        GROUP BY resource_type
    ),
    by_day_of_week AS (
        SELECT
            EXTRACT(DOW FROM appointment_date)::integer AS day_of_week,
            TO_CHAR(appointment_date, 'Day') AS day_name,
            COUNT(*) AS count
        FROM appointments
        WHERE organization_id = p_organization_id
          AND appointment_date BETWEEN p_start_date AND p_end_date
          AND deleted_at IS NULL
        GROUP BY day_of_week, day_name
        ORDER BY day_of_week
    )
    SELECT jsonb_build_object(
        'period', jsonb_build_object(
            'start_date', p_start_date::text,
            'end_date', p_end_date::text
        ),
        'summary', to_jsonb(s.*),
        'by_resource_type', (SELECT jsonb_agg(to_jsonb(brt.*)) FROM by_resource_type brt),
        'by_day_of_week', (SELECT jsonb_agg(to_jsonb(bdow.*)) FROM by_day_of_week bdow)
    )
    INTO v_stats
    FROM stats s;
    
    RETURN v_stats;
END;
$$;


--
-- Name: FUNCTION calculate_appointment_statistics(p_organization_id uuid, p_start_date date, p_end_date date); Type: COMMENT; Schema: app; Owner: -
--

COMMENT ON FUNCTION app.calculate_appointment_statistics(p_organization_id uuid, p_start_date date, p_end_date date) IS 'Calculates comprehensive appointment statistics for reporting and analytics';


--
-- Name: calculate_entity_metrics(uuid); Type: FUNCTION; Schema: app; Owner: -
--

CREATE FUNCTION app.calculate_entity_metrics(p_entity_id uuid) RETURNS jsonb
    LANGUAGE plpgsql SECURITY DEFINER
    AS $$
DECLARE
    v_start_time timestamptz := clock_timestamp();
    v_entity_type text;
    v_org_id uuid;
    v_metrics record;
    v_duration_ms integer;
BEGIN
    -- Get entity info
    SELECT entity_type, organization_id
    INTO v_entity_type, v_org_id
    FROM entities
    WHERE id = p_entity_id;
    
    -- Calculate appointment metrics
    WITH appointment_stats AS (
        SELECT
            COUNT(*) AS total_appointments,
            COUNT(*) FILTER (WHERE status = 'completed') AS completed,
            COUNT(*) FILTER (WHERE status = 'cancelled') AS cancelled,
            COUNT(*) FILTER (WHERE status = 'no_show') AS no_shows,
            COUNT(*) FILTER (WHERE status IN ('scheduled', 'confirmed')) AS upcoming,
            ROUND(AVG(duration_minutes), 2) AS avg_duration,
            MAX(appointment_date) FILTER (WHERE status = 'completed') AS last_appointment,
            MIN(appointment_date) FILTER (WHERE status IN ('scheduled', 'confirmed') AND appointment_date >= CURRENT_DATE) AS next_appointment
        FROM appointments
        WHERE client_entity_id = p_entity_id
          AND deleted_at IS NULL
    )
    SELECT * INTO v_metrics FROM appointment_stats;
    
    -- Calculate duration
    v_duration_ms := EXTRACT(EPOCH FROM (clock_timestamp() - v_start_time)) * 1000;
    
    -- Upsert metrics cache
    INSERT INTO entity_metrics_cache (
        entity_id,
        entity_type,
        organization_id,
        total_appointments,
        completed_appointments,
        cancelled_appointments,
        no_show_appointments,
        upcoming_appointments,
        avg_appointment_duration_minutes,
        last_appointment_date,
        next_appointment_date,
        last_calculated_at,
        calculation_duration_ms
    )
    VALUES (
        p_entity_id,
        v_entity_type,
        v_org_id,
        v_metrics.total_appointments,
        v_metrics.completed,
        v_metrics.cancelled,
        v_metrics.no_shows,
        v_metrics.upcoming,
        v_metrics.avg_duration,
        v_metrics.last_appointment,
        v_metrics.next_appointment,
        now(),
        v_duration_ms
    )
    ON CONFLICT (entity_id) DO UPDATE SET
        total_appointments = EXCLUDED.total_appointments,
        completed_appointments = EXCLUDED.completed_appointments,
        cancelled_appointments = EXCLUDED.cancelled_appointments,
        no_show_appointments = EXCLUDED.no_show_appointments,
        upcoming_appointments = EXCLUDED.upcoming_appointments,
        avg_appointment_duration_minutes = EXCLUDED.avg_appointment_duration_minutes,
        last_appointment_date = EXCLUDED.last_appointment_date,
        next_appointment_date = EXCLUDED.next_appointment_date,
        last_calculated_at = now(),
        calculation_duration_ms = v_duration_ms,
        updated_at = now();
    
    RETURN jsonb_build_object(
        'success', true,
        'entity_id', p_entity_id,
        'metrics', to_jsonb(v_metrics.*),
        'calculation_duration_ms', v_duration_ms
    );
END;
$$;


--
-- Name: check_resource_availability(uuid, date, time without time zone, time without time zone, uuid); Type: FUNCTION; Schema: app; Owner: -
--

CREATE FUNCTION app.check_resource_availability(p_resource_entity_id uuid, p_appointment_date date, p_start_time time without time zone, p_end_time time without time zone, p_exclude_appointment_id uuid DEFAULT NULL::uuid) RETURNS jsonb
    LANGUAGE plpgsql STABLE
    AS $$
DECLARE
    v_is_available boolean := true;
    v_conflicts jsonb;
    v_reason text;
    v_unavailable_count integer;
BEGIN
    -- Check for conflicting appointments
    SELECT
        COUNT(*) = 0,
        jsonb_agg(jsonb_build_object(
            'appointment_id', id,
            'client_name', (SELECT display_name FROM entities WHERE id = client_entity_id),
            'start_time', start_time::text,
            'end_time', end_time::text,
            'status', status
        )) FILTER (WHERE status IN ('scheduled', 'confirmed', 'in_progress'))
    INTO v_is_available, v_conflicts
    FROM appointments
    WHERE resource_entity_id = p_resource_entity_id
      AND appointment_date = p_appointment_date
      AND status IN ('scheduled', 'confirmed', 'in_progress')
      AND deleted_at IS NULL
      AND (p_exclude_appointment_id IS NULL OR id != p_exclude_appointment_id)
      AND (start_time, end_time) OVERLAPS (p_start_time, p_end_time);
    
    IF NOT v_is_available THEN
        v_reason := 'Resource has conflicting appointments';
        RETURN jsonb_build_object(
            'is_available', false,
            'resource_entity_id', p_resource_entity_id,
            'reason', v_reason,
            'conflicts', COALESCE(v_conflicts, '[]'::jsonb)
        );
    END IF;
    
    -- Check unavailability periods
    SELECT COUNT(*) INTO v_unavailable_count
    FROM resource_unavailability
    WHERE resource_entity_id = p_resource_entity_id
      AND is_active = true
      AND (
          (p_appointment_date + p_start_time, p_appointment_date + p_end_time)
          OVERLAPS
          (unavailable_from, unavailable_until)
      );
    
    IF v_unavailable_count > 0 THEN
        SELECT reason INTO v_reason
        FROM resource_unavailability
        WHERE resource_entity_id = p_resource_entity_id
          AND is_active = true
          AND (
              (p_appointment_date + p_start_time, p_appointment_date + p_end_time)
              OVERLAPS
              (unavailable_from, unavailable_until)
          )
        LIMIT 1;
        
        RETURN jsonb_build_object(
            'is_available', false,
            'resource_entity_id', p_resource_entity_id,
            'reason', 'Resource is unavailable: ' || v_reason,
            'conflicts', '[]'::jsonb
        );
    END IF;
    
    -- Check if resource has availability schedule for this day
    IF NOT EXISTS (
        SELECT 1
        FROM resource_availability
        WHERE resource_entity_id = p_resource_entity_id
          AND day_of_week = EXTRACT(DOW FROM p_appointment_date)
          AND is_active = true
          AND (effective_until IS NULL OR p_appointment_date <= effective_until)
          AND p_appointment_date >= effective_from
          AND (start_time, end_time) OVERLAPS (p_start_time, p_end_time)
    ) THEN
        RETURN jsonb_build_object(
            'is_available', false,
            'resource_entity_id', p_resource_entity_id,
            'reason', 'Resource does not have availability schedule for this time',
            'conflicts', '[]'::jsonb
        );
    END IF;
    
    -- All checks passed
    RETURN jsonb_build_object(
        'is_available', true,
        'resource_entity_id', p_resource_entity_id,
        'reason', NULL,
        'conflicts', '[]'::jsonb
    );
END;
$$;


--
-- Name: FUNCTION check_resource_availability(p_resource_entity_id uuid, p_appointment_date date, p_start_time time without time zone, p_end_time time without time zone, p_exclude_appointment_id uuid); Type: COMMENT; Schema: app; Owner: -
--

COMMENT ON FUNCTION app.check_resource_availability(p_resource_entity_id uuid, p_appointment_date date, p_start_time time without time zone, p_end_time time without time zone, p_exclude_appointment_id uuid) IS 'Checks if a resource is available for booking at specified date/time';


--
-- Name: create_default_provider_schedule(uuid, uuid, time without time zone, time without time zone); Type: FUNCTION; Schema: app; Owner: -
--

CREATE FUNCTION app.create_default_provider_schedule(p_provider_entity_id uuid, p_organization_id uuid, p_start_time time without time zone, p_end_time time without time zone) RETURNS void
    LANGUAGE plpgsql
    AS $$
BEGIN
    -- Create schedule for Monday through Friday (1-5)
    FOR day IN 1..5 LOOP
        INSERT INTO public.provider_schedules (
            organization_id,
            provider_entity_id,
            day_of_week,
            start_time,
            end_time,
            is_available
        ) VALUES (
            p_organization_id,
            p_provider_entity_id,
            day,
            p_start_time,
            p_end_time,
            true
        );
    END LOOP;
END;
$$;


--
-- Name: FUNCTION create_default_provider_schedule(p_provider_entity_id uuid, p_organization_id uuid, p_start_time time without time zone, p_end_time time without time zone); Type: COMMENT; Schema: app; Owner: -
--

COMMENT ON FUNCTION app.create_default_provider_schedule(p_provider_entity_id uuid, p_organization_id uuid, p_start_time time without time zone, p_end_time time without time zone) IS 'Helper to create Mon-Fri schedule for a provider';


--
-- Name: disable_auto_embeddings(text); Type: FUNCTION; Schema: app; Owner: -
--

CREATE FUNCTION app.disable_auto_embeddings(p_table_name text) RETURNS jsonb
    LANGUAGE plpgsql SECURITY DEFINER
    AS $$
DECLARE
    v_trigger_name text;
BEGIN
    -- Update config
    UPDATE ai_embedding_configs
    SET enabled = false, trigger_enabled = false, updated_at = now()
    WHERE table_schema = 'public' AND table_name = p_table_name;

    IF NOT FOUND THEN
        RETURN jsonb_build_object(
            'success', false,
            'message', format('No configuration found for table: %s', p_table_name)
        );
    END IF;

    -- Drop trigger
    v_trigger_name := 'ai_auto_embed_' || p_table_name;
    EXECUTE format('DROP TRIGGER IF EXISTS %I ON %I', v_trigger_name, p_table_name);

    RETURN jsonb_build_object(
        'success', true,
        'table_name', p_table_name,
        'message', format('Auto-embeddings disabled for table: %s', p_table_name)
    );
END;
$$;


--
-- Name: FUNCTION disable_auto_embeddings(p_table_name text); Type: COMMENT; Schema: app; Owner: -
--

COMMENT ON FUNCTION app.disable_auto_embeddings(p_table_name text) IS 'Disable automatic embeddings for a table - drops trigger and marks config as disabled';


--
-- Name: enable_auto_embeddings(text, text[], text, text[], text); Type: FUNCTION; Schema: app; Owner: -
--

CREATE FUNCTION app.enable_auto_embeddings(p_table_name text, p_content_columns text[], p_filter_condition text DEFAULT NULL::text, p_watch_columns text[] DEFAULT NULL::text[], p_custom_content_sql text DEFAULT NULL::text) RETURNS jsonb
    LANGUAGE plpgsql SECURITY DEFINER
    AS $$
DECLARE
    v_config_id uuid;
    v_trigger_name text;
    v_trigger_sql text;
    v_watch_cols_sql text;
BEGIN
    -- Validate table exists
    IF NOT EXISTS (
        SELECT 1 FROM information_schema.tables
        WHERE table_schema = 'public' AND table_name = p_table_name
    ) THEN
        RAISE EXCEPTION 'Table %.% does not exist', 'public', p_table_name;
    END IF;

    -- Insert or update configuration
    INSERT INTO ai_embedding_configs (
        table_name,
        table_schema,
        content_columns,
        custom_content_sql,
        filter_condition,
        watch_columns,
        created_by
    ) VALUES (
        p_table_name,
        'public',
        p_content_columns,
        p_custom_content_sql,
        p_filter_condition,
        COALESCE(p_watch_columns, p_content_columns), -- Default: watch same columns as content
        auth.uid()
    )
    ON CONFLICT (table_schema, table_name)
    DO UPDATE SET
        content_columns = EXCLUDED.content_columns,
        custom_content_sql = EXCLUDED.custom_content_sql,
        filter_condition = EXCLUDED.filter_condition,
        watch_columns = EXCLUDED.watch_columns,
        enabled = true,
        trigger_enabled = true,
        updated_at = now()
    RETURNING id INTO v_config_id;

    -- Create trigger name
    v_trigger_name := 'ai_auto_embed_' || p_table_name;

    -- Drop existing trigger if exists
    EXECUTE format('DROP TRIGGER IF EXISTS %I ON %I', v_trigger_name, p_table_name);

    -- Build watch columns SQL
    IF p_watch_columns IS NOT NULL AND array_length(p_watch_columns, 1) > 0 THEN
        v_watch_cols_sql := ' OF ' || array_to_string(p_watch_columns, ', ');
    ELSE
        v_watch_cols_sql := '';
    END IF;

    -- Create trigger dynamically
    v_trigger_sql := format(
        'CREATE TRIGGER %I
         AFTER INSERT OR UPDATE%s
         ON %I
         FOR EACH ROW
         EXECUTE FUNCTION ai_generic_queue_embedding()',
        v_trigger_name,
        v_watch_cols_sql,
        p_table_name
    );

    EXECUTE v_trigger_sql;

    RETURN jsonb_build_object(
        'success', true,
        'config_id', v_config_id,
        'table_name', p_table_name,
        'trigger_name', v_trigger_name,
        'content_columns', p_content_columns,
        'message', format('Auto-embeddings enabled for table: %s', p_table_name)
    );
END;
$$;


--
-- Name: FUNCTION enable_auto_embeddings(p_table_name text, p_content_columns text[], p_filter_condition text, p_watch_columns text[], p_custom_content_sql text); Type: COMMENT; Schema: app; Owner: -
--

COMMENT ON FUNCTION app.enable_auto_embeddings(p_table_name text, p_content_columns text[], p_filter_condition text, p_watch_columns text[], p_custom_content_sql text) IS 'Enable automatic embeddings for any table - creates config and trigger';


--
-- Name: find_available_resources_for_service(uuid, text, date, time without time zone, time without time zone, integer, integer); Type: FUNCTION; Schema: app; Owner: -
--

CREATE FUNCTION app.find_available_resources_for_service(p_organization_id uuid, p_service_query text, p_date date, p_preferred_time_start time without time zone DEFAULT '09:00:00'::time without time zone, p_preferred_time_end time without time zone DEFAULT '18:00:00'::time without time zone, p_duration_minutes integer DEFAULT 60, p_limit integer DEFAULT 10) RETURNS TABLE(resource_id uuid, resource_name text, resource_type text, semantic_score numeric, available_slots jsonb, earliest_slot time without time zone, total_available_slots integer, ai_match_reasons jsonb, custom_fields jsonb)
    LANGUAGE plpgsql
    AS $$
DECLARE
    v_resource record;
    v_slots jsonb;
    v_earliest time;
    v_count integer;
BEGIN
    -- Validate inputs
    IF p_organization_id IS NULL THEN
        RAISE EXCEPTION 'organization_id cannot be null';
    END IF;
    
    IF p_service_query IS NULL OR trim(p_service_query) = '' THEN
        RAISE EXCEPTION 'service_query cannot be empty';
    END IF;

    -- Step 1: Find relevant resources using semantic search
    -- Reutiliza semantic_search_entities() existente
    FOR v_resource IN
        SELECT 
            e.id,
            e.display_name,
            e.entity_type,
            e.custom_fields,
            sse.similarity_score,
            sse.match_reasons
        FROM public.semantic_search_entities(
            p_query := p_service_query,
            p_organization_id := p_organization_id,
            p_entity_types := ARRAY['person', 'organization'], -- Resources can be people (doctors, stylists) or orgs (rooms, equipment)
            p_limit := p_limit * 2 -- Get more candidates, filter by availability
        ) sse
        JOIN app.entities e ON e.id = sse.id
        WHERE e.is_active = true
          AND e.organization_id = p_organization_id
    LOOP
        -- Step 2: Check availability for each resource
        -- Reutiliza get_available_time_slots() existente
        BEGIN
            SELECT 
                jsonb_agg(
                    jsonb_build_object(
                        'start_time', slot_time,
                        'end_time', slot_time + (p_duration_minutes || ' minutes')::interval
                    ) ORDER BY slot_time
                ),
                MIN(slot_time),
                COUNT(*)
            INTO v_slots, v_earliest, v_count
            FROM app.get_available_time_slots(
                p_resource_entity_id := v_resource.id,
                p_date := p_date,
                p_start_time := p_preferred_time_start,
                p_end_time := p_preferred_time_end,
                p_duration_minutes := p_duration_minutes
            ) slot(slot_time);

            -- Only return resources with available slots
            IF v_count > 0 THEN
                RETURN QUERY
                SELECT
                    v_resource.id,
                    v_resource.display_name,
                    v_resource.entity_type,
                    ROUND(v_resource.similarity_score::numeric, 3),
                    v_slots,
                    v_earliest,
                    v_count,
                    v_resource.match_reasons,
                    v_resource.custom_fields;
            END IF;
        EXCEPTION
            WHEN OTHERS THEN
                -- Log error but continue with other resources
                RAISE WARNING 'Error checking availability for resource %: %', v_resource.id, SQLERRM;
        END;
    END LOOP;
    
    RETURN;
END;
$$;


--
-- Name: FUNCTION find_available_resources_for_service(p_organization_id uuid, p_service_query text, p_date date, p_preferred_time_start time without time zone, p_preferred_time_end time without time zone, p_duration_minutes integer, p_limit integer); Type: COMMENT; Schema: app; Owner: -
--

COMMENT ON FUNCTION app.find_available_resources_for_service(p_organization_id uuid, p_service_query text, p_date date, p_preferred_time_start time without time zone, p_preferred_time_end time without time zone, p_duration_minutes integer, p_limit integer) IS 'Finds available resources for a service using AI semantic search + availability check.
Combines semantic_search_entities() with get_available_time_slots() to return only resources that:
1. Match the service semantically (skills, expertise, services offered)
2. Have actual availability on the requested date/time

Example:
SELECT * FROM app.find_available_resources_for_service(
    p_organization_id := ''uuid-org'',
    p_service_query := ''corte de pelo moderno para hombre'',
    p_date := ''2025-01-15'',
    p_preferred_time_start := ''10:00'',
    p_preferred_time_end := ''18:00'',
    p_duration_minutes := 45,
    p_limit := 5
);

Returns:
- resource_id: Entity UUID
- resource_name: Display name
- semantic_score: AI match score (0-1)
- available_slots: JSONB array of {start_time, end_time}
- earliest_slot: First available time
- total_available_slots: Count of slots
- ai_match_reasons: Why this resource matched (skills, tags, etc.)
';


--
-- Name: find_employees_by_skills(text[], uuid, text, integer); Type: FUNCTION; Schema: app; Owner: -
--

CREATE FUNCTION app.find_employees_by_skills(p_required_skills text[], p_organization_id uuid, p_min_proficiency text DEFAULT 'intermediate'::text, p_limit integer DEFAULT 20) RETURNS TABLE(employee_id uuid, employee_code character varying, display_name text, emp_position text, matched_skills jsonb, match_count integer, match_percentage numeric)
    LANGUAGE plpgsql STABLE
    AS $$
BEGIN
    RETURN QUERY
    SELECT
        e.id,
        e.employee_code,
        ent.display_name,
        e.position,
        e.skills,
        (
            SELECT COUNT(*)::integer
            FROM unnest(p_required_skills) AS req_skill
            WHERE e.skills->'technical'->'programming' ? req_skill
               OR e.skills->'technical'->'frameworks' ? req_skill
               OR e.skills->'technical'->'tools' ? req_skill
        ) as matched_count,
        ROUND(
            (
                SELECT COUNT(*)::numeric
                FROM unnest(p_required_skills) AS req_skill
                WHERE e.skills->'technical'->'programming' ? req_skill
                   OR e.skills->'technical'->'frameworks' ? req_skill
                   OR e.skills->'technical'->'tools' ? req_skill
            ) * 100.0 / NULLIF(array_length(p_required_skills, 1), 0),
            2
        ) as match_pct
    FROM employees e
    JOIN entities ent ON e.entity_id = ent.id
    WHERE e.organization_id = p_organization_id
      AND e.employment_status = 'active'
      AND e.deleted_at IS NULL
      AND e.skills IS NOT NULL
    ORDER BY matched_count DESC, match_pct DESC
    LIMIT p_limit;
END;
$$;


--
-- Name: FUNCTION find_employees_by_skills(p_required_skills text[], p_organization_id uuid, p_min_proficiency text, p_limit integer); Type: COMMENT; Schema: app; Owner: -
--

COMMENT ON FUNCTION app.find_employees_by_skills(p_required_skills text[], p_organization_id uuid, p_min_proficiency text, p_limit integer) IS 'Find employees matching required skills with proficiency levels';


--
-- Name: fuzzy_search_entities(uuid, text, text, integer, integer); Type: FUNCTION; Schema: app; Owner: -
--

CREATE FUNCTION app.fuzzy_search_entities(p_org_id uuid, p_domain text, p_search_term text, p_max_distance integer DEFAULT 3, p_limit integer DEFAULT 5) RETURNS TABLE(id uuid, entity_id uuid, name text, distance integer, similarity double precision, match_type text, domain text)
    LANGUAGE plpgsql STABLE SECURITY DEFINER
    AS $$
DECLARE
    v_search_lower TEXT := lower(trim(p_search_term));
BEGIN
    IF v_search_lower IS NULL OR v_search_lower = '' THEN
        RETURN;
    END IF;

    -- SERVICE PROVIDERS (includes employees for multi-vertical support)
    IF p_domain = 'service_provider' OR p_domain = 'provider' OR p_domain = 'doctor' THEN
        RETURN QUERY
        WITH provider_matches AS (
            -- 1. Search in service_providers table (legacy healthcare providers)
            SELECT DISTINCT
                sp.provider_entity_id AS eid,
                e.display_name AS ename,
                extensions.levenshtein_less_equal(lower(e.display_name), v_search_lower, p_max_distance + 1) AS dist,
                'full_name'::TEXT AS mtype
            FROM public.service_providers sp
            JOIN public.entities e ON e.id = sp.provider_entity_id
            WHERE sp.organization_id = p_org_id
              AND sp.is_available = true
              AND e.deleted_at IS NULL
              AND extensions.levenshtein_less_equal(lower(e.display_name), v_search_lower, p_max_distance + 1) <= p_max_distance
            
            UNION ALL
            
            -- 2. Search in entities table with service provider subtypes (for beauty salons, etc.)
            SELECT DISTINCT
                e.id AS eid,
                e.display_name AS ename,
                extensions.levenshtein_less_equal(lower(e.display_name), v_search_lower, p_max_distance + 1) AS dist,
                'full_name'::TEXT AS mtype
            FROM public.entities e
            WHERE e.organization_id = p_org_id
              AND e.entity_type = 'person'
              AND e.person_subtype IN ('employee', 'doctor', 'nurse', 'therapist', 'technician')
              AND e.deleted_at IS NULL
              AND extensions.levenshtein_less_equal(lower(e.display_name), v_search_lower, p_max_distance + 1) <= p_max_distance
            
            UNION ALL
            
            -- 3. Partial name matches from service_providers
            SELECT DISTINCT
                sp.provider_entity_id AS eid,
                e.display_name AS ename,
                MIN(extensions.levenshtein_less_equal(lower(word), v_search_lower, p_max_distance + 1)) AS dist,
                'partial_name'::TEXT AS mtype
            FROM public.service_providers sp
            JOIN public.entities e ON e.id = sp.provider_entity_id,
                 LATERAL unnest(string_to_array(e.display_name, ' ')) AS word
            WHERE sp.organization_id = p_org_id
              AND sp.is_available = true
              AND e.deleted_at IS NULL
              AND length(word) >= 3
              AND extensions.levenshtein_less_equal(lower(word), v_search_lower, p_max_distance + 1) <= p_max_distance
            GROUP BY sp.provider_entity_id, e.display_name
            
            UNION ALL
            
            -- 4. Partial name matches from entities (employees)
            SELECT DISTINCT
                e.id AS eid,
                e.display_name AS ename,
                MIN(extensions.levenshtein_less_equal(lower(word), v_search_lower, p_max_distance + 1)) AS dist,
                'partial_name'::TEXT AS mtype
            FROM public.entities e,
                 LATERAL unnest(string_to_array(e.display_name, ' ')) AS word
            WHERE e.organization_id = p_org_id
              AND e.entity_type = 'person'
              AND e.person_subtype IN ('employee', 'doctor', 'nurse', 'therapist', 'technician')
              AND e.deleted_at IS NULL
              AND length(word) >= 3
              AND extensions.levenshtein_less_equal(lower(word), v_search_lower, p_max_distance + 1) <= p_max_distance
            GROUP BY e.id, e.display_name
        ),
        best_matches AS (
            SELECT DISTINCT ON (pm.eid)
                pm.eid, pm.ename, pm.dist, pm.mtype
            FROM provider_matches pm
            WHERE pm.dist <= p_max_distance
            ORDER BY pm.eid, pm.dist ASC
        )
        SELECT
            bm.eid AS id, bm.eid AS entity_id, bm.ename AS name, bm.dist AS distance,
            (1.0 - (bm.dist::FLOAT / GREATEST(length(bm.ename), length(v_search_lower))))::FLOAT AS similarity,
            bm.mtype AS match_type, 'service_provider'::TEXT AS domain
        FROM best_matches bm
        ORDER BY bm.dist ASC, similarity DESC
        LIMIT p_limit;

    -- PATIENTS (kept as-is)
    ELSIF p_domain = 'patient' OR p_domain = 'cliente_paciente' THEN
        RETURN QUERY
        WITH patient_matches AS (
            SELECT p.id AS pid, p.entity_id AS eid, e.display_name AS ename,
                extensions.levenshtein_less_equal(lower(e.display_name), v_search_lower, p_max_distance + 1) AS dist,
                'full_name'::TEXT AS mtype
            FROM public.patients p JOIN public.entities e ON e.id = p.entity_id
            WHERE p.organization_id = p_org_id AND p.deleted_at IS NULL AND p.status = 'active'
              AND extensions.levenshtein_less_equal(lower(e.display_name), v_search_lower, p_max_distance + 1) <= p_max_distance
            UNION ALL
            SELECT p.id AS pid, p.entity_id AS eid, e.display_name AS ename,
                MIN(extensions.levenshtein_less_equal(lower(word), v_search_lower, p_max_distance + 1)) AS dist,
                'partial_name'::TEXT AS mtype
            FROM public.patients p JOIN public.entities e ON e.id = p.entity_id,
                 LATERAL unnest(string_to_array(e.display_name, ' ')) AS word
            WHERE p.organization_id = p_org_id AND p.deleted_at IS NULL AND p.status = 'active'
              AND length(word) >= 3
              AND extensions.levenshtein_less_equal(lower(word), v_search_lower, p_max_distance + 1) <= p_max_distance
            GROUP BY p.id, p.entity_id, e.display_name
        ),
        best_matches AS (
            SELECT DISTINCT ON (pm.eid)
                pm.pid, pm.eid, pm.ename, pm.dist, pm.mtype
            FROM patient_matches pm
            WHERE pm.dist <= p_max_distance
            ORDER BY pm.eid, pm.dist ASC
        )
        SELECT
            bm.pid AS id, bm.eid AS entity_id, bm.ename AS name, bm.dist AS distance,
            (1.0 - (bm.dist::FLOAT / GREATEST(length(bm.ename), length(v_search_lower))))::FLOAT AS similarity,
            bm.mtype AS match_type, 'patient'::TEXT AS domain
        FROM best_matches bm
        ORDER BY bm.dist ASC
        LIMIT p_limit;

    -- SERVICES
    ELSIF p_domain = 'service' THEN
        RETURN QUERY
        SELECT s.id, s.id AS entity_id, s.service_name AS name,
            extensions.levenshtein_less_equal(lower(s.service_name), v_search_lower, p_max_distance + 1) AS distance,
            (1.0 - (extensions.levenshtein_less_equal(lower(s.service_name), v_search_lower, p_max_distance + 1)::FLOAT /
                    GREATEST(length(s.service_name), length(v_search_lower))))::FLOAT AS similarity,
            'full_name'::TEXT AS match_type, 'service'::TEXT AS domain
        FROM public.services s
        WHERE s.organization_id = p_org_id AND s.is_active = true
          AND extensions.levenshtein_less_equal(lower(s.service_name), v_search_lower, p_max_distance + 1) <= p_max_distance
        ORDER BY distance ASC
        LIMIT p_limit;
    END IF;
END;
$$;


--
-- Name: FUNCTION fuzzy_search_entities(p_org_id uuid, p_domain text, p_search_term text, p_max_distance integer, p_limit integer); Type: COMMENT; Schema: app; Owner: -
--

COMMENT ON FUNCTION app.fuzzy_search_entities(p_org_id uuid, p_domain text, p_search_term text, p_max_distance integer, p_limit integer) IS 'Generic fuzzy search for any entity domain type (service_provider, patient, employee, client, etc.)';


--
-- Name: get_available_time_slots(uuid, date, integer, integer); Type: FUNCTION; Schema: app; Owner: -
--

CREATE FUNCTION app.get_available_time_slots(p_resource_entity_id uuid, p_date date, p_duration_minutes integer DEFAULT 30, p_buffer_minutes integer DEFAULT 0) RETURNS TABLE(slot_start time without time zone, slot_end time without time zone, is_available boolean, reason text)
    LANGUAGE plpgsql STABLE
    AS $$
BEGIN
    RETURN QUERY
    WITH working_hours AS (
        SELECT ra.start_time, ra.end_time, ra.buffer_time_minutes
        FROM resource_availability ra
        WHERE ra.resource_entity_id = p_resource_entity_id
          AND ra.day_of_week = EXTRACT(DOW FROM p_date)
          AND ra.is_active = true
          AND (ra.effective_until IS NULL OR p_date <= ra.effective_until)
          AND p_date >= ra.effective_from
    ),
    time_slots AS (
        SELECT
            (t.slot_ts)::time AS slot_start,
            (t.slot_ts + (p_duration_minutes || ' minutes')::interval)::time AS slot_end
        FROM working_hours wh
        CROSS JOIN LATERAL generate_series(
            (p_date + wh.start_time)::timestamp,
            (p_date + wh.end_time - (p_duration_minutes || ' minutes')::interval)::timestamp,
            ((p_duration_minutes + COALESCE(p_buffer_minutes, wh.buffer_time_minutes, 0)) || ' minutes')::interval
        ) AS t(slot_ts)
    ),
    slot_availability AS (
        SELECT
            ts.slot_start,
            ts.slot_end,
            NOT EXISTS (
                SELECT 1
                FROM appointments a
                WHERE a.resource_entity_id = p_resource_entity_id
                  AND a.appointment_date = p_date
                  AND a.status IN ('scheduled', 'confirmed', 'in_progress')
                  AND a.deleted_at IS NULL
                  AND (a.start_time, a.end_time) OVERLAPS (ts.slot_start, ts.slot_end)
            ) AS is_available,
            CASE
                WHEN EXISTS (
                    SELECT 1
                    FROM appointments a
                    WHERE a.resource_entity_id = p_resource_entity_id
                      AND a.appointment_date = p_date
                      AND a.status IN ('scheduled', 'confirmed', 'in_progress')
                      AND a.deleted_at IS NULL
                      AND (a.start_time, a.end_time) OVERLAPS (ts.slot_start, ts.slot_end)
                ) THEN 'Slot already booked'
                WHEN EXISTS (
                    SELECT 1
                    FROM resource_unavailability ru
                    WHERE ru.resource_entity_id = p_resource_entity_id
                      AND ru.is_active = true
                      AND (
                          (p_date + ts.slot_start, p_date + ts.slot_end)
                          OVERLAPS
                          (ru.unavailable_from, ru.unavailable_until)
                      )
                ) THEN 'Resource unavailable'
                ELSE 'Available'
            END AS reason
        FROM time_slots ts
    )
    SELECT
        sa.slot_start,
        sa.slot_end,
        sa.is_available,
        sa.reason
    FROM slot_availability sa
    ORDER BY sa.slot_start;
END;
$$;


--
-- Name: FUNCTION get_available_time_slots(p_resource_entity_id uuid, p_date date, p_duration_minutes integer, p_buffer_minutes integer); Type: COMMENT; Schema: app; Owner: -
--

COMMENT ON FUNCTION app.get_available_time_slots(p_resource_entity_id uuid, p_date date, p_duration_minutes integer, p_buffer_minutes integer) IS 'Returns all available time slots for a resource on a given date';


--
-- Name: get_available_time_slots(uuid, uuid, date, integer, integer); Type: FUNCTION; Schema: app; Owner: -
--

CREATE FUNCTION app.get_available_time_slots(p_organization_id uuid, p_resource_entity_id uuid, p_date date, p_duration_minutes integer DEFAULT 30, p_buffer_minutes integer DEFAULT 0) RETURNS TABLE(slot_start time without time zone, slot_end time without time zone, is_available boolean)
    LANGUAGE plpgsql STABLE
    AS $$
BEGIN
    -- Generate slots from 8am to 6pm
    RETURN QUERY
    WITH time_slots AS (
        SELECT
            t.slot_time::time AS slot_start,
            (t.slot_time + (p_duration_minutes || ' minutes')::interval)::time AS slot_end
        FROM generate_series(
            '08:00:00'::time,
            '18:00:00'::time - (p_duration_minutes || ' minutes')::interval,
            ((p_duration_minutes + p_buffer_minutes) || ' minutes')::interval
        ) AS t(slot_time)
    )
    SELECT
        ts.slot_start,
        ts.slot_end,
        NOT EXISTS (
            SELECT 1
            FROM appointments a
            WHERE a.resource_entity_id = p_resource_entity_id
              AND a.appointment_date = p_date
              AND a.status IN ('scheduled', 'confirmed', 'in_progress')
              AND (a.start_time, a.end_time) OVERLAPS (ts.slot_start, ts.slot_end)
        ) AS is_available
    FROM time_slots ts
    ORDER BY ts.slot_start;
END;
$$;


--
-- Name: get_booking_availability(uuid, uuid[], uuid, integer, integer); Type: FUNCTION; Schema: app; Owner: -
--

CREATE FUNCTION app.get_booking_availability(p_organization_id uuid, p_catalog_item_ids uuid[], p_provider_entity_id uuid DEFAULT NULL::uuid, p_days_ahead integer DEFAULT 7, p_slot_interval_minutes integer DEFAULT 30) RETURNS json
    LANGUAGE plpgsql STABLE SECURITY DEFINER
    AS $$
DECLARE
    v_result json;
    v_total_duration int;
    v_start_date date;
    v_end_date date;
    v_availability jsonb := '{}'::jsonb;
    v_date date;
    v_slots jsonb;
    v_valid_items_count int;
BEGIN
    -- First, verify that catalog items exist for this organization
    SELECT COUNT(*), COALESCE(SUM(duration_minutes), 0)
    INTO v_valid_items_count, v_total_duration
    FROM catalog_items
    WHERE id = ANY(p_catalog_item_ids)
      AND organization_id = p_organization_id;

    -- If no valid items found, return empty availability
    IF v_valid_items_count = 0 THEN
        RETURN json_build_object(
            'availability', '{}'::jsonb,
            'total_duration_minutes', 0,
            'slot_interval_minutes', p_slot_interval_minutes,
            'provider_id', p_provider_entity_id,
            'catalog_item_ids', p_catalog_item_ids,
            'date_range', json_build_object(
                'start', CURRENT_DATE,
                'end', CURRENT_DATE + p_days_ahead,
                'days', p_days_ahead
            ),
            'generated_at', NOW(),
            'error', 'No valid catalog items found for this organization'
        );
    END IF;

    -- Default to 60 minutes if somehow duration is 0
    IF v_total_duration = 0 THEN
        v_total_duration := 60;
    END IF;

    v_start_date := CURRENT_DATE;
    v_end_date := CURRENT_DATE + p_days_ahead;

    -- Generate availability for each day
    FOR v_date IN SELECT generate_series(v_start_date, v_end_date, interval '1 day')::date
    LOOP
        -- Get available slots for this day based on working hours
        SELECT jsonb_agg(slot_time ORDER BY slot_time)
        INTO v_slots
        FROM (
            SELECT DISTINCT to_char(
                '09:00'::time + (n * (p_slot_interval_minutes || ' minutes')::interval),
                'HH24:MI'
            ) as slot_time
            FROM generate_series(0, 16) n -- Generate up to 8 hours of slots
            WHERE 
                -- Slot must be within business hours (9am - 6pm)
                '09:00'::time + (n * (p_slot_interval_minutes || ' minutes')::interval) <= '18:00'::time
                -- Slot must fit the service duration
                AND '09:00'::time + (n * (p_slot_interval_minutes || ' minutes')::interval) 
                    + (v_total_duration || ' minutes')::interval <= '18:00'::time
                -- Skip Sunday (0)
                AND EXTRACT(DOW FROM v_date) BETWEEN 1 AND 6
                -- Must be at least 1 hour in the future for today
                AND (
                    v_date > CURRENT_DATE 
                    OR (v_date = CURRENT_DATE 
                        AND '09:00'::time + (n * (p_slot_interval_minutes || ' minutes')::interval) 
                            > CURRENT_TIME + interval '1 hour')
                )
                -- No overlapping appointments for this provider
                AND NOT EXISTS (
                    SELECT 1 FROM appointments a
                    WHERE a.organization_id = p_organization_id
                      AND (p_provider_entity_id IS NULL OR a.resource_entity_id = p_provider_entity_id)
                      AND a.status NOT IN ('cancelled', 'no_show')
                      AND a.appointment_date = v_date
                      AND (
                          '09:00'::time + (n * (p_slot_interval_minutes || ' minutes')::interval),
                          '09:00'::time + (n * (p_slot_interval_minutes || ' minutes')::interval) 
                              + (v_total_duration || ' minutes')::interval
                      ) OVERLAPS (a.start_time, a.end_time)
                )
        ) slots
        WHERE slot_time IS NOT NULL;

        -- Add to availability if there are slots
        IF v_slots IS NOT NULL AND jsonb_array_length(v_slots) > 0 THEN
            v_availability := v_availability || jsonb_build_object(v_date::text, v_slots);
        END IF;
    END LOOP;

    -- Build final result
    v_result := json_build_object(
        'availability', v_availability,
        'total_duration_minutes', v_total_duration,
        'slot_interval_minutes', p_slot_interval_minutes,
        'provider_id', p_provider_entity_id,
        'catalog_item_ids', p_catalog_item_ids,
        'date_range', json_build_object(
            'start', v_start_date,
            'end', v_end_date,
            'days', p_days_ahead
        ),
        'generated_at', NOW()
    );
    
    RETURN v_result;
END;
$$;


--
-- Name: FUNCTION get_booking_availability(p_organization_id uuid, p_catalog_item_ids uuid[], p_provider_entity_id uuid, p_days_ahead integer, p_slot_interval_minutes integer); Type: COMMENT; Schema: app; Owner: -
--

COMMENT ON FUNCTION app.get_booking_availability(p_organization_id uuid, p_catalog_item_ids uuid[], p_provider_entity_id uuid, p_days_ahead integer, p_slot_interval_minutes integer) IS 'Returns real-time availability slots for booking based on provider schedules and existing appointments. Validates that catalog items belong to the specified organization.';


--
-- Name: get_direct_reports(uuid); Type: FUNCTION; Schema: app; Owner: -
--

CREATE FUNCTION app.get_direct_reports(p_manager_employee_id uuid) RETURNS TABLE(employee_id uuid, employee_code character varying, display_name text, emp_position text, department character varying, employment_status public.employment_status_enum, hire_date date)
    LANGUAGE plpgsql STABLE
    AS $$
BEGIN
    RETURN QUERY
    SELECT
        e.id,
        e.employee_code,
        ent.display_name,
        e.position,
        e.department,
        e.employment_status,
        e.hire_date
    FROM employees e
    JOIN entities ent ON e.entity_id = ent.id
    WHERE e.reports_to_employee_id = p_manager_employee_id
      AND e.deleted_at IS NULL
      AND e.employment_status IN ('active', 'on_leave')
    ORDER BY ent.display_name;
END;
$$;


--
-- Name: FUNCTION get_direct_reports(p_manager_employee_id uuid); Type: COMMENT; Schema: app; Owner: -
--

COMMENT ON FUNCTION app.get_direct_reports(p_manager_employee_id uuid) IS 'Get all direct reports for a given manager';


--
-- Name: get_embedding_config(text); Type: FUNCTION; Schema: app; Owner: -
--

CREATE FUNCTION app.get_embedding_config(p_table_name text) RETURNS jsonb
    LANGUAGE plpgsql STABLE
    AS $$
DECLARE
    v_config record;
    v_trigger_exists boolean;
BEGIN
    SELECT * INTO v_config
    FROM ai_embedding_configs
    WHERE table_schema = 'public' AND table_name = p_table_name;

    IF NOT FOUND THEN
        RETURN NULL;
    END IF;

    -- Check if trigger exists
    SELECT EXISTS (
        SELECT 1 FROM pg_trigger
        WHERE tgname = 'ai_auto_embed_' || p_table_name
    ) INTO v_trigger_exists;

    RETURN jsonb_build_object(
        'table_name', v_config.table_name,
        'content_columns', v_config.content_columns,
        'watch_columns', v_config.watch_columns,
        'filter_condition', v_config.filter_condition,
        'enabled', v_config.enabled,
        'trigger_enabled', v_config.trigger_enabled,
        'trigger_exists', v_trigger_exists,
        'created_at', v_config.created_at,
        'updated_at', v_config.updated_at
    );
END;
$$;


--
-- Name: FUNCTION get_embedding_config(p_table_name text); Type: COMMENT; Schema: app; Owner: -
--

COMMENT ON FUNCTION app.get_embedding_config(p_table_name text) IS 'Get embedding configuration for a specific table';


--
-- Name: get_employee_tenure(uuid); Type: FUNCTION; Schema: app; Owner: -
--

CREATE FUNCTION app.get_employee_tenure(p_employee_id uuid) RETURNS interval
    LANGUAGE plpgsql STABLE
    AS $$
DECLARE
    v_hire_date date;
    v_end_date date;
    v_tenure interval;
BEGIN
    -- Get hire date and termination date (if any)
    SELECT hire_date, termination_date
    INTO v_hire_date, v_end_date
    FROM employees
    WHERE id = p_employee_id;

    -- If employee not found
    IF v_hire_date IS NULL THEN
        RETURN NULL;
    END IF;

    -- Use termination date if exists, otherwise current date
    v_end_date := COALESCE(v_end_date, CURRENT_DATE);

    -- Calculate tenure
    v_tenure := age(v_end_date, v_hire_date);

    RETURN v_tenure;
END;
$$;


--
-- Name: FUNCTION get_employee_tenure(p_employee_id uuid); Type: COMMENT; Schema: app; Owner: -
--

COMMENT ON FUNCTION app.get_employee_tenure(p_employee_id uuid) IS 'Calculate employee tenure (time between hire and termination or current date)';


--
-- Name: get_high_risk_entities(uuid, text, numeric, integer); Type: FUNCTION; Schema: app; Owner: -
--

CREATE FUNCTION app.get_high_risk_entities(p_organization_id uuid, p_risk_type text DEFAULT 'churn'::text, p_threshold numeric DEFAULT 0.7, p_limit integer DEFAULT 50) RETURNS TABLE(entity_id uuid, entity_name text, entity_type text, risk_score numeric, risk_type text, recommended_actions jsonb)
    LANGUAGE plpgsql STABLE
    AS $$
BEGIN
    RETURN QUERY
    SELECT
        e.id,
        e.display_name,
        traits.entity_type,
        CASE
            WHEN p_risk_type = 'churn' THEN (traits.ai_churn_risk->>'churn_score')::numeric
            WHEN p_risk_type = 'no_show' THEN (traits.ai_no_show_risk->>'no_show_probability')::numeric
            ELSE GREATEST(
                COALESCE((traits.ai_churn_risk->>'churn_score')::numeric, 0),
                COALESCE((traits.ai_no_show_risk->>'no_show_probability')::numeric, 0)
            )
        END AS risk_score,
        p_risk_type AS risk_type,
        COALESCE(
            traits.ai_retention_strategy->'recommended_actions',
            '[]'::jsonb
        ) AS recommended_actions
    FROM entity_ai_traits traits
    JOIN entities e ON e.id = traits.entity_id
    WHERE traits.organization_id = p_organization_id
      AND e.deleted_at IS NULL
      AND (
          (p_risk_type = 'churn' AND (traits.ai_churn_risk->>'churn_score')::numeric > p_threshold)
          OR (p_risk_type = 'no_show' AND (traits.ai_no_show_risk->>'no_show_probability')::numeric > p_threshold)
          OR (p_risk_type = 'both' AND (
              COALESCE((traits.ai_churn_risk->>'churn_score')::numeric, 0) > p_threshold
              OR COALESCE((traits.ai_no_show_risk->>'no_show_probability')::numeric, 0) > p_threshold
          ))
      )
    ORDER BY risk_score DESC
    LIMIT p_limit;
END;
$$;


--
-- Name: get_resource_schedule(uuid, date, date); Type: FUNCTION; Schema: app; Owner: -
--

CREATE FUNCTION app.get_resource_schedule(p_resource_entity_id uuid, p_start_date date, p_end_date date DEFAULT NULL::date) RETURNS jsonb
    LANGUAGE plpgsql STABLE
    AS $$
DECLARE
    v_end_date date := COALESCE(p_end_date, p_start_date + interval '7 days');
    v_result jsonb;
BEGIN
    WITH date_series AS (
        SELECT generate_series(p_start_date, v_end_date, '1 day'::interval)::date AS date
    ),
    daily_schedule AS (
        SELECT
            ds.date,
            EXTRACT(DOW FROM ds.date)::integer AS day_of_week,
            COALESCE(
                jsonb_agg(
                    jsonb_build_object(
                        'appointment_id', a.id,
                        'client_name', (SELECT display_name FROM entities WHERE id = a.client_entity_id),
                        'start_time', a.start_time::text,
                        'end_time', a.end_time::text,
                        'status', a.status,
                        'service_name', a.service_name
                    ) ORDER BY a.start_time
                ) FILTER (WHERE a.id IS NOT NULL),
                '[]'::jsonb
            ) AS appointments,
            (
                SELECT jsonb_agg(jsonb_build_object(
                    'start_time', ra.start_time::text,
                    'end_time', ra.end_time::text
                ))
                FROM resource_availability ra
                WHERE ra.resource_entity_id = p_resource_entity_id
                  AND ra.day_of_week = EXTRACT(DOW FROM ds.date)
                  AND ra.is_active = true
                  AND (ra.effective_until IS NULL OR ds.date <= ra.effective_until)
                  AND ds.date >= ra.effective_from
            ) AS availability,
            (
                SELECT jsonb_agg(jsonb_build_object(
                    'reason', ru.reason,
                    'from', ru.unavailable_from::text,
                    'until', ru.unavailable_until::text
                ))
                FROM resource_unavailability ru
                WHERE ru.resource_entity_id = p_resource_entity_id
                  AND ru.is_active = true
                  AND ds.date BETWEEN ru.unavailable_from::date AND ru.unavailable_until::date
            ) AS unavailability
        FROM date_series ds
        LEFT JOIN appointments a ON
            a.resource_entity_id = p_resource_entity_id
            AND a.appointment_date = ds.date
            AND a.deleted_at IS NULL
            AND a.status IN ('scheduled', 'confirmed', 'in_progress')
        GROUP BY ds.date
    )
    SELECT jsonb_agg(
        jsonb_build_object(
            'date', date::text,
            'day_of_week', day_of_week,
            'appointments', appointments,
            'availability', COALESCE(availability, '[]'::jsonb),
            'unavailability', COALESCE(unavailability, '[]'::jsonb)
        ) ORDER BY date
    )
    INTO v_result
    FROM daily_schedule;
    
    RETURN COALESCE(v_result, '[]'::jsonb);
END;
$$;


--
-- Name: FUNCTION get_resource_schedule(p_resource_entity_id uuid, p_start_date date, p_end_date date); Type: COMMENT; Schema: app; Owner: -
--

COMMENT ON FUNCTION app.get_resource_schedule(p_resource_entity_id uuid, p_start_date date, p_end_date date) IS 'Returns complete schedule for a resource including appointments, availability, and unavailability';


--
-- Name: get_smart_booking_data(uuid, uuid); Type: FUNCTION; Schema: app; Owner: -
--

CREATE FUNCTION app.get_smart_booking_data(p_organization_id uuid, p_user_entity_id uuid DEFAULT NULL::uuid) RETURNS json
    LANGUAGE plpgsql STABLE SECURITY DEFINER
    AS $$
DECLARE
    v_result json;
BEGIN
    SELECT json_build_object(
        'catalog_items', (
            SELECT COALESCE(json_agg(json_build_object(
                'id', ci.id,
                'name', ci.name,
                'display_name', ci.display_name,
                'description', ci.description,
                'item_type', ci.item_type,
                'category_id', ci.category_id,
                'duration_minutes', ci.duration_minutes,
                'base_price', ci.base_price,
                'currency', ci.currency,
                'image_url', ci.image_url
            ) ORDER BY ci.name), '[]'::json)
            FROM catalog_items ci
            WHERE ci.organization_id = p_organization_id
              AND ci.is_bookable = true
              AND ci.is_active = true
              AND ci.is_published = true
              AND ci.deleted_at IS NULL
            LIMIT 100
        ),
        
        'providers', (
            SELECT COALESCE(json_agg(json_build_object(
                'id', e.id,
                'display_name', e.display_name,
                'person_subtype', e.person_subtype,
                'avatar_url', e.custom_fields->>'avatar_url',
                'email', e.email,
                'qualified_item_ids', ARRAY[]::uuid[]
            ) ORDER BY e.display_name), '[]'::json)
            FROM entities e
            WHERE e.organization_id = p_organization_id
              AND e.entity_type = 'person'
              AND e.person_subtype IN ('doctor', 'nurse', 'technician', 'therapist', 'employee')
              AND e.status = 'active'
              AND e.deleted_at IS NULL
            LIMIT 50
        ),
        
        'categories', (
            SELECT COALESCE(json_agg(json_build_object(
                'id', cc.id,
                'name', cc.name,
                'slug', cc.slug,
                'parent_id', cc.parent_id
            ) ORDER BY cc.name), '[]'::json)
            FROM catalog_categories cc
            WHERE cc.organization_id = p_organization_id
              AND cc.is_active = true
              AND cc.deleted_at IS NULL
        ),
        
        'current_user', NULL,
        
        'metadata', json_build_object(
            'organization_id', p_organization_id,
            'generated_at', NOW(),
            'version', '1.3'
        )
    )
    INTO v_result;
    
    RETURN v_result;
END;
$$;


--
-- Name: FUNCTION get_smart_booking_data(p_organization_id uuid, p_user_entity_id uuid); Type: COMMENT; Schema: app; Owner: -
--

COMMENT ON FUNCTION app.get_smart_booking_data(p_organization_id uuid, p_user_entity_id uuid) IS 'Returns all data needed for the Smart Booking Form A2UI component including catalog items, providers, categories, and current user info';


--
-- Name: log_appointment_change(); Type: FUNCTION; Schema: app; Owner: -
--

CREATE FUNCTION app.log_appointment_change() RETURNS trigger
    LANGUAGE plpgsql SECURITY DEFINER
    AS $$
DECLARE
    v_action text;
    v_user_name text;
    v_description text;
BEGIN
    -- Determine action
    IF TG_OP = 'INSERT' THEN
        v_action := 'created';
        v_description := 'Appointment created';
    ELSIF TG_OP = 'UPDATE' THEN
        IF OLD.status != NEW.status THEN
            IF NEW.status = 'cancelled' THEN
                v_action := 'cancelled';
            ELSIF NEW.status = 'no_show' THEN
                v_action := 'no_show';
            ELSIF NEW.status = 'completed' THEN
                v_action := 'completed';
            ELSIF NEW.status = 'confirmed' THEN
                v_action := 'confirmed';
            ELSE
                v_action := 'status_changed';
            END IF;
            v_description := format('Status changed from %s to %s', OLD.status, NEW.status);
        ELSIF OLD.appointment_date != NEW.appointment_date OR OLD.start_time != NEW.start_time THEN
            v_action := 'rescheduled';
            v_description := format('Rescheduled from %s %s to %s %s', 
                OLD.appointment_date, OLD.start_time, 
                NEW.appointment_date, NEW.start_time);
        ELSIF OLD.resource_entity_id != NEW.resource_entity_id THEN
            v_action := 'resource_changed';
            v_description := 'Resource/staff changed';
        ELSE
            v_action := 'updated';
            v_description := 'Appointment updated';
        END IF;
    END IF;
    
    -- Get user name
    SELECT COALESCE(
        (SELECT raw_user_meta_data->>'full_name' FROM auth.users WHERE id = auth.uid()),
        'System'
    ) INTO v_user_name;
    
    -- Insert audit log
    INSERT INTO appointment_audit_log (
        appointment_id,
        user_id,
        user_name,
        action,
        previous_values,
        new_values,
        description,
        reason,
        organization_id
    )
    VALUES (
        COALESCE(NEW.id, OLD.id),
        auth.uid(),
        v_user_name,
        v_action,
        CASE WHEN TG_OP = 'UPDATE' THEN to_jsonb(OLD) ELSE NULL END,
        to_jsonb(NEW),
        v_description,
        NEW.cancellation_reason,
        COALESCE(NEW.organization_id, OLD.organization_id)
    );
    
    RETURN NEW;
END;
$$;


--
-- Name: record_position_change(uuid, text, character varying, character varying, text, date); Type: FUNCTION; Schema: app; Owner: -
--

CREATE FUNCTION app.record_position_change(p_employee_id uuid, p_new_position text, p_new_department character varying DEFAULT NULL::character varying, p_new_division character varying DEFAULT NULL::character varying, p_reason text DEFAULT NULL::text, p_effective_date date DEFAULT CURRENT_DATE) RETURNS jsonb
    LANGUAGE plpgsql SECURITY DEFINER
    AS $$
DECLARE
    v_current_position text;
    v_current_department varchar(100);
    v_current_division varchar(100);
    v_position_record jsonb;
    v_result jsonb;
BEGIN
    -- Get current position info
    SELECT position, department, division
    INTO v_current_position, v_current_department, v_current_division
    FROM employees
    WHERE id = p_employee_id;

    IF v_current_position IS NULL THEN
        RAISE EXCEPTION 'Employee not found: %', p_employee_id;
    END IF;

    -- Use current values if new ones not provided
    p_new_department := COALESCE(p_new_department, v_current_department);
    p_new_division := COALESCE(p_new_division, v_current_division);

    -- Create position history record
    v_position_record := jsonb_build_object(
        'effective_date', p_effective_date,
        'previous_position', v_current_position,
        'new_position', p_new_position,
        'previous_department', v_current_department,
        'new_department', p_new_department,
        'previous_division', v_current_division,
        'new_division', p_new_division,
        'reason', p_reason,
        'recorded_by', auth.uid(),
        'recorded_at', now()
    );

    -- Update position and add to history
    UPDATE employees
    SET
        position = p_new_position,
        department = p_new_department,
        division = p_new_division,
        position_history = position_history || v_position_record,
        updated_by = auth.uid()
    WHERE id = p_employee_id;

    -- Return result
    v_result := jsonb_build_object(
        'success', true,
        'employee_id', p_employee_id,
        'previous_position', v_current_position,
        'new_position', p_new_position,
        'previous_department', v_current_department,
        'new_department', p_new_department,
        'effective_date', p_effective_date
    );

    RETURN v_result;
END;
$$;


--
-- Name: FUNCTION record_position_change(p_employee_id uuid, p_new_position text, p_new_department character varying, p_new_division character varying, p_reason text, p_effective_date date); Type: COMMENT; Schema: app; Owner: -
--

COMMENT ON FUNCTION app.record_position_change(p_employee_id uuid, p_new_position text, p_new_department character varying, p_new_division character varying, p_reason text, p_effective_date date) IS 'Record position/department change with full history tracking';


--
-- Name: record_salary_increase(uuid, numeric, text, uuid, date); Type: FUNCTION; Schema: app; Owner: -
--

CREATE FUNCTION app.record_salary_increase(p_employee_id uuid, p_new_salary numeric, p_reason text, p_approved_by uuid, p_effective_date date DEFAULT CURRENT_DATE) RETURNS jsonb
    LANGUAGE plpgsql SECURITY DEFINER
    AS $$
DECLARE
    v_current_salary numeric;
    v_increase_amount numeric;
    v_increase_percentage numeric;
    v_salary_record jsonb;
    v_result jsonb;
BEGIN
    -- Get current salary
    SELECT salary INTO v_current_salary
    FROM employees
    WHERE id = p_employee_id;

    IF v_current_salary IS NULL THEN
        RAISE EXCEPTION 'Employee not found or no current salary: %', p_employee_id;
    END IF;

    -- Validate new salary
    IF p_new_salary <= 0 THEN
        RAISE EXCEPTION 'New salary must be positive: %', p_new_salary;
    END IF;

    -- Calculate increase
    v_increase_amount := p_new_salary - v_current_salary;
    v_increase_percentage := (v_increase_amount / v_current_salary) * 100;

    -- Create salary history record
    v_salary_record := jsonb_build_object(
        'effective_date', p_effective_date,
        'previous_salary', v_current_salary,
        'new_salary', p_new_salary,
        'increase_amount', v_increase_amount,
        'increase_percentage', ROUND(v_increase_percentage, 2),
        'reason', p_reason,
        'approved_by', p_approved_by,
        'approved_at', now(),
        'recorded_by', auth.uid()
    );

    -- Update salary and add to history
    UPDATE employees
    SET
        salary = p_new_salary,
        salary_history = salary_history || v_salary_record,
        updated_by = auth.uid()
    WHERE id = p_employee_id;

    -- Return result
    v_result := jsonb_build_object(
        'success', true,
        'employee_id', p_employee_id,
        'previous_salary', v_current_salary,
        'new_salary', p_new_salary,
        'increase_amount', v_increase_amount,
        'increase_percentage', ROUND(v_increase_percentage, 2),
        'effective_date', p_effective_date
    );

    RETURN v_result;
END;
$$;


--
-- Name: FUNCTION record_salary_increase(p_employee_id uuid, p_new_salary numeric, p_reason text, p_approved_by uuid, p_effective_date date); Type: COMMENT; Schema: app; Owner: -
--

COMMENT ON FUNCTION app.record_salary_increase(p_employee_id uuid, p_new_salary numeric, p_reason text, p_approved_by uuid, p_effective_date date) IS 'Record salary increase with full history tracking and approval';


--
-- Name: refresh_employee_analytics(uuid); Type: FUNCTION; Schema: app; Owner: -
--

CREATE FUNCTION app.refresh_employee_analytics(p_employee_id uuid) RETURNS jsonb
    LANGUAGE plpgsql SECURITY DEFINER
    AS $$
DECLARE
    v_employee record;
    v_analytics jsonb;
BEGIN
    -- Get employee data
    SELECT * INTO v_employee
    FROM employees
    WHERE id = p_employee_id;

    IF NOT FOUND THEN
        RAISE EXCEPTION 'Employee not found: %', p_employee_id;
    END IF;

    -- Build analytics snapshot
    v_analytics := jsonb_build_object(
        'current_period', jsonb_build_object(
            'period', to_char(CURRENT_DATE, 'YYYY-Q"Q"'),
            'days_active', EXTRACT(DAY FROM age(CURRENT_DATE, v_employee.hire_date))::integer
        ),
        'compensation', jsonb_build_object(
            'current_salary', v_employee.salary,
            'salary_currency', v_employee.salary_currency,
            'last_snapshot_date', CURRENT_DATE
        ),
        'employment', jsonb_build_object(
            'status', v_employee.employment_status,
            'type', v_employee.employment_type,
            'tenure_years', EXTRACT(YEAR FROM age(CURRENT_DATE, v_employee.hire_date))::numeric(10,2)
        ),
        'benefits', jsonb_build_object(
            'vacation_balance', v_employee.vacation_days_accrued,
            'vacation_allowance', v_employee.vacation_days_per_year
        ),
        'last_updated', now()
    );

    -- Update analytics snapshot
    UPDATE employees
    SET
        analytics_snapshot = v_analytics,
        updated_at = now()
    WHERE id = p_employee_id;

    RETURN jsonb_build_object(
        'success', true,
        'employee_id', p_employee_id,
        'analytics', v_analytics
    );
END;
$$;


--
-- Name: FUNCTION refresh_employee_analytics(p_employee_id uuid); Type: COMMENT; Schema: app; Owner: -
--

COMMENT ON FUNCTION app.refresh_employee_analytics(p_employee_id uuid) IS 'Refresh aggregated analytics snapshot for an employee - should be called daily/weekly via cron';


--
-- Name: refresh_entity_ai_traits(uuid, boolean); Type: FUNCTION; Schema: app; Owner: -
--

CREATE FUNCTION app.refresh_entity_ai_traits(p_entity_id uuid, p_force_refresh boolean DEFAULT false) RETURNS jsonb
    LANGUAGE plpgsql SECURITY DEFINER
    AS $$
DECLARE
    v_entity_type text;
    v_last_refresh timestamptz;
    v_result jsonb;
BEGIN
    -- Get entity type
    SELECT entity_type INTO v_entity_type
    FROM entities
    WHERE id = p_entity_id;
    
    -- Check if refresh needed (unless forced)
    IF NOT p_force_refresh THEN
        SELECT last_ai_refresh_at INTO v_last_refresh
        FROM entity_ai_traits
        WHERE entity_id = p_entity_id;
        
        IF v_last_refresh IS NOT NULL AND v_last_refresh > now() - interval '1 hour' THEN
            RETURN jsonb_build_object(
                'success', true,
                'message', 'AI traits recently refreshed, skipping',
                'last_refresh', v_last_refresh
            );
        END IF;
    END IF;
    
    -- Ensure entity_ai_traits record exists
    INSERT INTO entity_ai_traits (entity_id, entity_type, organization_id)
    SELECT p_entity_id, v_entity_type, organization_id
    FROM entities
    WHERE id = p_entity_id
    ON CONFLICT (entity_id) DO NOTHING;
    
    -- TODO: Call AI models to populate fields
    -- For now, just update timestamp
    UPDATE entity_ai_traits
    SET last_ai_refresh_at = now()
    WHERE entity_id = p_entity_id;
    
    RETURN jsonb_build_object(
        'success', true,
        'message', 'AI traits refreshed successfully',
        'entity_id', p_entity_id,
        'entity_type', v_entity_type
    );
END;
$$;


--
-- Name: smart_appointment_recommendations(uuid, text, uuid, date, integer); Type: FUNCTION; Schema: app; Owner: -
--

CREATE FUNCTION app.smart_appointment_recommendations(p_client_entity_id uuid, p_service_query text, p_organization_id uuid, p_preferred_date date DEFAULT NULL::date, p_limit integer DEFAULT 5) RETURNS jsonb
    LANGUAGE plpgsql
    AS $$
DECLARE
    v_client_metrics jsonb;
    v_recommendations jsonb := '[]'::jsonb;
    v_date date;
    v_resource record;
    v_score numeric;
BEGIN
    -- Validate inputs
    IF p_client_entity_id IS NULL THEN
        RAISE EXCEPTION 'client_entity_id cannot be null';
    END IF;
    
    IF p_organization_id IS NULL THEN
        RAISE EXCEPTION 'organization_id cannot be null';
    END IF;

    -- Step 1: Get client behavioral metrics
    -- Reutiliza calculate_entity_metrics() existente
    BEGIN
        SELECT app.calculate_entity_metrics(p_client_entity_id, p_organization_id)
        INTO v_client_metrics;
    EXCEPTION
        WHEN OTHERS THEN
            v_client_metrics := '{}'::jsonb;
    END;

    -- Step 2: Determine search dates
    IF p_preferred_date IS NULL THEN
        -- Search next 7 days
        FOR i IN 0..6 LOOP
            v_date := CURRENT_DATE + i;
            
            -- Step 3: Find available resources for this date
            FOR v_resource IN
                SELECT * FROM app.find_available_resources_for_service(
                    p_organization_id := p_organization_id,
                    p_service_query := p_service_query,
                    p_date := v_date,
                    p_preferred_time_start := COALESCE(
                        (v_client_metrics->'preferred_time_start')::text::time,
                        '09:00'::time
                    ),
                    p_preferred_time_end := COALESCE(
                        (v_client_metrics->'preferred_time_end')::text::time,
                        '18:00'::time
                    ),
                    p_duration_minutes := 60,
                    p_limit := 3
                )
            LOOP
                -- Step 4: Calculate recommendation score
                -- Factors:
                -- - Semantic match score (40%)
                -- - Client preference match (30%)
                -- - Availability score (20%)
                -- - No-show risk adjustment (10%)
                
                v_score := (
                    v_resource.semantic_score * 0.4 +
                    CASE 
                        -- Prefer client's favorite resources
                        WHEN v_client_metrics->'preferred_resources' @> to_jsonb(v_resource.resource_id) 
                        THEN 1.0 
                        ELSE 0.5 
                    END * 0.3 +
                    LEAST(v_resource.total_available_slots / 10.0, 1.0) * 0.2 +
                    (1.0 - COALESCE((v_client_metrics->'no_show_risk')::numeric, 0)) * 0.1
                );
                
                -- Add to recommendations
                v_recommendations := v_recommendations || jsonb_build_object(
                    'resource_id', v_resource.resource_id,
                    'resource_name', v_resource.resource_name,
                    'date', v_date,
                    'earliest_slot', v_resource.earliest_slot,
                    'available_slots', v_resource.available_slots,
                    'recommendation_score', ROUND(v_score, 3),
                    'reasons', jsonb_build_array(
                        jsonb_build_object('factor', 'semantic_match', 'score', v_resource.semantic_score),
                        jsonb_build_object('factor', 'availability', 'slots', v_resource.total_available_slots),
                        jsonb_build_object('factor', 'client_preference', 'is_favorite', 
                            v_client_metrics->'preferred_resources' @> to_jsonb(v_resource.resource_id)
                        )
                    )
                );
            END LOOP;
        END LOOP;
    ELSE
        -- Search specific date only
        FOR v_resource IN
            SELECT * FROM app.find_available_resources_for_service(
                p_organization_id := p_organization_id,
                p_service_query := p_service_query,
                p_date := p_preferred_date,
                p_preferred_time_start := '09:00',
                p_preferred_time_end := '18:00',
                p_duration_minutes := 60,
                p_limit := p_limit
            )
        LOOP
            v_score := v_resource.semantic_score;
            
            v_recommendations := v_recommendations || jsonb_build_object(
                'resource_id', v_resource.resource_id,
                'resource_name', v_resource.resource_name,
                'date', p_preferred_date,
                'earliest_slot', v_resource.earliest_slot,
                'available_slots', v_resource.available_slots,
                'recommendation_score', ROUND(v_score, 3),
                'reasons', v_resource.ai_match_reasons
            );
        END LOOP;
    END IF;

    -- Sort by recommendation score and limit results
    RETURN (
        SELECT jsonb_agg(rec ORDER BY (rec->>'recommendation_score')::numeric DESC)
        FROM (
            SELECT rec
            FROM jsonb_array_elements(v_recommendations) rec
            LIMIT p_limit
        ) sorted
    );
END;
$$;


--
-- Name: FUNCTION smart_appointment_recommendations(p_client_entity_id uuid, p_service_query text, p_organization_id uuid, p_preferred_date date, p_limit integer); Type: COMMENT; Schema: app; Owner: -
--

COMMENT ON FUNCTION app.smart_appointment_recommendations(p_client_entity_id uuid, p_service_query text, p_organization_id uuid, p_preferred_date date, p_limit integer) IS 'Smart appointment recommendations using AI and client behavioral data.
Analyzes:
- Client history (preferred times, days, resources)
- Resource availability (via find_available_resources_for_service)
- No-show risk (via calculate_entity_metrics)
- Semantic match (service type relevance)

Returns JSONB array of recommendations sorted by score, including:
- resource_id, resource_name
- date, earliest_slot, available_slots
- recommendation_score (0-1)
- reasons (breakdown of scoring factors)

Example:
SELECT app.smart_appointment_recommendations(
    p_client_entity_id := ''client-uuid'',
    p_service_query := ''necesito un corte de pelo'',
    p_organization_id := ''org-uuid'',
    p_preferred_date := NULL, -- Search next 7 days
    p_limit := 5
);
';


--
-- Name: update_employee_ai_features(uuid, text, jsonb); Type: FUNCTION; Schema: app; Owner: -
--

CREATE FUNCTION app.update_employee_ai_features(p_employee_id uuid, p_feature_type text, p_feature_data jsonb) RETURNS jsonb
    LANGUAGE plpgsql SECURITY DEFINER
    AS $$
DECLARE
    v_result jsonb;
BEGIN
    -- Update specific AI feature
    UPDATE employees
    SET
        ai_features = jsonb_set(
            COALESCE(ai_features, '{}'::jsonb),
            ARRAY[p_feature_type],
            p_feature_data,
            true
        ),
        updated_at = now(),
        updated_by = auth.uid()
    WHERE id = p_employee_id
    RETURNING ai_features INTO v_result;

    IF v_result IS NULL THEN
        RAISE EXCEPTION 'Employee not found: %', p_employee_id;
    END IF;

    RETURN jsonb_build_object(
        'success', true,
        'employee_id', p_employee_id,
        'feature_type', p_feature_type,
        'updated_at', now()
    );
END;
$$;


--
-- Name: FUNCTION update_employee_ai_features(p_employee_id uuid, p_feature_type text, p_feature_data jsonb); Type: COMMENT; Schema: app; Owner: -
--

COMMENT ON FUNCTION app.update_employee_ai_features(p_employee_id uuid, p_feature_type text, p_feature_data jsonb) IS 'Update specific AI feature for an employee (embeddings, scores, predictions, etc.)';


--
-- Name: update_vacation_balance(uuid, numeric, character varying, text); Type: FUNCTION; Schema: app; Owner: -
--

CREATE FUNCTION app.update_vacation_balance(p_employee_id uuid, p_days numeric, p_operation character varying DEFAULT 'add'::character varying, p_notes text DEFAULT NULL::text) RETURNS jsonb
    LANGUAGE plpgsql SECURITY DEFINER
    AS $$
DECLARE
    v_current_balance numeric;
    v_new_balance numeric;
    v_leave_record jsonb;
    v_result jsonb;
BEGIN
    -- Get current balance
    SELECT vacation_days_accrued INTO v_current_balance
    FROM employees
    WHERE id = p_employee_id;

    IF v_current_balance IS NULL THEN
        RAISE EXCEPTION 'Employee not found: %', p_employee_id;
    END IF;

    -- Calculate new balance
    IF p_operation = 'add' THEN
        v_new_balance := v_current_balance + p_days;
    ELSIF p_operation = 'subtract' THEN
        v_new_balance := v_current_balance - p_days;
    ELSE
        RAISE EXCEPTION 'Invalid operation: % (use "add" or "subtract")', p_operation;
    END IF;

    -- Prevent negative balance
    IF v_new_balance < 0 THEN
        RAISE EXCEPTION 'Insufficient vacation balance. Current: %, Requested: %', v_current_balance, p_days;
    END IF;

    -- Create leave record for history
    v_leave_record := jsonb_build_object(
        'date', CURRENT_DATE,
        'type', 'vacation',
        'days', p_days,
        'operation', p_operation,
        'previous_balance', v_current_balance,
        'new_balance', v_new_balance,
        'notes', p_notes,
        'approved_by', auth.uid(),
        'approved_at', now()
    );

    -- Update balance and add to history
    UPDATE employees
    SET
        vacation_days_accrued = v_new_balance,
        leave_history = leave_history || v_leave_record,
        updated_by = auth.uid()
    WHERE id = p_employee_id;

    -- Return result
    v_result := jsonb_build_object(
        'success', true,
        'employee_id', p_employee_id,
        'previous_balance', v_current_balance,
        'new_balance', v_new_balance,
        'days_changed', p_days,
        'operation', p_operation
    );

    RETURN v_result;
END;
$$;


--
-- Name: FUNCTION update_vacation_balance(p_employee_id uuid, p_days numeric, p_operation character varying, p_notes text); Type: COMMENT; Schema: app; Owner: -
--

COMMENT ON FUNCTION app.update_vacation_balance(p_employee_id uuid, p_days numeric, p_operation character varying, p_notes text) IS 'Add or subtract vacation days and track in leave_history';


--
-- Name: accept_invite(text); Type: FUNCTION; Schema: public; Owner: -
--

CREATE FUNCTION public.accept_invite(invite_token text) RETURNS jsonb
    LANGUAGE plpgsql SECURITY DEFINER
    SET search_path TO 'public'
    AS $$
DECLARE
  v_invite public.invites%ROWTYPE;
  v_membership_id UUID;
  v_user_id UUID;
BEGIN
  v_user_id := auth.uid();
  
  IF v_user_id IS NULL THEN
    RETURN jsonb_build_object('success', false, 'error', 'Not authenticated');
  END IF;

  -- Lock and validate invite
  SELECT * INTO v_invite
  FROM public.invites
  WHERE token = invite_token
    AND accepted_at IS NULL
    AND revoked_at IS NULL
    AND COALESCE(expires_at, NOW() + interval '1 year') > NOW()
    AND times_used < max_uses
  FOR UPDATE;

  IF NOT FOUND THEN
    RETURN jsonb_build_object('success', false, 'error', 'Invalid, expired, or already used invitation');
  END IF;

  -- Create or update membership
  INSERT INTO public.memberships(organization_id, user_id, role_key)
  VALUES (v_invite.organization_id, v_user_id, v_invite.role_key)
  ON CONFLICT (organization_id, user_id) DO UPDATE
    SET role_key = EXCLUDED.role_key,
        updated_at = NOW()
  RETURNING id INTO v_membership_id;

  -- Mark invite as accepted
  UPDATE public.invites
    SET accepted_at = NOW(),
        accepted_by = v_user_id,
        times_used = times_used + 1
  WHERE id = v_invite.id;

  RETURN jsonb_build_object(
    'success', true,
    'organization_id', v_invite.organization_id,
    'membership_id', v_membership_id,
    'role', v_invite.role_key
  );
END;
$$;


--
-- Name: add_capability_availability(uuid, smallint[], time without time zone, time without time zone, text, jsonb); Type: FUNCTION; Schema: public; Owner: -
--

CREATE FUNCTION public.add_capability_availability(p_capability_id uuid, p_days_of_week smallint[], p_time_from time without time zone, p_time_until time without time zone, p_timezone text DEFAULT 'America/Santo_Domingo'::text, p_rules jsonb DEFAULT '{}'::jsonb) RETURNS uuid
    LANGUAGE plpgsql SECURITY DEFINER
    AS $$
DECLARE
  v_availability_id UUID;
BEGIN
  INSERT INTO public.resource_capability_availability (
    capability_id,
    days_of_week,
    time_from,
    time_until,
    timezone,
    rules
  ) VALUES (
    p_capability_id,
    p_days_of_week,
    p_time_from,
    p_time_until,
    p_timezone,
    p_rules
  )
  RETURNING id INTO v_availability_id;

  RETURN v_availability_id;
END;
$$;


--
-- Name: add_faq(uuid, text, text, text[], text); Type: FUNCTION; Schema: public; Owner: -
--

CREATE FUNCTION public.add_faq(p_organization_id uuid, p_question text, p_answer text, p_tags text[] DEFAULT '{}'::text[], p_vertical text DEFAULT NULL::text) RETURNS uuid
    LANGUAGE plpgsql
    AS $$
DECLARE
  v_id uuid;
BEGIN
  INSERT INTO org_knowledge_base (
    organization_id,
    title,
    content,
    content_type,
    tags,
    vertical
  )
  VALUES (
    p_organization_id,
    p_question,
    p_answer,
    'faq',
    p_tags,
    p_vertical
  )
  RETURNING id INTO v_id;

  RETURN v_id;
END;
$$;


--
-- Name: add_policy(uuid, text, text, text[]); Type: FUNCTION; Schema: public; Owner: -
--

CREATE FUNCTION public.add_policy(p_organization_id uuid, p_title text, p_content text, p_tags text[] DEFAULT '{}'::text[]) RETURNS uuid
    LANGUAGE plpgsql
    AS $$
DECLARE
  v_id uuid;
BEGIN
  INSERT INTO org_knowledge_base (
    organization_id,
    title,
    content,
    content_type,
    tags,
    priority
  )
  VALUES (
    p_organization_id,
    p_title,
    p_content,
    'policy',
    p_tags,
    10  -- Políticas tienen alta prioridad
  )
  RETURNING id INTO v_id;

  RETURN v_id;
END;
$$;


--
-- Name: add_resource_capability(uuid, uuid, uuid, public.proficiency_level, boolean, interval, numeric, character, jsonb); Type: FUNCTION; Schema: public; Owner: -
--

CREATE FUNCTION public.add_resource_capability(p_organization_id uuid, p_resource_entity_id uuid, p_catalog_item_id uuid, p_proficiency_level public.proficiency_level DEFAULT 'junior'::public.proficiency_level, p_is_primary boolean DEFAULT false, p_custom_duration interval DEFAULT NULL::interval, p_custom_price numeric DEFAULT NULL::numeric, p_currency_code character DEFAULT NULL::bpchar, p_attributes jsonb DEFAULT '{}'::jsonb) RETURNS uuid
    LANGUAGE plpgsql SECURITY DEFINER
    AS $$
DECLARE
  v_capability_id UUID;
  v_proficiency_score SMALLINT;
BEGIN
  -- Get numeric score from proficiency level
  v_proficiency_score := public.proficiency_to_int(p_proficiency_level);

  -- Insert or update capability
  INSERT INTO public.resource_capabilities (
    organization_id,
    resource_entity_id,
    catalog_item_id,
    proficiency_level,
    proficiency_score,
    is_primary,
    custom_duration,
    custom_price,
    currency_code,
    attributes
  ) VALUES (
    p_organization_id,
    p_resource_entity_id,
    p_catalog_item_id,
    p_proficiency_level,
    v_proficiency_score,
    p_is_primary,
    p_custom_duration,
    p_custom_price,
    p_currency_code,
    p_attributes
  )
  ON CONFLICT (organization_id, resource_entity_id, catalog_item_id, valid_from)
  DO UPDATE SET
    proficiency_level = EXCLUDED.proficiency_level,
    proficiency_score = EXCLUDED.proficiency_score,
    is_primary = EXCLUDED.is_primary,
    custom_duration = EXCLUDED.custom_duration,
    custom_price = EXCLUDED.custom_price,
    currency_code = EXCLUDED.currency_code,
    attributes = EXCLUDED.attributes,
    updated_at = now()
  RETURNING id INTO v_capability_id;

  RETURN v_capability_id;
END;
$$;


--
-- Name: FUNCTION add_resource_capability(p_organization_id uuid, p_resource_entity_id uuid, p_catalog_item_id uuid, p_proficiency_level public.proficiency_level, p_is_primary boolean, p_custom_duration interval, p_custom_price numeric, p_currency_code character, p_attributes jsonb); Type: COMMENT; Schema: public; Owner: -
--

COMMENT ON FUNCTION public.add_resource_capability(p_organization_id uuid, p_resource_entity_id uuid, p_catalog_item_id uuid, p_proficiency_level public.proficiency_level, p_is_primary boolean, p_custom_duration interval, p_custom_price numeric, p_currency_code character, p_attributes jsonb) IS 'Convenience function to add a capability to a resource with proper proficiency sync.';


--
-- Name: ai_generic_queue_embedding(); Type: FUNCTION; Schema: public; Owner: -
--

CREATE FUNCTION public.ai_generic_queue_embedding() RETURNS trigger
    LANGUAGE plpgsql SECURITY DEFINER
    AS $_$
DECLARE
    v_config record;
    v_content_text text;
    v_org_id uuid;
    v_sql text;
    v_should_process boolean;
    v_json_row jsonb;
BEGIN
    -- Get configuration for this table
    SELECT * INTO v_config
    FROM ai_embedding_configs
    WHERE table_schema = TG_TABLE_SCHEMA
      AND table_name = TG_TABLE_NAME
      AND enabled = true
      AND trigger_enabled = true;

    IF NOT FOUND THEN
        RETURN NEW;
    END IF;

    -- Check filter condition if specified
    IF v_config.filter_condition IS NOT NULL THEN
        v_sql := format('SELECT (%s) FROM (SELECT $1.*) AS t', v_config.filter_condition);
        EXECUTE v_sql INTO v_should_process USING NEW;

        IF NOT v_should_process THEN
            RETURN NEW;
        END IF;
    END IF;

    -- Get organization_id safely
    BEGIN
        EXECUTE format('SELECT ($1).%I', 'organization_id') INTO v_org_id USING NEW;
    EXCEPTION WHEN OTHERS THEN
        v_org_id := NULL;
    END;

    -- Build content using custom SQL or default concatenation
    IF v_config.custom_content_sql IS NOT NULL THEN
        -- Use custom content builder
        EXECUTE v_config.custom_content_sql INTO v_content_text USING NEW;
    ELSE
        -- Default: concatenate all content_columns SAFELY
        v_json_row := to_jsonb(NEW);
        
        SELECT string_agg(
            col || ': ' || COALESCE(v_json_row->>col, ''),
            ' | '
        )
        INTO v_content_text
        FROM unnest(v_config.content_columns) AS col;
    END IF;

    -- Insert into queue
    INSERT INTO ai_embedding_queue (
        source_table,
        source_id,
        organization_id,
        content
    ) VALUES (
        TG_TABLE_NAME,
        (NEW.id)::uuid,
        v_org_id,
        v_content_text
    )
    ON CONFLICT (source_table, source_id, organization_id)
    DO UPDATE SET
        content = EXCLUDED.content,
        status = 'pending',
        updated_at = now();

    RETURN NEW;
END;
$_$;


--
-- Name: FUNCTION ai_generic_queue_embedding(); Type: COMMENT; Schema: public; Owner: -
--

COMMENT ON FUNCTION public.ai_generic_queue_embedding() IS 'Generic trigger function for auto-embedding ANY table based on ai_embedding_configs';


--
-- Name: analyze_ai_usage_patterns(uuid, integer); Type: FUNCTION; Schema: public; Owner: -
--

CREATE FUNCTION public.analyze_ai_usage_patterns(p_organization_id uuid, p_days integer DEFAULT 30) RETURNS jsonb
    LANGUAGE plpgsql SECURITY DEFINER
    AS $$
DECLARE
  result jsonb;
BEGIN
  SELECT jsonb_build_object(
    'top_queries', (
      SELECT jsonb_agg(jsonb_build_object('query', query, 'count', count))
      FROM (
        SELECT query, COUNT(*) as count
        FROM ai_interactions
        WHERE organization_id = p_organization_id
          AND created_at >= now() - (p_days || ' days')::interval
        GROUP BY query
        ORDER BY count DESC
        LIMIT 10
      ) top_q
    ),
    'top_skills', (
      SELECT jsonb_agg(jsonb_build_object('skill_id', skill, 'count', count))
      FROM (
        SELECT unnest(skills_executed) as skill, COUNT(*) as count
        FROM ai_interactions
        WHERE organization_id = p_organization_id
          AND created_at >= now() - (p_days || ' days')::interval
        GROUP BY skill
        ORDER BY count DESC
        LIMIT 10
      ) top_s
    ),
    'avg_cost', (
      SELECT COALESCE(AVG(cost), 0)
      FROM ai_interactions
      WHERE organization_id = p_organization_id
        AND created_at >= now() - (p_days || ' days')::interval
    ),
    'avg_duration_ms', (
      SELECT COALESCE(AVG(duration_ms), 0)
      FROM ai_interactions
      WHERE organization_id = p_organization_id
        AND created_at >= now() - (p_days || ' days')::interval
    ),
    'total_interactions', (
      SELECT COUNT(*)
      FROM ai_interactions
      WHERE organization_id = p_organization_id
        AND created_at >= now() - (p_days || ' days')::interval
    ),
    'total_cost', (
      SELECT COALESCE(SUM(cost), 0)
      FROM ai_interactions
      WHERE organization_id = p_organization_id
        AND created_at >= now() - (p_days || ' days')::interval
    )
  ) INTO result;
  
  RETURN result;
END;
$$;


--
-- Name: FUNCTION analyze_ai_usage_patterns(p_organization_id uuid, p_days integer); Type: COMMENT; Schema: public; Owner: -
--

COMMENT ON FUNCTION public.analyze_ai_usage_patterns(p_organization_id uuid, p_days integer) IS 'Análisis de patrones de uso de IA. Para optimización y billing.';


SET default_tablespace = '';

SET default_table_access_method = heap;

--
-- Name: appointments; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.appointments (
    id uuid DEFAULT gen_random_uuid() NOT NULL,
    organization_id uuid NOT NULL,
    client_entity_id uuid,
    client_type public.appointment_client_type DEFAULT 'patient'::public.appointment_client_type NOT NULL,
    resource_entity_id uuid NOT NULL,
    resource_type public.appointment_resource_type NOT NULL,
    resource_subtype text,
    appointment_date date NOT NULL,
    start_time time without time zone NOT NULL,
    end_time time without time zone NOT NULL,
    duration_minutes integer GENERATED ALWAYS AS (((EXTRACT(epoch FROM (end_time - start_time)))::integer / 60)) STORED,
    timezone text DEFAULT 'America/Santo_Domingo'::text,
    catalog_item_id uuid,
    catalog_item_name text,
    catalog_item_price numeric(12,2),
    catalog_item_duration_minutes integer,
    status public.appointment_status DEFAULT 'pending'::public.appointment_status,
    notes text,
    cancellation_reason text,
    internal_notes text,
    location_entity_id uuid,
    location_type public.appointment_location_type DEFAULT 'physical'::public.appointment_location_type,
    location_details jsonb DEFAULT '{}'::jsonb,
    custom_fields jsonb DEFAULT '{}'::jsonb,
    tags text[],
    reminders_sent jsonb DEFAULT '[]'::jsonb,
    last_reminder_sent_at timestamp with time zone,
    confirmation_received_at timestamp with time zone,
    ai_no_show_prediction jsonb DEFAULT '{}'::jsonb,
    ai_optimal_scheduling jsonb DEFAULT '{}'::jsonb,
    ai_duration_prediction jsonb DEFAULT '{}'::jsonb,
    ai_resource_optimization jsonb DEFAULT '{}'::jsonb,
    ai_client_preferences jsonb DEFAULT '{}'::jsonb,
    ai_upsell_opportunities jsonb DEFAULT '{}'::jsonb,
    created_at timestamp with time zone DEFAULT now() NOT NULL,
    updated_at timestamp with time zone DEFAULT now() NOT NULL,
    created_by uuid,
    updated_by uuid,
    deleted_at timestamp with time zone,
    deleted_by uuid,
    embedding extensions.vector(1536),
    has_embedding boolean DEFAULT false,
    reminder_sent_at timestamp with time zone,
    handoff_target text,
    handoff_status text,
    recurrence_group_id uuid,
    recurrence_rule jsonb,
    is_recurrence_exception boolean DEFAULT false,
    buffer_before_minutes integer DEFAULT 0,
    buffer_after_minutes integer DEFAULT 0,
    CONSTRAINT appointments_date_not_past CHECK ((appointment_date >= (CURRENT_DATE - '1 year'::interval))),
    CONSTRAINT appointments_time_check CHECK ((end_time > start_time))
);


--
-- Name: TABLE appointments; Type: COMMENT; Schema: public; Owner: -
--

COMMENT ON TABLE public.appointments IS 'Universal appointments system supporting healthcare, beauty, retail, equipment, and custom verticals';


--
-- Name: COLUMN appointments.client_entity_id; Type: COMMENT; Schema: public; Owner: -
--

COMMENT ON COLUMN public.appointments.client_entity_id IS 'Universal client: patient, customer, beauty_client, etc';


--
-- Name: COLUMN appointments.client_type; Type: COMMENT; Schema: public; Owner: -
--

COMMENT ON COLUMN public.appointments.client_type IS 'Type of client making appointment';


--
-- Name: COLUMN appointments.resource_entity_id; Type: COMMENT; Schema: public; Owner: -
--

COMMENT ON COLUMN public.appointments.resource_entity_id IS 'Primary resource being scheduled (person, equipment, space, vehicle)';


--
-- Name: COLUMN appointments.resource_type; Type: COMMENT; Schema: public; Owner: -
--

COMMENT ON COLUMN public.appointments.resource_type IS 'Type of resource: healthcare_provider, medical_equipment, beauty_stylist, delivery_vehicle, etc';


--
-- Name: COLUMN appointments.resource_subtype; Type: COMMENT; Schema: public; Owner: -
--

COMMENT ON COLUMN public.appointments.resource_subtype IS 'Granular classification: mri_machine, hair_stylist, delivery_truck, etc';


--
-- Name: COLUMN appointments.catalog_item_id; Type: COMMENT; Schema: public; Owner: -
--

COMMENT ON COLUMN public.appointments.catalog_item_id IS 'Reference to catalog_items.id - can be a service, product, bundle, or subscription';


--
-- Name: COLUMN appointments.catalog_item_name; Type: COMMENT; Schema: public; Owner: -
--

COMMENT ON COLUMN public.appointments.catalog_item_name IS 'Denormalized name of the catalog item for display purposes';


--
-- Name: COLUMN appointments.catalog_item_price; Type: COMMENT; Schema: public; Owner: -
--

COMMENT ON COLUMN public.appointments.catalog_item_price IS 'Price at the time of booking (may differ from current catalog price)';


--
-- Name: COLUMN appointments.catalog_item_duration_minutes; Type: COMMENT; Schema: public; Owner: -
--

COMMENT ON COLUMN public.appointments.catalog_item_duration_minutes IS 'Expected duration from catalog item at booking time';


--
-- Name: COLUMN appointments.location_type; Type: COMMENT; Schema: public; Owner: -
--

COMMENT ON COLUMN public.appointments.location_type IS 'Appointment location: physical, virtual, mobile, or hybrid';


--
-- Name: COLUMN appointments.confirmation_received_at; Type: COMMENT; Schema: public; Owner: -
--

COMMENT ON COLUMN public.appointments.confirmation_received_at IS 'Timestamp cuando el cliente confirmó la cita';


--
-- Name: COLUMN appointments.ai_no_show_prediction; Type: COMMENT; Schema: public; Owner: -
--

COMMENT ON COLUMN public.appointments.ai_no_show_prediction IS 'AI prediction: {no_show_probability, risk_level, confidence, factors}';


--
-- Name: COLUMN appointments.ai_optimal_scheduling; Type: COMMENT; Schema: public; Owner: -
--

COMMENT ON COLUMN public.appointments.ai_optimal_scheduling IS 'AI optimal scheduling: {recommended_time, day_of_week, reasoning}';


--
-- Name: COLUMN appointments.ai_duration_prediction; Type: COMMENT; Schema: public; Owner: -
--

COMMENT ON COLUMN public.appointments.ai_duration_prediction IS 'AI duration prediction: {predicted_minutes, confidence_interval}';


--
-- Name: COLUMN appointments.ai_resource_optimization; Type: COMMENT; Schema: public; Owner: -
--

COMMENT ON COLUMN public.appointments.ai_resource_optimization IS 'AI resource optimization: {alternative_resources, cost_savings}';


--
-- Name: COLUMN appointments.ai_client_preferences; Type: COMMENT; Schema: public; Owner: -
--

COMMENT ON COLUMN public.appointments.ai_client_preferences IS 'AI client preferences: {preferred_times, preferred_providers}';


--
-- Name: COLUMN appointments.ai_upsell_opportunities; Type: COMMENT; Schema: public; Owner: -
--

COMMENT ON COLUMN public.appointments.ai_upsell_opportunities IS 'AI upsell opportunities: {recommended_services, revenue_potential}';


--
-- Name: COLUMN appointments.reminder_sent_at; Type: COMMENT; Schema: public; Owner: -
--

COMMENT ON COLUMN public.appointments.reminder_sent_at IS 'Timestamp cuando se envió el recordatorio';


--
-- Name: COLUMN appointments.recurrence_group_id; Type: COMMENT; Schema: public; Owner: -
--

COMMENT ON COLUMN public.appointments.recurrence_group_id IS 'Groups all instances of a recurring appointment';


--
-- Name: COLUMN appointments.recurrence_rule; Type: COMMENT; Schema: public; Owner: -
--

COMMENT ON COLUMN public.appointments.recurrence_rule IS 'Recurrence pattern: {frequency, interval, daysOfWeek, endDate, occurrences}';


--
-- Name: COLUMN appointments.is_recurrence_exception; Type: COMMENT; Schema: public; Owner: -
--

COMMENT ON COLUMN public.appointments.is_recurrence_exception IS 'True if this instance was modified from the series';


--
-- Name: COLUMN appointments.buffer_before_minutes; Type: COMMENT; Schema: public; Owner: -
--

COMMENT ON COLUMN public.appointments.buffer_before_minutes IS 'Buffer time before appointment (prep time)';


--
-- Name: COLUMN appointments.buffer_after_minutes; Type: COMMENT; Schema: public; Owner: -
--

COMMENT ON COLUMN public.appointments.buffer_after_minutes IS 'Buffer time after appointment (cleanup time)';


--
-- Name: appointments_embedding_content(public.appointments); Type: FUNCTION; Schema: public; Owner: -
--

CREATE FUNCTION public.appointments_embedding_content(appt public.appointments) RETURNS text
    LANGUAGE plpgsql STABLE SECURITY DEFINER
    AS $$
DECLARE
  v_org_name text;
  v_vertical_code text;
  v_client_name text;
  v_resource_name text;
  v_service_label text;
  v_client_label text;
  v_content_parts text[];
BEGIN
  -- Get organization and vertical info
  SELECT
    o.name,
    COALESCE(ov.code, 'other'),
    COALESCE(ov.terminology_config->>'service_label', 'Service'),
    COALESCE(ov.terminology_config->>'person_label', 'Client')
  INTO
    v_org_name,
    v_vertical_code,
    v_service_label,
    v_client_label
  FROM organizations o
  LEFT JOIN organization_verticals ov ON ov.id = o.vertical_id
  WHERE o.id = appt.organization_id;

  -- Get client name from entity
  SELECT display_name INTO v_client_name
  FROM entities
  WHERE id = appt.client_entity_id;

  -- Get resource name from entity (usually employee/doctor/stylist)
  SELECT display_name INTO v_resource_name
  FROM entities
  WHERE id = appt.resource_entity_id;

  -- Start with vertical context
  v_content_parts := ARRAY[format('[VERTICAL: %s | %s]', v_vertical_code, v_org_name)];

  -- Add appointment type description based on vertical
  CASE v_vertical_code
    WHEN 'healthcare', 'dental_clinic' THEN
      v_content_parts := array_append(v_content_parts, 'Appointment Type: Medical Consultation');
    WHEN 'veterinary' THEN
      v_content_parts := array_append(v_content_parts, 'Appointment Type: Veterinary Visit');
    WHEN 'beauty_salon', 'spa', 'wellness' THEN
      v_content_parts := array_append(v_content_parts, 'Appointment Type: Beauty/Wellness Service');
    WHEN 'gym', 'fitness' THEN
      v_content_parts := array_append(v_content_parts, 'Appointment Type: Fitness Session');
    ELSE
      v_content_parts := array_append(v_content_parts, 'Appointment Type: Scheduled Service');
  END CASE;

  -- Add client info
  IF v_client_name IS NOT NULL THEN
    v_content_parts := array_append(v_content_parts,
      format('%s: %s', v_client_label, v_client_name)
    );
  END IF;

  -- Add resource/provider info
  IF v_resource_name IS NOT NULL THEN
    CASE v_vertical_code
      WHEN 'healthcare', 'dental_clinic' THEN
        v_content_parts := array_append(v_content_parts, format('Doctor: %s', v_resource_name));
      WHEN 'veterinary' THEN
        v_content_parts := array_append(v_content_parts, format('Veterinarian: %s', v_resource_name));
      WHEN 'beauty_salon' THEN
        v_content_parts := array_append(v_content_parts, format('Stylist: %s', v_resource_name));
      WHEN 'spa', 'wellness' THEN
        v_content_parts := array_append(v_content_parts, format('Therapist: %s', v_resource_name));
      WHEN 'gym', 'fitness' THEN
        v_content_parts := array_append(v_content_parts, format('Trainer: %s', v_resource_name));
      ELSE
        v_content_parts := array_append(v_content_parts, format('Provider: %s', v_resource_name));
    END CASE;
  END IF;

  -- Add service info
  IF appt.service_name IS NOT NULL THEN
    v_content_parts := array_append(v_content_parts,
      format('%s: %s', v_service_label, appt.service_name)
    );
  END IF;

  -- Add date and time
  v_content_parts := array_append(v_content_parts,
    format('Date: %s', appt.appointment_date::text)
  );

  v_content_parts := array_append(v_content_parts,
    format('Time: %s - %s', appt.start_time::text, appt.end_time::text)
  );

  -- Add duration
  IF appt.duration_minutes IS NOT NULL THEN
    v_content_parts := array_append(v_content_parts,
      format('Duration: %s minutes', appt.duration_minutes)
    );
  END IF;

  -- Add status
  IF appt.status IS NOT NULL THEN
    v_content_parts := array_append(v_content_parts,
      format('Status: %s', appt.status)
    );
  END IF;

  -- Add notes (truncated)
  IF appt.notes IS NOT NULL AND appt.notes != '' THEN
    v_content_parts := array_append(v_content_parts,
      format('Notes: %s', left(appt.notes, 300))
    );
  END IF;

  -- Add tags
  IF appt.tags IS NOT NULL AND array_length(appt.tags, 1) > 0 THEN
    v_content_parts := array_append(v_content_parts,
      format('Tags: %s', array_to_string(appt.tags, ', '))
    );
  END IF;

  -- Add cancellation reason if applicable
  IF appt.status::text = 'cancelled' AND appt.cancellation_reason IS NOT NULL THEN
    v_content_parts := array_append(v_content_parts,
      format('Cancellation Reason: %s', appt.cancellation_reason)
    );
  END IF;

  RETURN array_to_string(v_content_parts, ' | ');
END;
$$;


--
-- Name: FUNCTION appointments_embedding_content(appt public.appointments); Type: COMMENT; Schema: public; Owner: -
--

COMMENT ON FUNCTION public.appointments_embedding_content(appt public.appointments) IS 'Generates multi-vertical aware content for appointment embeddings. Includes client, provider, service, date/time, and notes for semantic search.';


--
-- Name: appointments_embedding_content_wrapper(uuid); Type: FUNCTION; Schema: public; Owner: -
--

CREATE FUNCTION public.appointments_embedding_content_wrapper(p_id uuid) RETURNS text
    LANGUAGE sql STABLE SECURITY DEFINER
    SET search_path TO 'public'
    AS $$
  SELECT appointments_embedding_content(a) FROM appointments a WHERE a.id = p_id;
$$;


--
-- Name: FUNCTION appointments_embedding_content_wrapper(p_id uuid); Type: COMMENT; Schema: public; Owner: -
--

COMMENT ON FUNCTION public.appointments_embedding_content_wrapper(p_id uuid) IS 'Wrapper function for appointments_embedding_content that accepts UUID for process_embeddings compatibility.';


--
-- Name: book_appointment_with_resources(uuid, uuid, text, uuid, date, time without time zone, time without time zone, uuid, text, jsonb, jsonb); Type: FUNCTION; Schema: public; Owner: -
--

CREATE FUNCTION public.book_appointment_with_resources(p_organization_id uuid, p_client_entity_id uuid DEFAULT NULL::uuid, p_client_type text DEFAULT 'customer'::text, p_primary_resource_entity_id uuid DEFAULT NULL::uuid, p_appointment_date date DEFAULT NULL::date, p_start_time time without time zone DEFAULT NULL::time without time zone, p_end_time time without time zone DEFAULT NULL::time without time zone, p_service_id uuid DEFAULT NULL::uuid, p_notes text DEFAULT ''::text, p_service_items jsonb DEFAULT '[]'::jsonb, p_additional_resources jsonb DEFAULT '[]'::jsonb) RETURNS json
    LANGUAGE plpgsql SECURITY DEFINER
    AS $$
DECLARE
    v_appointment_id UUID;
    v_resource_type appointment_resource_type;
    v_client_type appointment_client_type;
    v_conflict_count INTEGER;
BEGIN
    -- ========================================
    -- VALIDATION: Required fields
    -- ========================================
    IF p_organization_id IS NULL THEN
        RETURN json_build_object('success', false, 'error', 'Organization ID is required');
    END IF;
    IF p_primary_resource_entity_id IS NULL THEN
        RETURN json_build_object('success', false, 'error', 'Resource is required');
    END IF;
    IF p_appointment_date IS NULL THEN
        RETURN json_build_object('success', false, 'error', 'Appointment date is required');
    END IF;
    IF p_start_time IS NULL OR p_end_time IS NULL THEN
        RETURN json_build_object('success', false, 'error', 'Start and end times are required');
    END IF;
    
    -- ========================================
    -- VALIDATION: Time range is valid
    -- ========================================
    IF p_end_time <= p_start_time THEN
        RETURN json_build_object('success', false, 'error', 'End time must be after start time');
    END IF;
    
    -- ========================================
    -- CONFLICT DETECTION: Check for overlapping appointments
    -- ========================================
    SELECT COUNT(*) INTO v_conflict_count
    FROM appointments
    WHERE organization_id = p_organization_id
      AND resource_entity_id = p_primary_resource_entity_id
      AND appointment_date = p_appointment_date
      AND status NOT IN ('cancelled', 'no_show')  -- Ignore cancelled appointments
      AND (
          -- New appointment starts during existing appointment
          (p_start_time >= start_time AND p_start_time < end_time)
          OR
          -- New appointment ends during existing appointment
          (p_end_time > start_time AND p_end_time <= end_time)
          OR
          -- New appointment completely contains existing appointment
          (p_start_time <= start_time AND p_end_time >= end_time)
      );
    
    IF v_conflict_count > 0 THEN
        RETURN json_build_object(
            'success', false, 
            'error', 'Time slot conflict: This resource already has an appointment during this time',
            'conflict_count', v_conflict_count
        );
    END IF;
    
    -- ========================================
    -- Determine resource_type and client_type
    -- ========================================
    v_resource_type := 'person';
    v_client_type := 'customer';
    BEGIN
        v_client_type := p_client_type::appointment_client_type;
    EXCEPTION WHEN OTHERS THEN
        v_client_type := 'customer';
    END;

    -- ========================================
    -- INSERT the appointment
    -- ========================================
    INSERT INTO appointments (
        organization_id,
        client_entity_id,
        client_type,
        resource_entity_id,
        resource_type,
        catalog_item_id,
        appointment_date,
        start_time,
        end_time,
        notes,
        status
    )
    VALUES (
        p_organization_id,
        p_client_entity_id,
        v_client_type,
        p_primary_resource_entity_id,
        v_resource_type,
        p_service_id,
        p_appointment_date,
        p_start_time,
        p_end_time,
        COALESCE(p_notes, ''),
        'scheduled'
    )
    RETURNING id INTO v_appointment_id;

    RETURN json_build_object(
        'success', true,
        'appointment_id', v_appointment_id,
        'message', 'Appointment created successfully'
    );

EXCEPTION
    WHEN OTHERS THEN
        RETURN json_build_object('success', false, 'error', SQLERRM, 'sqlstate', SQLSTATE);
END;
$$;


--
-- Name: build_patient_vertical_content(uuid); Type: FUNCTION; Schema: public; Owner: -
--

CREATE FUNCTION public.build_patient_vertical_content(p_patient_id uuid) RETURNS text
    LANGUAGE plpgsql SECURITY DEFINER
    AS $$
DECLARE
  -- Organization and vertical info
  v_org_id uuid;
  v_org_name text;
  v_vertical_code text;
  v_person_label text;
  
  -- Patient fields
  v_entity_id uuid;
  v_display_name text;
  v_patient_code text;
  v_category text;
  v_status text;
  v_blood_type text;
  v_medical_history jsonb;
  v_allergies jsonb;
  v_current_medications jsonb;
  v_vertical_fields jsonb;
  v_first_visit_date date;
  v_last_visit_date date;
  
  -- Content building
  v_content_parts text[];
  v_result text;
BEGIN
  -- Get patient data with vertical info
  SELECT 
    p.organization_id,
    o.name,
    ov.code,
    COALESCE(ov.terminology_config->>'person_label', 'Person'),
    p.entity_id,
    e.display_name,
    p.patient_code,
    p.category,
    p.status,
    p.blood_type,
    p.medical_history,
    p.allergies,
    p.current_medications,
    p.vertical_fields,
    p.first_visit_date,
    p.last_visit_date
  INTO
    v_org_id,
    v_org_name,
    v_vertical_code,
    v_person_label,
    v_entity_id,
    v_display_name,
    v_patient_code,
    v_category,
    v_status,
    v_blood_type,
    v_medical_history,
    v_allergies,
    v_current_medications,
    v_vertical_fields,
    v_first_visit_date,
    v_last_visit_date
  FROM patients p
  JOIN entities e ON e.id = p.entity_id
  JOIN organizations o ON o.id = p.organization_id
  LEFT JOIN organization_verticals ov ON ov.id = o.vertical_id
  WHERE p.id = p_patient_id;

  IF NOT FOUND THEN
    RETURN NULL;
  END IF;

  -- Start with vertical context
  v_content_parts := ARRAY[format('[VERTICAL: %s | %s]', v_vertical_code, v_org_name)];
  
  -- Add adapted person label with name
  v_content_parts := array_append(v_content_parts, 
    format('%s: %s', v_person_label, v_display_name)
  );
  
  -- Add patient code if present
  IF v_patient_code IS NOT NULL THEN
    v_content_parts := array_append(v_content_parts, 
      format('Patient Code: %s', v_patient_code)
    );
  END IF;

  -- Add category and status
  v_content_parts := array_append(v_content_parts, 
    format('Category: %s', v_category)
  );
  v_content_parts := array_append(v_content_parts, 
    format('Status: %s', v_status)
  );

  -- Healthcare-specific fields
  IF v_vertical_code IN ('healthcare', 'dental_clinic', 'veterinary') THEN
    IF v_medical_history IS NOT NULL AND jsonb_array_length(v_medical_history) > 0 THEN
      v_content_parts := array_append(v_content_parts, 
        format('Medical History: %s', v_medical_history::text)
      );
    END IF;

    IF v_allergies IS NOT NULL AND jsonb_array_length(v_allergies) > 0 THEN
      v_content_parts := array_append(v_content_parts, 
        format('Allergies: %s', jsonb_array_to_text_array(v_allergies))
      );
    END IF;

    IF v_current_medications IS NOT NULL AND jsonb_array_length(v_current_medications) > 0 THEN
      v_content_parts := array_append(v_content_parts, 
        format('Current Medications: %s', v_current_medications::text)
      );
    END IF;

    IF v_blood_type IS NOT NULL THEN
      v_content_parts := array_append(v_content_parts, 
        format('Blood Type: %s', v_blood_type)
      );
    END IF;
  END IF;

  -- Add vertical-specific fields from vertical_fields JSONB
  IF v_vertical_fields IS NOT NULL AND jsonb_typeof(v_vertical_fields) = 'object' THEN
    -- Beauty salon specific
    IF v_vertical_code = 'beauty_salon' THEN
      IF v_vertical_fields->>'hair_type' IS NOT NULL THEN
        v_content_parts := array_append(v_content_parts, 
          format('Hair Type: %s', v_vertical_fields->>'hair_type')
        );
      END IF;
      IF v_vertical_fields->>'skin_type' IS NOT NULL THEN
        v_content_parts := array_append(v_content_parts, 
          format('Skin Type: %s', v_vertical_fields->>'skin_type')
        );
      END IF;
      IF v_vertical_fields->>'favorite_services' IS NOT NULL THEN
        v_content_parts := array_append(v_content_parts, 
          format('Favorite Services: %s', v_vertical_fields->>'favorite_services')
        );
      END IF;
    END IF;

    -- Spa specific
    IF v_vertical_code = 'spa' THEN
      IF v_vertical_fields->>'health_concerns' IS NOT NULL THEN
        v_content_parts := array_append(v_content_parts, 
          format('Health Concerns: %s', v_vertical_fields->>'health_concerns')
        );
      END IF;
      IF v_vertical_fields->>'pressure_preference' IS NOT NULL THEN
        v_content_parts := array_append(v_content_parts, 
          format('Pressure Preference: %s', v_vertical_fields->>'pressure_preference')
        );
      END IF;
    END IF;

    -- Retail specific
    IF v_vertical_code = 'retail' THEN
      IF v_vertical_fields->>'purchase_preferences' IS NOT NULL THEN
        v_content_parts := array_append(v_content_parts, 
          format('Purchase Preferences: %s', v_vertical_fields->>'purchase_preferences')
        );
      END IF;
      IF v_vertical_fields->>'dietary_restrictions' IS NOT NULL THEN
        v_content_parts := array_append(v_content_parts, 
          format('Dietary Restrictions: %s', v_vertical_fields->>'dietary_restrictions')
        );
      END IF;
    END IF;
  END IF;

  -- Add visit history
  IF v_first_visit_date IS NOT NULL THEN
    v_content_parts := array_append(v_content_parts, 
      format('First Visit: %s', v_first_visit_date::text)
    );
  END IF;

  IF v_last_visit_date IS NOT NULL THEN
    v_content_parts := array_append(v_content_parts, 
      format('Last Visit: %s', v_last_visit_date::text)
    );
  END IF;

  -- Combine all parts
  v_result := array_to_string(v_content_parts, E'\n');

  RETURN v_result;
END;
$$;


--
-- Name: FUNCTION build_patient_vertical_content(p_patient_id uuid); Type: COMMENT; Schema: public; Owner: -
--

COMMENT ON FUNCTION public.build_patient_vertical_content(p_patient_id uuid) IS 'Builds vertical-aware content for patient embeddings using organization_verticals configuration';


--
-- Name: calculate_daily_time_summary(uuid, date); Type: FUNCTION; Schema: public; Owner: -
--

CREATE FUNCTION public.calculate_daily_time_summary(p_employee_id uuid, p_date date) RETURNS uuid
    LANGUAGE plpgsql SECURITY DEFINER
    AS $$
DECLARE
    v_org_id UUID;
    v_summary_id UUID;
    v_first_in TIMESTAMPTZ;
    v_last_out TIMESTAMPTZ;
    v_worked_minutes INTEGER := 0;
    v_break_minutes INTEGER := 0;
    v_is_late BOOLEAN := false;
    v_late_minutes INTEGER := 0;
    v_scheduled_start TIME;
    v_entry RECORD;
    v_last_clock_in TIMESTAMPTZ;
BEGIN
    -- Get organization
    SELECT organization_id INTO v_org_id
    FROM employees
    WHERE id = p_employee_id;

    -- Get scheduled start time from work_schedule
    SELECT (work_schedule->'weekly_schedule'->lower(to_char(p_date, 'day'))->>'start')::TIME
    INTO v_scheduled_start
    FROM employees
    WHERE id = p_employee_id;

    -- Calculate worked time from entries
    FOR v_entry IN
        SELECT * FROM time_entries
        WHERE employee_id = p_employee_id
        AND entry_date = p_date
        AND deleted_at IS NULL
        ORDER BY entry_timestamp
    LOOP
        CASE v_entry.entry_type
            WHEN 'clock_in' THEN
                v_last_clock_in := v_entry.entry_timestamp;
                IF v_first_in IS NULL THEN
                    v_first_in := v_entry.entry_timestamp;
                    -- Check if late
                    IF v_scheduled_start IS NOT NULL AND v_entry.entry_time > v_scheduled_start THEN
                        v_is_late := true;
                        v_late_minutes := EXTRACT(EPOCH FROM (v_entry.entry_time - v_scheduled_start))::INTEGER / 60;
                    END IF;
                END IF;
            WHEN 'clock_out' THEN
                IF v_last_clock_in IS NOT NULL THEN
                    v_worked_minutes := v_worked_minutes +
                        EXTRACT(EPOCH FROM (v_entry.entry_timestamp - v_last_clock_in))::INTEGER / 60;
                    v_last_out := v_entry.entry_timestamp;
                    v_last_clock_in := NULL;
                END IF;
            WHEN 'break_start' THEN
                -- Similar logic for breaks
                NULL;
            WHEN 'break_end' THEN
                NULL;
            ELSE
                NULL;
        END CASE;
    END LOOP;

    -- Upsert summary
    INSERT INTO daily_time_summary (
        organization_id,
        employee_id,
        summary_date,
        status,
        worked_minutes,
        regular_minutes,
        break_minutes,
        first_clock_in,
        last_clock_out,
        is_present,
        is_absent,
        is_late,
        late_minutes,
        last_calculated_at
    ) VALUES (
        v_org_id,
        p_employee_id,
        p_date,
        'calculated',
        v_worked_minutes,
        LEAST(v_worked_minutes, 480),  -- Cap regular at 8 hours
        v_break_minutes,
        v_first_in,
        v_last_out,
        v_first_in IS NOT NULL,
        v_first_in IS NULL,
        v_is_late,
        v_late_minutes,
        NOW()
    )
    ON CONFLICT (employee_id, summary_date) DO UPDATE SET
        status = 'calculated',
        worked_minutes = EXCLUDED.worked_minutes,
        regular_minutes = EXCLUDED.regular_minutes,
        break_minutes = EXCLUDED.break_minutes,
        first_clock_in = EXCLUDED.first_clock_in,
        last_clock_out = EXCLUDED.last_clock_out,
        is_present = EXCLUDED.is_present,
        is_absent = EXCLUDED.is_absent,
        is_late = EXCLUDED.is_late,
        late_minutes = EXCLUDED.late_minutes,
        last_calculated_at = NOW(),
        calculation_version = daily_time_summary.calculation_version + 1
    RETURNING id INTO v_summary_id;

    -- Mark entries as processed
    UPDATE time_entries
    SET is_processed = true, processed_at = NOW()
    WHERE employee_id = p_employee_id
    AND entry_date = p_date
    AND is_processed = false
    AND deleted_at IS NULL;

    RETURN v_summary_id;
END;
$$;


--
-- Name: calculate_department_path(); Type: FUNCTION; Schema: public; Owner: -
--

CREATE FUNCTION public.calculate_department_path() RETURNS trigger
    LANGUAGE plpgsql
    AS $$
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
$$;


--
-- Name: can_execute_skill(uuid, uuid, uuid); Type: FUNCTION; Schema: public; Owner: -
--

CREATE FUNCTION public.can_execute_skill(p_organization_id uuid, p_user_id uuid, p_skill_id uuid) RETURNS boolean
    LANGUAGE sql SECURITY DEFINER
    AS $$
    -- For now, return true (allow all)
    -- TODO: Implement proper RBAC
    SELECT true;
$$;


--
-- Name: capabilities_updated_at(); Type: FUNCTION; Schema: public; Owner: -
--

CREATE FUNCTION public.capabilities_updated_at() RETURNS trigger
    LANGUAGE plpgsql
    AS $$
BEGIN
  NEW.updated_at = now();
  RETURN NEW;
END;
$$;


--
-- Name: catalog_categories; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.catalog_categories (
    id uuid DEFAULT gen_random_uuid() NOT NULL,
    organization_id uuid NOT NULL,
    parent_id uuid,
    path public.ltree,
    depth integer GENERATED ALWAYS AS (
CASE
    WHEN (path IS NULL) THEN 0
    ELSE public.nlevel(path)
END) STORED,
    name text NOT NULL,
    slug character varying(100),
    description text,
    image_url text,
    sort_order integer DEFAULT 0,
    is_active boolean DEFAULT true NOT NULL,
    embedding extensions.vector(1536),
    custom_fields jsonb DEFAULT '{}'::jsonb,
    created_at timestamp with time zone DEFAULT now() NOT NULL,
    updated_at timestamp with time zone DEFAULT now() NOT NULL,
    deleted_at timestamp with time zone,
    has_embedding boolean DEFAULT false,
    CONSTRAINT catalog_categories_name_check CHECK ((length(TRIM(BOTH FROM name)) >= 2))
);


--
-- Name: TABLE catalog_categories; Type: COMMENT; Schema: public; Owner: -
--

COMMENT ON TABLE public.catalog_categories IS 'Hierarchical product/service categories with ltree support';


--
-- Name: catalog_categories_embedding_content(public.catalog_categories); Type: FUNCTION; Schema: public; Owner: -
--

CREATE FUNCTION public.catalog_categories_embedding_content(cat public.catalog_categories) RETURNS text
    LANGUAGE plpgsql STABLE SECURITY DEFINER
    AS $$
DECLARE
    v_org_name text;
    v_content_parts text[];
BEGIN
    -- Get organization info
    IF cat.organization_id IS NOT NULL THEN
        SELECT name INTO v_org_name
        FROM organizations
        WHERE id = cat.organization_id;

        v_content_parts := ARRAY[format('[ORG: %s]', v_org_name)];
    ELSE
        v_content_parts := ARRAY['[GLOBAL CATEGORY]'];
    END IF;

    -- Category name
    v_content_parts := array_append(v_content_parts, format('Category: %s', cat.name));

    -- Slug (code equivalent)
    IF cat.slug IS NOT NULL THEN
        v_content_parts := array_append(v_content_parts, format('Slug: %s', cat.slug));
    END IF;

    -- Path (hierarchy)
    IF cat.path IS NOT NULL THEN
        v_content_parts := array_append(v_content_parts, format('Path: %s', cat.path::text));
    END IF;

    -- Description
    IF cat.description IS NOT NULL AND cat.description != '' THEN
        v_content_parts := array_append(v_content_parts,
            format('Description: %s', cat.description)
        );
    END IF;

    RETURN array_to_string(v_content_parts, ' | ');
END;
$$;


--
-- Name: FUNCTION catalog_categories_embedding_content(cat public.catalog_categories); Type: COMMENT; Schema: public; Owner: -
--

COMMENT ON FUNCTION public.catalog_categories_embedding_content(cat public.catalog_categories) IS 'Generates content for category embeddings including hierarchy path';


--
-- Name: catalog_categories_embedding_content_wrapper(uuid); Type: FUNCTION; Schema: public; Owner: -
--

CREATE FUNCTION public.catalog_categories_embedding_content_wrapper(p_id uuid) RETURNS text
    LANGUAGE sql STABLE SECURITY DEFINER
    SET search_path TO 'public'
    AS $$
  SELECT catalog_categories_embedding_content(cc) FROM catalog_categories cc WHERE cc.id = p_id;
$$;


--
-- Name: catalog_categories_maintain_path(); Type: FUNCTION; Schema: public; Owner: -
--

CREATE FUNCTION public.catalog_categories_maintain_path() RETURNS trigger
    LANGUAGE plpgsql
    AS $$
BEGIN
    IF NEW.parent_id IS NULL THEN
        NEW.path = text2ltree(NEW.id::text);
    ELSE
        SELECT path || NEW.id::text INTO NEW.path
        FROM public.catalog_categories
        WHERE id = NEW.parent_id;
    END IF;
    RETURN NEW;
END;
$$;


--
-- Name: catalog_items; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.catalog_items (
    id uuid DEFAULT gen_random_uuid() NOT NULL,
    organization_id uuid NOT NULL,
    item_code character varying(50) NOT NULL,
    name text NOT NULL,
    internal_reference character varying(100),
    barcode character varying(50),
    item_type character varying(30) DEFAULT 'product'::character varying NOT NULL,
    tracking_type character varying(30) DEFAULT 'none'::character varying NOT NULL,
    is_storable boolean GENERATED ALWAYS AS (((item_type)::text = ANY ((ARRAY['product'::character varying, 'consumable'::character varying])::text[]))) STORED,
    is_bookable boolean GENERATED ALWAYS AS (((item_type)::text = ANY ((ARRAY['service'::character varying, 'bundle'::character varying])::text[]))) STORED,
    parent_id uuid,
    variant_name text,
    is_template boolean GENERATED ALWAYS AS ((parent_id IS NULL)) STORED,
    display_name text GENERATED ALWAYS AS ((name || COALESCE((' - '::text || variant_name), ''::text))) STORED,
    category_id uuid,
    tags text[] DEFAULT '{}'::text[],
    description text,
    description_rich jsonb,
    notes_internal text,
    base_price numeric(12,4) DEFAULT 0 NOT NULL,
    currency character varying(3) DEFAULT 'USD'::character varying NOT NULL,
    cost_price numeric(12,4),
    compare_at_price numeric(12,4),
    tax_category character varying(50),
    pricing_rules jsonb DEFAULT '[]'::jsonb,
    duration_minutes integer,
    buffer_before_minutes integer DEFAULT 0,
    buffer_after_minutes integer DEFAULT 0,
    min_advance_booking_hours integer,
    max_advance_booking_days integer,
    requires_resource boolean DEFAULT false,
    allowed_resource_types text[],
    weight_kg numeric(10,4),
    dimensions_cm jsonb,
    volume_liters numeric(10,4),
    min_stock_level integer,
    max_stock_level integer,
    lead_time_days integer,
    shelf_life_days integer,
    is_active boolean DEFAULT true NOT NULL,
    is_published boolean DEFAULT true NOT NULL,
    available_from timestamp with time zone,
    available_until timestamp with time zone,
    image_url text,
    gallery_urls text[] DEFAULT '{}'::text[],
    video_url text,
    embedding extensions.vector(1536),
    embedding_text text,
    ai_generated_description text,
    ai_keywords text[],
    ai_sentiment_score numeric(3,2),
    search_boost numeric(3,2) DEFAULT 1.0,
    vertical_config jsonb DEFAULT '{}'::jsonb,
    attributes jsonb DEFAULT '{}'::jsonb,
    custom_fields jsonb DEFAULT '{}'::jsonb,
    created_at timestamp with time zone DEFAULT now() NOT NULL,
    updated_at timestamp with time zone DEFAULT now() NOT NULL,
    deleted_at timestamp with time zone,
    created_by uuid,
    updated_by uuid,
    version integer DEFAULT 1 NOT NULL,
    has_embedding boolean DEFAULT false,
    search_vector tsvector,
    requires_appointment boolean DEFAULT true,
    requires_assessment boolean DEFAULT false,
    CONSTRAINT catalog_items_name_check CHECK ((length(TRIM(BOTH FROM name)) >= 2)),
    CONSTRAINT catalog_items_price_positive CHECK ((base_price >= (0)::numeric)),
    CONSTRAINT catalog_items_service_duration CHECK ((((item_type)::text <> 'service'::text) OR (duration_minutes IS NOT NULL))),
    CONSTRAINT catalog_items_stock_levels CHECK ((((item_type)::text <> ALL ((ARRAY['product'::character varying, 'consumable'::character varying])::text[])) OR ((min_stock_level IS NULL) OR (min_stock_level >= 0))))
);


--
-- Name: TABLE catalog_items; Type: COMMENT; Schema: public; Owner: -
--

COMMENT ON TABLE public.catalog_items IS 'Unified catalog for products, services, bundles, and subscriptions';


--
-- Name: catalog_items_embedding_content(public.catalog_items); Type: FUNCTION; Schema: public; Owner: -
--

CREATE FUNCTION public.catalog_items_embedding_content(item public.catalog_items) RETURNS text
    LANGUAGE plpgsql STABLE SECURITY DEFINER
    AS $$
DECLARE
    v_org_name text;
    v_vertical_code text;
    v_item_type_name text;
    v_category_path text;
    v_skill_names text;
    v_content_parts text[];
BEGIN
    -- Get organization and vertical info
    SELECT
        o.name,
        COALESCE(ov.code, 'other')
    INTO
        v_org_name,
        v_vertical_code
    FROM organizations o
    LEFT JOIN organization_verticals ov ON ov.id = o.vertical_id
    WHERE o.id = item.organization_id;

    -- Get item type name (display_name)
    BEGIN
        SELECT display_name INTO v_item_type_name
        FROM catalog_item_types
        WHERE code = item.item_type;
    EXCEPTION WHEN undefined_table THEN
        v_item_type_name := item.item_type;
    END;

    -- Get category hierarchy path
    SELECT string_agg(c2.name, ' > ' ORDER BY c2.path)
    INTO v_category_path
    FROM catalog_categories c1
    JOIN catalog_categories c2 ON c1.path <@ c2.path OR c1.id = c2.id
    WHERE c1.id = item.category_id;

    -- Get required skills for this item (min_proficiency, no deleted_at)
    SELECT string_agg(sd.display_name || ' (level ' || isr.min_proficiency || ')', ', ')
    INTO v_skill_names
    FROM item_skill_requirements isr
    JOIN skill_definitions sd ON sd.id = isr.skill_id
    WHERE isr.item_id = item.id;

    -- Build content parts
    v_content_parts := ARRAY[format('[VERTICAL: %s | %s]', v_vertical_code, v_org_name)];

    -- Item type and name
    v_content_parts := array_append(v_content_parts,
        format('%s: %s', COALESCE(v_item_type_name, item.item_type), item.name)
    );

    -- Item code
    IF item.item_code IS NOT NULL THEN
        v_content_parts := array_append(v_content_parts, format('Code: %s', item.item_code));
    END IF;

    -- Description
    IF item.description IS NOT NULL AND item.description != '' THEN
        v_content_parts := array_append(v_content_parts,
            format('Description: %s', item.description)
        );
    END IF;

    -- Category path
    IF v_category_path IS NOT NULL THEN
        v_content_parts := array_append(v_content_parts,
            format('Category: %s', v_category_path)
        );
    END IF;

    -- Tags
    IF item.tags IS NOT NULL AND array_length(item.tags, 1) > 0 THEN
        v_content_parts := array_append(v_content_parts,
            format('Tags: %s', array_to_string(item.tags, ', '))
        );
    END IF;

    -- Pricing
    IF item.base_price IS NOT NULL THEN
        v_content_parts := array_append(v_content_parts,
            format('Price: %s %s', item.base_price, COALESCE(item.currency, 'USD'))
        );
    END IF;

    -- Duration for services
    IF item.duration_minutes IS NOT NULL THEN
        v_content_parts := array_append(v_content_parts,
            format('Duration: %s minutes', item.duration_minutes)
        );
    END IF;

    -- Required skills
    IF v_skill_names IS NOT NULL THEN
        v_content_parts := array_append(v_content_parts,
            format('Required Skills: %s', v_skill_names)
        );
    END IF;

    -- Status
    v_content_parts := array_append(v_content_parts,
        format('Active: %s | Published: %s', item.is_active, item.is_published)
    );

    RETURN array_to_string(v_content_parts, ' | ');
END;
$$;


--
-- Name: FUNCTION catalog_items_embedding_content(item public.catalog_items); Type: COMMENT; Schema: public; Owner: -
--

COMMENT ON FUNCTION public.catalog_items_embedding_content(item public.catalog_items) IS 'Generates rich content for catalog item embeddings including category hierarchy, skills, and attributes';


--
-- Name: catalog_items_embedding_content_wrapper(uuid); Type: FUNCTION; Schema: public; Owner: -
--

CREATE FUNCTION public.catalog_items_embedding_content_wrapper(p_id uuid) RETURNS text
    LANGUAGE sql STABLE SECURITY DEFINER
    SET search_path TO 'public'
    AS $$
  SELECT catalog_items_embedding_content(c) FROM catalog_items c WHERE c.id = p_id;
$$;


--
-- Name: catalog_items_search_vector_trigger(); Type: FUNCTION; Schema: public; Owner: -
--

CREATE FUNCTION public.catalog_items_search_vector_trigger() RETURNS trigger
    LANGUAGE plpgsql
    AS $$
BEGIN
    NEW.search_vector := (
        setweight(to_tsvector('spanish', COALESCE(NEW.name, '')), 'A') ||
        setweight(to_tsvector('spanish', COALESCE(NEW.display_name, '')), 'A') ||
        setweight(to_tsvector('spanish', COALESCE(NEW.description, '')), 'B') ||
        setweight(to_tsvector('spanish', COALESCE(NEW.ai_generated_description, '')), 'B') ||
        setweight(to_tsvector('spanish', COALESCE(array_to_string(NEW.tags, ' '), '')), 'C') ||
        setweight(to_tsvector('spanish', COALESCE(NEW.attributes->>'keywords', '')), 'C')
    );
    RETURN NEW;
END;
$$;


--
-- Name: catalog_items_update_embedding_text(); Type: FUNCTION; Schema: public; Owner: -
--

CREATE FUNCTION public.catalog_items_update_embedding_text() RETURNS trigger
    LANGUAGE plpgsql
    AS $$
BEGIN
    NEW.embedding_text := NEW.name || ' ' || COALESCE(NEW.description, '') || ' ' ||
                          COALESCE(array_to_string(NEW.tags, ' '), '');
    RETURN NEW;
END;
$$;


--
-- Name: check_document_uniqueness(uuid, text, text, uuid); Type: FUNCTION; Schema: public; Owner: -
--

CREATE FUNCTION public.check_document_uniqueness(p_organization_id uuid, p_document_type text, p_document_number text, p_exclude_entity_id uuid DEFAULT NULL::uuid) RETURNS jsonb
    LANGUAGE plpgsql SECURITY DEFINER
    SET search_path TO 'public'
    AS $$
DECLARE
    v_normalized TEXT;
    v_existing RECORD;
    v_subtype TEXT;
BEGIN
    v_normalized := upper(regexp_replace(p_document_number, '[-\s]', '', 'g'));

    IF p_organization_id IS NULL OR length(v_normalized) < 5 THEN
        RETURN jsonb_build_object('unique', true, 'message', null);
    END IF;

    SELECT d.id as document_id, d.entity_id, d.document_type,
           e.display_name, e.person_subtype::text as subtype
    INTO v_existing
    FROM entity_identification_documents d
    JOIN entities e ON e.id = d.entity_id
    WHERE d.organization_id = p_organization_id
      AND d.document_number_normalized = v_normalized
      AND d.deleted_at IS NULL
      AND (p_exclude_entity_id IS NULL OR d.entity_id != p_exclude_entity_id)
    LIMIT 1;

    IF v_existing IS NULL THEN
        RETURN jsonb_build_object('unique', true, 'message', null);
    END IF;

    v_subtype := COALESCE(v_existing.subtype, 'entity');

    RETURN jsonb_build_object(
        'unique', false,
        'entity_id', v_existing.entity_id,
        'document_id', v_existing.document_id,
        'display_name', v_existing.display_name,
        'person_subtype', v_subtype,
        'message', CASE v_subtype
            WHEN 'patient' THEN 'Documento registrado para paciente: ' || v_existing.display_name
            WHEN 'client' THEN 'Documento registrado para cliente: ' || v_existing.display_name
            WHEN 'employee' THEN 'Documento registrado para empleado: ' || v_existing.display_name
            WHEN 'supplier' THEN 'Documento registrado para proveedor: ' || v_existing.display_name
            ELSE 'Documento registrado para: ' || v_existing.display_name
        END
    );
END;
$$;


--
-- Name: check_insurance_policy_uniqueness(uuid, text, text, uuid); Type: FUNCTION; Schema: public; Owner: -
--

CREATE FUNCTION public.check_insurance_policy_uniqueness(p_organization_id uuid, p_provider_code text, p_policy_number text, p_exclude_patient_id uuid DEFAULT NULL::uuid) RETURNS jsonb
    LANGUAGE plpgsql SECURITY DEFINER
    SET search_path TO 'public'
    AS $$
DECLARE
    v_clean_number TEXT;
    v_existing_patient RECORD;
BEGIN
    -- Clean the policy number (remove spaces and dashes)
    v_clean_number := regexp_replace(p_policy_number, '[\s\-]', '', 'g');
    
    -- Validate inputs
    IF p_organization_id IS NULL THEN
        RETURN jsonb_build_object(
            'unique', true,
            'message', null
        );
    END IF;
    
    IF v_clean_number IS NULL OR length(v_clean_number) < 3 THEN
        RETURN jsonb_build_object(
            'unique', true,
            'message', null
        );
    END IF;
    
    -- Search in patients table for matching policy
    SELECT 
        p.id,
        p.first_name,
        p.last_name,
        p.patient_code,
        policy
    INTO v_existing_patient
    FROM patients p,
         jsonb_array_elements(COALESCE(p.insurance_policies, '[]'::jsonb)) AS policy
    WHERE p.organization_id = p_organization_id
      AND p.deleted_at IS NULL
      AND (
          -- Match provider code AND policy number
          (policy->>'provider_code' = p_provider_code OR policy->>'provider_code' IS NULL)
          AND regexp_replace(policy->>'policy_number', '[\s\-]', '', 'g') = v_clean_number
      )
      -- Exclude current patient when editing
      AND (p_exclude_patient_id IS NULL OR p.id != p_exclude_patient_id)
    LIMIT 1;
    
    IF v_existing_patient IS NULL THEN
        -- Policy is unique
        RETURN jsonb_build_object(
            'unique', true,
            'message', null
        );
    END IF;
    
    -- Policy already exists - build informative message
    RETURN jsonb_build_object(
        'unique', false,
        'patient_id', v_existing_patient.id,
        'patient_code', v_existing_patient.patient_code,
        'patient_name', TRIM(COALESCE(v_existing_patient.first_name, '') || ' ' || COALESCE(v_existing_patient.last_name, '')),
        'message', 'Póliza registrada: ' || 
            TRIM(COALESCE(v_existing_patient.first_name, '') || ' ' || COALESCE(v_existing_patient.last_name, '')) ||
            CASE 
                WHEN v_existing_patient.patient_code IS NOT NULL 
                THEN ' (' || v_existing_patient.patient_code || ')'
                ELSE ''
            END
    );
END;
$$;


--
-- Name: FUNCTION check_insurance_policy_uniqueness(p_organization_id uuid, p_provider_code text, p_policy_number text, p_exclude_patient_id uuid); Type: COMMENT; Schema: public; Owner: -
--

COMMENT ON FUNCTION public.check_insurance_policy_uniqueness(p_organization_id uuid, p_provider_code text, p_policy_number text, p_exclude_patient_id uuid) IS 'Checks if an insurance policy number already exists for another patient
within the specified organization. Used for real-time validation in forms.

Parameters:
  - p_organization_id: The organization to search within
  - p_provider_code: Insurance provider code (e.g., ''senasa'', ''ars_humano'')
  - p_policy_number: The policy/carnet number to check
  - p_exclude_patient_id: Optional patient ID to exclude (for edit mode)

Returns JSONB:
  - unique: boolean - true if policy doesn''t exist for another patient
  - message: string - Human-readable message if duplicate found
  - patient_id: uuid - ID of existing patient if duplicate
  - patient_code: string - Code of existing patient if duplicate
  - patient_name: string - Name of existing patient if duplicate

Example:
  SELECT check_insurance_policy_uniqueness(
    ''org-uuid'',
    ''senasa'',
    ''123456789'',
    null
  );
';


--
-- Name: check_insurance_uniqueness(uuid, text, text, uuid); Type: FUNCTION; Schema: public; Owner: -
--

CREATE FUNCTION public.check_insurance_uniqueness(p_organization_id uuid, p_provider_code text, p_policy_number text, p_exclude_entity_id uuid DEFAULT NULL::uuid) RETURNS jsonb
    LANGUAGE plpgsql SECURITY DEFINER
    SET search_path TO 'public'
    AS $$
DECLARE
    v_normalized TEXT;
    v_existing RECORD;
BEGIN
    v_normalized := upper(regexp_replace(p_policy_number, '[-\s]', '', 'g'));

    IF p_organization_id IS NULL OR length(v_normalized) < 3 THEN
        RETURN jsonb_build_object('unique', true, 'message', null);
    END IF;

    SELECT i.id as policy_id, i.entity_id, i.provider_name,
           e.display_name, e.person_subtype
    INTO v_existing
    FROM entity_insurance_policies i
    JOIN entities e ON e.id = i.entity_id
    WHERE i.organization_id = p_organization_id
      AND i.provider_code = p_provider_code
      AND i.policy_number_normalized = v_normalized
      AND i.deleted_at IS NULL
      AND (p_exclude_entity_id IS NULL OR i.entity_id != p_exclude_entity_id)
    LIMIT 1;

    IF v_existing IS NULL THEN
        RETURN jsonb_build_object('unique', true, 'message', null);
    END IF;

    RETURN jsonb_build_object(
        'unique', false,
        'entity_id', v_existing.entity_id,
        'policy_id', v_existing.policy_id,
        'display_name', v_existing.display_name,
        'provider_name', v_existing.provider_name,
        'message', 'Póliza ' || p_policy_number || ' de ' || COALESCE(v_existing.provider_name, p_provider_code)
                   || ' ya registrada para: ' || v_existing.display_name
    );
END;
$$;


--
-- Name: classify_by_signals(text, uuid, double precision); Type: FUNCTION; Schema: public; Owner: -
--

CREATE FUNCTION public.classify_by_signals(p_text text, p_organization_id uuid DEFAULT NULL::uuid, p_min_score double precision DEFAULT 0.5) RETURNS TABLE(intent text, score double precision, confidence text, matched_signals jsonb)
    LANGUAGE plpgsql STABLE
    AS $$
BEGIN
  RETURN QUERY
  SELECT
    s.intent,
    s.score,
    CASE
      WHEN s.score >= 3.0 THEN 'high'
      WHEN s.score >= 1.5 THEN 'medium'
      ELSE 'low'
    END::TEXT as confidence,
    s.matched_signals
  FROM score_intents_by_signals(p_text, p_organization_id) s
  WHERE s.score >= p_min_score
    AND s.has_required = true
    AND s.has_negative = false
  ORDER BY s.score DESC
  LIMIT 1;
END;
$$;


--
-- Name: classify_intent(extensions.vector, uuid, integer, double precision); Type: FUNCTION; Schema: public; Owner: -
--

CREATE FUNCTION public.classify_intent(p_embedding extensions.vector, p_organization_id uuid DEFAULT NULL::uuid, p_top_k integer DEFAULT 5, p_min_similarity double precision DEFAULT 0.75) RETURNS TABLE(intent text, confidence double precision, match_count integer, top_example text)
    LANGUAGE plpgsql STABLE
    AS $$
BEGIN
  RETURN QUERY
  WITH matches AS (
    SELECT
      e.intent,
      e.example_text,
      1 - (e.embedding <=> p_embedding) as similarity
    FROM nlu_intent_examples e
    WHERE e.is_active = true
      AND e.embedding IS NOT NULL
      AND (e.organization_id IS NULL OR e.organization_id = p_organization_id)
      AND 1 - (e.embedding <=> p_embedding) >= p_min_similarity
    ORDER BY e.embedding <=> p_embedding
    LIMIT p_top_k
  ),
  intent_votes AS (
    SELECT
      m.intent,
      COUNT(*) as vote_count,
      AVG(m.similarity) as avg_similarity,
      MAX(m.similarity) as max_similarity,
      (ARRAY_AGG(m.example_text ORDER BY m.similarity DESC))[1] as best_example
    FROM matches m
    GROUP BY m.intent
  )
  SELECT
    iv.intent,
    iv.max_similarity as confidence,
    iv.vote_count::INT as match_count,
    iv.best_example as top_example
  FROM intent_votes iv
  ORDER BY iv.vote_count DESC, iv.max_similarity DESC
  LIMIT 1;
END;
$$;


--
-- Name: cleanup_expired_booking_sessions(); Type: FUNCTION; Schema: public; Owner: -
--

CREATE FUNCTION public.cleanup_expired_booking_sessions() RETURNS void
    LANGUAGE sql
    AS $$
    UPDATE booking_sessions 
    SET status = 'expired' 
    WHERE status = 'pending' AND expires_at < now();
$$;


--
-- Name: cleanup_expired_cache(); Type: FUNCTION; Schema: public; Owner: -
--

CREATE FUNCTION public.cleanup_expired_cache() RETURNS integer
    LANGUAGE plpgsql SECURITY DEFINER
    AS $$
DECLARE
    deleted_count integer;
BEGIN
    DELETE FROM public.ai_cache
    WHERE expires_at IS NOT NULL
      AND expires_at < NOW();

    GET DIAGNOSTICS deleted_count = ROW_COUNT;

    RETURN deleted_count;
END;
$$;


--
-- Name: FUNCTION cleanup_expired_cache(); Type: COMMENT; Schema: public; Owner: -
--

COMMENT ON FUNCTION public.cleanup_expired_cache() IS 'Clean up expired AI cache entries. Run this periodically via pg_cron.';


--
-- Name: cleanup_expired_conversation_flows(); Type: FUNCTION; Schema: public; Owner: -
--

CREATE FUNCTION public.cleanup_expired_conversation_flows() RETURNS integer
    LANGUAGE plpgsql SECURITY DEFINER
    SET search_path TO 'public'
    AS $$
DECLARE
    v_count int;
BEGIN
    WITH expired AS (
        UPDATE conversation_flow_states
        SET status = 'timeout', completed_at = now()
        WHERE status = 'active' AND expires_at < now()
        RETURNING id
    )
    SELECT count(*) INTO v_count FROM expired;
    
    RETURN v_count;
END;
$$;


--
-- Name: cleanup_expired_sessions(); Type: FUNCTION; Schema: public; Owner: -
--

CREATE FUNCTION public.cleanup_expired_sessions() RETURNS integer
    LANGUAGE plpgsql SECURITY DEFINER
    AS $$
DECLARE
    deleted_count INTEGER;
BEGIN
    WITH updated AS (
        UPDATE conversation_sessions
        SET status = 'expired', closed_at = NOW()
        WHERE status = 'active' AND expires_at < NOW()
        RETURNING id
    )
    SELECT COUNT(*) INTO deleted_count FROM updated;
    
    -- Also cleanup expired flow runtimes
    UPDATE conversation_flow_runtime
    SET status = 'timeout'
    WHERE status IN ('active', 'awaiting_input', 'awaiting_confirmation')
    AND expires_at < NOW();
    
    RETURN deleted_count;
END;
$$;


--
-- Name: FUNCTION cleanup_expired_sessions(); Type: COMMENT; Schema: public; Owner: -
--

COMMENT ON FUNCTION public.cleanup_expired_sessions() IS 'Marks expired conversation sessions and flow runtimes';


--
-- Name: clear_expired_conversation_states(); Type: FUNCTION; Schema: public; Owner: -
--

CREATE FUNCTION public.clear_expired_conversation_states() RETURNS integer
    LANGUAGE plpgsql SECURITY DEFINER
    AS $$
DECLARE
  cleared_count INTEGER;
BEGIN
  WITH cleared AS (
    UPDATE whatsapp_conversations
    SET conversation_state = '{}'::jsonb
    WHERE 
      conversation_state IS NOT NULL
      AND conversation_state != '{}'::jsonb
      AND (conversation_state->>'expires_at')::timestamp < NOW()
    RETURNING id
  )
  SELECT COUNT(*) INTO cleared_count FROM cleared;
  
  RETURN cleared_count;
END;
$$;


--
-- Name: FUNCTION clear_expired_conversation_states(); Type: COMMENT; Schema: public; Owner: -
--

COMMENT ON FUNCTION public.clear_expired_conversation_states() IS 'Clears conversation states that have expired (default 15 minutes)';


--
-- Name: clear_pending_action(uuid); Type: FUNCTION; Schema: public; Owner: -
--

CREATE FUNCTION public.clear_pending_action(p_conversation_id uuid) RETURNS void
    LANGUAGE plpgsql
    AS $$
BEGIN
  UPDATE whatsapp_conversations
  SET pending_action = NULL
  WHERE id = p_conversation_id;
END;
$$;


--
-- Name: close_inactive_conversations(); Type: FUNCTION; Schema: public; Owner: -
--

CREATE FUNCTION public.close_inactive_conversations() RETURNS integer
    LANGUAGE plpgsql
    AS $$
DECLARE
  v_closed_count INTEGER;
BEGIN
  UPDATE whatsapp_conversations
  SET 
    conversation_state = 'abandoned',
    updated_at = now()
  WHERE conversation_state = 'active'
    AND last_message_at < now() - INTERVAL '24 hours'
    AND deleted_at IS NULL;
  
  GET DIAGNOSTICS v_closed_count = ROW_COUNT;
  
  RAISE NOTICE 'Closed % inactive WhatsApp conversations', v_closed_count;
  RETURN v_closed_count;
END;
$$;


--
-- Name: FUNCTION close_inactive_conversations(); Type: COMMENT; Schema: public; Owner: -
--

COMMENT ON FUNCTION public.close_inactive_conversations() IS 'Maintenance function to mark conversations as abandoned after 24h inactivity';


--
-- Name: complete_conversation_flow(uuid, character varying); Type: FUNCTION; Schema: public; Owner: -
--

CREATE FUNCTION public.complete_conversation_flow(p_state_id uuid, p_status character varying DEFAULT 'completed'::character varying) RETURNS void
    LANGUAGE plpgsql SECURITY DEFINER
    SET search_path TO 'public'
    AS $$
BEGIN
    UPDATE conversation_flow_states
    SET 
        status = p_status,
        completed_at = now()
    WHERE id = p_state_id;
END;
$$;


--
-- Name: complete_skill_execution(uuid, public.skill_execution_status, jsonb, text, text, text, integer, integer); Type: FUNCTION; Schema: public; Owner: -
--

CREATE FUNCTION public.complete_skill_execution(p_execution_id uuid, p_status public.skill_execution_status, p_output_result jsonb DEFAULT NULL::jsonb, p_reasoning text DEFAULT NULL::text, p_error_message text DEFAULT NULL::text, p_error_code text DEFAULT NULL::text, p_latency_ms integer DEFAULT NULL::integer, p_tokens_used integer DEFAULT NULL::integer) RETURNS void
    LANGUAGE plpgsql
    AS $$
BEGIN
  UPDATE ai_skill_executions
  SET
    status = p_status,
    output_result = COALESCE(p_output_result, output_result),
    reasoning = COALESCE(p_reasoning, reasoning),
    error_message = p_error_message,
    error_code = p_error_code,
    latency_ms = p_latency_ms,
    tokens_used = p_tokens_used,
    completed_at = now()
  WHERE id = p_execution_id;
END;
$$;


--
-- Name: correct_nlu_typos(text, text[], uuid); Type: FUNCTION; Schema: public; Owner: -
--

CREATE FUNCTION public.correct_nlu_typos(p_text text, p_categories text[] DEFAULT ARRAY['appointment'::text, 'service'::text, 'provider'::text, 'general'::text, 'abbreviation'::text], p_organization_id uuid DEFAULT NULL::uuid) RETURNS TABLE(corrected_text text, corrections_made jsonb)
    LANGUAGE plpgsql STABLE
    AS $$
DECLARE
  result_text TEXT;
  corrections JSONB := '[]'::jsonb;
  rec RECORD;
BEGIN
  result_text := lower(trim(p_text));

  -- Apply corrections in order of typo length (longer first to avoid partial replacements)
  FOR rec IN
    SELECT t.typo, t.correction, t.category
    FROM nlu_typo_corrections t
    WHERE t.is_active = true
      AND t.category = ANY(p_categories)
      AND (t.organization_id IS NULL OR t.organization_id = p_organization_id)
      AND result_text LIKE '%' || t.typo || '%'
    ORDER BY length(t.typo) DESC
  LOOP
    -- Check if typo exists (word boundary aware for short typos)
    IF length(rec.typo) <= 3 THEN
      -- Use word boundary for short typos to avoid false positives
      IF result_text ~ ('\y' || rec.typo || '\y') THEN
        result_text := regexp_replace(result_text, '\y' || rec.typo || '\y', rec.correction, 'g');
        corrections := corrections || jsonb_build_object(
          'from', rec.typo,
          'to', rec.correction,
          'category', rec.category
        );
      END IF;
    ELSE
      -- Direct replacement for longer typos
      result_text := replace(result_text, rec.typo, rec.correction);
      corrections := corrections || jsonb_build_object(
        'from', rec.typo,
        'to', rec.correction,
        'category', rec.category
      );
    END IF;
  END LOOP;

  RETURN QUERY SELECT result_text, corrections;
END;
$$;


--
-- Name: create_bidirectional_relationship(uuid, uuid, uuid, public.entity_relationship_type, date, date, jsonb); Type: FUNCTION; Schema: public; Owner: -
--

CREATE FUNCTION public.create_bidirectional_relationship(p_organization_id uuid, p_entity_1_id uuid, p_entity_2_id uuid, p_relationship_type public.entity_relationship_type, p_valid_from date DEFAULT CURRENT_DATE, p_valid_until date DEFAULT NULL::date, p_custom_fields jsonb DEFAULT '{}'::jsonb) RETURNS TABLE(relationship_1_id uuid, relationship_2_id uuid)
    LANGUAGE plpgsql SECURITY DEFINER
    AS $$
DECLARE
    v_rel_1_id uuid;
    v_rel_2_id uuid;
BEGIN
    -- Create relationship from entity_1 to entity_2
    INSERT INTO entity_relationships (
        organization_id,
        entity_from_id,
        entity_to_id,
        relationship_type,
        status,
        valid_from,
        valid_until,
        custom_fields,
        created_by
    ) VALUES (
        p_organization_id,
        p_entity_1_id,
        p_entity_2_id,
        p_relationship_type,
        'active',
        p_valid_from,
        p_valid_until,
        p_custom_fields,
        auth.uid()
    )
    RETURNING id INTO v_rel_1_id;

    -- Create reverse relationship from entity_2 to entity_1
    INSERT INTO entity_relationships (
        organization_id,
        entity_from_id,
        entity_to_id,
        relationship_type,
        status,
        valid_from,
        valid_until,
        custom_fields,
        created_by
    ) VALUES (
        p_organization_id,
        p_entity_2_id,
        p_entity_1_id,
        p_relationship_type,
        'active',
        p_valid_from,
        p_valid_until,
        p_custom_fields,
        auth.uid()
    )
    RETURNING id INTO v_rel_2_id;

    RETURN QUERY SELECT v_rel_1_id, v_rel_2_id;
END;
$$;


--
-- Name: FUNCTION create_bidirectional_relationship(p_organization_id uuid, p_entity_1_id uuid, p_entity_2_id uuid, p_relationship_type public.entity_relationship_type, p_valid_from date, p_valid_until date, p_custom_fields jsonb); Type: COMMENT; Schema: public; Owner: -
--

COMMENT ON FUNCTION public.create_bidirectional_relationship(p_organization_id uuid, p_entity_1_id uuid, p_entity_2_id uuid, p_relationship_type public.entity_relationship_type, p_valid_from date, p_valid_until date, p_custom_fields jsonb) IS 'Create symmetric bidirectional relationship (e.g., spouse, sibling, colleague).
Returns IDs of both relationship records.';


--
-- Name: create_client_from_chat(uuid, text, text, text, public.client_source, jsonb); Type: FUNCTION; Schema: public; Owner: -
--

CREATE FUNCTION public.create_client_from_chat(p_organization_id uuid, p_display_name text, p_phone text, p_email text DEFAULT NULL::text, p_source public.client_source DEFAULT 'whatsapp'::public.client_source, p_vertical_fields jsonb DEFAULT '{}'::jsonb) RETURNS TABLE(entity_id uuid, client_id uuid, display_name text, is_new boolean)
    LANGUAGE plpgsql SECURITY DEFINER
    AS $$
DECLARE
    v_entity_id uuid;
    v_client_id uuid;
    v_entity_code text;
    v_normalized_phone text;
BEGIN
    -- Normalize phone
    v_normalized_phone := regexp_replace(p_phone, '[^0-9]', '', 'g');

    -- Check if entity already exists by phone
    SELECT e.id INTO v_entity_id
    FROM entities e
    WHERE e.organization_id = p_organization_id
      AND e.entity_type = 'person'
      AND e.status = 'active'
      AND e.deleted_at IS NULL
      AND (
          regexp_replace(COALESCE(e.phone, ''), '[^0-9]', '', 'g') = v_normalized_phone
          OR regexp_replace(COALESCE(e.mobile, ''), '[^0-9]', '', 'g') = v_normalized_phone
      );

    IF v_entity_id IS NOT NULL THEN
        -- Entity exists, check if client record exists
        SELECT c.id INTO v_client_id
        FROM clients c
        WHERE c.entity_id = v_entity_id;

        IF v_client_id IS NOT NULL THEN
            -- Both exist, return existing
            RETURN QUERY SELECT v_entity_id, v_client_id, p_display_name, false;
            RETURN;
        END IF;
    ELSE
        -- Create new entity
        v_entity_code := 'CLI-' || to_char(now(), 'YYYYMMDD') || '-' || substr(gen_random_uuid()::text, 1, 4);

        INSERT INTO entities (
            organization_id,
            entity_code,
            display_name,
            entity_type,
            person_subtype,
            phone,
            mobile,
            email,
            status,
            created_at,
            updated_at
        ) VALUES (
            p_organization_id,
            v_entity_code,
            p_display_name,
            'person',
            'client',
            p_phone,
            p_phone,  -- Also set as mobile
            p_email,
            'active',
            now(),
            now()
        )
        RETURNING id INTO v_entity_id;
    END IF;

    -- Create client record
    INSERT INTO clients (
        entity_id,
        organization_id,
        source,
        first_visit_date,
        category,
        vertical_fields,
        created_at,
        updated_at
    ) VALUES (
        v_entity_id,
        p_organization_id,
        p_source,
        CURRENT_DATE,
        'new',
        p_vertical_fields,
        now(),
        now()
    )
    RETURNING id INTO v_client_id;

    RETURN QUERY SELECT v_entity_id, v_client_id, p_display_name, true;
END;
$$;


--
-- Name: FUNCTION create_client_from_chat(p_organization_id uuid, p_display_name text, p_phone text, p_email text, p_source public.client_source, p_vertical_fields jsonb); Type: COMMENT; Schema: public; Owner: -
--

COMMENT ON FUNCTION public.create_client_from_chat(p_organization_id uuid, p_display_name text, p_phone text, p_email text, p_source public.client_source, p_vertical_fields jsonb) IS 'Creates a new client from chat interaction (entity + client record)';


--
-- Name: create_default_organization_templates(); Type: FUNCTION; Schema: public; Owner: -
--

CREATE FUNCTION public.create_default_organization_templates() RETURNS trigger
    LANGUAGE plpgsql
    AS $$
BEGIN
  -- =========================================================================
  -- DEFAULT SHIFT TEMPLATES
  -- =========================================================================
  
  INSERT INTO shift_templates (organization_id, code, name, description, shift_type, start_time, end_time, is_overnight, color, is_active)
  VALUES 
    (NEW.id, 'DIA', 'Turno Diurno', 'Turno estándar de día (8:00 AM - 5:00 PM)', 'regular', '08:00', '17:00', false, '#4CAF50', true),
    (NEW.id, 'MAT', 'Turno Matutino', 'Turno de mañana (6:00 AM - 2:00 PM)', 'regular', '06:00', '14:00', false, '#2196F3', true),
    (NEW.id, 'VES', 'Turno Vespertino', 'Turno de tarde (2:00 PM - 10:00 PM)', 'regular', '14:00', '22:00', false, '#FF9800', true),
    (NEW.id, 'NOC', 'Turno Nocturno', 'Turno de noche (10:00 PM - 6:00 AM)', 'regular', '22:00', '06:00', true, '#673AB7', true),
    (NEW.id, 'MT', 'Medio Tiempo', 'Turno de medio tiempo (4 horas)', 'regular', '08:00', '12:00', false, '#9E9E9E', true),
    (NEW.id, 'R12', 'Rotativo 12 Horas', 'Turno rotativo de 12 horas', 'regular', '07:00', '19:00', false, '#E91E63', true);

  -- =========================================================================
  -- DEFAULT WORK POLICIES (Ley 16-92 RD Compliant)
  -- =========================================================================
  
  INSERT INTO work_policies (
    organization_id, name, description, policy_type, is_default, is_active,
    standard_hours_per_week, max_hours_per_day, max_hours_per_week,
    overtime_rate, overtime_method,
    night_shift_premium, night_shift_start, night_shift_end,
    min_break_minutes, paid_break,
    max_consecutive_days, min_rest_hours_between_shifts
  ) VALUES 
    (NEW.id, 'Política Estándar RD', 'Política laboral estándar según Ley 16-92', 'standard', true, true,
     44.0, 10.0, 66.0, 1.35, 'weekly', 0.15, '21:00', '07:00', 60, false, 6, 12),
    (NEW.id, 'Política Comercio', 'Política para establecimientos comerciales', 'flexible', false, true,
     44.0, 12.0, 60.0, 1.35, 'daily', 0.15, '21:00', '07:00', 30, false, 6, 11),
    (NEW.id, 'Política Salud', 'Política para centros de salud con turnos rotativos', 'shift_based', false, true,
     44.0, 16.0, 60.0, 1.50, 'weekly', 0.25, '19:00', '07:00', 45, true, 4, 8);

  RETURN NEW;
END;
$$;


--
-- Name: create_organization_with_membership(text, text, text, text, text, text, text, text, text, text, text, uuid); Type: FUNCTION; Schema: public; Owner: -
--

CREATE FUNCTION public.create_organization_with_membership(p_name text, p_email text DEFAULT NULL::text, p_phone text DEFAULT NULL::text, p_tax_id text DEFAULT NULL::text, p_rnc text DEFAULT NULL::text, p_industry text DEFAULT NULL::text, p_address_line1 text DEFAULT NULL::text, p_city text DEFAULT NULL::text, p_country text DEFAULT 'DO'::text, p_plan_key text DEFAULT 'free'::text, p_vertical_code text DEFAULT 'general'::text, p_owner_user_id uuid DEFAULT NULL::uuid) RETURNS jsonb
    LANGUAGE plpgsql SECURITY DEFINER
    SET search_path TO 'public'
    AS $$
DECLARE
    v_org_id UUID;
    v_membership_id UUID;
    v_subscription_id UUID;
    v_owner_id UUID;
    v_plan subscription_plans%ROWTYPE;
    v_trial_ends_at TIMESTAMPTZ;
    v_period_end TIMESTAMPTZ;
    v_custom_fields JSONB;
BEGIN
    -- Determine owner: passed param or current user
    v_owner_id := COALESCE(p_owner_user_id, auth.uid());
    
    IF v_owner_id IS NULL THEN
        RETURN jsonb_build_object(
            'success', false,
            'error', 'No user specified and not authenticated'
        );
    END IF;

    -- Validate plan exists
    SELECT * INTO v_plan FROM subscription_plans WHERE key = p_plan_key AND is_active = true;
    IF NOT FOUND THEN
        RETURN jsonb_build_object(
            'success', false,
            'error', 'Invalid or inactive plan: ' || p_plan_key
        );
    END IF;

    -- Calculate trial/period dates
    IF v_plan.trial_days > 0 THEN
        v_trial_ends_at := NOW() + (v_plan.trial_days || ' days')::INTERVAL;
        v_period_end := v_trial_ends_at;
    ELSE
        v_trial_ends_at := NULL;
        v_period_end := NOW() + INTERVAL '1 year';
    END IF;

    -- Build custom_fields JSONB with contact info
    v_custom_fields := jsonb_build_object(
        'email', p_email,
        'phone', p_phone,
        'address_line1', p_address_line1,
        'city', p_city,
        'country', p_country,
        'industry', p_industry
    );

    -- 1. Create Organization (using actual columns)
    INSERT INTO organizations (
        name,
        tax_id,
        vertical_code,
        custom_fields,
        created_by,
        updated_by
    ) VALUES (
        p_name,
        COALESCE(p_tax_id, p_rnc),
        p_vertical_code,
        v_custom_fields,
        v_owner_id,
        v_owner_id
    )
    RETURNING id INTO v_org_id;

    -- 2. Create Owner Membership
    INSERT INTO memberships (
        organization_id,
        user_id,
        role_key,
        status,
        created_by
    ) VALUES (
        v_org_id,
        v_owner_id,
        'owner',
        'active',
        v_owner_id
    )
    RETURNING id INTO v_membership_id;

    -- 3. Create Subscription
    INSERT INTO subscriptions (
        organization_id,
        plan_key,
        status,
        trial_ends_at,
        current_period_start,
        current_period_end
    ) VALUES (
        v_org_id,
        p_plan_key,
        CASE WHEN v_plan.trial_days > 0 THEN 'trial' ELSE 'active' END,
        v_trial_ends_at,
        NOW(),
        v_period_end
    )
    RETURNING id INTO v_subscription_id;

    -- 4. Set as active organization in user_sessions
    INSERT INTO user_sessions (user_id, active_org_id, last_activity_at)
    VALUES (v_owner_id, v_org_id, NOW())
    ON CONFLICT (user_id) DO UPDATE 
    SET active_org_id = v_org_id, 
        last_activity_at = NOW(),
        updated_at = NOW();

    -- Return success response
    RETURN jsonb_build_object(
        'success', true,
        'organization_id', v_org_id,
        'membership_id', v_membership_id,
        'subscription_id', v_subscription_id,
        'plan_key', p_plan_key,
        'status', CASE WHEN v_plan.trial_days > 0 THEN 'trial' ELSE 'active' END,
        'trial_ends_at', v_trial_ends_at
    );

EXCEPTION WHEN OTHERS THEN
    RETURN jsonb_build_object(
        'success', false,
        'error', SQLERRM,
        'detail', SQLSTATE
    );
END;
$$;


--
-- Name: current_org_id(); Type: FUNCTION; Schema: public; Owner: -
--

CREATE FUNCTION public.current_org_id() RETURNS uuid
    LANGUAGE sql STABLE
    AS $$
    SELECT (current_setting('request.jwt.claims', true)::jsonb->>'organization_id')::uuid;
$$;


--
-- Name: current_user_id(); Type: FUNCTION; Schema: public; Owner: -
--

CREATE FUNCTION public.current_user_id() RETURNS uuid
    LANGUAGE sql STABLE
    AS $$
    SELECT (current_setting('request.jwt.claims', true)::jsonb->>'sub')::uuid;
$$;


--
-- Name: employees; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.employees (
    id uuid DEFAULT gen_random_uuid() NOT NULL,
    entity_id uuid NOT NULL,
    organization_id uuid NOT NULL,
    employee_code character varying(50),
    hire_date date NOT NULL,
    termination_date date,
    employment_status public.employment_status_enum DEFAULT 'active'::public.employment_status_enum NOT NULL,
    employment_type public.employment_type_enum DEFAULT 'full_time'::public.employment_type_enum NOT NULL,
    "position" text,
    department character varying(100),
    division character varying(100),
    work_location text,
    reports_to_employee_id uuid,
    salary numeric(15,2),
    salary_currency character varying(3) DEFAULT 'DOP'::character varying,
    salary_period public.salary_period_enum DEFAULT 'monthly'::public.salary_period_enum,
    commission_rate numeric(5,2),
    bonus_eligible boolean DEFAULT false,
    standard_hours_per_week numeric(4,1) DEFAULT 40.0,
    overtime_eligible boolean DEFAULT true,
    vacation_days_per_year numeric(4,1) DEFAULT 15.0,
    vacation_days_accrued numeric(5,2) DEFAULT 0,
    sick_days_per_year numeric(4,1) DEFAULT 10.0,
    sick_days_used numeric(5,2) DEFAULT 0,
    health_insurance_plan character varying(100),
    life_insurance_amount numeric(12,2),
    retirement_plan_enrolled boolean DEFAULT false,
    bank_name character varying(100),
    bank_account_number text,
    payment_method public.payment_method_enum DEFAULT 'bank_transfer'::public.payment_method_enum,
    tax_id character varying(50),
    social_security_number text,
    work_permit_number character varying(100),
    work_permit_expiry date,
    emergency_contact_name text,
    emergency_contact_relationship character varying(50),
    emergency_contact_phone character varying(50),
    education_level character varying(100),
    certifications text[],
    licenses text[],
    languages_spoken text[],
    last_review_date date,
    next_review_date date,
    performance_rating character varying(20),
    notes text,
    document_ids uuid[],
    hr_data jsonb DEFAULT '{}'::jsonb,
    preferences jsonb DEFAULT '{}'::jsonb,
    custom_fields jsonb DEFAULT '{}'::jsonb,
    salary_history jsonb DEFAULT '[]'::jsonb,
    position_history jsonb DEFAULT '[]'::jsonb,
    leave_history jsonb DEFAULT '[]'::jsonb,
    disciplinary_history jsonb DEFAULT '[]'::jsonb,
    created_at timestamp with time zone DEFAULT now() NOT NULL,
    updated_at timestamp with time zone DEFAULT now() NOT NULL,
    created_by uuid,
    updated_by uuid,
    deleted_at timestamp with time zone,
    deleted_by uuid,
    skills jsonb DEFAULT '{}'::jsonb,
    ai_features jsonb DEFAULT '{}'::jsonb,
    analytics_snapshot jsonb DEFAULT '{}'::jsonb,
    embedding extensions.vector(1536),
    has_embedding boolean DEFAULT false,
    job_id uuid,
    department_id uuid,
    position_id uuid,
    work_schedule jsonb DEFAULT '{}'::jsonb,
    commission_structure jsonb DEFAULT '{}'::jsonb,
    vertical_data jsonb DEFAULT '{}'::jsonb,
    gender public.gender_enum,
    marital_status public.marital_status,
    nationality text,
    bank_account_type text,
    general_notes text,
    internal_notes text,
    pay_frequency text DEFAULT 'monthly'::text,
    termination_reason text,
    probation_end_date date,
    manager_id uuid,
    source text,
    referral_source text,
    metadata jsonb DEFAULT '{}'::jsonb,
    tags text[] DEFAULT '{}'::text[],
    ai_insights jsonb DEFAULT '{}'::jsonb,
    ai_performance_metrics jsonb DEFAULT '{}'::jsonb,
    addresses jsonb DEFAULT '[]'::jsonb,
    emails jsonb DEFAULT '[]'::jsonb,
    phones jsonb DEFAULT '[]'::jsonb,
    date_of_birth date,
    photo_url text,
    first_name text,
    last_name text,
    middle_name text,
    CONSTRAINT chk_commission_rate_range CHECK (((commission_rate IS NULL) OR ((commission_rate >= (0)::numeric) AND (commission_rate <= (100)::numeric)))),
    CONSTRAINT chk_currency_code CHECK ((length((salary_currency)::text) = 3)),
    CONSTRAINT chk_employee_code_length CHECK ((length(TRIM(BOTH FROM employee_code)) >= 2)),
    CONSTRAINT chk_hire_before_termination CHECK (((termination_date IS NULL) OR (termination_date >= hire_date))),
    CONSTRAINT chk_hours_per_week_positive CHECK ((standard_hours_per_week > (0)::numeric)),
    CONSTRAINT chk_performance_rating CHECK (((performance_rating IS NULL) OR ((performance_rating)::text = ANY ((ARRAY['excellent'::character varying, 'very_good'::character varying, 'good'::character varying, 'satisfactory'::character varying, 'needs_improvement'::character varying, 'unsatisfactory'::character varying])::text[])))),
    CONSTRAINT chk_salary_positive CHECK (((salary IS NULL) OR (salary > (0)::numeric))),
    CONSTRAINT chk_sick_days_positive CHECK ((sick_days_per_year >= (0)::numeric)),
    CONSTRAINT chk_terminated_status CHECK ((((termination_date IS NULL) AND (employment_status <> ALL (ARRAY['terminated'::public.employment_status_enum, 'resigned'::public.employment_status_enum, 'retired'::public.employment_status_enum, 'deceased'::public.employment_status_enum]))) OR ((termination_date IS NOT NULL) AND (employment_status = ANY (ARRAY['terminated'::public.employment_status_enum, 'resigned'::public.employment_status_enum, 'retired'::public.employment_status_enum, 'deceased'::public.employment_status_enum]))))),
    CONSTRAINT chk_vacation_days_positive CHECK ((vacation_days_per_year >= (0)::numeric))
);


--
-- Name: TABLE employees; Type: COMMENT; Schema: public; Owner: -
--

COMMENT ON TABLE public.employees IS 'Employees table - specializes entities for employee records with comprehensive HR/ERP features';


--
-- Name: COLUMN employees.entity_id; Type: COMMENT; Schema: public; Owner: -
--

COMMENT ON COLUMN public.employees.entity_id IS 'Foreign key to entities table - one employee per entity';


--
-- Name: COLUMN employees.employee_code; Type: COMMENT; Schema: public; Owner: -
--

COMMENT ON COLUMN public.employees.employee_code IS 'Internal employee number unique per organization';


--
-- Name: COLUMN employees.reports_to_employee_id; Type: COMMENT; Schema: public; Owner: -
--

COMMENT ON COLUMN public.employees.reports_to_employee_id IS 'Manager/supervisor employee ID - creates reporting hierarchy';


--
-- Name: COLUMN employees.hr_data; Type: COMMENT; Schema: public; Owner: -
--

COMMENT ON COLUMN public.employees.hr_data IS 'Industry-specific HR data (certifications, specialties, etc.) in JSONB format';


--
-- Name: COLUMN employees.salary_history; Type: COMMENT; Schema: public; Owner: -
--

COMMENT ON COLUMN public.employees.salary_history IS 'Array of salary changes with dates, reasons, and approvals';


--
-- Name: COLUMN employees.position_history; Type: COMMENT; Schema: public; Owner: -
--

COMMENT ON COLUMN public.employees.position_history IS 'Array of position/department changes over time';


--
-- Name: COLUMN employees.leave_history; Type: COMMENT; Schema: public; Owner: -
--

COMMENT ON COLUMN public.employees.leave_history IS 'Array of leave records (vacation, sick, unpaid, etc.)';


--
-- Name: COLUMN employees.skills; Type: COMMENT; Schema: public; Owner: -
--

COMMENT ON COLUMN public.employees.skills IS 'Technical and soft skills with proficiency levels - enables talent matching, skill gap analysis, and team composition optimization';


--
-- Name: COLUMN employees.ai_features; Type: COMMENT; Schema: public; Owner: -
--

COMMENT ON COLUMN public.employees.ai_features IS 'Pre-calculated AI features: embeddings, scores, predictions, recommendations - critical for ML/AI without recalculating';


--
-- Name: COLUMN employees.analytics_snapshot; Type: COMMENT; Schema: public; Owner: -
--

COMMENT ON COLUMN public.employees.analytics_snapshot IS 'Aggregated KPIs and metrics snapshot - enables fast dashboards and executive reporting without complex joins';


--
-- Name: COLUMN employees.work_schedule; Type: COMMENT; Schema: public; Owner: -
--

COMMENT ON COLUMN public.employees.work_schedule IS 'JSONB with schedule type, weekly hours, overtime rules, and booking config';


--
-- Name: COLUMN employees.commission_structure; Type: COMMENT; Schema: public; Owner: -
--

COMMENT ON COLUMN public.employees.commission_structure IS 'JSONB with commission tiers, rates, and calculation rules';


--
-- Name: COLUMN employees.vertical_data; Type: COMMENT; Schema: public; Owner: -
--

COMMENT ON COLUMN public.employees.vertical_data IS 'JSONB with vertical-specific data (clinical, salon, legal, etc.)';


--
-- Name: employees_embedding_content(public.employees); Type: FUNCTION; Schema: public; Owner: -
--

CREATE FUNCTION public.employees_embedding_content(e public.employees) RETURNS text
    LANGUAGE plpgsql STABLE SECURITY DEFINER
    AS $$
DECLARE
  v_org_name text;
  v_vertical_code text;
  v_entity_name text;
  v_email text;
  v_phone text;
  v_content_parts text[];
BEGIN
  -- Get organization and vertical info
  SELECT o.name, COALESCE(ov.code, 'other'), ent.display_name, ent.email, ent.phone
  INTO v_org_name, v_vertical_code, v_entity_name, v_email, v_phone
  FROM organizations o
  LEFT JOIN organization_verticals ov ON ov.id = o.vertical_id
  LEFT JOIN entities ent ON ent.id = e.entity_id
  WHERE o.id = e.organization_id;

  v_content_parts := ARRAY[format('[VERTICAL: %s | %s]', v_vertical_code, v_org_name)];
  v_content_parts := array_append(v_content_parts, format('Employee: %s', v_entity_name));
  
  IF v_email IS NOT NULL THEN
    v_content_parts := array_append(v_content_parts, format('Email: %s', v_email));
  END IF;
  IF v_phone IS NOT NULL THEN
    v_content_parts := array_append(v_content_parts, format('Phone: %s', v_phone));
  END IF;
  IF e.position IS NOT NULL THEN
    v_content_parts := array_append(v_content_parts, format('Position: %s', e.position));
  END IF;
  IF e.department IS NOT NULL THEN
    v_content_parts := array_append(v_content_parts, format('Department: %s', e.department));
  END IF;
  
  v_content_parts := array_append(v_content_parts, format('Status: %s', e.employment_status::text));
  
  IF e.skills IS NOT NULL AND e.skills != '{}'::jsonb THEN
    v_content_parts := array_append(v_content_parts, format('Skills: %s', e.skills::text));
  END IF;
  IF e.hire_date IS NOT NULL THEN
    v_content_parts := array_append(v_content_parts, format('Hired: %s', e.hire_date::text));
  END IF;
  
  RETURN array_to_string(v_content_parts, ' | ');
END;
$$;


--
-- Name: employees_embedding_content_wrapper(uuid); Type: FUNCTION; Schema: public; Owner: -
--

CREATE FUNCTION public.employees_embedding_content_wrapper(p_id uuid) RETURNS text
    LANGUAGE sql STABLE SECURITY DEFINER
    SET search_path TO 'public'
    AS $$
  SELECT employees_embedding_content(e) FROM employees e WHERE e.id = p_id;
$$;


--
-- Name: ensure_single_primary_document(); Type: FUNCTION; Schema: public; Owner: -
--

CREATE FUNCTION public.ensure_single_primary_document() RETURNS trigger
    LANGUAGE plpgsql
    AS $$
BEGIN
    IF NEW.is_primary = true THEN
        UPDATE entity_identification_documents
        SET is_primary = false, updated_at = now()
        WHERE entity_id = NEW.entity_id AND document_type = NEW.document_type
          AND id != NEW.id AND is_primary = true AND deleted_at IS NULL;
    END IF;
    RETURN NEW;
END;
$$;


--
-- Name: ensure_single_primary_insurance(); Type: FUNCTION; Schema: public; Owner: -
--

CREATE FUNCTION public.ensure_single_primary_insurance() RETURNS trigger
    LANGUAGE plpgsql
    AS $$
BEGIN
    IF NEW.is_primary = true THEN
        UPDATE entity_insurance_policies
        SET is_primary = false, updated_at = now()
        WHERE entity_id = NEW.entity_id AND policy_type = NEW.policy_type
          AND id != NEW.id AND is_primary = true AND deleted_at IS NULL;
    END IF;
    RETURN NEW;
END;
$$;


--
-- Name: entities; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.entities (
    id uuid DEFAULT gen_random_uuid() NOT NULL,
    organization_id uuid NOT NULL,
    entity_code character varying(50) NOT NULL,
    display_name text NOT NULL,
    legal_name text,
    entity_type public.entity_type NOT NULL,
    person_subtype public.person_subtype,
    organization_subtype public.organization_subtype,
    email character varying(255),
    phone character varying(50),
    mobile character varying(50),
    address text,
    city character varying(100),
    state character varying(100),
    postal_code character varying(20),
    country character varying(100) DEFAULT 'Dominican Republic'::character varying,
    tax_id character varying(50),
    registration_number character varying(50),
    status public.entity_status DEFAULT 'active'::public.entity_status NOT NULL,
    notes text,
    custom_fields jsonb DEFAULT '{}'::jsonb,
    created_at timestamp with time zone DEFAULT timezone('utc'::text, now()) NOT NULL,
    updated_at timestamp with time zone DEFAULT timezone('utc'::text, now()) NOT NULL,
    created_by uuid,
    updated_by uuid,
    deleted_at timestamp with time zone,
    embedding extensions.vector(1536),
    has_embedding boolean DEFAULT false,
    CONSTRAINT entities_display_name_check CHECK ((length(TRIM(BOTH FROM display_name)) >= 2)),
    CONSTRAINT entities_email_format CHECK ((((email)::text ~* '^[A-Za-z0-9._%+-]+@[A-Za-z0-9.-]+\.[A-Za-z]{2,}$'::text) OR (email IS NULL))),
    CONSTRAINT entities_type_subtype_check CHECK ((((entity_type = 'person'::public.entity_type) AND (person_subtype IS NOT NULL) AND (organization_subtype IS NULL)) OR ((entity_type = 'organization'::public.entity_type) AND (organization_subtype IS NOT NULL) AND (person_subtype IS NULL))))
);


--
-- Name: TABLE entities; Type: COMMENT; Schema: public; Owner: -
--

COMMENT ON TABLE public.entities IS 'Universal entity table - supports both persons and organizations in a multi-tenant context';


--
-- Name: COLUMN entities.entity_code; Type: COMMENT; Schema: public; Owner: -
--

COMMENT ON COLUMN public.entities.entity_code IS 'Unique code within organization (e.g., PAT-001, DOC-123, CUS-456)';


--
-- Name: COLUMN entities.entity_type; Type: COMMENT; Schema: public; Owner: -
--

COMMENT ON COLUMN public.entities.entity_type IS 'Discriminator: person or organization';


--
-- Name: COLUMN entities.person_subtype; Type: COMMENT; Schema: public; Owner: -
--

COMMENT ON COLUMN public.entities.person_subtype IS 'Subtype when entity_type = person';


--
-- Name: COLUMN entities.organization_subtype; Type: COMMENT; Schema: public; Owner: -
--

COMMENT ON COLUMN public.entities.organization_subtype IS 'Subtype when entity_type = organization';


--
-- Name: entities_embedding_content(public.entities); Type: FUNCTION; Schema: public; Owner: -
--

CREATE FUNCTION public.entities_embedding_content(ent public.entities) RETURNS text
    LANGUAGE plpgsql STABLE SECURITY DEFINER
    AS $$
DECLARE
  v_org_name text;
  v_vertical_code text;
  v_content_parts text[];
BEGIN
  SELECT o.name, COALESCE(ov.code, 'other')
  INTO v_org_name, v_vertical_code
  FROM organizations o
  LEFT JOIN organization_verticals ov ON ov.id = o.vertical_id
  WHERE o.id = ent.organization_id;

  v_content_parts := ARRAY[format('[VERTICAL: %s | %s]', v_vertical_code, COALESCE(v_org_name, 'Unknown'))];
  v_content_parts := array_append(v_content_parts, format('Entity: %s (%s)', ent.display_name, ent.entity_type::text));
  
  IF ent.email IS NOT NULL THEN
    v_content_parts := array_append(v_content_parts, format('Email: %s', ent.email));
  END IF;
  IF ent.phone IS NOT NULL THEN
    v_content_parts := array_append(v_content_parts, format('Phone: %s', ent.phone));
  END IF;
  IF ent.address_line1 IS NOT NULL THEN
    v_content_parts := array_append(v_content_parts, 
      format('Address: %s %s %s', 
        COALESCE(ent.address_line1, ''), 
        COALESCE(ent.city, ''), 
        COALESCE(ent.country, '')
      )
    );
  END IF;
  
  RETURN array_to_string(v_content_parts, ' | ');
END;
$$;


--
-- Name: entities_embedding_content_wrapper(uuid); Type: FUNCTION; Schema: public; Owner: -
--

CREATE FUNCTION public.entities_embedding_content_wrapper(p_id uuid) RETURNS text
    LANGUAGE sql STABLE SECURITY DEFINER
    SET search_path TO 'public'
    AS $$
  SELECT 
    format('[VERTICAL: %s | %s] | Entity: %s (%s)%s%s',
      COALESCE(ov.code, 'other'),
      COALESCE(o.name, 'Unknown'),
      ent.display_name,
      ent.entity_type::text,
      CASE WHEN ent.email IS NOT NULL THEN ' | Email: ' || ent.email ELSE '' END,
      CASE WHEN ent.phone IS NOT NULL THEN ' | Phone: ' || ent.phone ELSE '' END
    )
  FROM entities ent
  LEFT JOIN organizations o ON o.id = ent.organization_id
  LEFT JOIN organization_verticals ov ON ov.id = o.vertical_id
  WHERE ent.id = p_id;
$$;


--
-- Name: estimate_walkin_wait_time(uuid, integer); Type: FUNCTION; Schema: public; Owner: -
--

CREATE FUNCTION public.estimate_walkin_wait_time(p_location_id uuid, p_service_duration_minutes integer) RETURNS integer
    LANGUAGE plpgsql SECURITY DEFINER
    AS $$
DECLARE
  waiting_count INTEGER;
  estimated_wait INTEGER;
BEGIN
  SELECT COUNT(*) INTO waiting_count
  FROM walkin_entries WHERE location_id = p_location_id AND status = 'waiting';
  estimated_wait := (waiting_count * COALESCE(p_service_duration_minutes, 30)) / 2;
  RETURN estimated_wait;
END;
$$;


--
-- Name: export_nlu_training_data(uuid, real, boolean, integer); Type: FUNCTION; Schema: public; Owner: -
--

CREATE FUNCTION public.export_nlu_training_data(p_organization_id uuid DEFAULT NULL::uuid, p_min_confidence real DEFAULT 0.7, p_only_reviewed boolean DEFAULT false, p_limit integer DEFAULT 10000) RETURNS TABLE(text text, intent character varying, slots jsonb, confidence real, is_corrected boolean)
    LANGUAGE plpgsql
    AS $$
BEGIN
    RETURN QUERY
    SELECT
        t.input_text AS text,
        COALESCE(t.corrected_intent, t.extracted_intent) AS intent,
        COALESCE(t.corrected_slots, t.extracted_slots) AS slots,
        t.extracted_confidence AS confidence,
        (t.corrected_intent IS NOT NULL) AS is_corrected
    FROM nlu_training_logs t
    WHERE
        (p_organization_id IS NULL OR t.organization_id = p_organization_id)
        AND t.extracted_confidence >= p_min_confidence
        AND (NOT p_only_reviewed OR t.reviewed)
    ORDER BY
        (t.corrected_intent IS NOT NULL) DESC,
        t.extracted_confidence DESC
    LIMIT p_limit;
END;
$$;


--
-- Name: find_cross_channel_context(uuid, text, uuid, integer); Type: FUNCTION; Schema: public; Owner: -
--

CREATE FUNCTION public.find_cross_channel_context(p_organization_id uuid, p_phone_number text DEFAULT NULL::text, p_user_id uuid DEFAULT NULL::uuid, p_max_age_days integer DEFAULT 7) RETURNS TABLE(conversation_id uuid, channel text, summary text, collected_slots jsonb, last_intent text, last_message_at timestamp with time zone)
    LANGUAGE plpgsql SECURITY DEFINER
    AS $$
DECLARE
  v_cutoff TIMESTAMP WITH TIME ZONE;
BEGIN
  v_cutoff := NOW() - (p_max_age_days || ' days')::INTERVAL;

  RETURN QUERY
  SELECT
    c.id AS conversation_id,
    c.channel,
    c.summary,
    c.collected_slots,
    c.last_intent,
    c.last_message_at
  FROM ai_conversations c
  WHERE c.organization_id = p_organization_id
    AND c.last_message_at > v_cutoff
    AND (
      (p_phone_number IS NOT NULL AND c.phone_number = p_phone_number)
      OR (p_user_id IS NOT NULL AND c.user_id = p_user_id)
    )
  ORDER BY c.last_message_at DESC
  LIMIT 5;
END;
$$;


--
-- Name: FUNCTION find_cross_channel_context(p_organization_id uuid, p_phone_number text, p_user_id uuid, p_max_age_days integer); Type: COMMENT; Schema: public; Owner: -
--

COMMENT ON FUNCTION public.find_cross_channel_context(p_organization_id uuid, p_phone_number text, p_user_id uuid, p_max_age_days integer) IS 'Finds related conversations across different channels for the same user/phone.';


--
-- Name: waitlist_entries; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.waitlist_entries (
    id uuid DEFAULT gen_random_uuid() NOT NULL,
    organization_id uuid NOT NULL,
    client_entity_id uuid,
    client_name character varying(255) NOT NULL,
    client_phone character varying(50),
    client_email character varying(255),
    location_id uuid,
    service_id uuid,
    service_name character varying(255) NOT NULL,
    preferred_resource_id uuid,
    preferred_resource_name character varying(255),
    requested_date date NOT NULL,
    time_preference public.time_preference DEFAULT 'anytime'::public.time_preference NOT NULL,
    preferred_time_start time without time zone,
    preferred_time_end time without time zone,
    preferred_days_of_week integer[],
    priority public.waitlist_priority DEFAULT 'first_in_line'::public.waitlist_priority NOT NULL,
    estimated_value numeric(10,2),
    added_at timestamp with time zone DEFAULT now() NOT NULL,
    expires_at timestamp with time zone,
    status public.waitlist_status DEFAULT 'waiting'::public.waitlist_status NOT NULL,
    notification_attempts integer DEFAULT 0 NOT NULL,
    last_notified_at timestamp with time zone,
    responded_at timestamp with time zone,
    response_timeout_hours integer DEFAULT 24 NOT NULL,
    notification_method public.notification_method DEFAULT 'all'::public.notification_method NOT NULL,
    booking_probability numeric(3,2),
    ai_recommended_slot character varying(255),
    ai_insights jsonb,
    converted_appointment_id uuid,
    converted_at timestamp with time zone,
    processed_by_staff_id uuid,
    notes text,
    created_by uuid,
    created_at timestamp with time zone DEFAULT now() NOT NULL,
    updated_at timestamp with time zone DEFAULT now() NOT NULL,
    CONSTRAINT valid_probability CHECK (((booking_probability IS NULL) OR ((booking_probability >= (0)::numeric) AND (booking_probability <= (1)::numeric)))),
    CONSTRAINT valid_time_range CHECK (((preferred_time_start IS NULL) OR (preferred_time_end IS NULL) OR (preferred_time_start < preferred_time_end)))
);


--
-- Name: find_matching_waitlist_entries(uuid, timestamp with time zone, timestamp with time zone, uuid, uuid, uuid, integer); Type: FUNCTION; Schema: public; Owner: -
--

CREATE FUNCTION public.find_matching_waitlist_entries(p_organization_id uuid, p_slot_start timestamp with time zone, p_slot_end timestamp with time zone, p_service_id uuid, p_resource_id uuid DEFAULT NULL::uuid, p_location_id uuid DEFAULT NULL::uuid, p_limit integer DEFAULT 10) RETURNS SETOF public.waitlist_entries
    LANGUAGE plpgsql SECURITY DEFINER
    AS $$
DECLARE
  slot_date DATE := p_slot_start::DATE;
  slot_time_start TIME := p_slot_start::TIME;
  slot_time_end TIME := p_slot_end::TIME;
  slot_dow INTEGER := EXTRACT(DOW FROM p_slot_start)::INTEGER;
  slot_hour INTEGER := EXTRACT(HOUR FROM p_slot_start)::INTEGER;
BEGIN
  RETURN QUERY
  SELECT w.*
  FROM waitlist_entries w
  WHERE w.organization_id = p_organization_id
    AND w.status = 'waiting'
    AND w.service_id = p_service_id
    AND w.requested_date = slot_date
    AND (
      w.time_preference = 'anytime'
      OR (w.time_preference = 'morning' AND slot_hour < 12)
      OR (w.time_preference = 'afternoon' AND slot_hour >= 12 AND slot_hour < 17)
      OR (w.time_preference = 'evening' AND slot_hour >= 17)
    )
    AND (w.preferred_time_start IS NULL OR slot_time_start >= w.preferred_time_start)
    AND (w.preferred_time_end IS NULL OR slot_time_end <= w.preferred_time_end)
    AND (w.preferred_days_of_week IS NULL OR slot_dow = ANY(w.preferred_days_of_week))
    AND (w.preferred_resource_id IS NULL OR p_resource_id IS NULL OR w.preferred_resource_id = p_resource_id)
    AND (w.location_id IS NULL OR p_location_id IS NULL OR w.location_id = p_location_id)
    AND (w.expires_at IS NULL OR w.expires_at > NOW())
  ORDER BY 
    CASE w.priority
      WHEN 'first_in_line' THEN 1
      WHEN 'highest_value' THEN 2
      WHEN 'ai_optimized' THEN 3
      WHEN 'staff_picks' THEN 4
    END,
    CASE WHEN w.priority = 'highest_value' THEN -COALESCE(w.estimated_value, 0) ELSE 0 END,
    w.added_at
  LIMIT p_limit;
END;
$$;


--
-- Name: find_qualified_providers(uuid, uuid, date, integer); Type: FUNCTION; Schema: public; Owner: -
--

CREATE FUNCTION public.find_qualified_providers(p_item_id uuid, p_organization_id uuid DEFAULT NULL::uuid, p_date date DEFAULT CURRENT_DATE, p_limit_count integer DEFAULT 10) RETURNS TABLE(provider_entity_id uuid, provider_name text, proficiency_level integer, is_fully_qualified boolean, missing_skills text[], custom_price numeric, custom_duration integer, is_available boolean)
    LANGUAGE plpgsql STABLE
    AS $$
BEGIN
    RETURN QUERY
    WITH item_requirements AS (
        -- Get all required skills for the item
        SELECT
            isr.skill_id,
            isr.min_proficiency,
            isr.is_required,
            sd.display_name AS skill_name
        FROM public.item_skill_requirements isr
        JOIN public.skill_definitions sd ON sd.id = isr.skill_id
        WHERE isr.item_id = p_item_id
    ),
    provider_qualifications AS (
        -- Check each provider's skills against requirements
        SELECT
            ip.provider_entity_id,
            e.display_name AS provider_name,
            ip.custom_price,
            ip.custom_duration_minutes,
            ip.is_available,
            ip.proficiency_level AS provider_proficiency,
            -- Check if provider meets all required skills
            NOT EXISTS (
                SELECT 1 FROM item_requirements ir
                WHERE ir.is_required = true
                AND NOT EXISTS (
                    SELECT 1 FROM public.provider_skills ps
                    WHERE ps.provider_entity_id = ip.provider_entity_id
                    AND ps.skill_id = ir.skill_id
                    AND ps.proficiency_level >= ir.min_proficiency
                    AND (ps.certification_expires_at IS NULL OR ps.certification_expires_at > p_date)
                )
            ) AS is_fully_qualified,
            -- List missing skills
            ARRAY(
                SELECT ir.skill_name FROM item_requirements ir
                WHERE ir.is_required = true
                AND NOT EXISTS (
                    SELECT 1 FROM public.provider_skills ps
                    WHERE ps.provider_entity_id = ip.provider_entity_id
                    AND ps.skill_id = ir.skill_id
                    AND ps.proficiency_level >= ir.min_proficiency
                )
            ) AS missing_skills
        FROM public.item_providers ip
        JOIN public.entities e ON e.id = ip.provider_entity_id
        WHERE ip.item_id = p_item_id
        AND ip.is_available = true
        AND (p_organization_id IS NULL OR ip.organization_id = p_organization_id)
    )
    SELECT
        pq.provider_entity_id,
        pq.provider_name,
        pq.provider_proficiency,
        pq.is_fully_qualified,
        pq.missing_skills,
        pq.custom_price,
        pq.custom_duration_minutes,
        pq.is_available
    FROM provider_qualifications pq
    ORDER BY
        pq.is_fully_qualified DESC,
        pq.provider_proficiency DESC,
        array_length(pq.missing_skills, 1) ASC NULLS FIRST
    LIMIT p_limit_count;
END;
$$;


--
-- Name: FUNCTION find_qualified_providers(p_item_id uuid, p_organization_id uuid, p_date date, p_limit_count integer); Type: COMMENT; Schema: public; Owner: -
--

COMMENT ON FUNCTION public.find_qualified_providers(p_item_id uuid, p_organization_id uuid, p_date date, p_limit_count integer) IS 'Find providers qualified to deliver a catalog item based on skill requirements';


--
-- Name: find_resources_for_catalog_item(uuid, uuid, integer, time without time zone, integer, jsonb, integer); Type: FUNCTION; Schema: public; Owner: -
--

CREATE FUNCTION public.find_resources_for_catalog_item(p_organization_id uuid, p_catalog_item_id uuid, p_check_day integer DEFAULT NULL::integer, p_check_time time without time zone DEFAULT NULL::time without time zone, p_min_proficiency_score integer DEFAULT NULL::integer, p_attributes_filter jsonb DEFAULT NULL::jsonb, p_limit integer DEFAULT 10) RETURNS TABLE(resource_entity_id uuid, resource_name text, capability_id uuid, custom_duration interval, custom_price numeric, currency_code character, proficiency_level public.proficiency_level, proficiency_score smallint, is_primary boolean, attributes jsonb)
    LANGUAGE plpgsql STABLE SECURITY DEFINER
    AS $$
BEGIN
  RETURN QUERY
  SELECT
    rc.resource_entity_id,
    e.display_name AS resource_name,
    rc.id AS capability_id,
    rc.custom_duration,
    rc.custom_price,
    rc.currency_code,
    rc.proficiency_level,
    rc.proficiency_score,
    rc.is_primary,
    rc.attributes
  FROM public.resource_capabilities rc
  JOIN public.entities e ON e.id = rc.resource_entity_id
  WHERE rc.organization_id = p_organization_id
    AND rc.catalog_item_id = p_catalog_item_id
    AND rc.is_active = true
    AND rc.deleted_at IS NULL
    AND e.deleted_at IS NULL
    AND rc.valid_from <= now()
    AND (rc.valid_until IS NULL OR rc.valid_until > now())
    -- Proficiency filter
    AND (p_min_proficiency_score IS NULL OR rc.proficiency_score >= p_min_proficiency_score)
    -- Attributes filter (JSONB containment)
    AND (p_attributes_filter IS NULL OR rc.attributes @> p_attributes_filter)
    -- Availability filter (if day/time specified)
    AND (
      (p_check_day IS NULL AND p_check_time IS NULL)
      OR NOT EXISTS(SELECT 1 FROM public.resource_capability_availability rca2 WHERE rca2.capability_id = rc.id AND rca2.is_active = true)
      OR EXISTS(
        SELECT 1
        FROM public.resource_capability_availability rca
        WHERE rca.capability_id = rc.id
          AND rca.is_active = true
          AND (p_check_day IS NULL OR p_check_day = ANY(rca.days_of_week))
          AND (p_check_time IS NULL OR (p_check_time >= rca.time_from AND p_check_time <= rca.time_until))
      )
    )
  ORDER BY
    rc.is_primary DESC,
    rc.proficiency_score DESC,
    e.display_name ASC
  LIMIT p_limit;
END;
$$;


--
-- Name: FUNCTION find_resources_for_catalog_item(p_organization_id uuid, p_catalog_item_id uuid, p_check_day integer, p_check_time time without time zone, p_min_proficiency_score integer, p_attributes_filter jsonb, p_limit integer); Type: COMMENT; Schema: public; Owner: -
--

COMMENT ON FUNCTION public.find_resources_for_catalog_item(p_organization_id uuid, p_catalog_item_id uuid, p_check_day integer, p_check_time time without time zone, p_min_proficiency_score integer, p_attributes_filter jsonb, p_limit integer) IS 'Find resources that can provide a catalog item, with filtering by proficiency and attributes.';


--
-- Name: format_whatsapp_message(uuid, text, text, jsonb); Type: FUNCTION; Schema: public; Owner: -
--

CREATE FUNCTION public.format_whatsapp_message(p_organization_id uuid, p_category text, p_message_key text, p_variables jsonb DEFAULT '{}'::jsonb) RETURNS jsonb
    LANGUAGE plpgsql STABLE SECURITY DEFINER
    AS $$
DECLARE
  config JSONB;
  message_text TEXT;
  formatted_text TEXT;
  emoji_mappings JSONB;
  emoji_key TEXT;
  emoji_value TEXT;
BEGIN
  -- Get org config
  config := get_whatsapp_config(p_organization_id);
  emoji_mappings := config->'emoji_mappings';

  -- Get message template
  message_text := get_bot_message(
    p_category,
    p_message_key,
    p_organization_id,
    'whatsapp',
    COALESCE(config->>'default_language', 'es'),
    p_variables
  );

  -- Fallback to default if not found
  IF message_text IS NULL THEN
    message_text := get_bot_message(p_category, p_message_key, NULL, 'whatsapp', 'es', p_variables);
  END IF;

  IF message_text IS NULL THEN
    message_text := get_bot_message(p_category, p_message_key, NULL, NULL, 'es', p_variables);
  END IF;

  formatted_text := message_text;

  -- Remove emojis if disabled
  IF NOT (config->>'use_emojis')::boolean AND formatted_text IS NOT NULL THEN
    -- Simple emoji removal (basic pattern)
    formatted_text := regexp_replace(formatted_text, '[\U0001F300-\U0001F9FF]', '', 'g');
  END IF;

  -- Remove formatting if disabled
  IF NOT (config->>'use_formatting')::boolean AND formatted_text IS NOT NULL THEN
    formatted_text := regexp_replace(formatted_text, '\*([^*]+)\*', '\1', 'g');  -- Remove bold
    formatted_text := regexp_replace(formatted_text, '_([^_]+)_', '\1', 'g');    -- Remove italic
  END IF;

  -- Add signature if configured
  IF config->>'message_signature' IS NOT NULL AND formatted_text IS NOT NULL THEN
    formatted_text := formatted_text || E'\n\n' || (config->>'message_signature');
  END IF;

  RETURN jsonb_build_object(
    'text', formatted_text,
    'use_buttons', (config->>'use_buttons')::boolean,
    'use_list_messages', (config->>'use_list_messages')::boolean,
    'max_inline_buttons', (config->>'max_inline_buttons')::int,
    'show_quick_replies', (config->>'show_quick_replies')::boolean
  );
END;
$$;


--
-- Name: FUNCTION format_whatsapp_message(p_organization_id uuid, p_category text, p_message_key text, p_variables jsonb); Type: COMMENT; Schema: public; Owner: -
--

COMMENT ON FUNCTION public.format_whatsapp_message(p_organization_id uuid, p_category text, p_message_key text, p_variables jsonb) IS 'Format a bot message according to org WhatsApp config';


--
-- Name: fuzzy_search_entities(uuid, text, text, integer, integer); Type: FUNCTION; Schema: public; Owner: -
--

CREATE FUNCTION public.fuzzy_search_entities(p_org_id uuid, p_domain text, p_search_term text, p_max_distance integer DEFAULT 3, p_limit integer DEFAULT 5) RETURNS TABLE(id uuid, entity_id uuid, name text, distance integer, similarity double precision, match_type text, domain text)
    LANGUAGE sql STABLE SECURITY DEFINER
    AS $$
    SELECT * FROM app.fuzzy_search_entities(p_org_id, p_domain, p_search_term, p_max_distance, p_limit);
$$;


--
-- Name: fuzzy_search_entity(text, uuid, text, integer); Type: FUNCTION; Schema: public; Owner: -
--

CREATE FUNCTION public.fuzzy_search_entity(p_search_term text, p_organization_id uuid, p_entity_type text DEFAULT 'person'::text, p_max_distance integer DEFAULT 2) RETURNS TABLE(id uuid, display_name text, phone text, email text, distance integer, match_type text)
    LANGUAGE plpgsql
    AS $$
BEGIN
    RETURN QUERY
    -- First try exact match on first name
    SELECT e.id, e.display_name::TEXT, e.phone::TEXT, e.email::TEXT, 0::INT as distance, 'exact'::TEXT as match_type
    FROM entities e
    WHERE e.organization_id = p_organization_id
      AND e.entity_type::TEXT = p_entity_type
      AND e.deleted_at IS NULL
      AND LOWER(SPLIT_PART(e.display_name, ' ', 1)) = LOWER(p_search_term)
    
    UNION ALL
    
    -- Then fuzzy match on first name with Levenshtein
    SELECT e.id, e.display_name::TEXT, e.phone::TEXT, e.email::TEXT, 
           levenshtein(LOWER(SPLIT_PART(e.display_name, ' ', 1)), LOWER(p_search_term)) as distance,
           'fuzzy'::TEXT as match_type
    FROM entities e
    WHERE e.organization_id = p_organization_id
      AND e.entity_type::TEXT = p_entity_type
      AND e.deleted_at IS NULL
      AND levenshtein(LOWER(SPLIT_PART(e.display_name, ' ', 1)), LOWER(p_search_term)) <= p_max_distance
      AND LOWER(SPLIT_PART(e.display_name, ' ', 1)) != LOWER(p_search_term)
    
    ORDER BY distance, display_name
    LIMIT 5;
END;
$$;


--
-- Name: generate_patient_code(uuid); Type: FUNCTION; Schema: public; Owner: -
--

CREATE FUNCTION public.generate_patient_code(p_organization_id uuid) RETURNS text
    LANGUAGE plpgsql SECURITY DEFINER
    SET search_path TO 'public'
    AS $$
DECLARE
  v_prefix text;
  v_sequence integer;
  v_year text;
  v_code text;
BEGIN
  -- Get current year
  v_year := to_char(now(), 'YYYY');

  -- Get or create sequence for this organization
  INSERT INTO patient_code_sequences (organization_id, current_sequence, prefix)
  VALUES (p_organization_id, 0, 'PAT')
  ON CONFLICT (organization_id) DO NOTHING;

  -- Increment and get sequence (atomic operation)
  UPDATE patient_code_sequences
  SET current_sequence = current_sequence + 1,
      updated_at = now()
  WHERE organization_id = p_organization_id
  RETURNING current_sequence, prefix INTO v_sequence, v_prefix;

  -- Generate code: PREFIX-YEAR-SEQUENCE (padded to 5 digits)
  v_code := format('%s-%s-%s', v_prefix, v_year, lpad(v_sequence::text, 5, '0'));

  RETURN v_code;
END;
$$;


--
-- Name: FUNCTION generate_patient_code(p_organization_id uuid); Type: COMMENT; Schema: public; Owner: -
--

COMMENT ON FUNCTION public.generate_patient_code(p_organization_id uuid) IS 'Generates unique patient code in format PREFIX-YEAR-SEQUENCE';


--
-- Name: generate_scheduled_shifts(uuid, date, date); Type: FUNCTION; Schema: public; Owner: -
--

CREATE FUNCTION public.generate_scheduled_shifts(p_employee_id uuid, p_start_date date, p_end_date date) RETURNS integer
    LANGUAGE plpgsql SECURITY DEFINER
    AS $$
DECLARE
    v_org_id UUID;
    v_dept_id UUID;
    v_schedule JSONB;
    v_current_date DATE;
    v_day_name TEXT;
    v_day_config JSONB;
    v_shift JSONB;
    v_count INTEGER := 0;
BEGIN
    -- Get employee info
    SELECT organization_id, department_id, work_schedule
    INTO v_org_id, v_dept_id, v_schedule
    FROM employees
    WHERE id = p_employee_id AND deleted_at IS NULL;

    IF v_schedule IS NULL OR v_schedule = '{}'::jsonb THEN
        RETURN 0;
    END IF;

    -- Loop through each date in range
    v_current_date := p_start_date;
    WHILE v_current_date <= p_end_date LOOP
        -- Get day name from date
        v_day_name := lower(to_char(v_current_date, 'day'));
        v_day_name := trim(v_day_name);  -- Remove trailing spaces

        -- Get config for this day
        v_day_config := v_schedule->'weekly_schedule'->v_day_name;

        -- Skip if no config or not working day
        IF v_day_config IS NULL OR (v_day_config->>'is_working_day')::boolean = false THEN
            v_current_date := v_current_date + INTERVAL '1 day';
            CONTINUE;
        END IF;

        -- Create shift for each shift block
        FOR v_shift IN SELECT * FROM jsonb_array_elements(v_day_config->'shifts')
        LOOP
            INSERT INTO scheduled_shifts (
                organization_id,
                employee_id,
                shift_date,
                start_time,
                end_time,
                breaks,
                department_id,
                status
            ) VALUES (
                v_org_id,
                p_employee_id,
                v_current_date,
                (v_shift->>'start')::TIME,
                (v_shift->>'end')::TIME,
                COALESCE(v_day_config->'breaks', '[]'::jsonb),
                v_dept_id,
                'scheduled'
            )
            ON CONFLICT (employee_id, shift_date, start_time) DO NOTHING;

            v_count := v_count + 1;
        END LOOP;

        v_current_date := v_current_date + INTERVAL '1 day';
    END LOOP;

    RETURN v_count;
END;
$$;


--
-- Name: FUNCTION generate_scheduled_shifts(p_employee_id uuid, p_start_date date, p_end_date date); Type: COMMENT; Schema: public; Owner: -
--

COMMENT ON FUNCTION public.generate_scheduled_shifts(p_employee_id uuid, p_start_date date, p_end_date date) IS 'Generates scheduled_shifts for a date range based on employee work_schedule';


--
-- Name: get_active_conversation_flow(uuid); Type: FUNCTION; Schema: public; Owner: -
--

CREATE FUNCTION public.get_active_conversation_flow(p_conversation_id uuid) RETURNS TABLE(state_id uuid, flow_id uuid, flow_name character varying, current_slot character varying, collected_slots jsonb, awaiting_confirmation boolean, slots_definition jsonb)
    LANGUAGE plpgsql SECURITY DEFINER
    SET search_path TO 'public'
    AS $$
BEGIN
    RETURN QUERY
    SELECT 
        cfs.id AS state_id,
        cfs.flow_id,
        cf.flow_name,
        cfs.current_slot,
        cfs.collected_slots,
        cfs.awaiting_confirmation,
        cf.slots AS slots_definition
    FROM conversation_flow_states cfs
    JOIN conversation_flows cf ON cfs.flow_id = cf.id
    WHERE cfs.conversation_id = p_conversation_id
      AND cfs.status = 'active'
      AND (cfs.expires_at IS NULL OR cfs.expires_at > now())
    ORDER BY cfs.started_at DESC
    LIMIT 1;
END;
$$;


--
-- Name: get_appointments_pending_reminder(integer, uuid); Type: FUNCTION; Schema: public; Owner: -
--

CREATE FUNCTION public.get_appointments_pending_reminder(p_hours_ahead integer DEFAULT 24, p_organization_id uuid DEFAULT NULL::uuid) RETURNS TABLE(appointment_id uuid, organization_id uuid, organization_name text, appointment_date date, start_time time without time zone, catalog_item_name text, client_id uuid, client_name text, client_phone text, client_email text, provider_id uuid, provider_name text, status text, reminder_message text)
    LANGUAGE plpgsql
    AS $$
BEGIN
    RETURN QUERY
    SELECT
        a.id AS appointment_id,
        a.organization_id,
        o.name::TEXT AS organization_name,
        a.appointment_date,
        a.start_time,
        a.catalog_item_name::TEXT,
        c.id AS client_id,
        c.display_name::TEXT AS client_name,
        c.phone::TEXT AS client_phone,
        c.email::TEXT AS client_email,
        r.id AS provider_id,
        r.display_name::TEXT AS provider_name,
        a.status::TEXT,
        format(
            E'¡Hola %s! 👋\n\nTe recordamos tu cita en *%s*:\n\n📅 *Fecha:* %s\n🕐 *Hora:* %s\n%s%s\n\n¿Confirmas tu asistencia?\nResponde *SÍ* para confirmar o *NO* si necesitas cancelar/reagendar.',
            c.display_name,
            o.name,
            TO_CHAR(a.appointment_date, 'DD/MM/YYYY'),
            TO_CHAR(a.start_time, 'HH24:MI'),
            CASE WHEN a.catalog_item_name IS NOT NULL 
                 THEN format(E'💈 *Servicio:* %s\n', a.catalog_item_name)
                 ELSE '' END,
            CASE WHEN r.display_name IS NOT NULL 
                 THEN format(E'👤 *Con:* %s', r.display_name)
                 ELSE '' END
        )::TEXT AS reminder_message
    FROM appointments a
    JOIN entities c ON a.client_entity_id = c.id
    LEFT JOIN entities r ON a.resource_entity_id = r.id
    JOIN organizations o ON a.organization_id = o.id
    WHERE 
        a.status IN ('pending', 'scheduled')
        AND a.reminder_sent_at IS NULL
        AND (a.appointment_date + a.start_time) BETWEEN NOW() AND NOW() + (p_hours_ahead || ' hours')::INTERVAL
        AND (p_organization_id IS NULL OR a.organization_id = p_organization_id)
        AND c.phone IS NOT NULL
    ORDER BY a.appointment_date, a.start_time;
END;
$$;


--
-- Name: get_available_skills(public.skill_category, boolean); Type: FUNCTION; Schema: public; Owner: -
--

CREATE FUNCTION public.get_available_skills(p_category public.skill_category DEFAULT NULL::public.skill_category, p_include_deprecated boolean DEFAULT false) RETURNS TABLE(id uuid, name text, description text, parameters jsonb, category public.skill_category, requires_approval boolean, success_rate numeric)
    LANGUAGE sql STABLE
    AS $$
  SELECT
    s.id,
    s.name,
    s.description,
    s.parameters,
    s.category,
    s.requires_approval,
    s.success_rate
  FROM ai_skills s
  WHERE s.enabled = true
    AND (p_category IS NULL OR s.category = p_category)
    AND (p_include_deprecated OR s.deprecated_at IS NULL)
  ORDER BY s.usage_count DESC, s.name;
$$;


--
-- Name: get_available_time_slots(uuid, uuid, date, integer, integer); Type: FUNCTION; Schema: public; Owner: -
--

CREATE FUNCTION public.get_available_time_slots(p_organization_id uuid, p_resource_entity_id uuid, p_date date, p_duration_minutes integer DEFAULT 30, p_buffer_minutes integer DEFAULT 0) RETURNS TABLE(slot_start time without time zone, slot_end time without time zone, is_available boolean)
    LANGUAGE plpgsql STABLE
    AS $$
DECLARE
    v_start_time time := '08:00:00'::time;
    v_end_time time := '18:00:00'::time;
    v_interval_minutes integer;
    v_current_slot time;
BEGIN
    v_interval_minutes := p_duration_minutes + p_buffer_minutes;
    IF v_interval_minutes < 1 THEN
        v_interval_minutes := 30;
    END IF;
    
    v_current_slot := v_start_time;
    
    WHILE v_current_slot + (p_duration_minutes || ' minutes')::interval <= v_end_time LOOP
        slot_start := v_current_slot;
        slot_end := v_current_slot + (p_duration_minutes || ' minutes')::interval;
        
        -- Check if this slot is available
        is_available := NOT EXISTS (
            SELECT 1
            FROM appointments a
            WHERE a.resource_entity_id = p_resource_entity_id
              AND a.appointment_date = p_date
              AND a.status IN ('scheduled', 'confirmed', 'in_progress')
              AND (a.start_time, a.end_time) OVERLAPS (slot_start, slot_end)
        );
        
        RETURN NEXT;
        
        v_current_slot := v_current_slot + (v_interval_minutes || ' minutes')::interval;
    END LOOP;
    
    RETURN;
END;
$$;


--
-- Name: get_billing_entity(uuid); Type: FUNCTION; Schema: public; Owner: -
--

CREATE FUNCTION public.get_billing_entity(p_entity_id uuid) RETURNS TABLE(billing_entity_id uuid, billing_name text, billing_email character varying, billing_phone character varying, billing_tax_id character varying, relationship_type public.entity_relationship_type)
    LANGUAGE plpgsql SECURITY DEFINER
    AS $$
BEGIN
    RETURN QUERY
    SELECT 
        bc.billing_entity_id,
        bc.billing_name,
        bc.billing_email,
        bc.billing_phone,
        bc.billing_tax_id,
        bc.relationship_type
    FROM v_billing_contacts bc
    WHERE bc.entity_id = p_entity_id
    ORDER BY bc.priority, bc.is_primary DESC
    LIMIT 1;
    
    -- If no billing contact found, return the entity itself
    IF NOT FOUND THEN
        RETURN QUERY
        SELECT 
            e.id,
            e.display_name,
            e.email,
            e.phone,
            e.tax_id,
            NULL::entity_relationship_type
        FROM entities e
        WHERE e.id = p_entity_id
        AND e.deleted_at IS NULL;
    END IF;
END;
$$;


--
-- Name: FUNCTION get_billing_entity(p_entity_id uuid); Type: COMMENT; Schema: public; Owner: -
--

COMMENT ON FUNCTION public.get_billing_entity(p_entity_id uuid) IS 'Returns the entity responsible for billing. Falls back to the entity itself if no billing contact exists.';


--
-- Name: get_bot_message(text, text, uuid, text, text, jsonb); Type: FUNCTION; Schema: public; Owner: -
--

CREATE FUNCTION public.get_bot_message(p_category text, p_message_key text, p_organization_id uuid DEFAULT NULL::uuid, p_channel text DEFAULT NULL::text, p_language text DEFAULT 'es'::text, p_variables jsonb DEFAULT '{}'::jsonb) RETURNS text
    LANGUAGE plpgsql STABLE
    AS $$
DECLARE
  msg_template TEXT;
  variations JSONB;
  result TEXT;
  var_key TEXT;
  var_value TEXT;
BEGIN
  -- Find message with fallback: org+channel > org > global+channel > global
  SELECT m.message_template, m.variations INTO msg_template, variations
  FROM bot_messages m
  WHERE m.is_active = true
    AND m.category = p_category
    AND m.message_key = p_message_key
    AND m.language = p_language
    AND (m.organization_id = p_organization_id OR m.organization_id IS NULL)
    AND (m.channel = p_channel OR m.channel IS NULL)
  ORDER BY
    CASE WHEN m.organization_id = p_organization_id THEN 0 ELSE 1 END,
    CASE WHEN m.channel = p_channel THEN 0 ELSE 1 END,
    m.priority DESC
  LIMIT 1;

  IF msg_template IS NULL THEN
    RETURN NULL;
  END IF;

  -- Optionally pick a random variation
  IF variations IS NOT NULL AND jsonb_array_length(variations) > 0 AND random() > 0.7 THEN
    msg_template := variations->>(floor(random() * jsonb_array_length(variations))::int);
  END IF;

  -- Replace variables
  result := msg_template;
  FOR var_key, var_value IN SELECT * FROM jsonb_each_text(p_variables)
  LOOP
    result := replace(result, '{' || var_key || '}', COALESCE(var_value, ''));
  END LOOP;

  RETURN result;
END;
$$;


--
-- Name: get_bot_messages_by_category(text, uuid, text, text); Type: FUNCTION; Schema: public; Owner: -
--

CREATE FUNCTION public.get_bot_messages_by_category(p_category text, p_organization_id uuid DEFAULT NULL::uuid, p_channel text DEFAULT NULL::text, p_language text DEFAULT 'es'::text) RETURNS TABLE(message_key text, message_template text, variations jsonb)
    LANGUAGE plpgsql STABLE
    AS $$
BEGIN
  RETURN QUERY
  SELECT DISTINCT ON (m.message_key)
    m.message_key,
    m.message_template,
    m.variations
  FROM bot_messages m
  WHERE m.is_active = true
    AND m.category = p_category
    AND m.language = p_language
    AND (m.organization_id = p_organization_id OR m.organization_id IS NULL)
    AND (m.channel = p_channel OR m.channel IS NULL)
  ORDER BY
    m.message_key,
    CASE WHEN m.organization_id = p_organization_id THEN 0 ELSE 1 END,
    CASE WHEN m.channel = p_channel THEN 0 ELSE 1 END,
    m.priority DESC;
END;
$$;


--
-- Name: get_cache_stats(uuid); Type: FUNCTION; Schema: public; Owner: -
--

CREATE FUNCTION public.get_cache_stats(p_organization_id uuid DEFAULT NULL::uuid) RETURNS TABLE(total_entries bigint, total_hits bigint, avg_hits_per_entry numeric, cache_size_bytes bigint, hit_rate numeric)
    LANGUAGE plpgsql SECURITY DEFINER
    AS $$
BEGIN
    RETURN QUERY
    SELECT
        COUNT(*) as total_entries,
        SUM(hit_count) as total_hits,
        ROUND(AVG(hit_count), 2) as avg_hits_per_entry,
        SUM(pg_column_size(response_text))::bigint as cache_size_bytes,
        CASE
            WHEN SUM(hit_count) > 0
            THEN ROUND((SUM(hit_count)::numeric / COUNT(*)::numeric) * 100, 2)
            ELSE 0
        END as hit_rate
    FROM public.ai_cache
    WHERE p_organization_id IS NULL OR organization_id = p_organization_id;
END;
$$;


--
-- Name: FUNCTION get_cache_stats(p_organization_id uuid); Type: COMMENT; Schema: public; Owner: -
--

COMMENT ON FUNCTION public.get_cache_stats(p_organization_id uuid) IS 'Get statistics about AI response cache usage.';


--
-- Name: get_client_full(uuid); Type: FUNCTION; Schema: public; Owner: -
--

CREATE FUNCTION public.get_client_full(p_client_id uuid) RETURNS TABLE(client_id uuid, entity_id uuid, organization_id uuid, display_name text, phone text, mobile text, email text, category public.client_category, status public.entity_status, total_visits integer, total_spent numeric, loyalty_points integer, loyalty_tier character varying, preferences jsonb, alerts jsonb, last_visit_date date, next_appointment_date date)
    LANGUAGE sql STABLE
    AS $$
    SELECT
        c.id as client_id,
        e.id as entity_id,
        c.organization_id,
        e.display_name,
        e.phone,
        e.mobile,
        e.email,
        c.category,
        c.status,
        c.total_visits,
        c.total_spent,
        c.loyalty_points,
        c.loyalty_tier,
        c.preferences,
        c.alerts,
        c.last_visit_date,
        c.next_appointment_date
    FROM clients c
    JOIN entities e ON e.id = c.entity_id
    WHERE c.id = p_client_id
      AND c.deleted_at IS NULL
      AND e.deleted_at IS NULL;
$$;


--
-- Name: get_client_resolution_config(uuid); Type: FUNCTION; Schema: public; Owner: -
--

CREATE FUNCTION public.get_client_resolution_config(p_organization_id uuid) RETURNS jsonb
    LANGUAGE sql STABLE
    AS $$
    SELECT COALESCE(
        (SELECT config FROM organization_configs
         WHERE organization_id = p_organization_id
         AND config_key = 'client_resolution'),
        jsonb_build_object(
            'auto_resolve_by_phone', true,
            'assume_self_booking', true,
            'allow_booking_for_others', true,
            'create_client_on_unknown', true,
            'require_registration', false
        )
    );
$$;


--
-- Name: FUNCTION get_client_resolution_config(p_organization_id uuid); Type: COMMENT; Schema: public; Owner: -
--

COMMENT ON FUNCTION public.get_client_resolution_config(p_organization_id uuid) IS 'Get client resolution configuration for an organization';


--
-- Name: get_confirmation_message(text, jsonb, uuid, text); Type: FUNCTION; Schema: public; Owner: -
--

CREATE FUNCTION public.get_confirmation_message(p_message_key text, p_variables jsonb DEFAULT '{}'::jsonb, p_organization_id uuid DEFAULT NULL::uuid, p_channel text DEFAULT NULL::text) RETURNS text
    LANGUAGE plpgsql STABLE
    AS $$
BEGIN
  RETURN get_bot_message(
    'confirmation',
    p_message_key,
    p_organization_id,
    p_channel,
    'es',
    p_variables
  );
END;
$$;


--
-- Name: get_conversation_context(uuid); Type: FUNCTION; Schema: public; Owner: -
--

CREATE FUNCTION public.get_conversation_context(p_conversation_id uuid) RETURNS TABLE(summary text, collected_slots jsonb, last_intent text, recent_messages jsonb, channel text)
    LANGUAGE plpgsql SECURITY DEFINER
    AS $$
BEGIN
  RETURN QUERY
  SELECT
    c.summary,
    CASE
      WHEN jsonb_typeof(c.collected_slots) = 'object' THEN c.collected_slots
      ELSE '{}'::jsonb
    END as collected_slots,
    c.last_intent,
    (SELECT jsonb_agg(sub.elem)
     FROM (SELECT elem FROM jsonb_array_elements(c.messages) AS elem
           ORDER BY (elem->>'timestamp')::timestamp DESC NULLS LAST
           LIMIT 5) sub) AS recent_messages,
    c.channel
  FROM ai_conversations c
  WHERE c.id = p_conversation_id;
END;
$$;


--
-- Name: FUNCTION get_conversation_context(p_conversation_id uuid); Type: COMMENT; Schema: public; Owner: -
--

COMMENT ON FUNCTION public.get_conversation_context(p_conversation_id uuid) IS 'Returns conversation context, ensures collected_slots is always an object';


--
-- Name: get_conversation_flow(character varying, uuid, character varying, character varying); Type: FUNCTION; Schema: public; Owner: -
--

CREATE FUNCTION public.get_conversation_flow(p_intent character varying, p_organization_id uuid DEFAULT NULL::uuid, p_vertical_code character varying DEFAULT NULL::character varying, p_channel character varying DEFAULT NULL::character varying) RETURNS TABLE(id uuid, flow_name character varying, slots jsonb, slot_order text[], confirmation_required boolean, success_action character varying, success_skill_id uuid, metadata jsonb, match_score integer)
    LANGUAGE plpgsql SECURITY DEFINER
    SET search_path TO 'public'
    AS $$
BEGIN
    RETURN QUERY
    SELECT 
        cf.id,
        cf.flow_name,
        cf.slots,
        cf.slot_order,
        cf.confirmation_required,
        cf.success_action,
        cf.success_skill_id,
        cf.metadata,
        (
            CASE WHEN cf.organization_id = p_organization_id THEN 100 ELSE 0 END +
            CASE WHEN cf.vertical_code = p_vertical_code THEN 10 ELSE 0 END +
            CASE WHEN cf.channel = p_channel THEN 5 ELSE 0 END +
            cf.priority
        ) AS match_score
    FROM conversation_flows cf
    WHERE 
        cf.enabled = true
        AND p_intent = ANY(cf.trigger_intents)
        AND (cf.organization_id IS NULL OR cf.organization_id = p_organization_id)
        AND (cf.vertical_code IS NULL OR cf.vertical_code = p_vertical_code)
        AND (cf.channel IS NULL OR cf.channel = p_channel)
    ORDER BY match_score DESC
    LIMIT 1;
END;
$$;


--
-- Name: get_conversation_history(uuid, integer); Type: FUNCTION; Schema: public; Owner: -
--

CREATE FUNCTION public.get_conversation_history(p_conversation_id uuid, p_limit integer DEFAULT 10) RETURNS TABLE(role text, content text, sent_at timestamp with time zone)
    LANGUAGE sql STABLE
    AS $$
  SELECT 
    CASE 
      WHEN direction = 'inbound' THEN 'user'
      ELSE 'assistant'
    END as role,
    content,
    sent_at
  FROM whatsapp_messages
  WHERE conversation_id = p_conversation_id
    AND message_type = 'text'
    AND content IS NOT NULL
  ORDER BY sent_at DESC
  LIMIT p_limit;
$$;


--
-- Name: FUNCTION get_conversation_history(p_conversation_id uuid, p_limit integer); Type: COMMENT; Schema: public; Owner: -
--

COMMENT ON FUNCTION public.get_conversation_history(p_conversation_id uuid, p_limit integer) IS 'Returns recent text messages formatted for LLM context (user/assistant roles)';


--
-- Name: get_conversation_state(uuid); Type: FUNCTION; Schema: public; Owner: -
--

CREATE FUNCTION public.get_conversation_state(p_conversation_id uuid) RETURNS jsonb
    LANGUAGE plpgsql SECURITY DEFINER
    AS $$
DECLARE
  state JSONB;
BEGIN
  SELECT conversation_state INTO state
  FROM whatsapp_conversations
  WHERE id = p_conversation_id;
  
  RETURN COALESCE(state, '{}'::jsonb);
END;
$$;


--
-- Name: FUNCTION get_conversation_state(p_conversation_id uuid); Type: COMMENT; Schema: public; Owner: -
--

COMMENT ON FUNCTION public.get_conversation_state(p_conversation_id uuid) IS 'Retrieves the current conversation state';


--
-- Name: get_current_capability(uuid, uuid, timestamp with time zone); Type: FUNCTION; Schema: public; Owner: -
--

CREATE FUNCTION public.get_current_capability(p_resource_entity_id uuid, p_catalog_item_id uuid, p_at_time timestamp with time zone DEFAULT now()) RETURNS TABLE(capability_id uuid, proficiency_level public.proficiency_level, proficiency_score smallint, custom_duration interval, custom_price numeric, currency_code character, attributes jsonb, is_primary boolean)
    LANGUAGE sql STABLE SECURITY DEFINER
    AS $$
  SELECT
    rc.id,
    rc.proficiency_level,
    rc.proficiency_score,
    rc.custom_duration,
    rc.custom_price,
    rc.currency_code,
    rc.attributes,
    rc.is_primary
  FROM public.resource_capabilities rc
  WHERE rc.resource_entity_id = p_resource_entity_id
    AND rc.catalog_item_id = p_catalog_item_id
    AND rc.is_active = true
    AND rc.deleted_at IS NULL
    AND rc.valid_from <= p_at_time
    AND (rc.valid_until IS NULL OR rc.valid_until > p_at_time)
  ORDER BY rc.valid_from DESC
  LIMIT 1;
$$;


--
-- Name: get_dependents(uuid); Type: FUNCTION; Schema: public; Owner: -
--

CREATE FUNCTION public.get_dependents(p_entity_id uuid) RETURNS TABLE(dependent_id uuid, dependent_name text, relationship_type public.entity_relationship_type, date_of_birth date, age integer, financial_responsibility boolean, custom_fields jsonb)
    LANGUAGE plpgsql SECURITY DEFINER
    AS $$
BEGIN
    RETURN QUERY
    SELECT
        e.id AS dependent_id,
        e.display_name AS dependent_name,
        er.relationship_type,
        p.date_of_birth,
        EXTRACT(YEAR FROM age(p.date_of_birth))::integer AS age,
        er.financial_responsibility,
        er.custom_fields
    FROM entity_relationships er
    JOIN entities e ON e.id = er.entity_to_id
    LEFT JOIN patients p ON p.entity_id = e.id
    WHERE er.entity_from_id = p_entity_id
      AND er.relationship_type IN ('child', 'dependent', 'legal_guardian')
      AND er.status = 'active'
      AND er.deleted_at IS NULL
      AND e.deleted_at IS NULL
      AND (er.valid_until IS NULL OR er.valid_until >= CURRENT_DATE)
    ORDER BY p.date_of_birth DESC NULLS LAST;
END;
$$;


--
-- Name: FUNCTION get_dependents(p_entity_id uuid); Type: COMMENT; Schema: public; Owner: -
--

COMMENT ON FUNCTION public.get_dependents(p_entity_id uuid) IS 'Get all dependents of an entity (children, legal dependents).';


--
-- Name: get_emergency_contacts(uuid); Type: FUNCTION; Schema: public; Owner: -
--

CREATE FUNCTION public.get_emergency_contacts(p_entity_id uuid) RETURNS TABLE(contact_id uuid, contact_name text, contact_phone text, contact_email text, relationship_type public.entity_relationship_type, priority_order integer, can_make_medical_decisions boolean, custom_fields jsonb)
    LANGUAGE plpgsql SECURITY DEFINER
    AS $$
BEGIN
    RETURN QUERY
    SELECT
        e.id AS contact_id,
        e.display_name AS contact_name,
        e.phone AS contact_phone,
        e.email AS contact_email,
        er.relationship_type,
        er.priority_order,
        er.can_make_medical_decisions,
        er.custom_fields
    FROM entity_relationships er
    JOIN entities e ON e.id = er.entity_from_id
    WHERE er.entity_to_id = p_entity_id
      AND er.relationship_type IN ('emergency_contact', 'parent', 'legal_guardian', 'spouse', 'partner', 'healthcare_proxy')
      AND er.status = 'active'
      AND er.deleted_at IS NULL
      AND e.deleted_at IS NULL
      AND (er.valid_until IS NULL OR er.valid_until >= CURRENT_DATE)
    ORDER BY er.priority_order ASC, er.primary_contact DESC;
END;
$$;


--
-- Name: FUNCTION get_emergency_contacts(p_entity_id uuid); Type: COMMENT; Schema: public; Owner: -
--

COMMENT ON FUNCTION public.get_emergency_contacts(p_entity_id uuid) IS 'Get emergency contacts for an entity, ordered by priority.';


--
-- Name: get_entity_documents(uuid); Type: FUNCTION; Schema: public; Owner: -
--

CREATE FUNCTION public.get_entity_documents(p_entity_id uuid) RETURNS jsonb
    LANGUAGE sql STABLE SECURITY DEFINER
    AS $$
    SELECT COALESCE(jsonb_agg(
        jsonb_build_object(
            'id', id, 
            'type', document_type, 
            'number', document_number,
            'issuing_country', issuing_country, 
            'issued_at', issued_at,
            'expires_at', expires_at, 
            'is_primary', is_primary,
            'is_verified', is_verified, 
            'verified_at', verified_at,
            'verification_method', verification_method,
            'label', label, 
            'notes', notes, 
            'image_url_front', image_url_front,
            'image_url_back', image_url_back, 
            'custom_fields', custom_fields
        ) ORDER BY is_primary DESC, created_at
    ), '[]'::jsonb)
    FROM entity_identification_documents
    WHERE entity_id = p_entity_id AND deleted_at IS NULL;
$$;


--
-- Name: get_entity_insurance(uuid); Type: FUNCTION; Schema: public; Owner: -
--

CREATE FUNCTION public.get_entity_insurance(p_entity_id uuid) RETURNS jsonb
    LANGUAGE sql STABLE SECURITY DEFINER
    AS $$
    SELECT COALESCE(jsonb_agg(
        jsonb_build_object(
            'id', id, 
            'policy_type', policy_type, 
            'provider_code', provider_code,
            'provider_name', provider_name, 
            'provider_entity_id', provider_entity_id,
            'policy_number', policy_number, 
            'plan_code', plan_code, 
            'plan_name', plan_name,
            'group_number', group_number, 
            'subscriber_id', subscriber_id,
            'subscriber_name', subscriber_name, 
            'subscriber_relationship', subscriber_relationship,
            'nss', nss, 
            'effective_date', effective_date, 
            'expiration_date', expiration_date,
            'copay', copay, 
            'deductible', deductible, 
            'out_of_pocket_max', out_of_pocket_max,
            'coverage_details', coverage_details, 
            'is_primary', is_primary,
            'is_active', is_active, 
            'is_verified', is_verified,
            'verified_at', verified_at,
            'card_image_url_front', card_image_url_front, 
            'card_image_url_back', card_image_url_back,
            'notes', notes, 
            'custom_fields', custom_fields
        ) ORDER BY is_primary DESC, is_active DESC, created_at
    ), '[]'::jsonb)
    FROM entity_insurance_policies
    WHERE entity_id = p_entity_id AND deleted_at IS NULL;
$$;


--
-- Name: get_entity_recommendations(uuid, uuid, integer); Type: FUNCTION; Schema: public; Owner: -
--

CREATE FUNCTION public.get_entity_recommendations(p_entity_id uuid, p_organization_id uuid, p_limit integer DEFAULT 5) RETURNS TABLE(entity_id uuid, display_name text, entity_type text, similarity_score double precision, email text)
    LANGUAGE plpgsql SECURITY DEFINER
    AS $$
DECLARE
    source_embedding extensions.vector(1536);
BEGIN
    -- Get embedding of source entity
    SELECT embedding INTO source_embedding
    FROM public.ai_embeddings
    WHERE source_table = 'entities'
      AND source_id = p_entity_id
      AND organization_id = p_organization_id
    LIMIT 1;

    IF source_embedding IS NULL THEN
        RAISE EXCEPTION 'Entity embedding not found for ID: %', p_entity_id;
    END IF;

    -- Find similar entities
    RETURN QUERY
    SELECT
        e.id as entity_id,
        e.display_name,
        e.entity_type::text,
        1 - (emb.embedding <=> source_embedding) as similarity_score,
        e.email
    FROM public.ai_embeddings emb
    JOIN public.entities e ON e.id = emb.source_id
    WHERE emb.organization_id = p_organization_id
      AND emb.source_table = 'entities'
      AND emb.source_id != p_entity_id  -- Exclude source entity
      AND e.deleted_at IS NULL
      AND e.status = 'active'
    ORDER BY emb.embedding <=> source_embedding
    LIMIT p_limit;
END;
$$;


--
-- Name: FUNCTION get_entity_recommendations(p_entity_id uuid, p_organization_id uuid, p_limit integer); Type: COMMENT; Schema: public; Owner: -
--

COMMENT ON FUNCTION public.get_entity_recommendations(p_entity_id uuid, p_organization_id uuid, p_limit integer) IS 'Get similar entities based on vector similarity. Useful for "Similar patients" feature.';


--
-- Name: get_entity_relationships(uuid, boolean); Type: FUNCTION; Schema: public; Owner: -
--

CREATE FUNCTION public.get_entity_relationships(p_entity_id uuid, p_include_inactive boolean DEFAULT false) RETURNS TABLE(relationship_id uuid, related_entity_id uuid, related_entity_name text, relationship_type public.entity_relationship_type, direction text, status public.relationship_status, can_make_medical_decisions boolean, can_view_medical_records boolean, financial_responsibility boolean, primary_contact boolean, valid_from date, valid_until date, custom_fields jsonb)
    LANGUAGE plpgsql SECURITY DEFINER
    AS $$
BEGIN
    RETURN QUERY
    -- Relationships FROM this entity
    SELECT
        er.id AS relationship_id,
        er.entity_to_id AS related_entity_id,
        e.display_name AS related_entity_name,
        er.relationship_type,
        'from'::text AS direction,
        er.status,
        er.can_make_medical_decisions,
        er.can_view_medical_records,
        er.financial_responsibility,
        er.primary_contact,
        er.valid_from,
        er.valid_until,
        er.custom_fields
    FROM entity_relationships er
    JOIN entities e ON e.id = er.entity_to_id
    WHERE er.entity_from_id = p_entity_id
      AND er.deleted_at IS NULL
      AND e.deleted_at IS NULL
      AND (p_include_inactive OR er.status = 'active')
      AND (er.valid_until IS NULL OR er.valid_until >= CURRENT_DATE)

    UNION ALL

    -- Relationships TO this entity
    SELECT
        er.id AS relationship_id,
        er.entity_from_id AS related_entity_id,
        e.display_name AS related_entity_name,
        er.relationship_type,
        'to'::text AS direction,
        er.status,
        er.can_make_medical_decisions,
        er.can_view_medical_records,
        er.financial_responsibility,
        er.primary_contact,
        er.valid_from,
        er.valid_until,
        er.custom_fields
    FROM entity_relationships er
    JOIN entities e ON e.id = er.entity_from_id
    WHERE er.entity_to_id = p_entity_id
      AND er.deleted_at IS NULL
      AND e.deleted_at IS NULL
      AND (p_include_inactive OR er.status = 'active')
      AND (er.valid_until IS NULL OR er.valid_until >= CURRENT_DATE)

    ORDER BY primary_contact DESC, priority_order ASC;
END;
$$;


--
-- Name: FUNCTION get_entity_relationships(p_entity_id uuid, p_include_inactive boolean); Type: COMMENT; Schema: public; Owner: -
--

COMMENT ON FUNCTION public.get_entity_relationships(p_entity_id uuid, p_include_inactive boolean) IS 'Get all active relationships for an entity (both from and to).
Set p_include_inactive=true to include inactive relationships.';


--
-- Name: get_entity_synonyms(character varying, uuid, boolean); Type: FUNCTION; Schema: public; Owner: -
--

CREATE FUNCTION public.get_entity_synonyms(p_entity_type character varying, p_organization_id uuid DEFAULT NULL::uuid, p_include_global boolean DEFAULT true) RETURNS TABLE(id uuid, synonym character varying, canonical_value character varying, canonical_id uuid, category character varying, is_org_specific boolean)
    LANGUAGE sql SECURITY DEFINER
    SET search_path TO 'public'
    AS $$
    SELECT 
        es.id,
        es.synonym,
        es.canonical_value,
        es.canonical_id,
        es.category,
        (es.organization_id IS NOT NULL) AS is_org_specific
    FROM entity_synonyms es
    WHERE 
        es.enabled = true
        AND es.entity_type = p_entity_type
        AND (
            (p_include_global AND es.organization_id IS NULL) OR
            es.organization_id = p_organization_id
        )
    ORDER BY 
        es.organization_id NULLS LAST,
        es.canonical_value,
        es.synonym;
$$;


--
-- Name: get_greeting_message(uuid, text, jsonb); Type: FUNCTION; Schema: public; Owner: -
--

CREATE FUNCTION public.get_greeting_message(p_organization_id uuid DEFAULT NULL::uuid, p_channel text DEFAULT NULL::text, p_context jsonb DEFAULT '{}'::jsonb) RETURNS text
    LANGUAGE plpgsql STABLE
    AS $$
DECLARE
  greetings TEXT[];
  greeting TEXT;
  var_key TEXT;
  var_value TEXT;
BEGIN
  SELECT array_agg(m.message_template)
  INTO greetings
  FROM bot_messages m
  WHERE m.is_active = true
    AND m.category = 'greeting'
    AND m.message_key = 'default'
    AND (m.organization_id = p_organization_id OR m.organization_id IS NULL)
    AND (m.channel = p_channel OR m.channel IS NULL);

  IF greetings IS NULL OR array_length(greetings, 1) = 0 THEN
    RETURN 'Hola, ¿en qué puedo ayudarte?';
  END IF;

  greeting := greetings[1 + floor(random() * array_length(greetings, 1))::int];

  FOR var_key, var_value IN SELECT * FROM jsonb_each_text(p_context)
  LOOP
    greeting := replace(greeting, '{' || var_key || '}', COALESCE(var_value, ''));
  END LOOP;

  RETURN greeting;
END;
$$;


--
-- Name: get_guardians(uuid); Type: FUNCTION; Schema: public; Owner: -
--

CREATE FUNCTION public.get_guardians(p_entity_id uuid) RETURNS TABLE(guardian_id uuid, guardian_name text, guardian_email character varying, guardian_phone character varying, relationship_type public.entity_relationship_type, is_primary boolean, can_authorize boolean, can_represent boolean, can_pickup boolean, is_billing_contact boolean, custody_type text)
    LANGUAGE plpgsql SECURITY DEFINER
    AS $$
BEGIN
    RETURN QUERY
    SELECT 
        vg.guardian_entity_id,
        vg.guardian_name,
        vg.guardian_email,
        vg.guardian_phone,
        vg.relationship_type,
        vg.is_primary,
        vg.can_authorize,
        vg.can_represent,
        vg.can_pickup,
        vg.is_billing_contact,
        vg.custody_type
    FROM v_entity_guardians vg
    WHERE vg.minor_entity_id = p_entity_id
    ORDER BY vg.priority, vg.is_primary DESC;
END;
$$;


--
-- Name: FUNCTION get_guardians(p_entity_id uuid); Type: COMMENT; Schema: public; Owner: -
--

COMMENT ON FUNCTION public.get_guardians(p_entity_id uuid) IS 'Returns all guardians/parents for a minor entity';


--
-- Name: get_high_risk_patients(uuid, numeric); Type: FUNCTION; Schema: public; Owner: -
--

CREATE FUNCTION public.get_high_risk_patients(p_organization_id uuid, p_risk_threshold numeric DEFAULT 0.7) RETURNS TABLE(patient_id uuid, display_name text, patient_code character varying, risk_score numeric, risk_category text, last_visit_date date, email text, phone text)
    LANGUAGE plpgsql SECURITY DEFINER
    AS $$
BEGIN
    RETURN QUERY
    SELECT
        p.id,
        e.display_name,
        p.patient_code,
        (p.ai_risk_assessment->>'overall_risk_score')::numeric,
        p.ai_risk_assessment->>'risk_category',
        p.last_visit_date,
        e.email,
        e.phone
    FROM patients p
    JOIN entities e ON e.id = p.entity_id
    WHERE p.organization_id = p_organization_id
      AND p.deleted_at IS NULL
      AND e.deleted_at IS NULL
      AND p.ai_risk_assessment ? 'overall_risk_score'
      AND (p.ai_risk_assessment->>'overall_risk_score')::numeric >= p_risk_threshold
    ORDER BY (p.ai_risk_assessment->>'overall_risk_score')::numeric DESC;
END;
$$;


--
-- Name: FUNCTION get_high_risk_patients(p_organization_id uuid, p_risk_threshold numeric); Type: COMMENT; Schema: public; Owner: -
--

COMMENT ON FUNCTION public.get_high_risk_patients(p_organization_id uuid, p_risk_threshold numeric) IS 'Get high-risk patients based on AI risk assessment.';


--
-- Name: get_inactive_patients(uuid, integer); Type: FUNCTION; Schema: public; Owner: -
--

CREATE FUNCTION public.get_inactive_patients(p_organization_id uuid, p_months_inactive integer DEFAULT 6) RETURNS TABLE(patient_id uuid, display_name text, patient_code character varying, last_visit_date date, months_since_visit integer, email text, phone text, status public.patient_status)
    LANGUAGE plpgsql SECURITY DEFINER
    AS $$
BEGIN
    RETURN QUERY
    SELECT
        p.id,
        e.display_name,
        p.patient_code,
        p.last_visit_date,
        EXTRACT(MONTH FROM age(CURRENT_DATE, p.last_visit_date))::integer,
        e.email,
        e.phone,
        p.status
    FROM patients p
    JOIN entities e ON e.id = p.entity_id
    WHERE p.organization_id = p_organization_id
      AND p.deleted_at IS NULL
      AND e.deleted_at IS NULL
      AND p.last_visit_date IS NOT NULL
      AND p.last_visit_date < (CURRENT_DATE - (p_months_inactive || ' months')::interval)
      AND p.status IN ('active', 'inactive')
    ORDER BY p.last_visit_date DESC;
END;
$$;


--
-- Name: FUNCTION get_inactive_patients(p_organization_id uuid, p_months_inactive integer); Type: COMMENT; Schema: public; Owner: -
--

COMMENT ON FUNCTION public.get_inactive_patients(p_organization_id uuid, p_months_inactive integer) IS 'Get patients who haven''t visited in N months (default 6).';


--
-- Name: get_intent_signals(text, uuid); Type: FUNCTION; Schema: public; Owner: -
--

CREATE FUNCTION public.get_intent_signals(p_intent text, p_organization_id uuid DEFAULT NULL::uuid) RETURNS TABLE(signal_type text, signal_value text, weight double precision, is_required boolean, is_negative boolean, priority integer)
    LANGUAGE plpgsql STABLE
    AS $$
BEGIN
  RETURN QUERY
  SELECT
    s.signal_type,
    s.signal_value,
    s.weight,
    s.is_required,
    s.is_negative,
    s.priority
  FROM nlu_intent_signals s
  WHERE s.is_active = true
    AND s.intent = p_intent
    AND (s.organization_id IS NULL OR s.organization_id = p_organization_id)
  ORDER BY s.priority DESC, s.weight DESC;
END;
$$;


--
-- Name: get_knowledge_stats(uuid); Type: FUNCTION; Schema: public; Owner: -
--

CREATE FUNCTION public.get_knowledge_stats(p_organization_id uuid) RETURNS TABLE(content_type public.knowledge_content_type, total_count bigint, with_embedding bigint, pending_embedding bigint)
    LANGUAGE sql STABLE
    AS $$
  SELECT
    kb.content_type,
    COUNT(*)::bigint as total_count,
    COUNT(*) FILTER (WHERE kb.embedding IS NOT NULL)::bigint as with_embedding,
    COUNT(*) FILTER (WHERE kb.embedding IS NULL AND kb.enabled = true)::bigint as pending_embedding
  FROM org_knowledge_base kb
  WHERE kb.organization_id = p_organization_id
  GROUP BY kb.content_type;
$$;


--
-- Name: get_llm_prompt(character varying, uuid, character varying, character varying, character varying); Type: FUNCTION; Schema: public; Owner: -
--

CREATE FUNCTION public.get_llm_prompt(p_prompt_key character varying, p_organization_id uuid DEFAULT NULL::uuid, p_vertical_code character varying DEFAULT NULL::character varying, p_channel character varying DEFAULT NULL::character varying, p_language character varying DEFAULT 'es'::character varying) RETURNS TABLE(id uuid, prompt_key character varying, system_prompt text, model_hint character varying, temperature numeric, max_tokens integer, top_p numeric, frequency_penalty numeric, presence_penalty numeric, metadata jsonb, match_score integer)
    LANGUAGE plpgsql SECURITY DEFINER
    SET search_path TO 'public'
    AS $$
BEGIN
    RETURN QUERY
    SELECT 
        lp.id,
        lp.prompt_key,
        lp.system_prompt,
        lp.model_hint,
        lp.temperature,
        lp.max_tokens,
        lp.top_p,
        lp.frequency_penalty,
        lp.presence_penalty,
        lp.metadata,
        -- Calculate match score based on specificity
        (
            CASE WHEN lp.organization_id = p_organization_id THEN 100 ELSE 0 END +
            CASE WHEN lp.vertical_code = p_vertical_code THEN 10 ELSE 0 END +
            CASE WHEN lp.channel = p_channel THEN 5 ELSE 0 END +
            CASE WHEN lp.language = p_language THEN 2 ELSE 0 END +
            lp.priority
        ) AS match_score
    FROM llm_prompts lp
    WHERE 
        lp.enabled = true
        AND lp.prompt_key = p_prompt_key
        AND (lp.organization_id IS NULL OR lp.organization_id = p_organization_id)
        AND (lp.vertical_code IS NULL OR lp.vertical_code = p_vertical_code)
        AND (lp.channel IS NULL OR lp.channel = p_channel)
        AND (lp.language IS NULL OR lp.language = p_language OR lp.language = 'es')  -- Fallback to Spanish
    ORDER BY match_score DESC, lp.created_at DESC
    LIMIT 1;
END;
$$;


--
-- Name: FUNCTION get_llm_prompt(p_prompt_key character varying, p_organization_id uuid, p_vertical_code character varying, p_channel character varying, p_language character varying); Type: COMMENT; Schema: public; Owner: -
--

COMMENT ON FUNCTION public.get_llm_prompt(p_prompt_key character varying, p_organization_id uuid, p_vertical_code character varying, p_channel character varying, p_language character varying) IS 'Gets the most specific LLM prompt for the given context.
Uses priority scoring to find the best match:
- Organization match: +100 points
- Vertical match: +10 points
- Channel match: +5 points
- Language match: +2 points
- Plus the prompt priority field';


--
-- Name: get_nlu_keywords(text, uuid); Type: FUNCTION; Schema: public; Owner: -
--

CREATE FUNCTION public.get_nlu_keywords(p_category text, p_organization_id uuid DEFAULT NULL::uuid) RETURNS TABLE(keyword text, weight double precision)
    LANGUAGE plpgsql STABLE
    AS $$
BEGIN
  RETURN QUERY
  SELECT DISTINCT ON (k.keyword)
    k.keyword,
    k.weight
  FROM nlu_keywords k
  WHERE k.is_active = true
    AND k.category = p_category
    AND (k.organization_id IS NULL OR k.organization_id = p_organization_id)
  ORDER BY k.keyword, k.organization_id NULLS LAST;  -- Prefer org-specific over global
END;
$$;


--
-- Name: get_openai_key(); Type: FUNCTION; Schema: public; Owner: -
--

CREATE FUNCTION public.get_openai_key() RETURNS text
    LANGUAGE sql SECURITY DEFINER
    AS $$
  SELECT decrypted_secret 
  FROM vault.decrypted_secrets 
  WHERE name = 'OPENAI_API_KEY' 
  LIMIT 1;
$$;


--
-- Name: get_or_create_conversation(uuid, text, text, uuid, text, integer); Type: FUNCTION; Schema: public; Owner: -
--

CREATE FUNCTION public.get_or_create_conversation(p_organization_id uuid, p_channel text, p_phone_number text DEFAULT NULL::text, p_user_id uuid DEFAULT NULL::uuid, p_context_type text DEFAULT 'general'::text, p_max_age_minutes integer DEFAULT 30) RETURNS uuid
    LANGUAGE plpgsql SECURITY DEFINER
    AS $$
DECLARE
  v_conversation_id UUID;
  v_cutoff TIMESTAMP WITH TIME ZONE;
BEGIN
  v_cutoff := NOW() - (p_max_age_minutes || ' minutes')::INTERVAL;

  -- Try to find existing active conversation
  IF p_phone_number IS NOT NULL THEN
    SELECT id INTO v_conversation_id
    FROM ai_conversations
    WHERE organization_id = p_organization_id
      AND phone_number = p_phone_number
      AND channel = p_channel
      AND status = 'active'
      AND last_message_at > v_cutoff
    ORDER BY last_message_at DESC
    LIMIT 1;
  ELSIF p_user_id IS NOT NULL THEN
    SELECT id INTO v_conversation_id
    FROM ai_conversations
    WHERE organization_id = p_organization_id
      AND user_id = p_user_id
      AND channel = p_channel
      AND status = 'active'
      AND last_message_at > v_cutoff
    ORDER BY last_message_at DESC
    LIMIT 1;
  END IF;

  -- Create new conversation if not found
  IF v_conversation_id IS NULL THEN
    INSERT INTO ai_conversations (
      organization_id,
      user_id,
      channel,
      phone_number,
      context_type,
      status
    ) VALUES (
      p_organization_id,
      p_user_id,
      p_channel,
      p_phone_number,
      p_context_type,
      'active'
    )
    RETURNING id INTO v_conversation_id;
  END IF;

  RETURN v_conversation_id;
END;
$$;


--
-- Name: FUNCTION get_or_create_conversation(p_organization_id uuid, p_channel text, p_phone_number text, p_user_id uuid, p_context_type text, p_max_age_minutes integer); Type: COMMENT; Schema: public; Owner: -
--

COMMENT ON FUNCTION public.get_or_create_conversation(p_organization_id uuid, p_channel text, p_phone_number text, p_user_id uuid, p_context_type text, p_max_age_minutes integer) IS 'Finds an active conversation or creates a new one. Used by bot handlers.';


--
-- Name: conversation_sessions; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.conversation_sessions (
    id uuid DEFAULT gen_random_uuid() NOT NULL,
    organization_id uuid NOT NULL,
    channel character varying(50) NOT NULL,
    channel_user_id character varying(255) NOT NULL,
    current_intent character varying(100),
    slot_definitions jsonb DEFAULT '[]'::jsonb,
    collected_slots jsonb DEFAULT '{}'::jsonb,
    extracted_entities jsonb DEFAULT '{}'::jsonb,
    context jsonb DEFAULT '{}'::jsonb,
    metadata jsonb DEFAULT '{}'::jsonb,
    turn_count integer DEFAULT 0,
    last_user_message text,
    last_bot_response text,
    active_flow_id uuid,
    pending_confirmation boolean DEFAULT false,
    confirmation_data jsonb,
    started_at timestamp with time zone DEFAULT now(),
    last_activity_at timestamp with time zone DEFAULT now(),
    expires_at timestamp with time zone DEFAULT (now() + '00:30:00'::interval),
    closed_at timestamp with time zone,
    status character varying(20) DEFAULT 'active'::character varying,
    CONSTRAINT conversation_sessions_status_check CHECK (((status)::text = ANY ((ARRAY['active'::character varying, 'waiting'::character varying, 'completed'::character varying, 'expired'::character varying, 'error'::character varying])::text[])))
);


--
-- Name: TABLE conversation_sessions; Type: COMMENT; Schema: public; Owner: -
--

COMMENT ON TABLE public.conversation_sessions IS 'Tracks active conversation sessions for multi-turn AI interactions';


--
-- Name: get_or_create_conversation_session(uuid, character varying, character varying); Type: FUNCTION; Schema: public; Owner: -
--

CREATE FUNCTION public.get_or_create_conversation_session(p_organization_id uuid, p_channel character varying, p_channel_user_id character varying) RETURNS public.conversation_sessions
    LANGUAGE plpgsql SECURITY DEFINER
    AS $$
DECLARE
    v_session conversation_sessions;
BEGIN
    -- Try to find an active session
    SELECT * INTO v_session
    FROM conversation_sessions
    WHERE organization_id = p_organization_id
    AND channel = p_channel
    AND channel_user_id = p_channel_user_id
    AND status = 'active'
    AND expires_at > NOW()
    ORDER BY started_at DESC
    LIMIT 1;
    
    -- If found, update last_activity and extend expiry
    IF FOUND THEN
        UPDATE conversation_sessions
        SET 
            last_activity_at = NOW(),
            expires_at = NOW() + INTERVAL '30 minutes'
        WHERE id = v_session.id
        RETURNING * INTO v_session;
        
        RETURN v_session;
    END IF;
    
    -- Create new session
    INSERT INTO conversation_sessions (
        organization_id, channel, channel_user_id,
        status, expires_at
    ) VALUES (
        p_organization_id, p_channel, p_channel_user_id,
        'active', NOW() + INTERVAL '30 minutes'
    )
    RETURNING * INTO v_session;
    
    RETURN v_session;
END;
$$;


--
-- Name: FUNCTION get_or_create_conversation_session(p_organization_id uuid, p_channel character varying, p_channel_user_id character varying); Type: COMMENT; Schema: public; Owner: -
--

COMMENT ON FUNCTION public.get_or_create_conversation_session(p_organization_id uuid, p_channel character varying, p_channel_user_id character varying) IS 'Gets an active session or creates a new one';


--
-- Name: get_or_create_whatsapp_conversation(text, uuid, text); Type: FUNCTION; Schema: public; Owner: -
--

CREATE FUNCTION public.get_or_create_whatsapp_conversation(p_phone_number text, p_organization_id uuid, p_provider text DEFAULT 'meta'::text) RETURNS uuid
    LANGUAGE plpgsql
    AS $$
DECLARE
  v_conversation_id UUID;
  v_entity_id UUID;
BEGIN
  -- Try to find active conversation for this phone + organization
  SELECT id INTO v_conversation_id
  FROM whatsapp_conversations
  WHERE phone_number = p_phone_number
    AND organization_id = p_organization_id
    AND conversation_state = 'active'
  LIMIT 1;
  
  -- If no active conversation found, create new one
  IF v_conversation_id IS NULL THEN
    -- Try to auto-link to an existing entity by phone number
    SELECT id INTO v_entity_id
    FROM entities
    WHERE organization_id = p_organization_id
      AND deleted_at IS NULL
      AND phone = p_phone_number
    LIMIT 1;
    
    -- Create new conversation
    INSERT INTO whatsapp_conversations (
      phone_number,
      organization_id,
      entity_id,
      conversation_state,
      context,
      provider,
      message_count,
      first_message_at,
      last_message_at,
      created_at,
      updated_at
    )
    VALUES (
      p_phone_number,
      p_organization_id,
      v_entity_id,  -- May be NULL if no entity found
      'active',
      '{}'::jsonb,
      p_provider,
      0,
      now(),
      now(),
      now(),
      now()
    )
    RETURNING id INTO v_conversation_id;
  END IF;
  
  RETURN v_conversation_id;
END;
$$;


--
-- Name: FUNCTION get_or_create_whatsapp_conversation(p_phone_number text, p_organization_id uuid, p_provider text); Type: COMMENT; Schema: public; Owner: -
--

COMMENT ON FUNCTION public.get_or_create_whatsapp_conversation(p_phone_number text, p_organization_id uuid, p_provider text) IS 'Finds active conversation by phone+org or creates new one. Auto-links to entity if exists.';


--
-- Name: llm_prompts; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.llm_prompts (
    id uuid DEFAULT gen_random_uuid() NOT NULL,
    organization_id uuid,
    prompt_key character varying(100) NOT NULL,
    prompt_name character varying(255),
    description text,
    system_prompt text NOT NULL,
    model_hint character varying(100),
    temperature numeric(3,2) DEFAULT 0.7,
    max_tokens integer DEFAULT 4000,
    top_p numeric(3,2) DEFAULT 1.0,
    frequency_penalty numeric(3,2) DEFAULT 0,
    presence_penalty numeric(3,2) DEFAULT 0,
    vertical_code character varying(50),
    channel character varying(50),
    language character varying(10) DEFAULT 'es'::character varying,
    version integer DEFAULT 1,
    parent_prompt_id uuid,
    enabled boolean DEFAULT true,
    priority integer DEFAULT 0,
    tags text[],
    metadata jsonb DEFAULT '{}'::jsonb,
    created_at timestamp with time zone DEFAULT now(),
    updated_at timestamp with time zone DEFAULT now(),
    created_by uuid,
    CONSTRAINT llm_prompts_frequency_penalty_check CHECK (((frequency_penalty >= ('-2'::integer)::numeric) AND (frequency_penalty <= (2)::numeric))),
    CONSTRAINT llm_prompts_max_tokens_check CHECK (((max_tokens > 0) AND (max_tokens <= 128000))),
    CONSTRAINT llm_prompts_presence_penalty_check CHECK (((presence_penalty >= ('-2'::integer)::numeric) AND (presence_penalty <= (2)::numeric))),
    CONSTRAINT llm_prompts_temperature_check CHECK (((temperature >= (0)::numeric) AND (temperature <= (2)::numeric))),
    CONSTRAINT llm_prompts_top_p_check CHECK (((top_p >= (0)::numeric) AND (top_p <= (1)::numeric)))
);


--
-- Name: TABLE llm_prompts; Type: COMMENT; Schema: public; Owner: -
--

COMMENT ON TABLE public.llm_prompts IS 'Stores configurable LLM system prompts with multi-tenant, multi-vertical, multi-channel support.
Replaces hardcoded SYSTEM_PROMPTS in TypeScript.
Use get_llm_prompt() RPC to retrieve the most specific prompt for a given context.';


--
-- Name: COLUMN llm_prompts.prompt_key; Type: COMMENT; Schema: public; Owner: -
--

COMMENT ON COLUMN public.llm_prompts.prompt_key IS 'Unique key identifying the prompt type: general, appointment_booking, patient_search, etc.';


--
-- Name: COLUMN llm_prompts.model_hint; Type: COMMENT; Schema: public; Owner: -
--

COMMENT ON COLUMN public.llm_prompts.model_hint IS 'Suggested model to use. NULL = use system default.';


--
-- Name: COLUMN llm_prompts.vertical_code; Type: COMMENT; Schema: public; Owner: -
--

COMMENT ON COLUMN public.llm_prompts.vertical_code IS 'Vertical this prompt is optimized for. NULL = all verticals.';


--
-- Name: COLUMN llm_prompts.channel; Type: COMMENT; Schema: public; Owner: -
--

COMMENT ON COLUMN public.llm_prompts.channel IS 'Channel this prompt is optimized for (whatsapp, web, voice). NULL = all channels.';


--
-- Name: COLUMN llm_prompts.priority; Type: COMMENT; Schema: public; Owner: -
--

COMMENT ON COLUMN public.llm_prompts.priority IS 'When multiple prompts match, higher priority wins.';


--
-- Name: get_org_llm_prompts(uuid); Type: FUNCTION; Schema: public; Owner: -
--

CREATE FUNCTION public.get_org_llm_prompts(p_organization_id uuid) RETURNS SETOF public.llm_prompts
    LANGUAGE sql SECURITY DEFINER
    SET search_path TO 'public'
    AS $$
    SELECT *
    FROM llm_prompts
    WHERE organization_id IS NULL OR organization_id = p_organization_id
    ORDER BY 
        organization_id NULLS LAST,  -- Org-specific first
        prompt_key,
        vertical_code NULLS LAST,
        channel NULLS LAST;
$$;


--
-- Name: get_organization_vertical_config(uuid); Type: FUNCTION; Schema: public; Owner: -
--

CREATE FUNCTION public.get_organization_vertical_config(p_organization_id uuid) RETURNS jsonb
    LANGUAGE plpgsql STABLE SECURITY DEFINER
    AS $$
DECLARE
  v_config jsonb;
BEGIN
  SELECT jsonb_build_object(
    'vertical_code', ov.code,
    'vertical_name', ov.name_es,
    'terminology', ov.terminology_config,
    'features', ov.features_config,
    'field_visibility', ov.field_visibility_config,
    'icon', ov.icon,
    'color', ov.color
  )
  INTO v_config
  FROM organizations o
  JOIN organization_verticals ov ON ov.id = o.vertical_id
  WHERE o.id = p_organization_id
    AND o.deleted_at IS NULL
    AND ov.is_active = true;
  
  RETURN COALESCE(v_config, '{}'::jsonb);
END;
$$;


--
-- Name: FUNCTION get_organization_vertical_config(p_organization_id uuid); Type: COMMENT; Schema: public; Owner: -
--

COMMENT ON FUNCTION public.get_organization_vertical_config(p_organization_id uuid) IS 'Returns complete vertical configuration for an organization including terminology and features';


--
-- Name: get_organization_whatsapp_config(uuid); Type: FUNCTION; Schema: public; Owner: -
--

CREATE FUNCTION public.get_organization_whatsapp_config(org_id uuid) RETURNS jsonb
    LANGUAGE plpgsql SECURITY DEFINER
    AS $$
DECLARE
  config JSONB;
BEGIN
  SELECT whatsapp_config INTO config
  FROM organizations
  WHERE id = org_id;
  
  RETURN config;
END;
$$;


--
-- Name: FUNCTION get_organization_whatsapp_config(org_id uuid); Type: COMMENT; Schema: public; Owner: -
--

COMMENT ON FUNCTION public.get_organization_whatsapp_config(org_id uuid) IS 'Retrieves WhatsApp configuration for a specific organization';


--
-- Name: get_own_profile(); Type: FUNCTION; Schema: public; Owner: -
--

CREATE FUNCTION public.get_own_profile() RETURNS jsonb
    LANGUAGE plpgsql SECURITY DEFINER
    SET search_path TO 'public'
    AS $$
DECLARE
  v_user_id UUID;
  v_profile public.profiles%ROWTYPE;
  v_email TEXT;
BEGIN
  v_user_id := auth.uid();
  
  IF v_user_id IS NULL THEN
    RETURN jsonb_build_object('error', 'Not authenticated');
  END IF;

  -- Get profile
  SELECT * INTO v_profile
  FROM public.profiles
  WHERE user_id = v_user_id;

  -- Get email from auth.users
  SELECT email INTO v_email
  FROM auth.users
  WHERE id = v_user_id;

  IF v_profile IS NULL THEN
    RETURN jsonb_build_object('error', 'Profile not found');
  END IF;

  RETURN jsonb_build_object(
    'user_id', v_profile.user_id,
    'full_name', v_profile.full_name,
    'avatar_url', v_profile.avatar_url,
    'email', v_email,
    'role', v_profile.role,
    'phone_number', v_profile.phone_number,
    'job_title', v_profile.job_title,
    'department', v_profile.department,
    'timezone', v_profile.timezone,
    'date_format', v_profile.date_format,
    'time_format', v_profile.time_format,
    'preferred_language', v_profile.preferred_language,
    'notifications_enabled', v_profile.notifications_enabled,
    'dark_mode_enabled', v_profile.dark_mode_enabled,
    'is_active', v_profile.is_active,
    'created_at', v_profile.created_at,
    'updated_at', v_profile.updated_at
  );
END;
$$;


--
-- Name: get_patient_age(date); Type: FUNCTION; Schema: public; Owner: -
--

CREATE FUNCTION public.get_patient_age(p_date_of_birth date) RETURNS integer
    LANGUAGE plpgsql IMMUTABLE
    AS $$
BEGIN
    RETURN EXTRACT(YEAR FROM age(p_date_of_birth))::integer;
END;
$$;


--
-- Name: FUNCTION get_patient_age(p_date_of_birth date); Type: COMMENT; Schema: public; Owner: -
--

COMMENT ON FUNCTION public.get_patient_age(p_date_of_birth date) IS 'Calculate patient age from date of birth.';


--
-- Name: get_patient_full_profile(uuid); Type: FUNCTION; Schema: public; Owner: -
--

CREATE FUNCTION public.get_patient_full_profile(p_patient_id uuid) RETURNS TABLE(patient_id uuid, patient_code character varying, medical_record_number character varying, status public.patient_status, category public.patient_category, entity_id uuid, display_name text, email text, phone text, date_of_birth date, age integer, gender_identity public.gender_identity, preferred_language public.preferred_language, blood_type public.blood_type_enum, first_visit_date date, last_visit_date date, next_appointment_date date, insurance_info jsonb, medical_history jsonb, allergies jsonb, current_medications jsonb, preferences jsonb, ai_risk_assessment jsonb, ai_predictions jsonb, ai_insights jsonb)
    LANGUAGE plpgsql SECURITY DEFINER
    AS $$
BEGIN
    RETURN QUERY
    SELECT
        p.id,
        p.patient_code,
        p.medical_record_number,
        p.status,
        p.category,
        e.id,
        e.display_name,
        e.email,
        e.phone,
        p.date_of_birth,
        get_patient_age(p.date_of_birth),
        p.gender_identity,
        p.preferred_language,
        p.blood_type,
        p.first_visit_date,
        p.last_visit_date,
        p.next_appointment_date,
        p.insurance_info,
        p.medical_history,
        p.allergies,
        p.current_medications,
        p.preferences,
        p.ai_risk_assessment,
        p.ai_predictions,
        p.ai_insights
    FROM patients p
    JOIN entities e ON e.id = p.entity_id
    WHERE p.id = p_patient_id
      AND p.deleted_at IS NULL
      AND e.deleted_at IS NULL;
END;
$$;


--
-- Name: FUNCTION get_patient_full_profile(p_patient_id uuid); Type: COMMENT; Schema: public; Owner: -
--

COMMENT ON FUNCTION public.get_patient_full_profile(p_patient_id uuid) IS 'Get complete patient profile with entity information.';


--
-- Name: get_patient_notes_with_author(uuid, integer, integer, text); Type: FUNCTION; Schema: public; Owner: -
--

CREATE FUNCTION public.get_patient_notes_with_author(p_patient_id uuid, p_limit integer DEFAULT 50, p_offset integer DEFAULT 0, p_note_type text DEFAULT NULL::text) RETURNS TABLE(id uuid, patient_id uuid, note_type text, title text, content text, appointment_id uuid, visit_date timestamp with time zone, is_private boolean, is_pinned boolean, tags text[], attachments jsonb, created_by uuid, created_at timestamp with time zone, updated_at timestamp with time zone, author_name text, author_email text, author_avatar_url text)
    LANGUAGE plpgsql SECURITY DEFINER
    AS $$
BEGIN
    RETURN QUERY
    SELECT 
        pn.id,
        pn.patient_id,
        pn.note_type,
        pn.title,
        pn.content,
        pn.appointment_id,
        pn.visit_date,
        pn.is_private,
        pn.is_pinned,
        pn.tags,
        pn.attachments,
        pn.created_by,
        pn.created_at,
        pn.updated_at,
        COALESCE(p.full_name, 'Usuario del sistema') as author_name,
        COALESCE(p.email, '') as author_email,
        p.avatar_url as author_avatar_url
    FROM public.patient_notes pn
    LEFT JOIN public.profiles p ON p.user_id = pn.created_by
    WHERE pn.patient_id = p_patient_id
      AND pn.deleted_at IS NULL
      AND (p_note_type IS NULL OR pn.note_type = p_note_type)
      AND (NOT pn.is_private OR pn.created_by = auth.uid())
    ORDER BY pn.is_pinned DESC, pn.created_at DESC
    LIMIT p_limit
    OFFSET p_offset;
END;
$$;


--
-- Name: get_patient_primary_email(uuid); Type: FUNCTION; Schema: public; Owner: -
--

CREATE FUNCTION public.get_patient_primary_email(p_patient_id uuid) RETURNS text
    LANGUAGE sql STABLE
    AS $$
  SELECT 
    COALESCE(
      -- First try to find primary email
      (SELECT e->>'address' 
       FROM patients p, jsonb_array_elements(p.emails) e 
       WHERE p.id = p_patient_id AND (e->>'isPrimary')::boolean = true
       LIMIT 1),
      -- Fall back to first email
      (SELECT emails->0->>'address' 
       FROM patients 
       WHERE id = p_patient_id)
    );
$$;


--
-- Name: get_patient_primary_phone(uuid); Type: FUNCTION; Schema: public; Owner: -
--

CREATE FUNCTION public.get_patient_primary_phone(p_patient_id uuid) RETURNS text
    LANGUAGE sql STABLE
    AS $$
  SELECT 
    COALESCE(
      -- First try to find primary phone
      (SELECT ph->>'number' 
       FROM patients p, jsonb_array_elements(p.phones) ph 
       WHERE p.id = p_patient_id AND (ph->>'isPrimary')::boolean = true
       LIMIT 1),
      -- Fall back to first phone
      (SELECT phones->0->>'number' 
       FROM patients 
       WHERE id = p_patient_id)
    );
$$;


--
-- Name: get_patient_whatsapp(uuid); Type: FUNCTION; Schema: public; Owner: -
--

CREATE FUNCTION public.get_patient_whatsapp(p_patient_id uuid) RETURNS text
    LANGUAGE sql STABLE
    AS $$
  SELECT ph->>'number' 
  FROM patients p, jsonb_array_elements(p.phones) ph 
  WHERE p.id = p_patient_id AND (ph->>'whatsapp')::boolean = true
  LIMIT 1;
$$;


--
-- Name: get_patients_with_upcoming_appointments(uuid, integer); Type: FUNCTION; Schema: public; Owner: -
--

CREATE FUNCTION public.get_patients_with_upcoming_appointments(p_organization_id uuid, p_days_ahead integer DEFAULT 7) RETURNS TABLE(patient_id uuid, display_name text, next_appointment_date date, days_until_appointment integer, reminder_preference public.appointment_reminder_preference, email text, phone text)
    LANGUAGE plpgsql SECURITY DEFINER
    AS $$
BEGIN
    RETURN QUERY
    SELECT
        p.id,
        e.display_name,
        p.next_appointment_date,
        (p.next_appointment_date - CURRENT_DATE)::integer,
        (p.preferences->>'appointment_reminder')::appointment_reminder_preference,
        e.email,
        e.phone
    FROM patients p
    JOIN entities e ON e.id = p.entity_id
    WHERE p.organization_id = p_organization_id
      AND p.deleted_at IS NULL
      AND e.deleted_at IS NULL
      AND p.next_appointment_date IS NOT NULL
      AND p.next_appointment_date BETWEEN CURRENT_DATE AND (CURRENT_DATE + p_days_ahead)
    ORDER BY p.next_appointment_date;
END;
$$;


--
-- Name: FUNCTION get_patients_with_upcoming_appointments(p_organization_id uuid, p_days_ahead integer); Type: COMMENT; Schema: public; Owner: -
--

COMMENT ON FUNCTION public.get_patients_with_upcoming_appointments(p_organization_id uuid, p_days_ahead integer) IS 'Get patients with appointments in the next N days (default 7).';


--
-- Name: get_pending_action(uuid); Type: FUNCTION; Schema: public; Owner: -
--

CREATE FUNCTION public.get_pending_action(p_conversation_id uuid) RETURNS jsonb
    LANGUAGE plpgsql
    AS $$
DECLARE
  action JSONB;
BEGIN
  SELECT pending_action INTO action
  FROM whatsapp_conversations
  WHERE id = p_conversation_id;

  -- Return NULL if no action or expired
  IF action IS NULL THEN
    RETURN NULL;
  END IF;

  IF (action->>'expires_at')::timestamptz < now() THEN
    -- Clear expired action
    UPDATE whatsapp_conversations
    SET pending_action = NULL
    WHERE id = p_conversation_id;
    RETURN NULL;
  END IF;

  RETURN action;
END;
$$;


--
-- Name: get_person_label(uuid, boolean); Type: FUNCTION; Schema: public; Owner: -
--

CREATE FUNCTION public.get_person_label(p_organization_id uuid, p_plural boolean DEFAULT false) RETURNS text
    LANGUAGE plpgsql STABLE SECURITY DEFINER
    AS $$
DECLARE
  v_label text;
  v_key text;
BEGIN
  v_key := CASE WHEN p_plural THEN 'person_label_plural' ELSE 'person_label' END;
  
  SELECT ov.terminology_config->>v_key
  INTO v_label
  FROM organizations o
  JOIN organization_verticals ov ON ov.id = o.vertical_id
  WHERE o.id = p_organization_id
    AND o.deleted_at IS NULL
    AND ov.is_active = true;
  
  RETURN COALESCE(v_label, CASE WHEN p_plural THEN 'Personas' ELSE 'Persona' END);
END;
$$;


--
-- Name: FUNCTION get_person_label(p_organization_id uuid, p_plural boolean); Type: COMMENT; Schema: public; Owner: -
--

COMMENT ON FUNCTION public.get_person_label(p_organization_id uuid, p_plural boolean) IS 'Returns the appropriate person label for an organization based on its vertical (e.g., Paciente, Cliente, Huésped)';


--
-- Name: get_resource_capabilities(uuid); Type: FUNCTION; Schema: public; Owner: -
--

CREATE FUNCTION public.get_resource_capabilities(p_resource_entity_id uuid) RETURNS TABLE(capability_id uuid, catalog_item_id uuid, catalog_item_name text, catalog_item_type character varying, custom_duration interval, custom_price numeric, currency_code character, base_duration_minutes integer, base_price numeric, proficiency_level public.proficiency_level, proficiency_score smallint, is_primary boolean, is_active boolean, attributes jsonb, availability_count bigint)
    LANGUAGE plpgsql STABLE SECURITY DEFINER
    AS $$
BEGIN
  RETURN QUERY
  SELECT
    rc.id AS capability_id,
    rc.catalog_item_id,
    ci.name AS catalog_item_name,
    ci.item_type AS catalog_item_type,
    rc.custom_duration,
    rc.custom_price,
    rc.currency_code,
    ci.duration_minutes AS base_duration_minutes,
    ci.base_price,
    rc.proficiency_level,
    rc.proficiency_score,
    rc.is_primary,
    rc.is_active,
    rc.attributes,
    (SELECT COUNT(*) FROM public.resource_capability_availability rca
     WHERE rca.capability_id = rc.id AND rca.is_active = true) AS availability_count
  FROM public.resource_capabilities rc
  JOIN public.catalog_items ci ON ci.id = rc.catalog_item_id
  WHERE rc.resource_entity_id = p_resource_entity_id
    AND rc.deleted_at IS NULL
    AND ci.deleted_at IS NULL
    AND rc.valid_from <= now()
    AND (rc.valid_until IS NULL OR rc.valid_until > now())
  ORDER BY
    rc.is_primary DESC,
    ci.item_type,
    ci.name;
END;
$$;


--
-- Name: get_search_analytics(uuid, integer); Type: FUNCTION; Schema: public; Owner: -
--

CREATE FUNCTION public.get_search_analytics(p_organization_id uuid, p_days integer DEFAULT 30) RETURNS TABLE(total_searches bigint, avg_results_count numeric, avg_similarity numeric, avg_latency_ms numeric, most_common_queries jsonb)
    LANGUAGE plpgsql SECURITY DEFINER
    AS $$
BEGIN
    RETURN QUERY
    WITH analytics AS (
        SELECT
            COUNT(*) as total,
            AVG(results_count) as avg_results,
            AVG(avg_similarity_score) as avg_sim,
            AVG(latency_ms) as avg_lat
        FROM public.ai_search_logs
        WHERE organization_id = p_organization_id
          AND created_at >= NOW() - (p_days || ' days')::interval
    ),
    common_queries AS (
        SELECT jsonb_agg(
            jsonb_build_object(
                'query', query_text,
                'count', count
            )
            ORDER BY count DESC
        ) as queries
        FROM (
            SELECT query_text, COUNT(*) as count
            FROM public.ai_search_logs
            WHERE organization_id = p_organization_id
              AND created_at >= NOW() - (p_days || ' days')::interval
            GROUP BY query_text
            ORDER BY count DESC
            LIMIT 10
        ) t
    )
    SELECT
        a.total,
        ROUND(a.avg_results, 2),
        ROUND(a.avg_sim, 3),
        ROUND(a.avg_lat, 0),
        c.queries
    FROM analytics a
    CROSS JOIN common_queries c;
END;
$$;


--
-- Name: FUNCTION get_search_analytics(p_organization_id uuid, p_days integer); Type: COMMENT; Schema: public; Owner: -
--

COMMENT ON FUNCTION public.get_search_analytics(p_organization_id uuid, p_days integer) IS 'Get analytics about semantic searches for the last N days.';


--
-- Name: get_skill_metrics(uuid, integer); Type: FUNCTION; Schema: public; Owner: -
--

CREATE FUNCTION public.get_skill_metrics(p_organization_id uuid, p_days integer DEFAULT 30) RETURNS TABLE(skill_name text, category public.skill_category, total_executions bigint, successful bigint, failed bigint, avg_latency_ms numeric, success_rate numeric, total_tokens bigint)
    LANGUAGE sql STABLE
    AS $$
  SELECT
    s.name as skill_name,
    s.category,
    COUNT(*)::bigint as total_executions,
    COUNT(*) FILTER (WHERE e.status = 'completed')::bigint as successful,
    COUNT(*) FILTER (WHERE e.status = 'failed')::bigint as failed,
    ROUND(AVG(e.latency_ms), 2) as avg_latency_ms,
    ROUND(
      (COUNT(*) FILTER (WHERE e.status = 'completed')::numeric /
       NULLIF(COUNT(*), 0) * 100), 2
    ) as success_rate,
    COALESCE(SUM(e.tokens_used), 0)::bigint as total_tokens
  FROM ai_skill_executions e
  JOIN ai_skills s ON e.skill_id = s.id
  WHERE e.organization_id = p_organization_id
    AND e.created_at >= now() - (p_days || ' days')::interval
  GROUP BY s.name, s.category
  ORDER BY total_executions DESC;
$$;


--
-- Name: get_slot_prompt(text, uuid, text); Type: FUNCTION; Schema: public; Owner: -
--

CREATE FUNCTION public.get_slot_prompt(p_slot_name text, p_organization_id uuid, p_vertical text DEFAULT 'generic'::text) RETURNS text
    LANGUAGE plpgsql STABLE
    AS $$
DECLARE
  config JSONB;
  prompt TEXT;
BEGIN
  config := get_vertical_config(p_organization_id, p_vertical);
  prompt := config->'slot_prompts'->>p_slot_name;

  RETURN COALESCE(prompt, 'Por favor proporcione ' || p_slot_name);
END;
$$;


--
-- Name: get_slot_prompt_message(text, uuid, text, jsonb); Type: FUNCTION; Schema: public; Owner: -
--

CREATE FUNCTION public.get_slot_prompt_message(p_slot_name text, p_organization_id uuid DEFAULT NULL::uuid, p_channel text DEFAULT NULL::text, p_context jsonb DEFAULT '{}'::jsonb) RETURNS text
    LANGUAGE plpgsql STABLE
    AS $$
BEGIN
  RETURN get_bot_message(
    'slot_prompt',
    p_slot_name,
    p_organization_id,
    p_channel,
    'es',
    p_context
  );
END;
$$;


--
-- Name: get_time_based_greeting_key(integer); Type: FUNCTION; Schema: public; Owner: -
--

CREATE FUNCTION public.get_time_based_greeting_key(p_hour integer DEFAULT NULL::integer) RETURNS text
    LANGUAGE plpgsql STABLE
    AS $$
DECLARE
  current_hour INT;
BEGIN
  current_hour := COALESCE(p_hour, EXTRACT(HOUR FROM now() AT TIME ZONE 'America/Mexico_City')::int);

  IF current_hour >= 5 AND current_hour < 12 THEN
    RETURN 'morning';
  ELSIF current_hour >= 12 AND current_hour < 19 THEN
    RETURN 'afternoon';
  ELSE
    RETURN 'evening';
  END IF;
END;
$$;


--
-- Name: get_typo_correction(text, uuid); Type: FUNCTION; Schema: public; Owner: -
--

CREATE FUNCTION public.get_typo_correction(p_typo text, p_organization_id uuid DEFAULT NULL::uuid) RETURNS text
    LANGUAGE plpgsql STABLE
    AS $$
DECLARE
  result TEXT;
BEGIN
  SELECT t.correction INTO result
  FROM nlu_typo_corrections t
  WHERE t.is_active = true
    AND t.typo = lower(trim(p_typo))
    AND (t.organization_id IS NULL OR t.organization_id = p_organization_id)
  ORDER BY t.organization_id NULLS LAST  -- Prefer org-specific
  LIMIT 1;

  RETURN COALESCE(result, p_typo);
END;
$$;


--
-- Name: get_user_allowed_skills(uuid, uuid, text, text); Type: FUNCTION; Schema: public; Owner: -
--

CREATE FUNCTION public.get_user_allowed_skills(p_user_id uuid, p_organization_id uuid, p_module text DEFAULT NULL::text, p_vertical text DEFAULT NULL::text) RETURNS TABLE(skill_id text, can_execute boolean, requires_approval boolean, max_daily_calls integer)
    LANGUAGE plpgsql STABLE SECURITY DEFINER
    AS $$
DECLARE
    v_role_key TEXT;
BEGIN
    -- Get user's role in organization
    SELECT m.role_key INTO v_role_key
    FROM public.memberships m
    WHERE m.user_id = p_user_id
      AND m.organization_id = p_organization_id
      AND m.status = 'active';

    -- Default to external_client for WhatsApp/web users without membership
    v_role_key := COALESCE(v_role_key, 'external_client');

    RETURN QUERY
    SELECT
        sa.skill_id,
        sa.can_execute,
        sa.requires_approval,
        sa.max_daily_calls
    FROM public.skill_access sa
    WHERE sa.role_key = v_role_key
      AND sa.can_execute = true
      -- Module filter (if skill has module restriction)
      AND (sa.modules IS NULL OR p_module IS NULL OR p_module = ANY(sa.modules))
      -- Vertical filter (if skill has vertical restriction)
      AND (sa.verticals IS NULL OR p_vertical IS NULL OR p_vertical = ANY(sa.verticals));
END;
$$;


--
-- Name: get_user_emails(uuid[]); Type: FUNCTION; Schema: public; Owner: -
--

CREATE FUNCTION public.get_user_emails(user_ids uuid[]) RETURNS TABLE(user_id uuid, email text)
    LANGUAGE sql SECURITY DEFINER
    SET search_path TO 'public', 'auth'
    AS $$
    SELECT 
        au.id as user_id,
        au.email::TEXT as email
    FROM auth.users au
    WHERE au.id = ANY(user_ids);
$$;


--
-- Name: get_user_permissions(uuid, uuid); Type: FUNCTION; Schema: public; Owner: -
--

CREATE FUNCTION public.get_user_permissions(p_user_id uuid, p_organization_id uuid) RETURNS jsonb
    LANGUAGE plpgsql STABLE SECURITY DEFINER
    AS $$
DECLARE
    v_role_permissions JSONB;
    v_custom_permissions JSONB;
    v_role_key TEXT;
BEGIN
    -- Get membership
    SELECT m.role_key, r.permissions, m.custom_permissions
    INTO v_role_key, v_role_permissions, v_custom_permissions
    FROM public.memberships m
    INNER JOIN public.roles r ON r.key = m.role_key
    WHERE m.user_id = p_user_id
      AND m.organization_id = p_organization_id
      AND m.status = 'active';

    IF v_role_permissions IS NULL THEN
        -- No membership found - return external_client permissions (for WhatsApp/Web users)
        SELECT permissions INTO v_role_permissions
        FROM public.roles WHERE key = 'external_client';

        RETURN COALESCE(v_role_permissions, '{}'::jsonb);
    END IF;

    -- Merge custom permissions (override role)
    IF v_custom_permissions IS NOT NULL THEN
        RETURN v_role_permissions || v_custom_permissions;
    END IF;

    RETURN v_role_permissions;
END;
$$;


--
-- Name: get_user_role_info(uuid, uuid); Type: FUNCTION; Schema: public; Owner: -
--

CREATE FUNCTION public.get_user_role_info(p_user_id uuid, p_organization_id uuid) RETURNS TABLE(role_key text, role_name text, role_level integer, permissions jsonb, custom_permissions jsonb, status text)
    LANGUAGE plpgsql STABLE SECURITY DEFINER
    AS $$
BEGIN
    RETURN QUERY
    SELECT
        r.key AS role_key,
        r.name AS role_name,
        r.level AS role_level,
        r.permissions,
        m.custom_permissions,
        m.status
    FROM public.memberships m
    INNER JOIN public.roles r ON r.key = m.role_key
    WHERE m.user_id = p_user_id
      AND m.organization_id = p_organization_id;
END;
$$;


--
-- Name: get_vertical_config(uuid, text, text); Type: FUNCTION; Schema: public; Owner: -
--

CREATE FUNCTION public.get_vertical_config(p_organization_id uuid, p_vertical text DEFAULT 'generic'::text, p_language text DEFAULT 'es'::text) RETURNS jsonb
    LANGUAGE plpgsql STABLE
    AS $$
DECLARE
  org_config JSONB;
  global_config JSONB;
BEGIN
  -- Try org-specific first
  SELECT config INTO org_config
  FROM vertical_configs
  WHERE is_active = true
    AND organization_id = p_organization_id
    AND vertical = p_vertical
    AND language = p_language;

  -- Fallback to global
  SELECT config INTO global_config
  FROM vertical_configs
  WHERE is_active = true
    AND organization_id IS NULL
    AND vertical = p_vertical
    AND language = p_language;

  -- Merge: org config takes precedence
  IF org_config IS NOT NULL AND global_config IS NOT NULL THEN
    RETURN global_config || org_config;
  ELSIF org_config IS NOT NULL THEN
    RETURN org_config;
  ELSIF global_config IS NOT NULL THEN
    RETURN global_config;
  ELSE
    -- Return empty config if nothing found
    RETURN '{}'::jsonb;
  END IF;
END;
$$;


--
-- Name: get_vertical_terminology(uuid, text, text); Type: FUNCTION; Schema: public; Owner: -
--

CREATE FUNCTION public.get_vertical_terminology(p_organization_id uuid, p_vertical text DEFAULT 'generic'::text, p_term_type text DEFAULT NULL::text) RETURNS jsonb
    LANGUAGE plpgsql STABLE
    AS $$
DECLARE
  config JSONB;
BEGIN
  config := get_vertical_config(p_organization_id, p_vertical);

  IF p_term_type IS NOT NULL THEN
    RETURN config->'terminology'->p_term_type;
  ELSE
    RETURN config->'terminology';
  END IF;
END;
$$;


--
-- Name: get_waitlist_stats(uuid, uuid, date, date); Type: FUNCTION; Schema: public; Owner: -
--

CREATE FUNCTION public.get_waitlist_stats(p_organization_id uuid, p_location_id uuid DEFAULT NULL::uuid, p_from_date date DEFAULT NULL::date, p_to_date date DEFAULT NULL::date) RETURNS TABLE(total_waiting bigint, total_notified bigint, total_booked bigint, total_declined bigint, total_expired bigint, average_wait_days numeric, conversion_rate numeric)
    LANGUAGE plpgsql SECURITY DEFINER
    AS $$
BEGIN
  RETURN QUERY
  WITH stats AS (
    SELECT
      w.status,
      EXTRACT(DAY FROM (
        CASE WHEN w.status IN ('booked', 'declined', 'expired', 'removed') 
        THEN COALESCE(w.responded_at, w.updated_at) 
        ELSE NOW() END
      ) - w.added_at) AS wait_days
    FROM waitlist_entries w
    WHERE w.organization_id = p_organization_id
      AND (p_location_id IS NULL OR w.location_id = p_location_id)
      AND (p_from_date IS NULL OR w.added_at >= p_from_date)
      AND (p_to_date IS NULL OR w.added_at <= p_to_date)
  )
  SELECT
    COUNT(*) FILTER (WHERE status = 'waiting'),
    COUNT(*) FILTER (WHERE status = 'notified'),
    COUNT(*) FILTER (WHERE status = 'booked'),
    COUNT(*) FILTER (WHERE status = 'declined'),
    COUNT(*) FILTER (WHERE status = 'expired'),
    ROUND(AVG(wait_days), 1),
    ROUND(
      COUNT(*) FILTER (WHERE status = 'booked')::NUMERIC / 
      NULLIF(COUNT(*) FILTER (WHERE status IN ('booked', 'declined', 'expired'))::NUMERIC, 0) * 100,
      1
    )
  FROM stats;
END;
$$;


--
-- Name: get_walkin_queue_stats(uuid); Type: FUNCTION; Schema: public; Owner: -
--

CREATE FUNCTION public.get_walkin_queue_stats(p_location_id uuid) RETURNS TABLE(total_waiting bigint, currently_serving bigint, average_wait_minutes integer, longest_wait_minutes integer, high_risk_count bigint, served_today bigint, walked_away_today bigint, available_providers integer, next_opening_minutes integer)
    LANGUAGE plpgsql SECURITY DEFINER
    AS $$
DECLARE
  today_start TIMESTAMPTZ := DATE_TRUNC('day', NOW());
BEGIN
  RETURN QUERY
  SELECT
    COUNT(*) FILTER (WHERE w.status = 'waiting'),
    COUNT(*) FILTER (WHERE w.status = 'serving'),
    COALESCE(AVG(CASE WHEN w.status = 'waiting' THEN EXTRACT(EPOCH FROM (NOW() - w.arrived_at)) / 60 END)::INTEGER, 0),
    COALESCE(MAX(CASE WHEN w.status = 'waiting' THEN EXTRACT(EPOCH FROM (NOW() - w.arrived_at)) / 60 END)::INTEGER, 0),
    COUNT(*) FILTER (WHERE w.status = 'waiting' AND w.walk_away_risk > 0.7),
    COUNT(*) FILTER (WHERE w.status = 'completed' AND w.arrived_at >= today_start),
    COUNT(*) FILTER (WHERE w.status = 'walked_away' AND w.arrived_at >= today_start),
    0::INTEGER,
    NULL::INTEGER
  FROM walkin_entries w
  WHERE w.location_id = p_location_id AND w.arrived_at >= today_start;
END;
$$;


--
-- Name: get_whatsapp_config(uuid); Type: FUNCTION; Schema: public; Owner: -
--

CREATE FUNCTION public.get_whatsapp_config(p_organization_id uuid) RETURNS jsonb
    LANGUAGE plpgsql STABLE SECURITY DEFINER
    AS $$
DECLARE
  config RECORD;
BEGIN
  SELECT * INTO config
  FROM whatsapp_org_config
  WHERE organization_id = p_organization_id;

  IF NOT FOUND THEN
    -- Return defaults
    RETURN jsonb_build_object(
      'use_emojis', true,
      'use_formatting', true,
      'default_tone', 'friendly',
      'greeting_style', 'warm',
      'use_buttons', true,
      'use_list_messages', true,
      'max_inline_buttons', 3,
      'show_quick_replies', true,
      'confirmation_style', 'detailed',
      'use_time_based_greetings', true,
      'default_language', 'es',
      'date_format', 'DD/MM/YYYY',
      'time_format', '12h',
      'emoji_mappings', '{
        "greeting": "👋",
        "success": "✅",
        "error": "❌",
        "warning": "⚠️",
        "info": "ℹ️",
        "calendar": "📅",
        "clock": "🕐",
        "person": "👤",
        "service": "💇",
        "money": "💰",
        "location": "📍",
        "phone": "📞",
        "email": "📧",
        "sparkle": "✨",
        "heart": "❤️",
        "thumbs_up": "👍",
        "wave": "👋",
        "celebration": "🎉"
      }'::jsonb,
      'message_signature', null,
      'custom_templates', '{}'::jsonb
    );
  END IF;

  RETURN jsonb_build_object(
    'use_emojis', config.use_emojis,
    'use_formatting', config.use_formatting,
    'default_tone', config.default_tone,
    'greeting_style', config.greeting_style,
    'use_buttons', config.use_buttons,
    'use_list_messages', config.use_list_messages,
    'max_inline_buttons', config.max_inline_buttons,
    'show_quick_replies', config.show_quick_replies,
    'confirmation_style', config.confirmation_style,
    'use_time_based_greetings', config.use_time_based_greetings,
    'default_language', config.default_language,
    'date_format', config.date_format,
    'time_format', config.time_format,
    'emoji_mappings', config.emoji_mappings,
    'message_signature', config.message_signature,
    'custom_templates', config.custom_templates
  );
END;
$$;


--
-- Name: FUNCTION get_whatsapp_config(p_organization_id uuid); Type: COMMENT; Schema: public; Owner: -
--

COMMENT ON FUNCTION public.get_whatsapp_config(p_organization_id uuid) IS 'Get WhatsApp configuration for an organization with defaults';


--
-- Name: has_ai_feature_access(text); Type: FUNCTION; Schema: public; Owner: -
--

CREATE FUNCTION public.has_ai_feature_access(feature_name text) RETURNS boolean
    LANGUAGE plpgsql STABLE SECURITY DEFINER
    AS $$
DECLARE
    org_id uuid;
    org_plan text;
BEGIN
    -- Get current organization
    org_id := public.current_org_id();

    IF org_id IS NULL THEN
        RETURN false;
    END IF;

    -- For now, all organizations have access to AI features
    -- In the future, this could check subscription plans
    -- SELECT plan_type INTO org_plan
    -- FROM public.subscriptions
    -- WHERE organization_id = org_id AND status = 'active';

    -- Return true if feature is enabled for this plan
    -- For MVP, return true for all features
    RETURN true;
END;
$$;


--
-- Name: FUNCTION has_ai_feature_access(feature_name text); Type: COMMENT; Schema: public; Owner: -
--

COMMENT ON FUNCTION public.has_ai_feature_access(feature_name text) IS 'Check if current user has access to AI features. Can be extended with subscription plan checks.';


--
-- Name: has_role(text); Type: FUNCTION; Schema: public; Owner: -
--

CREATE FUNCTION public.has_role(required_role text) RETURNS boolean
    LANGUAGE sql STABLE
    AS $$
    SELECT (current_setting('request.jwt.claims', true)::jsonb->>'role') = required_role;
$$;


--
-- Name: hybrid_search_entities(text, extensions.vector, uuid, integer, double precision, double precision); Type: FUNCTION; Schema: public; Owner: -
--

CREATE FUNCTION public.hybrid_search_entities(query_text text, query_embedding extensions.vector, p_organization_id uuid, p_limit integer DEFAULT 10, p_semantic_weight double precision DEFAULT 0.7, p_keyword_weight double precision DEFAULT 0.3) RETURNS TABLE(entity_id uuid, display_name text, entity_type text, combined_score double precision, semantic_score double precision, keyword_score double precision, email text, status text)
    LANGUAGE plpgsql SECURITY DEFINER
    AS $$
BEGIN
    RETURN QUERY
    WITH semantic_results AS (
        SELECT
            e.id,
            1 - (emb.embedding <=> query_embedding) as score
        FROM public.ai_embeddings emb
        JOIN public.entities e ON e.id = emb.source_id
        WHERE emb.organization_id = p_organization_id
          AND emb.source_table = 'entities'
          AND e.deleted_at IS NULL
          AND e.status = 'active'
    ),
    keyword_results AS (
        SELECT
            id,
            GREATEST(
                similarity(display_name, query_text),
                COALESCE(similarity(email, query_text), 0)
            ) as score
        FROM public.entities
        WHERE organization_id = p_organization_id
          AND deleted_at IS NULL
          AND status = 'active'
          AND (
              display_name ILIKE '%' || query_text || '%'
              OR email ILIKE '%' || query_text || '%'
          )
    )
    SELECT
        e.id as entity_id,
        e.display_name,
        e.entity_type::text,
        (COALESCE(sr.score, 0) * p_semantic_weight +
         COALESCE(kr.score, 0) * p_keyword_weight) as combined_score,
        COALESCE(sr.score, 0) as semantic_score,
        COALESCE(kr.score, 0) as keyword_score,
        e.email,
        e.status::text
    FROM public.entities e
    LEFT JOIN semantic_results sr ON sr.id = e.id
    LEFT JOIN keyword_results kr ON kr.id = e.id
    WHERE e.organization_id = p_organization_id
      AND e.deleted_at IS NULL
      AND e.status = 'active'
      AND (sr.score IS NOT NULL OR kr.score IS NOT NULL)
    ORDER BY combined_score DESC
    LIMIT p_limit;
END;
$$;


--
-- Name: FUNCTION hybrid_search_entities(query_text text, query_embedding extensions.vector, p_organization_id uuid, p_limit integer, p_semantic_weight double precision, p_keyword_weight double precision); Type: COMMENT; Schema: public; Owner: -
--

COMMENT ON FUNCTION public.hybrid_search_entities(query_text text, query_embedding extensions.vector, p_organization_id uuid, p_limit integer, p_semantic_weight double precision, p_keyword_weight double precision) IS 'Hybrid search combining semantic (AI) and keyword (text exact match). Best for multilingual and typo-tolerant search.';


--
-- Name: increment_ai_refresh_count(); Type: FUNCTION; Schema: public; Owner: -
--

CREATE FUNCTION public.increment_ai_refresh_count() RETURNS trigger
    LANGUAGE plpgsql
    AS $$
BEGIN
    NEW.ai_refresh_count := COALESCE(OLD.ai_refresh_count, 0) + 1;
    NEW.last_ai_refresh_at := now();
    RETURN NEW;
END;
$$;


--
-- Name: is_authenticated(); Type: FUNCTION; Schema: public; Owner: -
--

CREATE FUNCTION public.is_authenticated() RETURNS boolean
    LANGUAGE sql STABLE
    AS $$
    SELECT (current_setting('request.jwt.claims', true)::jsonb->>'sub') IS NOT NULL;
$$;


--
-- Name: is_platform_admin(); Type: FUNCTION; Schema: public; Owner: -
--

CREATE FUNCTION public.is_platform_admin() RETURNS boolean
    LANGUAGE plpgsql STABLE SECURITY DEFINER
    SET search_path TO 'public'
    AS $$
BEGIN
    -- Check if user has platform_admin role in user_roles table
    RETURN EXISTS (
        SELECT 1 
        FROM user_roles ur
        JOIN roles r ON r.key = ur.role_key
        WHERE ur.user_id = auth.uid()
          AND r.level >= 200
    );
END;
$$;


--
-- Name: log_semantic_search(text, uuid, uuid, integer, double precision, integer, text, jsonb); Type: FUNCTION; Schema: public; Owner: -
--

CREATE FUNCTION public.log_semantic_search(p_query_text text, p_organization_id uuid, p_user_id uuid, p_results_count integer, p_avg_similarity_score double precision, p_latency_ms integer, p_search_type text DEFAULT 'semantic'::text, p_filters_applied jsonb DEFAULT NULL::jsonb) RETURNS uuid
    LANGUAGE plpgsql SECURITY DEFINER
    AS $$
DECLARE
    log_id uuid;
BEGIN
    INSERT INTO public.ai_search_logs (
        query_text,
        organization_id,
        user_id,
        results_count,
        avg_similarity_score,
        latency_ms,
        search_type,
        filters_applied
    ) VALUES (
        p_query_text,
        p_organization_id,
        p_user_id,
        p_results_count,
        p_avg_similarity_score,
        p_latency_ms,
        p_search_type,
        p_filters_applied
    )
    RETURNING id INTO log_id;

    RETURN log_id;
END;
$$;


--
-- Name: FUNCTION log_semantic_search(p_query_text text, p_organization_id uuid, p_user_id uuid, p_results_count integer, p_avg_similarity_score double precision, p_latency_ms integer, p_search_type text, p_filters_applied jsonb); Type: COMMENT; Schema: public; Owner: -
--

COMMENT ON FUNCTION public.log_semantic_search(p_query_text text, p_organization_id uuid, p_user_id uuid, p_results_count integer, p_avg_similarity_score double precision, p_latency_ms integer, p_search_type text, p_filters_applied jsonb) IS 'Log semantic search queries for analytics and performance monitoring.';


--
-- Name: mark_reminder_sent(uuid); Type: FUNCTION; Schema: public; Owner: -
--

CREATE FUNCTION public.mark_reminder_sent(p_appointment_id uuid) RETURNS boolean
    LANGUAGE plpgsql
    AS $$
DECLARE
    v_updated INTEGER;
BEGIN
    UPDATE appointments
    SET 
        reminder_sent_at = NOW(),
        internal_notes = COALESCE(internal_notes, '') || E'\nRecordatorio enviado el ' || NOW()::TEXT
    WHERE id = p_appointment_id
      AND reminder_sent_at IS NULL;
    
    GET DIAGNOSTICS v_updated = ROW_COUNT;
    RETURN v_updated > 0;
END;
$$;


--
-- Name: match_catalog_items(extensions.vector, uuid, text[], uuid, jsonb, numeric, numeric, double precision, integer); Type: FUNCTION; Schema: public; Owner: -
--

CREATE FUNCTION public.match_catalog_items(p_query_embedding extensions.vector, p_organization_id uuid, p_item_types text[] DEFAULT NULL::text[], p_category_id uuid DEFAULT NULL::uuid, p_attributes jsonb DEFAULT NULL::jsonb, p_min_price numeric DEFAULT NULL::numeric, p_max_price numeric DEFAULT NULL::numeric, p_similarity_threshold double precision DEFAULT 0.5, p_limit_count integer DEFAULT 20) RETURNS TABLE(id uuid, item_code character varying, name text, display_name text, item_type character varying, description text, base_price numeric, duration_minutes integer, category_id uuid, attributes jsonb, tags text[], image_url text, similarity double precision, match_quality text)
    LANGUAGE plpgsql STABLE SECURITY DEFINER
    SET search_path TO 'public', 'extensions'
    AS $$
BEGIN
    RETURN QUERY
    SELECT
        ci.id,
        ci.item_code,
        ci.name,
        ci.display_name,
        ci.item_type,
        ci.description,
        ci.base_price,
        ci.duration_minutes,
        ci.category_id,
        ci.attributes,
        ci.tags,
        ci.image_url,
        (1 - (ci.embedding <=> p_query_embedding)) * COALESCE(ci.search_boost, 1.0) AS similarity,
        CASE
            WHEN (1 - (ci.embedding <=> p_query_embedding)) >= 0.85 THEN 'excellent'
            WHEN (1 - (ci.embedding <=> p_query_embedding)) >= 0.75 THEN 'very_good'
            WHEN (1 - (ci.embedding <=> p_query_embedding)) >= 0.65 THEN 'good'
            ELSE 'fair'
        END AS match_quality
    FROM public.catalog_items ci
    WHERE
        ci.organization_id = p_organization_id
        AND ci.is_active = true
        AND ci.deleted_at IS NULL
        AND ci.embedding IS NOT NULL
        AND (1 - (ci.embedding <=> p_query_embedding)) >= p_similarity_threshold
        AND (p_item_types IS NULL OR ci.item_type = ANY(p_item_types))
        AND (p_category_id IS NULL OR ci.category_id = p_category_id)
        AND (p_min_price IS NULL OR ci.base_price >= p_min_price)
        AND (p_max_price IS NULL OR ci.base_price <= p_max_price)
        AND (p_attributes IS NULL OR ci.attributes @> p_attributes)
    ORDER BY similarity DESC
    LIMIT p_limit_count;
END;
$$;


--
-- Name: FUNCTION match_catalog_items(p_query_embedding extensions.vector, p_organization_id uuid, p_item_types text[], p_category_id uuid, p_attributes jsonb, p_min_price numeric, p_max_price numeric, p_similarity_threshold double precision, p_limit_count integer); Type: COMMENT; Schema: public; Owner: -
--

COMMENT ON FUNCTION public.match_catalog_items(p_query_embedding extensions.vector, p_organization_id uuid, p_item_types text[], p_category_id uuid, p_attributes jsonb, p_min_price numeric, p_max_price numeric, p_similarity_threshold double precision, p_limit_count integer) IS 'Primary semantic search function for catalog items with full filtering. Uses pgvector cosine similarity.';


--
-- Name: match_catalog_items_simple(extensions.vector, uuid, double precision, integer, text, uuid); Type: FUNCTION; Schema: public; Owner: -
--

CREATE FUNCTION public.match_catalog_items_simple(p_query_embedding extensions.vector, p_organization_id uuid, p_similarity_threshold double precision DEFAULT 0.5, p_limit_count integer DEFAULT 10, p_item_type text DEFAULT NULL::text, p_category uuid DEFAULT NULL::uuid) RETURNS TABLE(id uuid, name text, item_code character varying, description text, item_type character varying, category_id uuid, base_price numeric, duration_minutes integer, is_active boolean, is_published boolean, tags text[], similarity double precision)
    LANGUAGE plpgsql STABLE SECURITY DEFINER
    SET search_path TO 'public', 'extensions'
    AS $$
BEGIN
    RETURN QUERY
    SELECT
        m.id,
        m.name,
        m.item_code,
        m.description,
        m.item_type,
        m.category_id,
        m.base_price,
        m.duration_minutes,
        true AS is_active,  -- Only active items returned by primary
        true AS is_published,
        m.tags,
        m.similarity
    FROM public.match_catalog_items(
        p_query_embedding,
        p_organization_id,
        CASE WHEN p_item_type IS NOT NULL THEN ARRAY[p_item_type] ELSE NULL END,
        p_category,
        NULL,  -- no attributes filter
        NULL,  -- no min_price
        NULL,  -- no max_price
        p_similarity_threshold,
        p_limit_count
    ) m;
END;
$$;


--
-- Name: FUNCTION match_catalog_items_simple(p_query_embedding extensions.vector, p_organization_id uuid, p_similarity_threshold double precision, p_limit_count integer, p_item_type text, p_category uuid); Type: COMMENT; Schema: public; Owner: -
--

COMMENT ON FUNCTION public.match_catalog_items_simple(p_query_embedding extensions.vector, p_organization_id uuid, p_similarity_threshold double precision, p_limit_count integer, p_item_type text, p_category uuid) IS 'Backward-compatible wrapper for simple semantic search. Calls primary match_catalog_items internally.';


--
-- Name: match_domain_knowledge(extensions.vector, double precision, integer, uuid, text); Type: FUNCTION; Schema: public; Owner: -
--

CREATE FUNCTION public.match_domain_knowledge(query_embedding extensions.vector, match_threshold double precision DEFAULT 0.7, match_count integer DEFAULT 5, p_organization_id uuid DEFAULT NULL::uuid, p_domain text DEFAULT NULL::text) RETURNS TABLE(id uuid, organization_id uuid, domain text, category text, title text, content text, metadata jsonb, created_at timestamp with time zone, similarity double precision)
    LANGUAGE plpgsql
    AS $$
BEGIN
  RETURN QUERY
  SELECT
    dk.id,
    dk.organization_id,
    dk.domain,
    dk.category,
    dk.title,
    dk.content,
    dk.metadata,
    dk.created_at,
    1 - (dk.embedding <=> query_embedding) as similarity
  FROM domain_knowledge dk
  WHERE dk.organization_id = COALESCE(p_organization_id, dk.organization_id)
    AND (p_domain IS NULL OR dk.domain = p_domain)
    AND dk.embedding IS NOT NULL
    AND 1 - (dk.embedding <=> query_embedding) > match_threshold
  ORDER BY dk.embedding <=> query_embedding
  LIMIT match_count;
END;
$$;


--
-- Name: match_domain_knowledge(extensions.vector, uuid, text, double precision, integer); Type: FUNCTION; Schema: public; Owner: -
--

CREATE FUNCTION public.match_domain_knowledge(query_embedding extensions.vector, p_organization_id uuid, p_domain text DEFAULT NULL::text, match_threshold double precision DEFAULT 0.6, match_count integer DEFAULT 3) RETURNS TABLE(id uuid, title text, content text, category text, metadata jsonb, similarity double precision)
    LANGUAGE plpgsql SECURITY DEFINER
    AS $$
BEGIN
  RETURN QUERY
  SELECT 
    dk.id,
    dk.title,
    dk.content,
    dk.category,
    dk.metadata,
    1 - (dk.embedding <=> query_embedding) as similarity
  FROM domain_knowledge dk
  WHERE dk.organization_id = p_organization_id
    AND (p_domain IS NULL OR dk.domain = p_domain)
    AND dk.embedding IS NOT NULL
    AND 1 - (dk.embedding <=> query_embedding) > match_threshold
  ORDER BY dk.embedding <=> query_embedding
  LIMIT match_count;
END;
$$;


--
-- Name: FUNCTION match_domain_knowledge(query_embedding extensions.vector, p_organization_id uuid, p_domain text, match_threshold double precision, match_count integer); Type: COMMENT; Schema: public; Owner: -
--

COMMENT ON FUNCTION public.match_domain_knowledge(query_embedding extensions.vector, p_organization_id uuid, p_domain text, match_threshold double precision, match_count integer) IS 'Búsqueda semántica de knowledge base. Para enriquecer contexto con políticas/guías.';


--
-- Name: match_domain_knowledge_rpc(text, double precision, integer, uuid, text); Type: FUNCTION; Schema: public; Owner: -
--

CREATE FUNCTION public.match_domain_knowledge_rpc(query_embedding_text text, match_threshold double precision DEFAULT 0.7, match_count integer DEFAULT 5, p_organization_id uuid DEFAULT NULL::uuid, p_domain text DEFAULT NULL::text) RETURNS TABLE(id uuid, title text, content text, category text, metadata jsonb, similarity double precision)
    LANGUAGE plpgsql SECURITY DEFINER
    SET search_path TO 'public', 'extensions'
    AS $$
BEGIN
  RETURN QUERY SELECT * FROM match_domain_knowledge(
    query_embedding_text::extensions.vector,
    p_organization_id,
    p_domain,
    match_threshold,
    match_count
  );
END;
$$;


--
-- Name: match_intent_by_embedding(extensions.vector, uuid, integer, double precision); Type: FUNCTION; Schema: public; Owner: -
--

CREATE FUNCTION public.match_intent_by_embedding(p_embedding extensions.vector, p_organization_id uuid DEFAULT NULL::uuid, p_top_k integer DEFAULT 5, p_min_similarity double precision DEFAULT 0.7) RETURNS TABLE(intent text, example_text text, similarity double precision, is_global boolean)
    LANGUAGE plpgsql STABLE
    AS $$
BEGIN
  RETURN QUERY
  SELECT
    e.intent,
    e.example_text,
    1 - (e.embedding <=> p_embedding) as similarity,
    e.organization_id IS NULL as is_global
  FROM nlu_intent_examples e
  WHERE e.is_active = true
    AND e.embedding IS NOT NULL
    -- Include global examples (org_id IS NULL) and org-specific ones
    AND (e.organization_id IS NULL OR e.organization_id = p_organization_id)
  ORDER BY e.embedding <=> p_embedding
  LIMIT p_top_k;
END;
$$;


--
-- Name: match_nlu_keywords(text, text, uuid); Type: FUNCTION; Schema: public; Owner: -
--

CREATE FUNCTION public.match_nlu_keywords(p_text text, p_category text, p_organization_id uuid DEFAULT NULL::uuid) RETURNS TABLE(matched_keyword text, weight double precision, match_position integer)
    LANGUAGE plpgsql STABLE
    AS $$
DECLARE
  normalized_text TEXT;
BEGIN
  normalized_text := lower(trim(p_text));

  RETURN QUERY
  SELECT
    k.keyword,
    k.weight,
    position(k.keyword IN normalized_text)::INT as match_position
  FROM nlu_keywords k
  WHERE k.is_active = true
    AND k.category = p_category
    AND (k.organization_id IS NULL OR k.organization_id = p_organization_id)
    AND normalized_text LIKE '%' || k.keyword || '%'
  ORDER BY k.weight DESC, length(k.keyword) DESC;
END;
$$;


--
-- Name: match_nlu_keywords_batch(text, text[], uuid); Type: FUNCTION; Schema: public; Owner: -
--

CREATE FUNCTION public.match_nlu_keywords_batch(p_text text, p_categories text[], p_organization_id uuid DEFAULT NULL::uuid) RETURNS jsonb
    LANGUAGE plpgsql STABLE
    AS $_$
DECLARE
  normalized_text TEXT;
  result JSONB := '{}';
  cat TEXT;
  matches JSONB;
BEGIN
  normalized_text := lower(trim(p_text));

  FOREACH cat IN ARRAY p_categories LOOP
    SELECT jsonb_agg(jsonb_build_object(
      'keyword', k.keyword,
      'weight', k.weight
    ))
    INTO matches
    FROM nlu_keywords k
    WHERE k.is_active = true
      AND k.category = cat
      AND (k.organization_id IS NULL OR k.organization_id = p_organization_id)
      -- Usar regex con word boundary en lugar de LIKE para evitar falsos positivos
      AND normalized_text ~* ('(^|\s|[^a-záéíóúüñ])' || regexp_replace(k.keyword, '([.+*?^$\[\]{}|()])', '\\\1', 'g') || '(\s|[^a-záéíóúüñ]|$)');

    IF matches IS NOT NULL THEN
      result := result || jsonb_build_object(cat, matches);
    END IF;
  END LOOP;

  RETURN result;
END;
$_$;


--
-- Name: match_providers(extensions.vector, uuid, double precision, integer, uuid, text); Type: FUNCTION; Schema: public; Owner: -
--

CREATE FUNCTION public.match_providers(p_query_embedding extensions.vector, p_organization_id uuid, p_similarity_threshold double precision DEFAULT 0.6, p_limit_count integer DEFAULT 5, p_service_id uuid DEFAULT NULL::uuid, p_specialty text DEFAULT NULL::text) RETURNS TABLE(provider_entity_id uuid, display_name text, service_id uuid, similarity double precision)
    LANGUAGE plpgsql SECURITY DEFINER
    SET search_path TO 'public', 'extensions'
    AS $$
BEGIN
  RETURN QUERY
  SELECT DISTINCT ON (e.id)
    e.id as provider_entity_id,
    e.display_name,
    pss.service_id,
    1 - (e.embedding <=> p_query_embedding) AS similarity
  FROM entities e
  JOIN service_providers sp ON sp.provider_entity_id = e.id
  LEFT JOIN provider_service_slots pss ON pss.provider_entity_id = e.id
  WHERE sp.organization_id = p_organization_id
    AND sp.is_available = true
    AND e.embedding IS NOT NULL
    AND 1 - (e.embedding <=> p_query_embedding) > p_similarity_threshold
    AND (p_service_id IS NULL OR pss.service_id = p_service_id)
    AND (p_specialty IS NULL OR sp.specialty ILIKE '%' || p_specialty || '%')
  ORDER BY e.id, (e.embedding <=> p_query_embedding)
  LIMIT p_limit_count;
END;
$$;


--
-- Name: FUNCTION match_providers(p_query_embedding extensions.vector, p_organization_id uuid, p_similarity_threshold double precision, p_limit_count integer, p_service_id uuid, p_specialty text); Type: COMMENT; Schema: public; Owner: -
--

COMMENT ON FUNCTION public.match_providers(p_query_embedding extensions.vector, p_organization_id uuid, p_similarity_threshold double precision, p_limit_count integer, p_service_id uuid, p_specialty text) IS 'Match service providers using embedding similarity. Includes extensions schema for pgvector operators.';


--
-- Name: match_services(extensions.vector, double precision, integer, uuid, numeric, text); Type: FUNCTION; Schema: public; Owner: -
--

CREATE FUNCTION public.match_services(p_query_embedding extensions.vector, p_similarity_threshold double precision DEFAULT 0.6, p_limit_count integer DEFAULT 10, p_organization_id uuid DEFAULT NULL::uuid, p_max_price_usd numeric DEFAULT NULL::numeric, p_category text DEFAULT NULL::text) RETURNS TABLE(id uuid, code text, name text, description text, category text, duration_minutes integer, base_price_usd numeric, requires_appointment boolean, similarity double precision)
    LANGUAGE plpgsql
    AS $$
BEGIN
  RETURN QUERY
  SELECT
    s.id,
    s.code,
    s.name,
    s.description,
    s.category,
    s.duration_minutes,
    s.base_price_usd,
    s.requires_appointment,
    1 - (s.embedding <=> p_query_embedding) as similarity
  FROM services s
  WHERE s.organization_id = COALESCE(p_organization_id, s.organization_id)
    AND (p_category IS NULL OR s.category = p_category)
    AND (p_max_price_usd IS NULL OR s.base_price_usd <= p_max_price_usd)
    AND s.embedding IS NOT NULL
    AND s.deleted_at IS NULL
    AND 1 - (s.embedding <=> p_query_embedding) > p_similarity_threshold
  ORDER BY s.embedding <=> p_query_embedding
  LIMIT p_limit_count;
END;
$$;


--
-- Name: FUNCTION match_services(p_query_embedding extensions.vector, p_similarity_threshold double precision, p_limit_count integer, p_organization_id uuid, p_max_price_usd numeric, p_category text); Type: COMMENT; Schema: public; Owner: -
--

COMMENT ON FUNCTION public.match_services(p_query_embedding extensions.vector, p_similarity_threshold double precision, p_limit_count integer, p_organization_id uuid, p_max_price_usd numeric, p_category text) IS 'Match services using embedding similarity. Includes extensions schema for pgvector operators.';


--
-- Name: match_vertical_terminology(text, text, uuid, text); Type: FUNCTION; Schema: public; Owner: -
--

CREATE FUNCTION public.match_vertical_terminology(p_text text, p_term_type text, p_organization_id uuid, p_vertical text DEFAULT 'generic'::text) RETURNS TABLE(matched_term text, term_type text)
    LANGUAGE plpgsql STABLE
    AS $$
DECLARE
  normalized_text TEXT;
  terms JSONB;
BEGIN
  normalized_text := lower(trim(p_text));
  terms := get_vertical_terminology(p_organization_id, p_vertical, p_term_type);

  IF terms IS NULL OR jsonb_typeof(terms) != 'array' THEN
    RETURN;
  END IF;

  RETURN QUERY
  SELECT
    t.term::TEXT as matched_term,
    p_term_type as term_type
  FROM jsonb_array_elements_text(terms) as t(term)
  WHERE normalized_text LIKE '%' || t.term || '%';
END;
$$;


--
-- Name: org_knowledge_base; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.org_knowledge_base (
    id uuid DEFAULT gen_random_uuid() NOT NULL,
    organization_id uuid NOT NULL,
    title text NOT NULL,
    content text NOT NULL,
    content_type public.knowledge_content_type DEFAULT 'general_info'::public.knowledge_content_type NOT NULL,
    tags text[] DEFAULT '{}'::text[],
    vertical text,
    language text DEFAULT 'es'::text,
    embedding extensions.vector(1536),
    enabled boolean DEFAULT true,
    priority integer DEFAULT 0,
    valid_from timestamp with time zone,
    valid_until timestamp with time zone,
    created_at timestamp with time zone DEFAULT now(),
    updated_at timestamp with time zone DEFAULT now(),
    created_by uuid,
    has_embedding boolean DEFAULT false
);


--
-- Name: org_knowledge_base_embedding_content(public.org_knowledge_base); Type: FUNCTION; Schema: public; Owner: -
--

CREATE FUNCTION public.org_knowledge_base_embedding_content(kb public.org_knowledge_base) RETURNS text
    LANGUAGE plpgsql STABLE SECURITY DEFINER
    AS $$
DECLARE
  v_org_name text;
  v_content_parts text[];
BEGIN
  SELECT name INTO v_org_name
  FROM organizations
  WHERE id = kb.organization_id;

  v_content_parts := ARRAY[
    format('[ORG: %s | TYPE: %s]', COALESCE(v_org_name, 'Unknown'), kb.content_type)
  ];
  v_content_parts := array_append(v_content_parts, format('Title: %s', kb.title));
  v_content_parts := array_append(v_content_parts, format('Content: %s', kb.content));
  
  IF kb.tags IS NOT NULL AND array_length(kb.tags, 1) > 0 THEN
    v_content_parts := array_append(v_content_parts, format('Tags: %s', array_to_string(kb.tags, ', ')));
  END IF;
  IF kb.vertical IS NOT NULL THEN
    v_content_parts := array_append(v_content_parts, format('Vertical: %s', kb.vertical));
  END IF;
  
  RETURN array_to_string(v_content_parts, ' | ');
END;
$$;


--
-- Name: org_knowledge_base_embedding_content_wrapper(uuid); Type: FUNCTION; Schema: public; Owner: -
--

CREATE FUNCTION public.org_knowledge_base_embedding_content_wrapper(p_id uuid) RETURNS text
    LANGUAGE sql STABLE SECURITY DEFINER
    SET search_path TO 'public'
    AS $$
  SELECT org_knowledge_base_embedding_content(kb) FROM org_knowledge_base kb WHERE kb.id = p_id;
$$;


--
-- Name: patients; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.patients (
    id uuid DEFAULT gen_random_uuid() NOT NULL,
    entity_id uuid NOT NULL,
    organization_id uuid NOT NULL,
    patient_code character varying(50),
    medical_record_number character varying(50),
    external_id character varying(100),
    date_of_birth date NOT NULL,
    preferred_language public.preferred_language DEFAULT 'es'::public.preferred_language,
    marital_status public.marital_status,
    blood_type public.blood_type_enum,
    height_cm numeric(5,2),
    weight_kg numeric(6,2),
    status public.patient_status DEFAULT 'new'::public.patient_status NOT NULL,
    category public.patient_category DEFAULT 'regular'::public.patient_category,
    first_visit_date date,
    last_visit_date date,
    next_appointment_date date,
    insurance_info jsonb DEFAULT '{}'::jsonb,
    medical_history jsonb DEFAULT '[]'::jsonb,
    allergies jsonb DEFAULT '[]'::jsonb,
    current_medications jsonb DEFAULT '[]'::jsonb,
    immunizations jsonb DEFAULT '[]'::jsonb,
    family_history jsonb DEFAULT '[]'::jsonb,
    lifestyle_info jsonb DEFAULT '{}'::jsonb,
    preferences jsonb DEFAULT '{}'::jsonb,
    clinical_notes jsonb DEFAULT '[]'::jsonb,
    alerts jsonb DEFAULT '[]'::jsonb,
    emergency_contacts jsonb DEFAULT '[]'::jsonb,
    ai_risk_assessment jsonb DEFAULT '{}'::jsonb,
    ai_predictions jsonb DEFAULT '{}'::jsonb,
    ai_insights jsonb DEFAULT '{}'::jsonb,
    ai_clinical_insights jsonb DEFAULT '{}'::jsonb,
    ai_treatment_recommendations jsonb DEFAULT '{}'::jsonb,
    ai_appointment_optimization jsonb DEFAULT '{}'::jsonb,
    ai_similar_patients jsonb DEFAULT '{}'::jsonb,
    ai_preventive_care_alerts jsonb DEFAULT '{}'::jsonb,
    ai_cost_predictions jsonb DEFAULT '{}'::jsonb,
    vertical_fields jsonb DEFAULT '{}'::jsonb,
    created_at timestamp with time zone DEFAULT now() NOT NULL,
    created_by uuid,
    updated_at timestamp with time zone DEFAULT now() NOT NULL,
    updated_by uuid,
    deleted_at timestamp with time zone,
    deleted_by uuid,
    embedding extensions.vector(1536),
    has_embedding boolean DEFAULT false,
    gender public.gender_enum,
    addresses jsonb DEFAULT '[]'::jsonb NOT NULL,
    emails jsonb DEFAULT '[]'::jsonb NOT NULL,
    phones jsonb DEFAULT '[]'::jsonb NOT NULL,
    first_name text,
    last_name text,
    photo_url text,
    CONSTRAINT patients_dob_in_past CHECK ((date_of_birth <= CURRENT_DATE)),
    CONSTRAINT patients_height_positive CHECK (((height_cm IS NULL) OR (height_cm > (0)::numeric))),
    CONSTRAINT patients_visit_dates_logical CHECK (((last_visit_date IS NULL) OR (first_visit_date IS NULL) OR (last_visit_date >= first_visit_date))),
    CONSTRAINT patients_weight_positive CHECK (((weight_kg IS NULL) OR (weight_kg > (0)::numeric)))
);


--
-- Name: TABLE patients; Type: COMMENT; Schema: public; Owner: -
--

COMMENT ON TABLE public.patients IS 'Patient records following Entity-Party pattern.
Documents and insurance are stored in normalized tables:
- entity_identification_documents (linked via entity_id)
- entity_insurance_policies (linked via entity_id)

BREAKING CHANGE 2025-12-19: Removed identification_documents and insurance_policies JSONB columns.';


--
-- Name: COLUMN patients.patient_code; Type: COMMENT; Schema: public; Owner: -
--

COMMENT ON COLUMN public.patients.patient_code IS 'Auto-generated unique patient code. Format: {ORG_PREFIX}-{YEAR}-{SEQUENCE}. NOT EDITABLE by users.';


--
-- Name: COLUMN patients.medical_record_number; Type: COMMENT; Schema: public; Owner: -
--

COMMENT ON COLUMN public.patients.medical_record_number IS 'Legacy/external Medical Record Number. For imported data from other systems. Auto-generated patient_code is the primary identifier.';


--
-- Name: COLUMN patients.insurance_info; Type: COMMENT; Schema: public; Owner: -
--

COMMENT ON COLUMN public.patients.insurance_info IS 'Insurance information (primary, secondary, tertiary) - healthcare specific.';


--
-- Name: COLUMN patients.medical_history; Type: COMMENT; Schema: public; Owner: -
--

COMMENT ON COLUMN public.patients.medical_history IS 'Array of medical conditions and diagnoses.';


--
-- Name: COLUMN patients.allergies; Type: COMMENT; Schema: public; Owner: -
--

COMMENT ON COLUMN public.patients.allergies IS 'Array of allergies (medications, food, environmental).';


--
-- Name: COLUMN patients.current_medications; Type: COMMENT; Schema: public; Owner: -
--

COMMENT ON COLUMN public.patients.current_medications IS 'Array of current medications.';


--
-- Name: COLUMN patients.preferences; Type: COMMENT; Schema: public; Owner: -
--

COMMENT ON COLUMN public.patients.preferences IS 'Patient preferences (appointments, communication, products, etc.).';


--
-- Name: COLUMN patients.ai_risk_assessment; Type: COMMENT; Schema: public; Owner: -
--

COMMENT ON COLUMN public.patients.ai_risk_assessment IS 'AI-powered overall health risk assessment.';


--
-- Name: COLUMN patients.ai_clinical_insights; Type: COMMENT; Schema: public; Owner: -
--

COMMENT ON COLUMN public.patients.ai_clinical_insights IS 'AI-detected anomalies, trends, and recommended tests.';


--
-- Name: COLUMN patients.ai_treatment_recommendations; Type: COMMENT; Schema: public; Owner: -
--

COMMENT ON COLUMN public.patients.ai_treatment_recommendations IS 'ML-based treatment and medication suggestions.';


--
-- Name: COLUMN patients.ai_appointment_optimization; Type: COMMENT; Schema: public; Owner: -
--

COMMENT ON COLUMN public.patients.ai_appointment_optimization IS 'AI-optimized appointment scheduling recommendations.';


--
-- Name: COLUMN patients.ai_similar_patients; Type: COMMENT; Schema: public; Owner: -
--

COMMENT ON COLUMN public.patients.ai_similar_patients IS 'Cohort analysis and similar patient benchmarking.';


--
-- Name: COLUMN patients.ai_preventive_care_alerts; Type: COMMENT; Schema: public; Owner: -
--

COMMENT ON COLUMN public.patients.ai_preventive_care_alerts IS 'Proactive screening and vaccination reminders.';


--
-- Name: COLUMN patients.ai_cost_predictions; Type: COMMENT; Schema: public; Owner: -
--

COMMENT ON COLUMN public.patients.ai_cost_predictions IS 'Healthcare cost forecasting and optimization.';


--
-- Name: COLUMN patients.vertical_fields; Type: COMMENT; Schema: public; Owner: -
--

COMMENT ON COLUMN public.patients.vertical_fields IS 'Industry-specific fields (healthcare, beauty, spa, dental, etc.).';


--
-- Name: COLUMN patients.addresses; Type: COMMENT; Schema: public; Owner: -
--

COMMENT ON COLUMN public.patients.addresses IS 'List of patient addresses (home, work, billing). Format: [{type, line1, line2, city, state, postalCode, country, isPrimary}]';


--
-- Name: COLUMN patients.emails; Type: COMMENT; Schema: public; Owner: -
--

COMMENT ON COLUMN public.patients.emails IS 'List of patient emails. Format: [{type, address, isPrimary, isVerified}]';


--
-- Name: COLUMN patients.phones; Type: COMMENT; Schema: public; Owner: -
--

COMMENT ON COLUMN public.patients.phones IS 'List of patient phones. Format: [{type, number, isPrimary, whatsapp, telegram}]';


--
-- Name: patients_embedding_content(public.patients); Type: FUNCTION; Schema: public; Owner: -
--

CREATE FUNCTION public.patients_embedding_content(p public.patients) RETURNS text
    LANGUAGE plpgsql STABLE
    AS $$
DECLARE
  -- Organization and vertical info
  v_org_name text;
  v_vertical_code text;
  v_person_label text;

  -- Patient fields
  v_display_name text;
  v_email text;
  v_phone text;

  -- Content building
  v_content_parts text[];
  v_temp_text text;
  v_key text;
  v_val jsonb;
BEGIN
  -- Get entity and organization data
  SELECT
    o.name,
    COALESCE(ov.code, 'other'),
    COALESCE(ov.terminology_config->>'person_label', 'Person'),
    e.display_name,
    e.email,
    e.phone
  INTO
    v_org_name,
    v_vertical_code,
    v_person_label,
    v_display_name,
    v_email,
    v_phone
  FROM entities e
  JOIN organizations o ON o.id = p.organization_id
  LEFT JOIN organization_verticals ov ON ov.id = o.vertical_id
  WHERE e.id = p.entity_id;

  -- Start with vertical context header
  v_content_parts := ARRAY[format('[VERTICAL: %s | %s]', v_vertical_code, v_org_name)];

  -- Add adapted person label with name
  v_content_parts := array_append(v_content_parts,
    format('%s: %s', v_person_label, COALESCE(v_display_name, 'Unknown'))
  );

  -- Contact information
  IF v_email IS NOT NULL THEN
    v_content_parts := array_append(v_content_parts,
      format('Contact: %s', v_email)
    );
  END IF;

  IF v_phone IS NOT NULL THEN
    v_content_parts := array_append(v_content_parts,
      format('Phone: %s', v_phone)
    );
  END IF;

  -- Patient code
  IF p.patient_code IS NOT NULL THEN
    v_content_parts := array_append(v_content_parts,
      format('Code: %s', p.patient_code)
    );
  END IF;

  -- Category and status (cast enums to text)
  v_content_parts := array_append(v_content_parts,
    format('Category: %s | Status: %s', p.category::text, p.status::text)
  );

  -- Healthcare-specific fields
  IF v_vertical_code IN ('healthcare', 'dental_clinic', 'veterinary') THEN
    
    -- Handle medical_history (can be object or array)
    IF p.medical_history IS NOT NULL THEN
      IF jsonb_typeof(p.medical_history) = 'array' AND jsonb_array_length(p.medical_history) > 0 THEN
        SELECT array_to_string(array_agg(elem::text), ', ') INTO v_temp_text
        FROM jsonb_array_elements_text(p.medical_history) elem;
        v_content_parts := array_append(v_content_parts, format('Medical History: %s', v_temp_text));
        
      ELSIF jsonb_typeof(p.medical_history) = 'object' THEN
        -- Add notes if exists  
        IF p.medical_history ? 'notes' AND p.medical_history->>'notes' IS NOT NULL THEN
          v_content_parts := array_append(v_content_parts,
            format('Medical Notes: %s', p.medical_history->>'notes')
          );
        END IF;
        
        -- Extract conditions if exists
        IF p.medical_history ? 'conditions' AND jsonb_typeof(p.medical_history->'conditions') = 'array' 
           AND jsonb_array_length(p.medical_history->'conditions') > 0 THEN
          SELECT array_to_string(array_agg(elem::text), ', ') INTO v_temp_text
          FROM jsonb_array_elements_text(p.medical_history->'conditions') elem;
          v_content_parts := array_append(v_content_parts, format('Medical Conditions: %s', v_temp_text));
        END IF;
        
        -- Extract surgeries if exists
        IF p.medical_history ? 'surgeries' AND jsonb_typeof(p.medical_history->'surgeries') = 'array' 
           AND jsonb_array_length(p.medical_history->'surgeries') > 0 THEN
          SELECT array_to_string(array_agg(elem::text), ', ') INTO v_temp_text
          FROM jsonb_array_elements_text(p.medical_history->'surgeries') elem;
          v_content_parts := array_append(v_content_parts, format('Surgeries: %s', v_temp_text));
        END IF;
      END IF;
    END IF;

    -- Allergies (should be array)
    IF p.allergies IS NOT NULL AND jsonb_typeof(p.allergies) = 'array' AND jsonb_array_length(p.allergies) > 0 THEN
      SELECT array_to_string(array_agg(elem::text), ', ') INTO v_temp_text
      FROM jsonb_array_elements_text(p.allergies) elem;
      v_content_parts := array_append(v_content_parts, format('Allergies: %s', v_temp_text));
    END IF;

    -- Current medications (should be array)
    IF p.current_medications IS NOT NULL AND jsonb_typeof(p.current_medications) = 'array' AND jsonb_array_length(p.current_medications) > 0 THEN
      SELECT array_to_string(array_agg(elem::text), ', ') INTO v_temp_text
      FROM jsonb_array_elements_text(p.current_medications) elem;
      v_content_parts := array_append(v_content_parts, format('Medications: %s', v_temp_text));
    END IF;

    -- Blood type
    IF p.blood_type IS NOT NULL THEN
      v_content_parts := array_append(v_content_parts,
        format('Blood Type: %s', p.blood_type)
      );
    END IF;
  END IF;

  -- Vertical fields (custom fields)
  IF p.vertical_fields IS NOT NULL AND jsonb_typeof(p.vertical_fields) = 'object' THEN
    FOR v_key, v_val IN SELECT * FROM jsonb_each(p.vertical_fields)
    LOOP
      IF v_val IS NOT NULL AND v_val::text != 'null' AND v_val::text != '""' THEN
        v_content_parts := array_append(v_content_parts,
          format('%s: %s', initcap(replace(v_key, '_', ' ')), v_val::text)
        );
      END IF;
    END LOOP;
  END IF;

  -- Return combined content
  RETURN array_to_string(v_content_parts, E'\n');
END;
$$;


--
-- Name: FUNCTION patients_embedding_content(p public.patients); Type: COMMENT; Schema: public; Owner: -
--

COMMENT ON FUNCTION public.patients_embedding_content(p public.patients) IS 'Generates embedding content for a patient. Handles medical_history as both array and object.';


--
-- Name: process_pending_reminders(integer); Type: FUNCTION; Schema: public; Owner: -
--

CREATE FUNCTION public.process_pending_reminders(p_hours_ahead integer DEFAULT 24) RETURNS TABLE(processed_count integer, appointments_data jsonb)
    LANGUAGE plpgsql
    AS $$
DECLARE
    v_count INTEGER := 0;
    v_data JSONB := '[]'::JSONB;
    v_row RECORD;
BEGIN
    -- Obtener todas las citas pendientes de recordatorio
    FOR v_row IN 
        SELECT * FROM get_appointments_pending_reminder(p_hours_ahead)
    LOOP
        -- Agregar al array JSON
        v_data := v_data || jsonb_build_array(jsonb_build_object(
            'appointment_id', v_row.appointment_id,
            'organization_id', v_row.organization_id,
            'organization_name', v_row.organization_name,
            'appointment_date', v_row.appointment_date,
            'start_time', v_row.start_time,
            'service', v_row.catalog_item_name,
            'client_id', v_row.client_id,
            'client_name', v_row.client_name,
            'client_phone', v_row.client_phone,
            'provider_name', v_row.provider_name,
            'message', v_row.reminder_message
        ));
        
        v_count := v_count + 1;
    END LOOP;
    
    -- Insertar en tabla de log de notificaciones pendientes
    IF v_count > 0 THEN
        INSERT INTO notification_queue (id, payload, created_at, status)
        VALUES (gen_random_uuid(), v_data, NOW(), 'pending')
        ON CONFLICT DO NOTHING;
    END IF;
    
    processed_count := v_count;
    appointments_data := v_data;
    RETURN NEXT;
END;
$$;


--
-- Name: proficiency_to_int(public.proficiency_level); Type: FUNCTION; Schema: public; Owner: -
--

CREATE FUNCTION public.proficiency_to_int(p public.proficiency_level) RETURNS integer
    LANGUAGE sql IMMUTABLE
    AS $$
  SELECT CASE p
    WHEN 'trainee' THEN 1
    WHEN 'junior' THEN 2
    WHEN 'intermediate' THEN 3
    WHEN 'senior' THEN 4
    WHEN 'expert' THEN 5
    WHEN 'master' THEN 6
  END;
$$;


--
-- Name: promotions_update_embedding_text(); Type: FUNCTION; Schema: public; Owner: -
--

CREATE FUNCTION public.promotions_update_embedding_text() RETURNS trigger
    LANGUAGE plpgsql
    AS $$
BEGIN
    NEW.embedding_text := COALESCE(NEW.name, '') || ' ' ||
                          COALESCE(NEW.description, '') || ' ' ||
                          COALESCE(NEW.ai_summary, '') || ' ' ||
                          COALESCE(NEW.promo_code, '') || ' ' ||
                          COALESCE(array_to_string(NEW.ai_keywords, ' '), '');
    RETURN NEW;
END;
$$;


--
-- Name: queue_appointment_embedding(); Type: FUNCTION; Schema: public; Owner: -
--

CREATE FUNCTION public.queue_appointment_embedding() RETURNS trigger
    LANGUAGE plpgsql SECURITY DEFINER
    AS $$
BEGIN
    INSERT INTO public.ai_embedding_queue (
        source_table,
        source_id,
        organization_id,
        content,
        status
    ) VALUES (
        'appointments',
        NEW.id,
        NEW.organization_id,
        -- Build searchable content
        CONCAT_WS(' ',
            'Appointment on', NEW.appointment_date::text,
            'at', NEW.start_time::text,
            'Status:', NEW.status::text,
            'Provider type:', NEW.provider_type::text,
            COALESCE('Notes: ' || NEW.notes, '')
        ),
        'pending'
    )
    ON CONFLICT (source_table, source_id, organization_id)
    DO UPDATE SET
        content = EXCLUDED.content,
        status = 'pending',
        updated_at = now();

    RETURN NEW;
END;
$$;


--
-- Name: FUNCTION queue_appointment_embedding(); Type: COMMENT; Schema: public; Owner: -
--

COMMENT ON FUNCTION public.queue_appointment_embedding() IS 'Automatically queue appointments for embedding generation';


--
-- Name: queue_time_summary_recalculation(); Type: FUNCTION; Schema: public; Owner: -
--

CREATE FUNCTION public.queue_time_summary_recalculation() RETURNS trigger
    LANGUAGE plpgsql
    AS $$
BEGIN
    -- For inserts and updates, recalculate for the entry date
    IF TG_OP = 'INSERT' OR TG_OP = 'UPDATE' THEN
        -- Mark existing summary as needing recalculation
        UPDATE daily_time_summary
        SET status = 'pending'
        WHERE employee_id = NEW.employee_id
        AND summary_date = NEW.entry_date
        AND status NOT IN ('finalized', 'paid');

        -- Optionally trigger immediate recalculation
        -- PERFORM calculate_daily_time_summary(NEW.employee_id, NEW.entry_date);

        RETURN NEW;
    END IF;

    RETURN NULL;
END;
$$;


--
-- Name: recalculate_walkin_queue_positions(uuid); Type: FUNCTION; Schema: public; Owner: -
--

CREATE FUNCTION public.recalculate_walkin_queue_positions(p_location_id uuid) RETURNS void
    LANGUAGE plpgsql SECURITY DEFINER
    AS $$
BEGIN
  WITH ranked AS (
    SELECT id, ROW_NUMBER() OVER (ORDER BY arrived_at) AS new_position
    FROM walkin_entries
    WHERE location_id = p_location_id AND status = 'waiting'
  )
  UPDATE walkin_entries w
  SET queue_position = r.new_position
  FROM ranked r
  WHERE w.id = r.id;
END;
$$;


--
-- Name: record_time_entry(uuid, public.time_entry_type, public.time_entry_source, public.verification_method, jsonb, text, timestamp with time zone); Type: FUNCTION; Schema: public; Owner: -
--

CREATE FUNCTION public.record_time_entry(p_employee_id uuid, p_entry_type public.time_entry_type, p_source public.time_entry_source DEFAULT 'web'::public.time_entry_source, p_verification_method public.verification_method DEFAULT 'none'::public.verification_method, p_location_data jsonb DEFAULT NULL::jsonb, p_notes text DEFAULT NULL::text, p_timestamp timestamp with time zone DEFAULT now()) RETURNS uuid
    LANGUAGE plpgsql SECURITY DEFINER
    AS $$
DECLARE
    v_org_id UUID;
    v_entry_id UUID;
BEGIN
    -- Get organization
    SELECT organization_id INTO v_org_id
    FROM employees
    WHERE id = p_employee_id AND deleted_at IS NULL;

    IF v_org_id IS NULL THEN
        RAISE EXCEPTION 'Employee not found or inactive';
    END IF;

    -- Insert time entry
    INSERT INTO time_entries (
        organization_id,
        employee_id,
        entry_timestamp,
        entry_type,
        source,
        verification_method,
        location_data,
        notes,
        created_by
    ) VALUES (
        v_org_id,
        p_employee_id,
        p_timestamp,
        p_entry_type,
        p_source,
        p_verification_method,
        p_location_data,
        p_notes,
        auth.uid()
    ) RETURNING id INTO v_entry_id;

    RETURN v_entry_id;
END;
$$;


--
-- Name: remove_member(uuid); Type: FUNCTION; Schema: public; Owner: -
--

CREATE FUNCTION public.remove_member(p_membership_id uuid) RETURNS jsonb
    LANGUAGE plpgsql SECURITY DEFINER
    SET search_path TO 'public'
    AS $$
DECLARE
  v_membership public.memberships%ROWTYPE;
  v_caller_membership public.memberships%ROWTYPE;
  v_caller_role_level INT;
  v_target_role_level INT;
BEGIN
  -- Get target membership
  SELECT * INTO v_membership
  FROM public.memberships
  WHERE id = p_membership_id;
  
  IF NOT FOUND THEN
    RETURN jsonb_build_object('success', false, 'error', 'Membership not found');
  END IF;

  -- Get caller's membership in same org
  SELECT * INTO v_caller_membership
  FROM public.memberships
  WHERE organization_id = v_membership.organization_id
    AND user_id = auth.uid();
  
  IF NOT FOUND THEN
    RETURN jsonb_build_object('success', false, 'error', 'You are not a member of this organization');
  END IF;

  -- Get role levels
  SELECT level INTO v_caller_role_level FROM public.roles WHERE key = v_caller_membership.role_key;
  SELECT level INTO v_target_role_level FROM public.roles WHERE key = v_membership.role_key;

  -- Validate: Cannot remove yourself
  IF v_membership.user_id = auth.uid() THEN
    RETURN jsonb_build_object('success', false, 'error', 'Cannot remove yourself. Transfer ownership first.');
  END IF;

  -- Validate: Must be admin or owner
  IF v_caller_role_level < 80 THEN
    RETURN jsonb_build_object('success', false, 'error', 'Only admins and owners can remove members');
  END IF;

  -- Validate: Cannot remove someone with equal or higher level
  IF v_target_role_level >= v_caller_role_level THEN
    RETURN jsonb_build_object('success', false, 'error', 'Cannot remove someone with equal or higher level');
  END IF;

  -- Delete membership
  DELETE FROM public.memberships WHERE id = p_membership_id;

  RETURN jsonb_build_object(
    'success', true,
    'removed_membership_id', p_membership_id
  );
END;
$$;


--
-- Name: resolve_client_by_phone(uuid, text); Type: FUNCTION; Schema: public; Owner: -
--

CREATE FUNCTION public.resolve_client_by_phone(p_organization_id uuid, p_phone text) RETURNS TABLE(client_id uuid, client_name text, is_new boolean)
    LANGUAGE plpgsql STABLE
    AS $$
DECLARE
    v_config jsonb;
    v_normalized_phone text;
BEGIN
    -- Get client resolution config
    v_config := get_client_resolution_config(p_organization_id);

    -- Normalize phone (remove non-digits)
    v_normalized_phone := regexp_replace(p_phone, '[^0-9]', '', 'g');

    -- Try to find existing client by phone or mobile
    -- Using 'patient' for healthcare and 'client' for beauty/retail
    RETURN QUERY
    SELECT
        e.id as client_id,
        COALESCE(e.display_name, e.legal_name, 'Cliente') as client_name,
        false as is_new
    FROM entities e
    WHERE e.organization_id = p_organization_id
      AND e.entity_type = 'person'
      AND e.person_subtype::text IN ('client', 'patient')
      AND e.status = 'active'
      AND (
          -- Match phone field
          regexp_replace(COALESCE(e.phone, ''), '[^0-9]', '', 'g') = v_normalized_phone
          OR RIGHT(regexp_replace(COALESCE(e.phone, ''), '[^0-9]', '', 'g'), 10) = RIGHT(v_normalized_phone, 10)
          -- Match mobile field
          OR regexp_replace(COALESCE(e.mobile, ''), '[^0-9]', '', 'g') = v_normalized_phone
          OR RIGHT(regexp_replace(COALESCE(e.mobile, ''), '[^0-9]', '', 'g'), 10) = RIGHT(v_normalized_phone, 10)
      )
    LIMIT 1;

    -- If no rows returned, indicate new client if config allows
    IF NOT FOUND THEN
        IF (v_config->>'create_client_on_unknown')::boolean THEN
            RETURN QUERY SELECT NULL::uuid, NULL::text, true;
        END IF;
    END IF;
END;
$$;


--
-- Name: FUNCTION resolve_client_by_phone(p_organization_id uuid, p_phone text); Type: COMMENT; Schema: public; Owner: -
--

COMMENT ON FUNCTION public.resolve_client_by_phone(p_organization_id uuid, p_phone text) IS 'Resolve client entity by phone number with organization-specific rules';


--
-- Name: resolve_entity_synonym(character varying, character varying, uuid, character varying, character varying, character varying); Type: FUNCTION; Schema: public; Owner: -
--

CREATE FUNCTION public.resolve_entity_synonym(p_input_text character varying, p_entity_type character varying, p_organization_id uuid DEFAULT NULL::uuid, p_vertical_code character varying DEFAULT NULL::character varying, p_channel character varying DEFAULT NULL::character varying, p_language character varying DEFAULT 'es'::character varying) RETURNS TABLE(canonical_value character varying, canonical_id uuid, match_type character varying, confidence numeric, is_special_token boolean, metadata jsonb)
    LANGUAGE plpgsql SECURITY DEFINER
    SET search_path TO 'public'
    AS $$
DECLARE
    v_normalized_input varchar;
BEGIN
    -- Normalize input
    v_normalized_input := lower(trim(p_input_text));
    
    RETURN QUERY
    SELECT 
        es.canonical_value,
        es.canonical_id,
        es.match_type,
        -- Calculate confidence score
        (
            es.weight * 
            CASE 
                WHEN es.organization_id = p_organization_id THEN 1.5
                WHEN es.organization_id IS NULL THEN 1.0
                ELSE 0.5
            END *
            CASE
                WHEN es.match_type = 'exact' AND v_normalized_input = es.synonym THEN 1.0
                WHEN es.match_type = 'prefix' AND v_normalized_input LIKE es.synonym || '%' THEN 0.9
                WHEN es.match_type = 'contains' AND v_normalized_input LIKE '%' || es.synonym || '%' THEN 0.7
                ELSE 0.5
            END
        )::decimal AS confidence,
        es.is_special_token,
        jsonb_build_object(
            'matched_synonym', es.synonym,
            'category', es.category,
            'context_hints', es.context_hints
        ) AS metadata
    FROM entity_synonyms es
    WHERE 
        es.enabled = true
        AND es.entity_type = p_entity_type
        AND (es.organization_id IS NULL OR es.organization_id = p_organization_id)
        AND (es.vertical_code IS NULL OR es.vertical_code = p_vertical_code)
        AND (es.channel IS NULL OR es.channel = p_channel)
        AND (es.language IS NULL OR es.language = p_language)
        AND (
            -- Match based on match_type
            (es.match_type = 'exact' AND (
                (NOT es.case_sensitive AND lower(es.synonym) = v_normalized_input) OR
                (es.case_sensitive AND es.synonym = p_input_text)
            ))
            OR (es.match_type = 'prefix' AND v_normalized_input LIKE lower(es.synonym) || '%')
            OR (es.match_type = 'contains' AND v_normalized_input LIKE '%' || lower(es.synonym) || '%')
        )
    ORDER BY 
        confidence DESC,
        es.priority DESC,
        es.organization_id NULLS LAST  -- Org-specific first
    LIMIT 1;
END;
$$;


--
-- Name: FUNCTION resolve_entity_synonym(p_input_text character varying, p_entity_type character varying, p_organization_id uuid, p_vertical_code character varying, p_channel character varying, p_language character varying); Type: COMMENT; Schema: public; Owner: -
--

COMMENT ON FUNCTION public.resolve_entity_synonym(p_input_text character varying, p_entity_type character varying, p_organization_id uuid, p_vertical_code character varying, p_channel character varying, p_language character varying) IS 'Resolves an input text to its canonical entity value.
Supports exact, prefix, and contains matching with confidence scoring.
Organization-specific synonyms take priority over global ones.';


--
-- Name: resolve_entity_synonyms_batch(jsonb, uuid, character varying, character varying); Type: FUNCTION; Schema: public; Owner: -
--

CREATE FUNCTION public.resolve_entity_synonyms_batch(p_inputs jsonb, p_organization_id uuid DEFAULT NULL::uuid, p_vertical_code character varying DEFAULT NULL::character varying, p_channel character varying DEFAULT NULL::character varying) RETURNS jsonb
    LANGUAGE plpgsql SECURITY DEFINER
    SET search_path TO 'public'
    AS $$
DECLARE
    v_input jsonb;
    v_result jsonb := '[]'::jsonb;
    v_resolved record;
BEGIN
    FOR v_input IN SELECT * FROM jsonb_array_elements(p_inputs)
    LOOP
        SELECT * INTO v_resolved
        FROM resolve_entity_synonym(
            v_input->>'text',
            v_input->>'type',
            p_organization_id,
            p_vertical_code,
            p_channel
        );
        
        IF v_resolved.canonical_value IS NOT NULL THEN
            v_result := v_result || jsonb_build_object(
                'input', v_input->>'text',
                'type', v_input->>'type',
                'resolved', v_resolved.canonical_value,
                'canonical_id', v_resolved.canonical_id,
                'confidence', v_resolved.confidence,
                'is_special_token', v_resolved.is_special_token
            );
        ELSE
            v_result := v_result || jsonb_build_object(
                'input', v_input->>'text',
                'type', v_input->>'type',
                'resolved', NULL,
                'confidence', 0
            );
        END IF;
    END LOOP;
    
    RETURN v_result;
END;
$$;


--
-- Name: resolve_slot_value(uuid, text, text, text); Type: FUNCTION; Schema: public; Owner: -
--

CREATE FUNCTION public.resolve_slot_value(p_organization_id uuid, p_slot_name text, p_search_value text, p_channel_user_id text DEFAULT NULL::text) RETURNS TABLE(resolved_id uuid, resolved_name text, resolved_type text, confidence numeric, alternatives jsonb)
    LANGUAGE plpgsql STABLE
    AS $$
DECLARE
    v_normalized_phone text;
    v_search_lower text;
BEGIN
    v_search_lower := lower(trim(COALESCE(p_search_value, '')));

    -- Route to appropriate resolver based on slot type
    CASE p_slot_name
        -- CLIENT/PATIENT resolution
        WHEN 'client', 'client_name', 'patient', 'patient_name' THEN
            -- First try by phone if channel_user_id provided
            IF p_channel_user_id IS NOT NULL THEN
                v_normalized_phone := regexp_replace(p_channel_user_id, '[^0-9]', '', 'g');

                RETURN QUERY
                SELECT
                    e.id,
                    COALESCE(e.display_name, e.legal_name, 'Cliente'),
                    'entity'::text,
                    1.0::numeric,
                    NULL::jsonb
                FROM entities e
                WHERE e.organization_id = p_organization_id
                  AND e.entity_type = 'person'
                  AND e.person_subtype::text IN ('client', 'patient')
                  AND e.status = 'active'
                  AND (
                      regexp_replace(COALESCE(e.phone, ''), '[^0-9]', '', 'g') = v_normalized_phone
                      OR RIGHT(regexp_replace(COALESCE(e.phone, ''), '[^0-9]', '', 'g'), 10) = RIGHT(v_normalized_phone, 10)
                      OR regexp_replace(COALESCE(e.mobile, ''), '[^0-9]', '', 'g') = v_normalized_phone
                      OR RIGHT(regexp_replace(COALESCE(e.mobile, ''), '[^0-9]', '', 'g'), 10) = RIGHT(v_normalized_phone, 10)
                  )
                LIMIT 1;

                IF FOUND THEN RETURN; END IF;
            END IF;

            -- Then try by name if search value provided
            IF p_search_value IS NOT NULL AND p_search_value != '' THEN
                RETURN QUERY
                SELECT
                    e.id,
                    COALESCE(e.display_name, e.legal_name),
                    'entity'::text,
                    similarity(lower(COALESCE(e.display_name, e.legal_name, '')), v_search_lower)::numeric,
                    NULL::jsonb
                FROM entities e
                WHERE e.organization_id = p_organization_id
                  AND e.entity_type = 'person'
                  AND e.person_subtype::text IN ('client', 'patient')
                  AND e.status = 'active'
                  AND (
                      lower(e.display_name) LIKE '%' || v_search_lower || '%'
                      OR lower(e.legal_name) LIKE '%' || v_search_lower || '%'
                  )
                ORDER BY similarity(lower(COALESCE(e.display_name, e.legal_name, '')), v_search_lower) DESC
                LIMIT 1;

                IF FOUND THEN RETURN; END IF;
            END IF;

            -- Not found - return 'new' indicator
            RETURN QUERY SELECT NULL::uuid, p_search_value, 'new'::text, 0::numeric, NULL::jsonb;

        -- PROVIDER/DOCTOR/EMPLOYEE resolution
        WHEN 'provider', 'provider_name', 'doctor', 'stylist', 'employee' THEN
            RETURN QUERY
            SELECT
                e.id,
                COALESCE(e.display_name, e.legal_name),
                'entity'::text,
                similarity(lower(COALESCE(e.display_name, e.legal_name, '')), v_search_lower)::numeric,
                (SELECT jsonb_agg(jsonb_build_object('id', alt.id, 'name', COALESCE(alt.display_name, alt.legal_name)))
                 FROM entities alt
                 WHERE alt.organization_id = p_organization_id
                   AND alt.entity_type = 'person'
                   AND alt.person_subtype::text IN ('doctor', 'nurse', 'employee', 'technician', 'therapist')
                   AND alt.status = 'active'
                   AND alt.id != e.id
                   AND (lower(alt.display_name) LIKE '%' || v_search_lower || '%' OR lower(alt.legal_name) LIKE '%' || v_search_lower || '%')
                 LIMIT 3
                )
            FROM entities e
            WHERE e.organization_id = p_organization_id
              AND e.entity_type = 'person'
              AND e.person_subtype::text IN ('doctor', 'nurse', 'employee', 'technician', 'therapist')
              AND e.status = 'active'
              AND (
                  lower(e.display_name) LIKE '%' || v_search_lower || '%'
                  OR lower(e.legal_name) LIKE '%' || v_search_lower || '%'
              )
            ORDER BY similarity(lower(COALESCE(e.display_name, e.legal_name, '')), v_search_lower) DESC
            LIMIT 1;

        -- SERVICE/PRODUCT resolution from catalog_items
        WHEN 'service', 'service_name', 'product', 'item' THEN
            RETURN QUERY
            SELECT
                ci.id,
                COALESCE(ci.display_name, ci.name),
                'catalog_item'::text,
                similarity(lower(COALESCE(ci.display_name, ci.name, '')), v_search_lower)::numeric,
                (SELECT jsonb_agg(jsonb_build_object('id', alt.id, 'name', COALESCE(alt.display_name, alt.name)))
                 FROM catalog_items alt
                 WHERE alt.organization_id = p_organization_id
                   AND alt.is_active = true
                   AND alt.id != ci.id
                   AND (lower(alt.name) LIKE '%' || v_search_lower || '%' OR lower(alt.display_name) LIKE '%' || v_search_lower || '%')
                 LIMIT 3
                )
            FROM catalog_items ci
            WHERE ci.organization_id = p_organization_id
              AND ci.is_active = true
              AND (ci.is_bookable = true OR p_slot_name = 'product')
              AND (
                  lower(ci.name) LIKE '%' || v_search_lower || '%'
                  OR lower(ci.display_name) LIKE '%' || v_search_lower || '%'
                  OR v_search_lower = ANY(SELECT lower(unnest(ci.ai_keywords)))
              )
            ORDER BY similarity(lower(COALESCE(ci.display_name, ci.name, '')), v_search_lower) DESC
            LIMIT 1;

        ELSE
            -- Unknown slot type - return null
            RETURN QUERY SELECT NULL::uuid, NULL::text, NULL::text, 0::numeric, NULL::jsonb;
    END CASE;
END;
$$;


--
-- Name: FUNCTION resolve_slot_value(p_organization_id uuid, p_slot_name text, p_search_value text, p_channel_user_id text); Type: COMMENT; Schema: public; Owner: -
--

COMMENT ON FUNCTION public.resolve_slot_value(p_organization_id uuid, p_slot_name text, p_search_value text, p_channel_user_id text) IS 'Generic slot resolver - resolves client/provider/service values to entity/catalog IDs';


--
-- Name: resource_can_provide(uuid, uuid, integer, time without time zone, text); Type: FUNCTION; Schema: public; Owner: -
--

CREATE FUNCTION public.resource_can_provide(p_resource_entity_id uuid, p_catalog_item_id uuid, p_check_day integer DEFAULT NULL::integer, p_check_time time without time zone DEFAULT NULL::time without time zone, p_check_timezone text DEFAULT 'America/Santo_Domingo'::text) RETURNS TABLE(can_provide boolean, capability_id uuid, custom_duration interval, custom_price numeric, currency_code character, proficiency_level public.proficiency_level, proficiency_score smallint, reason text)
    LANGUAGE plpgsql STABLE SECURITY DEFINER
    AS $$
DECLARE
  v_capability RECORD;
  v_has_availability BOOLEAN;
BEGIN
  -- Get current capability
  SELECT * INTO v_capability
  FROM public.resource_capabilities rc
  WHERE rc.resource_entity_id = p_resource_entity_id
    AND rc.catalog_item_id = p_catalog_item_id
    AND rc.is_active = true
    AND rc.deleted_at IS NULL
    AND rc.valid_from <= now()
    AND (rc.valid_until IS NULL OR rc.valid_until > now());

  -- No capability found
  IF NOT FOUND THEN
    RETURN QUERY SELECT
      false::BOOLEAN,
      NULL::UUID,
      NULL::INTERVAL,
      NULL::NUMERIC(18,4),
      NULL::CHAR(3),
      NULL::proficiency_level,
      NULL::SMALLINT,
      'Resource does not have this capability'::TEXT;
    RETURN;
  END IF;

  -- If no day/time specified, just check capability exists
  IF p_check_day IS NULL AND p_check_time IS NULL THEN
    RETURN QUERY SELECT
      true::BOOLEAN,
      v_capability.id,
      v_capability.custom_duration,
      v_capability.custom_price,
      v_capability.currency_code,
      v_capability.proficiency_level,
      v_capability.proficiency_score,
      'OK'::TEXT;
    RETURN;
  END IF;

  -- Check availability slots
  SELECT EXISTS(
    SELECT 1
    FROM public.resource_capability_availability rca
    WHERE rca.capability_id = v_capability.id
      AND rca.is_active = true
      AND (p_check_day IS NULL OR p_check_day = ANY(rca.days_of_week))
      AND (p_check_time IS NULL OR (p_check_time >= rca.time_from AND p_check_time <= rca.time_until))
  ) INTO v_has_availability;

  -- No availability defined = available any time
  IF NOT EXISTS(
    SELECT 1 FROM public.resource_capability_availability rca2
    WHERE rca2.capability_id = v_capability.id AND rca2.is_active = true
  ) THEN
    v_has_availability := true;
  END IF;

  IF NOT v_has_availability THEN
    RETURN QUERY SELECT
      false::BOOLEAN,
      v_capability.id,
      v_capability.custom_duration,
      v_capability.custom_price,
      v_capability.currency_code,
      v_capability.proficiency_level,
      v_capability.proficiency_score,
      'Resource is not available at this day/time for this service'::TEXT;
    RETURN;
  END IF;

  -- All checks passed
  RETURN QUERY SELECT
    true::BOOLEAN,
    v_capability.id,
    v_capability.custom_duration,
    v_capability.custom_price,
    v_capability.currency_code,
    v_capability.proficiency_level,
    v_capability.proficiency_score,
    'OK'::TEXT;
END;
$$;


--
-- Name: FUNCTION resource_can_provide(p_resource_entity_id uuid, p_catalog_item_id uuid, p_check_day integer, p_check_time time without time zone, p_check_timezone text); Type: COMMENT; Schema: public; Owner: -
--

COMMENT ON FUNCTION public.resource_can_provide(p_resource_entity_id uuid, p_catalog_item_id uuid, p_check_day integer, p_check_time time without time zone, p_check_timezone text) IS 'Check if a resource can provide a catalog item at a specific day/time. Returns capability details.';


--
-- Name: restore_patient(uuid); Type: FUNCTION; Schema: public; Owner: -
--

CREATE FUNCTION public.restore_patient(p_patient_id uuid) RETURNS boolean
    LANGUAGE plpgsql SECURITY DEFINER
    AS $$
DECLARE
    v_affected_rows integer;
BEGIN
    UPDATE patients
    SET
        deleted_at = NULL,
        deleted_by = NULL,
        updated_at = now(),
        updated_by = auth.uid()
    WHERE id = p_patient_id
      AND deleted_at IS NOT NULL;

    GET DIAGNOSTICS v_affected_rows = ROW_COUNT;

    RETURN v_affected_rows > 0;
END;
$$;


--
-- Name: FUNCTION restore_patient(p_patient_id uuid); Type: COMMENT; Schema: public; Owner: -
--

COMMENT ON FUNCTION public.restore_patient(p_patient_id uuid) IS 'Restore a soft-deleted patient (clear deleted_at timestamp).
Returns true if patient was restored, false if not found or not deleted.';


--
-- Name: role_has_permission(text, text, text); Type: FUNCTION; Schema: public; Owner: -
--

CREATE FUNCTION public.role_has_permission(p_role_key text, p_resource text, p_action text) RETURNS boolean
    LANGUAGE plpgsql STABLE SECURITY DEFINER
    AS $$
DECLARE
    v_permissions JSONB;
    v_resource_perms JSONB;
    v_permission TEXT;
BEGIN
    SELECT permissions INTO v_permissions
    FROM public.roles WHERE key = p_role_key;

    IF v_permissions IS NULL THEN RETURN FALSE; END IF;
    IF v_permissions->>'all' = 'true' THEN RETURN TRUE; END IF;

    v_resource_perms := v_permissions->p_resource;
    IF v_resource_perms IS NULL THEN RETURN FALSE; END IF;

    v_permission := v_resource_perms->>p_action;
    RETURN v_permission IN ('true', 'all', 'own', 'limited', 'reports_only', 'booking_only');
END;
$$;


--
-- Name: score_intents_by_signals(text, uuid); Type: FUNCTION; Schema: public; Owner: -
--

CREATE FUNCTION public.score_intents_by_signals(p_text text, p_organization_id uuid DEFAULT NULL::uuid) RETURNS TABLE(intent text, score double precision, matched_signals jsonb, has_required boolean, has_negative boolean)
    LANGUAGE plpgsql STABLE
    AS $$
DECLARE
  normalized_text TEXT;
BEGIN
  normalized_text := lower(trim(p_text));

  RETURN QUERY
  WITH signal_matches AS (
    SELECT
      s.intent,
      s.signal_type,
      s.signal_value,
      s.weight,
      s.is_required,
      s.is_negative,
      s.priority,
      CASE
        WHEN s.signal_type = 'keyword' THEN
          normalized_text ~ ('\y' || s.signal_value || '\y')
        WHEN s.signal_type = 'phrase' THEN
          normalized_text LIKE '%' || s.signal_value || '%'
        WHEN s.signal_type = 'pattern' THEN
          normalized_text ~ s.signal_value
        ELSE false
      END as is_matched
    FROM nlu_intent_signals s
    WHERE s.is_active = true
      AND (s.organization_id IS NULL OR s.organization_id = p_organization_id)
  ),
  intent_scores AS (
    SELECT
      m.intent,
      SUM(CASE WHEN m.is_matched AND NOT m.is_negative THEN m.weight ELSE 0 END) as total_score,
      jsonb_agg(
        CASE WHEN m.is_matched THEN
          jsonb_build_object(
            'type', m.signal_type,
            'value', m.signal_value,
            'weight', m.weight,
            'negative', m.is_negative
          )
        ELSE NULL END
      ) FILTER (WHERE m.is_matched) as matches,
      -- Check if all required signals are matched
      bool_and(
        CASE WHEN m.is_required THEN m.is_matched ELSE true END
      ) as all_required_matched,
      -- Check if any negative signal is matched
      bool_or(
        m.is_matched AND m.is_negative
      ) as any_negative_matched,
      MAX(m.priority) as max_priority
    FROM signal_matches m
    GROUP BY m.intent
  )
  SELECT
    i.intent,
    CASE
      WHEN NOT i.all_required_matched THEN 0
      WHEN i.any_negative_matched THEN 0
      ELSE i.total_score
    END as score,
    COALESCE(i.matches, '[]'::jsonb) as matched_signals,
    i.all_required_matched as has_required,
    i.any_negative_matched as has_negative
  FROM intent_scores i
  WHERE i.total_score > 0 OR i.any_negative_matched
  ORDER BY
    CASE WHEN i.any_negative_matched THEN 0 ELSE 1 END DESC,
    i.max_priority DESC,
    i.total_score DESC;
END;
$$;


--
-- Name: search_appointments(uuid, extensions.vector, double precision, integer, text[], date, date); Type: FUNCTION; Schema: public; Owner: -
--

CREATE FUNCTION public.search_appointments(p_organization_id uuid, p_query_embedding extensions.vector, p_similarity_threshold double precision DEFAULT 0.7, p_limit_count integer DEFAULT 10, p_status text[] DEFAULT NULL::text[], p_date_from date DEFAULT NULL::date, p_date_to date DEFAULT NULL::date) RETURNS TABLE(id uuid, client_name text, resource_name text, service_name text, appointment_date date, start_time time without time zone, end_time time without time zone, status text, notes text, similarity double precision)
    LANGUAGE sql STABLE
    AS $$
  SELECT
    a.id,
    ce.display_name as client_name,
    re.display_name as resource_name,
    a.service_name,
    a.appointment_date,
    a.start_time,
    a.end_time,
    a.status::text,
    a.notes,
    1 - (a.embedding <=> p_query_embedding) as similarity
  FROM appointments a
  LEFT JOIN entities ce ON ce.id = a.client_entity_id
  LEFT JOIN entities re ON re.id = a.resource_entity_id
  WHERE a.organization_id = p_organization_id
    AND a.deleted_at IS NULL
    AND a.embedding IS NOT NULL
    AND a.has_embedding = true
    AND (p_status IS NULL OR a.status::text = ANY(p_status))
    AND (p_date_from IS NULL OR a.appointment_date >= p_date_from)
    AND (p_date_to IS NULL OR a.appointment_date <= p_date_to)
    AND 1 - (a.embedding <=> p_query_embedding) >= p_similarity_threshold
  ORDER BY similarity DESC
  LIMIT p_limit_count;
$$;


--
-- Name: FUNCTION search_appointments(p_organization_id uuid, p_query_embedding extensions.vector, p_similarity_threshold double precision, p_limit_count integer, p_status text[], p_date_from date, p_date_to date); Type: COMMENT; Schema: public; Owner: -
--

COMMENT ON FUNCTION public.search_appointments(p_organization_id uuid, p_query_embedding extensions.vector, p_similarity_threshold double precision, p_limit_count integer, p_status text[], p_date_from date, p_date_to date) IS 'Semantic search for appointments with optional date and status filters.';


--
-- Name: search_available_resources(text, uuid, date, time without time zone, text[], integer); Type: FUNCTION; Schema: public; Owner: -
--

CREATE FUNCTION public.search_available_resources(p_query_text text, p_organization_id uuid, p_date date DEFAULT CURRENT_DATE, p_time time without time zone DEFAULT NULL::time without time zone, p_person_subtypes text[] DEFAULT NULL::text[], p_match_count integer DEFAULT 10) RETURNS TABLE(id uuid, display_name text, person_subtype text, email text, phone text, metadata jsonb, similarity_score numeric, is_available boolean, next_available_slot jsonb)
    LANGUAGE plpgsql SECURITY DEFINER
    AS $$
BEGIN
    RETURN QUERY
    SELECT 
        e.id,
        e.display_name,
        e.person_subtype,
        e.email,
        e.phone,
        e.metadata,
        e.similarity_score,
        -- Check if resource is available
        EXISTS (
            SELECT 1 
            FROM availability av
            WHERE av.entity_id = e.id
                AND av.organization_id = p_organization_id
                AND av.day_of_week = EXTRACT(ISODOW FROM p_date)
                AND av.is_available = true
                AND (p_time IS NULL OR (av.start_time <= p_time AND av.end_time > p_time))
        ) as is_available,
        -- Find next available slot
        (
            SELECT jsonb_build_object(
                'date', p_date,
                'start_time', av.start_time,
                'end_time', av.end_time
            )
            FROM availability av
            WHERE av.entity_id = e.id
                AND av.organization_id = p_organization_id
                AND av.day_of_week = EXTRACT(ISODOW FROM p_date)
                AND av.is_available = true
                AND NOT EXISTS (
                    SELECT 1 
                    FROM appointments a
                    WHERE a.resource_entity_id = e.id
                        AND a.appointment_date = p_date
                        AND a.status NOT IN ('cancelled', 'no_show')
                        AND a.deleted_at IS NULL
                        AND (
                            (a.start_time, a.end_time) OVERLAPS (av.start_time, av.end_time)
                        )
                )
            ORDER BY av.start_time
            LIMIT 1
        ) as next_available_slot
    FROM semantic_search_entities(
        p_query_text,
        p_organization_id,
        ARRAY['person'],
        p_person_subtypes,
        0.3,
        p_match_count * 2  -- Get more results to filter by availability
    ) e
    ORDER BY e.similarity_score DESC, e.display_name
    LIMIT p_match_count;
END;
$$;


--
-- Name: FUNCTION search_available_resources(p_query_text text, p_organization_id uuid, p_date date, p_time time without time zone, p_person_subtypes text[], p_match_count integer); Type: COMMENT; Schema: public; Owner: -
--

COMMENT ON FUNCTION public.search_available_resources(p_query_text text, p_organization_id uuid, p_date date, p_time time without time zone, p_person_subtypes text[], p_match_count integer) IS 'Search entities and check their availability for appointments.
Returns resources sorted by relevance with availability status.

Example:
SELECT * FROM search_available_resources(
    ''estilista'',
    ''00000000-0000-0000-0000-000000000002''::uuid,
    CURRENT_DATE + 1,
    ''14:00''::time,
    ARRAY[''staff''],
    5
);';


--
-- Name: search_catalog_items_hybrid(text, extensions.vector, uuid, text[], uuid, numeric, numeric, integer, double precision, double precision, double precision); Type: FUNCTION; Schema: public; Owner: -
--

CREATE FUNCTION public.search_catalog_items_hybrid(p_query_text text, p_query_embedding extensions.vector DEFAULT NULL::extensions.vector, p_organization_id uuid DEFAULT NULL::uuid, p_item_types text[] DEFAULT NULL::text[], p_category_id uuid DEFAULT NULL::uuid, p_min_price numeric DEFAULT NULL::numeric, p_max_price numeric DEFAULT NULL::numeric, p_limit_count integer DEFAULT 20, p_semantic_weight double precision DEFAULT 0.5, p_fulltext_weight double precision DEFAULT 0.3, p_fuzzy_weight double precision DEFAULT 0.2) RETURNS TABLE(id uuid, item_code character varying, name text, display_name text, item_type character varying, description text, base_price numeric, duration_minutes integer, category_id uuid, tags text[], image_url text, hybrid_score double precision, semantic_score double precision, fulltext_score double precision, fuzzy_score double precision, match_quality text)
    LANGUAGE plpgsql STABLE SECURITY DEFINER
    SET search_path TO 'public', 'extensions'
    AS $$
DECLARE
    v_tsquery tsquery;
BEGIN
    v_tsquery := plainto_tsquery('spanish', p_query_text);

    RETURN QUERY
    WITH scored_items AS (
        SELECT
            ci.id,
            ci.item_code,
            ci.name,
            ci.display_name,
            ci.item_type,
            ci.description,
            ci.base_price,
            ci.duration_minutes,
            ci.category_id,
            ci.tags,
            ci.image_url,
            -- Semantic score (0-1)
            CASE
                WHEN p_query_embedding IS NOT NULL AND ci.embedding IS NOT NULL
                THEN GREATEST(0, 1 - (ci.embedding <=> p_query_embedding))
                ELSE 0
            END AS sem_score,
            -- Full-text score (normalized 0-1)
            CASE
                WHEN ci.search_vector IS NOT NULL AND v_tsquery::text != ''
                THEN LEAST(1, ts_rank_cd(ci.search_vector, v_tsquery, 32) * 2)
                ELSE 0
            END AS fts_score,
            -- Trigram score (0-1) - NOW INCLUDES ai_generated_description
            GREATEST(
                similarity(ci.name, p_query_text),
                similarity(COALESCE(ci.description, ''), p_query_text) * 0.8,
                similarity(COALESCE(ci.ai_generated_description, ''), p_query_text) * 0.9
            ) AS trgm_score
        FROM public.catalog_items ci
        WHERE
            ci.is_active = true
            AND ci.deleted_at IS NULL
            AND (p_organization_id IS NULL OR ci.organization_id = p_organization_id)
            AND (p_item_types IS NULL OR ci.item_type = ANY(p_item_types))
            AND (p_category_id IS NULL OR ci.category_id = p_category_id)
            AND (p_min_price IS NULL OR ci.base_price >= p_min_price)
            AND (p_max_price IS NULL OR ci.base_price <= p_max_price)
            AND (
                (p_query_embedding IS NOT NULL AND ci.embedding IS NOT NULL
                    AND (1 - (ci.embedding <=> p_query_embedding)) >= 0.4)
                OR (ci.search_vector @@ v_tsquery)
                OR (similarity(ci.name, p_query_text) > 0.3)
                OR (similarity(COALESCE(ci.description, ''), p_query_text) > 0.25)
                OR (similarity(COALESCE(ci.ai_generated_description, ''), p_query_text) > 0.25)
            )
    )
    SELECT
        s.id,
        s.item_code,
        s.name,
        s.display_name,
        s.item_type,
        s.description,
        s.base_price,
        s.duration_minutes,
        s.category_id,
        s.tags,
        s.image_url,
        (s.sem_score * p_semantic_weight +
         s.fts_score * p_fulltext_weight +
         s.trgm_score * p_fuzzy_weight)::float AS hybrid_score,
        s.sem_score::float AS semantic_score,
        s.fts_score::float AS fulltext_score,
        s.trgm_score::float AS fuzzy_score,
        CASE
            WHEN (s.sem_score * p_semantic_weight + s.fts_score * p_fulltext_weight + s.trgm_score * p_fuzzy_weight) >= 0.7 THEN 'excellent'
            WHEN (s.sem_score * p_semantic_weight + s.fts_score * p_fulltext_weight + s.trgm_score * p_fuzzy_weight) >= 0.5 THEN 'very_good'
            WHEN (s.sem_score * p_semantic_weight + s.fts_score * p_fulltext_weight + s.trgm_score * p_fuzzy_weight) >= 0.3 THEN 'good'
            ELSE 'fair'
        END AS match_quality
    FROM scored_items s
    ORDER BY hybrid_score DESC
    LIMIT p_limit_count;
END;
$$;


--
-- Name: FUNCTION search_catalog_items_hybrid(p_query_text text, p_query_embedding extensions.vector, p_organization_id uuid, p_item_types text[], p_category_id uuid, p_min_price numeric, p_max_price numeric, p_limit_count integer, p_semantic_weight double precision, p_fulltext_weight double precision, p_fuzzy_weight double precision); Type: COMMENT; Schema: public; Owner: -
--

COMMENT ON FUNCTION public.search_catalog_items_hybrid(p_query_text text, p_query_embedding extensions.vector, p_organization_id uuid, p_item_types text[], p_category_id uuid, p_min_price numeric, p_max_price numeric, p_limit_count integer, p_semantic_weight double precision, p_fulltext_weight double precision, p_fuzzy_weight double precision) IS 'Hybrid search combining semantic (pgvector), full-text (tsvector), and fuzzy (pg_trgm) matching. Weights configurable.';


--
-- Name: search_catalog_items_text(text, uuid, text[], uuid, integer); Type: FUNCTION; Schema: public; Owner: -
--

CREATE FUNCTION public.search_catalog_items_text(p_query_text text, p_organization_id uuid DEFAULT NULL::uuid, p_item_types text[] DEFAULT NULL::text[], p_category_id uuid DEFAULT NULL::uuid, p_limit_count integer DEFAULT 20) RETURNS TABLE(id uuid, item_code character varying, name text, display_name text, item_type character varying, description text, base_price numeric, duration_minutes integer, category_id uuid, tags text[], text_score double precision, match_type text)
    LANGUAGE plpgsql STABLE SECURITY DEFINER
    SET search_path TO 'public', 'extensions'
    AS $$
DECLARE
    v_tsquery tsquery;
BEGIN
    v_tsquery := plainto_tsquery('spanish', p_query_text);

    RETURN QUERY
    WITH matches AS (
        SELECT
            ci.id,
            ci.item_code,
            ci.name,
            ci.display_name,
            ci.item_type,
            ci.description,
            ci.base_price,
            ci.duration_minutes,
            ci.category_id,
            ci.tags,
            -- Full-text score
            CASE
                WHEN ci.search_vector @@ v_tsquery
                THEN ts_rank_cd(ci.search_vector, v_tsquery, 32)
                ELSE 0
            END AS fts_score,
            -- Trigram score - NOW INCLUDES ai_generated_description
            GREATEST(
                similarity(ci.name, p_query_text),
                similarity(COALESCE(ci.description, ''), p_query_text) * 0.8,
                similarity(COALESCE(ci.ai_generated_description, ''), p_query_text) * 0.9
            ) AS trgm_score,
            -- Exact prefix match (highest priority)
            CASE
                WHEN lower(ci.name) LIKE lower(p_query_text) || '%' THEN 1.0
                WHEN lower(ci.name) LIKE '%' || lower(p_query_text) || '%' THEN 0.8
                ELSE 0
            END AS prefix_score
        FROM public.catalog_items ci
        WHERE
            ci.is_active = true
            AND ci.deleted_at IS NULL
            AND (p_organization_id IS NULL OR ci.organization_id = p_organization_id)
            AND (p_item_types IS NULL OR ci.item_type = ANY(p_item_types))
            AND (p_category_id IS NULL OR ci.category_id = p_category_id)
            AND (
                ci.search_vector @@ v_tsquery
                OR similarity(ci.name, p_query_text) > 0.2
                OR similarity(COALESCE(ci.description, ''), p_query_text) > 0.2
                OR similarity(COALESCE(ci.ai_generated_description, ''), p_query_text) > 0.2
                OR lower(ci.name) LIKE '%' || lower(p_query_text) || '%'
            )
    )
    SELECT
        m.id,
        m.item_code,
        m.name,
        m.display_name,
        m.item_type,
        m.description,
        m.base_price,
        m.duration_minutes,
        m.category_id,
        m.tags,
        (m.prefix_score * 0.5 + m.trgm_score * 0.3 + LEAST(m.fts_score, 1) * 0.2)::float AS text_score,
        CASE
            WHEN m.prefix_score > 0 THEN 'prefix'
            WHEN m.trgm_score > m.fts_score THEN 'fuzzy'
            ELSE 'fulltext'
        END AS match_type
    FROM matches m
    ORDER BY
        m.prefix_score DESC,
        m.trgm_score DESC,
        m.fts_score DESC
    LIMIT p_limit_count;
END;
$$;


--
-- Name: FUNCTION search_catalog_items_text(p_query_text text, p_organization_id uuid, p_item_types text[], p_category_id uuid, p_limit_count integer); Type: COMMENT; Schema: public; Owner: -
--

COMMENT ON FUNCTION public.search_catalog_items_text(p_query_text text, p_organization_id uuid, p_item_types text[], p_category_id uuid, p_limit_count integer) IS 'Text-only search using full-text (tsvector) and fuzzy (pg_trgm) matching. No embedding required.';


--
-- Name: search_faqs(uuid, extensions.vector, integer); Type: FUNCTION; Schema: public; Owner: -
--

CREATE FUNCTION public.search_faqs(p_organization_id uuid, p_query_embedding extensions.vector, p_limit_count integer DEFAULT 3) RETURNS TABLE(question text, answer text, similarity double precision)
    LANGUAGE sql STABLE
    AS $$
  SELECT
    kb.title as question,
    kb.content as answer,
    1 - (kb.embedding <=> p_query_embedding) as similarity
  FROM org_knowledge_base kb
  WHERE kb.organization_id = p_organization_id
    AND kb.enabled = true
    AND kb.content_type = 'faq'
    AND kb.embedding IS NOT NULL
    AND kb.has_embedding = true
    AND 1 - (kb.embedding <=> p_query_embedding) >= 0.75
  ORDER BY similarity DESC
  LIMIT p_limit_count;
$$;


--
-- Name: search_knowledge_base(uuid, extensions.vector, public.knowledge_content_type[], double precision, integer); Type: FUNCTION; Schema: public; Owner: -
--

CREATE FUNCTION public.search_knowledge_base(p_organization_id uuid, p_query_embedding extensions.vector, p_content_types public.knowledge_content_type[] DEFAULT NULL::public.knowledge_content_type[], p_similarity_threshold double precision DEFAULT 0.7, p_limit_count integer DEFAULT 5) RETURNS TABLE(id uuid, title text, content text, content_type public.knowledge_content_type, tags text[], similarity double precision)
    LANGUAGE sql STABLE
    AS $$
  SELECT
    kb.id,
    kb.title,
    kb.content,
    kb.content_type,
    kb.tags,
    1 - (kb.embedding <=> p_query_embedding) as similarity
  FROM org_knowledge_base kb
  WHERE kb.organization_id = p_organization_id
    AND kb.enabled = true
    AND kb.embedding IS NOT NULL
    AND kb.has_embedding = true
    AND (p_content_types IS NULL OR kb.content_type = ANY(p_content_types))
    AND (kb.valid_from IS NULL OR kb.valid_from <= now())
    AND (kb.valid_until IS NULL OR kb.valid_until >= now())
    AND 1 - (kb.embedding <=> p_query_embedding) >= p_similarity_threshold
  ORDER BY kb.priority DESC, similarity DESC
  LIMIT p_limit_count;
$$;


--
-- Name: search_similar_interactions(extensions.vector, double precision, integer, uuid); Type: FUNCTION; Schema: public; Owner: -
--

CREATE FUNCTION public.search_similar_interactions(query_embedding extensions.vector, match_threshold double precision DEFAULT 0.7, match_count integer DEFAULT 5, p_organization_id uuid DEFAULT NULL::uuid) RETURNS TABLE(id uuid, organization_id uuid, user_id uuid, query text, result_summary text, skills_executed text[], cost numeric, duration_ms integer, metadata jsonb, created_at timestamp with time zone, similarity double precision)
    LANGUAGE plpgsql SECURITY DEFINER
    SET search_path TO 'public', 'extensions'
    AS $$
BEGIN
  -- Si no se especifica org_id, usar del JWT
  IF p_organization_id IS NULL THEN
    p_organization_id := (auth.jwt() ->> 'organization_id')::uuid;
  END IF;

  RETURN QUERY
  SELECT
    ai.id,
    ai.organization_id,
    ai.user_id,
    ai.query,
    ai.result_summary,
    ai.skills_executed,
    ai.cost,
    ai.duration_ms,
    ai.metadata,
    ai.created_at,
    1 - (ai.embedding <=> query_embedding) as similarity
  FROM ai_interactions ai
  WHERE ai.organization_id = p_organization_id
    AND ai.embedding IS NOT NULL
    AND 1 - (ai.embedding <=> query_embedding) > match_threshold
  ORDER BY ai.embedding <=> query_embedding
  LIMIT match_count;
END;
$$;


--
-- Name: FUNCTION search_similar_interactions(query_embedding extensions.vector, match_threshold double precision, match_count integer, p_organization_id uuid); Type: COMMENT; Schema: public; Owner: -
--

COMMENT ON FUNCTION public.search_similar_interactions(query_embedding extensions.vector, match_threshold double precision, match_count integer, p_organization_id uuid) IS 'Search similar AI interactions using pgvector cosine similarity. Includes extensions schema for pgvector operators.';


--
-- Name: semantic_search_appointments(extensions.vector, uuid, integer, double precision); Type: FUNCTION; Schema: public; Owner: -
--

CREATE FUNCTION public.semantic_search_appointments(query_embedding extensions.vector, p_organization_id uuid, p_limit integer DEFAULT 10, p_min_similarity double precision DEFAULT 0.5) RETURNS TABLE(appointment_id uuid, appointment_date date, start_time time without time zone, end_time time without time zone, status text, resource_type text, similarity_score double precision, content_snippet text, notes text, client_name text, resource_name text)
    LANGUAGE plpgsql STABLE
    AS $$
BEGIN
    RETURN QUERY
    SELECT
        a.id as appointment_id,
        a.appointment_date,
        a.start_time,
        a.end_time,
        a.status::text,
        COALESCE(a.resource_type::text, '') as resource_type,
        (1 - (emb.embedding <=> query_embedding))::double precision as similarity_score,
        LEFT(emb.content, 200) as content_snippet,
        COALESCE(a.notes, '') as notes,
        COALESCE(client_entity.display_name, '') as client_name,
        COALESCE(resource_entity.display_name, '') as resource_name
    FROM public.ai_embeddings emb
    JOIN public.appointments a ON a.id = emb.source_id
    LEFT JOIN public.entities client_entity ON a.client_entity_id = client_entity.id
    LEFT JOIN public.entities resource_entity ON a.resource_entity_id = resource_entity.id
    WHERE emb.organization_id = p_organization_id
      AND emb.source_table = 'appointments'
      AND a.deleted_at IS NULL
      AND (1 - (emb.embedding <=> query_embedding)) >= p_min_similarity
    ORDER BY emb.embedding <=> query_embedding
    LIMIT p_limit;
END;
$$;


--
-- Name: semantic_search_appointments_json(text, uuid, double precision, integer); Type: FUNCTION; Schema: public; Owner: -
--

CREATE FUNCTION public.semantic_search_appointments_json(query_embedding_json text, p_organization_id uuid, p_min_similarity double precision DEFAULT 0.7, p_limit integer DEFAULT 20) RETURNS TABLE(id uuid, service_name text, status text, appointment_date date, start_time time without time zone, notes text, client_name text, resource_name text, similarity_score double precision)
    LANGUAGE plpgsql SECURITY DEFINER
    SET search_path TO 'public', 'extensions'
    AS $$
DECLARE
  query_embedding extensions.vector;
BEGIN
  -- Convert JSON array string to vector type
  query_embedding := ('[' || query_embedding_json || ']')::extensions.vector;
  
  RETURN QUERY
  SELECT 
    a.id,
    a.service_name,
    a.status::text,
    a.appointment_date,
    a.start_time,
    a.notes,
    c.display_name as client_name,
    r.display_name as resource_name,
    1 - (e.embedding <=> query_embedding) as similarity_score
  FROM ai_embeddings e
  JOIN appointments a ON e.source_id = a.id
  JOIN entities c ON a.client_entity_id = c.id
  JOIN entities r ON a.resource_entity_id = r.id
  WHERE e.source_table = 'appointments'
    AND a.organization_id = p_organization_id
    AND a.deleted_at IS NULL
    AND 1 - (e.embedding <=> query_embedding) >= p_min_similarity
  ORDER BY e.embedding <=> query_embedding
  LIMIT p_limit;
END;
$$;


--
-- Name: semantic_search_entities(extensions.vector, uuid, integer, double precision); Type: FUNCTION; Schema: public; Owner: -
--

CREATE FUNCTION public.semantic_search_entities(query_embedding extensions.vector, p_organization_id uuid, p_limit integer DEFAULT 10, p_min_similarity double precision DEFAULT 0.5) RETURNS TABLE(entity_id uuid, display_name text, entity_type text, person_subtype text, organization_subtype text, similarity_score double precision, content_snippet text, email text, status text)
    LANGUAGE plpgsql SECURITY DEFINER
    AS $$
BEGIN
    RETURN QUERY
    SELECT
        e.id as entity_id,
        e.display_name,
        e.entity_type::text,
        e.person_subtype::text,
        e.organization_subtype::text,
        1 - (emb.embedding <=> query_embedding) as similarity_score,
        LEFT(emb.content, 200) as content_snippet,
        e.email,
        e.status::text
    FROM public.ai_embeddings emb
    JOIN public.entities e ON e.id = emb.source_id
    WHERE emb.organization_id = p_organization_id
      AND emb.source_table = 'entities'
      AND e.deleted_at IS NULL
      AND e.status = 'active'
      AND (1 - (emb.embedding <=> query_embedding)) >= p_min_similarity
    ORDER BY emb.embedding <=> query_embedding
    LIMIT p_limit;
END;
$$;


--
-- Name: FUNCTION semantic_search_entities(query_embedding extensions.vector, p_organization_id uuid, p_limit integer, p_min_similarity double precision); Type: COMMENT; Schema: public; Owner: -
--

COMMENT ON FUNCTION public.semantic_search_entities(query_embedding extensions.vector, p_organization_id uuid, p_limit integer, p_min_similarity double precision) IS 'Semantic search of entities using vector similarity. Returns entities ordered by relevance.';


--
-- Name: semantic_search_entities(text, uuid, text[], text[], numeric, integer); Type: FUNCTION; Schema: public; Owner: -
--

CREATE FUNCTION public.semantic_search_entities(p_query_text text, p_organization_id uuid, p_entity_types text[] DEFAULT ARRAY['person'::text], p_person_subtypes text[] DEFAULT NULL::text[], p_match_threshold numeric DEFAULT 0.5, p_match_count integer DEFAULT 10) RETURNS TABLE(id uuid, entity_type text, person_subtype text, display_name text, email text, phone text, metadata jsonb, similarity_score numeric, match_reasons jsonb)
    LANGUAGE plpgsql SECURITY DEFINER
    AS $$
DECLARE
    v_has_embeddings boolean;
BEGIN
    -- Check if entity_embeddings table exists and has data
    SELECT EXISTS (
        SELECT 1 
        FROM information_schema.tables 
        WHERE table_schema = 'public' 
        AND table_name = 'entity_embeddings'
    ) INTO v_has_embeddings;
    
    -- If embeddings table exists and has records, use semantic search
    IF v_has_embeddings THEN
        RETURN QUERY
        SELECT 
            e.id,
            e.entity_type,
            e.person_subtype,
            e.display_name,
            e.email,
            e.phone,
            e.metadata,
            ROUND((1 - (emb.embedding <=> NULL::vector))::numeric, 3) as similarity_score,
            jsonb_build_object(
                'search_type', 'semantic_fallback',
                'reason', 'Embeddings not yet implemented - using text matching',
                'query', p_query_text
            ) as match_reasons
        FROM entities e
        LEFT JOIN entity_embeddings emb ON emb.entity_id = e.id
        WHERE e.organization_id = p_organization_id
            AND e.entity_type = ANY(p_entity_types)
            AND (p_person_subtypes IS NULL OR e.person_subtype = ANY(p_person_subtypes))
            AND e.deleted_at IS NULL
            AND (
                e.display_name ILIKE '%' || p_query_text || '%'
                OR e.email ILIKE '%' || p_query_text || '%'
                OR e.phone ILIKE '%' || p_query_text || '%'
                OR (e.metadata->>'specialty')::text ILIKE '%' || p_query_text || '%'
                OR (e.metadata->>'specialties')::text ILIKE '%' || p_query_text || '%'
            )
        ORDER BY 
            CASE 
                WHEN e.display_name ILIKE p_query_text || '%' THEN 1
                WHEN e.display_name ILIKE '%' || p_query_text || '%' THEN 2
                ELSE 3
            END,
            e.display_name
        LIMIT p_match_count;
    ELSE
        -- Fallback to pure text search if no embeddings table
        RETURN QUERY
        SELECT 
            e.id,
            e.entity_type,
            e.person_subtype,
            e.display_name,
            e.email,
            e.phone,
            e.metadata,
            CASE 
                WHEN e.display_name ILIKE p_query_text THEN 1.0
                WHEN e.display_name ILIKE p_query_text || '%' THEN 0.9
                WHEN e.display_name ILIKE '%' || p_query_text || '%' THEN 0.7
                WHEN e.email ILIKE '%' || p_query_text || '%' THEN 0.6
                ELSE 0.5
            END::numeric as similarity_score,
            jsonb_build_object(
                'search_type', 'text_fallback',
                'reason', 'Using text matching - embeddings not available',
                'query', p_query_text,
                'match_field', CASE 
                    WHEN e.display_name ILIKE '%' || p_query_text || '%' THEN 'display_name'
                    WHEN e.email ILIKE '%' || p_query_text || '%' THEN 'email'
                    WHEN e.phone ILIKE '%' || p_query_text || '%' THEN 'phone'
                    ELSE 'metadata'
                END
            ) as match_reasons
        FROM entities e
        WHERE e.organization_id = p_organization_id
            AND e.entity_type = ANY(p_entity_types)
            AND (p_person_subtypes IS NULL OR e.person_subtype = ANY(p_person_subtypes))
            AND e.deleted_at IS NULL
            AND (
                e.display_name ILIKE '%' || p_query_text || '%'
                OR e.email ILIKE '%' || p_query_text || '%'
                OR e.phone ILIKE '%' || p_query_text || '%'
                OR (e.metadata->>'specialty')::text ILIKE '%' || p_query_text || '%'
                OR (e.metadata->>'specialties')::text ILIKE '%' || p_query_text || '%'
                OR (e.metadata->>'profession')::text ILIKE '%' || p_query_text || '%'
            )
        ORDER BY 
            CASE 
                WHEN e.display_name ILIKE p_query_text THEN 1
                WHEN e.display_name ILIKE p_query_text || '%' THEN 2
                WHEN e.display_name ILIKE '%' || p_query_text || '%' THEN 3
                ELSE 4
            END,
            e.display_name
        LIMIT p_match_count;
    END IF;
END;
$$;


--
-- Name: services; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.services (
    id uuid DEFAULT gen_random_uuid() NOT NULL,
    organization_id uuid NOT NULL,
    service_code character varying(50) NOT NULL,
    service_name text NOT NULL,
    description text,
    category character varying(100),
    base_price numeric(10,2),
    currency character varying(3) DEFAULT 'DOP'::character varying,
    default_duration_minutes integer DEFAULT 30 NOT NULL,
    buffer_time_minutes integer DEFAULT 0,
    is_active boolean DEFAULT true NOT NULL,
    allowed_provider_types public.provider_type[],
    requires_approval boolean DEFAULT false,
    custom_fields jsonb DEFAULT '{}'::jsonb,
    created_at timestamp with time zone DEFAULT timezone('utc'::text, now()) NOT NULL,
    updated_at timestamp with time zone DEFAULT timezone('utc'::text, now()) NOT NULL,
    created_by uuid,
    updated_by uuid,
    embedding extensions.vector(1536),
    has_embedding boolean DEFAULT false,
    CONSTRAINT services_buffer_check CHECK ((buffer_time_minutes >= 0)),
    CONSTRAINT services_duration_check CHECK ((default_duration_minutes > 0)),
    CONSTRAINT services_name_check CHECK ((length(TRIM(BOTH FROM service_name)) >= 2))
);


--
-- Name: TABLE services; Type: COMMENT; Schema: public; Owner: -
--

COMMENT ON TABLE public.services IS 'Services offered by providers';


--
-- Name: services_embedding_content(public.services); Type: FUNCTION; Schema: public; Owner: -
--

CREATE FUNCTION public.services_embedding_content(s public.services) RETURNS text
    LANGUAGE plpgsql STABLE SECURITY DEFINER
    AS $$
DECLARE
  v_org_name text;
  v_vertical_code text;
  v_service_label text;
  v_content_parts text[];
BEGIN
  -- Get organization and vertical data
  SELECT 
    o.name,
    COALESCE(ov.code, 'other'),
    COALESCE(ov.terminology_config->>'service_label', 'Service')
  INTO
    v_org_name,
    v_vertical_code,
    v_service_label
  FROM organizations o
  LEFT JOIN organization_verticals ov ON ov.id = o.vertical_id
  WHERE o.id = s.organization_id;

  -- Start with vertical context
  v_content_parts := ARRAY[format('[VERTICAL: %s | %s]', v_vertical_code, v_org_name)];
  
  -- Add service name with adapted label
  v_content_parts := array_append(v_content_parts, 
    format('%s: %s', v_service_label, s.service_name)
  );

  -- Add description
  IF s.description IS NOT NULL AND s.description != '' THEN
    v_content_parts := array_append(v_content_parts, 
      format('Description: %s', s.description)
    );
  END IF;

  -- Add category
  IF s.category IS NOT NULL THEN
    v_content_parts := array_append(v_content_parts, 
      format('Category: %s', s.category)
    );
  END IF;

  -- Add pricing info
  IF s.base_price IS NOT NULL THEN
    v_content_parts := array_append(v_content_parts, 
      format('Price: %s %s', s.base_price, COALESCE(s.currency, 'USD'))
    );
  END IF;

  IF s.default_duration_minutes IS NOT NULL THEN
    v_content_parts := array_append(v_content_parts, 
      format('Duration: %s minutes', s.default_duration_minutes)
    );
  END IF;

  -- Healthcare-specific service fields
  IF v_vertical_code IN ('healthcare', 'dental_clinic', 'veterinary') THEN
    IF s.custom_fields IS NOT NULL THEN
      IF s.custom_fields ? 'medical_specialty' THEN
        v_content_parts := array_append(v_content_parts, 
          format('Specialty: %s', s.custom_fields->>'medical_specialty')
        );
      END IF;

      IF s.custom_fields ? 'requires_preparation' THEN
        v_content_parts := array_append(v_content_parts, 
          format('Preparation Required: %s', s.custom_fields->>'requires_preparation')
        );
      END IF;
    END IF;
  END IF;

  -- Beauty/Spa specific service fields
  IF v_vertical_code IN ('beauty_salon', 'spa', 'wellness') THEN
    IF s.custom_fields IS NOT NULL THEN
      IF s.custom_fields ? 'treatment_type' THEN
        v_content_parts := array_append(v_content_parts, 
          format('Treatment Type: %s', s.custom_fields->>'treatment_type')
        );
      END IF;

      IF s.custom_fields ? 'benefits' THEN
        v_content_parts := array_append(v_content_parts, 
          format('Benefits: %s', s.custom_fields->>'benefits')
        );
      END IF;

      IF s.custom_fields ? 'skin_types' THEN
        v_content_parts := array_append(v_content_parts, 
          format('Suitable for: %s', s.custom_fields->>'skin_types')
        );
      END IF;
    END IF;
  END IF;

  -- Retail/Product fields
  IF v_vertical_code IN ('retail', 'supermarket') THEN
    IF s.custom_fields IS NOT NULL THEN
      IF s.custom_fields ? 'brand' THEN
        v_content_parts := array_append(v_content_parts, 
          format('Brand: %s', s.custom_fields->>'brand')
        );
      END IF;

      IF s.custom_fields ? 'stock_quantity' THEN
        v_content_parts := array_append(v_content_parts, 
          format('Stock: %s', s.custom_fields->>'stock_quantity')
        );
      END IF;
    END IF;
  END IF;

  -- Add status
  v_content_parts := array_append(v_content_parts, 
    format('Active: %s', s.is_active)
  );

  RETURN array_to_string(v_content_parts, ' | ');
END;
$$;


--
-- Name: FUNCTION services_embedding_content(s public.services); Type: COMMENT; Schema: public; Owner: -
--

COMMENT ON FUNCTION public.services_embedding_content(s public.services) IS 'Generates multi-vertical aware content for service embeddings. Adapts based on organization vertical (healthcare treatments, beauty services, retail products, etc.)';


--
-- Name: set_organization_patient_prefix(uuid, text); Type: FUNCTION; Schema: public; Owner: -
--

CREATE FUNCTION public.set_organization_patient_prefix(p_organization_id uuid, p_prefix text) RETURNS void
    LANGUAGE plpgsql
    AS $$
BEGIN
  INSERT INTO patient_code_sequences (organization_id, prefix)
  VALUES (p_organization_id, upper(p_prefix))
  ON CONFLICT (organization_id) 
  DO UPDATE SET prefix = upper(p_prefix);
END;
$$;


--
-- Name: FUNCTION set_organization_patient_prefix(p_organization_id uuid, p_prefix text); Type: COMMENT; Schema: public; Owner: -
--

COMMENT ON FUNCTION public.set_organization_patient_prefix(p_organization_id uuid, p_prefix text) IS 'Sets the patient code prefix for an organization';


--
-- Name: set_pending_action(uuid, text, jsonb, integer); Type: FUNCTION; Schema: public; Owner: -
--

CREATE FUNCTION public.set_pending_action(p_conversation_id uuid, p_action_type text, p_data jsonb, p_expires_minutes integer DEFAULT 10) RETURNS void
    LANGUAGE plpgsql
    AS $$
BEGIN
  UPDATE whatsapp_conversations
  SET pending_action = jsonb_build_object(
    'type', p_action_type,
    'data', p_data,
    'created_at', now(),
    'expires_at', now() + (p_expires_minutes || ' minutes')::interval
  )
  WHERE id = p_conversation_id;
END;
$$;


--
-- Name: set_time_entry_derived_fields(); Type: FUNCTION; Schema: public; Owner: -
--

CREATE FUNCTION public.set_time_entry_derived_fields() RETURNS trigger
    LANGUAGE plpgsql
    AS $$
BEGIN
    -- Use AT TIME ZONE to get local date/time (default to organization timezone or UTC)
    NEW.entry_date := (NEW.entry_timestamp AT TIME ZONE 'America/Santo_Domingo')::date;
    NEW.entry_time := (NEW.entry_timestamp AT TIME ZONE 'America/Santo_Domingo')::time;
    RETURN NEW;
END;
$$;


--
-- Name: skill_definitions; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.skill_definitions (
    id uuid DEFAULT gen_random_uuid() NOT NULL,
    organization_id uuid,
    skill_code character varying(50) NOT NULL,
    display_name text NOT NULL,
    description text,
    parent_id uuid,
    path public.ltree,
    category character varying(50),
    proficiency_levels jsonb DEFAULT '[{"name": "Beginner", "level": 1, "description": "Basic understanding"}, {"name": "Intermediate", "level": 2, "description": "Can work independently"}, {"name": "Advanced", "level": 3, "description": "Deep expertise"}, {"name": "Expert", "level": 4, "description": "Can teach others"}, {"name": "Master", "level": 5, "description": "Industry leader"}]'::jsonb,
    requires_certification boolean DEFAULT false NOT NULL,
    certification_validity_months integer,
    certification_authority character varying(100),
    applicable_verticals text[] DEFAULT '{}'::text[],
    embedding extensions.vector(1536),
    is_active boolean DEFAULT true NOT NULL,
    created_at timestamp with time zone DEFAULT now() NOT NULL,
    updated_at timestamp with time zone DEFAULT now() NOT NULL,
    has_embedding boolean DEFAULT false
);


--
-- Name: TABLE skill_definitions; Type: COMMENT; Schema: public; Owner: -
--

COMMENT ON TABLE public.skill_definitions IS 'Defines skills/certifications that providers can have and items can require';


--
-- Name: skill_definitions_embedding_content(public.skill_definitions); Type: FUNCTION; Schema: public; Owner: -
--

CREATE FUNCTION public.skill_definitions_embedding_content(skill public.skill_definitions) RETURNS text
    LANGUAGE plpgsql STABLE SECURITY DEFINER
    AS $$
DECLARE
    v_org_name text;
    v_vertical_code text;
    v_content_parts text[];
BEGIN
    -- Get organization info (NULL for global skills)
    IF skill.organization_id IS NOT NULL THEN
        SELECT
            o.name,
            COALESCE(ov.code, 'other')
        INTO
            v_org_name,
            v_vertical_code
        FROM organizations o
        LEFT JOIN organization_verticals ov ON ov.id = o.vertical_id
        WHERE o.id = skill.organization_id;

        v_content_parts := ARRAY[format('[VERTICAL: %s | %s]', v_vertical_code, v_org_name)];
    ELSE
        v_content_parts := ARRAY['[GLOBAL SKILL]'];
    END IF;

    -- Skill name (display_name)
    v_content_parts := array_append(v_content_parts, format('Skill: %s', skill.display_name));

    -- Code (skill_code)
    IF skill.skill_code IS NOT NULL THEN
        v_content_parts := array_append(v_content_parts, format('Code: %s', skill.skill_code));
    END IF;

    -- Category
    IF skill.category IS NOT NULL THEN
        v_content_parts := array_append(v_content_parts, format('Category: %s', skill.category));
    END IF;

    -- Description
    IF skill.description IS NOT NULL AND skill.description != '' THEN
        v_content_parts := array_append(v_content_parts,
            format('Description: %s', skill.description)
        );
    END IF;

    -- Certification info (requires_certification)
    IF skill.requires_certification THEN
        v_content_parts := array_append(v_content_parts, 'Certification Required: Yes');

        IF skill.certification_authority IS NOT NULL THEN
            v_content_parts := array_append(v_content_parts,
                format('Certification Authority: %s', skill.certification_authority)
            );
        END IF;

        IF skill.certification_validity_months IS NOT NULL THEN
            v_content_parts := array_append(v_content_parts,
                format('Validity: %s months', skill.certification_validity_months)
            );
        END IF;
    END IF;

    -- Related verticals (applicable_verticals)
    IF skill.applicable_verticals IS NOT NULL AND array_length(skill.applicable_verticals, 1) > 0 THEN
        v_content_parts := array_append(v_content_parts,
            format('Verticals: %s', array_to_string(skill.applicable_verticals, ', '))
        );
    END IF;

    -- Path (hierarchy)
    IF skill.path IS NOT NULL THEN
        v_content_parts := array_append(v_content_parts, format('Path: %s', skill.path::text));
    END IF;

    RETURN array_to_string(v_content_parts, ' | ');
END;
$$;


--
-- Name: FUNCTION skill_definitions_embedding_content(skill public.skill_definitions); Type: COMMENT; Schema: public; Owner: -
--

COMMENT ON FUNCTION public.skill_definitions_embedding_content(skill public.skill_definitions) IS 'Generates content for skill definition embeddings';


--
-- Name: skill_definitions_embedding_content_wrapper(uuid); Type: FUNCTION; Schema: public; Owner: -
--

CREATE FUNCTION public.skill_definitions_embedding_content_wrapper(p_id uuid) RETURNS text
    LANGUAGE sql STABLE SECURITY DEFINER
    SET search_path TO 'public'
    AS $$
  SELECT skill_definitions_embedding_content(s) FROM skill_definitions s WHERE s.id = p_id;
$$;


--
-- Name: skill_definitions_maintain_path(); Type: FUNCTION; Schema: public; Owner: -
--

CREATE FUNCTION public.skill_definitions_maintain_path() RETURNS trigger
    LANGUAGE plpgsql
    AS $$
BEGIN
    IF NEW.parent_id IS NULL THEN
        NEW.path = text2ltree(NEW.id::text);
    ELSE
        SELECT path || NEW.id::text INTO NEW.path
        FROM public.skill_definitions
        WHERE id = NEW.parent_id;
    END IF;
    RETURN NEW;
END;
$$;


--
-- Name: soft_delete_patient(uuid); Type: FUNCTION; Schema: public; Owner: -
--

CREATE FUNCTION public.soft_delete_patient(p_patient_id uuid) RETURNS boolean
    LANGUAGE plpgsql SECURITY DEFINER
    AS $$
DECLARE
    v_affected_rows integer;
BEGIN
    UPDATE patients
    SET
        deleted_at = now(),
        deleted_by = auth.uid(),
        updated_at = now(),
        updated_by = auth.uid()
    WHERE id = p_patient_id
      AND deleted_at IS NULL;

    GET DIAGNOSTICS v_affected_rows = ROW_COUNT;

    RETURN v_affected_rows > 0;
END;
$$;


--
-- Name: FUNCTION soft_delete_patient(p_patient_id uuid); Type: COMMENT; Schema: public; Owner: -
--

COMMENT ON FUNCTION public.soft_delete_patient(p_patient_id uuid) IS 'Soft delete a patient (set deleted_at timestamp).
Returns true if patient was deleted, false if not found or already deleted.';


--
-- Name: start_conversation_flow(uuid, uuid, uuid, jsonb, jsonb); Type: FUNCTION; Schema: public; Owner: -
--

CREATE FUNCTION public.start_conversation_flow(p_conversation_id uuid, p_flow_id uuid, p_organization_id uuid DEFAULT NULL::uuid, p_initial_slots jsonb DEFAULT '{}'::jsonb, p_context jsonb DEFAULT '{}'::jsonb) RETURNS uuid
    LANGUAGE plpgsql SECURITY DEFINER
    SET search_path TO 'public'
    AS $$
DECLARE
    v_state_id uuid;
    v_flow record;
    v_first_slot varchar;
    v_timeout_seconds int;
BEGIN
    -- Get flow details
    SELECT * INTO v_flow FROM conversation_flows WHERE id = p_flow_id;
    
    IF v_flow IS NULL THEN
        RAISE EXCEPTION 'Flow not found: %', p_flow_id;
    END IF;
    
    -- Determine first unfilled required slot
    SELECT s->>'name' INTO v_first_slot
    FROM jsonb_array_elements(v_flow.slots) s
    WHERE (s->>'required')::boolean = true
      AND NOT (p_initial_slots ? (s->>'name'))
    ORDER BY (s->>'order')::int NULLS LAST
    LIMIT 1;
    
    v_timeout_seconds := COALESCE(v_flow.flow_timeout_seconds, 900);
    
    -- Create flow state
    INSERT INTO conversation_flow_states (
        conversation_id, flow_id, organization_id, current_slot,
        collected_slots, context, expires_at
    )
    VALUES (
        p_conversation_id, p_flow_id, p_organization_id, v_first_slot,
        p_initial_slots, p_context, now() + (v_timeout_seconds || ' seconds')::interval
    )
    RETURNING id INTO v_state_id;
    
    RETURN v_state_id;
END;
$$;


--
-- Name: start_skill_execution(text, uuid, uuid, jsonb, text, uuid, text); Type: FUNCTION; Schema: public; Owner: -
--

CREATE FUNCTION public.start_skill_execution(p_skill_name text, p_organization_id uuid, p_user_id uuid DEFAULT NULL::uuid, p_input_params jsonb DEFAULT '{}'::jsonb, p_channel text DEFAULT 'api'::text, p_conversation_id uuid DEFAULT NULL::uuid, p_request_id text DEFAULT NULL::text) RETURNS uuid
    LANGUAGE plpgsql
    AS $$
DECLARE
  v_skill_id uuid;
  v_requires_approval boolean;
  v_execution_id uuid;
BEGIN
  -- Buscar skill
  SELECT id, requires_approval INTO v_skill_id, v_requires_approval
  FROM ai_skills
  WHERE name = p_skill_name AND enabled = true;

  IF v_skill_id IS NULL THEN
    RAISE EXCEPTION 'Skill not found or disabled: %', p_skill_name;
  END IF;

  -- Crear registro de ejecución
  INSERT INTO ai_skill_executions (
    skill_id,
    organization_id,
    user_id,
    input_params,
    channel,
    conversation_id,
    request_id,
    status,
    requires_approval
  )
  VALUES (
    v_skill_id,
    p_organization_id,
    p_user_id,
    p_input_params,
    p_channel,
    p_conversation_id,
    p_request_id,
    CASE WHEN v_requires_approval THEN 'pending_approval' ELSE 'running' END,
    v_requires_approval
  )
  RETURNING id INTO v_execution_id;

  RETURN v_execution_id;
END;
$$;


--
-- Name: sync_employee_schedule_to_provider(uuid); Type: FUNCTION; Schema: public; Owner: -
--

CREATE FUNCTION public.sync_employee_schedule_to_provider(p_employee_id uuid) RETURNS void
    LANGUAGE plpgsql SECURITY DEFINER
    AS $$
DECLARE
    v_entity_id UUID;
    v_org_id UUID;
    v_schedule JSONB;
    v_day_name TEXT;
    v_day_number INTEGER;
    v_day_config JSONB;
    v_shift JSONB;
BEGIN
    -- Get employee info
    SELECT entity_id, organization_id, work_schedule
    INTO v_entity_id, v_org_id, v_schedule
    FROM employees
    WHERE id = p_employee_id AND deleted_at IS NULL;

    IF v_entity_id IS NULL THEN
        RAISE EXCEPTION 'Employee not found: %', p_employee_id;
    END IF;

    -- Skip if no work_schedule defined
    IF v_schedule IS NULL OR v_schedule = '{}'::jsonb THEN
        RETURN;
    END IF;

    -- Delete existing schedules for this provider
    DELETE FROM provider_schedules
    WHERE provider_entity_id = v_entity_id
    AND organization_id = v_org_id;

    -- Map day names to numbers (provider_schedules uses 1-7 where 1=Monday)
    FOR v_day_name, v_day_config IN
        SELECT * FROM jsonb_each(v_schedule->'weekly_schedule')
    LOOP
        -- Map day name to number
        v_day_number := CASE lower(v_day_name)
            WHEN 'monday' THEN 1
            WHEN 'tuesday' THEN 2
            WHEN 'wednesday' THEN 3
            WHEN 'thursday' THEN 4
            WHEN 'friday' THEN 5
            WHEN 'saturday' THEN 6
            WHEN 'sunday' THEN 7
            -- Spanish support
            WHEN 'lunes' THEN 1
            WHEN 'martes' THEN 2
            WHEN 'miercoles' THEN 3
            WHEN 'miércoles' THEN 3
            WHEN 'jueves' THEN 4
            WHEN 'viernes' THEN 5
            WHEN 'sabado' THEN 6
            WHEN 'sábado' THEN 6
            WHEN 'domingo' THEN 7
            ELSE NULL
        END;

        IF v_day_number IS NULL THEN
            CONTINUE;
        END IF;

        -- Check if working day
        IF (v_day_config->>'is_working_day')::boolean = false THEN
            -- Insert as not available
            INSERT INTO provider_schedules (
                organization_id,
                provider_entity_id,
                day_of_week,
                start_time,
                end_time,
                is_available,
                notes
            ) VALUES (
                v_org_id,
                v_entity_id,
                v_day_number,
                '00:00'::TIME,
                '00:01'::TIME,  -- Minimal duration for closed days
                false,
                'Día no laboral'
            );
        ELSE
            -- Insert each shift for the day
            FOR v_shift IN SELECT * FROM jsonb_array_elements(v_day_config->'shifts')
            LOOP
                INSERT INTO provider_schedules (
                    organization_id,
                    provider_entity_id,
                    day_of_week,
                    start_time,
                    end_time,
                    is_available,
                    notes
                ) VALUES (
                    v_org_id,
                    v_entity_id,
                    v_day_number,
                    (v_shift->>'start')::TIME,
                    (v_shift->>'end')::TIME,
                    true,
                    v_day_name
                );
            END LOOP;
        END IF;
    END LOOP;
END;
$$;


--
-- Name: FUNCTION sync_employee_schedule_to_provider(p_employee_id uuid); Type: COMMENT; Schema: public; Owner: -
--

COMMENT ON FUNCTION public.sync_employee_schedule_to_provider(p_employee_id uuid) IS 'Syncs employee work_schedule JSONB to provider_schedules table for scheduler integration';


--
-- Name: sync_proficiency_score(); Type: FUNCTION; Schema: public; Owner: -
--

CREATE FUNCTION public.sync_proficiency_score() RETURNS trigger
    LANGUAGE plpgsql
    AS $$
BEGIN
  IF NEW.proficiency_level IS DISTINCT FROM OLD.proficiency_level THEN
    NEW.proficiency_score := public.proficiency_to_int(NEW.proficiency_level);
  END IF;
  RETURN NEW;
END;
$$;


--
-- Name: trigger_set_patient_code(); Type: FUNCTION; Schema: public; Owner: -
--

CREATE FUNCTION public.trigger_set_patient_code() RETURNS trigger
    LANGUAGE plpgsql
    AS $$
BEGIN
  -- Only generate if patient_code is NULL or empty
  IF NEW.patient_code IS NULL OR NEW.patient_code = '' THEN
    -- Need organization_id to generate code
    IF NEW.organization_id IS NOT NULL THEN
      NEW.patient_code := generate_patient_code(NEW.organization_id);
    END IF;
  END IF;
  
  RETURN NEW;
END;
$$;


--
-- Name: trigger_sync_work_schedule(); Type: FUNCTION; Schema: public; Owner: -
--

CREATE FUNCTION public.trigger_sync_work_schedule() RETURNS trigger
    LANGUAGE plpgsql
    AS $$
BEGIN
    -- Only sync if work_schedule actually changed
    IF OLD.work_schedule IS DISTINCT FROM NEW.work_schedule THEN
        PERFORM sync_employee_schedule_to_provider(NEW.id);
    END IF;
    RETURN NEW;
END;
$$;


--
-- Name: trigger_sync_work_schedule_insert(); Type: FUNCTION; Schema: public; Owner: -
--

CREATE FUNCTION public.trigger_sync_work_schedule_insert() RETURNS trigger
    LANGUAGE plpgsql
    AS $$
BEGIN
    IF NEW.work_schedule IS NOT NULL AND NEW.work_schedule != '{}'::jsonb THEN
        PERFORM sync_employee_schedule_to_provider(NEW.id);
    END IF;
    RETURN NEW;
END;
$$;


--
-- Name: update_bot_messages_updated_at(); Type: FUNCTION; Schema: public; Owner: -
--

CREATE FUNCTION public.update_bot_messages_updated_at() RETURNS trigger
    LANGUAGE plpgsql
    AS $$
BEGIN
  NEW.updated_at = now();
  RETURN NEW;
END;
$$;


--
-- Name: update_business_hours_timestamp(); Type: FUNCTION; Schema: public; Owner: -
--

CREATE FUNCTION public.update_business_hours_timestamp() RETURNS trigger
    LANGUAGE plpgsql
    AS $$
BEGIN
    NEW.updated_at = NOW();
    RETURN NEW;
END;
$$;


--
-- Name: update_client_visit_stats(uuid, date, numeric); Type: FUNCTION; Schema: public; Owner: -
--

CREATE FUNCTION public.update_client_visit_stats(p_client_id uuid, p_visit_date date DEFAULT CURRENT_DATE, p_amount_spent numeric DEFAULT 0) RETURNS void
    LANGUAGE plpgsql
    AS $$
BEGIN
    UPDATE clients
    SET
        total_visits = total_visits + 1,
        last_visit_date = p_visit_date,
        total_spent = total_spent + p_amount_spent,
        average_ticket = CASE
            WHEN total_visits > 0 THEN (total_spent + p_amount_spent) / (total_visits + 1)
            ELSE p_amount_spent
        END,
        last_payment_date = CASE WHEN p_amount_spent > 0 THEN p_visit_date ELSE last_payment_date END,
        category = CASE
            WHEN total_visits >= 10 OR total_spent >= 5000 THEN 'vip'
            WHEN total_visits >= 1 THEN 'regular'
            ELSE 'new'
        END,
        updated_at = now()
    WHERE id = p_client_id;
END;
$$;


--
-- Name: update_conversation_memory(uuid, jsonb, jsonb, text, text); Type: FUNCTION; Schema: public; Owner: -
--

CREATE FUNCTION public.update_conversation_memory(p_conversation_id uuid, p_message jsonb, p_slots jsonb DEFAULT NULL::jsonb, p_intent text DEFAULT NULL::text, p_summary text DEFAULT NULL::text) RETURNS void
    LANGUAGE plpgsql SECURITY DEFINER
    AS $$
BEGIN
  UPDATE ai_conversations
  SET
    messages = messages || p_message,
    -- Properly merge JSONB objects (not array concatenation)
    collected_slots = CASE
      WHEN p_slots IS NOT NULL AND jsonb_typeof(p_slots) = 'object' THEN
        CASE
          WHEN jsonb_typeof(collected_slots) = 'object' THEN collected_slots || p_slots
          ELSE p_slots -- Reset if corrupted
        END
      ELSE
        CASE
          WHEN jsonb_typeof(collected_slots) = 'object' THEN collected_slots
          ELSE '{}'::jsonb -- Reset if corrupted
        END
    END,
    last_intent = COALESCE(p_intent, last_intent),
    summary = COALESCE(p_summary, summary),
    last_message_at = NOW(),
    updated_at = NOW()
  WHERE id = p_conversation_id;
END;
$$;


--
-- Name: FUNCTION update_conversation_memory(p_conversation_id uuid, p_message jsonb, p_slots jsonb, p_intent text, p_summary text); Type: COMMENT; Schema: public; Owner: -
--

COMMENT ON FUNCTION public.update_conversation_memory(p_conversation_id uuid, p_message jsonb, p_slots jsonb, p_intent text, p_summary text) IS 'Updates conversation with new message and merges slots (fixes array concatenation bug)';


--
-- Name: update_conversation_state(uuid, jsonb); Type: FUNCTION; Schema: public; Owner: -
--

CREATE FUNCTION public.update_conversation_state(p_conversation_id uuid, p_state jsonb) RETURNS void
    LANGUAGE plpgsql SECURITY DEFINER
    AS $$
BEGIN
  UPDATE whatsapp_conversations
  SET 
    conversation_state = p_state,
    updated_at = NOW()
  WHERE id = p_conversation_id;
END;
$$;


--
-- Name: FUNCTION update_conversation_state(p_conversation_id uuid, p_state jsonb); Type: COMMENT; Schema: public; Owner: -
--

COMMENT ON FUNCTION public.update_conversation_state(p_conversation_id uuid, p_state jsonb) IS 'Updates the conversation state for a WhatsApp conversation';


--
-- Name: update_conversation_timestamp(); Type: FUNCTION; Schema: public; Owner: -
--

CREATE FUNCTION public.update_conversation_timestamp() RETURNS trigger
    LANGUAGE plpgsql
    AS $$
BEGIN
  UPDATE whatsapp_conversations
  SET 
    last_message_at = NEW.sent_at,
    message_count = message_count + 1,
    updated_at = now()
  WHERE id = NEW.conversation_id;
  
  RETURN NEW;
END;
$$;


--
-- Name: FUNCTION update_conversation_timestamp(); Type: COMMENT; Schema: public; Owner: -
--

COMMENT ON FUNCTION public.update_conversation_timestamp() IS 'Automatically updates conversation last_message_at and message_count on new message';


--
-- Name: update_daily_time_summary_timestamp(); Type: FUNCTION; Schema: public; Owner: -
--

CREATE FUNCTION public.update_daily_time_summary_timestamp() RETURNS trigger
    LANGUAGE plpgsql
    AS $$
BEGIN
    NEW.updated_at = NOW();
    RETURN NEW;
END;
$$;


--
-- Name: update_departments_timestamp(); Type: FUNCTION; Schema: public; Owner: -
--

CREATE FUNCTION public.update_departments_timestamp() RETURNS trigger
    LANGUAGE plpgsql
    AS $$
BEGIN
    NEW.updated_at = NOW();
    RETURN NEW;
END;
$$;


--
-- Name: update_entity_party_updated_at(); Type: FUNCTION; Schema: public; Owner: -
--

CREATE FUNCTION public.update_entity_party_updated_at() RETURNS trigger
    LANGUAGE plpgsql
    AS $$
BEGIN
    NEW.updated_at = now();
    RETURN NEW;
END;
$$;


--
-- Name: update_flow_slot(uuid, character varying, text, boolean); Type: FUNCTION; Schema: public; Owner: -
--

CREATE FUNCTION public.update_flow_slot(p_state_id uuid, p_slot_name character varying, p_slot_value text, p_move_to_next boolean DEFAULT true) RETURNS jsonb
    LANGUAGE plpgsql SECURITY DEFINER
    SET search_path TO 'public'
    AS $$
DECLARE
    v_state record;
    v_flow record;
    v_next_slot varchar;
    v_all_required_filled boolean;
    v_new_slots jsonb;
BEGIN
    -- Get current state
    SELECT * INTO v_state FROM conversation_flow_states WHERE id = p_state_id AND status = 'active';
    IF v_state IS NULL THEN
        RETURN jsonb_build_object('error', 'Flow state not found or not active');
    END IF;
    
    -- Get flow
    SELECT * INTO v_flow FROM conversation_flows WHERE id = v_state.flow_id;
    
    -- Update collected slots
    v_new_slots := v_state.collected_slots || jsonb_build_object(p_slot_name, p_slot_value);
    
    -- Find next unfilled required slot
    IF p_move_to_next THEN
        SELECT s->>'name' INTO v_next_slot
        FROM jsonb_array_elements(v_flow.slots) s
        WHERE (s->>'required')::boolean = true
          AND NOT (v_new_slots ? (s->>'name'))
        ORDER BY (s->>'order')::int NULLS LAST
        LIMIT 1;
    ELSE
        v_next_slot := v_state.current_slot;
    END IF;
    
    -- Check if all required slots are filled
    SELECT NOT EXISTS (
        SELECT 1 FROM jsonb_array_elements(v_flow.slots) s
        WHERE (s->>'required')::boolean = true
          AND NOT (v_new_slots ? (s->>'name'))
    ) INTO v_all_required_filled;
    
    -- Update state
    UPDATE conversation_flow_states
    SET 
        collected_slots = v_new_slots,
        current_slot = v_next_slot,
        last_activity_at = now(),
        slot_history = slot_history || jsonb_build_object(
            'slot', p_slot_name,
            'value', p_slot_value,
            'timestamp', now()
        ),
        awaiting_confirmation = v_all_required_filled AND v_flow.confirmation_required
    WHERE id = p_state_id;
    
    RETURN jsonb_build_object(
        'success', true,
        'collected_slots', v_new_slots,
        'current_slot', v_next_slot,
        'all_required_filled', v_all_required_filled,
        'awaiting_confirmation', v_all_required_filled AND v_flow.confirmation_required
    );
END;
$$;


--
-- Name: update_heuristic_rules_timestamp(); Type: FUNCTION; Schema: public; Owner: -
--

CREATE FUNCTION public.update_heuristic_rules_timestamp() RETURNS trigger
    LANGUAGE plpgsql
    AS $$
BEGIN
    NEW.updated_at = NOW();
    RETURN NEW;
END;
$$;


--
-- Name: update_invites_updated_at(); Type: FUNCTION; Schema: public; Owner: -
--

CREATE FUNCTION public.update_invites_updated_at() RETURNS trigger
    LANGUAGE plpgsql
    AS $$
BEGIN
    NEW.updated_at = NOW();
    RETURN NEW;
END;
$$;


--
-- Name: update_jobs_timestamp(); Type: FUNCTION; Schema: public; Owner: -
--

CREATE FUNCTION public.update_jobs_timestamp() RETURNS trigger
    LANGUAGE plpgsql
    AS $$
BEGIN
    NEW.updated_at = NOW();
    RETURN NEW;
END;
$$;


--
-- Name: update_leave_balances_timestamp(); Type: FUNCTION; Schema: public; Owner: -
--

CREATE FUNCTION public.update_leave_balances_timestamp() RETURNS trigger
    LANGUAGE plpgsql
    AS $$
BEGIN
    NEW.updated_at = NOW();
    RETURN NEW;
END;
$$;


--
-- Name: update_leave_requests_timestamp(); Type: FUNCTION; Schema: public; Owner: -
--

CREATE FUNCTION public.update_leave_requests_timestamp() RETURNS trigger
    LANGUAGE plpgsql
    AS $$
BEGIN
    NEW.updated_at = NOW();
    RETURN NEW;
END;
$$;


--
-- Name: update_leave_types_timestamp(); Type: FUNCTION; Schema: public; Owner: -
--

CREATE FUNCTION public.update_leave_types_timestamp() RETURNS trigger
    LANGUAGE plpgsql
    AS $$
BEGIN
    NEW.updated_at = NOW();
    RETURN NEW;
END;
$$;


--
-- Name: update_llm_prompts_updated_at(); Type: FUNCTION; Schema: public; Owner: -
--

CREATE FUNCTION public.update_llm_prompts_updated_at() RETURNS trigger
    LANGUAGE plpgsql
    AS $$
BEGIN
    NEW.updated_at = now();
    RETURN NEW;
END;
$$;


--
-- Name: update_member_role(uuid, text); Type: FUNCTION; Schema: public; Owner: -
--

CREATE FUNCTION public.update_member_role(p_membership_id uuid, p_new_role text) RETURNS jsonb
    LANGUAGE plpgsql SECURITY DEFINER
    SET search_path TO 'public'
    AS $$
DECLARE
  v_membership public.memberships%ROWTYPE;
  v_caller_membership public.memberships%ROWTYPE;
  v_caller_role_level INT;
  v_target_role_level INT;
  v_new_role_level INT;
BEGIN
  -- Get target membership
  SELECT * INTO v_membership
  FROM public.memberships
  WHERE id = p_membership_id;
  
  IF NOT FOUND THEN
    RETURN jsonb_build_object('success', false, 'error', 'Membership not found');
  END IF;

  -- Get caller's membership in same org
  SELECT * INTO v_caller_membership
  FROM public.memberships
  WHERE organization_id = v_membership.organization_id
    AND user_id = auth.uid();
  
  IF NOT FOUND THEN
    RETURN jsonb_build_object('success', false, 'error', 'You are not a member of this organization');
  END IF;

  -- Get role levels
  SELECT level INTO v_caller_role_level FROM public.roles WHERE key = v_caller_membership.role_key;
  SELECT level INTO v_target_role_level FROM public.roles WHERE key = v_membership.role_key;
  SELECT level INTO v_new_role_level FROM public.roles WHERE key = p_new_role;

  -- Validate: Cannot change own role
  IF v_membership.user_id = auth.uid() THEN
    RETURN jsonb_build_object('success', false, 'error', 'Cannot change your own role');
  END IF;

  -- Validate: Must be admin or owner
  IF v_caller_role_level < 80 THEN
    RETURN jsonb_build_object('success', false, 'error', 'Only admins and owners can change roles');
  END IF;

  -- Validate: Cannot change role of someone with equal or higher level
  IF v_target_role_level >= v_caller_role_level THEN
    RETURN jsonb_build_object('success', false, 'error', 'Cannot change role of someone with equal or higher level');
  END IF;

  -- Validate: Cannot assign role equal or higher than your own
  IF v_new_role_level >= v_caller_role_level THEN
    RETURN jsonb_build_object('success', false, 'error', 'Cannot assign role equal or higher than your own');
  END IF;

  -- Update role
  UPDATE public.memberships
  SET role_key = p_new_role,
      updated_at = NOW(),
      updated_by = auth.uid()
  WHERE id = p_membership_id;

  RETURN jsonb_build_object(
    'success', true,
    'membership_id', p_membership_id,
    'new_role', p_new_role
  );
END;
$$;


--
-- Name: update_nlu_intent_examples_updated_at(); Type: FUNCTION; Schema: public; Owner: -
--

CREATE FUNCTION public.update_nlu_intent_examples_updated_at() RETURNS trigger
    LANGUAGE plpgsql
    AS $$
BEGIN
  NEW.updated_at = now();
  RETURN NEW;
END;
$$;


--
-- Name: update_patient_notes_updated_at(); Type: FUNCTION; Schema: public; Owner: -
--

CREATE FUNCTION public.update_patient_notes_updated_at() RETURNS trigger
    LANGUAGE plpgsql
    AS $$
BEGIN
    NEW.updated_at = now();
    RETURN NEW;
END;
$$;


--
-- Name: update_scheduled_shifts_timestamp(); Type: FUNCTION; Schema: public; Owner: -
--

CREATE FUNCTION public.update_scheduled_shifts_timestamp() RETURNS trigger
    LANGUAGE plpgsql
    AS $$
BEGIN
    NEW.updated_at = NOW();
    RETURN NEW;
END;
$$;


--
-- Name: update_shift_templates_timestamp(); Type: FUNCTION; Schema: public; Owner: -
--

CREATE FUNCTION public.update_shift_templates_timestamp() RETURNS trigger
    LANGUAGE plpgsql
    AS $$
BEGIN
    NEW.updated_at = NOW();
    RETURN NEW;
END;
$$;


--
-- Name: update_skill_metrics(); Type: FUNCTION; Schema: public; Owner: -
--

CREATE FUNCTION public.update_skill_metrics() RETURNS trigger
    LANGUAGE plpgsql
    AS $$
BEGIN
  -- Solo actualizar cuando la ejecución se completa o falla
  IF NEW.status IN ('completed', 'failed') AND (OLD.status IS NULL OR OLD.status != NEW.status) THEN
    UPDATE ai_skills
    SET
      usage_count = usage_count + 1,
      last_used_at = NEW.completed_at,
      avg_latency_ms = (
        SELECT COALESCE(AVG(latency_ms)::integer, 0)
        FROM ai_skill_executions
        WHERE skill_id = NEW.skill_id
          AND status = 'completed'
          AND latency_ms IS NOT NULL
      ),
      success_rate = (
        SELECT ROUND(
          (COUNT(*) FILTER (WHERE status = 'completed')::numeric /
           NULLIF(COUNT(*), 0) * 100), 2
        )
        FROM ai_skill_executions
        WHERE skill_id = NEW.skill_id
          AND status IN ('completed', 'failed')
      ),
      updated_at = now()
    WHERE id = NEW.skill_id;
  END IF;

  RETURN NEW;
END;
$$;


--
-- Name: update_subscriptions_updated_at(); Type: FUNCTION; Schema: public; Owner: -
--

CREATE FUNCTION public.update_subscriptions_updated_at() RETURNS trigger
    LANGUAGE plpgsql
    AS $$
BEGIN
    NEW.updated_at = NOW();
    RETURN NEW;
END;
$$;


--
-- Name: update_updated_at_column(); Type: FUNCTION; Schema: public; Owner: -
--

CREATE FUNCTION public.update_updated_at_column() RETURNS trigger
    LANGUAGE plpgsql
    AS $$
BEGIN
    NEW.updated_at = timezone('utc'::text, now());
    RETURN NEW;
END;
$$;


--
-- Name: FUNCTION update_updated_at_column(); Type: COMMENT; Schema: public; Owner: -
--

COMMENT ON FUNCTION public.update_updated_at_column() IS 'Trigger function to automatically update updated_at timestamps';


--
-- Name: update_user_sessions_updated_at(); Type: FUNCTION; Schema: public; Owner: -
--

CREATE FUNCTION public.update_user_sessions_updated_at() RETURNS trigger
    LANGUAGE plpgsql SECURITY DEFINER
    AS $$
BEGIN
    NEW.updated_at = NOW();
    NEW.last_activity_at = NOW();
    RETURN NEW;
END;
$$;


--
-- Name: update_vertical_configs_updated_at(); Type: FUNCTION; Schema: public; Owner: -
--

CREATE FUNCTION public.update_vertical_configs_updated_at() RETURNS trigger
    LANGUAGE plpgsql
    AS $$
BEGIN
  NEW.updated_at = now();
  RETURN NEW;
END;
$$;


--
-- Name: update_waitlist_updated_at(); Type: FUNCTION; Schema: public; Owner: -
--

CREATE FUNCTION public.update_waitlist_updated_at() RETURNS trigger
    LANGUAGE plpgsql
    AS $$
BEGIN
  NEW.updated_at = NOW();
  RETURN NEW;
END;
$$;


--
-- Name: update_walkin_updated_at(); Type: FUNCTION; Schema: public; Owner: -
--

CREATE FUNCTION public.update_walkin_updated_at() RETURNS trigger
    LANGUAGE plpgsql
    AS $$
BEGIN
  NEW.updated_at = NOW();
  RETURN NEW;
END;
$$;


--
-- Name: update_whatsapp_org_config_updated_at(); Type: FUNCTION; Schema: public; Owner: -
--

CREATE FUNCTION public.update_whatsapp_org_config_updated_at() RETURNS trigger
    LANGUAGE plpgsql
    AS $$
BEGIN
  NEW.updated_at = now();
  RETURN NEW;
END;
$$;


--
-- Name: upsert_entity_synonym(character varying, character varying, character varying, uuid, uuid, character varying, character varying, character varying, numeric, character varying); Type: FUNCTION; Schema: public; Owner: -
--

CREATE FUNCTION public.upsert_entity_synonym(p_entity_type character varying, p_synonym character varying, p_canonical_value character varying, p_organization_id uuid DEFAULT NULL::uuid, p_canonical_id uuid DEFAULT NULL::uuid, p_vertical_code character varying DEFAULT NULL::character varying, p_channel character varying DEFAULT NULL::character varying, p_category character varying DEFAULT NULL::character varying, p_weight numeric DEFAULT 1.0, p_match_type character varying DEFAULT 'exact'::character varying) RETURNS uuid
    LANGUAGE plpgsql SECURITY DEFINER
    SET search_path TO 'public'
    AS $$
DECLARE
    v_synonym_id uuid;
BEGIN
    INSERT INTO entity_synonyms (
        entity_type, synonym, canonical_value, organization_id, canonical_id,
        vertical_code, channel, category, weight, match_type
    )
    VALUES (
        p_entity_type, lower(trim(p_synonym)), p_canonical_value, p_organization_id, p_canonical_id,
        p_vertical_code, p_channel, p_category, p_weight, p_match_type
    )
    ON CONFLICT (organization_id, entity_type, synonym, vertical_code, channel, language)
    DO UPDATE SET
        canonical_value = EXCLUDED.canonical_value,
        canonical_id = EXCLUDED.canonical_id,
        category = EXCLUDED.category,
        weight = EXCLUDED.weight,
        match_type = EXCLUDED.match_type,
        updated_at = now()
    RETURNING id INTO v_synonym_id;
    
    RETURN v_synonym_id;
END;
$$;


--
-- Name: upsert_llm_prompt(character varying, text, uuid, character varying, character varying, character varying, character varying, numeric, integer, character varying, text, jsonb); Type: FUNCTION; Schema: public; Owner: -
--

CREATE FUNCTION public.upsert_llm_prompt(p_prompt_key character varying, p_system_prompt text, p_organization_id uuid DEFAULT NULL::uuid, p_vertical_code character varying DEFAULT NULL::character varying, p_channel character varying DEFAULT NULL::character varying, p_language character varying DEFAULT 'es'::character varying, p_model_hint character varying DEFAULT NULL::character varying, p_temperature numeric DEFAULT 0.7, p_max_tokens integer DEFAULT 4000, p_prompt_name character varying DEFAULT NULL::character varying, p_description text DEFAULT NULL::text, p_metadata jsonb DEFAULT '{}'::jsonb) RETURNS uuid
    LANGUAGE plpgsql SECURITY DEFINER
    SET search_path TO 'public'
    AS $$
DECLARE
    v_prompt_id uuid;
BEGIN
    INSERT INTO llm_prompts (
        prompt_key, system_prompt, organization_id, vertical_code, channel,
        language, model_hint, temperature, max_tokens, prompt_name, description, metadata
    )
    VALUES (
        p_prompt_key, p_system_prompt, p_organization_id, p_vertical_code, p_channel,
        p_language, p_model_hint, p_temperature, p_max_tokens, p_prompt_name, p_description, p_metadata
    )
    ON CONFLICT (organization_id, prompt_key, vertical_code, channel, language)
    DO UPDATE SET
        system_prompt = EXCLUDED.system_prompt,
        model_hint = EXCLUDED.model_hint,
        temperature = EXCLUDED.temperature,
        max_tokens = EXCLUDED.max_tokens,
        prompt_name = EXCLUDED.prompt_name,
        description = EXCLUDED.description,
        metadata = EXCLUDED.metadata,
        updated_at = now(),
        version = llm_prompts.version + 1
    RETURNING id INTO v_prompt_id;
    
    RETURN v_prompt_id;
END;
$$;


--
-- Name: user_can_execute_skill(uuid, uuid, text, text, text); Type: FUNCTION; Schema: public; Owner: -
--

CREATE FUNCTION public.user_can_execute_skill(p_user_id uuid, p_organization_id uuid, p_skill_id text, p_module text DEFAULT NULL::text, p_vertical text DEFAULT NULL::text) RETURNS boolean
    LANGUAGE plpgsql STABLE SECURITY DEFINER
    AS $$
BEGIN
    RETURN EXISTS (
        SELECT 1 FROM public.get_user_allowed_skills(
            p_user_id, p_organization_id, p_module, p_vertical
        ) WHERE skill_id = p_skill_id AND can_execute = true
    );
END;
$$;


--
-- Name: validate_days_of_week(); Type: FUNCTION; Schema: public; Owner: -
--

CREATE FUNCTION public.validate_days_of_week() RETURNS trigger
    LANGUAGE plpgsql
    AS $$
DECLARE
  day_val SMALLINT;
BEGIN
  FOREACH day_val IN ARRAY NEW.days_of_week
  LOOP
    IF day_val < 1 OR day_val > 7 THEN
      RAISE EXCEPTION 'days_of_week must contain values between 1 (Monday) and 7 (Sunday), got: %', day_val;
    END IF;
  END LOOP;
  RETURN NEW;
END;
$$;


--
-- Name: authenticate_as(text); Type: FUNCTION; Schema: tests; Owner: -
--

CREATE FUNCTION tests.authenticate_as(identifier text) RETURNS void
    LANGUAGE plpgsql SECURITY DEFINER
    SET search_path TO 'auth', 'pg_temp'
    AS $$
DECLARE
    user_id uuid;
BEGIN
    SELECT id INTO user_id
    FROM auth.users
    WHERE raw_user_meta_data ->> 'test_identifier' = identifier
    LIMIT 1;

    IF user_id IS NULL THEN
        RAISE EXCEPTION 'User with identifier % not found', identifier;
    END IF;

    PERFORM set_config('request.jwt.claim.sub', user_id::text, true);
    PERFORM set_config('request.jwt.claim.role', 'authenticated', true);
    PERFORM set_config('request.jwt.claims', json_build_object('sub', user_id)::text, true);

    EXECUTE 'SET LOCAL ROLE authenticated';
END;
$$;


--
-- Name: authenticate_as_service_role(); Type: FUNCTION; Schema: tests; Owner: -
--

CREATE FUNCTION tests.authenticate_as_service_role() RETURNS void
    LANGUAGE plpgsql SECURITY DEFINER
    AS $$
BEGIN
    PERFORM set_config('request.jwt.claim.sub', '', true);
    PERFORM set_config('request.jwt.claim.role', '', true);
    PERFORM set_config('request.jwt.claims', '', true);

    EXECUTE 'SET LOCAL ROLE service_role';
END;
$$;


--
-- Name: cleanup_test_data(); Type: FUNCTION; Schema: tests; Owner: -
--

CREATE FUNCTION tests.cleanup_test_data() RETURNS void
    LANGUAGE plpgsql SECURITY DEFINER
    SET search_path TO 'public', 'auth', 'pg_temp'
    AS $$
BEGIN
    DELETE FROM auth.users WHERE raw_user_meta_data->>'test_identifier' IS NOT NULL;
    DELETE FROM public.organizations WHERE custom_fields->>'test_data' = 'true';
END;
$$;


--
-- Name: clear_authentication(); Type: FUNCTION; Schema: tests; Owner: -
--

CREATE FUNCTION tests.clear_authentication() RETURNS void
    LANGUAGE plpgsql SECURITY DEFINER
    AS $$
BEGIN
    PERFORM set_config('request.jwt.claim.sub', '', true);
    PERFORM set_config('request.jwt.claim.role', '', true);
    PERFORM set_config('request.jwt.claims', '', true);

    EXECUTE 'SET LOCAL ROLE anon';
END;
$$;


--
-- Name: create_supabase_user(text, text, text, jsonb); Type: FUNCTION; Schema: tests; Owner: -
--

CREATE FUNCTION tests.create_supabase_user(identifier text, email text DEFAULT NULL::text, phone text DEFAULT NULL::text, metadata jsonb DEFAULT NULL::jsonb) RETURNS uuid
    LANGUAGE plpgsql SECURITY DEFINER
    SET search_path TO 'auth', 'pg_temp'
    AS $$
DECLARE
    user_id uuid;
BEGIN
    user_id := gen_random_uuid();

    INSERT INTO auth.users (
        id, email, phone, raw_user_meta_data, raw_app_meta_data,
        created_at, updated_at, email_confirmed_at, aud, role
    )
    VALUES (
        user_id,
        coalesce(email, concat(user_id, '@test.com')),
        phone,
        jsonb_build_object('test_identifier', identifier) || coalesce(metadata, '{}'::jsonb),
        '{}'::jsonb,
        now(), now(), now(), 'authenticated', 'authenticated'
    );

    RETURN user_id;
END;
$$;


--
-- Name: get_supabase_uid(text); Type: FUNCTION; Schema: tests; Owner: -
--

CREATE FUNCTION tests.get_supabase_uid(identifier text) RETURNS uuid
    LANGUAGE plpgsql SECURITY DEFINER
    SET search_path TO 'auth', 'pg_temp'
    AS $$
DECLARE
    user_id uuid;
BEGIN
    SELECT id INTO user_id
    FROM auth.users
    WHERE raw_user_meta_data ->> 'test_identifier' = identifier
    LIMIT 1;

    RETURN user_id;
END;
$$;


--
-- Name: get_supabase_user(text); Type: FUNCTION; Schema: tests; Owner: -
--

CREATE FUNCTION tests.get_supabase_user(identifier text) RETURNS json
    LANGUAGE plpgsql SECURITY DEFINER
    SET search_path TO 'auth', 'pg_temp'
    AS $$
DECLARE
    supabase_user json;
BEGIN
    SELECT json_build_object(
        'id', id, 'email', email, 'phone', phone,
        'raw_user_meta_data', raw_user_meta_data,
        'raw_app_meta_data', raw_app_meta_data
    ) INTO supabase_user
    FROM auth.users
    WHERE raw_user_meta_data ->> 'test_identifier' = identifier
    LIMIT 1;

    RETURN supabase_user;
END;
$$;


--
-- Name: rls_enabled(text); Type: FUNCTION; Schema: tests; Owner: -
--

CREATE FUNCTION tests.rls_enabled(testing_schema text) RETURNS SETOF text
    LANGUAGE plpgsql
    AS $$
DECLARE
    table_name text;
BEGIN
    FOR table_name IN
        SELECT tablename
        FROM pg_tables
        WHERE schemaname = testing_schema
    LOOP
        RETURN QUERY SELECT ok(
            (SELECT relrowsecurity FROM pg_class WHERE oid = (quote_ident(testing_schema) || '.' || quote_ident(table_name))::regclass),
            'RLS should be enabled on table ' || testing_schema || '.' || table_name
        );
    END LOOP;
END;
$$;


--
-- Name: rls_enabled(text, text); Type: FUNCTION; Schema: tests; Owner: -
--

CREATE FUNCTION tests.rls_enabled(testing_schema text, testing_table text) RETURNS SETOF text
    LANGUAGE plpgsql
    AS $$
BEGIN
    RETURN QUERY SELECT ok(
        (SELECT relrowsecurity FROM pg_class WHERE oid = (quote_ident(testing_schema) || '.' || quote_ident(testing_table))::regclass),
        'RLS should be enabled on table ' || testing_schema || '.' || testing_table
    );
END;
$$;


--
-- Name: aggregate_embedding_metrics(); Type: FUNCTION; Schema: util; Owner: -
--

CREATE FUNCTION util.aggregate_embedding_metrics() RETURNS void
    LANGUAGE plpgsql SECURITY DEFINER
    AS $$
BEGIN
  INSERT INTO util.embedding_metrics_hourly (
    hour, source_table, organization_id, jobs_processed, jobs_succeeded, jobs_failed, jobs_skipped,
    total_processing_time_ms, avg_processing_time_ms, min_processing_time_ms, max_processing_time_ms,
    total_content_length, avg_content_length
  )
  SELECT
    date_trunc('hour', completed_at), source_table, organization_id,
    COUNT(*), COUNT(*) FILTER (WHERE status = 'success'),
    COUNT(*) FILTER (WHERE status = 'failed'), COUNT(*) FILTER (WHERE status = 'skipped'),
    SUM(COALESCE(processing_time_ms, 0)), AVG(processing_time_ms)::numeric(10,2),
    MIN(processing_time_ms), MAX(processing_time_ms),
    SUM(COALESCE(content_length, 0)), AVG(content_length)::numeric(10,2)
  FROM util.embedding_job_history
  WHERE completed_at >= date_trunc('hour', now()) - interval '2 hours'
  GROUP BY date_trunc('hour', completed_at), source_table, organization_id
  ON CONFLICT (hour, source_table, organization_id) DO UPDATE SET
    jobs_processed = EXCLUDED.jobs_processed, jobs_succeeded = EXCLUDED.jobs_succeeded,
    jobs_failed = EXCLUDED.jobs_failed, jobs_skipped = EXCLUDED.jobs_skipped,
    total_processing_time_ms = EXCLUDED.total_processing_time_ms,
    avg_processing_time_ms = EXCLUDED.avg_processing_time_ms,
    min_processing_time_ms = EXCLUDED.min_processing_time_ms,
    max_processing_time_ms = EXCLUDED.max_processing_time_ms,
    total_content_length = EXCLUDED.total_content_length,
    avg_content_length = EXCLUDED.avg_content_length, updated_at = now();
END; $$;


--
-- Name: cleanup_embedding_history(integer); Type: FUNCTION; Schema: util; Owner: -
--

CREATE FUNCTION util.cleanup_embedding_history(p_days_to_keep integer DEFAULT 30) RETURNS integer
    LANGUAGE plpgsql SECURITY DEFINER
    AS $$
DECLARE v_deleted int;
BEGIN
  DELETE FROM util.embedding_job_history WHERE created_at < now() - (p_days_to_keep || ' days')::interval;
  GET DIAGNOSTICS v_deleted = ROW_COUNT;
  RETURN v_deleted;
END; $$;


--
-- Name: clear_column(); Type: FUNCTION; Schema: util; Owner: -
--

CREATE FUNCTION util.clear_column() RETURNS trigger
    LANGUAGE plpgsql
    AS $$
declare
  clear_column text := TG_ARGV[0];
begin
  -- Use hstore to set the specified column to NULL
  NEW := NEW #= hstore(clear_column, NULL);
  return NEW;
end;
$$;


--
-- Name: FUNCTION clear_column(); Type: COMMENT; Schema: util; Owner: -
--

COMMENT ON FUNCTION util.clear_column() IS 'Generic trigger to clear a column value (set to NULL) before update. Requires hstore extension.';


--
-- Name: invoke_edge_function(text, jsonb, integer); Type: FUNCTION; Schema: util; Owner: -
--

CREATE FUNCTION util.invoke_edge_function(name text, body jsonb, timeout_milliseconds integer DEFAULT ((5 * 60) * 1000)) RETURNS void
    LANGUAGE plpgsql
    AS $$
DECLARE
  headers_raw text;
  auth_header text;
  service_key text;
BEGIN
  -- Try to get auth from current request headers (for PostgREST sessions)
  headers_raw := current_setting('request.headers', true);
  
  IF headers_raw IS NOT NULL THEN
    auth_header := (headers_raw::json->>'authorization');
  END IF;
  
  -- If no auth from request, use service_role_key from vault
  IF auth_header IS NULL THEN
    SELECT v.decrypted_secret INTO service_key
    FROM vault.decrypted_secrets v
    WHERE v.name = 'service_role_key';
    
    auth_header := service_key;
  END IF;
  
  -- Perform async HTTP request to the edge function
  PERFORM net.http_post(
    url => util.project_url() || '/functions/v1/' || name,
    headers => jsonb_build_object(
      'Content-Type', 'application/json',
      'Authorization', auth_header
    ),
    body => body,
    timeout_milliseconds => timeout_milliseconds
  );
END;
$$;


--
-- Name: FUNCTION invoke_edge_function(name text, body jsonb, timeout_milliseconds integer); Type: COMMENT; Schema: util; Owner: -
--

COMMENT ON FUNCTION util.invoke_edge_function(name text, body jsonb, timeout_milliseconds integer) IS 'Invokes a Supabase Edge Function asynchronously via pg_net with optional authorization';


--
-- Name: process_embeddings(integer, integer, integer); Type: FUNCTION; Schema: util; Owner: -
--

CREATE FUNCTION util.process_embeddings(p_batch_size integer DEFAULT 10, p_visibility_timeout integer DEFAULT 30, p_max_attempts integer DEFAULT 3) RETURNS jsonb
    LANGUAGE plpgsql SECURITY DEFINER
    SET search_path TO 'public, util, pgmq'
    AS $_$
DECLARE
  v_job record;
  v_content text;
  v_start_time timestamptz;
  v_processing_time_ms int;
  v_org_id uuid;
  v_results jsonb := jsonb_build_object(
    'processed', 0, 'succeeded', 0, 'failed', 0, 'skipped', 0, 'moved_to_dlq', 0
  );
  v_error_message text;
  v_error_code text;
  v_wrapper_func text;
BEGIN
  FOR v_job IN
    SELECT * FROM pgmq.read('embeddings_jobs', p_visibility_timeout, p_batch_size)
  LOOP
    v_start_time := clock_timestamp();
    v_results := jsonb_set(v_results, '{processed}', to_jsonb((v_results->>'processed')::int + 1));

    BEGIN
      EXECUTE format('SELECT organization_id FROM %I.%I WHERE id = $1',
        v_job.message->>'schema', v_job.message->>'table'
      ) INTO v_org_id USING (v_job.message->>'id')::uuid;

      -- Use wrapper function with explicit public schema
      v_wrapper_func := v_job.message->>'contentFunction' || '_wrapper';
      EXECUTE format('SELECT public.%I($1)', v_wrapper_func)
        INTO v_content USING (v_job.message->>'id')::uuid;

      IF v_content IS NULL OR trim(v_content) = '' THEN
        PERFORM pgmq.archive('embeddings_jobs', v_job.msg_id);
        v_results := jsonb_set(v_results, '{skipped}', to_jsonb((v_results->>'skipped')::int + 1));
        INSERT INTO util.embedding_job_history (
          msg_id, source_schema, source_table, source_id, status, attempts,
          queued_at, started_at, completed_at, processing_time_ms, organization_id, content_function
        ) VALUES (
          v_job.msg_id, v_job.message->>'schema', v_job.message->>'table',
          (v_job.message->>'id')::uuid, 'skipped', v_job.read_ct,
          v_job.enqueued_at, v_start_time, clock_timestamp(),
          EXTRACT(MILLISECONDS FROM clock_timestamp() - v_start_time)::int,
          v_org_id, v_job.message->>'contentFunction'
        );
        CONTINUE;
      END IF;

      PERFORM util.invoke_edge_function('embed', jsonb_build_array(
        jsonb_build_object(
          'jobId', v_job.msg_id,
          'id', v_job.message->>'id',
          'schema', v_job.message->>'schema',
          'table', v_job.message->>'table',
          'contentFunction', v_job.message->>'contentFunction',
          'embeddingColumn', v_job.message->>'embeddingColumn'
        )
      ));

      v_processing_time_ms := EXTRACT(MILLISECONDS FROM clock_timestamp() - v_start_time)::int;
      PERFORM pgmq.archive('embeddings_jobs', v_job.msg_id);
      v_results := jsonb_set(v_results, '{succeeded}', to_jsonb((v_results->>'succeeded')::int + 1));

      INSERT INTO util.embedding_job_history (
        msg_id, source_schema, source_table, source_id, status, attempts,
        queued_at, started_at, completed_at, processing_time_ms, content_length,
        organization_id, content_function
      ) VALUES (
        v_job.msg_id, v_job.message->>'schema', v_job.message->>'table',
        (v_job.message->>'id')::uuid, 'success', v_job.read_ct,
        v_job.enqueued_at, v_start_time, clock_timestamp(), v_processing_time_ms,
        length(v_content), v_org_id, v_job.message->>'contentFunction'
      );

    EXCEPTION WHEN OTHERS THEN
      GET STACKED DIAGNOSTICS v_error_message = MESSAGE_TEXT, v_error_code = RETURNED_SQLSTATE;
      v_processing_time_ms := EXTRACT(MILLISECONDS FROM clock_timestamp() - v_start_time)::int;
      v_results := jsonb_set(v_results, '{failed}', to_jsonb((v_results->>'failed')::int + 1));

      IF v_job.read_ct >= p_max_attempts THEN
        INSERT INTO util.embedding_dead_letter_queue (
          original_msg_id, source_schema, source_table, source_id,
          content_function, embedding_column, error_message, error_code,
          attempts, last_attempt_at, organization_id, job_payload
        ) VALUES (
          v_job.msg_id, v_job.message->>'schema', v_job.message->>'table',
          (v_job.message->>'id')::uuid, v_job.message->>'contentFunction',
          v_job.message->>'embeddingColumn', v_error_message, v_error_code,
          v_job.read_ct, clock_timestamp(), v_org_id, v_job.message
        );
        PERFORM pgmq.archive('embeddings_jobs', v_job.msg_id);
        v_results := jsonb_set(v_results, '{moved_to_dlq}', to_jsonb((v_results->>'moved_to_dlq')::int + 1));
      END IF;

      INSERT INTO util.embedding_job_history (
        msg_id, source_schema, source_table, source_id, status, attempts,
        queued_at, started_at, completed_at, processing_time_ms,
        error_message, error_code, organization_id, content_function
      ) VALUES (
        v_job.msg_id, v_job.message->>'schema', v_job.message->>'table',
        (v_job.message->>'id')::uuid, 'failed', v_job.read_ct,
        v_job.enqueued_at, v_start_time, clock_timestamp(), v_processing_time_ms,
        v_error_message, v_error_code, v_org_id, v_job.message->>'contentFunction'
      );
    END;
  END LOOP;

  RETURN v_results;
END;
$_$;


--
-- Name: process_embeddings_with_ai(integer, integer, integer); Type: FUNCTION; Schema: util; Owner: -
--

CREATE FUNCTION util.process_embeddings_with_ai(p_batch_size integer DEFAULT 10, p_max_jobs integer DEFAULT 10, p_timeout_seconds integer DEFAULT 30) RETURNS jsonb
    LANGUAGE plpgsql
    AS $$
DECLARE
  v_jobs JSONB[];
  v_job JSONB;
  v_message JSONB;
  v_job_id BIGINT;
  v_content TEXT;
  v_response BIGINT;
  v_analyze_ai BOOLEAN;
  v_entity_type TEXT;
  v_processed INTEGER := 0;
  v_failed INTEGER := 0;
  v_total INTEGER := 0;
  v_edge_function TEXT;
  v_url TEXT;
  v_body JSONB;
  v_headers JSONB;
BEGIN
  -- Read jobs from queue
  SELECT array_agg(row_to_json(r)::jsonb) INTO v_jobs
  FROM pgmq.read('embedding_jobs', p_timeout_seconds, p_max_jobs) r;

  IF v_jobs IS NULL OR array_length(v_jobs, 1) IS NULL THEN
    RETURN jsonb_build_object(
      'status', 'no_jobs',
      'processed', 0,
      'failed', 0,
      'total', 0
    );
  END IF;

  -- Store total before processing
  v_total := array_length(v_jobs, 1);

  FOREACH v_job IN ARRAY v_jobs LOOP
    BEGIN
      v_job_id := (v_job->>'msg_id')::BIGINT;
      v_message := v_job->'message';

      v_analyze_ai := COALESCE((v_message->>'analyzeAi')::boolean, false);
      v_entity_type := COALESCE(v_message->>'entityType', v_message->>'table');

      RAISE NOTICE 'Processing job %: table=%, id=%', v_job_id, v_message->>'table', v_message->>'id';

      -- Get content using content function
      EXECUTE format('SELECT %I(t) FROM %I.%I t WHERE id = %L',
        v_message->>'contentFunction',
        v_message->>'schema',
        v_message->>'table',
        v_message->>'id'
      ) INTO v_content;

      IF v_content IS NULL OR trim(v_content) = '' THEN
        RAISE NOTICE 'No content for job %, archiving', v_job_id;
        PERFORM pgmq.archive('embedding_jobs', v_job_id);
        CONTINUE;
      END IF;

      v_edge_function := CASE WHEN v_analyze_ai THEN 'embed-and-analyze' ELSE 'embed' END;
      v_url := util.project_url() || '/functions/v1/' || v_edge_function;
      
      v_headers := jsonb_build_object(
        'Content-Type', 'application/json',
        'Authorization', 'Bearer ' || util.service_role_key()
      );
      
      v_body := jsonb_build_array(
        jsonb_build_object(
          'jobId', v_job_id,
          'id', v_message->>'id',
          'schema', v_message->>'schema',
          'table', v_message->>'table',
          'contentFunction', v_message->>'contentFunction',
          'embeddingColumn', v_message->>'embeddingColumn',
          'content', v_content,
          'analyzeAi', v_analyze_ai,
          'entityType', v_entity_type
        )
      );

      RAISE NOTICE 'Calling % with content length %', v_url, length(v_content);

      -- Use positional parameters: url, body, params, headers, timeout
      -- net.http_post signature: (url text, body jsonb, params jsonb, headers jsonb, timeout_milliseconds integer)
      SELECT net.http_post(
        v_url,
        v_body,
        '{}'::jsonb,  -- params
        v_headers,
        30000  -- timeout in milliseconds
      ) INTO v_response;

      RAISE NOTICE 'HTTP response ID: %', v_response;

      PERFORM pgmq.archive('embedding_jobs', v_job_id);
      v_processed := v_processed + 1;

    EXCEPTION WHEN OTHERS THEN
      PERFORM pgmq.archive('embedding_jobs', v_job_id);
      v_failed := v_failed + 1;
      RAISE WARNING 'Error processing job %: %', v_job_id, SQLERRM;
    END;
  END LOOP;

  RETURN jsonb_build_object(
    'status', 'completed',
    'processed', v_processed,
    'failed', v_failed,
    'total', v_total
  );
END;
$$;


--
-- Name: FUNCTION process_embeddings_with_ai(p_batch_size integer, p_max_jobs integer, p_timeout_seconds integer); Type: COMMENT; Schema: util; Owner: -
--

COMMENT ON FUNCTION util.process_embeddings_with_ai(p_batch_size integer, p_max_jobs integer, p_timeout_seconds integer) IS 'Processes embedding queue with correct net.http_post signature (positional params).';


--
-- Name: project_url(); Type: FUNCTION; Schema: util; Owner: -
--

CREATE FUNCTION util.project_url() RETURNS text
    LANGUAGE plpgsql SECURITY DEFINER
    AS $$
declare
  secret_value text;
begin
  -- Retrieve the project URL from Vault
  select decrypted_secret into secret_value 
  from vault.decrypted_secrets 
  where name = 'project_url';
  
  return secret_value;
end;
$$;


--
-- Name: FUNCTION project_url(); Type: COMMENT; Schema: util; Owner: -
--

COMMENT ON FUNCTION util.project_url() IS 'Retrieves Supabase project URL from Vault for Edge Function invocations';


--
-- Name: queue_embeddings(); Type: FUNCTION; Schema: util; Owner: -
--

CREATE FUNCTION util.queue_embeddings() RETURNS trigger
    LANGUAGE plpgsql SECURITY DEFINER
    SET search_path TO ''
    AS $$
declare
  content_function text = TG_ARGV[0];
  embedding_column text = TG_ARGV[1];
begin
  -- Send message to pgmq queue (correct name: embeddings_jobs with 's')
  perform pgmq.send(
    queue_name => 'embeddings_jobs',
    msg => jsonb_build_object(
      'id', NEW.id,
      'schema', TG_TABLE_SCHEMA,
      'table', TG_TABLE_NAME,
      'contentFunction', content_function,
      'embeddingColumn', embedding_column
    )
  );
  
  return NEW;
end;
$$;


--
-- Name: FUNCTION queue_embeddings(); Type: COMMENT; Schema: util; Owner: -
--

COMMENT ON FUNCTION util.queue_embeddings() IS 'Trigger function that queues embedding generation jobs in pgmq. Requires table to have id column.';


--
-- Name: queue_embeddings_with_ai(); Type: FUNCTION; Schema: util; Owner: -
--

CREATE FUNCTION util.queue_embeddings_with_ai() RETURNS trigger
    LANGUAGE plpgsql SECURITY DEFINER
    SET search_path TO ''
    AS $$
declare
  content_function text = TG_ARGV[0];
  embedding_column text = TG_ARGV[1];
  analyze_ai boolean = COALESCE(TG_ARGV[2]::boolean, false);
  entity_type text = COALESCE(TG_ARGV[3], TG_TABLE_NAME);
begin
  -- Send message to pgmq queue with AI analysis flag
  perform pgmq.send(
    queue_name => 'embedding_jobs',
    msg => jsonb_build_object(
      'id', NEW.id,
      'schema', TG_TABLE_SCHEMA,
      'table', TG_TABLE_NAME,
      'contentFunction', content_function,
      'embeddingColumn', embedding_column,
      'analyzeAi', analyze_ai,
      'entityType', entity_type
    )
  );
  
  return NEW;
end;
$$;


--
-- Name: FUNCTION queue_embeddings_with_ai(); Type: COMMENT; Schema: util; Owner: -
--

COMMENT ON FUNCTION util.queue_embeddings_with_ai() IS 'Trigger function that queues embedding generation AND AI analysis jobs. 
Args: contentFunction, embeddingColumn, analyzeAi (bool), entityType';


--
-- Name: resolve_dlq_job(uuid, text, text); Type: FUNCTION; Schema: util; Owner: -
--

CREATE FUNCTION util.resolve_dlq_job(p_dlq_id uuid, p_resolution text DEFAULT 'resolved'::text, p_notes text DEFAULT NULL::text) RETURNS boolean
    LANGUAGE plpgsql SECURITY DEFINER
    AS $$
BEGIN
  UPDATE util.embedding_dead_letter_queue
  SET status = p_resolution, resolved_at = now(), resolved_by = current_user, resolution_notes = p_notes, updated_at = now()
  WHERE id = p_dlq_id;
  RETURN FOUND;
END; $$;


--
-- Name: retry_dlq_job(uuid); Type: FUNCTION; Schema: util; Owner: -
--

CREATE FUNCTION util.retry_dlq_job(p_dlq_id uuid) RETURNS boolean
    LANGUAGE plpgsql SECURITY DEFINER
    AS $$
DECLARE v_job record;
BEGIN
  SELECT * INTO v_job FROM util.embedding_dead_letter_queue WHERE id = p_dlq_id AND status = 'failed';
  IF NOT FOUND THEN RAISE EXCEPTION 'DLQ job not found: %', p_dlq_id; END IF;
  
  PERFORM pgmq.send('embeddings_jobs', jsonb_build_object(
    'id', v_job.source_id, 'schema', v_job.source_schema, 'table', v_job.source_table,
    'contentFunction', v_job.content_function, 'embeddingColumn', v_job.embedding_column,
    'retried_from_dlq', v_job.id
  ));
  
  UPDATE util.embedding_dead_letter_queue SET status = 'retrying', updated_at = now() WHERE id = p_dlq_id;
  RETURN true;
END; $$;


--
-- Name: service_role_key(); Type: FUNCTION; Schema: util; Owner: -
--

CREATE FUNCTION util.service_role_key() RETURNS text
    LANGUAGE plpgsql SECURITY DEFINER
    SET search_path TO ''
    AS $$
declare
  secret_value text;
begin
  -- Retrieve the service role key from Vault
  select decrypted_secret into secret_value
  from vault.decrypted_secrets
  where name = 'service_role_key';

  -- Remove 'Bearer ' prefix if present (some secrets include it)
  IF secret_value LIKE 'Bearer %' THEN
    secret_value := substring(secret_value from 8);
  END IF;

  return secret_value;
end;
$$;


--
-- Name: FUNCTION service_role_key(); Type: COMMENT; Schema: util; Owner: -
--

COMMENT ON FUNCTION util.service_role_key() IS 'Returns the service_role JWT from vault.secrets. Strips "Bearer " prefix if present.';


--
-- Name: a_embedding_jobs; Type: TABLE; Schema: pgmq; Owner: -
--

CREATE TABLE pgmq.a_embedding_jobs (
    msg_id bigint NOT NULL,
    read_ct integer DEFAULT 0 NOT NULL,
    enqueued_at timestamp with time zone DEFAULT now() NOT NULL,
    archived_at timestamp with time zone DEFAULT now() NOT NULL,
    vt timestamp with time zone NOT NULL,
    message jsonb,
    headers jsonb
);


--
-- Name: a_embeddings_jobs; Type: TABLE; Schema: pgmq; Owner: -
--

CREATE TABLE pgmq.a_embeddings_jobs (
    msg_id bigint NOT NULL,
    read_ct integer DEFAULT 0 NOT NULL,
    enqueued_at timestamp with time zone DEFAULT now() NOT NULL,
    archived_at timestamp with time zone DEFAULT now() NOT NULL,
    vt timestamp with time zone NOT NULL,
    message jsonb,
    headers jsonb
);


--
-- Name: q_embedding_jobs; Type: TABLE; Schema: pgmq; Owner: -
--

CREATE TABLE pgmq.q_embedding_jobs (
    msg_id bigint NOT NULL,
    read_ct integer DEFAULT 0 NOT NULL,
    enqueued_at timestamp with time zone DEFAULT now() NOT NULL,
    vt timestamp with time zone NOT NULL,
    message jsonb,
    headers jsonb
);


--
-- Name: q_embedding_jobs_msg_id_seq; Type: SEQUENCE; Schema: pgmq; Owner: -
--

ALTER TABLE pgmq.q_embedding_jobs ALTER COLUMN msg_id ADD GENERATED ALWAYS AS IDENTITY (
    SEQUENCE NAME pgmq.q_embedding_jobs_msg_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1
);


--
-- Name: q_embeddings_jobs; Type: TABLE; Schema: pgmq; Owner: -
--

CREATE TABLE pgmq.q_embeddings_jobs (
    msg_id bigint NOT NULL,
    read_ct integer DEFAULT 0 NOT NULL,
    enqueued_at timestamp with time zone DEFAULT now() NOT NULL,
    vt timestamp with time zone NOT NULL,
    message jsonb,
    headers jsonb
);


--
-- Name: q_embeddings_jobs_msg_id_seq; Type: SEQUENCE; Schema: pgmq; Owner: -
--

ALTER TABLE pgmq.q_embeddings_jobs ALTER COLUMN msg_id ADD GENERATED ALWAYS AS IDENTITY (
    SEQUENCE NAME pgmq.q_embeddings_jobs_msg_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1
);


--
-- Name: _migrations; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public._migrations (
    id integer NOT NULL,
    name text NOT NULL,
    applied_at timestamp with time zone DEFAULT now()
);


--
-- Name: _migrations_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE public._migrations_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: _migrations_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE public._migrations_id_seq OWNED BY public._migrations.id;


--
-- Name: ai_cache; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.ai_cache (
    id uuid DEFAULT gen_random_uuid() NOT NULL,
    cache_key text NOT NULL,
    prompt_hash text NOT NULL,
    prompt_text text NOT NULL,
    response_text text NOT NULL,
    model text NOT NULL,
    organization_id uuid,
    hit_count integer DEFAULT 0,
    last_accessed_at timestamp with time zone DEFAULT now() NOT NULL,
    expires_at timestamp with time zone,
    created_at timestamp with time zone DEFAULT now() NOT NULL
);


--
-- Name: TABLE ai_cache; Type: COMMENT; Schema: public; Owner: -
--

COMMENT ON TABLE public.ai_cache IS 'Cache of AI responses to reduce API costs and improve latency';


--
-- Name: ai_conversations; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.ai_conversations (
    id uuid DEFAULT gen_random_uuid() NOT NULL,
    user_id uuid,
    organization_id uuid NOT NULL,
    context_type text DEFAULT 'general'::text NOT NULL,
    context_entity_id uuid,
    messages jsonb DEFAULT '[]'::jsonb NOT NULL,
    model_used text DEFAULT 'gpt-4o-mini'::text,
    total_tokens integer DEFAULT 0,
    status public.ai_conversation_status DEFAULT 'active'::public.ai_conversation_status NOT NULL,
    created_at timestamp with time zone DEFAULT now() NOT NULL,
    updated_at timestamp with time zone DEFAULT now() NOT NULL,
    last_message_at timestamp with time zone DEFAULT now() NOT NULL,
    channel text DEFAULT 'web'::text,
    phone_number text,
    summary text,
    collected_slots jsonb DEFAULT '{}'::jsonb,
    last_intent text,
    session_id uuid
);


--
-- Name: TABLE ai_conversations; Type: COMMENT; Schema: public; Owner: -
--

COMMENT ON TABLE public.ai_conversations IS 'AI chat conversation history';


--
-- Name: COLUMN ai_conversations.context_type; Type: COMMENT; Schema: public; Owner: -
--

COMMENT ON COLUMN public.ai_conversations.context_type IS 'Context: general, appointment_booking, patient_search, medical_notes';


--
-- Name: COLUMN ai_conversations.messages; Type: COMMENT; Schema: public; Owner: -
--

COMMENT ON COLUMN public.ai_conversations.messages IS 'Array of messages: [{"role": "user|assistant", "content": "...", "timestamp": "..."}]';


--
-- Name: COLUMN ai_conversations.channel; Type: COMMENT; Schema: public; Owner: -
--

COMMENT ON COLUMN public.ai_conversations.channel IS 'Origin channel: whatsapp, web, app, voice';


--
-- Name: COLUMN ai_conversations.phone_number; Type: COMMENT; Schema: public; Owner: -
--

COMMENT ON COLUMN public.ai_conversations.phone_number IS 'Phone number for identifying users without auth (WhatsApp)';


--
-- Name: COLUMN ai_conversations.summary; Type: COMMENT; Schema: public; Owner: -
--

COMMENT ON COLUMN public.ai_conversations.summary IS 'AI-generated summary of the conversation for context reuse';


--
-- Name: COLUMN ai_conversations.collected_slots; Type: COMMENT; Schema: public; Owner: -
--

COMMENT ON COLUMN public.ai_conversations.collected_slots IS 'Slots collected during conversation: {"doctor": "Dr. Pérez", "service": "consulta"}';


--
-- Name: COLUMN ai_conversations.last_intent; Type: COMMENT; Schema: public; Owner: -
--

COMMENT ON COLUMN public.ai_conversations.last_intent IS 'Last detected intent: create_appointment, cancel_appointment, etc.';


--
-- Name: COLUMN ai_conversations.session_id; Type: COMMENT; Schema: public; Owner: -
--

COMMENT ON COLUMN public.ai_conversations.session_id IS 'Session ID for grouping related conversations';


--
-- Name: ai_embedding_configs; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.ai_embedding_configs (
    id uuid DEFAULT gen_random_uuid() NOT NULL,
    table_name text NOT NULL,
    table_schema text DEFAULT 'public'::text NOT NULL,
    content_columns text[] NOT NULL,
    custom_content_sql text,
    filter_condition text,
    watch_columns text[],
    trigger_enabled boolean DEFAULT true,
    enabled boolean DEFAULT true,
    created_at timestamp with time zone DEFAULT now(),
    updated_at timestamp with time zone DEFAULT now(),
    created_by uuid
);


--
-- Name: TABLE ai_embedding_configs; Type: COMMENT; Schema: public; Owner: -
--

COMMENT ON TABLE public.ai_embedding_configs IS 'Registry of tables with auto-embedding enabled';


--
-- Name: COLUMN ai_embedding_configs.content_columns; Type: COMMENT; Schema: public; Owner: -
--

COMMENT ON COLUMN public.ai_embedding_configs.content_columns IS 'Array of column names to concatenate for embedding content';


--
-- Name: COLUMN ai_embedding_configs.custom_content_sql; Type: COMMENT; Schema: public; Owner: -
--

COMMENT ON COLUMN public.ai_embedding_configs.custom_content_sql IS 'Optional: Custom SQL to generate content (can reference NEW.column_name)';


--
-- Name: COLUMN ai_embedding_configs.filter_condition; Type: COMMENT; Schema: public; Owner: -
--

COMMENT ON COLUMN public.ai_embedding_configs.filter_condition IS 'Optional: WHERE clause to filter which rows get embedded';


--
-- Name: ai_embedding_queue; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.ai_embedding_queue (
    id uuid DEFAULT gen_random_uuid() NOT NULL,
    source_table text NOT NULL,
    source_id uuid NOT NULL,
    organization_id uuid NOT NULL,
    content text NOT NULL,
    status public.ai_embedding_status DEFAULT 'pending'::public.ai_embedding_status NOT NULL,
    error_message text,
    retry_count integer DEFAULT 0,
    created_at timestamp with time zone DEFAULT now() NOT NULL,
    updated_at timestamp with time zone DEFAULT now() NOT NULL,
    processed_at timestamp with time zone
);


--
-- Name: TABLE ai_embedding_queue; Type: COMMENT; Schema: public; Owner: -
--

COMMENT ON TABLE public.ai_embedding_queue IS 'Queue for asynchronous embedding generation via Edge Functions';


--
-- Name: ai_embeddings; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.ai_embeddings (
    id uuid DEFAULT gen_random_uuid() NOT NULL,
    source_table text NOT NULL,
    source_id uuid NOT NULL,
    content text NOT NULL,
    content_type text DEFAULT 'full_record'::text NOT NULL,
    embedding extensions.vector(1536),
    metadata jsonb DEFAULT '{}'::jsonb,
    model_name text DEFAULT 'text-embedding-3-small'::text,
    model_version text,
    organization_id uuid NOT NULL,
    created_at timestamp with time zone DEFAULT now() NOT NULL,
    updated_at timestamp with time zone DEFAULT now() NOT NULL
);


--
-- Name: TABLE ai_embeddings; Type: COMMENT; Schema: public; Owner: -
--

COMMENT ON TABLE public.ai_embeddings IS 'Vector embeddings for AI-powered semantic search';


--
-- Name: COLUMN ai_embeddings.embedding; Type: COMMENT; Schema: public; Owner: -
--

COMMENT ON COLUMN public.ai_embeddings.embedding IS 'Vector of 1536 dimensions (OpenAI text-embedding-3-small)';


--
-- Name: COLUMN ai_embeddings.metadata; Type: COMMENT; Schema: public; Owner: -
--

COMMENT ON COLUMN public.ai_embeddings.metadata IS 'Metadata for hybrid filtering (e.g., {"entity_type": "patient", "status": "active"})';


--
-- Name: ai_interactions; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.ai_interactions (
    id uuid DEFAULT gen_random_uuid() NOT NULL,
    organization_id uuid NOT NULL,
    user_id uuid NOT NULL,
    query text NOT NULL,
    result_summary text NOT NULL,
    skills_executed text[] DEFAULT '{}'::text[],
    cost numeric(10,4) DEFAULT 0,
    duration_ms integer DEFAULT 0,
    embedding extensions.vector(1536),
    metadata jsonb DEFAULT '{}'::jsonb,
    created_at timestamp with time zone DEFAULT now()
);


--
-- Name: TABLE ai_interactions; Type: COMMENT; Schema: public; Owner: -
--

COMMENT ON TABLE public.ai_interactions IS 'Memoria semántica de interacciones usuario-IA. Usado para RAG y aprendizaje.';


--
-- Name: ai_search_logs; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.ai_search_logs (
    id uuid DEFAULT gen_random_uuid() NOT NULL,
    query_text text NOT NULL,
    organization_id uuid NOT NULL,
    user_id uuid,
    results_count integer NOT NULL,
    avg_similarity_score double precision,
    latency_ms integer,
    search_type text DEFAULT 'semantic'::text,
    filters_applied jsonb,
    created_at timestamp with time zone DEFAULT now() NOT NULL
);


--
-- Name: TABLE ai_search_logs; Type: COMMENT; Schema: public; Owner: -
--

COMMENT ON TABLE public.ai_search_logs IS 'Logs of semantic searches for analytics and performance monitoring';


--
-- Name: ai_skill_executions; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.ai_skill_executions (
    id uuid DEFAULT gen_random_uuid() NOT NULL,
    skill_id uuid NOT NULL,
    organization_id uuid NOT NULL,
    user_id uuid,
    conversation_id uuid,
    channel text,
    request_id text,
    input_params jsonb,
    output_result jsonb,
    reasoning text,
    status public.skill_execution_status DEFAULT 'pending'::public.skill_execution_status NOT NULL,
    error_message text,
    error_code text,
    latency_ms integer,
    tokens_used integer,
    requires_approval boolean DEFAULT false,
    approved_by uuid,
    approved_at timestamp with time zone,
    started_at timestamp with time zone DEFAULT now(),
    completed_at timestamp with time zone,
    created_at timestamp with time zone DEFAULT now()
);


--
-- Name: TABLE ai_skill_executions; Type: COMMENT; Schema: public; Owner: -
--

COMMENT ON TABLE public.ai_skill_executions IS 'Audit trail of all skill executions';


--
-- Name: COLUMN ai_skill_executions.reasoning; Type: COMMENT; Schema: public; Owner: -
--

COMMENT ON COLUMN public.ai_skill_executions.reasoning IS 'LLM explanation of why this skill was selected';


--
-- Name: ai_skills; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.ai_skills (
    id uuid DEFAULT gen_random_uuid() NOT NULL,
    name text NOT NULL,
    version text DEFAULT '1.0.0'::text NOT NULL,
    description text NOT NULL,
    parameters jsonb DEFAULT '{}'::jsonb NOT NULL,
    edge_function text NOT NULL,
    category public.skill_category DEFAULT 'general'::public.skill_category NOT NULL,
    requires_approval boolean DEFAULT false,
    approval_threshold numeric,
    enabled boolean DEFAULT true,
    usage_count integer DEFAULT 0,
    avg_latency_ms integer,
    success_rate numeric(5,2),
    last_used_at timestamp with time zone,
    created_at timestamp with time zone DEFAULT now(),
    updated_at timestamp with time zone DEFAULT now(),
    deprecated_at timestamp with time zone,
    CONSTRAINT valid_success_rate CHECK (((success_rate IS NULL) OR ((success_rate >= (0)::numeric) AND (success_rate <= (100)::numeric))))
);


--
-- Name: TABLE ai_skills; Type: COMMENT; Schema: public; Owner: -
--

COMMENT ON TABLE public.ai_skills IS 'Registry of available AI skills for the orchestrator';


--
-- Name: COLUMN ai_skills.parameters; Type: COMMENT; Schema: public; Owner: -
--

COMMENT ON COLUMN public.ai_skills.parameters IS 'JSON Schema defining the skill parameters';


--
-- Name: COLUMN ai_skills.requires_approval; Type: COMMENT; Schema: public; Owner: -
--

COMMENT ON COLUMN public.ai_skills.requires_approval IS 'If true, execution requires human approval';


--
-- Name: ai_usage; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.ai_usage (
    id uuid DEFAULT gen_random_uuid() NOT NULL,
    organization_id uuid NOT NULL,
    user_id uuid NOT NULL,
    request_id uuid NOT NULL,
    model text NOT NULL,
    skill_id text,
    cost numeric(10,4) NOT NULL,
    tokens_input integer DEFAULT 0,
    tokens_output integer DEFAULT 0,
    metadata jsonb DEFAULT '{}'::jsonb,
    created_at timestamp with time zone DEFAULT now()
);


--
-- Name: TABLE ai_usage; Type: COMMENT; Schema: public; Owner: -
--

COMMENT ON TABLE public.ai_usage IS 'Tracking detallado de costos y uso de IA. Para billing y análisis.';


--
-- Name: appointment_audit_log; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.appointment_audit_log (
    id uuid DEFAULT gen_random_uuid() NOT NULL,
    appointment_id uuid NOT NULL,
    user_id uuid,
    user_name text NOT NULL,
    action text NOT NULL,
    "timestamp" timestamp with time zone DEFAULT now() NOT NULL,
    previous_values jsonb,
    new_values jsonb,
    description text,
    reason text,
    client_note text,
    ip_address text,
    user_agent text,
    organization_id uuid NOT NULL,
    created_at timestamp with time zone DEFAULT now() NOT NULL,
    CONSTRAINT appointment_audit_log_action_check CHECK ((action = ANY (ARRAY['created'::text, 'updated'::text, 'rescheduled'::text, 'cancelled'::text, 'no_show'::text, 'completed'::text, 'confirmed'::text, 'status_changed'::text, 'resource_changed'::text])))
);


--
-- Name: TABLE appointment_audit_log; Type: COMMENT; Schema: public; Owner: -
--

COMMENT ON TABLE public.appointment_audit_log IS 'Tracks all changes to appointments for compliance and history';


--
-- Name: appointment_resources; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.appointment_resources (
    id uuid DEFAULT gen_random_uuid() NOT NULL,
    appointment_id uuid NOT NULL,
    resource_entity_id uuid NOT NULL,
    resource_type public.appointment_resource_type NOT NULL,
    resource_subtype text,
    resource_role text DEFAULT 'assistant'::text,
    start_time time without time zone,
    end_time time without time zone,
    duration_minutes integer,
    status public.appointment_resource_status DEFAULT 'assigned'::public.appointment_resource_status,
    notes text,
    custom_fields jsonb DEFAULT '{}'::jsonb,
    created_at timestamp with time zone DEFAULT now() NOT NULL,
    updated_at timestamp with time zone DEFAULT now() NOT NULL,
    CONSTRAINT appointment_resources_resource_role_check CHECK ((resource_role = ANY (ARRAY['primary'::text, 'assistant'::text, 'backup'::text, 'equipment'::text, 'space'::text, 'other'::text]))),
    CONSTRAINT appointment_resources_time_check CHECK (((end_time IS NULL) OR (end_time > start_time)))
);


--
-- Name: TABLE appointment_resources; Type: COMMENT; Schema: public; Owner: -
--

COMMENT ON TABLE public.appointment_resources IS 'Multiple resources (people, equipment, rooms) per appointment';


--
-- Name: attribute_definitions; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.attribute_definitions (
    id uuid DEFAULT gen_random_uuid() NOT NULL,
    organization_id uuid,
    attribute_code character varying(50) NOT NULL,
    display_name text NOT NULL,
    description text,
    data_type character varying(20) NOT NULL,
    allowed_values jsonb,
    default_value jsonb,
    validation_rules jsonb,
    unit_of_measure character varying(20),
    applicable_item_types text[] DEFAULT '{}'::text[],
    is_variant_attribute boolean DEFAULT false NOT NULL,
    is_filterable boolean DEFAULT true NOT NULL,
    is_searchable boolean DEFAULT true NOT NULL,
    is_required boolean DEFAULT false NOT NULL,
    sort_order integer DEFAULT 0,
    display_group character varying(50),
    embedding extensions.vector(1536),
    created_at timestamp with time zone DEFAULT now() NOT NULL,
    updated_at timestamp with time zone DEFAULT now() NOT NULL,
    CONSTRAINT attribute_definitions_data_type_check CHECK (((data_type)::text = ANY ((ARRAY['text'::character varying, 'number'::character varying, 'boolean'::character varying, 'date'::character varying, 'select'::character varying, 'multi_select'::character varying, 'color'::character varying, 'url'::character varying])::text[])))
);


--
-- Name: TABLE attribute_definitions; Type: COMMENT; Schema: public; Owner: -
--

COMMENT ON TABLE public.attribute_definitions IS 'Defines available attributes for catalog items (color, size, etc.)';


--
-- Name: audit_logs; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.audit_logs (
    id uuid DEFAULT gen_random_uuid() NOT NULL,
    organization_id uuid,
    user_id uuid,
    action text NOT NULL,
    table_name text NOT NULL,
    record_id uuid,
    old_values jsonb,
    new_values jsonb,
    created_at timestamp with time zone DEFAULT timezone('utc'::text, now()) NOT NULL,
    CONSTRAINT audit_logs_action_check CHECK ((length(action) > 0))
);


--
-- Name: TABLE audit_logs; Type: COMMENT; Schema: public; Owner: -
--

COMMENT ON TABLE public.audit_logs IS 'Audit trail for all important data changes';


--
-- Name: booking_configurations; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.booking_configurations (
    id uuid DEFAULT gen_random_uuid() NOT NULL,
    organization_id uuid NOT NULL,
    business_name text NOT NULL,
    logo_url text,
    primary_color text DEFAULT '#0D47A1'::text,
    custom_css text,
    enabled_service_ids uuid[] DEFAULT '{}'::uuid[],
    enabled_resource_ids uuid[] DEFAULT '{}'::uuid[],
    allow_resource_selection boolean DEFAULT true,
    any_available_text text DEFAULT 'Any available'::text,
    advance_booking_days integer DEFAULT 30,
    minimum_notice_hours integer DEFAULT 1,
    max_bookings_per_day integer DEFAULT 1,
    slot_duration_minutes integer DEFAULT 30,
    require_payment boolean DEFAULT false,
    deposit_amount numeric(12,2),
    deposit_type text,
    terms_url text,
    privacy_url text,
    welcome_message text,
    confirmation_message text DEFAULT 'Your appointment has been confirmed. We look forward to seeing you!'::text,
    send_confirmation_email boolean DEFAULT true,
    send_reminder_email boolean DEFAULT true,
    reminder_hours integer DEFAULT 24,
    required_fields text[] DEFAULT ARRAY['name'::text, 'email'::text, 'phone'::text],
    custom_fields jsonb DEFAULT '[]'::jsonb,
    timezone text DEFAULT 'America/Santo_Domingo'::text,
    locale text DEFAULT 'en'::text,
    created_at timestamp with time zone DEFAULT now() NOT NULL,
    updated_at timestamp with time zone DEFAULT now() NOT NULL,
    CONSTRAINT booking_configurations_advance_booking_days_check CHECK ((advance_booking_days > 0)),
    CONSTRAINT booking_configurations_deposit_type_check CHECK ((deposit_type = ANY (ARRAY['fixed'::text, 'percentage'::text]))),
    CONSTRAINT booking_configurations_max_bookings_per_day_check CHECK ((max_bookings_per_day > 0)),
    CONSTRAINT booking_configurations_minimum_notice_hours_check CHECK ((minimum_notice_hours >= 0)),
    CONSTRAINT booking_configurations_slot_duration_minutes_check CHECK ((slot_duration_minutes > 0))
);


--
-- Name: TABLE booking_configurations; Type: COMMENT; Schema: public; Owner: -
--

COMMENT ON TABLE public.booking_configurations IS 'Configuration for public booking widget';


--
-- Name: booking_sessions; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.booking_sessions (
    id uuid DEFAULT gen_random_uuid() NOT NULL,
    organization_id uuid NOT NULL,
    service_id uuid,
    resource_entity_id uuid,
    slot_start timestamp with time zone NOT NULL,
    slot_end timestamp with time zone NOT NULL,
    client_info jsonb NOT NULL,
    custom_field_values jsonb,
    status text DEFAULT 'pending'::text,
    expires_at timestamp with time zone NOT NULL,
    confirmed_appointment_id uuid,
    created_at timestamp with time zone DEFAULT now() NOT NULL,
    CONSTRAINT booking_sessions_status_check CHECK ((status = ANY (ARRAY['pending'::text, 'confirmed'::text, 'expired'::text, 'cancelled'::text])))
);


--
-- Name: TABLE booking_sessions; Type: COMMENT; Schema: public; Owner: -
--

COMMENT ON TABLE public.booking_sessions IS 'Temporary holds on time slots during booking process';


--
-- Name: bot_messages; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.bot_messages (
    id uuid DEFAULT gen_random_uuid() NOT NULL,
    organization_id uuid,
    category text NOT NULL,
    message_key text NOT NULL,
    message_template text NOT NULL,
    variations jsonb DEFAULT '[]'::jsonb,
    tone text DEFAULT 'friendly'::text,
    channel text,
    language text DEFAULT 'es'::text,
    priority integer DEFAULT 0,
    is_active boolean DEFAULT true,
    created_at timestamp with time zone DEFAULT now(),
    updated_at timestamp with time zone DEFAULT now(),
    CONSTRAINT bot_messages_category_check CHECK ((category = ANY (ARRAY['greeting'::text, 'farewell'::text, 'acknowledgment'::text, 'slot_prompt'::text, 'confirmation'::text, 'error'::text, 'fallback'::text, 'waiting'::text, 'menu'::text, 'help'::text, 'transfer'::text, 'out_of_hours'::text, 'appointment_created'::text, 'appointment_updated'::text, 'appointment_cancelled'::text]))),
    CONSTRAINT bot_messages_channel_check CHECK (((channel IS NULL) OR (channel = ANY (ARRAY['whatsapp'::text, 'web'::text, 'app'::text]))))
);


--
-- Name: TABLE bot_messages; Type: COMMENT; Schema: public; Owner: -
--

COMMENT ON TABLE public.bot_messages IS 'Database-driven bot messages, prompts, and templates';


--
-- Name: COLUMN bot_messages.category; Type: COMMENT; Schema: public; Owner: -
--

COMMENT ON COLUMN public.bot_messages.category IS 'Message category: greeting, slot_prompt, error, etc.';


--
-- Name: COLUMN bot_messages.message_key; Type: COMMENT; Schema: public; Owner: -
--

COMMENT ON COLUMN public.bot_messages.message_key IS 'Specific key within category (e.g., service, provider for slot_prompt)';


--
-- Name: COLUMN bot_messages.message_template; Type: COMMENT; Schema: public; Owner: -
--

COMMENT ON COLUMN public.bot_messages.message_template IS 'Message text with {variable} placeholders';


--
-- Name: COLUMN bot_messages.variations; Type: COMMENT; Schema: public; Owner: -
--

COMMENT ON COLUMN public.bot_messages.variations IS 'Alternative phrasings for variety';


--
-- Name: business_hours; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.business_hours (
    id uuid DEFAULT gen_random_uuid() NOT NULL,
    organization_id uuid NOT NULL,
    day_of_week integer NOT NULL,
    is_closed boolean DEFAULT false NOT NULL,
    open_time time without time zone DEFAULT '09:00:00'::time without time zone NOT NULL,
    close_time time without time zone DEFAULT '17:00:00'::time without time zone NOT NULL,
    break_start time without time zone,
    break_end time without time zone,
    notes text,
    created_at timestamp with time zone DEFAULT now() NOT NULL,
    updated_at timestamp with time zone DEFAULT now() NOT NULL,
    CONSTRAINT business_hours_day_of_week_check CHECK (((day_of_week >= 0) AND (day_of_week <= 6)))
);


--
-- Name: calendar_connections; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.calendar_connections (
    id uuid DEFAULT gen_random_uuid() NOT NULL,
    user_id uuid NOT NULL,
    organization_id uuid NOT NULL,
    provider text NOT NULL,
    email text NOT NULL,
    sync_enabled boolean DEFAULT true,
    direction text DEFAULT 'bidirectional'::text,
    sync_status text DEFAULT 'pending'::text,
    last_sync_at timestamp with time zone,
    last_error text,
    calendar_id text,
    calendar_name text,
    encrypted_access_token text,
    encrypted_refresh_token text,
    token_expires_at timestamp with time zone,
    created_at timestamp with time zone DEFAULT now() NOT NULL,
    updated_at timestamp with time zone DEFAULT now() NOT NULL,
    CONSTRAINT calendar_connections_direction_check CHECK ((direction = ANY (ARRAY['push'::text, 'pull'::text, 'bidirectional'::text]))),
    CONSTRAINT calendar_connections_provider_check CHECK ((provider = ANY (ARRAY['google'::text, 'outlook'::text, 'apple'::text]))),
    CONSTRAINT calendar_connections_sync_status_check CHECK ((sync_status = ANY (ARRAY['pending'::text, 'syncing'::text, 'success'::text, 'error'::text])))
);


--
-- Name: TABLE calendar_connections; Type: COMMENT; Schema: public; Owner: -
--

COMMENT ON TABLE public.calendar_connections IS 'External calendar connections for sync (Google, Outlook, Apple)';


--
-- Name: catalog_item_types; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.catalog_item_types (
    code character varying(30) NOT NULL,
    display_name text NOT NULL,
    description text,
    is_storable boolean DEFAULT false NOT NULL,
    is_bookable boolean DEFAULT false NOT NULL,
    is_recurring boolean DEFAULT false NOT NULL,
    sort_order integer DEFAULT 0,
    created_at timestamp with time zone DEFAULT now() NOT NULL
);


--
-- Name: TABLE catalog_item_types; Type: COMMENT; Schema: public; Owner: -
--

COMMENT ON TABLE public.catalog_item_types IS 'Reference table for catalog item types (product, service, bundle, etc.)';


--
-- Name: catalog_tracking_types; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.catalog_tracking_types (
    code character varying(30) NOT NULL,
    display_name text NOT NULL,
    description text,
    sort_order integer DEFAULT 0,
    created_at timestamp with time zone DEFAULT now() NOT NULL
);


--
-- Name: TABLE catalog_tracking_types; Type: COMMENT; Schema: public; Owner: -
--

COMMENT ON TABLE public.catalog_tracking_types IS 'Reference table for inventory tracking methods';


--
-- Name: clients; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.clients (
    id uuid DEFAULT gen_random_uuid() NOT NULL,
    entity_id uuid NOT NULL,
    organization_id uuid NOT NULL,
    client_code character varying(50),
    external_id character varying(100),
    date_of_birth date,
    gender character varying(20),
    status public.entity_status DEFAULT 'active'::public.entity_status NOT NULL,
    category public.client_category DEFAULT 'new'::public.client_category,
    source public.client_source,
    referred_by_entity_id uuid,
    first_visit_date date,
    last_visit_date date,
    next_appointment_date date,
    total_visits integer DEFAULT 0,
    preferences jsonb DEFAULT '{}'::jsonb,
    communication_preferences jsonb DEFAULT '{}'::jsonb,
    loyalty_points integer DEFAULT 0,
    loyalty_tier character varying(50),
    loyalty_joined_at timestamp with time zone,
    total_spent numeric(12,2) DEFAULT 0,
    average_ticket numeric(12,2) DEFAULT 0,
    last_payment_date date,
    alerts jsonb DEFAULT '[]'::jsonb,
    notes text,
    ai_insights jsonb DEFAULT '{}'::jsonb,
    vertical_fields jsonb DEFAULT '{}'::jsonb,
    created_at timestamp with time zone DEFAULT now() NOT NULL,
    created_by uuid,
    updated_at timestamp with time zone DEFAULT now() NOT NULL,
    updated_by uuid,
    deleted_at timestamp with time zone,
    deleted_by uuid,
    embedding extensions.vector(1536),
    has_embedding boolean DEFAULT false,
    tags text[] DEFAULT '{}'::text[],
    client_type public.client_type DEFAULT 'individual'::public.client_type NOT NULL,
    photo_url text,
    company_name character varying(255),
    trade_name character varying(255),
    tax_id character varying(50),
    industry character varying(100),
    legal_representative character varying(255),
    legal_representative_phone character varying(50),
    legal_representative_email character varying(255),
    number_of_employees integer,
    website character varying(255),
    year_founded integer,
    social_links jsonb DEFAULT '{}'::jsonb,
    ai_churn_risk numeric(5,4),
    ai_lifetime_value numeric(12,2),
    ai_predicted_next_visit date,
    ai_upsell_opportunities text[] DEFAULT '{}'::text[],
    first_name character varying(100),
    last_name character varying(100),
    CONSTRAINT check_number_of_employees CHECK (((number_of_employees IS NULL) OR (number_of_employees >= 0))),
    CONSTRAINT check_year_founded CHECK (((year_founded IS NULL) OR ((year_founded >= 1800) AND ((year_founded)::numeric <= EXTRACT(year FROM CURRENT_DATE)))))
);


--
-- Name: TABLE clients; Type: COMMENT; Schema: public; Owner: -
--

COMMENT ON TABLE public.clients IS 'Extension table for non-healthcare client data (beauty, retail, etc.)';


--
-- Name: COLUMN clients.entity_id; Type: COMMENT; Schema: public; Owner: -
--

COMMENT ON COLUMN public.clients.entity_id IS 'Reference to base entity record';


--
-- Name: COLUMN clients.preferences; Type: COMMENT; Schema: public; Owner: -
--

COMMENT ON COLUMN public.clients.preferences IS 'Client preferences (preferred stylist, services, times, etc.)';


--
-- Name: COLUMN clients.ai_insights; Type: COMMENT; Schema: public; Owner: -
--

COMMENT ON COLUMN public.clients.ai_insights IS 'AI-generated insights (churn risk, upsell opportunities, etc.)';


--
-- Name: COLUMN clients.vertical_fields; Type: COMMENT; Schema: public; Owner: -
--

COMMENT ON COLUMN public.clients.vertical_fields IS 'Vertical-specific fields (hair_type, skin_type, etc. for beauty)';


--
-- Name: COLUMN clients.tags; Type: COMMENT; Schema: public; Owner: -
--

COMMENT ON COLUMN public.clients.tags IS 'Custom tags for organizing/filtering clients';


--
-- Name: COLUMN clients.client_type; Type: COMMENT; Schema: public; Owner: -
--

COMMENT ON COLUMN public.clients.client_type IS 'Type of client: individual (persona física) or business (empresa)';


--
-- Name: COLUMN clients.photo_url; Type: COMMENT; Schema: public; Owner: -
--

COMMENT ON COLUMN public.clients.photo_url IS 'URL to client profile photo in storage';


--
-- Name: COLUMN clients.company_name; Type: COMMENT; Schema: public; Owner: -
--

COMMENT ON COLUMN public.clients.company_name IS 'Legal company name (Razón Social) - only for business clients';


--
-- Name: COLUMN clients.trade_name; Type: COMMENT; Schema: public; Owner: -
--

COMMENT ON COLUMN public.clients.trade_name IS 'Trade/Commercial name (Nombre Comercial) - only for business clients';


--
-- Name: COLUMN clients.tax_id; Type: COMMENT; Schema: public; Owner: -
--

COMMENT ON COLUMN public.clients.tax_id IS 'Tax identification number (RNC/NIF/RFC/EIN) - only for business clients';


--
-- Name: COLUMN clients.industry; Type: COMMENT; Schema: public; Owner: -
--

COMMENT ON COLUMN public.clients.industry IS 'Industry or business sector - only for business clients';


--
-- Name: COLUMN clients.legal_representative; Type: COMMENT; Schema: public; Owner: -
--

COMMENT ON COLUMN public.clients.legal_representative IS 'Legal representative name - only for business clients';


--
-- Name: COLUMN clients.legal_representative_phone; Type: COMMENT; Schema: public; Owner: -
--

COMMENT ON COLUMN public.clients.legal_representative_phone IS 'Legal representative phone - only for business clients';


--
-- Name: COLUMN clients.legal_representative_email; Type: COMMENT; Schema: public; Owner: -
--

COMMENT ON COLUMN public.clients.legal_representative_email IS 'Legal representative email - only for business clients';


--
-- Name: COLUMN clients.number_of_employees; Type: COMMENT; Schema: public; Owner: -
--

COMMENT ON COLUMN public.clients.number_of_employees IS 'Company size / number of employees - only for business clients';


--
-- Name: COLUMN clients.website; Type: COMMENT; Schema: public; Owner: -
--

COMMENT ON COLUMN public.clients.website IS 'Company website URL - only for business clients';


--
-- Name: COLUMN clients.year_founded; Type: COMMENT; Schema: public; Owner: -
--

COMMENT ON COLUMN public.clients.year_founded IS 'Year the company was founded - only for business clients';


--
-- Name: COLUMN clients.social_links; Type: COMMENT; Schema: public; Owner: -
--

COMMENT ON COLUMN public.clients.social_links IS 'Social media profiles: {"instagram": {"url": "...", "handle": "..."}, "facebook": {...}, ...}';


--
-- Name: COLUMN clients.ai_churn_risk; Type: COMMENT; Schema: public; Owner: -
--

COMMENT ON COLUMN public.clients.ai_churn_risk IS 'AI-predicted churn probability (0.0 = no risk, 1.0 = certain churn)';


--
-- Name: COLUMN clients.ai_lifetime_value; Type: COMMENT; Schema: public; Owner: -
--

COMMENT ON COLUMN public.clients.ai_lifetime_value IS 'AI-predicted customer lifetime value in organization currency';


--
-- Name: COLUMN clients.ai_predicted_next_visit; Type: COMMENT; Schema: public; Owner: -
--

COMMENT ON COLUMN public.clients.ai_predicted_next_visit IS 'AI-predicted date of next visit based on behavior patterns';


--
-- Name: COLUMN clients.ai_upsell_opportunities; Type: COMMENT; Schema: public; Owner: -
--

COMMENT ON COLUMN public.clients.ai_upsell_opportunities IS 'AI-suggested upsell opportunities based on client profile and history';


--
-- Name: conversation_flow_runtime; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.conversation_flow_runtime (
    id uuid DEFAULT gen_random_uuid() NOT NULL,
    flow_id uuid NOT NULL,
    session_id uuid NOT NULL,
    conversation_id uuid NOT NULL,
    organization_id uuid NOT NULL,
    status character varying(30) DEFAULT 'active'::character varying,
    current_slot character varying(100),
    slot_index integer DEFAULT 0,
    collected_slots jsonb DEFAULT '{}'::jsonb,
    slot_history jsonb DEFAULT '[]'::jsonb,
    awaiting_confirmation boolean DEFAULT false,
    confirmation_data jsonb,
    retry_count integer DEFAULT 0,
    max_retries integer DEFAULT 3,
    last_prompt_sent text,
    last_user_input text,
    error_message text,
    context jsonb DEFAULT '{}'::jsonb,
    metadata jsonb DEFAULT '{}'::jsonb,
    started_at timestamp with time zone DEFAULT now(),
    last_activity_at timestamp with time zone DEFAULT now(),
    completed_at timestamp with time zone,
    expires_at timestamp with time zone,
    confirmation_retry_count integer DEFAULT 0
);


--
-- Name: conversation_flow_states; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.conversation_flow_states (
    id uuid DEFAULT gen_random_uuid() NOT NULL,
    conversation_id uuid NOT NULL,
    flow_id uuid NOT NULL,
    organization_id uuid,
    status character varying(20) DEFAULT 'active'::character varying,
    current_slot character varying(100),
    collected_slots jsonb DEFAULT '{}'::jsonb,
    slot_history jsonb DEFAULT '[]'::jsonb,
    awaiting_confirmation boolean DEFAULT false,
    confirmation_data jsonb,
    retry_count integer DEFAULT 0,
    last_prompt_sent character varying(255),
    started_at timestamp with time zone DEFAULT now(),
    last_activity_at timestamp with time zone DEFAULT now(),
    completed_at timestamp with time zone,
    expires_at timestamp with time zone,
    context jsonb DEFAULT '{}'::jsonb
);


--
-- Name: TABLE conversation_flow_states; Type: COMMENT; Schema: public; Owner: -
--

COMMENT ON TABLE public.conversation_flow_states IS 'Runtime state for active conversation flows. Tracks collected slots and current position.';


--
-- Name: conversation_flows; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.conversation_flows (
    id uuid DEFAULT gen_random_uuid() NOT NULL,
    organization_id uuid,
    flow_name character varying(100) NOT NULL,
    flow_label character varying(255),
    description text,
    trigger_intents text[] NOT NULL,
    slots jsonb DEFAULT '[]'::jsonb NOT NULL,
    slot_order text[],
    confirmation_required boolean DEFAULT true,
    confirmation_prompt_key character varying(100),
    success_action character varying(100),
    success_skill_id uuid,
    success_message_key character varying(100),
    cancel_keywords text[] DEFAULT ARRAY['cancelar'::text, 'no quiero'::text, 'olvídalo'::text, 'dejalo'::text],
    cancel_message_key character varying(100),
    slot_timeout_seconds integer DEFAULT 300,
    flow_timeout_seconds integer DEFAULT 900,
    timeout_message_key character varying(100),
    vertical_code character varying(50),
    channel character varying(50),
    language character varying(10) DEFAULT 'es'::character varying,
    enabled boolean DEFAULT true,
    priority integer DEFAULT 0,
    metadata jsonb DEFAULT '{}'::jsonb,
    tags text[],
    created_at timestamp with time zone DEFAULT now(),
    updated_at timestamp with time zone DEFAULT now(),
    created_by uuid
);


--
-- Name: TABLE conversation_flows; Type: COMMENT; Schema: public; Owner: -
--

COMMENT ON TABLE public.conversation_flows IS 'Defines multi-turn conversation flows with slot collection and validation.
Used to structure conversations like appointment booking, inquiries, etc.';


--
-- Name: COLUMN conversation_flows.trigger_intents; Type: COMMENT; Schema: public; Owner: -
--

COMMENT ON COLUMN public.conversation_flows.trigger_intents IS 'Array of intent names that activate this flow';


--
-- Name: COLUMN conversation_flows.slots; Type: COMMENT; Schema: public; Owner: -
--

COMMENT ON COLUMN public.conversation_flows.slots IS 'JSONB array defining slots with: name, type, required, order, prompt_key, validation, dependencies';


--
-- Name: conversation_memory; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.conversation_memory (
    id uuid DEFAULT gen_random_uuid() NOT NULL,
    organization_id uuid NOT NULL,
    channel character varying(50) NOT NULL,
    channel_user_id character varying(255) NOT NULL,
    role character varying(20) NOT NULL,
    content text NOT NULL,
    session_id uuid,
    detected_intent character varying(100),
    detected_entities jsonb DEFAULT '{}'::jsonb,
    created_at timestamp with time zone DEFAULT now(),
    CONSTRAINT conversation_memory_role_check CHECK (((role)::text = ANY ((ARRAY['user'::character varying, 'assistant'::character varying, 'system'::character varying])::text[])))
);


--
-- Name: TABLE conversation_memory; Type: COMMENT; Schema: public; Owner: -
--

COMMENT ON TABLE public.conversation_memory IS 'Stores conversation history for context-aware AI responses';


--
-- Name: daily_time_summary; Type: TABLE; Schema: public; Owner: -
--

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


--
-- Name: TABLE daily_time_summary; Type: COMMENT; Schema: public; Owner: -
--

COMMENT ON TABLE public.daily_time_summary IS 'Pre-calculated daily totals for fast reporting and payroll';


--
-- Name: departments; Type: TABLE; Schema: public; Owner: -
--

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


--
-- Name: TABLE departments; Type: COMMENT; Schema: public; Owner: -
--

COMMENT ON TABLE public.departments IS 'Organizational units with hierarchical structure';


--
-- Name: entity_ai_cold; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.entity_ai_cold (
    id uuid DEFAULT gen_random_uuid() NOT NULL,
    entity_id uuid NOT NULL,
    ai_data jsonb DEFAULT '{}'::jsonb,
    snapshot_date date NOT NULL,
    archived_at timestamp with time zone DEFAULT now(),
    created_at timestamp with time zone DEFAULT now() NOT NULL
);


--
-- Name: TABLE entity_ai_cold; Type: COMMENT; Schema: public; Owner: -
--

COMMENT ON TABLE public.entity_ai_cold IS 'Cold storage for historical AI snapshots - archived for compliance and trend analysis';


--
-- Name: entity_ai_hot; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.entity_ai_hot (
    id uuid DEFAULT gen_random_uuid() NOT NULL,
    entity_id uuid NOT NULL,
    ai_no_show_risk jsonb,
    ai_appointment_optimization jsonb,
    ai_service_recommendations jsonb,
    last_accessed_at timestamp with time zone DEFAULT now(),
    access_count integer DEFAULT 0,
    created_at timestamp with time zone DEFAULT now() NOT NULL,
    updated_at timestamp with time zone DEFAULT now() NOT NULL
);


--
-- Name: TABLE entity_ai_hot; Type: COMMENT; Schema: public; Owner: -
--

COMMENT ON TABLE public.entity_ai_hot IS 'Hot storage for frequently accessed AI data (last 90 days) - optimized for low latency';


--
-- Name: entity_ai_traits; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.entity_ai_traits (
    id uuid DEFAULT gen_random_uuid() NOT NULL,
    organization_id uuid NOT NULL,
    entity_id uuid NOT NULL,
    entity_type text NOT NULL,
    ai_no_show_risk jsonb DEFAULT '{}'::jsonb,
    ai_appointment_optimization jsonb DEFAULT '{}'::jsonb,
    ai_service_recommendations jsonb DEFAULT '{}'::jsonb,
    ai_product_recommendations jsonb DEFAULT '{}'::jsonb,
    ai_client_insights jsonb DEFAULT '{}'::jsonb,
    ai_retention_strategy jsonb DEFAULT '{}'::jsonb,
    ai_churn_risk jsonb DEFAULT '{}'::jsonb,
    ai_lifetime_value jsonb DEFAULT '{}'::jsonb,
    ai_behavior_predictions jsonb DEFAULT '{}'::jsonb,
    ai_promotion_optimization jsonb DEFAULT '{}'::jsonb,
    last_ai_refresh_at timestamp with time zone,
    ai_refresh_count integer DEFAULT 0,
    ai_model_versions jsonb DEFAULT '{}'::jsonb,
    created_at timestamp with time zone DEFAULT now() NOT NULL,
    updated_at timestamp with time zone DEFAULT now() NOT NULL,
    created_by uuid,
    updated_by uuid
);


--
-- Name: TABLE entity_ai_traits; Type: COMMENT; Schema: public; Owner: -
--

COMMENT ON TABLE public.entity_ai_traits IS 'Shared AI fields for all entity types - eliminates duplication across patients, customers, beauty_clients, etc';


--
-- Name: entity_identification_documents; Type: TABLE; Schema: public; Owner: -
--

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


--
-- Name: entity_insurance_policies; Type: TABLE; Schema: public; Owner: -
--

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


--
-- Name: entity_memory; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.entity_memory (
    id uuid DEFAULT gen_random_uuid() NOT NULL,
    organization_id uuid NOT NULL,
    entity_id uuid,
    channel character varying(50),
    channel_user_id character varying(255),
    last_provider_id uuid,
    last_provider_name character varying(255),
    last_service_id uuid,
    last_service_name character varying(255),
    preferred_time_slot character varying(50),
    preferred_day_of_week integer[],
    visit_count integer DEFAULT 1,
    last_visit_at timestamp with time zone DEFAULT now(),
    first_visit_at timestamp with time zone DEFAULT now(),
    preferences jsonb DEFAULT '{}'::jsonb,
    created_at timestamp with time zone DEFAULT now(),
    updated_at timestamp with time zone DEFAULT now()
);


--
-- Name: entity_metrics_cache; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.entity_metrics_cache (
    id uuid DEFAULT gen_random_uuid() NOT NULL,
    organization_id uuid NOT NULL,
    entity_id uuid NOT NULL,
    entity_type text NOT NULL,
    total_appointments integer DEFAULT 0,
    completed_appointments integer DEFAULT 0,
    cancelled_appointments integer DEFAULT 0,
    no_show_appointments integer DEFAULT 0,
    upcoming_appointments integer DEFAULT 0,
    avg_appointment_duration_minutes numeric(10,2),
    last_appointment_date date,
    next_appointment_date date,
    total_revenue numeric(12,2) DEFAULT 0,
    avg_transaction_value numeric(12,2),
    last_purchase_date date,
    last_purchase_amount numeric(12,2),
    days_since_last_visit integer,
    visit_frequency_days numeric(10,2),
    engagement_score numeric(5,2),
    no_show_risk_score numeric(5,4),
    churn_risk_score numeric(5,4),
    lifetime_value_score numeric(12,2),
    last_calculated_at timestamp with time zone DEFAULT now(),
    calculation_duration_ms integer,
    created_at timestamp with time zone DEFAULT now() NOT NULL,
    updated_at timestamp with time zone DEFAULT now() NOT NULL
);


--
-- Name: TABLE entity_metrics_cache; Type: COMMENT; Schema: public; Owner: -
--

COMMENT ON TABLE public.entity_metrics_cache IS 'Materialized metrics cache for fast dashboard queries - updated via triggers or batch jobs';


--
-- Name: entity_relationships; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.entity_relationships (
    id uuid DEFAULT gen_random_uuid() NOT NULL,
    organization_id uuid NOT NULL,
    source_entity_id uuid NOT NULL,
    target_entity_id uuid NOT NULL,
    relationship_type public.entity_relationship_type NOT NULL,
    status public.relationship_status DEFAULT 'active'::public.relationship_status NOT NULL,
    relationship_code character varying(50),
    can_make_medical_decisions boolean DEFAULT false,
    can_view_medical_records boolean DEFAULT false,
    can_view_financial_records boolean DEFAULT false,
    is_billing_contact boolean DEFAULT false,
    is_primary boolean DEFAULT false,
    valid_from date DEFAULT CURRENT_DATE NOT NULL,
    valid_until date,
    priority integer DEFAULT 0,
    metadata jsonb DEFAULT '{}'::jsonb,
    created_at timestamp with time zone DEFAULT now() NOT NULL,
    created_by uuid,
    updated_at timestamp with time zone DEFAULT now() NOT NULL,
    updated_by uuid,
    deleted_at timestamp with time zone,
    deleted_by uuid,
    is_emergency_contact boolean DEFAULT false,
    can_authorize boolean DEFAULT false,
    can_represent boolean DEFAULT false,
    can_pickup boolean DEFAULT false,
    receives_notifications boolean DEFAULT true,
    context character varying(50) DEFAULT 'general'::character varying,
    notes text,
    CONSTRAINT entity_relationships_no_self_relation CHECK ((source_entity_id <> target_entity_id)),
    CONSTRAINT entity_relationships_priority_positive CHECK ((priority >= 0)),
    CONSTRAINT entity_relationships_valid_dates CHECK (((valid_until IS NULL) OR (valid_until >= valid_from)))
);


--
-- Name: TABLE entity_relationships; Type: COMMENT; Schema: public; Owner: -
--

COMMENT ON TABLE public.entity_relationships IS 'Bidirectional relationships between entities.
Examples: parent-child, patient-physician, employee-manager, client-vendor.
Create both directions if relationship is symmetric (e.g., spouse, sibling).';


--
-- Name: COLUMN entity_relationships.source_entity_id; Type: COMMENT; Schema: public; Owner: -
--

COMMENT ON COLUMN public.entity_relationships.source_entity_id IS 'Source entity in relationship (e.g., parent, physician, manager).';


--
-- Name: COLUMN entity_relationships.target_entity_id; Type: COMMENT; Schema: public; Owner: -
--

COMMENT ON COLUMN public.entity_relationships.target_entity_id IS 'Target entity in relationship (e.g., child, patient, employee).';


--
-- Name: COLUMN entity_relationships.can_make_medical_decisions; Type: COMMENT; Schema: public; Owner: -
--

COMMENT ON COLUMN public.entity_relationships.can_make_medical_decisions IS 'Can make medical decisions on behalf of entity_to (healthcare proxy, guardian).';


--
-- Name: COLUMN entity_relationships.can_view_medical_records; Type: COMMENT; Schema: public; Owner: -
--

COMMENT ON COLUMN public.entity_relationships.can_view_medical_records IS 'Authorized to view medical records of entity_to.';


--
-- Name: COLUMN entity_relationships.is_billing_contact; Type: COMMENT; Schema: public; Owner: -
--

COMMENT ON COLUMN public.entity_relationships.is_billing_contact IS 'Financially responsible for entity_to (parent, guarantor).';


--
-- Name: COLUMN entity_relationships.is_primary; Type: COMMENT; Schema: public; Owner: -
--

COMMENT ON COLUMN public.entity_relationships.is_primary IS 'Primary contact for entity_to (emergency, billing, etc.).';


--
-- Name: COLUMN entity_relationships.valid_from; Type: COMMENT; Schema: public; Owner: -
--

COMMENT ON COLUMN public.entity_relationships.valid_from IS 'Relationship start date.';


--
-- Name: COLUMN entity_relationships.valid_until; Type: COMMENT; Schema: public; Owner: -
--

COMMENT ON COLUMN public.entity_relationships.valid_until IS 'Relationship end date (NULL = active indefinitely).';


--
-- Name: COLUMN entity_relationships.priority; Type: COMMENT; Schema: public; Owner: -
--

COMMENT ON COLUMN public.entity_relationships.priority IS 'Priority/order (1=primary, 2=secondary). Lower number = higher priority.';


--
-- Name: entity_synonyms; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.entity_synonyms (
    id uuid DEFAULT gen_random_uuid() NOT NULL,
    organization_id uuid,
    entity_type character varying(50) NOT NULL,
    synonym character varying(255) NOT NULL,
    canonical_value character varying(255) NOT NULL,
    canonical_id uuid,
    context_hints jsonb DEFAULT '{}'::jsonb,
    vertical_code character varying(50),
    channel character varying(50),
    language character varying(10) DEFAULT 'es'::character varying,
    weight double precision DEFAULT 1.0,
    match_type character varying(20) DEFAULT 'exact'::character varying,
    case_sensitive boolean DEFAULT false,
    is_special_token boolean DEFAULT false,
    category character varying(100),
    tags text[],
    enabled boolean DEFAULT true,
    priority integer DEFAULT 0,
    created_at timestamp with time zone DEFAULT now(),
    updated_at timestamp with time zone DEFAULT now(),
    created_by uuid,
    CONSTRAINT entity_synonyms_weight_check CHECK (((weight >= ((0)::numeric)::double precision) AND (weight <= ((2)::numeric)::double precision)))
);


--
-- Name: TABLE entity_synonyms; Type: COMMENT; Schema: public; Owner: -
--

COMMENT ON TABLE public.entity_synonyms IS 'Stores entity synonyms for NLU resolution with multi-tenant support.
Maps informal/regional terms to canonical values.
Examples: "la china" → "Xiomara", "corte" → "corte de cabello"';


--
-- Name: COLUMN entity_synonyms.entity_type; Type: COMMENT; Schema: public; Owner: -
--

COMMENT ON COLUMN public.entity_synonyms.entity_type IS 'Type of entity: service, provider, product, location, time_expression';


--
-- Name: COLUMN entity_synonyms.synonym; Type: COMMENT; Schema: public; Owner: -
--

COMMENT ON COLUMN public.entity_synonyms.synonym IS 'The input text to match (stored lowercase)';


--
-- Name: COLUMN entity_synonyms.canonical_value; Type: COMMENT; Schema: public; Owner: -
--

COMMENT ON COLUMN public.entity_synonyms.canonical_value IS 'The normalized/resolved value';


--
-- Name: COLUMN entity_synonyms.canonical_id; Type: COMMENT; Schema: public; Owner: -
--

COMMENT ON COLUMN public.entity_synonyms.canonical_id IS 'Optional direct reference to the entity (employee.id, service.id)';


--
-- Name: COLUMN entity_synonyms.match_type; Type: COMMENT; Schema: public; Owner: -
--

COMMENT ON COLUMN public.entity_synonyms.match_type IS 'How to match: exact, prefix, contains, fuzzy, regex';


--
-- Name: COLUMN entity_synonyms.is_special_token; Type: COMMENT; Schema: public; Owner: -
--

COMMENT ON COLUMN public.entity_synonyms.is_special_token IS 'For special tokens like __LAST_PROVIDER__, __ANY__';


--
-- Name: external_calendar_events; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.external_calendar_events (
    id uuid DEFAULT gen_random_uuid() NOT NULL,
    connection_id uuid NOT NULL,
    organization_id uuid NOT NULL,
    external_id text NOT NULL,
    external_updated_at timestamp with time zone,
    title text NOT NULL,
    description text,
    start_time timestamp with time zone NOT NULL,
    end_time timestamp with time zone NOT NULL,
    is_all_day boolean DEFAULT false,
    is_blocking boolean DEFAULT true,
    synced_appointment_id uuid,
    created_at timestamp with time zone DEFAULT now() NOT NULL,
    updated_at timestamp with time zone DEFAULT now() NOT NULL
);


--
-- Name: TABLE external_calendar_events; Type: COMMENT; Schema: public; Owner: -
--

COMMENT ON TABLE public.external_calendar_events IS 'Events synced from external calendars';


--
-- Name: identification_document_types; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.identification_document_types (
    id uuid DEFAULT gen_random_uuid() NOT NULL,
    organization_id uuid,
    code character varying(50) NOT NULL,
    name character varying(200) NOT NULL,
    short_name character varying(50),
    country_code character varying(2) DEFAULT 'DO'::character varying,
    format_regex character varying(500),
    format_mask character varying(100),
    format_hint character varying(200),
    min_length integer,
    max_length integer,
    validation_url text,
    can_validate_online boolean DEFAULT false,
    category character varying(50) DEFAULT 'personal'::character varying,
    applies_to character varying(50) DEFAULT 'person'::character varying,
    icon character varying(50),
    display_order integer DEFAULT 0,
    is_active boolean DEFAULT true,
    is_required boolean DEFAULT false,
    created_at timestamp with time zone DEFAULT now(),
    updated_at timestamp with time zone DEFAULT now()
);


--
-- Name: TABLE identification_document_types; Type: COMMENT; Schema: public; Owner: -
--

COMMENT ON TABLE public.identification_document_types IS 'Catalog of identification document types per country';


--
-- Name: insurance_providers; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.insurance_providers (
    id uuid DEFAULT gen_random_uuid() NOT NULL,
    entity_id uuid NOT NULL,
    organization_id uuid NOT NULL,
    provider_code character varying(50) NOT NULL,
    provider_type character varying(50) NOT NULL,
    rnc character varying(20),
    sisalril_code character varying(50),
    license_number character varying(100),
    superintendencia_code character varying(50),
    logo_url text,
    primary_color character varying(7),
    secondary_color character varying(7),
    claims_email character varying(200),
    claims_phone character varying(50),
    authorizations_phone character varying(50),
    emergencies_phone character varying(50),
    website character varying(200),
    member_portal_url character varying(200),
    available_plans jsonb DEFAULT '[]'::jsonb,
    coverage_network jsonb DEFAULT '{}'::jsonb,
    is_active boolean DEFAULT true,
    is_global boolean DEFAULT false,
    country_code character varying(2) DEFAULT 'DO'::character varying,
    display_order integer DEFAULT 0,
    created_at timestamp with time zone DEFAULT now(),
    updated_at timestamp with time zone DEFAULT now()
);


--
-- Name: TABLE insurance_providers; Type: COMMENT; Schema: public; Owner: -
--

COMMENT ON TABLE public.insurance_providers IS 'Insurance provider specific data - extends entities table';


--
-- Name: inventory; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.inventory (
    id uuid DEFAULT gen_random_uuid() NOT NULL,
    organization_id uuid NOT NULL,
    product_id uuid NOT NULL,
    quantity_available integer DEFAULT 0 NOT NULL,
    location text,
    metadata jsonb DEFAULT '{}'::jsonb,
    created_at timestamp with time zone DEFAULT now() NOT NULL,
    updated_at timestamp with time zone DEFAULT now() NOT NULL
);


--
-- Name: TABLE inventory; Type: COMMENT; Schema: public; Owner: -
--

COMMENT ON TABLE public.inventory IS 'Inventario por producto/organización';


--
-- Name: invites; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.invites (
    id uuid DEFAULT gen_random_uuid() NOT NULL,
    organization_id uuid NOT NULL,
    email text NOT NULL,
    role_key text NOT NULL,
    token text DEFAULT encode(extensions.gen_random_bytes(32), 'hex'::text) NOT NULL,
    message text,
    accepted_by uuid,
    created_by uuid NOT NULL,
    created_at timestamp with time zone DEFAULT now(),
    updated_at timestamp with time zone DEFAULT now(),
    accepted_at timestamp with time zone,
    expires_at timestamp with time zone DEFAULT (now() + '7 days'::interval),
    max_uses integer DEFAULT 1,
    times_used integer DEFAULT 0,
    revoked_at timestamp with time zone,
    deleted_at timestamp with time zone,
    status text DEFAULT 'pending'::text
);


--
-- Name: item_attributes; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.item_attributes (
    id uuid DEFAULT gen_random_uuid() NOT NULL,
    item_id uuid NOT NULL,
    attribute_id uuid NOT NULL,
    value_text text,
    value_number numeric,
    value_boolean boolean,
    value_date date,
    value_json jsonb,
    created_at timestamp with time zone DEFAULT now() NOT NULL
);


--
-- Name: TABLE item_attributes; Type: COMMENT; Schema: public; Owner: -
--

COMMENT ON TABLE public.item_attributes IS 'Stores attribute values for catalog items (especially for variant-creating attributes)';


--
-- Name: item_providers; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.item_providers (
    id uuid DEFAULT gen_random_uuid() NOT NULL,
    organization_id uuid NOT NULL,
    item_id uuid NOT NULL,
    provider_entity_id uuid NOT NULL,
    custom_price numeric(12,4),
    custom_duration_minutes integer,
    priority integer DEFAULT 0,
    max_daily_bookings integer,
    is_available boolean DEFAULT true NOT NULL,
    available_from timestamp with time zone,
    available_until timestamp with time zone,
    proficiency_level integer,
    is_qualified boolean DEFAULT true NOT NULL,
    created_at timestamp with time zone DEFAULT now() NOT NULL,
    updated_at timestamp with time zone DEFAULT now() NOT NULL
);


--
-- Name: TABLE item_providers; Type: COMMENT; Schema: public; Owner: -
--

COMMENT ON TABLE public.item_providers IS 'Links catalog items to providers who can deliver them';


--
-- Name: item_skill_requirements; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.item_skill_requirements (
    id uuid DEFAULT gen_random_uuid() NOT NULL,
    item_id uuid NOT NULL,
    skill_id uuid NOT NULL,
    min_proficiency integer DEFAULT 1 NOT NULL,
    is_required boolean DEFAULT true NOT NULL,
    notes text,
    created_at timestamp with time zone DEFAULT now() NOT NULL,
    CONSTRAINT item_skill_requirements_min_proficiency_check CHECK (((min_proficiency >= 1) AND (min_proficiency <= 5)))
);


--
-- Name: TABLE item_skill_requirements; Type: COMMENT; Schema: public; Owner: -
--

COMMENT ON TABLE public.item_skill_requirements IS 'Defines which skills/certifications are required to provide an item';


--
-- Name: jobs; Type: TABLE; Schema: public; Owner: -
--

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


--
-- Name: TABLE jobs; Type: COMMENT; Schema: public; Owner: -
--

COMMENT ON TABLE public.jobs IS 'Position templates with pay grades, requirements, and benefit eligibility';


--
-- Name: leave_balances; Type: TABLE; Schema: public; Owner: -
--

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


--
-- Name: TABLE leave_balances; Type: COMMENT; Schema: public; Owner: -
--

COMMENT ON TABLE public.leave_balances IS 'Employee leave balances per type per year';


--
-- Name: leave_requests; Type: TABLE; Schema: public; Owner: -
--

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


--
-- Name: TABLE leave_requests; Type: COMMENT; Schema: public; Owner: -
--

COMMENT ON TABLE public.leave_requests IS 'Employee leave requests with approval workflow';


--
-- Name: leave_types; Type: TABLE; Schema: public; Owner: -
--

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


--
-- Name: TABLE leave_types; Type: COMMENT; Schema: public; Owner: -
--

COMMENT ON TABLE public.leave_types IS 'Types of leave with accrual rules and pay configuration';


--
-- Name: memberships; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.memberships (
    id uuid DEFAULT gen_random_uuid() NOT NULL,
    organization_id uuid NOT NULL,
    user_id uuid NOT NULL,
    role_key text NOT NULL,
    status text DEFAULT 'active'::text NOT NULL,
    custom_permissions jsonb,
    joined_at timestamp with time zone DEFAULT now() NOT NULL,
    created_at timestamp with time zone DEFAULT now() NOT NULL,
    updated_at timestamp with time zone DEFAULT now() NOT NULL,
    created_by uuid,
    updated_by uuid,
    CONSTRAINT memberships_status_check CHECK ((status = ANY (ARRAY['active'::text, 'inactive'::text, 'suspended'::text]))),
    CONSTRAINT valid_custom_permissions CHECK (((custom_permissions IS NULL) OR (jsonb_typeof(custom_permissions) = 'object'::text)))
);


--
-- Name: TABLE memberships; Type: COMMENT; Schema: public; Owner: -
--

COMMENT ON TABLE public.memberships IS 'Links users to organizations with specific roles and optional custom permissions';


--
-- Name: COLUMN memberships.custom_permissions; Type: COMMENT; Schema: public; Owner: -
--

COMMENT ON COLUMN public.memberships.custom_permissions IS 'User-specific permission overrides. Merges with role permissions.';


--
-- Name: nlu_entity_synonyms; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.nlu_entity_synonyms (
    id uuid DEFAULT gen_random_uuid() NOT NULL,
    organization_id uuid,
    entity_type character varying(100) NOT NULL,
    synonym text NOT NULL,
    canonical_value text NOT NULL,
    confidence double precision DEFAULT 0.8,
    created_at timestamp with time zone DEFAULT now(),
    updated_at timestamp with time zone DEFAULT now()
);


--
-- Name: TABLE nlu_entity_synonyms; Type: COMMENT; Schema: public; Owner: -
--

COMMENT ON TABLE public.nlu_entity_synonyms IS 'Sinónimos de entidades para NLU';


--
-- Name: nlu_heuristic_rules; Type: TABLE; Schema: public; Owner: -
--

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


--
-- Name: nlu_intent_examples; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.nlu_intent_examples (
    id uuid DEFAULT gen_random_uuid() NOT NULL,
    organization_id uuid,
    intent text NOT NULL,
    example_text text NOT NULL,
    embedding extensions.vector(1536),
    language text DEFAULT 'es'::text,
    is_active boolean DEFAULT true,
    created_at timestamp with time zone DEFAULT now(),
    updated_at timestamp with time zone DEFAULT now()
);


--
-- Name: TABLE nlu_intent_examples; Type: COMMENT; Schema: public; Owner: -
--

COMMENT ON TABLE public.nlu_intent_examples IS 'Stores example phrases for intent classification using embeddings';


--
-- Name: COLUMN nlu_intent_examples.organization_id; Type: COMMENT; Schema: public; Owner: -
--

COMMENT ON COLUMN public.nlu_intent_examples.organization_id IS 'NULL = global example, UUID = org-specific';


--
-- Name: COLUMN nlu_intent_examples.intent; Type: COMMENT; Schema: public; Owner: -
--

COMMENT ON COLUMN public.nlu_intent_examples.intent IS 'Intent name: create_appointment, greeting, acknowledgment, farewell, etc.';


--
-- Name: COLUMN nlu_intent_examples.embedding; Type: COMMENT; Schema: public; Owner: -
--

COMMENT ON COLUMN public.nlu_intent_examples.embedding IS 'Vector embedding for semantic similarity search';


--
-- Name: nlu_intent_signals; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.nlu_intent_signals (
    id uuid DEFAULT gen_random_uuid() NOT NULL,
    organization_id uuid,
    intent text NOT NULL,
    signal_type text NOT NULL,
    signal_value text NOT NULL,
    weight double precision DEFAULT 1.0,
    is_required boolean DEFAULT false,
    is_negative boolean DEFAULT false,
    language text DEFAULT 'es'::text,
    priority integer DEFAULT 0,
    is_active boolean DEFAULT true,
    created_at timestamp with time zone DEFAULT now(),
    CONSTRAINT nlu_intent_signals_signal_type_check CHECK ((signal_type = ANY (ARRAY['pattern'::text, 'keyword'::text, 'phrase'::text])))
);


--
-- Name: TABLE nlu_intent_signals; Type: COMMENT; Schema: public; Owner: -
--

COMMENT ON TABLE public.nlu_intent_signals IS 'Pattern-based signals for intent classification';


--
-- Name: COLUMN nlu_intent_signals.signal_type; Type: COMMENT; Schema: public; Owner: -
--

COMMENT ON COLUMN public.nlu_intent_signals.signal_type IS 'pattern=regex, keyword=word boundary, phrase=contains';


--
-- Name: COLUMN nlu_intent_signals.is_required; Type: COMMENT; Schema: public; Owner: -
--

COMMENT ON COLUMN public.nlu_intent_signals.is_required IS 'If true, signal must match for intent to be detected';


--
-- Name: COLUMN nlu_intent_signals.is_negative; Type: COMMENT; Schema: public; Owner: -
--

COMMENT ON COLUMN public.nlu_intent_signals.is_negative IS 'If true, signal negates the intent (anti-pattern)';


--
-- Name: nlu_keywords; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.nlu_keywords (
    id uuid DEFAULT gen_random_uuid() NOT NULL,
    organization_id uuid,
    category text NOT NULL,
    keyword text NOT NULL,
    weight double precision DEFAULT 1.0,
    language text DEFAULT 'es'::text,
    is_active boolean DEFAULT true,
    created_at timestamp with time zone DEFAULT now(),
    CONSTRAINT nlu_keywords_category_check CHECK ((category = ANY (ARRAY['action'::text, 'acknowledgment'::text, 'farewell'::text, 'new_appointment'::text, 'affirmative'::text, 'negative'::text, 'question'::text, 'service'::text, 'registration'::text, 'greeting'::text, 'service_inquiry'::text, 'third_party_booking'::text, 'return_ticket'::text, 'reschedule'::text, 'wait_time'::text, 'price_inquiry'::text, 'availability'::text, 'cancellation'::text, 'confirmation'::text])))
);


--
-- Name: TABLE nlu_keywords; Type: COMMENT; Schema: public; Owner: -
--

COMMENT ON TABLE public.nlu_keywords IS 'Database-driven keywords for NLU intent detection';


--
-- Name: COLUMN nlu_keywords.category; Type: COMMENT; Schema: public; Owner: -
--

COMMENT ON COLUMN public.nlu_keywords.category IS 'Keyword category: action, acknowledgment, farewell, new_appointment, etc.';


--
-- Name: COLUMN nlu_keywords.weight; Type: COMMENT; Schema: public; Owner: -
--

COMMENT ON COLUMN public.nlu_keywords.weight IS 'Scoring weight (1.0 = normal, higher = more important)';


--
-- Name: nlu_training_logs; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.nlu_training_logs (
    id uuid DEFAULT gen_random_uuid() NOT NULL,
    organization_id uuid,
    input_text text NOT NULL,
    normalized_text text,
    extracted_intent character varying(100) NOT NULL,
    extracted_confidence real NOT NULL,
    extracted_slots jsonb DEFAULT '{}'::jsonb,
    extracted_sentiment character varying(20),
    detected_language character varying(10) DEFAULT 'es'::character varying,
    needs_clarification boolean DEFAULT false,
    clarification_question text,
    reasoning text,
    extraction_path character varying(20) DEFAULT 'llm'::character varying NOT NULL,
    reviewed boolean DEFAULT false,
    reviewed_at timestamp with time zone,
    reviewed_by uuid,
    corrected_intent character varying(100),
    corrected_slots jsonb,
    correction_notes text,
    quality_score integer,
    session_id character varying(100),
    channel character varying(50),
    vertical_code character varying(50),
    created_at timestamp with time zone DEFAULT now(),
    updated_at timestamp with time zone DEFAULT now(),
    CONSTRAINT nlu_training_logs_quality_score_check CHECK (((quality_score >= 1) AND (quality_score <= 5)))
);


--
-- Name: TABLE nlu_training_logs; Type: COMMENT; Schema: public; Owner: -
--

COMMENT ON TABLE public.nlu_training_logs IS 'Stores NLU extractions for Active Learning and BERT fine-tuning';


--
-- Name: COLUMN nlu_training_logs.extraction_path; Type: COMMENT; Schema: public; Owner: -
--

COMMENT ON COLUMN public.nlu_training_logs.extraction_path IS 'Which NLU path was used: pattern (fast) or llm (smart)';


--
-- Name: COLUMN nlu_training_logs.corrected_intent; Type: COMMENT; Schema: public; Owner: -
--

COMMENT ON COLUMN public.nlu_training_logs.corrected_intent IS 'Human-corrected intent (if different from extracted)';


--
-- Name: COLUMN nlu_training_logs.quality_score; Type: COMMENT; Schema: public; Owner: -
--

COMMENT ON COLUMN public.nlu_training_logs.quality_score IS 'Human rating 1-5 of extraction quality';


--
-- Name: nlu_review_queue; Type: VIEW; Schema: public; Owner: -
--

CREATE VIEW public.nlu_review_queue AS
 SELECT id,
    organization_id,
    input_text,
    extracted_intent,
    extracted_confidence,
    extracted_slots,
    needs_clarification,
    reasoning,
    created_at
   FROM public.nlu_training_logs
  WHERE ((NOT reviewed) AND ((extracted_confidence < (0.7)::double precision) OR needs_clarification))
  ORDER BY extracted_confidence, created_at DESC;


--
-- Name: VIEW nlu_review_queue; Type: COMMENT; Schema: public; Owner: -
--

COMMENT ON VIEW public.nlu_review_queue IS 'Queue of NLU extractions needing human review';


--
-- Name: nlu_signals; Type: VIEW; Schema: public; Owner: -
--

CREATE VIEW public.nlu_signals AS
 SELECT id,
    organization_id,
    intent,
    signal_type,
    signal_value,
    weight,
    is_required,
    is_negative,
    language,
    priority,
    is_active,
    created_at
   FROM public.nlu_intent_signals;


--
-- Name: nlu_typo_corrections; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.nlu_typo_corrections (
    id uuid DEFAULT gen_random_uuid() NOT NULL,
    organization_id uuid,
    category text NOT NULL,
    typo text NOT NULL,
    correction text NOT NULL,
    language text DEFAULT 'es'::text,
    is_active boolean DEFAULT true,
    created_at timestamp with time zone DEFAULT now(),
    CONSTRAINT nlu_typo_corrections_category_check CHECK ((category = ANY (ARRAY['appointment'::text, 'service'::text, 'provider'::text, 'general'::text, 'abbreviation'::text])))
);


--
-- Name: TABLE nlu_typo_corrections; Type: COMMENT; Schema: public; Owner: -
--

COMMENT ON TABLE public.nlu_typo_corrections IS 'Database-driven typo and abbreviation corrections';


--
-- Name: COLUMN nlu_typo_corrections.typo; Type: COMMENT; Schema: public; Owner: -
--

COMMENT ON COLUMN public.nlu_typo_corrections.typo IS 'The misspelling or abbreviation to correct';


--
-- Name: COLUMN nlu_typo_corrections.correction; Type: COMMENT; Schema: public; Owner: -
--

COMMENT ON COLUMN public.nlu_typo_corrections.correction IS 'The correct form';


--
-- Name: notification_queue; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.notification_queue (
    id uuid DEFAULT gen_random_uuid() NOT NULL,
    payload jsonb NOT NULL,
    created_at timestamp with time zone DEFAULT now(),
    processed_at timestamp with time zone,
    status text DEFAULT 'pending'::text,
    error_message text,
    retry_count integer DEFAULT 0,
    CONSTRAINT notification_queue_status_check CHECK ((status = ANY (ARRAY['pending'::text, 'processing'::text, 'completed'::text, 'failed'::text])))
);


--
-- Name: TABLE notification_queue; Type: COMMENT; Schema: public; Owner: -
--

COMMENT ON TABLE public.notification_queue IS 'Cola de notificaciones pendientes de envío por WhatsApp/SMS';


--
-- Name: orders; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.orders (
    id uuid DEFAULT gen_random_uuid() NOT NULL,
    organization_id uuid NOT NULL,
    product_id uuid NOT NULL,
    quantity integer DEFAULT 1 NOT NULL,
    status text DEFAULT 'pending'::text NOT NULL,
    delivery_method text,
    metadata jsonb DEFAULT '{}'::jsonb,
    created_at timestamp with time zone DEFAULT now() NOT NULL,
    updated_at timestamp with time zone DEFAULT now() NOT NULL
);


--
-- Name: TABLE orders; Type: COMMENT; Schema: public; Owner: -
--

COMMENT ON TABLE public.orders IS 'Órdenes simples creadas por el bot';


--
-- Name: organization_configs; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.organization_configs (
    organization_id uuid NOT NULL,
    config_key text NOT NULL,
    config jsonb DEFAULT '{}'::jsonb NOT NULL,
    created_at timestamp with time zone DEFAULT now() NOT NULL,
    updated_at timestamp with time zone DEFAULT now() NOT NULL
);


--
-- Name: TABLE organization_configs; Type: COMMENT; Schema: public; Owner: -
--

COMMENT ON TABLE public.organization_configs IS 'Key-value JSON configs per organization (e.g., whatsapp_vocabulary)';


--
-- Name: organization_policies; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.organization_policies (
    id uuid DEFAULT gen_random_uuid() NOT NULL,
    organization_id uuid NOT NULL,
    max_cost_per_request numeric(10,2) DEFAULT 1.00,
    daily_ai_budget numeric(10,2) DEFAULT 100.00,
    monthly_ai_budget numeric(10,2) DEFAULT 3000.00,
    compliance_requirements text[] DEFAULT ARRAY['HIPAA'::text],
    approved_models text[] DEFAULT ARRAY['gpt-4o-mini'::text, 'gpt-4o'::text],
    enable_content_moderation boolean DEFAULT true,
    enable_pii_detection boolean DEFAULT true,
    config jsonb DEFAULT '{}'::jsonb,
    created_at timestamp with time zone DEFAULT now(),
    updated_at timestamp with time zone DEFAULT now()
);


--
-- Name: TABLE organization_policies; Type: COMMENT; Schema: public; Owner: -
--

COMMENT ON TABLE public.organization_policies IS 'Políticas y configuración de IA por organización. Controla límites, compliance y moderación.';


--
-- Name: organization_verticals; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.organization_verticals (
    id uuid DEFAULT gen_random_uuid() NOT NULL,
    code text NOT NULL,
    name_es text NOT NULL,
    name_en text NOT NULL,
    description_es text,
    description_en text,
    icon text,
    color text,
    default_person_subtype public.person_subtype DEFAULT 'patient'::public.person_subtype,
    terminology_config jsonb DEFAULT '{}'::jsonb NOT NULL,
    features_config jsonb DEFAULT '{}'::jsonb NOT NULL,
    field_visibility_config jsonb DEFAULT '{}'::jsonb NOT NULL,
    is_active boolean DEFAULT true NOT NULL,
    is_system boolean DEFAULT false NOT NULL,
    sort_order integer DEFAULT 0,
    created_at timestamp with time zone DEFAULT now() NOT NULL,
    updated_at timestamp with time zone DEFAULT now() NOT NULL,
    created_by uuid,
    updated_by uuid
);


--
-- Name: TABLE organization_verticals; Type: COMMENT; Schema: public; Owner: -
--

COMMENT ON TABLE public.organization_verticals IS 'Master configuration for organization verticals (industries) with terminology and feature customization';


--
-- Name: COLUMN organization_verticals.code; Type: COMMENT; Schema: public; Owner: -
--

COMMENT ON COLUMN public.organization_verticals.code IS 'Unique code identifier for programmatic use (e.g., healthcare, beauty_salon)';


--
-- Name: COLUMN organization_verticals.terminology_config; Type: COMMENT; Schema: public; Owner: -
--

COMMENT ON COLUMN public.organization_verticals.terminology_config IS 'JSONB configuration for adapting UI labels per vertical';


--
-- Name: COLUMN organization_verticals.features_config; Type: COMMENT; Schema: public; Owner: -
--

COMMENT ON COLUMN public.organization_verticals.features_config IS 'JSONB configuration for enabling/disabling features per vertical';


--
-- Name: COLUMN organization_verticals.field_visibility_config; Type: COMMENT; Schema: public; Owner: -
--

COMMENT ON COLUMN public.organization_verticals.field_visibility_config IS 'JSONB configuration for showing/hiding form fields per vertical';


--
-- Name: COLUMN organization_verticals.is_system; Type: COMMENT; Schema: public; Owner: -
--

COMMENT ON COLUMN public.organization_verticals.is_system IS 'System verticals are protected and cannot be deleted by users';


--
-- Name: organizations; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.organizations (
    id uuid DEFAULT gen_random_uuid() NOT NULL,
    name text NOT NULL,
    tax_id text,
    status public.entity_status DEFAULT 'active'::public.entity_status NOT NULL,
    created_at timestamp with time zone DEFAULT timezone('utc'::text, now()) NOT NULL,
    updated_at timestamp with time zone DEFAULT timezone('utc'::text, now()) NOT NULL,
    created_by uuid,
    updated_by uuid,
    deleted_at timestamp with time zone,
    custom_fields jsonb DEFAULT '{}'::jsonb,
    vertical_id uuid,
    whatsapp_config jsonb DEFAULT '{}'::jsonb,
    vertical_code text,
    email text,
    phone text,
    website text,
    legal_name text,
    trade_name text,
    rnc text,
    country text DEFAULT 'DO'::text,
    industry text,
    addresses jsonb DEFAULT '[]'::jsonb NOT NULL,
    phones jsonb DEFAULT '[]'::jsonb NOT NULL,
    emails jsonb DEFAULT '[]'::jsonb NOT NULL,
    contacts jsonb DEFAULT '[]'::jsonb NOT NULL,
    business_hours jsonb DEFAULT '{}'::jsonb NOT NULL,
    social_links jsonb DEFAULT '{}'::jsonb NOT NULL,
    tax_info jsonb,
    org_type public.org_type DEFAULT 'company'::public.org_type NOT NULL,
    parent_id uuid,
    logo_url text,
    description text,
    settings jsonb DEFAULT '{}'::jsonb NOT NULL,
    metadata jsonb DEFAULT '{}'::jsonb NOT NULL,
    timezone text DEFAULT 'America/Santo_Domingo'::text NOT NULL,
    currency text DEFAULT 'DOP'::text NOT NULL,
    locale text DEFAULT 'es'::text NOT NULL,
    contact_email text,
    CONSTRAINT organizations_name_check CHECK ((length(name) >= 2)),
    CONSTRAINT organizations_name_not_empty CHECK ((TRIM(BOTH FROM name) <> ''::text))
);


--
-- Name: TABLE organizations; Type: COMMENT; Schema: public; Owner: -
--

COMMENT ON TABLE public.organizations IS 'Multi-tenant organizations - root of data isolation';


--
-- Name: COLUMN organizations.tax_id; Type: COMMENT; Schema: public; Owner: -
--

COMMENT ON COLUMN public.organizations.tax_id IS 'Tax identification number';


--
-- Name: COLUMN organizations.custom_fields; Type: COMMENT; Schema: public; Owner: -
--

COMMENT ON COLUMN public.organizations.custom_fields IS 'Flexible JSON storage for organization-specific fields';


--
-- Name: COLUMN organizations.vertical_id; Type: COMMENT; Schema: public; Owner: -
--

COMMENT ON COLUMN public.organizations.vertical_id IS 'Reference to the configured vertical for this organization';


--
-- Name: COLUMN organizations.whatsapp_config; Type: COMMENT; Schema: public; Owner: -
--

COMMENT ON COLUMN public.organizations.whatsapp_config IS 'WhatsApp Business API configuration for this organization. Structure:
{
  "phone_number_id": "string",
  "business_account_id": "string", 
  "access_token": "encrypted_string",
  "verify_token": "string",
  "enabled": boolean
}';


--
-- Name: COLUMN organizations.vertical_code; Type: COMMENT; Schema: public; Owner: -
--

COMMENT ON COLUMN public.organizations.vertical_code IS 'Business vertical code (healthcare, beauty, retail, etc.)';


--
-- Name: COLUMN organizations.email; Type: COMMENT; Schema: public; Owner: -
--

COMMENT ON COLUMN public.organizations.email IS 'Primary email address (legacy - prefer emails JSONB array)';


--
-- Name: COLUMN organizations.phone; Type: COMMENT; Schema: public; Owner: -
--

COMMENT ON COLUMN public.organizations.phone IS 'Primary phone number (legacy - prefer phones JSONB array)';


--
-- Name: COLUMN organizations.legal_name; Type: COMMENT; Schema: public; Owner: -
--

COMMENT ON COLUMN public.organizations.legal_name IS 'Legal registered name (Razón Social)';


--
-- Name: COLUMN organizations.trade_name; Type: COMMENT; Schema: public; Owner: -
--

COMMENT ON COLUMN public.organizations.trade_name IS 'Trade/commercial name (Nombre Comercial)';


--
-- Name: COLUMN organizations.rnc; Type: COMMENT; Schema: public; Owner: -
--

COMMENT ON COLUMN public.organizations.rnc IS 'Dominican Republic Tax ID (Registro Nacional del Contribuyente)';


--
-- Name: COLUMN organizations.country; Type: COMMENT; Schema: public; Owner: -
--

COMMENT ON COLUMN public.organizations.country IS 'Primary country code (ISO 3166-1 alpha-2)';


--
-- Name: COLUMN organizations.industry; Type: COMMENT; Schema: public; Owner: -
--

COMMENT ON COLUMN public.organizations.industry IS 'Industry/sector classification';


--
-- Name: COLUMN organizations.addresses; Type: COMMENT; Schema: public; Owner: -
--

COMMENT ON COLUMN public.organizations.addresses IS 'JSONB array of address objects';


--
-- Name: COLUMN organizations.phones; Type: COMMENT; Schema: public; Owner: -
--

COMMENT ON COLUMN public.organizations.phones IS 'JSONB array of phone objects';


--
-- Name: COLUMN organizations.emails; Type: COMMENT; Schema: public; Owner: -
--

COMMENT ON COLUMN public.organizations.emails IS 'JSONB array of email objects';


--
-- Name: COLUMN organizations.contacts; Type: COMMENT; Schema: public; Owner: -
--

COMMENT ON COLUMN public.organizations.contacts IS 'JSONB array of contact person objects';


--
-- Name: COLUMN organizations.business_hours; Type: COMMENT; Schema: public; Owner: -
--

COMMENT ON COLUMN public.organizations.business_hours IS 'JSONB object with business hours by day';


--
-- Name: COLUMN organizations.social_links; Type: COMMENT; Schema: public; Owner: -
--

COMMENT ON COLUMN public.organizations.social_links IS 'JSONB object with social media links';


--
-- Name: COLUMN organizations.tax_info; Type: COMMENT; Schema: public; Owner: -
--

COMMENT ON COLUMN public.organizations.tax_info IS 'JSONB object with tax/fiscal information';


--
-- Name: COLUMN organizations.org_type; Type: COMMENT; Schema: public; Owner: -
--

COMMENT ON COLUMN public.organizations.org_type IS 'Organization type: company (parent) or branch (child)';


--
-- Name: COLUMN organizations.parent_id; Type: COMMENT; Schema: public; Owner: -
--

COMMENT ON COLUMN public.organizations.parent_id IS 'Parent organization ID for branches';


--
-- Name: patient_code_sequences; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.patient_code_sequences (
    organization_id uuid NOT NULL,
    current_sequence integer DEFAULT 0 NOT NULL,
    prefix text DEFAULT 'PAT'::text NOT NULL,
    updated_at timestamp with time zone DEFAULT now() NOT NULL
);


--
-- Name: TABLE patient_code_sequences; Type: COMMENT; Schema: public; Owner: -
--

COMMENT ON TABLE public.patient_code_sequences IS 'Stores the current sequence number for patient codes per organization';


--
-- Name: COLUMN patient_code_sequences.prefix; Type: COMMENT; Schema: public; Owner: -
--

COMMENT ON COLUMN public.patient_code_sequences.prefix IS 'Organization-specific prefix for patient codes (e.g., BF, CLI, SPA)';


--
-- Name: patient_notes; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.patient_notes (
    id uuid DEFAULT gen_random_uuid() NOT NULL,
    organization_id uuid NOT NULL,
    patient_id uuid NOT NULL,
    note_type text DEFAULT 'general'::text NOT NULL,
    title text,
    content text NOT NULL,
    appointment_id uuid,
    visit_date timestamp with time zone DEFAULT now(),
    is_private boolean DEFAULT false,
    is_pinned boolean DEFAULT false,
    tags text[] DEFAULT '{}'::text[],
    attachments jsonb DEFAULT '[]'::jsonb,
    created_by uuid,
    created_at timestamp with time zone DEFAULT now() NOT NULL,
    updated_by uuid,
    updated_at timestamp with time zone DEFAULT now() NOT NULL,
    deleted_at timestamp with time zone,
    deleted_by uuid,
    CONSTRAINT valid_note_type CHECK ((note_type = ANY (ARRAY['general'::text, 'clinical'::text, 'billing'::text, 'internal'::text, 'follow_up'::text, 'phone_call'::text, 'email'::text, 'visit'::text])))
);


--
-- Name: TABLE patient_notes; Type: COMMENT; Schema: public; Owner: -
--

COMMENT ON TABLE public.patient_notes IS 'Notas y comentarios de visitas de pacientes';


--
-- Name: COLUMN patient_notes.note_type; Type: COMMENT; Schema: public; Owner: -
--

COMMENT ON COLUMN public.patient_notes.note_type IS 'Tipo: general, clinical, billing, internal, follow_up, phone_call, email, visit';


--
-- Name: COLUMN patient_notes.visit_date; Type: COMMENT; Schema: public; Owner: -
--

COMMENT ON COLUMN public.patient_notes.visit_date IS 'Fecha de la visita/contacto (puede diferir de created_at)';


--
-- Name: COLUMN patient_notes.is_private; Type: COMMENT; Schema: public; Owner: -
--

COMMENT ON COLUMN public.patient_notes.is_private IS 'Si es true, solo visible para el creador';


--
-- Name: COLUMN patient_notes.is_pinned; Type: COMMENT; Schema: public; Owner: -
--

COMMENT ON COLUMN public.patient_notes.is_pinned IS 'Notas fijadas aparecen primero en el timeline';


--
-- Name: COLUMN patient_notes.attachments; Type: COMMENT; Schema: public; Owner: -
--

COMMENT ON COLUMN public.patient_notes.attachments IS 'Array JSON de archivos adjuntos [{url, name, type, size}]';


--
-- Name: positions; Type: TABLE; Schema: public; Owner: -
--

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


--
-- Name: TABLE positions; Type: COMMENT; Schema: public; Owner: -
--

COMMENT ON TABLE public.positions IS 'Specific roles linking jobs to departments, can be filled by employees';


--
-- Name: products; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.products (
    id uuid DEFAULT gen_random_uuid() NOT NULL,
    organization_id uuid NOT NULL,
    product_name text NOT NULL,
    sku text,
    description text,
    price numeric(12,2),
    metadata jsonb DEFAULT '{}'::jsonb,
    created_at timestamp with time zone DEFAULT now() NOT NULL,
    updated_at timestamp with time zone DEFAULT now() NOT NULL
);


--
-- Name: TABLE products; Type: COMMENT; Schema: public; Owner: -
--

COMMENT ON TABLE public.products IS 'Catálogo de productos por organización';


--
-- Name: profiles; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.profiles (
    user_id uuid NOT NULL,
    full_name text NOT NULL,
    avatar_url text,
    created_at timestamp with time zone DEFAULT now(),
    updated_at timestamp with time zone DEFAULT now(),
    role text DEFAULT 'user'::text,
    deleted_at timestamp with time zone,
    is_active boolean DEFAULT true NOT NULL,
    notifications_enabled boolean DEFAULT true,
    dark_mode_enabled boolean DEFAULT false,
    phone_number text,
    job_title text,
    department text,
    timezone text DEFAULT 'America/Santo_Domingo'::text NOT NULL,
    date_format text DEFAULT 'DD/MM/YYYY'::text NOT NULL,
    time_format text DEFAULT '12h'::text NOT NULL,
    preferred_language text DEFAULT 'es'::text NOT NULL,
    CONSTRAINT check_date_format CHECK ((date_format = ANY (ARRAY['DD/MM/YYYY'::text, 'MM/DD/YYYY'::text, 'YYYY-MM-DD'::text]))),
    CONSTRAINT check_preferred_language CHECK ((preferred_language = ANY (ARRAY['es'::text, 'en'::text])))
);


--
-- Name: TABLE profiles; Type: COMMENT; Schema: public; Owner: -
--

COMMENT ON TABLE public.profiles IS 'User profiles with preferences and settings';


--
-- Name: promotion_analytics; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.promotion_analytics (
    id uuid DEFAULT gen_random_uuid() NOT NULL,
    promotion_id uuid NOT NULL,
    date date NOT NULL,
    impressions integer DEFAULT 0,
    clicks integer DEFAULT 0,
    conversions integer DEFAULT 0,
    revenue_generated numeric(12,2) DEFAULT 0,
    discount_given numeric(12,2) DEFAULT 0,
    channel_breakdown jsonb DEFAULT '{}'::jsonb,
    vertical_breakdown jsonb DEFAULT '{}'::jsonb
);


--
-- Name: TABLE promotion_analytics; Type: COMMENT; Schema: public; Owner: -
--

COMMENT ON TABLE public.promotion_analytics IS 'AI-Native analytics for promotion effectiveness tracking and learning';


--
-- Name: promotion_bundle_items; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.promotion_bundle_items (
    id uuid DEFAULT gen_random_uuid() NOT NULL,
    promotion_id uuid NOT NULL,
    catalog_item_id uuid NOT NULL,
    quantity integer DEFAULT 1,
    is_required boolean DEFAULT true,
    can_substitute_with jsonb DEFAULT '[]'::jsonb
);


--
-- Name: promotion_rule_items; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.promotion_rule_items (
    rule_id uuid NOT NULL,
    catalog_item_id uuid NOT NULL,
    override_discount numeric(10,2),
    role character varying(20) DEFAULT 'both'::character varying,
    CONSTRAINT promotion_rule_items_role_check CHECK (((role)::text = ANY ((ARRAY['qualifying'::character varying, 'reward'::character varying, 'both'::character varying])::text[])))
);


--
-- Name: promotion_rules; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.promotion_rules (
    id uuid DEFAULT gen_random_uuid() NOT NULL,
    promotion_id uuid NOT NULL,
    apply_on character varying(30) NOT NULL,
    category_id uuid,
    include_children boolean DEFAULT true,
    item_type character varying(30),
    min_price numeric(10,2),
    max_price numeric(10,2),
    required_tags text[],
    resource_type character varying(50),
    override_discount_percentage numeric(5,2),
    override_discount_amount numeric(10,2),
    vertical_rule_config jsonb DEFAULT '{}'::jsonb,
    is_active boolean DEFAULT true,
    created_at timestamp with time zone DEFAULT now(),
    CONSTRAINT promotion_rules_apply_on_check CHECK (((apply_on)::text = ANY ((ARRAY['all'::character varying, 'category'::character varying, 'items'::character varying, 'item_type'::character varying, 'tags'::character varying, 'price_range'::character varying, 'resource_type'::character varying, 'vertical_specific'::character varying])::text[])))
);


--
-- Name: TABLE promotion_rules; Type: COMMENT; Schema: public; Owner: -
--

COMMENT ON TABLE public.promotion_rules IS 'Defines WHERE a promotion applies - supports multi-vertical targeting';


--
-- Name: promotion_tiers; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.promotion_tiers (
    id uuid DEFAULT gen_random_uuid() NOT NULL,
    promotion_id uuid NOT NULL,
    tier_label character varying(100),
    min_quantity integer,
    max_quantity integer,
    min_amount numeric(10,2),
    max_amount numeric(10,2),
    discount_percentage numeric(5,2),
    discount_amount numeric(10,2),
    bonus_points integer,
    tier_order integer NOT NULL,
    CONSTRAINT tier_has_range CHECK (((min_quantity IS NOT NULL) OR (min_amount IS NOT NULL)))
);


--
-- Name: promotions; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.promotions (
    id uuid DEFAULT gen_random_uuid() NOT NULL,
    organization_id uuid,
    vertical_code character varying(50),
    vertical_config jsonb DEFAULT '{}'::jsonb,
    name character varying(255) NOT NULL,
    description text,
    promo_code character varying(50),
    internal_code character varying(50),
    ai_generated_description text,
    ai_summary text,
    ai_keywords text[],
    promo_type character varying(30) NOT NULL,
    discount_percentage numeric(5,2),
    discount_amount numeric(10,2),
    fixed_price numeric(10,2),
    buy_quantity integer,
    get_quantity integer,
    get_discount_percent numeric(5,2) DEFAULT 100,
    get_item_id uuid,
    get_same_item boolean DEFAULT true,
    bundle_price numeric(10,2),
    points_multiplier numeric(3,1) DEFAULT 1.0,
    max_discount_amount numeric(10,2),
    min_purchase_amount numeric(10,2),
    min_quantity integer,
    max_uses_total integer,
    max_uses_per_customer integer,
    current_uses integer DEFAULT 0,
    valid_from timestamp with time zone DEFAULT now(),
    valid_until timestamp with time zone,
    valid_days_of_week integer[],
    valid_hours_start time without time zone,
    valid_hours_end time without time zone,
    is_combinable boolean DEFAULT false,
    priority integer DEFAULT 0,
    requires_code boolean DEFAULT false,
    auto_apply boolean DEFAULT true,
    show_in_catalog boolean DEFAULT true,
    notify_on_eligible boolean DEFAULT false,
    embedding extensions.vector(1536),
    has_embedding boolean DEFAULT false,
    embedding_text text,
    nlu_triggers jsonb DEFAULT '[]'::jsonb,
    conversion_rate numeric(5,2) DEFAULT 0,
    total_revenue_generated numeric(12,2) DEFAULT 0,
    avg_order_value_with_promo numeric(10,2),
    rules jsonb DEFAULT '{}'::jsonb,
    is_active boolean DEFAULT true,
    metadata jsonb DEFAULT '{}'::jsonb,
    created_at timestamp with time zone DEFAULT now(),
    updated_at timestamp with time zone DEFAULT now(),
    created_by uuid,
    CONSTRAINT promotions_promo_type_check CHECK (((promo_type)::text = ANY ((ARRAY['percentage'::character varying, 'fixed_amount'::character varying, 'fixed_price'::character varying, 'buy_x_get_y'::character varying, 'free_item'::character varying, 'free_shipping'::character varying, 'bundle_price'::character varying, 'tiered'::character varying, 'loyalty_points'::character varying, 'first_visit'::character varying, 'referral'::character varying])::text[]))),
    CONSTRAINT valid_buy_get CHECK ((((promo_type)::text <> 'buy_x_get_y'::text) OR ((buy_quantity IS NOT NULL) AND (buy_quantity > 0) AND (get_quantity IS NOT NULL) AND (get_quantity > 0)))),
    CONSTRAINT valid_fixed_price CHECK ((((promo_type)::text <> 'fixed_price'::text) OR (fixed_price IS NOT NULL))),
    CONSTRAINT valid_percentage CHECK ((((promo_type)::text <> 'percentage'::text) OR ((discount_percentage IS NOT NULL) AND ((discount_percentage >= (0)::numeric) AND (discount_percentage <= (100)::numeric)))))
);


--
-- Name: TABLE promotions; Type: COMMENT; Schema: public; Owner: -
--

COMMENT ON TABLE public.promotions IS 'AI-Native Multi-Vertical Promotions System v2.0 - Supports all promo types with semantic search and vertical-specific rules';


--
-- Name: COLUMN promotions.vertical_config; Type: COMMENT; Schema: public; Owner: -
--

COMMENT ON COLUMN public.promotions.vertical_config IS 'Vertical-specific rules: salon (stylist_commission), clinic (requires_prescription), retail (online_only)';


--
-- Name: COLUMN promotions.embedding; Type: COMMENT; Schema: public; Owner: -
--

COMMENT ON COLUMN public.promotions.embedding IS 'Vector embedding for semantic search: "find promotions for hair services"';


--
-- Name: COLUMN promotions.nlu_triggers; Type: COMMENT; Schema: public; Owner: -
--

COMMENT ON COLUMN public.promotions.nlu_triggers IS 'NLU integration: intents, keywords, and contexts that trigger this promotion';


--
-- Name: provider_schedule_exceptions; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.provider_schedule_exceptions (
    id uuid DEFAULT gen_random_uuid() NOT NULL,
    organization_id uuid NOT NULL,
    provider_entity_id uuid NOT NULL,
    exception_date date NOT NULL,
    end_date date,
    start_time time without time zone,
    end_time time without time zone,
    is_available boolean DEFAULT false NOT NULL,
    exception_type character varying(50),
    reason text,
    custom_fields jsonb DEFAULT '{}'::jsonb,
    created_at timestamp with time zone DEFAULT timezone('utc'::text, now()) NOT NULL
);


--
-- Name: TABLE provider_schedule_exceptions; Type: COMMENT; Schema: public; Owner: -
--

COMMENT ON TABLE public.provider_schedule_exceptions IS 'Exceptions to regular schedules (vacations, special hours, etc.)';


--
-- Name: provider_schedules; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.provider_schedules (
    id uuid DEFAULT gen_random_uuid() NOT NULL,
    organization_id uuid NOT NULL,
    provider_entity_id uuid NOT NULL,
    day_of_week integer NOT NULL,
    start_time time without time zone NOT NULL,
    end_time time without time zone NOT NULL,
    is_available boolean DEFAULT true NOT NULL,
    notes text,
    created_at timestamp with time zone DEFAULT timezone('utc'::text, now()) NOT NULL,
    CONSTRAINT provider_schedules_day_of_week_check CHECK (((day_of_week >= 1) AND (day_of_week <= 7))),
    CONSTRAINT provider_schedules_time_check CHECK ((end_time > start_time))
);


--
-- Name: TABLE provider_schedules; Type: COMMENT; Schema: public; Owner: -
--

COMMENT ON TABLE public.provider_schedules IS 'Regular weekly schedules for providers';


--
-- Name: provider_skills; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.provider_skills (
    id uuid DEFAULT gen_random_uuid() NOT NULL,
    provider_entity_id uuid NOT NULL,
    skill_id uuid NOT NULL,
    proficiency_level integer DEFAULT 1 NOT NULL,
    is_certified boolean DEFAULT false NOT NULL,
    certified_at date,
    certification_expires_at date,
    certification_number character varying(100),
    certification_document_url text,
    verified_by uuid,
    verified_at timestamp with time zone,
    created_at timestamp with time zone DEFAULT now() NOT NULL,
    updated_at timestamp with time zone DEFAULT now() NOT NULL,
    CONSTRAINT provider_skills_proficiency_level_check CHECK (((proficiency_level >= 1) AND (proficiency_level <= 5)))
);


--
-- Name: TABLE provider_skills; Type: COMMENT; Schema: public; Owner: -
--

COMMENT ON TABLE public.provider_skills IS 'Tracks skills and certifications that providers have';


--
-- Name: resource_availability; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.resource_availability (
    id uuid DEFAULT gen_random_uuid() NOT NULL,
    organization_id uuid NOT NULL,
    resource_entity_id uuid NOT NULL,
    resource_type public.appointment_resource_type NOT NULL,
    day_of_week integer,
    start_time time without time zone NOT NULL,
    end_time time without time zone NOT NULL,
    effective_from date DEFAULT CURRENT_DATE NOT NULL,
    effective_until date,
    is_recurring boolean DEFAULT true,
    max_concurrent_appointments integer DEFAULT 1,
    buffer_time_minutes integer DEFAULT 0,
    is_active boolean DEFAULT true,
    notes text,
    created_at timestamp with time zone DEFAULT now() NOT NULL,
    updated_at timestamp with time zone DEFAULT now() NOT NULL,
    CONSTRAINT resource_availability_buffer_time_minutes_check CHECK ((buffer_time_minutes >= 0)),
    CONSTRAINT resource_availability_dates_check CHECK (((effective_until IS NULL) OR (effective_until >= effective_from))),
    CONSTRAINT resource_availability_day_of_week_check CHECK (((day_of_week >= 0) AND (day_of_week <= 6))),
    CONSTRAINT resource_availability_max_concurrent_appointments_check CHECK ((max_concurrent_appointments > 0)),
    CONSTRAINT resource_availability_time_check CHECK ((end_time > start_time))
);


--
-- Name: TABLE resource_availability; Type: COMMENT; Schema: public; Owner: -
--

COMMENT ON TABLE public.resource_availability IS 'Recurring availability schedules for any resource type';


--
-- Name: resource_capabilities; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.resource_capabilities (
    id uuid DEFAULT gen_random_uuid() NOT NULL,
    organization_id uuid NOT NULL,
    resource_entity_id uuid NOT NULL,
    catalog_item_id uuid NOT NULL,
    proficiency_level public.proficiency_level DEFAULT 'junior'::public.proficiency_level NOT NULL,
    proficiency_score smallint DEFAULT 2 NOT NULL,
    is_primary boolean DEFAULT false NOT NULL,
    custom_duration interval,
    custom_price numeric(18,4),
    currency_code character(3),
    attributes jsonb DEFAULT '{}'::jsonb NOT NULL,
    embedding extensions.vector(1536),
    has_embedding boolean DEFAULT false,
    search_keywords text[],
    valid_from timestamp with time zone DEFAULT now() NOT NULL,
    valid_until timestamp with time zone,
    required_equipment_ids uuid[],
    min_advance_hours integer DEFAULT 0,
    max_daily_appointments integer,
    is_active boolean DEFAULT true NOT NULL,
    notes text,
    created_at timestamp with time zone DEFAULT now() NOT NULL,
    updated_at timestamp with time zone DEFAULT now() NOT NULL,
    created_by uuid,
    updated_by uuid,
    deleted_at timestamp with time zone,
    deleted_by uuid,
    CONSTRAINT chk_currency_with_price CHECK ((((custom_price IS NULL) AND (currency_code IS NULL)) OR ((custom_price IS NOT NULL) AND (currency_code IS NOT NULL)))),
    CONSTRAINT chk_custom_duration_positive CHECK (((custom_duration IS NULL) OR (custom_duration > '00:00:00'::interval))),
    CONSTRAINT chk_custom_price_positive CHECK (((custom_price IS NULL) OR (custom_price >= (0)::numeric))),
    CONSTRAINT chk_proficiency_score_range CHECK (((proficiency_score >= 1) AND (proficiency_score <= 6))),
    CONSTRAINT chk_valid_period CHECK (((valid_until IS NULL) OR (valid_from < valid_until)))
);


--
-- Name: TABLE resource_capabilities; Type: COMMENT; Schema: public; Owner: -
--

COMMENT ON TABLE public.resource_capabilities IS 'Defines WHAT a resource can provide (capability). Multi-tenant, multi-vertical, multi-currency.';


--
-- Name: COLUMN resource_capabilities.attributes; Type: COMMENT; Schema: public; Owner: -
--

COMMENT ON COLUMN public.resource_capabilities.attributes IS 'Flexible JSONB for multi-vertical attributes: modality, languages, certifications, tags, etc.';


--
-- Name: COLUMN resource_capabilities.valid_from; Type: COMMENT; Schema: public; Owner: -
--

COMMENT ON COLUMN public.resource_capabilities.valid_from IS 'Start of validity period. Allows historical tracking of capability/pricing changes.';


--
-- Name: resource_capability_availability; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.resource_capability_availability (
    id uuid DEFAULT gen_random_uuid() NOT NULL,
    capability_id uuid NOT NULL,
    days_of_week smallint[] NOT NULL,
    time_from time without time zone NOT NULL,
    time_until time without time zone NOT NULL,
    timezone text DEFAULT 'America/Santo_Domingo'::text NOT NULL,
    rules jsonb DEFAULT '{}'::jsonb,
    is_active boolean DEFAULT true NOT NULL,
    created_at timestamp with time zone DEFAULT now() NOT NULL,
    updated_at timestamp with time zone DEFAULT now() NOT NULL,
    CONSTRAINT chk_days_not_empty CHECK (((days_of_week IS NOT NULL) AND (cardinality(days_of_week) > 0))),
    CONSTRAINT chk_time_range CHECK ((time_from < time_until))
);


--
-- Name: TABLE resource_capability_availability; Type: COMMENT; Schema: public; Owner: -
--

COMMENT ON TABLE public.resource_capability_availability IS 'Defines WHEN a resource can provide a capability. Supports multiple time slots per capability.';


--
-- Name: COLUMN resource_capability_availability.rules; Type: COMMENT; Schema: public; Owner: -
--

COMMENT ON COLUMN public.resource_capability_availability.rules IS 'Flexible rules: max_bookings_per_day, blocked_dates, channels, priority, etc.';


--
-- Name: resource_unavailability; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.resource_unavailability (
    id uuid DEFAULT gen_random_uuid() NOT NULL,
    organization_id uuid NOT NULL,
    resource_entity_id uuid NOT NULL,
    resource_type public.appointment_resource_type NOT NULL,
    unavailable_from timestamp with time zone NOT NULL,
    unavailable_until timestamp with time zone NOT NULL,
    reason text NOT NULL,
    reason_details text,
    is_active boolean DEFAULT true,
    created_at timestamp with time zone DEFAULT now() NOT NULL,
    updated_at timestamp with time zone DEFAULT now() NOT NULL,
    CONSTRAINT resource_unavailability_reason_check CHECK ((reason = ANY (ARRAY['vacation'::text, 'maintenance'::text, 'repair'::text, 'reserved'::text, 'broken'::text, 'sick_leave'::text, 'other'::text]))),
    CONSTRAINT unavailability_time_check CHECK ((unavailable_until > unavailable_from))
);


--
-- Name: TABLE resource_unavailability; Type: COMMENT; Schema: public; Owner: -
--

COMMENT ON TABLE public.resource_unavailability IS 'Exception periods (vacations, maintenance, etc)';


--
-- Name: roles; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.roles (
    key text NOT NULL,
    name text NOT NULL,
    description text NOT NULL,
    level integer NOT NULL,
    permissions jsonb DEFAULT '{}'::jsonb NOT NULL,
    organization_id uuid,
    is_system boolean DEFAULT false NOT NULL,
    created_at timestamp with time zone DEFAULT now() NOT NULL,
    updated_at timestamp with time zone DEFAULT now() NOT NULL,
    created_by uuid,
    updated_by uuid,
    CONSTRAINT roles_level_check CHECK (((level >= 0) AND (level <= 300))),
    CONSTRAINT valid_permissions CHECK ((jsonb_typeof(permissions) = 'object'::text))
);


--
-- Name: TABLE roles; Type: COMMENT; Schema: public; Owner: -
--

COMMENT ON TABLE public.roles IS 'Hierarchical role system with JSONB permissions for flexible access control';


--
-- Name: COLUMN roles.key; Type: COMMENT; Schema: public; Owner: -
--

COMMENT ON COLUMN public.roles.key IS 'Unique identifier for the role (e.g., owner, admin, manager)';


--
-- Name: COLUMN roles.level; Type: COMMENT; Schema: public; Owner: -
--

COMMENT ON COLUMN public.roles.level IS 'Hierarchy level: owner=100, admin=80, manager=60, staff=40, accountant=30, viewer=10';


--
-- Name: COLUMN roles.permissions; Type: COMMENT; Schema: public; Owner: -
--

COMMENT ON COLUMN public.roles.permissions IS 'JSONB permissions: {"resource": {"action": true|false|"all"|"own"}}';


--
-- Name: scheduled_shifts; Type: TABLE; Schema: public; Owner: -
--

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


--
-- Name: TABLE scheduled_shifts; Type: COMMENT; Schema: public; Owner: -
--

COMMENT ON TABLE public.scheduled_shifts IS 'Specific shifts assigned to employees for particular dates';


--
-- Name: service_providers; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.service_providers (
    id uuid DEFAULT gen_random_uuid() NOT NULL,
    organization_id uuid NOT NULL,
    service_id uuid NOT NULL,
    provider_entity_id uuid NOT NULL,
    custom_price numeric(10,2),
    is_available boolean DEFAULT true NOT NULL,
    custom_fields jsonb DEFAULT '{}'::jsonb,
    created_at timestamp with time zone DEFAULT timezone('utc'::text, now()) NOT NULL
);


--
-- Name: TABLE service_providers; Type: COMMENT; Schema: public; Owner: -
--

COMMENT ON TABLE public.service_providers IS 'Links services to providers who can perform them';


--
-- Name: shift_templates; Type: TABLE; Schema: public; Owner: -
--

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


--
-- Name: TABLE shift_templates; Type: COMMENT; Schema: public; Owner: -
--

COMMENT ON TABLE public.shift_templates IS 'Reusable shift patterns with break configurations';


--
-- Name: skill_access; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.skill_access (
    id uuid DEFAULT gen_random_uuid() NOT NULL,
    role_key text NOT NULL,
    skill_id text NOT NULL,
    can_execute boolean DEFAULT true NOT NULL,
    modules text[],
    verticals text[],
    max_daily_calls integer,
    requires_approval boolean DEFAULT false,
    created_at timestamp with time zone DEFAULT now() NOT NULL,
    updated_at timestamp with time zone DEFAULT now() NOT NULL
);


--
-- Name: TABLE skill_access; Type: COMMENT; Schema: public; Owner: -
--

COMMENT ON TABLE public.skill_access IS 'Controls which roles can execute which CoPilot skills';


--
-- Name: COLUMN skill_access.modules; Type: COMMENT; Schema: public; Owner: -
--

COMMENT ON COLUMN public.skill_access.modules IS 'If set, skill only available in these modules';


--
-- Name: COLUMN skill_access.verticals; Type: COMMENT; Schema: public; Owner: -
--

COMMENT ON COLUMN public.skill_access.verticals IS 'If set, skill only available in these verticals';


--
-- Name: subscription_plans; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.subscription_plans (
    key text NOT NULL,
    name text NOT NULL,
    description text,
    price numeric(10,2) DEFAULT 0,
    currency text DEFAULT 'USD'::text,
    billing_period text DEFAULT 'monthly'::text,
    trial_days integer DEFAULT 14,
    max_users integer,
    max_branches integer DEFAULT 1,
    features jsonb DEFAULT '{}'::jsonb,
    is_active boolean DEFAULT true,
    is_public boolean DEFAULT true,
    sort_order integer DEFAULT 0,
    created_at timestamp with time zone DEFAULT now(),
    updated_at timestamp with time zone DEFAULT now(),
    CONSTRAINT subscription_plans_billing_period_check CHECK ((billing_period = ANY (ARRAY['monthly'::text, 'yearly'::text, 'one_time'::text])))
);


--
-- Name: TABLE subscription_plans; Type: COMMENT; Schema: public; Owner: -
--

COMMENT ON TABLE public.subscription_plans IS 'Available subscription plans for organizations';


--
-- Name: subscriptions; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.subscriptions (
    id uuid DEFAULT gen_random_uuid() NOT NULL,
    organization_id uuid NOT NULL,
    plan_key text NOT NULL,
    status text DEFAULT 'trial'::text NOT NULL,
    trial_ends_at timestamp with time zone,
    current_period_start timestamp with time zone DEFAULT now(),
    current_period_end timestamp with time zone,
    canceled_at timestamp with time zone,
    cancel_reason text,
    payment_method jsonb,
    billing_email text,
    created_at timestamp with time zone DEFAULT now(),
    updated_at timestamp with time zone DEFAULT now(),
    CONSTRAINT subscriptions_status_check CHECK ((status = ANY (ARRAY['trial'::text, 'active'::text, 'past_due'::text, 'canceled'::text, 'suspended'::text])))
);


--
-- Name: TABLE subscriptions; Type: COMMENT; Schema: public; Owner: -
--

COMMENT ON TABLE public.subscriptions IS 'Organization subscriptions linking to plans';


--
-- Name: time_entries; Type: TABLE; Schema: public; Owner: -
--

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


--
-- Name: TABLE time_entries; Type: COMMENT; Schema: public; Owner: -
--

COMMENT ON TABLE public.time_entries IS 'Immutable time punch events - Event Sourcing pattern for T&A';


--
-- Name: time_entry_modifications; Type: TABLE; Schema: public; Owner: -
--

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


--
-- Name: TABLE time_entry_modifications; Type: COMMENT; Schema: public; Owner: -
--

COMMENT ON TABLE public.time_entry_modifications IS 'Audit trail for all time entry modifications';


--
-- Name: user_roles; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.user_roles (
    id uuid DEFAULT gen_random_uuid() NOT NULL,
    user_id uuid NOT NULL,
    role_key text NOT NULL,
    granted_by uuid,
    granted_at timestamp with time zone DEFAULT now(),
    expires_at timestamp with time zone,
    created_at timestamp with time zone DEFAULT now()
);


--
-- Name: user_sessions; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.user_sessions (
    user_id uuid NOT NULL,
    active_org_id uuid,
    preferences jsonb DEFAULT '{}'::jsonb,
    last_activity_at timestamp with time zone DEFAULT now() NOT NULL,
    created_at timestamp with time zone DEFAULT now() NOT NULL,
    updated_at timestamp with time zone DEFAULT now() NOT NULL,
    CONSTRAINT valid_preferences CHECK ((jsonb_typeof(preferences) = 'object'::text))
);


--
-- Name: v_ai_embedding_system_status; Type: VIEW; Schema: public; Owner: -
--

CREATE VIEW public.v_ai_embedding_system_status AS
 SELECT c.table_name,
    c.content_columns,
    c.enabled,
    c.trigger_enabled,
    (EXISTS ( SELECT 1
           FROM pg_trigger
          WHERE (pg_trigger.tgname = ('ai_auto_embed_'::text || c.table_name)))) AS trigger_exists,
    count(q.id) FILTER (WHERE (q.status = 'pending'::public.ai_embedding_status)) AS pending_count,
    count(q.id) FILTER (WHERE (q.status = 'completed'::public.ai_embedding_status)) AS completed_count,
    count(q.id) FILTER (WHERE (q.status = 'failed'::public.ai_embedding_status)) AS failed_count,
    count(emb.id) AS embeddings_count,
    c.created_at,
    c.updated_at
   FROM ((public.ai_embedding_configs c
     LEFT JOIN public.ai_embedding_queue q ON ((q.source_table = c.table_name)))
     LEFT JOIN public.ai_embeddings emb ON ((emb.source_table = c.table_name)))
  WHERE (c.table_schema = 'public'::text)
  GROUP BY c.id, c.table_name, c.content_columns, c.enabled, c.trigger_enabled, c.created_at, c.updated_at
  ORDER BY c.table_name;


--
-- Name: VIEW v_ai_embedding_system_status; Type: COMMENT; Schema: public; Owner: -
--

COMMENT ON VIEW public.v_ai_embedding_system_status IS 'Overview of all tables with auto-embeddings configured';


--
-- Name: v_billing_contacts; Type: VIEW; Schema: public; Owner: -
--

CREATE VIEW public.v_billing_contacts AS
 SELECT er.source_entity_id AS entity_id,
    er.target_entity_id AS billing_entity_id,
    b.display_name AS billing_name,
    b.email AS billing_email,
    b.phone AS billing_phone,
    b.address AS billing_address,
    b.tax_id AS billing_tax_id,
    er.relationship_type,
    er.is_primary,
    er.priority,
    er.context,
    er.notes,
    er.organization_id
   FROM (public.entity_relationships er
     JOIN public.entities b ON ((b.id = er.target_entity_id)))
  WHERE ((er.is_billing_contact = true) AND (er.status = 'active'::public.relationship_status) AND (er.deleted_at IS NULL) AND (b.deleted_at IS NULL) AND ((er.valid_until IS NULL) OR (er.valid_until >= CURRENT_DATE)))
  ORDER BY er.priority, er.is_primary DESC;


--
-- Name: VIEW v_billing_contacts; Type: COMMENT; Schema: public; Owner: -
--

COMMENT ON VIEW public.v_billing_contacts IS 'Entities responsible for billing/invoicing';


--
-- Name: v_clients_full; Type: VIEW; Schema: public; Owner: -
--

CREATE VIEW public.v_clients_full AS
 SELECT c.id,
    c.entity_id,
    c.organization_id,
    c.client_code,
    c.external_id,
    c.date_of_birth,
    c.gender,
    c.status,
    c.category,
    c.source,
    c.referred_by_entity_id,
    c.first_visit_date,
    c.last_visit_date,
    c.next_appointment_date,
    c.total_visits,
    c.preferences,
    c.communication_preferences,
    c.loyalty_points,
    c.loyalty_tier,
    c.loyalty_joined_at,
    c.total_spent,
    c.average_ticket,
    c.last_payment_date,
    c.alerts,
    c.notes,
    c.ai_insights,
    c.vertical_fields,
    c.created_at,
    c.created_by,
    c.updated_at,
    c.updated_by,
    c.deleted_at,
    c.deleted_by,
    c.embedding,
    c.has_embedding,
    c.tags,
    c.client_type,
    c.photo_url,
    c.company_name,
    c.trade_name,
    c.tax_id,
    c.industry,
    c.legal_representative,
    c.legal_representative_phone,
    c.legal_representative_email,
    c.number_of_employees,
    c.website,
    c.year_founded,
    c.social_links,
    c.ai_churn_risk,
    c.ai_lifetime_value,
    c.ai_predicted_next_visit,
    c.ai_upsell_opportunities,
    c.first_name,
    c.last_name,
    e.display_name,
    e.phone,
    e.mobile,
    e.email
   FROM (public.clients c
     LEFT JOIN public.entities e ON ((e.id = c.entity_id)));


--
-- Name: v_clients_summary; Type: VIEW; Schema: public; Owner: -
--

CREATE VIEW public.v_clients_summary AS
 SELECT c.id AS client_id,
    c.entity_id,
    c.organization_id,
    e.display_name,
    e.phone,
    e.email,
    c.category,
    c.status,
    c.source,
    c.total_visits,
    c.total_spent,
    c.loyalty_points,
    c.loyalty_tier,
    c.last_visit_date,
    c.next_appointment_date,
    c.first_visit_date,
        CASE
            WHEN (c.last_visit_date IS NOT NULL) THEN (CURRENT_DATE - c.last_visit_date)
            ELSE NULL::integer
        END AS days_since_last_visit,
    ((c.next_appointment_date IS NOT NULL) AND (c.next_appointment_date >= CURRENT_DATE)) AS has_upcoming_appointment
   FROM (public.clients c
     JOIN public.entities e ON ((e.id = c.entity_id)))
  WHERE ((c.deleted_at IS NULL) AND (e.deleted_at IS NULL));


--
-- Name: v_emergency_contacts; Type: VIEW; Schema: public; Owner: -
--

CREATE VIEW public.v_emergency_contacts AS
 SELECT er.source_entity_id AS entity_id,
    er.target_entity_id AS contact_entity_id,
    c.display_name AS contact_name,
    c.phone AS contact_phone,
    c.mobile AS contact_mobile,
    c.email AS contact_email,
    er.relationship_type,
    er.can_authorize,
    er.priority,
    er.notes,
    er.organization_id
   FROM (public.entity_relationships er
     JOIN public.entities c ON ((c.id = er.target_entity_id)))
  WHERE ((er.is_emergency_contact = true) AND (er.status = 'active'::public.relationship_status) AND (er.deleted_at IS NULL) AND (c.deleted_at IS NULL) AND ((er.valid_until IS NULL) OR (er.valid_until >= CURRENT_DATE)))
  ORDER BY er.priority;


--
-- Name: VIEW v_emergency_contacts; Type: COMMENT; Schema: public; Owner: -
--

COMMENT ON VIEW public.v_emergency_contacts IS 'Emergency contacts for entities';


--
-- Name: v_employee_hierarchy; Type: VIEW; Schema: public; Owner: -
--

CREATE VIEW public.v_employee_hierarchy AS
 WITH RECURSIVE hierarchy AS (
         SELECT e.id,
            e.employee_code,
            e.entity_id,
            ent.display_name,
            e."position",
            e.department,
            e.reports_to_employee_id,
            0 AS level,
            ARRAY[e.id] AS path,
            ent.display_name AS hierarchy_path
           FROM (public.employees e
             JOIN public.entities ent ON ((e.entity_id = ent.id)))
          WHERE ((e.reports_to_employee_id IS NULL) AND (e.deleted_at IS NULL) AND (e.employment_status = ANY (ARRAY['active'::public.employment_status_enum, 'on_leave'::public.employment_status_enum])))
        UNION ALL
         SELECT e.id,
            e.employee_code,
            e.entity_id,
            ent.display_name,
            e."position",
            e.department,
            e.reports_to_employee_id,
            (h.level + 1),
            (h.path || e.id),
            ((h.hierarchy_path || ' > '::text) || ent.display_name)
           FROM ((public.employees e
             JOIN public.entities ent ON ((e.entity_id = ent.id)))
             JOIN hierarchy h ON ((e.reports_to_employee_id = h.id)))
          WHERE ((e.deleted_at IS NULL) AND (e.employment_status = ANY (ARRAY['active'::public.employment_status_enum, 'on_leave'::public.employment_status_enum])) AND (NOT (e.id = ANY (h.path))))
        )
 SELECT id,
    employee_code,
    entity_id,
    display_name,
    "position",
    department,
    reports_to_employee_id,
    level,
    path,
    hierarchy_path
   FROM hierarchy
  ORDER BY hierarchy_path;


--
-- Name: VIEW v_employee_hierarchy; Type: COMMENT; Schema: public; Owner: -
--

COMMENT ON VIEW public.v_employee_hierarchy IS 'Recursive employee hierarchy showing reporting structure';


--
-- Name: v_employees_ai_dashboard; Type: VIEW; Schema: public; Owner: -
--

CREATE VIEW public.v_employees_ai_dashboard AS
 SELECT e.id,
    e.employee_code,
    ent.display_name,
    e."position",
    e.department,
    e.employment_status,
    jsonb_array_length(COALESCE(((e.skills -> 'technical'::text) -> 'programming'::text), '[]'::jsonb)) AS programming_skills_count,
    jsonb_array_length(COALESCE((e.skills -> 'certifications'::text), '[]'::jsonb)) AS certifications_count,
    (((e.ai_features -> 'scores'::text) ->> 'performance_score'::text))::numeric AS ai_performance_score,
    (((e.ai_features -> 'scores'::text) ->> 'engagement_score'::text))::numeric AS ai_engagement_score,
    (((e.ai_features -> 'scores'::text) ->> 'retention_risk'::text))::numeric AS ai_retention_risk,
    (((e.ai_features -> 'predictions'::text) ->> 'turnover_probability'::text))::numeric AS ai_turnover_probability,
    (((e.analytics_snapshot -> 'employment'::text) ->> 'tenure_years'::text))::numeric AS tenure_years,
    (((e.analytics_snapshot -> 'compensation'::text) ->> 'current_salary'::text))::numeric AS current_salary,
    e.skills,
    e.ai_features,
    e.analytics_snapshot,
    e.updated_at
   FROM (public.employees e
     JOIN public.entities ent ON ((e.entity_id = ent.id)))
  WHERE ((e.deleted_at IS NULL) AND (e.employment_status = 'active'::public.employment_status_enum));


--
-- Name: VIEW v_employees_ai_dashboard; Type: COMMENT; Schema: public; Owner: -
--

COMMENT ON VIEW public.v_employees_ai_dashboard IS 'AI-powered employee dashboard with skills, predictions, and analytics';


--
-- Name: v_employees_by_department; Type: VIEW; Schema: public; Owner: -
--

CREATE VIEW public.v_employees_by_department AS
 SELECT organization_id,
    department,
    count(*) AS total_employees,
    count(*) FILTER (WHERE (employment_status = 'active'::public.employment_status_enum)) AS active_employees,
    count(*) FILTER (WHERE (employment_type = 'full_time'::public.employment_type_enum)) AS full_time_employees,
    count(*) FILTER (WHERE (employment_type = 'part_time'::public.employment_type_enum)) AS part_time_employees,
    avg(salary) FILTER (WHERE (salary IS NOT NULL)) AS avg_salary,
    min(salary) FILTER (WHERE (salary IS NOT NULL)) AS min_salary,
    max(salary) FILTER (WHERE (salary IS NOT NULL)) AS max_salary,
    avg(EXTRACT(year FROM age((COALESCE(termination_date, CURRENT_DATE))::timestamp with time zone, (hire_date)::timestamp with time zone))) AS avg_tenure_years
   FROM public.employees e
  WHERE (deleted_at IS NULL)
  GROUP BY organization_id, department
  ORDER BY organization_id, (count(*)) DESC;


--
-- Name: VIEW v_employees_by_department; Type: COMMENT; Schema: public; Owner: -
--

COMMENT ON VIEW public.v_employees_by_department IS 'Employee statistics aggregated by department';


--
-- Name: v_employees_full; Type: VIEW; Schema: public; Owner: -
--

CREATE VIEW public.v_employees_full AS
 SELECT e.id,
    e.employee_code,
    e.entity_id,
    e.organization_id,
    ent.display_name,
    ent.legal_name,
    ent.email,
    ent.phone,
    ent.mobile,
    ent.address,
    ent.city,
    ent.state,
    ent.postal_code,
    ent.country,
    e.hire_date,
    e.termination_date,
    e.employment_status,
    e.employment_type,
    e."position",
    e.department,
    e.division,
    e.work_location,
    e.reports_to_employee_id,
    mgr_ent.display_name AS manager_name,
    mgr."position" AS manager_position,
    e.salary,
    e.salary_currency,
    e.salary_period,
    e.commission_rate,
    e.bonus_eligible,
    e.vacation_days_per_year,
    e.vacation_days_accrued,
    e.sick_days_per_year,
    e.sick_days_used,
    e.last_review_date,
    e.next_review_date,
    e.performance_rating,
    app.get_employee_tenure(e.id) AS tenure,
    EXTRACT(year FROM age((COALESCE(e.termination_date, CURRENT_DATE))::timestamp with time zone, (e.hire_date)::timestamp with time zone)) AS years_of_service,
    e.created_at,
    e.updated_at,
    e.deleted_at
   FROM (((public.employees e
     JOIN public.entities ent ON ((e.entity_id = ent.id)))
     LEFT JOIN public.employees mgr ON ((e.reports_to_employee_id = mgr.id)))
     LEFT JOIN public.entities mgr_ent ON ((mgr.entity_id = mgr_ent.id)))
  WHERE (e.deleted_at IS NULL);


--
-- Name: VIEW v_employees_full; Type: COMMENT; Schema: public; Owner: -
--

COMMENT ON VIEW public.v_employees_full IS 'Full employee view with entity and manager information';


--
-- Name: v_entity_guardians; Type: VIEW; Schema: public; Owner: -
--

CREATE VIEW public.v_entity_guardians AS
 SELECT er.source_entity_id AS minor_entity_id,
    er.target_entity_id AS guardian_entity_id,
    g.display_name AS guardian_name,
    g.email AS guardian_email,
    g.phone AS guardian_phone,
    er.relationship_type,
    er.is_primary,
    er.can_authorize,
    er.can_represent,
    er.can_pickup,
    er.is_billing_contact,
    er.priority,
    er.context,
    (er.metadata ->> 'custody_type'::text) AS custody_type,
    er.notes,
    er.organization_id
   FROM (public.entity_relationships er
     JOIN public.entities g ON ((g.id = er.target_entity_id)))
  WHERE ((er.relationship_type = ANY (ARRAY['parent'::public.entity_relationship_type, 'legal_guardian'::public.entity_relationship_type, 'grandparent'::public.entity_relationship_type])) AND (er.status = 'active'::public.relationship_status) AND (er.deleted_at IS NULL) AND (g.deleted_at IS NULL) AND ((er.valid_until IS NULL) OR (er.valid_until >= CURRENT_DATE)))
  ORDER BY er.priority, er.is_primary DESC;


--
-- Name: VIEW v_entity_guardians; Type: COMMENT; Schema: public; Owner: -
--

COMMENT ON VIEW public.v_entity_guardians IS 'Parents and guardians for minor entities';


--
-- Name: v_entity_relationships_full; Type: VIEW; Schema: public; Owner: -
--

CREATE VIEW public.v_entity_relationships_full AS
 SELECT er.id AS relationship_id,
    er.organization_id,
    er.relationship_type,
    er.status,
    er.context,
    er.source_entity_id,
    source.display_name AS source_name,
    source.entity_type AS source_type,
    source.email AS source_email,
    source.phone AS source_phone,
    er.target_entity_id,
    target.display_name AS target_name,
    target.entity_type AS target_type,
    target.email AS target_email,
    target.phone AS target_phone,
    er.is_primary,
    er.is_billing_contact,
    er.is_emergency_contact,
    er.can_authorize,
    er.can_represent,
    er.can_pickup,
    er.receives_notifications,
    er.valid_from,
    er.valid_until,
        CASE
            WHEN (er.valid_until IS NULL) THEN true
            WHEN (er.valid_until >= CURRENT_DATE) THEN true
            ELSE false
        END AS is_currently_valid,
    er.priority,
    er.notes,
    er.metadata,
    er.created_at,
    er.updated_at
   FROM ((public.entity_relationships er
     JOIN public.entities source ON ((source.id = er.source_entity_id)))
     JOIN public.entities target ON ((target.id = er.target_entity_id)))
  WHERE ((er.deleted_at IS NULL) AND (source.deleted_at IS NULL) AND (target.deleted_at IS NULL));


--
-- Name: VIEW v_entity_relationships_full; Type: COMMENT; Schema: public; Owner: -
--

COMMENT ON VIEW public.v_entity_relationships_full IS 'Complete view of entity relationships with source and target entity details';


--
-- Name: v_inactive_clients; Type: VIEW; Schema: public; Owner: -
--

CREATE VIEW public.v_inactive_clients AS
 SELECT client_id,
    entity_id,
    organization_id,
    display_name,
    phone,
    email,
    category,
    status,
    source,
    total_visits,
    total_spent,
    loyalty_points,
    loyalty_tier,
    last_visit_date,
    next_appointment_date,
    first_visit_date,
    days_since_last_visit,
    has_upcoming_appointment
   FROM public.v_clients_summary
  WHERE ((days_since_last_visit > 90) OR ((days_since_last_visit IS NULL) AND (first_visit_date < (CURRENT_DATE - '90 days'::interval))));


--
-- Name: v_patients_summary; Type: VIEW; Schema: public; Owner: -
--

CREATE VIEW public.v_patients_summary AS
 SELECT p.id AS patient_id,
    p.organization_id,
    p.patient_code,
    p.medical_record_number,
    e.id AS entity_id,
    e.display_name,
    e.email,
    e.phone,
    e.person_subtype,
    p.date_of_birth,
    public.get_patient_age(p.date_of_birth) AS age,
    p.gender,
    p.preferred_language,
    p.blood_type,
    p.status,
    p.category,
    p.first_visit_date,
    p.last_visit_date,
    p.next_appointment_date,
    ((p.ai_risk_assessment ->> 'overall_risk_score'::text))::numeric AS risk_score,
    (p.ai_risk_assessment ->> 'risk_category'::text) AS risk_category,
    ((p.ai_predictions ->> 'no_show_probability'::text))::numeric AS no_show_probability,
    p.created_at,
    p.updated_at
   FROM (public.patients p
     JOIN public.entities e ON ((e.id = p.entity_id)))
  WHERE ((p.deleted_at IS NULL) AND (e.deleted_at IS NULL));


--
-- Name: v_patients_with_allergies; Type: VIEW; Schema: public; Owner: -
--

CREATE VIEW public.v_patients_with_allergies AS
 SELECT p.id AS patient_id,
    p.organization_id,
    e.display_name,
    p.patient_code,
    p.allergies,
    jsonb_array_length(p.allergies) AS allergy_count
   FROM (public.patients p
     JOIN public.entities e ON ((e.id = p.entity_id)))
  WHERE ((p.deleted_at IS NULL) AND (e.deleted_at IS NULL) AND (jsonb_array_length(p.allergies) > 0));


--
-- Name: VIEW v_patients_with_allergies; Type: COMMENT; Schema: public; Owner: -
--

COMMENT ON VIEW public.v_patients_with_allergies IS 'Patients with documented allergies (safety-critical).';


--
-- Name: v_pediatric_patients; Type: VIEW; Schema: public; Owner: -
--

CREATE VIEW public.v_pediatric_patients AS
 SELECT p.id AS patient_id,
    p.organization_id,
    p.patient_code,
    e.display_name AS patient_name,
    p.date_of_birth,
    public.get_patient_age(p.date_of_birth) AS age,
    p.status,
    p.last_visit_date,
    p.next_appointment_date
   FROM (public.patients p
     JOIN public.entities e ON ((e.id = p.entity_id)))
  WHERE ((p.deleted_at IS NULL) AND (e.deleted_at IS NULL) AND (public.get_patient_age(p.date_of_birth) < 18));


--
-- Name: VIEW v_pediatric_patients; Type: COMMENT; Schema: public; Owner: -
--

COMMENT ON VIEW public.v_pediatric_patients IS 'Pediatric patients (age < 18).';


--
-- Name: v_upcoming_reviews; Type: VIEW; Schema: public; Owner: -
--

CREATE VIEW public.v_upcoming_reviews AS
 SELECT e.id,
    e.employee_code,
    ent.display_name,
    e."position",
    e.department,
    e.next_review_date,
    e.last_review_date,
    e.performance_rating,
    (CURRENT_DATE - e.next_review_date) AS days_overdue,
    mgr_ent.display_name AS manager_name
   FROM (((public.employees e
     JOIN public.entities ent ON ((e.entity_id = ent.id)))
     LEFT JOIN public.employees mgr ON ((e.reports_to_employee_id = mgr.id)))
     LEFT JOIN public.entities mgr_ent ON ((mgr.entity_id = mgr_ent.id)))
  WHERE ((e.deleted_at IS NULL) AND (e.employment_status = 'active'::public.employment_status_enum) AND ((e.next_review_date <= (CURRENT_DATE + '30 days'::interval)) OR (e.next_review_date IS NULL)))
  ORDER BY e.next_review_date;


--
-- Name: VIEW v_upcoming_reviews; Type: COMMENT; Schema: public; Owner: -
--

COMMENT ON VIEW public.v_upcoming_reviews IS 'Employees with upcoming or overdue performance reviews';


--
-- Name: v_vip_clients; Type: VIEW; Schema: public; Owner: -
--

CREATE VIEW public.v_vip_clients AS
 SELECT client_id,
    entity_id,
    organization_id,
    display_name,
    phone,
    email,
    category,
    status,
    source,
    total_visits,
    total_spent,
    loyalty_points,
    loyalty_tier,
    last_visit_date,
    next_appointment_date,
    first_visit_date,
    days_since_last_visit,
    has_upcoming_appointment
   FROM public.v_clients_summary
  WHERE (category = 'vip'::public.client_category);


--
-- Name: v_vip_patients; Type: VIEW; Schema: public; Owner: -
--

CREATE VIEW public.v_vip_patients AS
 SELECT p.id AS patient_id,
    p.organization_id,
    p.patient_code,
    e.display_name,
    e.email,
    e.phone,
    p.category,
    p.status,
    p.last_visit_date,
    p.next_appointment_date,
    ((p.ai_insights ->> 'lifetime_value_estimate'::text))::numeric AS lifetime_value
   FROM (public.patients p
     JOIN public.entities e ON ((e.id = p.entity_id)))
  WHERE ((p.deleted_at IS NULL) AND (e.deleted_at IS NULL) AND (p.category = 'vip'::public.patient_category));


--
-- Name: VIEW v_vip_patients; Type: COMMENT; Schema: public; Owner: -
--

COMMENT ON VIEW public.v_vip_patients IS 'VIP patients with lifetime value estimates.';


--
-- Name: vertical_configs; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.vertical_configs (
    id uuid DEFAULT gen_random_uuid() NOT NULL,
    organization_id uuid,
    vertical text NOT NULL,
    config jsonb DEFAULT '{}'::jsonb NOT NULL,
    language text DEFAULT 'es'::text,
    is_active boolean DEFAULT true,
    created_at timestamp with time zone DEFAULT now(),
    updated_at timestamp with time zone DEFAULT now(),
    CONSTRAINT vertical_configs_vertical_check CHECK ((vertical = ANY (ARRAY['healthcare'::text, 'dental'::text, 'beauty'::text, 'fitness'::text, 'veterinary'::text, 'legal'::text, 'education'::text, 'restaurant'::text, 'retail'::text, 'generic'::text])))
);


--
-- Name: TABLE vertical_configs; Type: COMMENT; Schema: public; Owner: -
--

COMMENT ON TABLE public.vertical_configs IS 'Industry-specific configurations and terminology';


--
-- Name: COLUMN vertical_configs.vertical; Type: COMMENT; Schema: public; Owner: -
--

COMMENT ON COLUMN public.vertical_configs.vertical IS 'Industry vertical: healthcare, dental, beauty, etc.';


--
-- Name: COLUMN vertical_configs.config; Type: COMMENT; Schema: public; Owner: -
--

COMMENT ON COLUMN public.vertical_configs.config IS 'JSONB config with terminology, prompts, business rules';


--
-- Name: waitlist_configurations; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.waitlist_configurations (
    id uuid DEFAULT gen_random_uuid() NOT NULL,
    organization_id uuid NOT NULL,
    location_id uuid,
    enabled boolean DEFAULT true NOT NULL,
    allow_client_self_add boolean DEFAULT true NOT NULL,
    default_priority public.waitlist_priority DEFAULT 'first_in_line'::public.waitlist_priority NOT NULL,
    default_expiration_days integer DEFAULT 30 NOT NULL,
    default_response_timeout_hours integer DEFAULT 24 NOT NULL,
    max_entries_per_client integer DEFAULT 5 NOT NULL,
    auto_notify_on_opening boolean DEFAULT true NOT NULL,
    max_notify_per_opening integer DEFAULT 3 NOT NULL,
    notification_email_template text,
    notification_sms_template text,
    require_card_on_file boolean DEFAULT false NOT NULL,
    enable_ai_prioritization boolean DEFAULT false NOT NULL,
    enable_ai_slot_recommendation boolean DEFAULT false NOT NULL,
    created_at timestamp with time zone DEFAULT now() NOT NULL,
    updated_at timestamp with time zone DEFAULT now() NOT NULL
);


--
-- Name: walkin_configurations; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.walkin_configurations (
    id uuid DEFAULT gen_random_uuid() NOT NULL,
    organization_id uuid NOT NULL,
    location_id uuid,
    enabled boolean DEFAULT true NOT NULL,
    enable_kiosk_checkin boolean DEFAULT true NOT NULL,
    enable_web_checkin boolean DEFAULT true NOT NULL,
    enable_sms_checkin boolean DEFAULT true NOT NULL,
    enable_qr_checkin boolean DEFAULT true NOT NULL,
    enable_virtual_waiting_room boolean DEFAULT true NOT NULL,
    allow_remote_waiting boolean DEFAULT true NOT NULL,
    auto_send_ready_notification boolean DEFAULT true NOT NULL,
    self_checkin_lead_minutes integer DEFAULT 15 NOT NULL,
    max_queue_size integer DEFAULT 0 NOT NULL,
    show_estimated_wait_time boolean DEFAULT true NOT NULL,
    enable_queue_display boolean DEFAULT true NOT NULL,
    enable_queue_position_updates boolean DEFAULT true NOT NULL,
    queue_position_update_interval_minutes integer DEFAULT 10 NOT NULL,
    enable_gap_processing boolean DEFAULT true NOT NULL,
    minimum_gap_minutes integer DEFAULT 15 NOT NULL,
    gap_eligible_service_ids uuid[],
    walk_away_timeout_minutes integer DEFAULT 60 NOT NULL,
    no_response_timeout_minutes integer DEFAULT 5 NOT NULL,
    enable_ai_wait_time_estimation boolean DEFAULT false NOT NULL,
    enable_ai_walk_away_prediction boolean DEFAULT false NOT NULL,
    enable_ai_resource_assignment boolean DEFAULT false NOT NULL,
    self_checkin_message text,
    ready_notification_message text,
    queue_display_theme character varying(50),
    created_at timestamp with time zone DEFAULT now() NOT NULL,
    updated_at timestamp with time zone DEFAULT now() NOT NULL
);


--
-- Name: walkin_entries; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.walkin_entries (
    id uuid DEFAULT gen_random_uuid() NOT NULL,
    organization_id uuid NOT NULL,
    location_id uuid NOT NULL,
    client_entity_id uuid,
    client_name character varying(255) NOT NULL,
    client_phone character varying(50),
    client_email character varying(255),
    is_new_client boolean DEFAULT false NOT NULL,
    service_id uuid,
    service_name character varying(255) NOT NULL,
    service_duration_minutes integer NOT NULL,
    preferred_resource_id uuid,
    preferred_resource_name character varying(255),
    checkin_method public.checkin_method DEFAULT 'staff_added'::public.checkin_method NOT NULL,
    arrived_at timestamp with time zone DEFAULT now() NOT NULL,
    party_size integer DEFAULT 1 NOT NULL,
    status public.walkin_status DEFAULT 'waiting'::public.walkin_status NOT NULL,
    queue_position integer DEFAULT 1 NOT NULL,
    estimated_wait_minutes integer,
    actual_wait_minutes integer,
    assigned_resource_id uuid,
    assigned_resource_name character varying(255),
    called_at timestamp with time zone,
    service_started_at timestamp with time zone,
    service_completed_at timestamp with time zone,
    is_gap_processing boolean DEFAULT false NOT NULL,
    gap_from_appointment_id uuid,
    gap_processing_notes text,
    is_waiting_remotely boolean DEFAULT false NOT NULL,
    remote_waiting_location character varying(255),
    ready_notification_sent_at timestamp with time zone,
    confirmed_arriving boolean DEFAULT false NOT NULL,
    wait_time_confidence numeric(3,2),
    ai_suggested_resource_id uuid,
    walk_away_risk numeric(3,2),
    queue_updates_sent integer DEFAULT 0 NOT NULL,
    created_appointment_id uuid,
    notes text,
    processed_by_staff_id uuid,
    created_by uuid,
    created_at timestamp with time zone DEFAULT now() NOT NULL,
    updated_at timestamp with time zone DEFAULT now() NOT NULL
);


--
-- Name: whatsapp_messages; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.whatsapp_messages (
    id uuid DEFAULT gen_random_uuid() NOT NULL,
    conversation_id uuid NOT NULL,
    direction text NOT NULL,
    content text,
    message_type text DEFAULT 'text'::text,
    media_url text,
    media_mime_type text,
    caption text,
    location_latitude numeric(10,7),
    location_longitude numeric(10,7),
    location_name text,
    location_address text,
    interactive_data jsonb,
    provider_message_id text,
    provider_status text,
    provider_error_code text,
    provider_error_message text,
    orchestrator_request_id text,
    orchestrator_response jsonb,
    processing_time_ms integer,
    sent_at timestamp with time zone DEFAULT now(),
    delivered_at timestamp with time zone,
    read_at timestamp with time zone,
    created_at timestamp with time zone DEFAULT now(),
    CONSTRAINT valid_message_data CHECK (((content IS NOT NULL) OR (media_url IS NOT NULL) OR ((location_latitude IS NOT NULL) AND (location_longitude IS NOT NULL)) OR (interactive_data IS NOT NULL))),
    CONSTRAINT whatsapp_messages_direction_check CHECK ((direction = ANY (ARRAY['inbound'::text, 'outbound'::text]))),
    CONSTRAINT whatsapp_messages_message_type_check CHECK ((message_type = ANY (ARRAY['text'::text, 'image'::text, 'voice'::text, 'video'::text, 'document'::text, 'location'::text, 'button_reply'::text, 'list_reply'::text, 'buttons'::text, 'list'::text]))),
    CONSTRAINT whatsapp_messages_provider_status_check CHECK ((provider_status = ANY (ARRAY['sent'::text, 'delivered'::text, 'read'::text, 'failed'::text])))
);


--
-- Name: TABLE whatsapp_messages; Type: COMMENT; Schema: public; Owner: -
--

COMMENT ON TABLE public.whatsapp_messages IS 'Stores individual WhatsApp messages with full media and interaction support';


--
-- Name: COLUMN whatsapp_messages.interactive_data; Type: COMMENT; Schema: public; Owner: -
--

COMMENT ON COLUMN public.whatsapp_messages.interactive_data IS 'Stores button/list configuration for interactive messages';


--
-- Name: COLUMN whatsapp_messages.orchestrator_response; Type: COMMENT; Schema: public; Owner: -
--

COMMENT ON COLUMN public.whatsapp_messages.orchestrator_response IS 'Stores full orchestrator response for analytics and debugging';


--
-- Name: whatsapp_appointment_success_rate; Type: VIEW; Schema: public; Owner: -
--

CREATE VIEW public.whatsapp_appointment_success_rate AS
 SELECT date(sent_at) AS date,
    count(*) AS total_orchestrator_calls,
    count(*) FILTER (WHERE ((orchestrator_response ->> 'success'::text) = 'true'::text)) AS successful,
    count(*) FILTER (WHERE ((orchestrator_response ->> 'success'::text) = 'false'::text)) AS failed,
    round(((100.0 * (count(*) FILTER (WHERE ((orchestrator_response ->> 'success'::text) = 'true'::text)))::numeric) / (NULLIF(count(*), 0))::numeric), 2) AS success_rate_pct
   FROM public.whatsapp_messages
  WHERE ((direction = 'outbound'::text) AND (orchestrator_response IS NOT NULL) AND (sent_at >= (CURRENT_DATE - '30 days'::interval)))
  GROUP BY (date(sent_at))
  ORDER BY (date(sent_at)) DESC;


--
-- Name: VIEW whatsapp_appointment_success_rate; Type: COMMENT; Schema: public; Owner: -
--

COMMENT ON VIEW public.whatsapp_appointment_success_rate IS 'Daily success rate for appointment creation via WhatsApp';


--
-- Name: whatsapp_conversations; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.whatsapp_conversations (
    id uuid DEFAULT gen_random_uuid() NOT NULL,
    phone_number text NOT NULL,
    organization_id uuid NOT NULL,
    entity_id uuid,
    user_id uuid,
    first_message_at timestamp with time zone DEFAULT now(),
    last_message_at timestamp with time zone DEFAULT now(),
    message_count integer DEFAULT 0,
    conversation_state text DEFAULT 'active'::text,
    context jsonb DEFAULT '{}'::jsonb,
    provider text DEFAULT 'meta'::text,
    provider_conversation_id text,
    created_at timestamp with time zone DEFAULT now(),
    updated_at timestamp with time zone DEFAULT now(),
    deleted_at timestamp with time zone,
    flow_state jsonb DEFAULT '{}'::jsonb,
    pending_action jsonb,
    CONSTRAINT whatsapp_conversations_conversation_state_check CHECK ((conversation_state = ANY (ARRAY['active'::text, 'waiting_response'::text, 'resolved'::text, 'abandoned'::text]))),
    CONSTRAINT whatsapp_conversations_provider_check CHECK ((provider = ANY (ARRAY['meta'::text, 'twilio'::text])))
);


--
-- Name: TABLE whatsapp_conversations; Type: COMMENT; Schema: public; Owner: -
--

COMMENT ON TABLE public.whatsapp_conversations IS 'Stores WhatsApp conversation sessions with context and state for multi-turn interactions';


--
-- Name: COLUMN whatsapp_conversations.conversation_state; Type: COMMENT; Schema: public; Owner: -
--

COMMENT ON COLUMN public.whatsapp_conversations.conversation_state IS 'Tracks the current state of the conversation for multi-turn interactions. Structure:
{
  "pending_action": "create_appointment",
  "collected_data": {
    "doctor": "Dr. Pérez",
    "date": "2025-11-28",
    "time": "10:00"
  },
  "missing_fields": ["service_type"],
  "last_question": "¿Qué tipo de consulta necesitas?",
  "question_count": 1,
  "started_at": "2025-11-27T22:00:00Z",
  "expires_at": "2025-11-27T22:15:00Z"
}';


--
-- Name: COLUMN whatsapp_conversations.context; Type: COMMENT; Schema: public; Owner: -
--

COMMENT ON COLUMN public.whatsapp_conversations.context IS 'JSONB field storing partial appointment data, user preferences, and conversation state';


--
-- Name: COLUMN whatsapp_conversations.flow_state; Type: COMMENT; Schema: public; Owner: -
--

COMMENT ON COLUMN public.whatsapp_conversations.flow_state IS 'Tracks multi-turn conversation flow state for collecting information. Structure:
{
  "pending_action": "create_appointment",
  "collected_data": {"doctor": "Dr. Pérez", "date": "2025-11-28"},
  "missing_fields": ["time", "service"],
  "question_count": 1,
  "started_at": "2025-11-27T22:00:00Z",
  "expires_at": "2025-11-27T22:15:00Z"
}';


--
-- Name: COLUMN whatsapp_conversations.pending_action; Type: COMMENT; Schema: public; Owner: -
--

COMMENT ON COLUMN public.whatsapp_conversations.pending_action IS 'Pending action awaiting user confirmation (e.g., appointment to be created)';


--
-- Name: whatsapp_message_stats; Type: VIEW; Schema: public; Owner: -
--

CREATE VIEW public.whatsapp_message_stats AS
 SELECT date(sent_at) AS date,
    direction,
    message_type,
    count(*) AS message_count,
    count(DISTINCT conversation_id) AS unique_conversations,
    avg(processing_time_ms) AS avg_processing_time_ms,
    count(*) FILTER (WHERE (provider_status = 'failed'::text)) AS failed_count
   FROM public.whatsapp_messages
  WHERE (sent_at >= (CURRENT_DATE - '30 days'::interval))
  GROUP BY (date(sent_at)), direction, message_type
  ORDER BY (date(sent_at)) DESC, direction, message_type;


--
-- Name: VIEW whatsapp_message_stats; Type: COMMENT; Schema: public; Owner: -
--

COMMENT ON VIEW public.whatsapp_message_stats IS 'Daily aggregated statistics for WhatsApp messages';


--
-- Name: whatsapp_org_config; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.whatsapp_org_config (
    id uuid DEFAULT gen_random_uuid() NOT NULL,
    organization_id uuid NOT NULL,
    use_emojis boolean DEFAULT true,
    use_formatting boolean DEFAULT true,
    default_tone text DEFAULT 'friendly'::text,
    greeting_style text DEFAULT 'warm'::text,
    use_buttons boolean DEFAULT true,
    use_list_messages boolean DEFAULT true,
    max_inline_buttons integer DEFAULT 3,
    show_quick_replies boolean DEFAULT true,
    confirmation_style text DEFAULT 'detailed'::text,
    emoji_mappings jsonb DEFAULT '{"info": "ℹ️", "wave": "👋", "clock": "🕐", "email": "📧", "error": "❌", "heart": "❤️", "money": "💰", "phone": "📞", "person": "👤", "service": "💇", "sparkle": "✨", "success": "✅", "warning": "⚠️", "calendar": "📅", "greeting": "👋", "location": "📍", "thumbs_up": "👍", "celebration": "🎉"}'::jsonb,
    message_signature text,
    use_time_based_greetings boolean DEFAULT true,
    default_language text DEFAULT 'es'::text,
    date_format text DEFAULT 'DD/MM/YYYY'::text,
    time_format text DEFAULT '12h'::text,
    custom_templates jsonb DEFAULT '{}'::jsonb,
    created_at timestamp with time zone DEFAULT now(),
    updated_at timestamp with time zone DEFAULT now(),
    CONSTRAINT whatsapp_org_config_confirmation_style_check CHECK ((confirmation_style = ANY (ARRAY['minimal'::text, 'detailed'::text, 'elaborate'::text]))),
    CONSTRAINT whatsapp_org_config_default_tone_check CHECK ((default_tone = ANY (ARRAY['formal'::text, 'friendly'::text, 'casual'::text]))),
    CONSTRAINT whatsapp_org_config_greeting_style_check CHECK ((greeting_style = ANY (ARRAY['minimal'::text, 'warm'::text, 'enthusiastic'::text]))),
    CONSTRAINT whatsapp_org_config_time_format_check CHECK ((time_format = ANY (ARRAY['12h'::text, '24h'::text])))
);


--
-- Name: TABLE whatsapp_org_config; Type: COMMENT; Schema: public; Owner: -
--

COMMENT ON TABLE public.whatsapp_org_config IS 'Per-organization WhatsApp styling and UX configuration';


--
-- Name: COLUMN whatsapp_org_config.use_emojis; Type: COMMENT; Schema: public; Owner: -
--

COMMENT ON COLUMN public.whatsapp_org_config.use_emojis IS 'Whether to include emojis in messages';


--
-- Name: COLUMN whatsapp_org_config.use_formatting; Type: COMMENT; Schema: public; Owner: -
--

COMMENT ON COLUMN public.whatsapp_org_config.use_formatting IS 'Whether to use WhatsApp formatting (*bold*, _italic_)';


--
-- Name: COLUMN whatsapp_org_config.emoji_mappings; Type: COMMENT; Schema: public; Owner: -
--

COMMENT ON COLUMN public.whatsapp_org_config.emoji_mappings IS 'Custom emoji overrides for different message contexts';


--
-- Name: whatsapp_response_times; Type: VIEW; Schema: public; Owner: -
--

CREATE VIEW public.whatsapp_response_times AS
 SELECT conv.organization_id,
    date(inbound.sent_at) AS date,
    count(*) AS response_count,
    avg(EXTRACT(epoch FROM (outbound.sent_at - inbound.sent_at))) AS avg_response_seconds,
    percentile_cont((0.5)::double precision) WITHIN GROUP (ORDER BY ((EXTRACT(epoch FROM (outbound.sent_at - inbound.sent_at)))::double precision)) AS median_response_seconds,
    percentile_cont((0.95)::double precision) WITHIN GROUP (ORDER BY ((EXTRACT(epoch FROM (outbound.sent_at - inbound.sent_at)))::double precision)) AS p95_response_seconds
   FROM ((public.whatsapp_messages inbound
     JOIN public.whatsapp_messages outbound ON (((outbound.conversation_id = inbound.conversation_id) AND (outbound.direction = 'outbound'::text) AND (outbound.sent_at > inbound.sent_at) AND (outbound.sent_at <= (inbound.sent_at + '00:05:00'::interval)))))
     JOIN public.whatsapp_conversations conv ON ((conv.id = inbound.conversation_id)))
  WHERE ((inbound.direction = 'inbound'::text) AND (inbound.sent_at >= (CURRENT_DATE - '7 days'::interval)))
  GROUP BY conv.organization_id, (date(inbound.sent_at))
  ORDER BY (date(inbound.sent_at)) DESC;


--
-- Name: VIEW whatsapp_response_times; Type: COMMENT; Schema: public; Owner: -
--

COMMENT ON VIEW public.whatsapp_response_times IS 'Average and percentile response times for WhatsApp messages';


--
-- Name: work_policies; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.work_policies (
    id uuid DEFAULT gen_random_uuid() NOT NULL,
    organization_id uuid NOT NULL,
    name character varying(100) NOT NULL,
    description text,
    policy_type character varying(50) DEFAULT 'standard'::character varying NOT NULL,
    standard_hours_per_week numeric(4,1) DEFAULT 44 NOT NULL,
    max_hours_per_day numeric(4,1) DEFAULT 10 NOT NULL,
    max_hours_per_week numeric(4,1) DEFAULT 60 NOT NULL,
    overtime_rate numeric(4,2) DEFAULT 1.35 NOT NULL,
    overtime_method character varying(50) DEFAULT 'daily'::character varying NOT NULL,
    min_break_minutes integer DEFAULT 60 NOT NULL,
    paid_break boolean DEFAULT false NOT NULL,
    night_shift_premium numeric(4,2) DEFAULT 0.15 NOT NULL,
    night_shift_start character varying(5) DEFAULT '21:00'::character varying NOT NULL,
    night_shift_end character varying(5) DEFAULT '06:00'::character varying NOT NULL,
    max_consecutive_days integer DEFAULT 6 NOT NULL,
    min_rest_hours_between_shifts integer DEFAULT 12 NOT NULL,
    department_ids uuid[] DEFAULT '{}'::uuid[],
    position_ids uuid[] DEFAULT '{}'::uuid[],
    is_default boolean DEFAULT false NOT NULL,
    effective_from date,
    effective_to date,
    is_active boolean DEFAULT true NOT NULL,
    created_at timestamp with time zone DEFAULT now(),
    updated_at timestamp with time zone DEFAULT now()
);


--
-- Name: TABLE work_policies; Type: COMMENT; Schema: public; Owner: -
--

COMMENT ON TABLE public.work_policies IS 'Labor policies for organizations (RD Ley 16-92 compliant)';


--
-- Name: embedding_dead_letter_queue; Type: TABLE; Schema: util; Owner: -
--

CREATE TABLE util.embedding_dead_letter_queue (
    id uuid DEFAULT gen_random_uuid() NOT NULL,
    original_msg_id bigint,
    source_schema text NOT NULL,
    source_table text NOT NULL,
    source_id uuid NOT NULL,
    content_function text NOT NULL,
    embedding_column text NOT NULL,
    error_message text,
    error_code text,
    attempts integer DEFAULT 0 NOT NULL,
    last_attempt_at timestamp with time zone,
    organization_id uuid,
    job_payload jsonb,
    status text DEFAULT 'failed'::text NOT NULL,
    resolved_at timestamp with time zone,
    resolved_by text,
    resolution_notes text,
    created_at timestamp with time zone DEFAULT now() NOT NULL,
    updated_at timestamp with time zone DEFAULT now() NOT NULL,
    CONSTRAINT embedding_dead_letter_queue_status_check CHECK ((status = ANY (ARRAY['failed'::text, 'retrying'::text, 'resolved'::text, 'ignored'::text])))
);


--
-- Name: embedding_job_history; Type: TABLE; Schema: util; Owner: -
--

CREATE TABLE util.embedding_job_history (
    id uuid DEFAULT gen_random_uuid() NOT NULL,
    msg_id bigint,
    source_schema text NOT NULL,
    source_table text NOT NULL,
    source_id uuid NOT NULL,
    status text NOT NULL,
    attempts integer DEFAULT 1 NOT NULL,
    queued_at timestamp with time zone,
    started_at timestamp with time zone,
    completed_at timestamp with time zone DEFAULT now() NOT NULL,
    processing_time_ms integer,
    content_length integer,
    embedding_dimensions integer,
    error_message text,
    error_code text,
    organization_id uuid,
    content_function text,
    model_name text DEFAULT 'text-embedding-3-small'::text,
    created_at timestamp with time zone DEFAULT now() NOT NULL,
    CONSTRAINT embedding_job_history_status_check CHECK ((status = ANY (ARRAY['success'::text, 'failed'::text, 'skipped'::text])))
);


--
-- Name: embedding_metrics_hourly; Type: TABLE; Schema: util; Owner: -
--

CREATE TABLE util.embedding_metrics_hourly (
    id uuid DEFAULT gen_random_uuid() NOT NULL,
    hour timestamp with time zone NOT NULL,
    source_table text NOT NULL,
    organization_id uuid,
    jobs_processed integer DEFAULT 0 NOT NULL,
    jobs_succeeded integer DEFAULT 0 NOT NULL,
    jobs_failed integer DEFAULT 0 NOT NULL,
    jobs_skipped integer DEFAULT 0 NOT NULL,
    total_processing_time_ms bigint DEFAULT 0 NOT NULL,
    avg_processing_time_ms numeric(10,2),
    min_processing_time_ms integer,
    max_processing_time_ms integer,
    p95_processing_time_ms integer,
    total_content_length bigint DEFAULT 0 NOT NULL,
    avg_content_length numeric(10,2),
    created_at timestamp with time zone DEFAULT now() NOT NULL,
    updated_at timestamp with time zone DEFAULT now() NOT NULL
);


--
-- Name: v_embedding_dlq_summary; Type: VIEW; Schema: util; Owner: -
--

CREATE VIEW util.v_embedding_dlq_summary AS
 SELECT source_table,
    count(*) AS failed_jobs,
    count(*) FILTER (WHERE (status = 'failed'::text)) AS pending_resolution,
    count(*) FILTER (WHERE (status = 'retrying'::text)) AS retrying,
    count(*) FILTER (WHERE (status = 'resolved'::text)) AS resolved,
    max(created_at) AS latest_failure,
    min(created_at) AS oldest_failure
   FROM util.embedding_dead_letter_queue
  GROUP BY source_table
  ORDER BY (count(*)) DESC;


--
-- Name: v_embedding_hourly_trend; Type: VIEW; Schema: util; Owner: -
--

CREATE VIEW util.v_embedding_hourly_trend AS
 SELECT hour,
    sum(jobs_processed) AS jobs_processed,
    sum(jobs_succeeded) AS jobs_succeeded,
    sum(jobs_failed) AS jobs_failed,
    round(avg(avg_processing_time_ms), 2) AS avg_processing_time_ms
   FROM util.embedding_metrics_hourly
  WHERE (hour >= (now() - '24:00:00'::interval))
  GROUP BY hour
  ORDER BY hour DESC;


--
-- Name: v_embedding_metrics_24h; Type: VIEW; Schema: util; Owner: -
--

CREATE VIEW util.v_embedding_metrics_24h AS
 SELECT source_table,
    sum(jobs_processed) AS total_processed,
    sum(jobs_succeeded) AS total_succeeded,
    sum(jobs_failed) AS total_failed,
    sum(jobs_skipped) AS total_skipped,
    round(avg(avg_processing_time_ms), 2) AS avg_processing_time_ms,
    min(min_processing_time_ms) AS min_processing_time_ms,
    max(max_processing_time_ms) AS max_processing_time_ms,
    round(((100.0 * (sum(jobs_succeeded))::numeric) / (NULLIF(sum(jobs_processed), 0))::numeric), 2) AS success_rate_pct
   FROM util.embedding_metrics_hourly
  WHERE (hour >= (now() - '24:00:00'::interval))
  GROUP BY source_table
  ORDER BY (sum(jobs_processed)) DESC;


--
-- Name: v_embedding_queue_status; Type: VIEW; Schema: util; Owner: -
--

CREATE VIEW util.v_embedding_queue_status AS
 SELECT ( SELECT count(*) AS count
           FROM pgmq.q_embeddings_jobs) AS pending_jobs,
    ( SELECT count(*) AS count
           FROM pgmq.q_embeddings_jobs
          WHERE (q_embeddings_jobs.vt <= now())) AS ready_to_process,
    ( SELECT count(*) AS count
           FROM pgmq.q_embeddings_jobs
          WHERE (q_embeddings_jobs.read_ct > 0)) AS in_progress,
    ( SELECT count(*) AS count
           FROM util.embedding_dead_letter_queue
          WHERE (embedding_dead_letter_queue.status = 'failed'::text)) AS failed_in_dlq,
    ( SELECT max(q_embeddings_jobs.enqueued_at) AS max
           FROM pgmq.q_embeddings_jobs) AS newest_job_at,
    ( SELECT min(q_embeddings_jobs.enqueued_at) AS min
           FROM pgmq.q_embeddings_jobs) AS oldest_job_at;


--
-- Name: _migrations id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY public._migrations ALTER COLUMN id SET DEFAULT nextval('public._migrations_id_seq'::regclass);


--
-- Name: a_embedding_jobs a_embedding_jobs_pkey; Type: CONSTRAINT; Schema: pgmq; Owner: -
--

ALTER TABLE ONLY pgmq.a_embedding_jobs
    ADD CONSTRAINT a_embedding_jobs_pkey PRIMARY KEY (msg_id);


--
-- Name: a_embeddings_jobs a_embeddings_jobs_pkey; Type: CONSTRAINT; Schema: pgmq; Owner: -
--

ALTER TABLE ONLY pgmq.a_embeddings_jobs
    ADD CONSTRAINT a_embeddings_jobs_pkey PRIMARY KEY (msg_id);


--
-- Name: q_embedding_jobs q_embedding_jobs_pkey; Type: CONSTRAINT; Schema: pgmq; Owner: -
--

ALTER TABLE ONLY pgmq.q_embedding_jobs
    ADD CONSTRAINT q_embedding_jobs_pkey PRIMARY KEY (msg_id);


--
-- Name: q_embeddings_jobs q_embeddings_jobs_pkey; Type: CONSTRAINT; Schema: pgmq; Owner: -
--

ALTER TABLE ONLY pgmq.q_embeddings_jobs
    ADD CONSTRAINT q_embeddings_jobs_pkey PRIMARY KEY (msg_id);


--
-- Name: _migrations _migrations_name_key; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public._migrations
    ADD CONSTRAINT _migrations_name_key UNIQUE (name);


--
-- Name: _migrations _migrations_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public._migrations
    ADD CONSTRAINT _migrations_pkey PRIMARY KEY (id);


--
-- Name: ai_cache ai_cache_cache_key_key; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.ai_cache
    ADD CONSTRAINT ai_cache_cache_key_key UNIQUE (cache_key);


--
-- Name: ai_cache ai_cache_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.ai_cache
    ADD CONSTRAINT ai_cache_pkey PRIMARY KEY (id);


--
-- Name: ai_conversations ai_conversations_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.ai_conversations
    ADD CONSTRAINT ai_conversations_pkey PRIMARY KEY (id);


--
-- Name: ai_embedding_configs ai_embedding_configs_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.ai_embedding_configs
    ADD CONSTRAINT ai_embedding_configs_pkey PRIMARY KEY (id);


--
-- Name: ai_embedding_configs ai_embedding_configs_table_schema_table_name_key; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.ai_embedding_configs
    ADD CONSTRAINT ai_embedding_configs_table_schema_table_name_key UNIQUE (table_schema, table_name);


--
-- Name: ai_embedding_queue ai_embedding_queue_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.ai_embedding_queue
    ADD CONSTRAINT ai_embedding_queue_pkey PRIMARY KEY (id);


--
-- Name: ai_embedding_queue ai_embedding_queue_source_unique; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.ai_embedding_queue
    ADD CONSTRAINT ai_embedding_queue_source_unique UNIQUE (source_table, source_id, organization_id);


--
-- Name: ai_embeddings ai_embeddings_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.ai_embeddings
    ADD CONSTRAINT ai_embeddings_pkey PRIMARY KEY (id);


--
-- Name: ai_embeddings ai_embeddings_source_unique; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.ai_embeddings
    ADD CONSTRAINT ai_embeddings_source_unique UNIQUE (source_table, source_id, content_type, organization_id);


--
-- Name: ai_interactions ai_interactions_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.ai_interactions
    ADD CONSTRAINT ai_interactions_pkey PRIMARY KEY (id);


--
-- Name: ai_search_logs ai_search_logs_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.ai_search_logs
    ADD CONSTRAINT ai_search_logs_pkey PRIMARY KEY (id);


--
-- Name: ai_skill_executions ai_skill_executions_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.ai_skill_executions
    ADD CONSTRAINT ai_skill_executions_pkey PRIMARY KEY (id);


--
-- Name: ai_skills ai_skills_name_key; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.ai_skills
    ADD CONSTRAINT ai_skills_name_key UNIQUE (name);


--
-- Name: ai_skills ai_skills_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.ai_skills
    ADD CONSTRAINT ai_skills_pkey PRIMARY KEY (id);


--
-- Name: ai_usage ai_usage_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.ai_usage
    ADD CONSTRAINT ai_usage_pkey PRIMARY KEY (id);


--
-- Name: appointment_audit_log appointment_audit_log_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.appointment_audit_log
    ADD CONSTRAINT appointment_audit_log_pkey PRIMARY KEY (id);


--
-- Name: appointment_resources appointment_resources_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.appointment_resources
    ADD CONSTRAINT appointment_resources_pkey PRIMARY KEY (id);


--
-- Name: appointments appointments_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.appointments
    ADD CONSTRAINT appointments_pkey PRIMARY KEY (id);


--
-- Name: attribute_definitions attribute_definitions_code_unique; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.attribute_definitions
    ADD CONSTRAINT attribute_definitions_code_unique UNIQUE NULLS NOT DISTINCT (organization_id, attribute_code);


--
-- Name: attribute_definitions attribute_definitions_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.attribute_definitions
    ADD CONSTRAINT attribute_definitions_pkey PRIMARY KEY (id);


--
-- Name: audit_logs audit_logs_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.audit_logs
    ADD CONSTRAINT audit_logs_pkey PRIMARY KEY (id);


--
-- Name: booking_configurations booking_configurations_organization_id_key; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.booking_configurations
    ADD CONSTRAINT booking_configurations_organization_id_key UNIQUE (organization_id);


--
-- Name: booking_configurations booking_configurations_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.booking_configurations
    ADD CONSTRAINT booking_configurations_pkey PRIMARY KEY (id);


--
-- Name: booking_sessions booking_sessions_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.booking_sessions
    ADD CONSTRAINT booking_sessions_pkey PRIMARY KEY (id);


--
-- Name: bot_messages bot_messages_organization_id_category_message_key_channel_l_key; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.bot_messages
    ADD CONSTRAINT bot_messages_organization_id_category_message_key_channel_l_key UNIQUE (organization_id, category, message_key, channel, language);


--
-- Name: bot_messages bot_messages_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.bot_messages
    ADD CONSTRAINT bot_messages_pkey PRIMARY KEY (id);


--
-- Name: business_hours business_hours_organization_id_day_of_week_key; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.business_hours
    ADD CONSTRAINT business_hours_organization_id_day_of_week_key UNIQUE (organization_id, day_of_week);


--
-- Name: business_hours business_hours_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.business_hours
    ADD CONSTRAINT business_hours_pkey PRIMARY KEY (id);


--
-- Name: calendar_connections calendar_connections_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.calendar_connections
    ADD CONSTRAINT calendar_connections_pkey PRIMARY KEY (id);


--
-- Name: calendar_connections calendar_connections_unique; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.calendar_connections
    ADD CONSTRAINT calendar_connections_unique UNIQUE (user_id, provider, calendar_id);


--
-- Name: catalog_categories catalog_categories_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.catalog_categories
    ADD CONSTRAINT catalog_categories_pkey PRIMARY KEY (id);


--
-- Name: catalog_categories catalog_categories_slug_org_unique; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.catalog_categories
    ADD CONSTRAINT catalog_categories_slug_org_unique UNIQUE (organization_id, slug);


--
-- Name: catalog_item_types catalog_item_types_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.catalog_item_types
    ADD CONSTRAINT catalog_item_types_pkey PRIMARY KEY (code);


--
-- Name: catalog_items catalog_items_code_org_unique; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.catalog_items
    ADD CONSTRAINT catalog_items_code_org_unique UNIQUE (organization_id, item_code);


--
-- Name: catalog_items catalog_items_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.catalog_items
    ADD CONSTRAINT catalog_items_pkey PRIMARY KEY (id);


--
-- Name: catalog_tracking_types catalog_tracking_types_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.catalog_tracking_types
    ADD CONSTRAINT catalog_tracking_types_pkey PRIMARY KEY (code);


--
-- Name: clients clients_code_org_unique; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.clients
    ADD CONSTRAINT clients_code_org_unique UNIQUE (organization_id, client_code);


--
-- Name: clients clients_entity_unique; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.clients
    ADD CONSTRAINT clients_entity_unique UNIQUE (entity_id);


--
-- Name: clients clients_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.clients
    ADD CONSTRAINT clients_pkey PRIMARY KEY (id);


--
-- Name: conversation_flow_runtime conversation_flow_runtime_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.conversation_flow_runtime
    ADD CONSTRAINT conversation_flow_runtime_pkey PRIMARY KEY (id);


--
-- Name: conversation_flow_states conversation_flow_states_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.conversation_flow_states
    ADD CONSTRAINT conversation_flow_states_pkey PRIMARY KEY (id);


--
-- Name: conversation_flows conversation_flows_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.conversation_flows
    ADD CONSTRAINT conversation_flows_pkey PRIMARY KEY (id);


--
-- Name: conversation_memory conversation_memory_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.conversation_memory
    ADD CONSTRAINT conversation_memory_pkey PRIMARY KEY (id);


--
-- Name: conversation_sessions conversation_sessions_organization_id_channel_channel_user__key; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.conversation_sessions
    ADD CONSTRAINT conversation_sessions_organization_id_channel_channel_user__key UNIQUE (organization_id, channel, channel_user_id, status);


--
-- Name: conversation_sessions conversation_sessions_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.conversation_sessions
    ADD CONSTRAINT conversation_sessions_pkey PRIMARY KEY (id);


--
-- Name: daily_time_summary daily_time_summary_employee_id_summary_date_key; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.daily_time_summary
    ADD CONSTRAINT daily_time_summary_employee_id_summary_date_key UNIQUE (employee_id, summary_date);


--
-- Name: daily_time_summary daily_time_summary_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.daily_time_summary
    ADD CONSTRAINT daily_time_summary_pkey PRIMARY KEY (id);


--
-- Name: departments departments_organization_id_code_key; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.departments
    ADD CONSTRAINT departments_organization_id_code_key UNIQUE (organization_id, code);


--
-- Name: departments departments_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.departments
    ADD CONSTRAINT departments_pkey PRIMARY KEY (id);


--
-- Name: employees employees_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.employees
    ADD CONSTRAINT employees_pkey PRIMARY KEY (id);


--
-- Name: entities entities_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.entities
    ADD CONSTRAINT entities_pkey PRIMARY KEY (id);


--
-- Name: entity_ai_cold entity_ai_cold_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.entity_ai_cold
    ADD CONSTRAINT entity_ai_cold_pkey PRIMARY KEY (id);


--
-- Name: entity_ai_hot entity_ai_hot_entity_id_key; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.entity_ai_hot
    ADD CONSTRAINT entity_ai_hot_entity_id_key UNIQUE (entity_id);


--
-- Name: entity_ai_hot entity_ai_hot_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.entity_ai_hot
    ADD CONSTRAINT entity_ai_hot_pkey PRIMARY KEY (id);


--
-- Name: entity_ai_traits entity_ai_traits_entity_id_key; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.entity_ai_traits
    ADD CONSTRAINT entity_ai_traits_entity_id_key UNIQUE (entity_id);


--
-- Name: entity_ai_traits entity_ai_traits_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.entity_ai_traits
    ADD CONSTRAINT entity_ai_traits_pkey PRIMARY KEY (id);


--
-- Name: entity_identification_documents entity_identification_documents_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.entity_identification_documents
    ADD CONSTRAINT entity_identification_documents_pkey PRIMARY KEY (id);


--
-- Name: entity_insurance_policies entity_insurance_policies_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.entity_insurance_policies
    ADD CONSTRAINT entity_insurance_policies_pkey PRIMARY KEY (id);


--
-- Name: entity_memory entity_memory_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.entity_memory
    ADD CONSTRAINT entity_memory_pkey PRIMARY KEY (id);


--
-- Name: entity_metrics_cache entity_metrics_cache_entity_id_key; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.entity_metrics_cache
    ADD CONSTRAINT entity_metrics_cache_entity_id_key UNIQUE (entity_id);


--
-- Name: entity_metrics_cache entity_metrics_cache_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.entity_metrics_cache
    ADD CONSTRAINT entity_metrics_cache_pkey PRIMARY KEY (id);


--
-- Name: entity_relationships entity_relationships_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.entity_relationships
    ADD CONSTRAINT entity_relationships_pkey PRIMARY KEY (id);


--
-- Name: entity_relationships entity_relationships_unique; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.entity_relationships
    ADD CONSTRAINT entity_relationships_unique UNIQUE (organization_id, source_entity_id, target_entity_id, relationship_type, valid_from);


--
-- Name: entity_synonyms entity_synonyms_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.entity_synonyms
    ADD CONSTRAINT entity_synonyms_pkey PRIMARY KEY (id);


--
-- Name: external_calendar_events external_calendar_events_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.external_calendar_events
    ADD CONSTRAINT external_calendar_events_pkey PRIMARY KEY (id);


--
-- Name: external_calendar_events external_events_unique; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.external_calendar_events
    ADD CONSTRAINT external_events_unique UNIQUE (connection_id, external_id);


--
-- Name: identification_document_types identification_document_types_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.identification_document_types
    ADD CONSTRAINT identification_document_types_pkey PRIMARY KEY (id);


--
-- Name: conversation_flow_states idx_flow_states_conversation; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.conversation_flow_states
    ADD CONSTRAINT idx_flow_states_conversation UNIQUE (conversation_id, flow_id, status);


--
-- Name: insurance_providers insurance_providers_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.insurance_providers
    ADD CONSTRAINT insurance_providers_pkey PRIMARY KEY (id);


--
-- Name: inventory inventory_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.inventory
    ADD CONSTRAINT inventory_pkey PRIMARY KEY (id);


--
-- Name: invites invites_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.invites
    ADD CONSTRAINT invites_pkey PRIMARY KEY (id);


--
-- Name: invites invites_token_key; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.invites
    ADD CONSTRAINT invites_token_key UNIQUE (token);


--
-- Name: item_attributes item_attributes_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.item_attributes
    ADD CONSTRAINT item_attributes_pkey PRIMARY KEY (id);


--
-- Name: item_attributes item_attributes_unique; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.item_attributes
    ADD CONSTRAINT item_attributes_unique UNIQUE (item_id, attribute_id);


--
-- Name: item_providers item_providers_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.item_providers
    ADD CONSTRAINT item_providers_pkey PRIMARY KEY (id);


--
-- Name: item_providers item_providers_unique; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.item_providers
    ADD CONSTRAINT item_providers_unique UNIQUE (item_id, provider_entity_id);


--
-- Name: item_skill_requirements item_skill_requirements_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.item_skill_requirements
    ADD CONSTRAINT item_skill_requirements_pkey PRIMARY KEY (id);


--
-- Name: item_skill_requirements item_skill_requirements_unique; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.item_skill_requirements
    ADD CONSTRAINT item_skill_requirements_unique UNIQUE (item_id, skill_id);


--
-- Name: jobs jobs_organization_id_code_key; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.jobs
    ADD CONSTRAINT jobs_organization_id_code_key UNIQUE (organization_id, code);


--
-- Name: jobs jobs_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.jobs
    ADD CONSTRAINT jobs_pkey PRIMARY KEY (id);


--
-- Name: leave_balances leave_balances_employee_id_leave_type_id_year_key; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.leave_balances
    ADD CONSTRAINT leave_balances_employee_id_leave_type_id_year_key UNIQUE (employee_id, leave_type_id, year);


--
-- Name: leave_balances leave_balances_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.leave_balances
    ADD CONSTRAINT leave_balances_pkey PRIMARY KEY (id);


--
-- Name: leave_requests leave_requests_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.leave_requests
    ADD CONSTRAINT leave_requests_pkey PRIMARY KEY (id);


--
-- Name: leave_types leave_types_organization_id_code_key; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.leave_types
    ADD CONSTRAINT leave_types_organization_id_code_key UNIQUE (organization_id, code);


--
-- Name: leave_types leave_types_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.leave_types
    ADD CONSTRAINT leave_types_pkey PRIMARY KEY (id);


--
-- Name: llm_prompts llm_prompts_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.llm_prompts
    ADD CONSTRAINT llm_prompts_pkey PRIMARY KEY (id);


--
-- Name: memberships memberships_organization_id_user_id_key; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.memberships
    ADD CONSTRAINT memberships_organization_id_user_id_key UNIQUE (organization_id, user_id);


--
-- Name: memberships memberships_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.memberships
    ADD CONSTRAINT memberships_pkey PRIMARY KEY (id);


--
-- Name: nlu_entity_synonyms nlu_entity_synonyms_organization_id_entity_type_synonym_key; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.nlu_entity_synonyms
    ADD CONSTRAINT nlu_entity_synonyms_organization_id_entity_type_synonym_key UNIQUE (organization_id, entity_type, synonym);


--
-- Name: nlu_entity_synonyms nlu_entity_synonyms_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.nlu_entity_synonyms
    ADD CONSTRAINT nlu_entity_synonyms_pkey PRIMARY KEY (id);


--
-- Name: nlu_heuristic_rules nlu_heuristic_rules_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.nlu_heuristic_rules
    ADD CONSTRAINT nlu_heuristic_rules_pkey PRIMARY KEY (id);


--
-- Name: nlu_intent_examples nlu_intent_examples_organization_id_intent_example_text_key; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.nlu_intent_examples
    ADD CONSTRAINT nlu_intent_examples_organization_id_intent_example_text_key UNIQUE (organization_id, intent, example_text);


--
-- Name: nlu_intent_examples nlu_intent_examples_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.nlu_intent_examples
    ADD CONSTRAINT nlu_intent_examples_pkey PRIMARY KEY (id);


--
-- Name: nlu_intent_signals nlu_intent_signals_organization_id_intent_signal_type_signa_key; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.nlu_intent_signals
    ADD CONSTRAINT nlu_intent_signals_organization_id_intent_signal_type_signa_key UNIQUE (organization_id, intent, signal_type, signal_value);


--
-- Name: nlu_intent_signals nlu_intent_signals_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.nlu_intent_signals
    ADD CONSTRAINT nlu_intent_signals_pkey PRIMARY KEY (id);


--
-- Name: nlu_keywords nlu_keywords_organization_id_category_keyword_key; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.nlu_keywords
    ADD CONSTRAINT nlu_keywords_organization_id_category_keyword_key UNIQUE (organization_id, category, keyword);


--
-- Name: nlu_keywords nlu_keywords_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.nlu_keywords
    ADD CONSTRAINT nlu_keywords_pkey PRIMARY KEY (id);


--
-- Name: nlu_training_logs nlu_training_logs_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.nlu_training_logs
    ADD CONSTRAINT nlu_training_logs_pkey PRIMARY KEY (id);


--
-- Name: nlu_typo_corrections nlu_typo_corrections_organization_id_category_typo_key; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.nlu_typo_corrections
    ADD CONSTRAINT nlu_typo_corrections_organization_id_category_typo_key UNIQUE (organization_id, category, typo);


--
-- Name: nlu_typo_corrections nlu_typo_corrections_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.nlu_typo_corrections
    ADD CONSTRAINT nlu_typo_corrections_pkey PRIMARY KEY (id);


--
-- Name: notification_queue notification_queue_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.notification_queue
    ADD CONSTRAINT notification_queue_pkey PRIMARY KEY (id);


--
-- Name: orders orders_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.orders
    ADD CONSTRAINT orders_pkey PRIMARY KEY (id);


--
-- Name: org_knowledge_base org_knowledge_base_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.org_knowledge_base
    ADD CONSTRAINT org_knowledge_base_pkey PRIMARY KEY (id);


--
-- Name: organization_configs organization_configs_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.organization_configs
    ADD CONSTRAINT organization_configs_pkey PRIMARY KEY (organization_id, config_key);


--
-- Name: organization_policies organization_policies_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.organization_policies
    ADD CONSTRAINT organization_policies_pkey PRIMARY KEY (id);


--
-- Name: organization_policies organization_policies_unique; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.organization_policies
    ADD CONSTRAINT organization_policies_unique UNIQUE (organization_id);


--
-- Name: organization_verticals organization_verticals_code_key; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.organization_verticals
    ADD CONSTRAINT organization_verticals_code_key UNIQUE (code);


--
-- Name: organization_verticals organization_verticals_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.organization_verticals
    ADD CONSTRAINT organization_verticals_pkey PRIMARY KEY (id);


--
-- Name: organizations organizations_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.organizations
    ADD CONSTRAINT organizations_pkey PRIMARY KEY (id);


--
-- Name: organizations organizations_tax_id_key; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.organizations
    ADD CONSTRAINT organizations_tax_id_key UNIQUE (tax_id);


--
-- Name: patient_code_sequences patient_code_sequences_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.patient_code_sequences
    ADD CONSTRAINT patient_code_sequences_pkey PRIMARY KEY (organization_id);


--
-- Name: patient_notes patient_notes_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.patient_notes
    ADD CONSTRAINT patient_notes_pkey PRIMARY KEY (id);


--
-- Name: patients patients_entity_id_key; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.patients
    ADD CONSTRAINT patients_entity_id_key UNIQUE (entity_id);


--
-- Name: patients patients_mrn_unique; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.patients
    ADD CONSTRAINT patients_mrn_unique UNIQUE (organization_id, medical_record_number);


--
-- Name: patients patients_patient_code_unique; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.patients
    ADD CONSTRAINT patients_patient_code_unique UNIQUE (organization_id, patient_code);


--
-- Name: patients patients_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.patients
    ADD CONSTRAINT patients_pkey PRIMARY KEY (id);


--
-- Name: positions positions_organization_id_code_key; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.positions
    ADD CONSTRAINT positions_organization_id_code_key UNIQUE (organization_id, code);


--
-- Name: positions positions_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.positions
    ADD CONSTRAINT positions_pkey PRIMARY KEY (id);


--
-- Name: products products_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.products
    ADD CONSTRAINT products_pkey PRIMARY KEY (id);


--
-- Name: profiles profiles_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.profiles
    ADD CONSTRAINT profiles_pkey PRIMARY KEY (user_id);


--
-- Name: promotion_analytics promotion_analytics_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.promotion_analytics
    ADD CONSTRAINT promotion_analytics_pkey PRIMARY KEY (id);


--
-- Name: promotion_analytics promotion_analytics_promotion_id_date_key; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.promotion_analytics
    ADD CONSTRAINT promotion_analytics_promotion_id_date_key UNIQUE (promotion_id, date);


--
-- Name: promotion_bundle_items promotion_bundle_items_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.promotion_bundle_items
    ADD CONSTRAINT promotion_bundle_items_pkey PRIMARY KEY (id);


--
-- Name: promotion_bundle_items promotion_bundle_items_promotion_id_catalog_item_id_key; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.promotion_bundle_items
    ADD CONSTRAINT promotion_bundle_items_promotion_id_catalog_item_id_key UNIQUE (promotion_id, catalog_item_id);


--
-- Name: promotion_rule_items promotion_rule_items_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.promotion_rule_items
    ADD CONSTRAINT promotion_rule_items_pkey PRIMARY KEY (rule_id, catalog_item_id);


--
-- Name: promotion_rules promotion_rules_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.promotion_rules
    ADD CONSTRAINT promotion_rules_pkey PRIMARY KEY (id);


--
-- Name: promotion_tiers promotion_tiers_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.promotion_tiers
    ADD CONSTRAINT promotion_tiers_pkey PRIMARY KEY (id);


--
-- Name: promotions promotions_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.promotions
    ADD CONSTRAINT promotions_pkey PRIMARY KEY (id);


--
-- Name: provider_schedule_exceptions provider_schedule_exceptions_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.provider_schedule_exceptions
    ADD CONSTRAINT provider_schedule_exceptions_pkey PRIMARY KEY (id);


--
-- Name: provider_schedules provider_schedules_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.provider_schedules
    ADD CONSTRAINT provider_schedules_pkey PRIMARY KEY (id);


--
-- Name: provider_skills provider_skills_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.provider_skills
    ADD CONSTRAINT provider_skills_pkey PRIMARY KEY (id);


--
-- Name: provider_skills provider_skills_unique; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.provider_skills
    ADD CONSTRAINT provider_skills_unique UNIQUE (provider_entity_id, skill_id);


--
-- Name: resource_availability resource_availability_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.resource_availability
    ADD CONSTRAINT resource_availability_pkey PRIMARY KEY (id);


--
-- Name: resource_capabilities resource_capabilities_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.resource_capabilities
    ADD CONSTRAINT resource_capabilities_pkey PRIMARY KEY (id);


--
-- Name: resource_capability_availability resource_capability_availability_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.resource_capability_availability
    ADD CONSTRAINT resource_capability_availability_pkey PRIMARY KEY (id);


--
-- Name: resource_unavailability resource_unavailability_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.resource_unavailability
    ADD CONSTRAINT resource_unavailability_pkey PRIMARY KEY (id);


--
-- Name: roles roles_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.roles
    ADD CONSTRAINT roles_pkey PRIMARY KEY (key);


--
-- Name: scheduled_shifts scheduled_shifts_employee_id_shift_date_start_time_key; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.scheduled_shifts
    ADD CONSTRAINT scheduled_shifts_employee_id_shift_date_start_time_key UNIQUE (employee_id, shift_date, start_time);


--
-- Name: scheduled_shifts scheduled_shifts_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.scheduled_shifts
    ADD CONSTRAINT scheduled_shifts_pkey PRIMARY KEY (id);


--
-- Name: service_providers service_providers_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.service_providers
    ADD CONSTRAINT service_providers_pkey PRIMARY KEY (id);


--
-- Name: services services_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.services
    ADD CONSTRAINT services_pkey PRIMARY KEY (id);


--
-- Name: shift_templates shift_templates_organization_id_code_key; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.shift_templates
    ADD CONSTRAINT shift_templates_organization_id_code_key UNIQUE (organization_id, code);


--
-- Name: shift_templates shift_templates_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.shift_templates
    ADD CONSTRAINT shift_templates_pkey PRIMARY KEY (id);


--
-- Name: skill_access skill_access_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.skill_access
    ADD CONSTRAINT skill_access_pkey PRIMARY KEY (id);


--
-- Name: skill_access skill_access_role_key_skill_id_key; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.skill_access
    ADD CONSTRAINT skill_access_role_key_skill_id_key UNIQUE (role_key, skill_id);


--
-- Name: skill_definitions skill_definitions_code_unique; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.skill_definitions
    ADD CONSTRAINT skill_definitions_code_unique UNIQUE NULLS NOT DISTINCT (organization_id, skill_code);


--
-- Name: skill_definitions skill_definitions_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.skill_definitions
    ADD CONSTRAINT skill_definitions_pkey PRIMARY KEY (id);


--
-- Name: subscription_plans subscription_plans_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.subscription_plans
    ADD CONSTRAINT subscription_plans_pkey PRIMARY KEY (key);


--
-- Name: subscriptions subscriptions_org_unique; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.subscriptions
    ADD CONSTRAINT subscriptions_org_unique UNIQUE (organization_id);


--
-- Name: subscriptions subscriptions_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.subscriptions
    ADD CONSTRAINT subscriptions_pkey PRIMARY KEY (id);


--
-- Name: time_entries time_entries_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.time_entries
    ADD CONSTRAINT time_entries_pkey PRIMARY KEY (id);


--
-- Name: time_entry_modifications time_entry_modifications_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.time_entry_modifications
    ADD CONSTRAINT time_entry_modifications_pkey PRIMARY KEY (id);


--
-- Name: whatsapp_conversations unique_active_phone_org; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.whatsapp_conversations
    ADD CONSTRAINT unique_active_phone_org UNIQUE (phone_number, organization_id, conversation_state);


--
-- Name: conversation_flows unique_flow_per_scope; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.conversation_flows
    ADD CONSTRAINT unique_flow_per_scope UNIQUE NULLS NOT DISTINCT (organization_id, flow_name, vertical_code, channel, language);


--
-- Name: roles unique_org_role; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.roles
    ADD CONSTRAINT unique_org_role UNIQUE (organization_id, key);


--
-- Name: llm_prompts unique_prompt_key_per_scope; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.llm_prompts
    ADD CONSTRAINT unique_prompt_key_per_scope UNIQUE NULLS NOT DISTINCT (organization_id, prompt_key, vertical_code, channel, language);


--
-- Name: whatsapp_messages unique_provider_message_id; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.whatsapp_messages
    ADD CONSTRAINT unique_provider_message_id UNIQUE (provider_message_id);


--
-- Name: nlu_heuristic_rules unique_rule_name_per_org; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.nlu_heuristic_rules
    ADD CONSTRAINT unique_rule_name_per_org UNIQUE (rule_name, organization_id);


--
-- Name: entity_synonyms unique_synonym_per_scope; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.entity_synonyms
    ADD CONSTRAINT unique_synonym_per_scope UNIQUE NULLS NOT DISTINCT (organization_id, entity_type, synonym, vertical_code, channel, language);


--
-- Name: waitlist_configurations unique_waitlist_config; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.waitlist_configurations
    ADD CONSTRAINT unique_waitlist_config UNIQUE NULLS NOT DISTINCT (organization_id, location_id);


--
-- Name: walkin_configurations unique_walkin_config; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.walkin_configurations
    ADD CONSTRAINT unique_walkin_config UNIQUE NULLS NOT DISTINCT (organization_id, location_id);


--
-- Name: resource_capabilities uq_capability; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.resource_capabilities
    ADD CONSTRAINT uq_capability UNIQUE (organization_id, resource_entity_id, catalog_item_id, valid_from);


--
-- Name: employees uq_employee_code_org; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.employees
    ADD CONSTRAINT uq_employee_code_org UNIQUE (organization_id, employee_code);


--
-- Name: entities uq_entity_code_org; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.entities
    ADD CONSTRAINT uq_entity_code_org UNIQUE (organization_id, entity_code);


--
-- Name: insurance_providers uq_insurance_provider_code_org; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.insurance_providers
    ADD CONSTRAINT uq_insurance_provider_code_org UNIQUE (organization_id, provider_code);


--
-- Name: insurance_providers uq_insurance_provider_entity; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.insurance_providers
    ADD CONSTRAINT uq_insurance_provider_entity UNIQUE (entity_id);


--
-- Name: entity_identification_documents uq_org_document_normalized; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.entity_identification_documents
    ADD CONSTRAINT uq_org_document_normalized UNIQUE (organization_id, document_number_normalized);


--
-- Name: entity_insurance_policies uq_org_provider_policy; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.entity_insurance_policies
    ADD CONSTRAINT uq_org_provider_policy UNIQUE (organization_id, provider_code, policy_number_normalized);


--
-- Name: services uq_service_code_org; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.services
    ADD CONSTRAINT uq_service_code_org UNIQUE (organization_id, service_code);


--
-- Name: service_providers uq_service_provider; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.service_providers
    ADD CONSTRAINT uq_service_provider UNIQUE (service_id, provider_entity_id);


--
-- Name: user_roles user_roles_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.user_roles
    ADD CONSTRAINT user_roles_pkey PRIMARY KEY (id);


--
-- Name: user_roles user_roles_user_id_role_key_key; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.user_roles
    ADD CONSTRAINT user_roles_user_id_role_key_key UNIQUE (user_id, role_key);


--
-- Name: user_sessions user_sessions_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.user_sessions
    ADD CONSTRAINT user_sessions_pkey PRIMARY KEY (user_id);


--
-- Name: vertical_configs vertical_configs_organization_id_vertical_language_key; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.vertical_configs
    ADD CONSTRAINT vertical_configs_organization_id_vertical_language_key UNIQUE (organization_id, vertical, language);


--
-- Name: vertical_configs vertical_configs_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.vertical_configs
    ADD CONSTRAINT vertical_configs_pkey PRIMARY KEY (id);


--
-- Name: waitlist_configurations waitlist_configurations_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.waitlist_configurations
    ADD CONSTRAINT waitlist_configurations_pkey PRIMARY KEY (id);


--
-- Name: waitlist_entries waitlist_entries_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.waitlist_entries
    ADD CONSTRAINT waitlist_entries_pkey PRIMARY KEY (id);


--
-- Name: walkin_configurations walkin_configurations_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.walkin_configurations
    ADD CONSTRAINT walkin_configurations_pkey PRIMARY KEY (id);


--
-- Name: walkin_entries walkin_entries_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.walkin_entries
    ADD CONSTRAINT walkin_entries_pkey PRIMARY KEY (id);


--
-- Name: whatsapp_conversations whatsapp_conversations_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.whatsapp_conversations
    ADD CONSTRAINT whatsapp_conversations_pkey PRIMARY KEY (id);


--
-- Name: whatsapp_messages whatsapp_messages_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.whatsapp_messages
    ADD CONSTRAINT whatsapp_messages_pkey PRIMARY KEY (id);


--
-- Name: whatsapp_org_config whatsapp_org_config_organization_id_key; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.whatsapp_org_config
    ADD CONSTRAINT whatsapp_org_config_organization_id_key UNIQUE (organization_id);


--
-- Name: whatsapp_org_config whatsapp_org_config_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.whatsapp_org_config
    ADD CONSTRAINT whatsapp_org_config_pkey PRIMARY KEY (id);


--
-- Name: work_policies work_policies_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.work_policies
    ADD CONSTRAINT work_policies_pkey PRIMARY KEY (id);


--
-- Name: embedding_dead_letter_queue embedding_dead_letter_queue_pkey; Type: CONSTRAINT; Schema: util; Owner: -
--

ALTER TABLE ONLY util.embedding_dead_letter_queue
    ADD CONSTRAINT embedding_dead_letter_queue_pkey PRIMARY KEY (id);


--
-- Name: embedding_job_history embedding_job_history_pkey; Type: CONSTRAINT; Schema: util; Owner: -
--

ALTER TABLE ONLY util.embedding_job_history
    ADD CONSTRAINT embedding_job_history_pkey PRIMARY KEY (id);


--
-- Name: embedding_metrics_hourly embedding_metrics_hourly_hour_source_table_organization_id_key; Type: CONSTRAINT; Schema: util; Owner: -
--

ALTER TABLE ONLY util.embedding_metrics_hourly
    ADD CONSTRAINT embedding_metrics_hourly_hour_source_table_organization_id_key UNIQUE (hour, source_table, organization_id);


--
-- Name: embedding_metrics_hourly embedding_metrics_hourly_pkey; Type: CONSTRAINT; Schema: util; Owner: -
--

ALTER TABLE ONLY util.embedding_metrics_hourly
    ADD CONSTRAINT embedding_metrics_hourly_pkey PRIMARY KEY (id);


--
-- Name: archived_at_idx_embedding_jobs; Type: INDEX; Schema: pgmq; Owner: -
--

CREATE INDEX archived_at_idx_embedding_jobs ON pgmq.a_embedding_jobs USING btree (archived_at);


--
-- Name: archived_at_idx_embeddings_jobs; Type: INDEX; Schema: pgmq; Owner: -
--

CREATE INDEX archived_at_idx_embeddings_jobs ON pgmq.a_embeddings_jobs USING btree (archived_at);


--
-- Name: q_embedding_jobs_vt_idx; Type: INDEX; Schema: pgmq; Owner: -
--

CREATE INDEX q_embedding_jobs_vt_idx ON pgmq.q_embedding_jobs USING btree (vt);


--
-- Name: q_embeddings_jobs_vt_idx; Type: INDEX; Schema: pgmq; Owner: -
--

CREATE INDEX q_embeddings_jobs_vt_idx ON pgmq.q_embeddings_jobs USING btree (vt);


--
-- Name: employees_embedding_idx; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX employees_embedding_idx ON public.employees USING ivfflat (embedding extensions.vector_cosine_ops) WITH (lists='100') WHERE (embedding IS NOT NULL);


--
-- Name: entities_embedding_idx; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX entities_embedding_idx ON public.entities USING ivfflat (embedding extensions.vector_cosine_ops) WITH (lists='100') WHERE (embedding IS NOT NULL);


--
-- Name: idx_ai_cache_expires; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX idx_ai_cache_expires ON public.ai_cache USING btree (expires_at) WHERE (expires_at IS NOT NULL);


--
-- Name: idx_ai_cache_key; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX idx_ai_cache_key ON public.ai_cache USING btree (cache_key);


--
-- Name: idx_ai_cache_org; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX idx_ai_cache_org ON public.ai_cache USING btree (organization_id, last_accessed_at DESC);


--
-- Name: idx_ai_conversations_channel; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX idx_ai_conversations_channel ON public.ai_conversations USING btree (channel, organization_id, status);


--
-- Name: idx_ai_conversations_context; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX idx_ai_conversations_context ON public.ai_conversations USING btree (context_type, status);


--
-- Name: idx_ai_conversations_org; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX idx_ai_conversations_org ON public.ai_conversations USING btree (organization_id, status);


--
-- Name: idx_ai_conversations_phone; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX idx_ai_conversations_phone ON public.ai_conversations USING btree (phone_number, organization_id) WHERE (phone_number IS NOT NULL);


--
-- Name: idx_ai_conversations_session; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX idx_ai_conversations_session ON public.ai_conversations USING btree (session_id) WHERE (session_id IS NOT NULL);


--
-- Name: idx_ai_conversations_user; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX idx_ai_conversations_user ON public.ai_conversations USING btree (user_id, last_message_at DESC);


--
-- Name: idx_ai_embedding_queue_org; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX idx_ai_embedding_queue_org ON public.ai_embedding_queue USING btree (organization_id);


--
-- Name: idx_ai_embedding_queue_status; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX idx_ai_embedding_queue_status ON public.ai_embedding_queue USING btree (status, created_at) WHERE (status = ANY (ARRAY['pending'::public.ai_embedding_status, 'failed'::public.ai_embedding_status]));


--
-- Name: idx_ai_embeddings_metadata; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX idx_ai_embeddings_metadata ON public.ai_embeddings USING gin (metadata);


--
-- Name: idx_ai_embeddings_org; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX idx_ai_embeddings_org ON public.ai_embeddings USING btree (organization_id);


--
-- Name: idx_ai_embeddings_source; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX idx_ai_embeddings_source ON public.ai_embeddings USING btree (source_table, source_id);


--
-- Name: idx_ai_embeddings_vector_hnsw; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX idx_ai_embeddings_vector_hnsw ON public.ai_embeddings USING hnsw (embedding extensions.vector_cosine_ops) WITH (m='16', ef_construction='64');


--
-- Name: INDEX idx_ai_embeddings_vector_hnsw; Type: COMMENT; Schema: public; Owner: -
--

COMMENT ON INDEX public.idx_ai_embeddings_vector_hnsw IS 'HNSW index for fast approximate nearest neighbor search';


--
-- Name: idx_ai_interactions_created; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX idx_ai_interactions_created ON public.ai_interactions USING btree (created_at DESC);


--
-- Name: idx_ai_interactions_embedding_hnsw; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX idx_ai_interactions_embedding_hnsw ON public.ai_interactions USING hnsw (embedding extensions.vector_cosine_ops) WITH (m='16', ef_construction='64');


--
-- Name: idx_ai_interactions_org; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX idx_ai_interactions_org ON public.ai_interactions USING btree (organization_id);


--
-- Name: idx_ai_search_logs_created; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX idx_ai_search_logs_created ON public.ai_search_logs USING btree (created_at DESC);


--
-- Name: idx_ai_search_logs_org; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX idx_ai_search_logs_org ON public.ai_search_logs USING btree (organization_id, created_at DESC);


--
-- Name: idx_ai_search_logs_user; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX idx_ai_search_logs_user ON public.ai_search_logs USING btree (user_id, created_at DESC);


--
-- Name: idx_ai_skills_category; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX idx_ai_skills_category ON public.ai_skills USING btree (category) WHERE (enabled = true);


--
-- Name: idx_ai_skills_enabled; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX idx_ai_skills_enabled ON public.ai_skills USING btree (enabled, name);


--
-- Name: idx_ai_usage_org_created; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX idx_ai_usage_org_created ON public.ai_usage USING btree (organization_id, created_at DESC);


--
-- Name: idx_ai_usage_request; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX idx_ai_usage_request ON public.ai_usage USING btree (request_id);


--
-- Name: idx_appointment_resources_appointment; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX idx_appointment_resources_appointment ON public.appointment_resources USING btree (appointment_id, resource_role);


--
-- Name: idx_appointment_resources_resource; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX idx_appointment_resources_resource ON public.appointment_resources USING btree (resource_entity_id, status);


--
-- Name: idx_appointment_resources_resource_type; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX idx_appointment_resources_resource_type ON public.appointment_resources USING btree (resource_type, status);


--
-- Name: idx_appointments_ai_no_show; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX idx_appointments_ai_no_show ON public.appointments USING gin (ai_no_show_prediction) WHERE (deleted_at IS NULL);


--
-- Name: idx_appointments_ai_resource_opt; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX idx_appointments_ai_resource_opt ON public.appointments USING gin (ai_resource_optimization) WHERE (deleted_at IS NULL);


--
-- Name: idx_appointments_ai_scheduling; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX idx_appointments_ai_scheduling ON public.appointments USING gin (ai_optimal_scheduling) WHERE (deleted_at IS NULL);


--
-- Name: idx_appointments_client; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX idx_appointments_client ON public.appointments USING btree (client_entity_id, appointment_date DESC) WHERE (deleted_at IS NULL);


--
-- Name: idx_appointments_date_range; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX idx_appointments_date_range ON public.appointments USING btree (organization_id, appointment_date, start_time, end_time) WHERE (deleted_at IS NULL);


--
-- Name: idx_appointments_embedding_hnsw; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX idx_appointments_embedding_hnsw ON public.appointments USING hnsw (embedding extensions.vector_cosine_ops) WITH (m='16', ef_construction='64') WHERE ((deleted_at IS NULL) AND (embedding IS NOT NULL));


--
-- Name: idx_appointments_location; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX idx_appointments_location ON public.appointments USING btree (location_entity_id) WHERE ((location_entity_id IS NOT NULL) AND (deleted_at IS NULL));


--
-- Name: idx_appointments_needs_embedding; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX idx_appointments_needs_embedding ON public.appointments USING btree (has_embedding) WHERE ((has_embedding = false) AND (deleted_at IS NULL));


--
-- Name: idx_appointments_no_show_probability; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX idx_appointments_no_show_probability ON public.appointments USING btree ((((ai_no_show_prediction ->> 'no_show_probability'::text))::numeric)) WHERE ((status = ANY (ARRAY['scheduled'::public.appointment_status, 'confirmed'::public.appointment_status])) AND (deleted_at IS NULL));


--
-- Name: idx_appointments_org_date; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX idx_appointments_org_date ON public.appointments USING btree (organization_id, appointment_date DESC) WHERE (deleted_at IS NULL);


--
-- Name: idx_appointments_recurrence; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX idx_appointments_recurrence ON public.appointments USING btree (recurrence_group_id) WHERE ((recurrence_group_id IS NOT NULL) AND (deleted_at IS NULL));


--
-- Name: idx_appointments_resource; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX idx_appointments_resource ON public.appointments USING btree (resource_entity_id, appointment_date, start_time) WHERE (deleted_at IS NULL);


--
-- Name: idx_appointments_resource_type; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX idx_appointments_resource_type ON public.appointments USING btree (resource_type, organization_id, appointment_date) WHERE (deleted_at IS NULL);


--
-- Name: idx_appointments_service; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX idx_appointments_service ON public.appointments USING btree (catalog_item_id, appointment_date) WHERE ((catalog_item_id IS NOT NULL) AND (deleted_at IS NULL));


--
-- Name: idx_appointments_status; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX idx_appointments_status ON public.appointments USING btree (status, organization_id, appointment_date) WHERE (deleted_at IS NULL);


--
-- Name: idx_attribute_definitions_code; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX idx_attribute_definitions_code ON public.attribute_definitions USING btree (attribute_code);


--
-- Name: idx_attribute_definitions_org; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX idx_attribute_definitions_org ON public.attribute_definitions USING btree (organization_id);


--
-- Name: idx_attribute_definitions_variant; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX idx_attribute_definitions_variant ON public.attribute_definitions USING btree (organization_id) WHERE (is_variant_attribute = true);


--
-- Name: idx_audit_action; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX idx_audit_action ON public.appointment_audit_log USING btree (action, organization_id);


--
-- Name: idx_audit_appointment; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX idx_audit_appointment ON public.appointment_audit_log USING btree (appointment_id, "timestamp" DESC);


--
-- Name: idx_audit_logs_created; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX idx_audit_logs_created ON public.audit_logs USING btree (created_at DESC);


--
-- Name: idx_audit_logs_org; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX idx_audit_logs_org ON public.audit_logs USING btree (organization_id, created_at DESC);


--
-- Name: idx_audit_logs_table; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX idx_audit_logs_table ON public.audit_logs USING btree (table_name, record_id);


--
-- Name: idx_audit_logs_user; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX idx_audit_logs_user ON public.audit_logs USING btree (user_id, created_at DESC);


--
-- Name: idx_audit_org; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX idx_audit_org ON public.appointment_audit_log USING btree (organization_id, "timestamp" DESC);


--
-- Name: idx_audit_user; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX idx_audit_user ON public.appointment_audit_log USING btree (user_id, "timestamp" DESC);


--
-- Name: idx_availability_capability; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX idx_availability_capability ON public.resource_capability_availability USING btree (capability_id) WHERE (is_active = true);


--
-- Name: idx_availability_days; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX idx_availability_days ON public.resource_capability_availability USING gin (days_of_week) WHERE (is_active = true);


--
-- Name: idx_booking_sessions_expires; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX idx_booking_sessions_expires ON public.booking_sessions USING btree (expires_at) WHERE (status = 'pending'::text);


--
-- Name: idx_bot_messages_category; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX idx_bot_messages_category ON public.bot_messages USING btree (category) WHERE (is_active = true);


--
-- Name: idx_bot_messages_lookup; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX idx_bot_messages_lookup ON public.bot_messages USING btree (organization_id, category, message_key, channel, language) WHERE (is_active = true);


--
-- Name: idx_business_hours_org_day; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX idx_business_hours_org_day ON public.business_hours USING btree (organization_id, day_of_week);


--
-- Name: idx_calendar_org; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX idx_calendar_org ON public.calendar_connections USING btree (organization_id);


--
-- Name: idx_calendar_sync_status; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX idx_calendar_sync_status ON public.calendar_connections USING btree (sync_status) WHERE (sync_enabled = true);


--
-- Name: idx_calendar_user; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX idx_calendar_user ON public.calendar_connections USING btree (user_id);


--
-- Name: idx_capabilities_attributes_gin; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX idx_capabilities_attributes_gin ON public.resource_capabilities USING gin (attributes jsonb_path_ops) WHERE (deleted_at IS NULL);


--
-- Name: idx_capabilities_catalog_item; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX idx_capabilities_catalog_item ON public.resource_capabilities USING btree (organization_id, catalog_item_id) WHERE ((deleted_at IS NULL) AND (is_active = true));


--
-- Name: idx_capabilities_embedding; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX idx_capabilities_embedding ON public.resource_capabilities USING ivfflat (embedding extensions.vector_cosine_ops) WITH (lists='100') WHERE ((deleted_at IS NULL) AND (has_embedding = true));


--
-- Name: idx_capabilities_org; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX idx_capabilities_org ON public.resource_capabilities USING btree (organization_id) WHERE (deleted_at IS NULL);


--
-- Name: idx_capabilities_primary; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX idx_capabilities_primary ON public.resource_capabilities USING btree (organization_id, resource_entity_id) WHERE ((deleted_at IS NULL) AND (is_active = true) AND (is_primary = true));


--
-- Name: idx_capabilities_resource; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX idx_capabilities_resource ON public.resource_capabilities USING btree (organization_id, resource_entity_id) WHERE ((deleted_at IS NULL) AND (is_active = true));


--
-- Name: idx_capabilities_validity; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX idx_capabilities_validity ON public.resource_capabilities USING btree (organization_id, resource_entity_id, valid_from, valid_until) WHERE (deleted_at IS NULL);


--
-- Name: idx_catalog_categories_has_embedding; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX idx_catalog_categories_has_embedding ON public.catalog_categories USING btree (has_embedding) WHERE (has_embedding = true);


--
-- Name: idx_catalog_categories_org; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX idx_catalog_categories_org ON public.catalog_categories USING btree (organization_id) WHERE (deleted_at IS NULL);


--
-- Name: idx_catalog_categories_parent; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX idx_catalog_categories_parent ON public.catalog_categories USING btree (parent_id) WHERE (deleted_at IS NULL);


--
-- Name: idx_catalog_categories_path_btree; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX idx_catalog_categories_path_btree ON public.catalog_categories USING btree (path) WHERE (deleted_at IS NULL);


--
-- Name: idx_catalog_categories_path_gist; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX idx_catalog_categories_path_gist ON public.catalog_categories USING gist (path) WHERE (deleted_at IS NULL);


--
-- Name: idx_catalog_items_ai_desc_trgm; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX idx_catalog_items_ai_desc_trgm ON public.catalog_items USING gin (ai_generated_description extensions.gin_trgm_ops);


--
-- Name: idx_catalog_items_attributes; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX idx_catalog_items_attributes ON public.catalog_items USING gin (attributes jsonb_path_ops) WHERE (deleted_at IS NULL);


--
-- Name: idx_catalog_items_barcode_org_unique; Type: INDEX; Schema: public; Owner: -
--

CREATE UNIQUE INDEX idx_catalog_items_barcode_org_unique ON public.catalog_items USING btree (organization_id, barcode) WHERE ((barcode IS NOT NULL) AND (deleted_at IS NULL));


--
-- Name: idx_catalog_items_category; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX idx_catalog_items_category ON public.catalog_items USING btree (category_id, organization_id) WHERE ((is_active = true) AND (deleted_at IS NULL));


--
-- Name: idx_catalog_items_description_trgm; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX idx_catalog_items_description_trgm ON public.catalog_items USING gin (description extensions.gin_trgm_ops);


--
-- Name: idx_catalog_items_embedding; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX idx_catalog_items_embedding ON public.catalog_items USING ivfflat (embedding extensions.vector_cosine_ops) WITH (lists='100');


--
-- Name: idx_catalog_items_exact_name; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX idx_catalog_items_exact_name ON public.catalog_items USING btree (organization_id, lower(name)) WHERE ((is_active = true) AND ((item_type)::text = 'service'::text));


--
-- Name: idx_catalog_items_has_embedding; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX idx_catalog_items_has_embedding ON public.catalog_items USING btree (has_embedding) WHERE (has_embedding = true);


--
-- Name: idx_catalog_items_name_search; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX idx_catalog_items_name_search ON public.catalog_items USING btree (organization_id, is_active, item_type, lower(name));


--
-- Name: idx_catalog_items_name_trgm; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX idx_catalog_items_name_trgm ON public.catalog_items USING gin (name extensions.gin_trgm_ops);


--
-- Name: idx_catalog_items_org_active; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX idx_catalog_items_org_active ON public.catalog_items USING btree (organization_id, is_active) WHERE (deleted_at IS NULL);


--
-- Name: idx_catalog_items_parent; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX idx_catalog_items_parent ON public.catalog_items USING btree (parent_id) WHERE ((parent_id IS NOT NULL) AND (deleted_at IS NULL));


--
-- Name: idx_catalog_items_search_vector; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX idx_catalog_items_search_vector ON public.catalog_items USING gin (search_vector);


--
-- Name: idx_catalog_items_tags; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX idx_catalog_items_tags ON public.catalog_items USING gin (tags) WHERE (deleted_at IS NULL);


--
-- Name: idx_catalog_items_templates; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX idx_catalog_items_templates ON public.catalog_items USING btree (organization_id) WHERE ((is_template = true) AND (is_active = true) AND (deleted_at IS NULL));


--
-- Name: idx_catalog_items_type; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX idx_catalog_items_type ON public.catalog_items USING btree (item_type, organization_id) WHERE ((is_active = true) AND (deleted_at IS NULL));


--
-- Name: idx_catalog_items_vertical_config; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX idx_catalog_items_vertical_config ON public.catalog_items USING gin (vertical_config jsonb_path_ops) WHERE (deleted_at IS NULL);


--
-- Name: idx_clients_ai_churn_risk; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX idx_clients_ai_churn_risk ON public.clients USING btree (organization_id, ai_churn_risk DESC) WHERE ((deleted_at IS NULL) AND (ai_churn_risk IS NOT NULL));


--
-- Name: idx_clients_ai_ltv; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX idx_clients_ai_ltv ON public.clients USING btree (organization_id, ai_lifetime_value DESC) WHERE ((deleted_at IS NULL) AND (ai_lifetime_value IS NOT NULL));


--
-- Name: idx_clients_category; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX idx_clients_category ON public.clients USING btree (organization_id, category) WHERE (deleted_at IS NULL);


--
-- Name: idx_clients_client_type; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX idx_clients_client_type ON public.clients USING btree (client_type);


--
-- Name: idx_clients_embedding; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX idx_clients_embedding ON public.clients USING ivfflat (embedding extensions.vector_cosine_ops) WITH (lists='100') WHERE (embedding IS NOT NULL);


--
-- Name: idx_clients_entity_id; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX idx_clients_entity_id ON public.clients USING btree (entity_id);


--
-- Name: idx_clients_industry; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX idx_clients_industry ON public.clients USING btree (organization_id, industry) WHERE ((deleted_at IS NULL) AND (industry IS NOT NULL));


--
-- Name: idx_clients_last_visit; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX idx_clients_last_visit ON public.clients USING btree (organization_id, last_visit_date DESC) WHERE (deleted_at IS NULL);


--
-- Name: idx_clients_loyalty_points; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX idx_clients_loyalty_points ON public.clients USING btree (organization_id, loyalty_points DESC) WHERE (deleted_at IS NULL);


--
-- Name: idx_clients_loyalty_tier; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX idx_clients_loyalty_tier ON public.clients USING btree (organization_id, loyalty_tier) WHERE (deleted_at IS NULL);


--
-- Name: idx_clients_next_appointment; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX idx_clients_next_appointment ON public.clients USING btree (organization_id, next_appointment_date) WHERE ((deleted_at IS NULL) AND (next_appointment_date IS NOT NULL));


--
-- Name: idx_clients_org_status; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX idx_clients_org_status ON public.clients USING btree (organization_id, status) WHERE (deleted_at IS NULL);


--
-- Name: idx_clients_organization_id; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX idx_clients_organization_id ON public.clients USING btree (organization_id);


--
-- Name: idx_clients_source; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX idx_clients_source ON public.clients USING btree (organization_id, source) WHERE (deleted_at IS NULL);


--
-- Name: idx_clients_tax_id; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX idx_clients_tax_id ON public.clients USING btree (organization_id, tax_id) WHERE ((deleted_at IS NULL) AND (tax_id IS NOT NULL));


--
-- Name: idx_clients_total_spent; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX idx_clients_total_spent ON public.clients USING btree (organization_id, total_spent DESC) WHERE (deleted_at IS NULL);


--
-- Name: idx_clients_type; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX idx_clients_type ON public.clients USING btree (organization_id, client_type) WHERE (deleted_at IS NULL);


--
-- Name: idx_conv_memory_created; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX idx_conv_memory_created ON public.conversation_memory USING btree (created_at DESC);


--
-- Name: idx_conv_memory_org_channel_user; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX idx_conv_memory_org_channel_user ON public.conversation_memory USING btree (organization_id, channel, channel_user_id);


--
-- Name: idx_conv_memory_org_created; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX idx_conv_memory_org_created ON public.conversation_memory USING btree (organization_id, created_at DESC);


--
-- Name: idx_conv_memory_session; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX idx_conv_memory_session ON public.conversation_memory USING btree (session_id);


--
-- Name: idx_conv_sessions_expires; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX idx_conv_sessions_expires ON public.conversation_sessions USING btree (expires_at) WHERE ((status)::text = 'active'::text);


--
-- Name: idx_conv_sessions_last_activity; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX idx_conv_sessions_last_activity ON public.conversation_sessions USING btree (last_activity_at);


--
-- Name: idx_conv_sessions_org_channel_user; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX idx_conv_sessions_org_channel_user ON public.conversation_sessions USING btree (organization_id, channel, channel_user_id);


--
-- Name: idx_conv_sessions_status; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX idx_conv_sessions_status ON public.conversation_sessions USING btree (status) WHERE ((status)::text = 'active'::text);


--
-- Name: idx_conversation_flows_intents; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX idx_conversation_flows_intents ON public.conversation_flows USING gin (trigger_intents) WHERE (enabled = true);


--
-- Name: idx_conversation_flows_name; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX idx_conversation_flows_name ON public.conversation_flows USING btree (flow_name) WHERE (enabled = true);


--
-- Name: idx_conversation_flows_org; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX idx_conversation_flows_org ON public.conversation_flows USING btree (organization_id) WHERE (enabled = true);


--
-- Name: idx_conversation_flows_vertical; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX idx_conversation_flows_vertical ON public.conversation_flows USING btree (vertical_code) WHERE (enabled = true);


--
-- Name: idx_daily_summary_absent; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX idx_daily_summary_absent ON public.daily_time_summary USING btree (organization_id, summary_date) WHERE (is_absent = true);


--
-- Name: idx_daily_summary_dept_date; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX idx_daily_summary_dept_date ON public.daily_time_summary USING btree (department_id, summary_date);


--
-- Name: idx_daily_summary_employee_date; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX idx_daily_summary_employee_date ON public.daily_time_summary USING btree (employee_id, summary_date);


--
-- Name: idx_daily_summary_exceptions; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX idx_daily_summary_exceptions ON public.daily_time_summary USING gin (exceptions) WHERE (exceptions <> '[]'::jsonb);


--
-- Name: idx_daily_summary_late; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX idx_daily_summary_late ON public.daily_time_summary USING btree (organization_id, summary_date) WHERE (is_late = true);


--
-- Name: idx_daily_summary_org_date; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX idx_daily_summary_org_date ON public.daily_time_summary USING btree (organization_id, summary_date);


--
-- Name: idx_daily_summary_status; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX idx_daily_summary_status ON public.daily_time_summary USING btree (status, organization_id, summary_date);


--
-- Name: idx_departments_manager; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX idx_departments_manager ON public.departments USING btree (manager_employee_id);


--
-- Name: idx_departments_org; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX idx_departments_org ON public.departments USING btree (organization_id) WHERE (is_active = true);


--
-- Name: idx_departments_parent; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX idx_departments_parent ON public.departments USING btree (parent_department_id);


--
-- Name: idx_departments_path; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX idx_departments_path ON public.departments USING gin (path);


--
-- Name: idx_doc_type_code_country; Type: INDEX; Schema: public; Owner: -
--

CREATE UNIQUE INDEX idx_doc_type_code_country ON public.identification_document_types USING btree (code, country_code) WHERE (organization_id IS NULL);


--
-- Name: idx_doc_type_code_org_country; Type: INDEX; Schema: public; Owner: -
--

CREATE UNIQUE INDEX idx_doc_type_code_org_country ON public.identification_document_types USING btree (organization_id, code, country_code) WHERE (organization_id IS NOT NULL);


--
-- Name: idx_doc_types_active; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX idx_doc_types_active ON public.identification_document_types USING btree (is_active) WHERE (is_active = true);


--
-- Name: idx_doc_types_country; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX idx_doc_types_country ON public.identification_document_types USING btree (country_code);


--
-- Name: idx_doc_types_org; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX idx_doc_types_org ON public.identification_document_types USING btree (organization_id);


--
-- Name: idx_embedding_configs_enabled; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX idx_embedding_configs_enabled ON public.ai_embedding_configs USING btree (enabled) WHERE (enabled = true);


--
-- Name: idx_employees_ai_features; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX idx_employees_ai_features ON public.employees USING gin (ai_features) WHERE (deleted_at IS NULL);


--
-- Name: INDEX idx_employees_ai_features; Type: COMMENT; Schema: public; Owner: -
--

COMMENT ON INDEX public.idx_employees_ai_features IS 'GIN index for AI predictions, embeddings similarity, and model scores';


--
-- Name: idx_employees_analytics_snapshot; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX idx_employees_analytics_snapshot ON public.employees USING gin (analytics_snapshot) WHERE (deleted_at IS NULL);


--
-- Name: INDEX idx_employees_analytics_snapshot; Type: COMMENT; Schema: public; Owner: -
--

COMMENT ON INDEX public.idx_employees_analytics_snapshot IS 'GIN index for fast KPI queries and aggregated metrics';


--
-- Name: idx_employees_code; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX idx_employees_code ON public.employees USING btree (employee_code, organization_id) WHERE (deleted_at IS NULL);


--
-- Name: idx_employees_custom_fields; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX idx_employees_custom_fields ON public.employees USING gin (custom_fields) WHERE (deleted_at IS NULL);


--
-- Name: idx_employees_deleted; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX idx_employees_deleted ON public.employees USING btree (deleted_at);


--
-- Name: idx_employees_department; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX idx_employees_department ON public.employees USING btree (department, organization_id) WHERE (deleted_at IS NULL);


--
-- Name: idx_employees_dept_id; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX idx_employees_dept_id ON public.employees USING btree (department_id) WHERE (deleted_at IS NULL);


--
-- Name: idx_employees_division; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX idx_employees_division ON public.employees USING btree (division, organization_id) WHERE (deleted_at IS NULL);


--
-- Name: idx_employees_entity; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX idx_employees_entity ON public.employees USING btree (entity_id) WHERE (deleted_at IS NULL);


--
-- Name: idx_employees_entity_org; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX idx_employees_entity_org ON public.employees USING btree (entity_id, organization_id) WHERE (deleted_at IS NULL);


--
-- Name: idx_employees_hire_date; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX idx_employees_hire_date ON public.employees USING btree (hire_date, organization_id) WHERE (deleted_at IS NULL);


--
-- Name: idx_employees_hr_data; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX idx_employees_hr_data ON public.employees USING gin (hr_data) WHERE (deleted_at IS NULL);


--
-- Name: idx_employees_job; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX idx_employees_job ON public.employees USING btree (job_id) WHERE (deleted_at IS NULL);


--
-- Name: idx_employees_org; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX idx_employees_org ON public.employees USING btree (organization_id) WHERE (deleted_at IS NULL);


--
-- Name: idx_employees_position_id; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX idx_employees_position_id ON public.employees USING btree (position_id) WHERE (deleted_at IS NULL);


--
-- Name: idx_employees_position_search; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX idx_employees_position_search ON public.employees USING gin (to_tsvector('spanish'::regconfig, "position")) WHERE (deleted_at IS NULL);


--
-- Name: idx_employees_preferences; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX idx_employees_preferences ON public.employees USING gin (preferences) WHERE (deleted_at IS NULL);


--
-- Name: idx_employees_reports_to; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX idx_employees_reports_to ON public.employees USING btree (reports_to_employee_id) WHERE (deleted_at IS NULL);


--
-- Name: idx_employees_review_dates; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX idx_employees_review_dates ON public.employees USING btree (next_review_date, organization_id) WHERE ((deleted_at IS NULL) AND (employment_status = 'active'::public.employment_status_enum));


--
-- Name: idx_employees_skills; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX idx_employees_skills ON public.employees USING gin (skills) WHERE (deleted_at IS NULL);


--
-- Name: INDEX idx_employees_skills; Type: COMMENT; Schema: public; Owner: -
--

COMMENT ON INDEX public.idx_employees_skills IS 'GIN index for fast skill-based queries and talent matching';


--
-- Name: idx_employees_status; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX idx_employees_status ON public.employees USING btree (employment_status, organization_id) WHERE (deleted_at IS NULL);


--
-- Name: idx_employees_type; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX idx_employees_type ON public.employees USING btree (employment_type, organization_id) WHERE (deleted_at IS NULL);


--
-- Name: idx_employees_work_schedule; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX idx_employees_work_schedule ON public.employees USING gin (work_schedule) WHERE (deleted_at IS NULL);


--
-- Name: idx_entities_code; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX idx_entities_code ON public.entities USING btree (entity_code, organization_id);


--
-- Name: idx_entities_custom_fields; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX idx_entities_custom_fields ON public.entities USING gin (custom_fields);


--
-- Name: idx_entities_deleted; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX idx_entities_deleted ON public.entities USING btree (deleted_at) WHERE (deleted_at IS NOT NULL);


--
-- Name: idx_entities_display_name_search; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX idx_entities_display_name_search ON public.entities USING btree (organization_id, entity_type, lower(display_name)) WHERE (deleted_at IS NULL);


--
-- Name: idx_entities_email; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX idx_entities_email ON public.entities USING btree (email) WHERE (email IS NOT NULL);


--
-- Name: idx_entities_exact_name; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX idx_entities_exact_name ON public.entities USING btree (organization_id, lower(display_name)) WHERE (deleted_at IS NULL);


--
-- Name: idx_entities_mobile; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX idx_entities_mobile ON public.entities USING btree (organization_id, mobile) WHERE (deleted_at IS NULL);


--
-- Name: idx_entities_name_search; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX idx_entities_name_search ON public.entities USING gin (to_tsvector('spanish'::regconfig, display_name));


--
-- Name: idx_entities_org; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX idx_entities_org ON public.entities USING btree (organization_id) WHERE (deleted_at IS NULL);


--
-- Name: idx_entities_org_subtype; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX idx_entities_org_subtype ON public.entities USING btree (organization_subtype, organization_id) WHERE ((entity_type = 'organization'::public.entity_type) AND (deleted_at IS NULL));


--
-- Name: idx_entities_person_subtype; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX idx_entities_person_subtype ON public.entities USING btree (person_subtype, organization_id) WHERE ((entity_type = 'person'::public.entity_type) AND (deleted_at IS NULL));


--
-- Name: idx_entities_phone; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX idx_entities_phone ON public.entities USING btree (organization_id, phone) WHERE (deleted_at IS NULL);


--
-- Name: idx_entities_status; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX idx_entities_status ON public.entities USING btree (status, organization_id) WHERE (deleted_at IS NULL);


--
-- Name: idx_entities_type; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX idx_entities_type ON public.entities USING btree (entity_type, organization_id) WHERE (deleted_at IS NULL);


--
-- Name: idx_entity_ai_cold_entity; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX idx_entity_ai_cold_entity ON public.entity_ai_cold USING btree (entity_id, snapshot_date DESC);


--
-- Name: idx_entity_ai_cold_snapshot; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX idx_entity_ai_cold_snapshot ON public.entity_ai_cold USING btree (snapshot_date DESC);


--
-- Name: idx_entity_ai_hot_accessed; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX idx_entity_ai_hot_accessed ON public.entity_ai_hot USING btree (last_accessed_at DESC);


--
-- Name: idx_entity_ai_hot_entity; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX idx_entity_ai_hot_entity ON public.entity_ai_hot USING btree (entity_id);


--
-- Name: idx_entity_ai_traits_churn; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX idx_entity_ai_traits_churn ON public.entity_ai_traits USING gin (ai_churn_risk);


--
-- Name: idx_entity_ai_traits_churn_score; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX idx_entity_ai_traits_churn_score ON public.entity_ai_traits USING btree ((((ai_churn_risk ->> 'churn_score'::text))::numeric)) WHERE ((ai_churn_risk ->> 'churn_score'::text) IS NOT NULL);


--
-- Name: idx_entity_ai_traits_entity; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX idx_entity_ai_traits_entity ON public.entity_ai_traits USING btree (entity_id);


--
-- Name: idx_entity_ai_traits_insights; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX idx_entity_ai_traits_insights ON public.entity_ai_traits USING gin (ai_client_insights);


--
-- Name: idx_entity_ai_traits_lifetime_value; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX idx_entity_ai_traits_lifetime_value ON public.entity_ai_traits USING btree ((((ai_lifetime_value ->> 'predicted_value'::text))::numeric)) WHERE ((ai_lifetime_value ->> 'predicted_value'::text) IS NOT NULL);


--
-- Name: idx_entity_ai_traits_no_show; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX idx_entity_ai_traits_no_show ON public.entity_ai_traits USING gin (ai_no_show_risk);


--
-- Name: idx_entity_ai_traits_no_show_probability; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX idx_entity_ai_traits_no_show_probability ON public.entity_ai_traits USING btree ((((ai_no_show_risk ->> 'no_show_probability'::text))::numeric)) WHERE ((ai_no_show_risk ->> 'no_show_probability'::text) IS NOT NULL);


--
-- Name: idx_entity_ai_traits_org_type; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX idx_entity_ai_traits_org_type ON public.entity_ai_traits USING btree (organization_id, entity_type);


--
-- Name: idx_entity_ai_traits_recommendations; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX idx_entity_ai_traits_recommendations ON public.entity_ai_traits USING gin (ai_service_recommendations);


--
-- Name: idx_entity_ai_traits_refresh; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX idx_entity_ai_traits_refresh ON public.entity_ai_traits USING btree (last_ai_refresh_at, organization_id) WHERE (last_ai_refresh_at IS NOT NULL);


--
-- Name: idx_entity_docs_entity; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX idx_entity_docs_entity ON public.entity_identification_documents USING btree (entity_id) WHERE (deleted_at IS NULL);


--
-- Name: idx_entity_docs_expires; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX idx_entity_docs_expires ON public.entity_identification_documents USING btree (organization_id, expires_at) WHERE ((deleted_at IS NULL) AND (expires_at IS NOT NULL));


--
-- Name: idx_entity_docs_org_normalized; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX idx_entity_docs_org_normalized ON public.entity_identification_documents USING btree (organization_id, document_number_normalized) WHERE (deleted_at IS NULL);


--
-- Name: idx_entity_docs_type; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX idx_entity_docs_type ON public.entity_identification_documents USING btree (organization_id, document_type) WHERE (deleted_at IS NULL);


--
-- Name: idx_entity_insurance_active; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX idx_entity_insurance_active ON public.entity_insurance_policies USING btree (organization_id, is_active) WHERE ((deleted_at IS NULL) AND (is_active = true));


--
-- Name: idx_entity_insurance_entity; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX idx_entity_insurance_entity ON public.entity_insurance_policies USING btree (entity_id) WHERE (deleted_at IS NULL);


--
-- Name: idx_entity_insurance_expires; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX idx_entity_insurance_expires ON public.entity_insurance_policies USING btree (organization_id, expiration_date) WHERE ((deleted_at IS NULL) AND (expiration_date IS NOT NULL));


--
-- Name: idx_entity_insurance_policy_num; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX idx_entity_insurance_policy_num ON public.entity_insurance_policies USING btree (organization_id, policy_number_normalized) WHERE (deleted_at IS NULL);


--
-- Name: idx_entity_insurance_provider; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX idx_entity_insurance_provider ON public.entity_insurance_policies USING btree (organization_id, provider_code) WHERE (deleted_at IS NULL);


--
-- Name: idx_entity_metrics_cache_churn; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX idx_entity_metrics_cache_churn ON public.entity_metrics_cache USING btree (churn_risk_score DESC) WHERE (churn_risk_score > 0.5);


--
-- Name: idx_entity_metrics_cache_engagement; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX idx_entity_metrics_cache_engagement ON public.entity_metrics_cache USING btree (engagement_score DESC);


--
-- Name: idx_entity_metrics_cache_last_visit; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX idx_entity_metrics_cache_last_visit ON public.entity_metrics_cache USING btree (days_since_last_visit) WHERE (days_since_last_visit IS NOT NULL);


--
-- Name: idx_entity_metrics_cache_lifetime_value; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX idx_entity_metrics_cache_lifetime_value ON public.entity_metrics_cache USING btree (lifetime_value_score DESC) WHERE (lifetime_value_score > (0)::numeric);


--
-- Name: idx_entity_metrics_cache_org_type; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX idx_entity_metrics_cache_org_type ON public.entity_metrics_cache USING btree (organization_id, entity_type);


--
-- Name: idx_entity_relationships_custom_fields; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX idx_entity_relationships_custom_fields ON public.entity_relationships USING gin (metadata) WHERE (deleted_at IS NULL);


--
-- Name: idx_entity_relationships_from; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX idx_entity_relationships_from ON public.entity_relationships USING btree (source_entity_id, deleted_at) WHERE (deleted_at IS NULL);


--
-- Name: idx_entity_relationships_medical_decisions; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX idx_entity_relationships_medical_decisions ON public.entity_relationships USING btree (target_entity_id, can_make_medical_decisions) WHERE ((can_make_medical_decisions = true) AND (deleted_at IS NULL));


--
-- Name: idx_entity_relationships_organization; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX idx_entity_relationships_organization ON public.entity_relationships USING btree (organization_id, deleted_at) WHERE (deleted_at IS NULL);


--
-- Name: idx_entity_relationships_primary_contact; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX idx_entity_relationships_primary_contact ON public.entity_relationships USING btree (target_entity_id, is_primary, priority) WHERE ((is_primary = true) AND (deleted_at IS NULL));


--
-- Name: idx_entity_relationships_status; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX idx_entity_relationships_status ON public.entity_relationships USING btree (status, deleted_at) WHERE (deleted_at IS NULL);


--
-- Name: idx_entity_relationships_temporal; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX idx_entity_relationships_temporal ON public.entity_relationships USING btree (valid_from, valid_until, deleted_at) WHERE (deleted_at IS NULL);


--
-- Name: idx_entity_relationships_to; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX idx_entity_relationships_to ON public.entity_relationships USING btree (target_entity_id, deleted_at) WHERE (deleted_at IS NULL);


--
-- Name: idx_entity_relationships_type; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX idx_entity_relationships_type ON public.entity_relationships USING btree (relationship_type, deleted_at) WHERE (deleted_at IS NULL);


--
-- Name: idx_entity_synonyms_canonical; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX idx_entity_synonyms_canonical ON public.entity_synonyms USING btree (canonical_value) WHERE (enabled = true);


--
-- Name: idx_entity_synonyms_lookup; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX idx_entity_synonyms_lookup ON public.entity_synonyms USING btree (entity_type, organization_id, vertical_code, channel) WHERE (enabled = true);


--
-- Name: idx_entity_synonyms_org; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX idx_entity_synonyms_org ON public.entity_synonyms USING btree (organization_id) WHERE (enabled = true);


--
-- Name: idx_entity_synonyms_synonym; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX idx_entity_synonyms_synonym ON public.entity_synonyms USING btree (synonym) WHERE (enabled = true);


--
-- Name: idx_entity_synonyms_synonym_gin; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX idx_entity_synonyms_synonym_gin ON public.entity_synonyms USING gin (to_tsvector('spanish'::regconfig, (synonym)::text)) WHERE (enabled = true);


--
-- Name: idx_entity_synonyms_type; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX idx_entity_synonyms_type ON public.entity_synonyms USING btree (entity_type) WHERE (enabled = true);


--
-- Name: idx_external_events_blocking; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX idx_external_events_blocking ON public.external_calendar_events USING btree (organization_id, start_time, end_time) WHERE (is_blocking = true);


--
-- Name: idx_external_events_connection; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX idx_external_events_connection ON public.external_calendar_events USING btree (connection_id);


--
-- Name: idx_external_events_time; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX idx_external_events_time ON public.external_calendar_events USING btree (start_time, end_time);


--
-- Name: idx_flow_states_active; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX idx_flow_states_active ON public.conversation_flow_states USING btree (conversation_id, status) WHERE ((status)::text = 'active'::text);


--
-- Name: idx_flow_states_expires; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX idx_flow_states_expires ON public.conversation_flow_states USING btree (expires_at) WHERE ((status)::text = 'active'::text);


--
-- Name: idx_heuristic_rules_enabled; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX idx_heuristic_rules_enabled ON public.nlu_heuristic_rules USING btree (enabled, priority DESC) WHERE (enabled = true);


--
-- Name: idx_heuristic_rules_org; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX idx_heuristic_rules_org ON public.nlu_heuristic_rules USING btree (organization_id) WHERE (organization_id IS NOT NULL);


--
-- Name: idx_insurance_providers_active; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX idx_insurance_providers_active ON public.insurance_providers USING btree (is_active) WHERE (is_active = true);


--
-- Name: idx_insurance_providers_global; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX idx_insurance_providers_global ON public.insurance_providers USING btree (is_global) WHERE (is_global = true);


--
-- Name: idx_insurance_providers_org; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX idx_insurance_providers_org ON public.insurance_providers USING btree (organization_id);


--
-- Name: idx_insurance_providers_type; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX idx_insurance_providers_type ON public.insurance_providers USING btree (provider_type);


--
-- Name: idx_invites_created_by; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX idx_invites_created_by ON public.invites USING btree (created_by);


--
-- Name: idx_invites_deleted; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX idx_invites_deleted ON public.invites USING btree (deleted_at) WHERE (deleted_at IS NULL);


--
-- Name: idx_invites_email; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX idx_invites_email ON public.invites USING btree (email) WHERE (accepted_at IS NULL);


--
-- Name: idx_invites_org; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX idx_invites_org ON public.invites USING btree (organization_id);


--
-- Name: idx_invites_token; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX idx_invites_token ON public.invites USING btree (token) WHERE ((accepted_at IS NULL) AND (revoked_at IS NULL));


--
-- Name: idx_item_attributes_attribute; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX idx_item_attributes_attribute ON public.item_attributes USING btree (attribute_id);


--
-- Name: idx_item_attributes_item; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX idx_item_attributes_item ON public.item_attributes USING btree (item_id);


--
-- Name: idx_item_providers_item; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX idx_item_providers_item ON public.item_providers USING btree (item_id, is_available) WHERE (is_available = true);


--
-- Name: idx_item_providers_org; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX idx_item_providers_org ON public.item_providers USING btree (organization_id);


--
-- Name: idx_item_providers_provider; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX idx_item_providers_provider ON public.item_providers USING btree (provider_entity_id, is_available);


--
-- Name: idx_item_skill_requirements_item; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX idx_item_skill_requirements_item ON public.item_skill_requirements USING btree (item_id);


--
-- Name: idx_item_skill_requirements_skill; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX idx_item_skill_requirements_skill ON public.item_skill_requirements USING btree (skill_id);


--
-- Name: idx_jobs_family; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX idx_jobs_family ON public.jobs USING btree (job_family, organization_id);


--
-- Name: idx_jobs_level; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX idx_jobs_level ON public.jobs USING btree (job_level, organization_id);


--
-- Name: idx_jobs_org; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX idx_jobs_org ON public.jobs USING btree (organization_id) WHERE (is_active = true);


--
-- Name: idx_jobs_search; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX idx_jobs_search ON public.jobs USING gin (to_tsvector('spanish'::regconfig, (((title)::text || ' '::text) || COALESCE(description, ''::text))));


--
-- Name: idx_knowledge_embedding; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX idx_knowledge_embedding ON public.org_knowledge_base USING hnsw (embedding extensions.vector_cosine_ops) WHERE ((enabled = true) AND (embedding IS NOT NULL));


--
-- Name: idx_knowledge_needs_embedding; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX idx_knowledge_needs_embedding ON public.org_knowledge_base USING btree (has_embedding) WHERE ((has_embedding = false) AND (enabled = true));


--
-- Name: idx_knowledge_org; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX idx_knowledge_org ON public.org_knowledge_base USING btree (organization_id) WHERE (enabled = true);


--
-- Name: idx_knowledge_tags; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX idx_knowledge_tags ON public.org_knowledge_base USING gin (tags);


--
-- Name: idx_knowledge_type; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX idx_knowledge_type ON public.org_knowledge_base USING btree (organization_id, content_type);


--
-- Name: idx_leave_balances_employee; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX idx_leave_balances_employee ON public.leave_balances USING btree (employee_id, year);


--
-- Name: idx_leave_balances_type; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX idx_leave_balances_type ON public.leave_balances USING btree (leave_type_id, year);


--
-- Name: idx_leave_requests_dates; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX idx_leave_requests_dates ON public.leave_requests USING btree (organization_id, start_date, end_date);


--
-- Name: idx_leave_requests_employee; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX idx_leave_requests_employee ON public.leave_requests USING btree (employee_id, start_date);


--
-- Name: idx_leave_requests_pending; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX idx_leave_requests_pending ON public.leave_requests USING btree (organization_id) WHERE ((status)::text = 'pending'::text);


--
-- Name: idx_leave_requests_status; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX idx_leave_requests_status ON public.leave_requests USING btree (status, organization_id);


--
-- Name: idx_leave_types_org; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX idx_leave_types_org ON public.leave_types USING btree (organization_id) WHERE (is_active = true);


--
-- Name: idx_llm_prompts_channel; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX idx_llm_prompts_channel ON public.llm_prompts USING btree (channel) WHERE (enabled = true);


--
-- Name: idx_llm_prompts_key; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX idx_llm_prompts_key ON public.llm_prompts USING btree (prompt_key) WHERE (enabled = true);


--
-- Name: idx_llm_prompts_lookup; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX idx_llm_prompts_lookup ON public.llm_prompts USING btree (prompt_key, organization_id, vertical_code, channel, language) WHERE (enabled = true);


--
-- Name: idx_llm_prompts_org; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX idx_llm_prompts_org ON public.llm_prompts USING btree (organization_id) WHERE (enabled = true);


--
-- Name: idx_llm_prompts_vertical; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX idx_llm_prompts_vertical ON public.llm_prompts USING btree (vertical_code) WHERE (enabled = true);


--
-- Name: idx_memberships_custom_permissions_gin; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX idx_memberships_custom_permissions_gin ON public.memberships USING gin (custom_permissions);


--
-- Name: idx_memberships_org; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX idx_memberships_org ON public.memberships USING btree (organization_id);


--
-- Name: idx_memberships_role; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX idx_memberships_role ON public.memberships USING btree (role_key);


--
-- Name: idx_memberships_status; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX idx_memberships_status ON public.memberships USING btree (status);


--
-- Name: idx_memberships_user; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX idx_memberships_user ON public.memberships USING btree (user_id);


--
-- Name: idx_memberships_user_org; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX idx_memberships_user_org ON public.memberships USING btree (user_id, organization_id);


--
-- Name: idx_nlu_intent_examples_embedding; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX idx_nlu_intent_examples_embedding ON public.nlu_intent_examples USING ivfflat (embedding extensions.vector_cosine_ops) WITH (lists='50');


--
-- Name: idx_nlu_intent_examples_intent; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX idx_nlu_intent_examples_intent ON public.nlu_intent_examples USING btree (intent);


--
-- Name: idx_nlu_intent_examples_org_active; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX idx_nlu_intent_examples_org_active ON public.nlu_intent_examples USING btree (organization_id, is_active) WHERE (is_active = true);


--
-- Name: idx_nlu_intent_signals_intent; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX idx_nlu_intent_signals_intent ON public.nlu_intent_signals USING btree (intent) WHERE (is_active = true);


--
-- Name: idx_nlu_intent_signals_org; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX idx_nlu_intent_signals_org ON public.nlu_intent_signals USING btree (organization_id, intent) WHERE (is_active = true);


--
-- Name: idx_nlu_intent_signals_type; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX idx_nlu_intent_signals_type ON public.nlu_intent_signals USING btree (signal_type) WHERE (is_active = true);


--
-- Name: idx_nlu_keywords_category; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX idx_nlu_keywords_category ON public.nlu_keywords USING btree (category) WHERE (is_active = true);


--
-- Name: idx_nlu_keywords_keyword_gin; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX idx_nlu_keywords_keyword_gin ON public.nlu_keywords USING gin (keyword extensions.gin_trgm_ops);


--
-- Name: idx_nlu_keywords_org_category; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX idx_nlu_keywords_org_category ON public.nlu_keywords USING btree (organization_id, category) WHERE (is_active = true);


--
-- Name: idx_nlu_training_logs_confidence; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX idx_nlu_training_logs_confidence ON public.nlu_training_logs USING btree (extracted_confidence);


--
-- Name: idx_nlu_training_logs_intent; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX idx_nlu_training_logs_intent ON public.nlu_training_logs USING btree (extracted_intent);


--
-- Name: idx_nlu_training_logs_org; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX idx_nlu_training_logs_org ON public.nlu_training_logs USING btree (organization_id);


--
-- Name: idx_nlu_training_logs_path; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX idx_nlu_training_logs_path ON public.nlu_training_logs USING btree (extraction_path);


--
-- Name: idx_nlu_training_logs_review_candidates; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX idx_nlu_training_logs_review_candidates ON public.nlu_training_logs USING btree (extracted_confidence, reviewed) WHERE ((NOT reviewed) AND (extracted_confidence < (0.7)::double precision));


--
-- Name: idx_nlu_training_logs_reviewed; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX idx_nlu_training_logs_reviewed ON public.nlu_training_logs USING btree (reviewed, created_at DESC);


--
-- Name: idx_nlu_typo_corrections_category; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX idx_nlu_typo_corrections_category ON public.nlu_typo_corrections USING btree (category) WHERE (is_active = true);


--
-- Name: idx_nlu_typo_corrections_typo_gin; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX idx_nlu_typo_corrections_typo_gin ON public.nlu_typo_corrections USING gin (typo extensions.gin_trgm_ops);


--
-- Name: idx_notification_queue_status; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX idx_notification_queue_status ON public.notification_queue USING btree (status) WHERE (status = 'pending'::text);


--
-- Name: idx_organization_verticals_active; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX idx_organization_verticals_active ON public.organization_verticals USING btree (is_active, sort_order);


--
-- Name: idx_organization_verticals_code; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX idx_organization_verticals_code ON public.organization_verticals USING btree (code) WHERE (is_active = true);


--
-- Name: idx_organization_verticals_system; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX idx_organization_verticals_system ON public.organization_verticals USING btree (is_system) WHERE (is_system = true);


--
-- Name: idx_organizations_addresses; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX idx_organizations_addresses ON public.organizations USING gin (addresses);


--
-- Name: idx_organizations_country; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX idx_organizations_country ON public.organizations USING btree (country) WHERE (deleted_at IS NULL);


--
-- Name: idx_organizations_custom_fields; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX idx_organizations_custom_fields ON public.organizations USING gin (custom_fields);


--
-- Name: idx_organizations_deleted; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX idx_organizations_deleted ON public.organizations USING btree (deleted_at) WHERE (deleted_at IS NOT NULL);


--
-- Name: idx_organizations_industry; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX idx_organizations_industry ON public.organizations USING btree (industry) WHERE (deleted_at IS NULL);


--
-- Name: idx_organizations_org_type; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX idx_organizations_org_type ON public.organizations USING btree (org_type) WHERE (deleted_at IS NULL);


--
-- Name: idx_organizations_parent_id; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX idx_organizations_parent_id ON public.organizations USING btree (parent_id) WHERE ((parent_id IS NOT NULL) AND (deleted_at IS NULL));


--
-- Name: idx_organizations_phones; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX idx_organizations_phones ON public.organizations USING gin (phones);


--
-- Name: idx_organizations_status; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX idx_organizations_status ON public.organizations USING btree (status) WHERE (deleted_at IS NULL);


--
-- Name: idx_organizations_tax_info; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX idx_organizations_tax_info ON public.organizations USING gin (tax_info);


--
-- Name: idx_organizations_vertical_code; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX idx_organizations_vertical_code ON public.organizations USING btree (vertical_code) WHERE (deleted_at IS NULL);


--
-- Name: idx_organizations_vertical_id; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX idx_organizations_vertical_id ON public.organizations USING btree (vertical_id) WHERE (deleted_at IS NULL);


--
-- Name: idx_organizations_whatsapp_phone; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX idx_organizations_whatsapp_phone ON public.organizations USING gin (((whatsapp_config -> '  phone_number_id'::text)));


--
-- Name: idx_patient_notes_appointment; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX idx_patient_notes_appointment ON public.patient_notes USING btree (appointment_id) WHERE ((deleted_at IS NULL) AND (appointment_id IS NOT NULL));


--
-- Name: idx_patient_notes_creator; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX idx_patient_notes_creator ON public.patient_notes USING btree (created_by, created_at DESC) WHERE (deleted_at IS NULL);


--
-- Name: idx_patient_notes_org; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX idx_patient_notes_org ON public.patient_notes USING btree (organization_id, created_at DESC) WHERE (deleted_at IS NULL);


--
-- Name: idx_patient_notes_patient; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX idx_patient_notes_patient ON public.patient_notes USING btree (patient_id, created_at DESC) WHERE (deleted_at IS NULL);


--
-- Name: idx_patient_notes_pinned; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX idx_patient_notes_pinned ON public.patient_notes USING btree (patient_id, is_pinned, created_at DESC) WHERE ((deleted_at IS NULL) AND (is_pinned = true));


--
-- Name: idx_patient_notes_type; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX idx_patient_notes_type ON public.patient_notes USING btree (patient_id, note_type) WHERE (deleted_at IS NULL);


--
-- Name: idx_patients_active_category; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX idx_patients_active_category ON public.patients USING btree (organization_id, category, status) WHERE ((deleted_at IS NULL) AND (status = ANY (ARRAY['active'::public.patient_status, 'new'::public.patient_status])));


--
-- Name: idx_patients_active_upcoming; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX idx_patients_active_upcoming ON public.patients USING btree (organization_id, status, next_appointment_date) WHERE ((deleted_at IS NULL) AND (status = 'active'::public.patient_status) AND (next_appointment_date IS NOT NULL));


--
-- Name: idx_patients_ai_appt_opt_gin; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX idx_patients_ai_appt_opt_gin ON public.patients USING gin (ai_appointment_optimization) WHERE (deleted_at IS NULL);


--
-- Name: idx_patients_ai_clinical_gin; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX idx_patients_ai_clinical_gin ON public.patients USING gin (ai_clinical_insights) WHERE (deleted_at IS NULL);


--
-- Name: idx_patients_ai_cost_gin; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX idx_patients_ai_cost_gin ON public.patients USING gin (ai_cost_predictions) WHERE (deleted_at IS NULL);


--
-- Name: idx_patients_ai_insights_gin; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX idx_patients_ai_insights_gin ON public.patients USING gin (ai_insights) WHERE (deleted_at IS NULL);


--
-- Name: idx_patients_ai_predictions_gin; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX idx_patients_ai_predictions_gin ON public.patients USING gin (ai_predictions) WHERE (deleted_at IS NULL);


--
-- Name: idx_patients_ai_preventive_gin; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX idx_patients_ai_preventive_gin ON public.patients USING gin (ai_preventive_care_alerts) WHERE (deleted_at IS NULL);


--
-- Name: idx_patients_ai_risk_gin; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX idx_patients_ai_risk_gin ON public.patients USING gin (ai_risk_assessment) WHERE (deleted_at IS NULL);


--
-- Name: idx_patients_ai_similar_gin; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX idx_patients_ai_similar_gin ON public.patients USING gin (ai_similar_patients) WHERE (deleted_at IS NULL);


--
-- Name: idx_patients_ai_treatment_gin; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX idx_patients_ai_treatment_gin ON public.patients USING gin (ai_treatment_recommendations) WHERE (deleted_at IS NULL);


--
-- Name: idx_patients_alerts_gin; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX idx_patients_alerts_gin ON public.patients USING gin (alerts) WHERE (deleted_at IS NULL);


--
-- Name: idx_patients_allergies_gin; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX idx_patients_allergies_gin ON public.patients USING gin (allergies) WHERE (deleted_at IS NULL);


--
-- Name: idx_patients_blood_type; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX idx_patients_blood_type ON public.patients USING btree (blood_type) WHERE ((deleted_at IS NULL) AND (blood_type IS NOT NULL));


--
-- Name: idx_patients_category; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX idx_patients_category ON public.patients USING btree (organization_id, category) WHERE (deleted_at IS NULL);


--
-- Name: idx_patients_created_at; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX idx_patients_created_at ON public.patients USING btree (created_at DESC) WHERE (deleted_at IS NULL);


--
-- Name: idx_patients_dob; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX idx_patients_dob ON public.patients USING btree (date_of_birth) WHERE (deleted_at IS NULL);


--
-- Name: idx_patients_emails_gin; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX idx_patients_emails_gin ON public.patients USING gin (emails jsonb_path_ops);


--
-- Name: idx_patients_entity_id; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX idx_patients_entity_id ON public.patients USING btree (entity_id) WHERE (deleted_at IS NULL);


--
-- Name: idx_patients_external_id; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX idx_patients_external_id ON public.patients USING btree (external_id) WHERE ((deleted_at IS NULL) AND (external_id IS NOT NULL));


--
-- Name: idx_patients_first_name; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX idx_patients_first_name ON public.patients USING btree (first_name);


--
-- Name: idx_patients_first_visit; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX idx_patients_first_visit ON public.patients USING btree (first_visit_date) WHERE ((deleted_at IS NULL) AND (first_visit_date IS NOT NULL));


--
-- Name: idx_patients_full_name; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX idx_patients_full_name ON public.patients USING btree (first_name, last_name);


--
-- Name: idx_patients_high_risk; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX idx_patients_high_risk ON public.patients USING btree (organization_id, (((ai_risk_assessment ->> 'overall_risk_score'::text))::numeric) DESC) WHERE ((deleted_at IS NULL) AND (ai_risk_assessment ? 'overall_risk_score'::text) AND (((ai_risk_assessment ->> 'overall_risk_score'::text))::numeric > 0.7));


--
-- Name: idx_patients_insurance_gin; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX idx_patients_insurance_gin ON public.patients USING gin (insurance_info) WHERE (deleted_at IS NULL);


--
-- Name: idx_patients_insurance_provider; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX idx_patients_insurance_provider ON public.patients USING btree ((((insurance_info -> 'primary'::text) ->> 'provider'::text))) WHERE ((deleted_at IS NULL) AND (insurance_info ? 'primary'::text));


--
-- Name: idx_patients_language; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX idx_patients_language ON public.patients USING btree (preferred_language) WHERE (deleted_at IS NULL);


--
-- Name: idx_patients_last_name; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX idx_patients_last_name ON public.patients USING btree (last_name);


--
-- Name: idx_patients_last_visit; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX idx_patients_last_visit ON public.patients USING btree (last_visit_date DESC) WHERE (deleted_at IS NULL);


--
-- Name: idx_patients_medical_history_gin; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX idx_patients_medical_history_gin ON public.patients USING gin (medical_history) WHERE (deleted_at IS NULL);


--
-- Name: idx_patients_medications_gin; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX idx_patients_medications_gin ON public.patients USING gin (current_medications) WHERE (deleted_at IS NULL);


--
-- Name: idx_patients_mrn; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX idx_patients_mrn ON public.patients USING btree (organization_id, medical_record_number) WHERE ((deleted_at IS NULL) AND (medical_record_number IS NOT NULL));


--
-- Name: idx_patients_new_recent; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX idx_patients_new_recent ON public.patients USING btree (organization_id, status, created_at DESC) WHERE ((deleted_at IS NULL) AND (status = 'new'::public.patient_status));


--
-- Name: idx_patients_next_appointment; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX idx_patients_next_appointment ON public.patients USING btree (next_appointment_date) WHERE ((deleted_at IS NULL) AND (next_appointment_date IS NOT NULL));


--
-- Name: idx_patients_no_show_prob; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX idx_patients_no_show_prob ON public.patients USING btree ((((ai_predictions ->> 'no_show_probability'::text))::numeric)) WHERE ((deleted_at IS NULL) AND (ai_predictions ? 'no_show_probability'::text));


--
-- Name: idx_patients_org_next_appt; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX idx_patients_org_next_appt ON public.patients USING btree (organization_id, next_appointment_date) WHERE ((deleted_at IS NULL) AND (next_appointment_date IS NOT NULL));


--
-- Name: idx_patients_organization_id; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX idx_patients_organization_id ON public.patients USING btree (organization_id, deleted_at) WHERE (deleted_at IS NULL);


--
-- Name: idx_patients_patient_code; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX idx_patients_patient_code ON public.patients USING btree (organization_id, patient_code) WHERE ((deleted_at IS NULL) AND (patient_code IS NOT NULL));


--
-- Name: idx_patients_phones_gin; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX idx_patients_phones_gin ON public.patients USING gin (phones jsonb_path_ops);


--
-- Name: idx_patients_preferences_gin; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX idx_patients_preferences_gin ON public.patients USING gin (preferences) WHERE (deleted_at IS NULL);


--
-- Name: idx_patients_reminder_pref; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX idx_patients_reminder_pref ON public.patients USING btree (((preferences ->> 'appointment_reminder'::text))) WHERE (deleted_at IS NULL);


--
-- Name: idx_patients_risk_score; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX idx_patients_risk_score ON public.patients USING btree ((((ai_risk_assessment ->> 'overall_risk_score'::text))::numeric)) WHERE ((deleted_at IS NULL) AND (ai_risk_assessment ? 'overall_risk_score'::text));


--
-- Name: idx_patients_status; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX idx_patients_status ON public.patients USING btree (organization_id, status, deleted_at) WHERE (deleted_at IS NULL);


--
-- Name: idx_patients_updated_at; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX idx_patients_updated_at ON public.patients USING btree (updated_at DESC) WHERE (deleted_at IS NULL);


--
-- Name: idx_patients_vertical_fields_gin; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX idx_patients_vertical_fields_gin ON public.patients USING gin (vertical_fields) WHERE (deleted_at IS NULL);


--
-- Name: idx_patients_vip; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX idx_patients_vip ON public.patients USING btree (organization_id, last_visit_date DESC) WHERE ((deleted_at IS NULL) AND (category = 'vip'::public.patient_category));


--
-- Name: idx_positions_dept; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX idx_positions_dept ON public.positions USING btree (department_id);


--
-- Name: idx_positions_job; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX idx_positions_job ON public.positions USING btree (job_id);


--
-- Name: idx_positions_open; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX idx_positions_open ON public.positions USING btree (organization_id, is_open) WHERE (is_open = true);


--
-- Name: idx_positions_org; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX idx_positions_org ON public.positions USING btree (organization_id) WHERE (is_active = true);


--
-- Name: idx_positions_reports_to; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX idx_positions_reports_to ON public.positions USING btree (reports_to_position_id);


--
-- Name: idx_profiles_preferences; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX idx_profiles_preferences ON public.profiles USING btree (notifications_enabled, dark_mode_enabled);


--
-- Name: idx_profiles_timezone; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX idx_profiles_timezone ON public.profiles USING btree (timezone);


--
-- Name: idx_promo_analytics_date; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX idx_promo_analytics_date ON public.promotion_analytics USING btree (promotion_id, date);


--
-- Name: idx_promo_bundle_promotion; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX idx_promo_bundle_promotion ON public.promotion_bundle_items USING btree (promotion_id);


--
-- Name: idx_promo_rule_items_item; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX idx_promo_rule_items_item ON public.promotion_rule_items USING btree (catalog_item_id);


--
-- Name: idx_promo_rules_category; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX idx_promo_rules_category ON public.promotion_rules USING btree (category_id) WHERE (category_id IS NOT NULL);


--
-- Name: idx_promo_rules_promotion; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX idx_promo_rules_promotion ON public.promotion_rules USING btree (promotion_id);


--
-- Name: idx_promo_tiers_promotion; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX idx_promo_tiers_promotion ON public.promotion_tiers USING btree (promotion_id);


--
-- Name: idx_promotions_ai_keywords; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX idx_promotions_ai_keywords ON public.promotions USING gin (ai_keywords) WHERE (is_active = true);


--
-- Name: idx_promotions_code; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX idx_promotions_code ON public.promotions USING btree (promo_code) WHERE ((promo_code IS NOT NULL) AND (is_active = true));


--
-- Name: idx_promotions_dates; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX idx_promotions_dates ON public.promotions USING btree (valid_from, valid_until) WHERE (is_active = true);


--
-- Name: idx_promotions_embedding; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX idx_promotions_embedding ON public.promotions USING ivfflat (embedding extensions.vector_cosine_ops) WITH (lists='50') WHERE ((is_active = true) AND (has_embedding = true));


--
-- Name: idx_promotions_nlu_triggers; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX idx_promotions_nlu_triggers ON public.promotions USING gin (nlu_triggers jsonb_path_ops) WHERE (is_active = true);


--
-- Name: idx_promotions_org_active; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX idx_promotions_org_active ON public.promotions USING btree (organization_id) WHERE (is_active = true);


--
-- Name: idx_promotions_type; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX idx_promotions_type ON public.promotions USING btree (promo_type, organization_id) WHERE (is_active = true);


--
-- Name: idx_promotions_vertical; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX idx_promotions_vertical ON public.promotions USING btree (vertical_code, organization_id) WHERE (is_active = true);


--
-- Name: idx_promotions_vertical_config; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX idx_promotions_vertical_config ON public.promotions USING gin (vertical_config jsonb_path_ops) WHERE (is_active = true);


--
-- Name: idx_provider_schedules_provider; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX idx_provider_schedules_provider ON public.provider_schedules USING btree (provider_entity_id, day_of_week, is_available);


--
-- Name: idx_provider_skills_expiring; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX idx_provider_skills_expiring ON public.provider_skills USING btree (certification_expires_at) WHERE (certification_expires_at IS NOT NULL);


--
-- Name: idx_provider_skills_provider; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX idx_provider_skills_provider ON public.provider_skills USING btree (provider_entity_id);


--
-- Name: idx_provider_skills_skill; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX idx_provider_skills_skill ON public.provider_skills USING btree (skill_id, proficiency_level);


--
-- Name: idx_resource_availability_org; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX idx_resource_availability_org ON public.resource_availability USING btree (organization_id, resource_type, is_active);


--
-- Name: idx_resource_availability_resource; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX idx_resource_availability_resource ON public.resource_availability USING btree (resource_entity_id, day_of_week, is_active) WHERE (is_active = true);


--
-- Name: idx_resource_unavailability_dates; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX idx_resource_unavailability_dates ON public.resource_unavailability USING btree (unavailable_from, unavailable_until) WHERE (is_active = true);


--
-- Name: idx_resource_unavailability_resource; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX idx_resource_unavailability_resource ON public.resource_unavailability USING btree (resource_entity_id, unavailable_from, unavailable_until) WHERE (is_active = true);


--
-- Name: idx_roles_level; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX idx_roles_level ON public.roles USING btree (level DESC);


--
-- Name: idx_roles_organization; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX idx_roles_organization ON public.roles USING btree (organization_id);


--
-- Name: idx_roles_permissions_gin; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX idx_roles_permissions_gin ON public.roles USING gin (permissions);


--
-- Name: idx_roles_system; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX idx_roles_system ON public.roles USING btree (is_system);


--
-- Name: idx_schedule_exceptions_date; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX idx_schedule_exceptions_date ON public.provider_schedule_exceptions USING btree (exception_date, end_date);


--
-- Name: idx_schedule_exceptions_provider; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX idx_schedule_exceptions_provider ON public.provider_schedule_exceptions USING btree (provider_entity_id, exception_date);


--
-- Name: idx_scheduled_shifts_dept_date; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX idx_scheduled_shifts_dept_date ON public.scheduled_shifts USING btree (department_id, shift_date);


--
-- Name: idx_scheduled_shifts_employee_date; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX idx_scheduled_shifts_employee_date ON public.scheduled_shifts USING btree (employee_id, shift_date);


--
-- Name: idx_scheduled_shifts_org_date; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX idx_scheduled_shifts_org_date ON public.scheduled_shifts USING btree (organization_id, shift_date);


--
-- Name: idx_scheduled_shifts_template; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX idx_scheduled_shifts_template ON public.scheduled_shifts USING btree (shift_template_id);


--
-- Name: idx_scheduled_shifts_unpublished; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX idx_scheduled_shifts_unpublished ON public.scheduled_shifts USING btree (organization_id, shift_date) WHERE (is_published = false);


--
-- Name: idx_service_providers_provider; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX idx_service_providers_provider ON public.service_providers USING btree (provider_entity_id, is_available);


--
-- Name: idx_service_providers_service; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX idx_service_providers_service ON public.service_providers USING btree (service_id, is_available);


--
-- Name: idx_services_category; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX idx_services_category ON public.services USING btree (category, organization_id) WHERE (is_active = true);


--
-- Name: idx_services_org; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX idx_services_org ON public.services USING btree (organization_id, is_active);


--
-- Name: idx_shift_templates_org; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX idx_shift_templates_org ON public.shift_templates USING btree (organization_id) WHERE (is_active = true);


--
-- Name: idx_shift_templates_type; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX idx_shift_templates_type ON public.shift_templates USING btree (shift_type, organization_id);


--
-- Name: idx_skill_access_modules_gin; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX idx_skill_access_modules_gin ON public.skill_access USING gin (modules);


--
-- Name: idx_skill_access_role; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX idx_skill_access_role ON public.skill_access USING btree (role_key);


--
-- Name: idx_skill_access_skill; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX idx_skill_access_skill ON public.skill_access USING btree (skill_id);


--
-- Name: idx_skill_access_verticals_gin; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX idx_skill_access_verticals_gin ON public.skill_access USING gin (verticals);


--
-- Name: idx_skill_definitions_category; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX idx_skill_definitions_category ON public.skill_definitions USING btree (category, organization_id);


--
-- Name: idx_skill_definitions_has_embedding; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX idx_skill_definitions_has_embedding ON public.skill_definitions USING btree (has_embedding) WHERE (has_embedding = true);


--
-- Name: idx_skill_definitions_org; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX idx_skill_definitions_org ON public.skill_definitions USING btree (organization_id) WHERE (is_active = true);


--
-- Name: idx_skill_definitions_path_gist; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX idx_skill_definitions_path_gist ON public.skill_definitions USING gist (path);


--
-- Name: idx_skill_executions_conversation; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX idx_skill_executions_conversation ON public.ai_skill_executions USING btree (conversation_id) WHERE (conversation_id IS NOT NULL);


--
-- Name: idx_skill_executions_org; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX idx_skill_executions_org ON public.ai_skill_executions USING btree (organization_id, created_at DESC);


--
-- Name: idx_skill_executions_pending; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX idx_skill_executions_pending ON public.ai_skill_executions USING btree (status) WHERE (status = ANY (ARRAY['pending'::public.skill_execution_status, 'pending_approval'::public.skill_execution_status]));


--
-- Name: idx_skill_executions_skill; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX idx_skill_executions_skill ON public.ai_skill_executions USING btree (skill_id, status);


--
-- Name: idx_skill_executions_user; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX idx_skill_executions_user ON public.ai_skill_executions USING btree (user_id, created_at DESC);


--
-- Name: idx_subscriptions_org; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX idx_subscriptions_org ON public.subscriptions USING btree (organization_id);


--
-- Name: idx_subscriptions_plan; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX idx_subscriptions_plan ON public.subscriptions USING btree (plan_key);


--
-- Name: idx_subscriptions_status; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX idx_subscriptions_status ON public.subscriptions USING btree (status);


--
-- Name: idx_subscriptions_trial_ends; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX idx_subscriptions_trial_ends ON public.subscriptions USING btree (trial_ends_at) WHERE (status = 'trial'::text);


--
-- Name: idx_time_entries_date_type; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX idx_time_entries_date_type ON public.time_entries USING btree (entry_date, entry_type) WHERE (deleted_at IS NULL);


--
-- Name: idx_time_entries_department; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX idx_time_entries_department ON public.time_entries USING btree (department_id, entry_date) WHERE (deleted_at IS NULL);


--
-- Name: idx_time_entries_employee_date; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX idx_time_entries_employee_date ON public.time_entries USING btree (employee_id, entry_date) WHERE (deleted_at IS NULL);


--
-- Name: idx_time_entries_needs_approval; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX idx_time_entries_needs_approval ON public.time_entries USING btree (organization_id, entry_date) WHERE ((requires_approval = true) AND (is_approved IS NULL) AND (deleted_at IS NULL));


--
-- Name: idx_time_entries_org_date; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX idx_time_entries_org_date ON public.time_entries USING btree (organization_id, entry_date) WHERE (deleted_at IS NULL);


--
-- Name: idx_time_entries_unprocessed; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX idx_time_entries_unprocessed ON public.time_entries USING btree (employee_id, entry_date) WHERE ((is_processed = false) AND (deleted_at IS NULL));


--
-- Name: idx_time_entry_mods_date; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX idx_time_entry_mods_date ON public.time_entry_modifications USING btree (modified_at);


--
-- Name: idx_time_entry_mods_entry; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX idx_time_entry_mods_entry ON public.time_entry_modifications USING btree (time_entry_id);


--
-- Name: idx_time_entry_mods_user; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX idx_time_entry_mods_user ON public.time_entry_modifications USING btree (modified_by);


--
-- Name: idx_user_sessions_active_org; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX idx_user_sessions_active_org ON public.user_sessions USING btree (active_org_id);


--
-- Name: idx_user_sessions_last_activity; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX idx_user_sessions_last_activity ON public.user_sessions USING btree (last_activity_at);


--
-- Name: idx_vertical_configs_config_gin; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX idx_vertical_configs_config_gin ON public.vertical_configs USING gin (config jsonb_path_ops);


--
-- Name: idx_vertical_configs_org; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX idx_vertical_configs_org ON public.vertical_configs USING btree (organization_id) WHERE (is_active = true);


--
-- Name: idx_vertical_configs_vertical; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX idx_vertical_configs_vertical ON public.vertical_configs USING btree (vertical) WHERE (is_active = true);


--
-- Name: idx_waitlist_added_at; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX idx_waitlist_added_at ON public.waitlist_entries USING btree (added_at);


--
-- Name: idx_waitlist_client; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX idx_waitlist_client ON public.waitlist_entries USING btree (client_entity_id);


--
-- Name: idx_waitlist_date; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX idx_waitlist_date ON public.waitlist_entries USING btree (requested_date);


--
-- Name: idx_waitlist_location; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX idx_waitlist_location ON public.waitlist_entries USING btree (location_id);


--
-- Name: idx_waitlist_org; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX idx_waitlist_org ON public.waitlist_entries USING btree (organization_id);


--
-- Name: idx_waitlist_priority; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX idx_waitlist_priority ON public.waitlist_entries USING btree (priority, added_at);


--
-- Name: idx_waitlist_service; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX idx_waitlist_service ON public.waitlist_entries USING btree (service_id);


--
-- Name: idx_waitlist_status; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX idx_waitlist_status ON public.waitlist_entries USING btree (status);


--
-- Name: idx_walkin_arrived; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX idx_walkin_arrived ON public.walkin_entries USING btree (arrived_at);


--
-- Name: idx_walkin_location; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX idx_walkin_location ON public.walkin_entries USING btree (location_id);


--
-- Name: idx_walkin_org; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX idx_walkin_org ON public.walkin_entries USING btree (organization_id);


--
-- Name: idx_walkin_queue; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX idx_walkin_queue ON public.walkin_entries USING btree (location_id, status, queue_position);


--
-- Name: idx_walkin_status; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX idx_walkin_status ON public.walkin_entries USING btree (status);


--
-- Name: idx_whatsapp_conversations_entity; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX idx_whatsapp_conversations_entity ON public.whatsapp_conversations USING btree (entity_id) WHERE (deleted_at IS NULL);


--
-- Name: idx_whatsapp_conversations_flow_state; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX idx_whatsapp_conversations_flow_state ON public.whatsapp_conversations USING gin (flow_state);


--
-- Name: idx_whatsapp_conversations_org; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX idx_whatsapp_conversations_org ON public.whatsapp_conversations USING btree (organization_id) WHERE (deleted_at IS NULL);


--
-- Name: idx_whatsapp_conversations_pending_action; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX idx_whatsapp_conversations_pending_action ON public.whatsapp_conversations USING btree (((pending_action IS NOT NULL))) WHERE (pending_action IS NOT NULL);


--
-- Name: idx_whatsapp_conversations_phone; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX idx_whatsapp_conversations_phone ON public.whatsapp_conversations USING btree (phone_number) WHERE (deleted_at IS NULL);


--
-- Name: idx_whatsapp_conversations_updated; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX idx_whatsapp_conversations_updated ON public.whatsapp_conversations USING btree (last_message_at DESC) WHERE (deleted_at IS NULL);


--
-- Name: idx_whatsapp_messages_conversation; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX idx_whatsapp_messages_conversation ON public.whatsapp_messages USING btree (conversation_id, sent_at DESC);


--
-- Name: idx_whatsapp_messages_direction; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX idx_whatsapp_messages_direction ON public.whatsapp_messages USING btree (direction, sent_at DESC);


--
-- Name: idx_whatsapp_messages_provider; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX idx_whatsapp_messages_provider ON public.whatsapp_messages USING btree (provider_message_id) WHERE (provider_message_id IS NOT NULL);


--
-- Name: idx_whatsapp_messages_status; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX idx_whatsapp_messages_status ON public.whatsapp_messages USING btree (provider_status) WHERE (direction = 'outbound'::text);


--
-- Name: idx_whatsapp_messages_type; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX idx_whatsapp_messages_type ON public.whatsapp_messages USING btree (message_type, created_at DESC);


--
-- Name: idx_whatsapp_org_config_org; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX idx_whatsapp_org_config_org ON public.whatsapp_org_config USING btree (organization_id);


--
-- Name: idx_work_policies_default; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX idx_work_policies_default ON public.work_policies USING btree (organization_id, is_default) WHERE (is_default = true);


--
-- Name: idx_work_policies_org; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX idx_work_policies_org ON public.work_policies USING btree (organization_id);


--
-- Name: inventory_org_idx; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX inventory_org_idx ON public.inventory USING btree (organization_id);


--
-- Name: inventory_product_idx; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX inventory_product_idx ON public.inventory USING btree (product_id);


--
-- Name: orders_org_idx; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX orders_org_idx ON public.orders USING btree (organization_id);


--
-- Name: orders_status_idx; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX orders_status_idx ON public.orders USING btree (status);


--
-- Name: patients_embedding_idx; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX patients_embedding_idx ON public.patients USING ivfflat (embedding extensions.vector_cosine_ops) WITH (lists='100') WHERE (embedding IS NOT NULL);


--
-- Name: products_name_trgm_idx; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX products_name_trgm_idx ON public.products USING gin (product_name extensions.gin_trgm_ops);


--
-- Name: products_org_idx; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX products_org_idx ON public.products USING btree (organization_id);


--
-- Name: profiles_active_idx; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX profiles_active_idx ON public.profiles USING btree (is_active) WHERE (deleted_at IS NULL);


--
-- Name: profiles_deleted_idx; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX profiles_deleted_idx ON public.profiles USING btree (deleted_at) WHERE (deleted_at IS NOT NULL);


--
-- Name: profiles_role_idx; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX profiles_role_idx ON public.profiles USING btree (role);


--
-- Name: services_embedding_idx; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX services_embedding_idx ON public.services USING ivfflat (embedding extensions.vector_cosine_ops) WITH (lists='100') WHERE (embedding IS NOT NULL);


--
-- Name: idx_embedding_dlq_created; Type: INDEX; Schema: util; Owner: -
--

CREATE INDEX idx_embedding_dlq_created ON util.embedding_dead_letter_queue USING btree (created_at DESC);


--
-- Name: idx_embedding_dlq_source; Type: INDEX; Schema: util; Owner: -
--

CREATE INDEX idx_embedding_dlq_source ON util.embedding_dead_letter_queue USING btree (source_table, source_id);


--
-- Name: idx_embedding_dlq_status; Type: INDEX; Schema: util; Owner: -
--

CREATE INDEX idx_embedding_dlq_status ON util.embedding_dead_letter_queue USING btree (status);


--
-- Name: idx_embedding_history_created; Type: INDEX; Schema: util; Owner: -
--

CREATE INDEX idx_embedding_history_created ON util.embedding_job_history USING btree (created_at DESC);


--
-- Name: idx_embedding_history_source; Type: INDEX; Schema: util; Owner: -
--

CREATE INDEX idx_embedding_history_source ON util.embedding_job_history USING btree (source_table, created_at DESC);


--
-- Name: idx_embedding_history_status; Type: INDEX; Schema: util; Owner: -
--

CREATE INDEX idx_embedding_history_status ON util.embedding_job_history USING btree (status, created_at DESC);


--
-- Name: idx_embedding_metrics_hour; Type: INDEX; Schema: util; Owner: -
--

CREATE INDEX idx_embedding_metrics_hour ON util.embedding_metrics_hourly USING btree (hour DESC);


--
-- Name: catalog_items ai_auto_embed_catalog_items; Type: TRIGGER; Schema: public; Owner: -
--

CREATE TRIGGER ai_auto_embed_catalog_items AFTER INSERT OR UPDATE ON public.catalog_items FOR EACH ROW EXECUTE FUNCTION public.ai_generic_queue_embedding();


--
-- Name: appointments appointment_audit_trigger; Type: TRIGGER; Schema: public; Owner: -
--

CREATE TRIGGER appointment_audit_trigger AFTER INSERT OR UPDATE ON public.appointments FOR EACH ROW EXECUTE FUNCTION app.log_appointment_change();


--
-- Name: appointments clear_appointments_embedding_on_update; Type: TRIGGER; Schema: public; Owner: -
--

CREATE TRIGGER clear_appointments_embedding_on_update BEFORE UPDATE OF client_entity_id, resource_entity_id, catalog_item_id, catalog_item_name, appointment_date, start_time, end_time, status, notes, tags, cancellation_reason ON public.appointments FOR EACH ROW EXECUTE FUNCTION util.clear_column('embedding');


--
-- Name: catalog_categories clear_catalog_categories_embedding_on_update; Type: TRIGGER; Schema: public; Owner: -
--

CREATE TRIGGER clear_catalog_categories_embedding_on_update BEFORE UPDATE OF name, slug, description, path ON public.catalog_categories FOR EACH ROW EXECUTE FUNCTION util.clear_column('embedding');


--
-- Name: catalog_items clear_catalog_items_embedding_on_update; Type: TRIGGER; Schema: public; Owner: -
--

CREATE TRIGGER clear_catalog_items_embedding_on_update BEFORE UPDATE OF name, description, item_code, internal_reference, barcode, tags, category_id, base_price, duration_minutes, is_active, is_published, attributes, vertical_config ON public.catalog_items FOR EACH ROW EXECUTE FUNCTION util.clear_column('embedding');


--
-- Name: employees clear_employees_embedding_on_update; Type: TRIGGER; Schema: public; Owner: -
--

CREATE TRIGGER clear_employees_embedding_on_update BEFORE UPDATE OF "position", department, skills, custom_fields, employment_status ON public.employees FOR EACH ROW EXECUTE FUNCTION util.clear_column('embedding');


--
-- Name: entities clear_entities_embedding_on_update; Type: TRIGGER; Schema: public; Owner: -
--

CREATE TRIGGER clear_entities_embedding_on_update BEFORE UPDATE OF display_name, person_subtype, email, phone, custom_fields, notes, status ON public.entities FOR EACH ROW EXECUTE FUNCTION util.clear_column('embedding');


--
-- Name: org_knowledge_base clear_knowledge_embedding_on_update; Type: TRIGGER; Schema: public; Owner: -
--

CREATE TRIGGER clear_knowledge_embedding_on_update BEFORE UPDATE OF content, title, tags ON public.org_knowledge_base FOR EACH ROW EXECUTE FUNCTION util.clear_column('embedding');


--
-- Name: patients clear_patients_embedding_on_update; Type: TRIGGER; Schema: public; Owner: -
--

CREATE TRIGGER clear_patients_embedding_on_update BEFORE UPDATE OF vertical_fields, medical_history, allergies, current_medications, blood_type, category, status ON public.patients FOR EACH ROW EXECUTE FUNCTION util.clear_column('embedding');


--
-- Name: services clear_services_embedding_on_update; Type: TRIGGER; Schema: public; Owner: -
--

CREATE TRIGGER clear_services_embedding_on_update BEFORE UPDATE OF service_name, description, category, custom_fields, base_price, default_duration_minutes ON public.services FOR EACH ROW EXECUTE FUNCTION util.clear_column('embedding');


--
-- Name: skill_definitions clear_skill_definitions_embedding_on_update; Type: TRIGGER; Schema: public; Owner: -
--

CREATE TRIGGER clear_skill_definitions_embedding_on_update BEFORE UPDATE OF display_name, skill_code, description, category, requires_certification, certification_authority, applicable_verticals ON public.skill_definitions FOR EACH ROW EXECUTE FUNCTION util.clear_column('embedding');


--
-- Name: clients clients_updated_at; Type: TRIGGER; Schema: public; Owner: -
--

CREATE TRIGGER clients_updated_at BEFORE UPDATE ON public.clients FOR EACH ROW EXECUTE FUNCTION public.update_updated_at_column();


--
-- Name: appointments embed_appointments_on_insert; Type: TRIGGER; Schema: public; Owner: -
--

CREATE TRIGGER embed_appointments_on_insert AFTER INSERT ON public.appointments FOR EACH ROW EXECUTE FUNCTION util.queue_embeddings('appointments_embedding_content', 'embedding');


--
-- Name: appointments embed_appointments_on_update; Type: TRIGGER; Schema: public; Owner: -
--

CREATE TRIGGER embed_appointments_on_update AFTER UPDATE OF embedding ON public.appointments FOR EACH ROW WHEN (((old.embedding IS NOT NULL) AND (new.embedding IS NULL))) EXECUTE FUNCTION util.queue_embeddings('appointments_embedding_content', 'embedding');


--
-- Name: catalog_categories embed_catalog_categories_on_insert; Type: TRIGGER; Schema: public; Owner: -
--

CREATE TRIGGER embed_catalog_categories_on_insert AFTER INSERT ON public.catalog_categories FOR EACH ROW EXECUTE FUNCTION util.queue_embeddings('catalog_categories_embedding_content', 'embedding');


--
-- Name: catalog_categories embed_catalog_categories_on_update; Type: TRIGGER; Schema: public; Owner: -
--

CREATE TRIGGER embed_catalog_categories_on_update AFTER UPDATE OF name, slug, description, path ON public.catalog_categories FOR EACH ROW EXECUTE FUNCTION util.queue_embeddings('catalog_categories_embedding_content', 'embedding');


--
-- Name: catalog_items embed_catalog_items_on_insert; Type: TRIGGER; Schema: public; Owner: -
--

CREATE TRIGGER embed_catalog_items_on_insert AFTER INSERT ON public.catalog_items FOR EACH ROW EXECUTE FUNCTION util.queue_embeddings('catalog_items_embedding_content', 'embedding');


--
-- Name: catalog_items embed_catalog_items_on_update; Type: TRIGGER; Schema: public; Owner: -
--

CREATE TRIGGER embed_catalog_items_on_update AFTER UPDATE OF name, description, item_code, internal_reference, barcode, tags, category_id, base_price, duration_minutes, is_active, is_published, attributes, vertical_config ON public.catalog_items FOR EACH ROW EXECUTE FUNCTION util.queue_embeddings('catalog_items_embedding_content', 'embedding');


--
-- Name: employees embed_employees_on_insert; Type: TRIGGER; Schema: public; Owner: -
--

CREATE TRIGGER embed_employees_on_insert AFTER INSERT ON public.employees FOR EACH ROW EXECUTE FUNCTION util.queue_embeddings_with_ai('employees_embedding_content', 'embedding', 'true', 'employee');


--
-- Name: employees embed_employees_on_update; Type: TRIGGER; Schema: public; Owner: -
--

CREATE TRIGGER embed_employees_on_update AFTER UPDATE OF "position", department, skills, custom_fields, employment_status ON public.employees FOR EACH ROW EXECUTE FUNCTION util.queue_embeddings_with_ai('employees_embedding_content', 'embedding', 'true', 'employee');


--
-- Name: entities embed_entities_on_insert; Type: TRIGGER; Schema: public; Owner: -
--

CREATE TRIGGER embed_entities_on_insert AFTER INSERT ON public.entities FOR EACH ROW EXECUTE FUNCTION util.queue_embeddings('entities_embedding_content', 'embedding');


--
-- Name: entities embed_entities_on_update; Type: TRIGGER; Schema: public; Owner: -
--

CREATE TRIGGER embed_entities_on_update AFTER UPDATE OF display_name, person_subtype, email, phone, custom_fields, notes, status ON public.entities FOR EACH ROW EXECUTE FUNCTION util.queue_embeddings('entities_embedding_content', 'embedding');


--
-- Name: org_knowledge_base embed_knowledge_on_insert; Type: TRIGGER; Schema: public; Owner: -
--

CREATE TRIGGER embed_knowledge_on_insert AFTER INSERT ON public.org_knowledge_base FOR EACH ROW EXECUTE FUNCTION util.queue_embeddings('org_knowledge_base_embedding_content', 'embedding');


--
-- Name: org_knowledge_base embed_knowledge_on_update; Type: TRIGGER; Schema: public; Owner: -
--

CREATE TRIGGER embed_knowledge_on_update AFTER UPDATE OF embedding ON public.org_knowledge_base FOR EACH ROW WHEN (((old.embedding IS NOT NULL) AND (new.embedding IS NULL))) EXECUTE FUNCTION util.queue_embeddings('org_knowledge_base_embedding_content', 'embedding');


--
-- Name: patients embed_patients_on_insert; Type: TRIGGER; Schema: public; Owner: -
--

CREATE TRIGGER embed_patients_on_insert AFTER INSERT ON public.patients FOR EACH ROW EXECUTE FUNCTION util.queue_embeddings_with_ai('patients_embedding_content', 'embedding', 'true', 'patient');


--
-- Name: patients embed_patients_on_update; Type: TRIGGER; Schema: public; Owner: -
--

CREATE TRIGGER embed_patients_on_update AFTER UPDATE OF vertical_fields, medical_history, allergies, current_medications, blood_type, category, status ON public.patients FOR EACH ROW EXECUTE FUNCTION util.queue_embeddings_with_ai('patients_embedding_content', 'embedding', 'true', 'patient');


--
-- Name: services embed_services_on_insert; Type: TRIGGER; Schema: public; Owner: -
--

CREATE TRIGGER embed_services_on_insert AFTER INSERT ON public.services FOR EACH ROW EXECUTE FUNCTION util.queue_embeddings('services_embedding_content', 'embedding');


--
-- Name: services embed_services_on_update; Type: TRIGGER; Schema: public; Owner: -
--

CREATE TRIGGER embed_services_on_update AFTER UPDATE OF service_name, description, category, custom_fields, base_price, default_duration_minutes ON public.services FOR EACH ROW EXECUTE FUNCTION util.queue_embeddings('services_embedding_content', 'embedding');


--
-- Name: skill_definitions embed_skill_definitions_on_insert; Type: TRIGGER; Schema: public; Owner: -
--

CREATE TRIGGER embed_skill_definitions_on_insert AFTER INSERT ON public.skill_definitions FOR EACH ROW EXECUTE FUNCTION util.queue_embeddings('skill_definitions_embedding_content', 'embedding');


--
-- Name: skill_definitions embed_skill_definitions_on_update; Type: TRIGGER; Schema: public; Owner: -
--

CREATE TRIGGER embed_skill_definitions_on_update AFTER UPDATE OF display_name, skill_code, description, category, requires_certification, certification_authority, applicable_verticals ON public.skill_definitions FOR EACH ROW EXECUTE FUNCTION util.queue_embeddings('skill_definitions_embedding_content', 'embedding');


--
-- Name: entity_ai_traits entity_ai_traits_refresh_count; Type: TRIGGER; Schema: public; Owner: -
--

CREATE TRIGGER entity_ai_traits_refresh_count BEFORE UPDATE ON public.entity_ai_traits FOR EACH ROW WHEN (((new.ai_no_show_risk IS DISTINCT FROM old.ai_no_show_risk) OR (new.ai_churn_risk IS DISTINCT FROM old.ai_churn_risk) OR (new.ai_service_recommendations IS DISTINCT FROM old.ai_service_recommendations))) EXECUTE FUNCTION public.increment_ai_refresh_count();


--
-- Name: nlu_heuristic_rules heuristic_rules_updated_at; Type: TRIGGER; Schema: public; Owner: -
--

CREATE TRIGGER heuristic_rules_updated_at BEFORE UPDATE ON public.nlu_heuristic_rules FOR EACH ROW EXECUTE FUNCTION public.update_heuristic_rules_timestamp();


--
-- Name: llm_prompts llm_prompts_updated_at; Type: TRIGGER; Schema: public; Owner: -
--

CREATE TRIGGER llm_prompts_updated_at BEFORE UPDATE ON public.llm_prompts FOR EACH ROW EXECUTE FUNCTION public.update_llm_prompts_updated_at();


--
-- Name: organizations on_organization_created_add_defaults; Type: TRIGGER; Schema: public; Owner: -
--

CREATE TRIGGER on_organization_created_add_defaults AFTER INSERT ON public.organizations FOR EACH ROW EXECUTE FUNCTION public.create_default_organization_templates();


--
-- Name: patient_notes patient_notes_updated_at; Type: TRIGGER; Schema: public; Owner: -
--

CREATE TRIGGER patient_notes_updated_at BEFORE UPDATE ON public.patient_notes FOR EACH ROW EXECUTE FUNCTION public.update_patient_notes_updated_at();


--
-- Name: entity_relationships set_entity_relationships_updated_at; Type: TRIGGER; Schema: public; Owner: -
--

CREATE TRIGGER set_entity_relationships_updated_at BEFORE UPDATE ON public.entity_relationships FOR EACH ROW EXECUTE FUNCTION public.update_updated_at_column();


--
-- Name: patients set_patients_updated_at; Type: TRIGGER; Schema: public; Owner: -
--

CREATE TRIGGER set_patients_updated_at BEFORE UPDATE ON public.patients FOR EACH ROW EXECUTE FUNCTION public.update_updated_at_column();


--
-- Name: resource_capability_availability tr_availability_updated_at; Type: TRIGGER; Schema: public; Owner: -
--

CREATE TRIGGER tr_availability_updated_at BEFORE UPDATE ON public.resource_capability_availability FOR EACH ROW EXECUTE FUNCTION public.capabilities_updated_at();


--
-- Name: resource_capabilities tr_capabilities_updated_at; Type: TRIGGER; Schema: public; Owner: -
--

CREATE TRIGGER tr_capabilities_updated_at BEFORE UPDATE ON public.resource_capabilities FOR EACH ROW EXECUTE FUNCTION public.capabilities_updated_at();


--
-- Name: patients tr_set_patient_code; Type: TRIGGER; Schema: public; Owner: -
--

CREATE TRIGGER tr_set_patient_code BEFORE INSERT ON public.patients FOR EACH ROW EXECUTE FUNCTION public.trigger_set_patient_code();


--
-- Name: resource_capabilities tr_sync_proficiency_score; Type: TRIGGER; Schema: public; Owner: -
--

CREATE TRIGGER tr_sync_proficiency_score BEFORE UPDATE ON public.resource_capabilities FOR EACH ROW EXECUTE FUNCTION public.sync_proficiency_score();


--
-- Name: resource_capability_availability tr_validate_days_of_week; Type: TRIGGER; Schema: public; Owner: -
--

CREATE TRIGGER tr_validate_days_of_week BEFORE INSERT OR UPDATE ON public.resource_capability_availability FOR EACH ROW EXECUTE FUNCTION public.validate_days_of_week();


--
-- Name: bot_messages trg_bot_messages_updated_at; Type: TRIGGER; Schema: public; Owner: -
--

CREATE TRIGGER trg_bot_messages_updated_at BEFORE UPDATE ON public.bot_messages FOR EACH ROW EXECUTE FUNCTION public.update_bot_messages_updated_at();


--
-- Name: business_hours trg_business_hours_updated; Type: TRIGGER; Schema: public; Owner: -
--

CREATE TRIGGER trg_business_hours_updated BEFORE UPDATE ON public.business_hours FOR EACH ROW EXECUTE FUNCTION public.update_business_hours_timestamp();


--
-- Name: catalog_categories trg_catalog_categories_path; Type: TRIGGER; Schema: public; Owner: -
--

CREATE TRIGGER trg_catalog_categories_path BEFORE INSERT OR UPDATE OF parent_id ON public.catalog_categories FOR EACH ROW EXECUTE FUNCTION public.catalog_categories_maintain_path();


--
-- Name: catalog_items trg_catalog_items_embedding_text; Type: TRIGGER; Schema: public; Owner: -
--

CREATE TRIGGER trg_catalog_items_embedding_text BEFORE INSERT OR UPDATE OF name, description, tags ON public.catalog_items FOR EACH ROW EXECUTE FUNCTION public.catalog_items_update_embedding_text();


--
-- Name: catalog_items trg_catalog_items_search_vector; Type: TRIGGER; Schema: public; Owner: -
--

CREATE TRIGGER trg_catalog_items_search_vector BEFORE INSERT OR UPDATE OF name, display_name, description, ai_generated_description, tags, attributes ON public.catalog_items FOR EACH ROW EXECUTE FUNCTION public.catalog_items_search_vector_trigger();


--
-- Name: daily_time_summary trg_daily_time_summary_updated; Type: TRIGGER; Schema: public; Owner: -
--

CREATE TRIGGER trg_daily_time_summary_updated BEFORE UPDATE ON public.daily_time_summary FOR EACH ROW EXECUTE FUNCTION public.update_daily_time_summary_timestamp();


--
-- Name: departments trg_departments_path; Type: TRIGGER; Schema: public; Owner: -
--

CREATE TRIGGER trg_departments_path BEFORE INSERT OR UPDATE OF parent_department_id ON public.departments FOR EACH ROW EXECUTE FUNCTION public.calculate_department_path();


--
-- Name: departments trg_departments_updated; Type: TRIGGER; Schema: public; Owner: -
--

CREATE TRIGGER trg_departments_updated BEFORE UPDATE ON public.departments FOR EACH ROW EXECUTE FUNCTION public.update_departments_timestamp();


--
-- Name: employees trg_employee_work_schedule_sync; Type: TRIGGER; Schema: public; Owner: -
--

CREATE TRIGGER trg_employee_work_schedule_sync AFTER UPDATE OF work_schedule ON public.employees FOR EACH ROW EXECUTE FUNCTION public.trigger_sync_work_schedule();


--
-- Name: employees trg_employee_work_schedule_sync_insert; Type: TRIGGER; Schema: public; Owner: -
--

CREATE TRIGGER trg_employee_work_schedule_sync_insert AFTER INSERT ON public.employees FOR EACH ROW EXECUTE FUNCTION public.trigger_sync_work_schedule_insert();


--
-- Name: entity_identification_documents trg_entity_docs_updated; Type: TRIGGER; Schema: public; Owner: -
--

CREATE TRIGGER trg_entity_docs_updated BEFORE UPDATE ON public.entity_identification_documents FOR EACH ROW EXECUTE FUNCTION public.update_entity_party_updated_at();


--
-- Name: entity_insurance_policies trg_entity_insurance_updated; Type: TRIGGER; Schema: public; Owner: -
--

CREATE TRIGGER trg_entity_insurance_updated BEFORE UPDATE ON public.entity_insurance_policies FOR EACH ROW EXECUTE FUNCTION public.update_entity_party_updated_at();


--
-- Name: jobs trg_jobs_updated; Type: TRIGGER; Schema: public; Owner: -
--

CREATE TRIGGER trg_jobs_updated BEFORE UPDATE ON public.jobs FOR EACH ROW EXECUTE FUNCTION public.update_jobs_timestamp();


--
-- Name: leave_balances trg_leave_balances_updated; Type: TRIGGER; Schema: public; Owner: -
--

CREATE TRIGGER trg_leave_balances_updated BEFORE UPDATE ON public.leave_balances FOR EACH ROW EXECUTE FUNCTION public.update_leave_balances_timestamp();


--
-- Name: leave_requests trg_leave_requests_updated; Type: TRIGGER; Schema: public; Owner: -
--

CREATE TRIGGER trg_leave_requests_updated BEFORE UPDATE ON public.leave_requests FOR EACH ROW EXECUTE FUNCTION public.update_leave_requests_timestamp();


--
-- Name: leave_types trg_leave_types_updated; Type: TRIGGER; Schema: public; Owner: -
--

CREATE TRIGGER trg_leave_types_updated BEFORE UPDATE ON public.leave_types FOR EACH ROW EXECUTE FUNCTION public.update_leave_types_timestamp();


--
-- Name: nlu_intent_examples trg_nlu_intent_examples_updated_at; Type: TRIGGER; Schema: public; Owner: -
--

CREATE TRIGGER trg_nlu_intent_examples_updated_at BEFORE UPDATE ON public.nlu_intent_examples FOR EACH ROW EXECUTE FUNCTION public.update_nlu_intent_examples_updated_at();


--
-- Name: promotions trg_promotions_embedding_text; Type: TRIGGER; Schema: public; Owner: -
--

CREATE TRIGGER trg_promotions_embedding_text BEFORE INSERT OR UPDATE OF name, description, ai_summary, promo_code, ai_keywords ON public.promotions FOR EACH ROW EXECUTE FUNCTION public.promotions_update_embedding_text();


--
-- Name: scheduled_shifts trg_scheduled_shifts_updated; Type: TRIGGER; Schema: public; Owner: -
--

CREATE TRIGGER trg_scheduled_shifts_updated BEFORE UPDATE ON public.scheduled_shifts FOR EACH ROW EXECUTE FUNCTION public.update_scheduled_shifts_timestamp();


--
-- Name: shift_templates trg_shift_templates_updated; Type: TRIGGER; Schema: public; Owner: -
--

CREATE TRIGGER trg_shift_templates_updated BEFORE UPDATE ON public.shift_templates FOR EACH ROW EXECUTE FUNCTION public.update_shift_templates_timestamp();


--
-- Name: entity_identification_documents trg_single_primary_doc; Type: TRIGGER; Schema: public; Owner: -
--

CREATE TRIGGER trg_single_primary_doc BEFORE INSERT OR UPDATE OF is_primary ON public.entity_identification_documents FOR EACH ROW WHEN ((new.is_primary = true)) EXECUTE FUNCTION public.ensure_single_primary_document();


--
-- Name: entity_insurance_policies trg_single_primary_insurance; Type: TRIGGER; Schema: public; Owner: -
--

CREATE TRIGGER trg_single_primary_insurance BEFORE INSERT OR UPDATE OF is_primary ON public.entity_insurance_policies FOR EACH ROW WHEN ((new.is_primary = true)) EXECUTE FUNCTION public.ensure_single_primary_insurance();


--
-- Name: skill_definitions trg_skill_definitions_path; Type: TRIGGER; Schema: public; Owner: -
--

CREATE TRIGGER trg_skill_definitions_path BEFORE INSERT OR UPDATE OF parent_id ON public.skill_definitions FOR EACH ROW EXECUTE FUNCTION public.skill_definitions_maintain_path();


--
-- Name: subscriptions trg_subscriptions_updated_at; Type: TRIGGER; Schema: public; Owner: -
--

CREATE TRIGGER trg_subscriptions_updated_at BEFORE UPDATE ON public.subscriptions FOR EACH ROW EXECUTE FUNCTION public.update_subscriptions_updated_at();


--
-- Name: time_entries trg_time_entry_derived; Type: TRIGGER; Schema: public; Owner: -
--

CREATE TRIGGER trg_time_entry_derived BEFORE INSERT OR UPDATE OF entry_timestamp ON public.time_entries FOR EACH ROW EXECUTE FUNCTION public.set_time_entry_derived_fields();


--
-- Name: time_entries trg_time_entry_recalc; Type: TRIGGER; Schema: public; Owner: -
--

CREATE TRIGGER trg_time_entry_recalc AFTER INSERT OR UPDATE ON public.time_entries FOR EACH ROW EXECUTE FUNCTION public.queue_time_summary_recalculation();


--
-- Name: ai_skill_executions trg_update_skill_metrics; Type: TRIGGER; Schema: public; Owner: -
--

CREATE TRIGGER trg_update_skill_metrics AFTER INSERT OR UPDATE OF status ON public.ai_skill_executions FOR EACH ROW EXECUTE FUNCTION public.update_skill_metrics();


--
-- Name: vertical_configs trg_vertical_configs_updated_at; Type: TRIGGER; Schema: public; Owner: -
--

CREATE TRIGGER trg_vertical_configs_updated_at BEFORE UPDATE ON public.vertical_configs FOR EACH ROW EXECUTE FUNCTION public.update_vertical_configs_updated_at();


--
-- Name: whatsapp_org_config trg_whatsapp_org_config_updated_at; Type: TRIGGER; Schema: public; Owner: -
--

CREATE TRIGGER trg_whatsapp_org_config_updated_at BEFORE UPDATE ON public.whatsapp_org_config FOR EACH ROW EXECUTE FUNCTION public.update_whatsapp_org_config_updated_at();


--
-- Name: invites trigger_invites_updated_at; Type: TRIGGER; Schema: public; Owner: -
--

CREATE TRIGGER trigger_invites_updated_at BEFORE UPDATE ON public.invites FOR EACH ROW EXECUTE FUNCTION public.update_invites_updated_at();


--
-- Name: subscriptions trigger_subscriptions_updated_at; Type: TRIGGER; Schema: public; Owner: -
--

CREATE TRIGGER trigger_subscriptions_updated_at BEFORE UPDATE ON public.subscriptions FOR EACH ROW EXECUTE FUNCTION public.update_subscriptions_updated_at();


--
-- Name: whatsapp_messages trigger_update_conversation_timestamp; Type: TRIGGER; Schema: public; Owner: -
--

CREATE TRIGGER trigger_update_conversation_timestamp AFTER INSERT ON public.whatsapp_messages FOR EACH ROW EXECUTE FUNCTION public.update_conversation_timestamp();


--
-- Name: user_sessions trigger_update_user_sessions_updated_at; Type: TRIGGER; Schema: public; Owner: -
--

CREATE TRIGGER trigger_update_user_sessions_updated_at BEFORE UPDATE ON public.user_sessions FOR EACH ROW EXECUTE FUNCTION public.update_user_sessions_updated_at();


--
-- Name: ai_conversations update_ai_conversations_updated_at; Type: TRIGGER; Schema: public; Owner: -
--

CREATE TRIGGER update_ai_conversations_updated_at BEFORE UPDATE ON public.ai_conversations FOR EACH ROW EXECUTE FUNCTION public.update_updated_at_column();


--
-- Name: ai_embedding_queue update_ai_embedding_queue_updated_at; Type: TRIGGER; Schema: public; Owner: -
--

CREATE TRIGGER update_ai_embedding_queue_updated_at BEFORE UPDATE ON public.ai_embedding_queue FOR EACH ROW EXECUTE FUNCTION public.update_updated_at_column();


--
-- Name: ai_embeddings update_ai_embeddings_updated_at; Type: TRIGGER; Schema: public; Owner: -
--

CREATE TRIGGER update_ai_embeddings_updated_at BEFORE UPDATE ON public.ai_embeddings FOR EACH ROW EXECUTE FUNCTION public.update_updated_at_column();


--
-- Name: appointment_resources update_appointment_resources_updated_at; Type: TRIGGER; Schema: public; Owner: -
--

CREATE TRIGGER update_appointment_resources_updated_at BEFORE UPDATE ON public.appointment_resources FOR EACH ROW EXECUTE FUNCTION public.update_updated_at_column();


--
-- Name: appointments update_appointments_updated_at; Type: TRIGGER; Schema: public; Owner: -
--

CREATE TRIGGER update_appointments_updated_at BEFORE UPDATE ON public.appointments FOR EACH ROW EXECUTE FUNCTION public.update_updated_at_column();


--
-- Name: booking_configurations update_booking_configurations_updated_at; Type: TRIGGER; Schema: public; Owner: -
--

CREATE TRIGGER update_booking_configurations_updated_at BEFORE UPDATE ON public.booking_configurations FOR EACH ROW EXECUTE FUNCTION public.update_updated_at_column();


--
-- Name: calendar_connections update_calendar_connections_updated_at; Type: TRIGGER; Schema: public; Owner: -
--

CREATE TRIGGER update_calendar_connections_updated_at BEFORE UPDATE ON public.calendar_connections FOR EACH ROW EXECUTE FUNCTION public.update_updated_at_column();


--
-- Name: catalog_items update_catalog_items_updated_at; Type: TRIGGER; Schema: public; Owner: -
--

CREATE TRIGGER update_catalog_items_updated_at BEFORE UPDATE ON public.catalog_items FOR EACH ROW EXECUTE FUNCTION public.update_updated_at_column();


--
-- Name: employees update_employees_updated_at; Type: TRIGGER; Schema: public; Owner: -
--

CREATE TRIGGER update_employees_updated_at BEFORE UPDATE ON public.employees FOR EACH ROW EXECUTE FUNCTION public.update_updated_at_column();


--
-- Name: entities update_entities_updated_at; Type: TRIGGER; Schema: public; Owner: -
--

CREATE TRIGGER update_entities_updated_at BEFORE UPDATE ON public.entities FOR EACH ROW EXECUTE FUNCTION public.update_updated_at_column();


--
-- Name: entity_ai_hot update_entity_ai_hot_updated_at; Type: TRIGGER; Schema: public; Owner: -
--

CREATE TRIGGER update_entity_ai_hot_updated_at BEFORE UPDATE ON public.entity_ai_hot FOR EACH ROW EXECUTE FUNCTION public.update_updated_at_column();


--
-- Name: entity_ai_traits update_entity_ai_traits_updated_at; Type: TRIGGER; Schema: public; Owner: -
--

CREATE TRIGGER update_entity_ai_traits_updated_at BEFORE UPDATE ON public.entity_ai_traits FOR EACH ROW EXECUTE FUNCTION public.update_updated_at_column();


--
-- Name: entity_metrics_cache update_entity_metrics_cache_updated_at; Type: TRIGGER; Schema: public; Owner: -
--

CREATE TRIGGER update_entity_metrics_cache_updated_at BEFORE UPDATE ON public.entity_metrics_cache FOR EACH ROW EXECUTE FUNCTION public.update_updated_at_column();


--
-- Name: organization_verticals update_organization_verticals_updated_at; Type: TRIGGER; Schema: public; Owner: -
--

CREATE TRIGGER update_organization_verticals_updated_at BEFORE UPDATE ON public.organization_verticals FOR EACH ROW EXECUTE FUNCTION public.update_updated_at_column();


--
-- Name: organizations update_organizations_updated_at; Type: TRIGGER; Schema: public; Owner: -
--

CREATE TRIGGER update_organizations_updated_at BEFORE UPDATE ON public.organizations FOR EACH ROW EXECUTE FUNCTION public.update_updated_at_column();


--
-- Name: profiles update_profiles_updated_at; Type: TRIGGER; Schema: public; Owner: -
--

CREATE TRIGGER update_profiles_updated_at BEFORE UPDATE ON public.profiles FOR EACH ROW EXECUTE FUNCTION public.update_updated_at_column();


--
-- Name: resource_availability update_resource_availability_updated_at; Type: TRIGGER; Schema: public; Owner: -
--

CREATE TRIGGER update_resource_availability_updated_at BEFORE UPDATE ON public.resource_availability FOR EACH ROW EXECUTE FUNCTION public.update_updated_at_column();


--
-- Name: resource_unavailability update_resource_unavailability_updated_at; Type: TRIGGER; Schema: public; Owner: -
--

CREATE TRIGGER update_resource_unavailability_updated_at BEFORE UPDATE ON public.resource_unavailability FOR EACH ROW EXECUTE FUNCTION public.update_updated_at_column();


--
-- Name: services update_services_updated_at; Type: TRIGGER; Schema: public; Owner: -
--

CREATE TRIGGER update_services_updated_at BEFORE UPDATE ON public.services FOR EACH ROW EXECUTE FUNCTION public.update_updated_at_column();


--
-- Name: waitlist_configurations waitlist_config_updated_at; Type: TRIGGER; Schema: public; Owner: -
--

CREATE TRIGGER waitlist_config_updated_at BEFORE UPDATE ON public.waitlist_configurations FOR EACH ROW EXECUTE FUNCTION public.update_waitlist_updated_at();


--
-- Name: waitlist_entries waitlist_entries_updated_at; Type: TRIGGER; Schema: public; Owner: -
--

CREATE TRIGGER waitlist_entries_updated_at BEFORE UPDATE ON public.waitlist_entries FOR EACH ROW EXECUTE FUNCTION public.update_waitlist_updated_at();


--
-- Name: walkin_configurations walkin_config_updated_at; Type: TRIGGER; Schema: public; Owner: -
--

CREATE TRIGGER walkin_config_updated_at BEFORE UPDATE ON public.walkin_configurations FOR EACH ROW EXECUTE FUNCTION public.update_walkin_updated_at();


--
-- Name: walkin_entries walkin_entries_updated_at; Type: TRIGGER; Schema: public; Owner: -
--

CREATE TRIGGER walkin_entries_updated_at BEFORE UPDATE ON public.walkin_entries FOR EACH ROW EXECUTE FUNCTION public.update_walkin_updated_at();


--
-- Name: ai_cache ai_cache_organization_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.ai_cache
    ADD CONSTRAINT ai_cache_organization_id_fkey FOREIGN KEY (organization_id) REFERENCES public.organizations(id) ON DELETE CASCADE;


--
-- Name: ai_conversations ai_conversations_organization_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.ai_conversations
    ADD CONSTRAINT ai_conversations_organization_id_fkey FOREIGN KEY (organization_id) REFERENCES public.organizations(id) ON DELETE CASCADE;


--
-- Name: ai_conversations ai_conversations_user_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.ai_conversations
    ADD CONSTRAINT ai_conversations_user_id_fkey FOREIGN KEY (user_id) REFERENCES auth.users(id) ON DELETE CASCADE;


--
-- Name: ai_embedding_configs ai_embedding_configs_created_by_fkey; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.ai_embedding_configs
    ADD CONSTRAINT ai_embedding_configs_created_by_fkey FOREIGN KEY (created_by) REFERENCES public.profiles(user_id);


--
-- Name: ai_embedding_queue ai_embedding_queue_organization_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.ai_embedding_queue
    ADD CONSTRAINT ai_embedding_queue_organization_id_fkey FOREIGN KEY (organization_id) REFERENCES public.organizations(id) ON DELETE CASCADE;


--
-- Name: ai_embeddings ai_embeddings_organization_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.ai_embeddings
    ADD CONSTRAINT ai_embeddings_organization_id_fkey FOREIGN KEY (organization_id) REFERENCES public.organizations(id) ON DELETE CASCADE;


--
-- Name: ai_interactions ai_interactions_organization_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.ai_interactions
    ADD CONSTRAINT ai_interactions_organization_id_fkey FOREIGN KEY (organization_id) REFERENCES public.organizations(id) ON DELETE CASCADE;


--
-- Name: ai_search_logs ai_search_logs_organization_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.ai_search_logs
    ADD CONSTRAINT ai_search_logs_organization_id_fkey FOREIGN KEY (organization_id) REFERENCES public.organizations(id) ON DELETE CASCADE;


--
-- Name: ai_search_logs ai_search_logs_user_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.ai_search_logs
    ADD CONSTRAINT ai_search_logs_user_id_fkey FOREIGN KEY (user_id) REFERENCES auth.users(id) ON DELETE SET NULL;


--
-- Name: ai_skill_executions ai_skill_executions_approved_by_fkey; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.ai_skill_executions
    ADD CONSTRAINT ai_skill_executions_approved_by_fkey FOREIGN KEY (approved_by) REFERENCES auth.users(id);


--
-- Name: ai_skill_executions ai_skill_executions_organization_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.ai_skill_executions
    ADD CONSTRAINT ai_skill_executions_organization_id_fkey FOREIGN KEY (organization_id) REFERENCES public.organizations(id) ON DELETE CASCADE;


--
-- Name: ai_skill_executions ai_skill_executions_skill_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.ai_skill_executions
    ADD CONSTRAINT ai_skill_executions_skill_id_fkey FOREIGN KEY (skill_id) REFERENCES public.ai_skills(id) ON DELETE CASCADE;


--
-- Name: ai_skill_executions ai_skill_executions_user_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.ai_skill_executions
    ADD CONSTRAINT ai_skill_executions_user_id_fkey FOREIGN KEY (user_id) REFERENCES auth.users(id);


--
-- Name: ai_usage ai_usage_organization_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.ai_usage
    ADD CONSTRAINT ai_usage_organization_id_fkey FOREIGN KEY (organization_id) REFERENCES public.organizations(id) ON DELETE CASCADE;


--
-- Name: appointment_audit_log appointment_audit_log_appointment_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.appointment_audit_log
    ADD CONSTRAINT appointment_audit_log_appointment_id_fkey FOREIGN KEY (appointment_id) REFERENCES public.appointments(id) ON DELETE CASCADE;


--
-- Name: appointment_audit_log appointment_audit_log_organization_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.appointment_audit_log
    ADD CONSTRAINT appointment_audit_log_organization_id_fkey FOREIGN KEY (organization_id) REFERENCES public.organizations(id) ON DELETE CASCADE;


--
-- Name: appointment_audit_log appointment_audit_log_user_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.appointment_audit_log
    ADD CONSTRAINT appointment_audit_log_user_id_fkey FOREIGN KEY (user_id) REFERENCES auth.users(id);


--
-- Name: appointment_resources appointment_resources_appointment_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.appointment_resources
    ADD CONSTRAINT appointment_resources_appointment_id_fkey FOREIGN KEY (appointment_id) REFERENCES public.appointments(id) ON DELETE CASCADE;


--
-- Name: appointment_resources appointment_resources_resource_entity_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.appointment_resources
    ADD CONSTRAINT appointment_resources_resource_entity_id_fkey FOREIGN KEY (resource_entity_id) REFERENCES public.entities(id) ON DELETE RESTRICT;


--
-- Name: appointments appointments_catalog_item_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.appointments
    ADD CONSTRAINT appointments_catalog_item_id_fkey FOREIGN KEY (catalog_item_id) REFERENCES public.catalog_items(id) ON DELETE SET NULL;


--
-- Name: appointments appointments_client_entity_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.appointments
    ADD CONSTRAINT appointments_client_entity_id_fkey FOREIGN KEY (client_entity_id) REFERENCES public.entities(id) ON DELETE RESTRICT;


--
-- Name: appointments appointments_created_by_fkey; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.appointments
    ADD CONSTRAINT appointments_created_by_fkey FOREIGN KEY (created_by) REFERENCES auth.users(id);


--
-- Name: appointments appointments_deleted_by_fkey; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.appointments
    ADD CONSTRAINT appointments_deleted_by_fkey FOREIGN KEY (deleted_by) REFERENCES auth.users(id);


--
-- Name: appointments appointments_location_entity_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.appointments
    ADD CONSTRAINT appointments_location_entity_id_fkey FOREIGN KEY (location_entity_id) REFERENCES public.entities(id) ON DELETE SET NULL;


--
-- Name: appointments appointments_organization_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.appointments
    ADD CONSTRAINT appointments_organization_id_fkey FOREIGN KEY (organization_id) REFERENCES public.organizations(id) ON DELETE CASCADE;


--
-- Name: appointments appointments_resource_entity_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.appointments
    ADD CONSTRAINT appointments_resource_entity_id_fkey FOREIGN KEY (resource_entity_id) REFERENCES public.entities(id) ON DELETE RESTRICT;


--
-- Name: appointments appointments_updated_by_fkey; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.appointments
    ADD CONSTRAINT appointments_updated_by_fkey FOREIGN KEY (updated_by) REFERENCES auth.users(id);


--
-- Name: attribute_definitions attribute_definitions_organization_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.attribute_definitions
    ADD CONSTRAINT attribute_definitions_organization_id_fkey FOREIGN KEY (organization_id) REFERENCES public.organizations(id) ON DELETE CASCADE;


--
-- Name: audit_logs audit_logs_organization_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.audit_logs
    ADD CONSTRAINT audit_logs_organization_id_fkey FOREIGN KEY (organization_id) REFERENCES public.organizations(id) ON DELETE CASCADE;


--
-- Name: audit_logs audit_logs_user_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.audit_logs
    ADD CONSTRAINT audit_logs_user_id_fkey FOREIGN KEY (user_id) REFERENCES auth.users(id) ON DELETE SET NULL;


--
-- Name: booking_configurations booking_configurations_organization_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.booking_configurations
    ADD CONSTRAINT booking_configurations_organization_id_fkey FOREIGN KEY (organization_id) REFERENCES public.organizations(id) ON DELETE CASCADE;


--
-- Name: booking_sessions booking_sessions_confirmed_appointment_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.booking_sessions
    ADD CONSTRAINT booking_sessions_confirmed_appointment_id_fkey FOREIGN KEY (confirmed_appointment_id) REFERENCES public.appointments(id);


--
-- Name: booking_sessions booking_sessions_organization_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.booking_sessions
    ADD CONSTRAINT booking_sessions_organization_id_fkey FOREIGN KEY (organization_id) REFERENCES public.organizations(id) ON DELETE CASCADE;


--
-- Name: booking_sessions booking_sessions_resource_entity_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.booking_sessions
    ADD CONSTRAINT booking_sessions_resource_entity_id_fkey FOREIGN KEY (resource_entity_id) REFERENCES public.entities(id);


--
-- Name: booking_sessions booking_sessions_service_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.booking_sessions
    ADD CONSTRAINT booking_sessions_service_id_fkey FOREIGN KEY (service_id) REFERENCES public.services(id);


--
-- Name: bot_messages bot_messages_organization_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.bot_messages
    ADD CONSTRAINT bot_messages_organization_id_fkey FOREIGN KEY (organization_id) REFERENCES public.organizations(id) ON DELETE CASCADE;


--
-- Name: business_hours business_hours_organization_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.business_hours
    ADD CONSTRAINT business_hours_organization_id_fkey FOREIGN KEY (organization_id) REFERENCES public.organizations(id);


--
-- Name: calendar_connections calendar_connections_organization_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.calendar_connections
    ADD CONSTRAINT calendar_connections_organization_id_fkey FOREIGN KEY (organization_id) REFERENCES public.organizations(id) ON DELETE CASCADE;


--
-- Name: calendar_connections calendar_connections_user_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.calendar_connections
    ADD CONSTRAINT calendar_connections_user_id_fkey FOREIGN KEY (user_id) REFERENCES auth.users(id) ON DELETE CASCADE;


--
-- Name: catalog_categories catalog_categories_organization_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.catalog_categories
    ADD CONSTRAINT catalog_categories_organization_id_fkey FOREIGN KEY (organization_id) REFERENCES public.organizations(id) ON DELETE CASCADE;


--
-- Name: catalog_categories catalog_categories_parent_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.catalog_categories
    ADD CONSTRAINT catalog_categories_parent_id_fkey FOREIGN KEY (parent_id) REFERENCES public.catalog_categories(id) ON DELETE SET NULL;


--
-- Name: catalog_items catalog_items_category_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.catalog_items
    ADD CONSTRAINT catalog_items_category_id_fkey FOREIGN KEY (category_id) REFERENCES public.catalog_categories(id) ON DELETE SET NULL;


--
-- Name: catalog_items catalog_items_item_type_fkey; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.catalog_items
    ADD CONSTRAINT catalog_items_item_type_fkey FOREIGN KEY (item_type) REFERENCES public.catalog_item_types(code);


--
-- Name: catalog_items catalog_items_organization_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.catalog_items
    ADD CONSTRAINT catalog_items_organization_id_fkey FOREIGN KEY (organization_id) REFERENCES public.organizations(id) ON DELETE CASCADE;


--
-- Name: catalog_items catalog_items_parent_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.catalog_items
    ADD CONSTRAINT catalog_items_parent_id_fkey FOREIGN KEY (parent_id) REFERENCES public.catalog_items(id) ON DELETE CASCADE;


--
-- Name: catalog_items catalog_items_tracking_type_fkey; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.catalog_items
    ADD CONSTRAINT catalog_items_tracking_type_fkey FOREIGN KEY (tracking_type) REFERENCES public.catalog_tracking_types(code);


--
-- Name: clients clients_created_by_fkey; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.clients
    ADD CONSTRAINT clients_created_by_fkey FOREIGN KEY (created_by) REFERENCES auth.users(id);


--
-- Name: clients clients_deleted_by_fkey; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.clients
    ADD CONSTRAINT clients_deleted_by_fkey FOREIGN KEY (deleted_by) REFERENCES auth.users(id);


--
-- Name: clients clients_entity_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.clients
    ADD CONSTRAINT clients_entity_id_fkey FOREIGN KEY (entity_id) REFERENCES public.entities(id) ON DELETE CASCADE;


--
-- Name: clients clients_organization_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.clients
    ADD CONSTRAINT clients_organization_id_fkey FOREIGN KEY (organization_id) REFERENCES public.organizations(id) ON DELETE CASCADE;


--
-- Name: clients clients_referred_by_entity_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.clients
    ADD CONSTRAINT clients_referred_by_entity_id_fkey FOREIGN KEY (referred_by_entity_id) REFERENCES public.entities(id);


--
-- Name: clients clients_updated_by_fkey; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.clients
    ADD CONSTRAINT clients_updated_by_fkey FOREIGN KEY (updated_by) REFERENCES auth.users(id);


--
-- Name: conversation_flow_runtime conversation_flow_runtime_flow_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.conversation_flow_runtime
    ADD CONSTRAINT conversation_flow_runtime_flow_id_fkey FOREIGN KEY (flow_id) REFERENCES public.conversation_flows(id) ON DELETE CASCADE;


--
-- Name: conversation_flow_runtime conversation_flow_runtime_organization_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.conversation_flow_runtime
    ADD CONSTRAINT conversation_flow_runtime_organization_id_fkey FOREIGN KEY (organization_id) REFERENCES public.organizations(id) ON DELETE CASCADE;


--
-- Name: conversation_flow_runtime conversation_flow_runtime_session_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.conversation_flow_runtime
    ADD CONSTRAINT conversation_flow_runtime_session_id_fkey FOREIGN KEY (session_id) REFERENCES public.conversation_sessions(id) ON DELETE CASCADE;


--
-- Name: conversation_flow_states conversation_flow_states_flow_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.conversation_flow_states
    ADD CONSTRAINT conversation_flow_states_flow_id_fkey FOREIGN KEY (flow_id) REFERENCES public.conversation_flows(id);


--
-- Name: conversation_flow_states conversation_flow_states_organization_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.conversation_flow_states
    ADD CONSTRAINT conversation_flow_states_organization_id_fkey FOREIGN KEY (organization_id) REFERENCES public.organizations(id);


--
-- Name: conversation_flows conversation_flows_created_by_fkey; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.conversation_flows
    ADD CONSTRAINT conversation_flows_created_by_fkey FOREIGN KEY (created_by) REFERENCES auth.users(id);


--
-- Name: conversation_flows conversation_flows_organization_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.conversation_flows
    ADD CONSTRAINT conversation_flows_organization_id_fkey FOREIGN KEY (organization_id) REFERENCES public.organizations(id) ON DELETE CASCADE;


--
-- Name: conversation_flows conversation_flows_success_skill_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.conversation_flows
    ADD CONSTRAINT conversation_flows_success_skill_id_fkey FOREIGN KEY (success_skill_id) REFERENCES public.ai_skills(id);


--
-- Name: conversation_memory conversation_memory_organization_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.conversation_memory
    ADD CONSTRAINT conversation_memory_organization_id_fkey FOREIGN KEY (organization_id) REFERENCES public.organizations(id) ON DELETE CASCADE;


--
-- Name: conversation_memory conversation_memory_session_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.conversation_memory
    ADD CONSTRAINT conversation_memory_session_id_fkey FOREIGN KEY (session_id) REFERENCES public.conversation_sessions(id) ON DELETE SET NULL;


--
-- Name: conversation_sessions conversation_sessions_active_flow_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.conversation_sessions
    ADD CONSTRAINT conversation_sessions_active_flow_id_fkey FOREIGN KEY (active_flow_id) REFERENCES public.conversation_flows(id);


--
-- Name: conversation_sessions conversation_sessions_organization_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.conversation_sessions
    ADD CONSTRAINT conversation_sessions_organization_id_fkey FOREIGN KEY (organization_id) REFERENCES public.organizations(id) ON DELETE CASCADE;


--
-- Name: daily_time_summary daily_time_summary_approved_by_fkey; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.daily_time_summary
    ADD CONSTRAINT daily_time_summary_approved_by_fkey FOREIGN KEY (approved_by) REFERENCES public.profiles(user_id);


--
-- Name: daily_time_summary daily_time_summary_department_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.daily_time_summary
    ADD CONSTRAINT daily_time_summary_department_id_fkey FOREIGN KEY (department_id) REFERENCES public.departments(id);


--
-- Name: daily_time_summary daily_time_summary_employee_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.daily_time_summary
    ADD CONSTRAINT daily_time_summary_employee_id_fkey FOREIGN KEY (employee_id) REFERENCES public.employees(id) ON DELETE CASCADE;


--
-- Name: daily_time_summary daily_time_summary_finalized_by_fkey; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.daily_time_summary
    ADD CONSTRAINT daily_time_summary_finalized_by_fkey FOREIGN KEY (finalized_by) REFERENCES public.profiles(user_id);


--
-- Name: daily_time_summary daily_time_summary_organization_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.daily_time_summary
    ADD CONSTRAINT daily_time_summary_organization_id_fkey FOREIGN KEY (organization_id) REFERENCES public.organizations(id) ON DELETE CASCADE;


--
-- Name: departments departments_created_by_fkey; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.departments
    ADD CONSTRAINT departments_created_by_fkey FOREIGN KEY (created_by) REFERENCES public.profiles(user_id);


--
-- Name: departments departments_organization_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.departments
    ADD CONSTRAINT departments_organization_id_fkey FOREIGN KEY (organization_id) REFERENCES public.organizations(id) ON DELETE CASCADE;


--
-- Name: departments departments_parent_department_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.departments
    ADD CONSTRAINT departments_parent_department_id_fkey FOREIGN KEY (parent_department_id) REFERENCES public.departments(id) ON DELETE SET NULL;


--
-- Name: departments departments_updated_by_fkey; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.departments
    ADD CONSTRAINT departments_updated_by_fkey FOREIGN KEY (updated_by) REFERENCES public.profiles(user_id);


--
-- Name: employees employees_created_by_fkey; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.employees
    ADD CONSTRAINT employees_created_by_fkey FOREIGN KEY (created_by) REFERENCES public.profiles(user_id);


--
-- Name: employees employees_deleted_by_fkey; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.employees
    ADD CONSTRAINT employees_deleted_by_fkey FOREIGN KEY (deleted_by) REFERENCES public.profiles(user_id);


--
-- Name: employees employees_department_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.employees
    ADD CONSTRAINT employees_department_id_fkey FOREIGN KEY (department_id) REFERENCES public.departments(id) ON DELETE SET NULL;


--
-- Name: employees employees_entity_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.employees
    ADD CONSTRAINT employees_entity_id_fkey FOREIGN KEY (entity_id) REFERENCES public.entities(id) ON DELETE CASCADE;


--
-- Name: employees employees_job_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.employees
    ADD CONSTRAINT employees_job_id_fkey FOREIGN KEY (job_id) REFERENCES public.jobs(id) ON DELETE SET NULL;


--
-- Name: employees employees_manager_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.employees
    ADD CONSTRAINT employees_manager_id_fkey FOREIGN KEY (manager_id) REFERENCES public.employees(id);


--
-- Name: employees employees_organization_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.employees
    ADD CONSTRAINT employees_organization_id_fkey FOREIGN KEY (organization_id) REFERENCES public.organizations(id) ON DELETE CASCADE;


--
-- Name: employees employees_position_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.employees
    ADD CONSTRAINT employees_position_id_fkey FOREIGN KEY (position_id) REFERENCES public.positions(id) ON DELETE SET NULL;


--
-- Name: employees employees_updated_by_fkey; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.employees
    ADD CONSTRAINT employees_updated_by_fkey FOREIGN KEY (updated_by) REFERENCES public.profiles(user_id);


--
-- Name: entities entities_organization_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.entities
    ADD CONSTRAINT entities_organization_id_fkey FOREIGN KEY (organization_id) REFERENCES public.organizations(id) ON DELETE CASCADE;


--
-- Name: entity_ai_cold entity_ai_cold_entity_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.entity_ai_cold
    ADD CONSTRAINT entity_ai_cold_entity_id_fkey FOREIGN KEY (entity_id) REFERENCES public.entities(id) ON DELETE CASCADE;


--
-- Name: entity_ai_hot entity_ai_hot_entity_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.entity_ai_hot
    ADD CONSTRAINT entity_ai_hot_entity_id_fkey FOREIGN KEY (entity_id) REFERENCES public.entities(id) ON DELETE CASCADE;


--
-- Name: entity_ai_traits entity_ai_traits_created_by_fkey; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.entity_ai_traits
    ADD CONSTRAINT entity_ai_traits_created_by_fkey FOREIGN KEY (created_by) REFERENCES auth.users(id);


--
-- Name: entity_ai_traits entity_ai_traits_entity_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.entity_ai_traits
    ADD CONSTRAINT entity_ai_traits_entity_id_fkey FOREIGN KEY (entity_id) REFERENCES public.entities(id) ON DELETE CASCADE;


--
-- Name: entity_ai_traits entity_ai_traits_organization_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.entity_ai_traits
    ADD CONSTRAINT entity_ai_traits_organization_id_fkey FOREIGN KEY (organization_id) REFERENCES public.organizations(id) ON DELETE CASCADE;


--
-- Name: entity_ai_traits entity_ai_traits_updated_by_fkey; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.entity_ai_traits
    ADD CONSTRAINT entity_ai_traits_updated_by_fkey FOREIGN KEY (updated_by) REFERENCES auth.users(id);


--
-- Name: entity_identification_documents entity_identification_documents_created_by_fkey; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.entity_identification_documents
    ADD CONSTRAINT entity_identification_documents_created_by_fkey FOREIGN KEY (created_by) REFERENCES auth.users(id);


--
-- Name: entity_identification_documents entity_identification_documents_deleted_by_fkey; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.entity_identification_documents
    ADD CONSTRAINT entity_identification_documents_deleted_by_fkey FOREIGN KEY (deleted_by) REFERENCES auth.users(id);


--
-- Name: entity_identification_documents entity_identification_documents_entity_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.entity_identification_documents
    ADD CONSTRAINT entity_identification_documents_entity_id_fkey FOREIGN KEY (entity_id) REFERENCES public.entities(id) ON DELETE CASCADE;


--
-- Name: entity_identification_documents entity_identification_documents_organization_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.entity_identification_documents
    ADD CONSTRAINT entity_identification_documents_organization_id_fkey FOREIGN KEY (organization_id) REFERENCES public.organizations(id) ON DELETE CASCADE;


--
-- Name: entity_identification_documents entity_identification_documents_updated_by_fkey; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.entity_identification_documents
    ADD CONSTRAINT entity_identification_documents_updated_by_fkey FOREIGN KEY (updated_by) REFERENCES auth.users(id);


--
-- Name: entity_insurance_policies entity_insurance_policies_created_by_fkey; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.entity_insurance_policies
    ADD CONSTRAINT entity_insurance_policies_created_by_fkey FOREIGN KEY (created_by) REFERENCES auth.users(id);


--
-- Name: entity_insurance_policies entity_insurance_policies_deleted_by_fkey; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.entity_insurance_policies
    ADD CONSTRAINT entity_insurance_policies_deleted_by_fkey FOREIGN KEY (deleted_by) REFERENCES auth.users(id);


--
-- Name: entity_insurance_policies entity_insurance_policies_entity_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.entity_insurance_policies
    ADD CONSTRAINT entity_insurance_policies_entity_id_fkey FOREIGN KEY (entity_id) REFERENCES public.entities(id) ON DELETE CASCADE;


--
-- Name: entity_insurance_policies entity_insurance_policies_organization_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.entity_insurance_policies
    ADD CONSTRAINT entity_insurance_policies_organization_id_fkey FOREIGN KEY (organization_id) REFERENCES public.organizations(id) ON DELETE CASCADE;


--
-- Name: entity_insurance_policies entity_insurance_policies_provider_entity_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.entity_insurance_policies
    ADD CONSTRAINT entity_insurance_policies_provider_entity_id_fkey FOREIGN KEY (provider_entity_id) REFERENCES public.entities(id);


--
-- Name: entity_insurance_policies entity_insurance_policies_updated_by_fkey; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.entity_insurance_policies
    ADD CONSTRAINT entity_insurance_policies_updated_by_fkey FOREIGN KEY (updated_by) REFERENCES auth.users(id);


--
-- Name: entity_memory entity_memory_entity_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.entity_memory
    ADD CONSTRAINT entity_memory_entity_id_fkey FOREIGN KEY (entity_id) REFERENCES public.entities(id) ON DELETE CASCADE;


--
-- Name: entity_memory entity_memory_organization_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.entity_memory
    ADD CONSTRAINT entity_memory_organization_id_fkey FOREIGN KEY (organization_id) REFERENCES public.organizations(id) ON DELETE CASCADE;


--
-- Name: entity_metrics_cache entity_metrics_cache_entity_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.entity_metrics_cache
    ADD CONSTRAINT entity_metrics_cache_entity_id_fkey FOREIGN KEY (entity_id) REFERENCES public.entities(id) ON DELETE CASCADE;


--
-- Name: entity_metrics_cache entity_metrics_cache_organization_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.entity_metrics_cache
    ADD CONSTRAINT entity_metrics_cache_organization_id_fkey FOREIGN KEY (organization_id) REFERENCES public.organizations(id) ON DELETE CASCADE;


--
-- Name: entity_relationships entity_relationships_created_by_fkey; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.entity_relationships
    ADD CONSTRAINT entity_relationships_created_by_fkey FOREIGN KEY (created_by) REFERENCES auth.users(id);


--
-- Name: entity_relationships entity_relationships_deleted_by_fkey; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.entity_relationships
    ADD CONSTRAINT entity_relationships_deleted_by_fkey FOREIGN KEY (deleted_by) REFERENCES auth.users(id);


--
-- Name: entity_relationships entity_relationships_entity_from_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.entity_relationships
    ADD CONSTRAINT entity_relationships_entity_from_id_fkey FOREIGN KEY (source_entity_id) REFERENCES public.entities(id) ON DELETE CASCADE;


--
-- Name: entity_relationships entity_relationships_entity_to_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.entity_relationships
    ADD CONSTRAINT entity_relationships_entity_to_id_fkey FOREIGN KEY (target_entity_id) REFERENCES public.entities(id) ON DELETE CASCADE;


--
-- Name: entity_relationships entity_relationships_organization_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.entity_relationships
    ADD CONSTRAINT entity_relationships_organization_id_fkey FOREIGN KEY (organization_id) REFERENCES public.organizations(id) ON DELETE CASCADE;


--
-- Name: entity_relationships entity_relationships_updated_by_fkey; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.entity_relationships
    ADD CONSTRAINT entity_relationships_updated_by_fkey FOREIGN KEY (updated_by) REFERENCES auth.users(id);


--
-- Name: entity_synonyms entity_synonyms_created_by_fkey; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.entity_synonyms
    ADD CONSTRAINT entity_synonyms_created_by_fkey FOREIGN KEY (created_by) REFERENCES auth.users(id);


--
-- Name: entity_synonyms entity_synonyms_organization_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.entity_synonyms
    ADD CONSTRAINT entity_synonyms_organization_id_fkey FOREIGN KEY (organization_id) REFERENCES public.organizations(id) ON DELETE CASCADE;


--
-- Name: external_calendar_events external_calendar_events_connection_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.external_calendar_events
    ADD CONSTRAINT external_calendar_events_connection_id_fkey FOREIGN KEY (connection_id) REFERENCES public.calendar_connections(id) ON DELETE CASCADE;


--
-- Name: external_calendar_events external_calendar_events_organization_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.external_calendar_events
    ADD CONSTRAINT external_calendar_events_organization_id_fkey FOREIGN KEY (organization_id) REFERENCES public.organizations(id) ON DELETE CASCADE;


--
-- Name: external_calendar_events external_calendar_events_synced_appointment_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.external_calendar_events
    ADD CONSTRAINT external_calendar_events_synced_appointment_id_fkey FOREIGN KEY (synced_appointment_id) REFERENCES public.appointments(id) ON DELETE SET NULL;


--
-- Name: departments fk_departments_manager; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.departments
    ADD CONSTRAINT fk_departments_manager FOREIGN KEY (manager_employee_id) REFERENCES public.employees(id) ON DELETE SET NULL;


--
-- Name: employees fk_employees_reports_to; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.employees
    ADD CONSTRAINT fk_employees_reports_to FOREIGN KEY (reports_to_employee_id) REFERENCES public.employees(id) ON DELETE SET NULL;


--
-- Name: identification_document_types identification_document_types_organization_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.identification_document_types
    ADD CONSTRAINT identification_document_types_organization_id_fkey FOREIGN KEY (organization_id) REFERENCES public.organizations(id) ON DELETE CASCADE;


--
-- Name: insurance_providers insurance_providers_entity_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.insurance_providers
    ADD CONSTRAINT insurance_providers_entity_id_fkey FOREIGN KEY (entity_id) REFERENCES public.entities(id) ON DELETE CASCADE;


--
-- Name: insurance_providers insurance_providers_organization_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.insurance_providers
    ADD CONSTRAINT insurance_providers_organization_id_fkey FOREIGN KEY (organization_id) REFERENCES public.organizations(id) ON DELETE CASCADE;


--
-- Name: inventory inventory_product_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.inventory
    ADD CONSTRAINT inventory_product_id_fkey FOREIGN KEY (product_id) REFERENCES public.products(id) ON DELETE CASCADE;


--
-- Name: invites invites_accepted_by_fkey; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.invites
    ADD CONSTRAINT invites_accepted_by_fkey FOREIGN KEY (accepted_by) REFERENCES public.profiles(user_id) ON DELETE SET NULL;


--
-- Name: invites invites_created_by_fkey; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.invites
    ADD CONSTRAINT invites_created_by_fkey FOREIGN KEY (created_by) REFERENCES public.profiles(user_id) ON DELETE CASCADE;


--
-- Name: invites invites_organization_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.invites
    ADD CONSTRAINT invites_organization_id_fkey FOREIGN KEY (organization_id) REFERENCES public.organizations(id) ON DELETE CASCADE;


--
-- Name: invites invites_role_key_fkey; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.invites
    ADD CONSTRAINT invites_role_key_fkey FOREIGN KEY (role_key) REFERENCES public.roles(key);


--
-- Name: item_attributes item_attributes_attribute_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.item_attributes
    ADD CONSTRAINT item_attributes_attribute_id_fkey FOREIGN KEY (attribute_id) REFERENCES public.attribute_definitions(id) ON DELETE CASCADE;


--
-- Name: item_attributes item_attributes_item_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.item_attributes
    ADD CONSTRAINT item_attributes_item_id_fkey FOREIGN KEY (item_id) REFERENCES public.catalog_items(id) ON DELETE CASCADE;


--
-- Name: item_providers item_providers_item_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.item_providers
    ADD CONSTRAINT item_providers_item_id_fkey FOREIGN KEY (item_id) REFERENCES public.catalog_items(id) ON DELETE CASCADE;


--
-- Name: item_providers item_providers_organization_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.item_providers
    ADD CONSTRAINT item_providers_organization_id_fkey FOREIGN KEY (organization_id) REFERENCES public.organizations(id) ON DELETE CASCADE;


--
-- Name: item_providers item_providers_provider_entity_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.item_providers
    ADD CONSTRAINT item_providers_provider_entity_id_fkey FOREIGN KEY (provider_entity_id) REFERENCES public.entities(id) ON DELETE CASCADE;


--
-- Name: item_skill_requirements item_skill_requirements_item_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.item_skill_requirements
    ADD CONSTRAINT item_skill_requirements_item_id_fkey FOREIGN KEY (item_id) REFERENCES public.catalog_items(id) ON DELETE CASCADE;


--
-- Name: item_skill_requirements item_skill_requirements_skill_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.item_skill_requirements
    ADD CONSTRAINT item_skill_requirements_skill_id_fkey FOREIGN KEY (skill_id) REFERENCES public.skill_definitions(id) ON DELETE CASCADE;


--
-- Name: jobs jobs_created_by_fkey; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.jobs
    ADD CONSTRAINT jobs_created_by_fkey FOREIGN KEY (created_by) REFERENCES public.profiles(user_id);


--
-- Name: jobs jobs_organization_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.jobs
    ADD CONSTRAINT jobs_organization_id_fkey FOREIGN KEY (organization_id) REFERENCES public.organizations(id) ON DELETE CASCADE;


--
-- Name: jobs jobs_updated_by_fkey; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.jobs
    ADD CONSTRAINT jobs_updated_by_fkey FOREIGN KEY (updated_by) REFERENCES public.profiles(user_id);


--
-- Name: leave_balances leave_balances_employee_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.leave_balances
    ADD CONSTRAINT leave_balances_employee_id_fkey FOREIGN KEY (employee_id) REFERENCES public.employees(id) ON DELETE CASCADE;


--
-- Name: leave_balances leave_balances_leave_type_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.leave_balances
    ADD CONSTRAINT leave_balances_leave_type_id_fkey FOREIGN KEY (leave_type_id) REFERENCES public.leave_types(id) ON DELETE CASCADE;


--
-- Name: leave_balances leave_balances_organization_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.leave_balances
    ADD CONSTRAINT leave_balances_organization_id_fkey FOREIGN KEY (organization_id) REFERENCES public.organizations(id) ON DELETE CASCADE;


--
-- Name: leave_requests leave_requests_approved_by_fkey; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.leave_requests
    ADD CONSTRAINT leave_requests_approved_by_fkey FOREIGN KEY (approved_by) REFERENCES public.profiles(user_id);


--
-- Name: leave_requests leave_requests_created_by_fkey; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.leave_requests
    ADD CONSTRAINT leave_requests_created_by_fkey FOREIGN KEY (created_by) REFERENCES public.profiles(user_id);


--
-- Name: leave_requests leave_requests_employee_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.leave_requests
    ADD CONSTRAINT leave_requests_employee_id_fkey FOREIGN KEY (employee_id) REFERENCES public.employees(id) ON DELETE CASCADE;


--
-- Name: leave_requests leave_requests_leave_type_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.leave_requests
    ADD CONSTRAINT leave_requests_leave_type_id_fkey FOREIGN KEY (leave_type_id) REFERENCES public.leave_types(id) ON DELETE CASCADE;


--
-- Name: leave_requests leave_requests_organization_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.leave_requests
    ADD CONSTRAINT leave_requests_organization_id_fkey FOREIGN KEY (organization_id) REFERENCES public.organizations(id) ON DELETE CASCADE;


--
-- Name: leave_types leave_types_organization_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.leave_types
    ADD CONSTRAINT leave_types_organization_id_fkey FOREIGN KEY (organization_id) REFERENCES public.organizations(id) ON DELETE CASCADE;


--
-- Name: llm_prompts llm_prompts_created_by_fkey; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.llm_prompts
    ADD CONSTRAINT llm_prompts_created_by_fkey FOREIGN KEY (created_by) REFERENCES auth.users(id);


--
-- Name: llm_prompts llm_prompts_organization_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.llm_prompts
    ADD CONSTRAINT llm_prompts_organization_id_fkey FOREIGN KEY (organization_id) REFERENCES public.organizations(id) ON DELETE CASCADE;


--
-- Name: llm_prompts llm_prompts_parent_prompt_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.llm_prompts
    ADD CONSTRAINT llm_prompts_parent_prompt_id_fkey FOREIGN KEY (parent_prompt_id) REFERENCES public.llm_prompts(id);


--
-- Name: memberships memberships_created_by_fkey; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.memberships
    ADD CONSTRAINT memberships_created_by_fkey FOREIGN KEY (created_by) REFERENCES auth.users(id);


--
-- Name: memberships memberships_organization_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.memberships
    ADD CONSTRAINT memberships_organization_id_fkey FOREIGN KEY (organization_id) REFERENCES public.organizations(id) ON DELETE CASCADE;


--
-- Name: memberships memberships_role_key_fkey; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.memberships
    ADD CONSTRAINT memberships_role_key_fkey FOREIGN KEY (role_key) REFERENCES public.roles(key) ON DELETE CASCADE;


--
-- Name: memberships memberships_updated_by_fkey; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.memberships
    ADD CONSTRAINT memberships_updated_by_fkey FOREIGN KEY (updated_by) REFERENCES auth.users(id);


--
-- Name: memberships memberships_user_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.memberships
    ADD CONSTRAINT memberships_user_id_fkey FOREIGN KEY (user_id) REFERENCES public.profiles(user_id) ON DELETE CASCADE;


--
-- Name: nlu_entity_synonyms nlu_entity_synonyms_organization_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.nlu_entity_synonyms
    ADD CONSTRAINT nlu_entity_synonyms_organization_id_fkey FOREIGN KEY (organization_id) REFERENCES public.organizations(id) ON DELETE CASCADE;


--
-- Name: nlu_heuristic_rules nlu_heuristic_rules_organization_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.nlu_heuristic_rules
    ADD CONSTRAINT nlu_heuristic_rules_organization_id_fkey FOREIGN KEY (organization_id) REFERENCES public.organizations(id) ON DELETE CASCADE;


--
-- Name: nlu_intent_examples nlu_intent_examples_organization_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.nlu_intent_examples
    ADD CONSTRAINT nlu_intent_examples_organization_id_fkey FOREIGN KEY (organization_id) REFERENCES public.organizations(id) ON DELETE CASCADE;


--
-- Name: nlu_intent_signals nlu_intent_signals_organization_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.nlu_intent_signals
    ADD CONSTRAINT nlu_intent_signals_organization_id_fkey FOREIGN KEY (organization_id) REFERENCES public.organizations(id) ON DELETE CASCADE;


--
-- Name: nlu_keywords nlu_keywords_organization_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.nlu_keywords
    ADD CONSTRAINT nlu_keywords_organization_id_fkey FOREIGN KEY (organization_id) REFERENCES public.organizations(id) ON DELETE CASCADE;


--
-- Name: nlu_training_logs nlu_training_logs_organization_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.nlu_training_logs
    ADD CONSTRAINT nlu_training_logs_organization_id_fkey FOREIGN KEY (organization_id) REFERENCES public.organizations(id);


--
-- Name: nlu_typo_corrections nlu_typo_corrections_organization_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.nlu_typo_corrections
    ADD CONSTRAINT nlu_typo_corrections_organization_id_fkey FOREIGN KEY (organization_id) REFERENCES public.organizations(id) ON DELETE CASCADE;


--
-- Name: orders orders_product_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.orders
    ADD CONSTRAINT orders_product_id_fkey FOREIGN KEY (product_id) REFERENCES public.products(id) ON DELETE CASCADE;


--
-- Name: org_knowledge_base org_knowledge_base_created_by_fkey; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.org_knowledge_base
    ADD CONSTRAINT org_knowledge_base_created_by_fkey FOREIGN KEY (created_by) REFERENCES auth.users(id);


--
-- Name: org_knowledge_base org_knowledge_base_organization_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.org_knowledge_base
    ADD CONSTRAINT org_knowledge_base_organization_id_fkey FOREIGN KEY (organization_id) REFERENCES public.organizations(id) ON DELETE CASCADE;


--
-- Name: organization_configs organization_configs_organization_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.organization_configs
    ADD CONSTRAINT organization_configs_organization_id_fkey FOREIGN KEY (organization_id) REFERENCES public.organizations(id) ON DELETE CASCADE;


--
-- Name: organization_policies organization_policies_organization_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.organization_policies
    ADD CONSTRAINT organization_policies_organization_id_fkey FOREIGN KEY (organization_id) REFERENCES public.organizations(id) ON DELETE CASCADE;


--
-- Name: organization_verticals organization_verticals_created_by_fkey; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.organization_verticals
    ADD CONSTRAINT organization_verticals_created_by_fkey FOREIGN KEY (created_by) REFERENCES auth.users(id);


--
-- Name: organization_verticals organization_verticals_updated_by_fkey; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.organization_verticals
    ADD CONSTRAINT organization_verticals_updated_by_fkey FOREIGN KEY (updated_by) REFERENCES auth.users(id);


--
-- Name: organizations organizations_parent_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.organizations
    ADD CONSTRAINT organizations_parent_id_fkey FOREIGN KEY (parent_id) REFERENCES public.organizations(id);


--
-- Name: organizations organizations_vertical_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.organizations
    ADD CONSTRAINT organizations_vertical_id_fkey FOREIGN KEY (vertical_id) REFERENCES public.organization_verticals(id);


--
-- Name: patient_code_sequences patient_code_sequences_organization_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.patient_code_sequences
    ADD CONSTRAINT patient_code_sequences_organization_id_fkey FOREIGN KEY (organization_id) REFERENCES public.organizations(id) ON DELETE CASCADE;


--
-- Name: patient_notes patient_notes_appointment_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.patient_notes
    ADD CONSTRAINT patient_notes_appointment_id_fkey FOREIGN KEY (appointment_id) REFERENCES public.appointments(id) ON DELETE SET NULL;


--
-- Name: patient_notes patient_notes_created_by_fkey; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.patient_notes
    ADD CONSTRAINT patient_notes_created_by_fkey FOREIGN KEY (created_by) REFERENCES auth.users(id);


--
-- Name: patient_notes patient_notes_deleted_by_fkey; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.patient_notes
    ADD CONSTRAINT patient_notes_deleted_by_fkey FOREIGN KEY (deleted_by) REFERENCES auth.users(id);


--
-- Name: patient_notes patient_notes_organization_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.patient_notes
    ADD CONSTRAINT patient_notes_organization_id_fkey FOREIGN KEY (organization_id) REFERENCES public.organizations(id) ON DELETE CASCADE;


--
-- Name: patient_notes patient_notes_patient_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.patient_notes
    ADD CONSTRAINT patient_notes_patient_id_fkey FOREIGN KEY (patient_id) REFERENCES public.patients(id) ON DELETE CASCADE;


--
-- Name: patient_notes patient_notes_updated_by_fkey; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.patient_notes
    ADD CONSTRAINT patient_notes_updated_by_fkey FOREIGN KEY (updated_by) REFERENCES auth.users(id);


--
-- Name: patients patients_created_by_fkey; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.patients
    ADD CONSTRAINT patients_created_by_fkey FOREIGN KEY (created_by) REFERENCES auth.users(id);


--
-- Name: patients patients_deleted_by_fkey; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.patients
    ADD CONSTRAINT patients_deleted_by_fkey FOREIGN KEY (deleted_by) REFERENCES auth.users(id);


--
-- Name: patients patients_entity_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.patients
    ADD CONSTRAINT patients_entity_id_fkey FOREIGN KEY (entity_id) REFERENCES public.entities(id) ON DELETE CASCADE;


--
-- Name: patients patients_organization_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.patients
    ADD CONSTRAINT patients_organization_id_fkey FOREIGN KEY (organization_id) REFERENCES public.organizations(id) ON DELETE CASCADE;


--
-- Name: patients patients_updated_by_fkey; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.patients
    ADD CONSTRAINT patients_updated_by_fkey FOREIGN KEY (updated_by) REFERENCES auth.users(id);


--
-- Name: positions positions_department_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.positions
    ADD CONSTRAINT positions_department_id_fkey FOREIGN KEY (department_id) REFERENCES public.departments(id) ON DELETE SET NULL;


--
-- Name: positions positions_job_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.positions
    ADD CONSTRAINT positions_job_id_fkey FOREIGN KEY (job_id) REFERENCES public.jobs(id) ON DELETE SET NULL;


--
-- Name: positions positions_organization_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.positions
    ADD CONSTRAINT positions_organization_id_fkey FOREIGN KEY (organization_id) REFERENCES public.organizations(id) ON DELETE CASCADE;


--
-- Name: positions positions_reports_to_position_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.positions
    ADD CONSTRAINT positions_reports_to_position_id_fkey FOREIGN KEY (reports_to_position_id) REFERENCES public.positions(id) ON DELETE SET NULL;


--
-- Name: profiles profiles_user_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.profiles
    ADD CONSTRAINT profiles_user_id_fkey FOREIGN KEY (user_id) REFERENCES auth.users(id) ON DELETE CASCADE;


--
-- Name: promotion_analytics promotion_analytics_promotion_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.promotion_analytics
    ADD CONSTRAINT promotion_analytics_promotion_id_fkey FOREIGN KEY (promotion_id) REFERENCES public.promotions(id) ON DELETE CASCADE;


--
-- Name: promotion_bundle_items promotion_bundle_items_catalog_item_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.promotion_bundle_items
    ADD CONSTRAINT promotion_bundle_items_catalog_item_id_fkey FOREIGN KEY (catalog_item_id) REFERENCES public.catalog_items(id) ON DELETE CASCADE;


--
-- Name: promotion_bundle_items promotion_bundle_items_promotion_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.promotion_bundle_items
    ADD CONSTRAINT promotion_bundle_items_promotion_id_fkey FOREIGN KEY (promotion_id) REFERENCES public.promotions(id) ON DELETE CASCADE;


--
-- Name: promotion_rule_items promotion_rule_items_catalog_item_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.promotion_rule_items
    ADD CONSTRAINT promotion_rule_items_catalog_item_id_fkey FOREIGN KEY (catalog_item_id) REFERENCES public.catalog_items(id) ON DELETE CASCADE;


--
-- Name: promotion_rule_items promotion_rule_items_rule_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.promotion_rule_items
    ADD CONSTRAINT promotion_rule_items_rule_id_fkey FOREIGN KEY (rule_id) REFERENCES public.promotion_rules(id) ON DELETE CASCADE;


--
-- Name: promotion_rules promotion_rules_category_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.promotion_rules
    ADD CONSTRAINT promotion_rules_category_id_fkey FOREIGN KEY (category_id) REFERENCES public.catalog_categories(id);


--
-- Name: promotion_rules promotion_rules_promotion_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.promotion_rules
    ADD CONSTRAINT promotion_rules_promotion_id_fkey FOREIGN KEY (promotion_id) REFERENCES public.promotions(id) ON DELETE CASCADE;


--
-- Name: promotion_tiers promotion_tiers_promotion_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.promotion_tiers
    ADD CONSTRAINT promotion_tiers_promotion_id_fkey FOREIGN KEY (promotion_id) REFERENCES public.promotions(id) ON DELETE CASCADE;


--
-- Name: promotions promotions_get_item_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.promotions
    ADD CONSTRAINT promotions_get_item_id_fkey FOREIGN KEY (get_item_id) REFERENCES public.catalog_items(id);


--
-- Name: promotions promotions_organization_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.promotions
    ADD CONSTRAINT promotions_organization_id_fkey FOREIGN KEY (organization_id) REFERENCES public.organizations(id) ON DELETE CASCADE;


--
-- Name: provider_schedule_exceptions provider_schedule_exceptions_organization_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.provider_schedule_exceptions
    ADD CONSTRAINT provider_schedule_exceptions_organization_id_fkey FOREIGN KEY (organization_id) REFERENCES public.organizations(id) ON DELETE CASCADE;


--
-- Name: provider_schedule_exceptions provider_schedule_exceptions_provider_entity_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.provider_schedule_exceptions
    ADD CONSTRAINT provider_schedule_exceptions_provider_entity_id_fkey FOREIGN KEY (provider_entity_id) REFERENCES public.entities(id) ON DELETE CASCADE;


--
-- Name: provider_schedules provider_schedules_organization_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.provider_schedules
    ADD CONSTRAINT provider_schedules_organization_id_fkey FOREIGN KEY (organization_id) REFERENCES public.organizations(id) ON DELETE CASCADE;


--
-- Name: provider_schedules provider_schedules_provider_entity_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.provider_schedules
    ADD CONSTRAINT provider_schedules_provider_entity_id_fkey FOREIGN KEY (provider_entity_id) REFERENCES public.entities(id) ON DELETE CASCADE;


--
-- Name: provider_skills provider_skills_provider_entity_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.provider_skills
    ADD CONSTRAINT provider_skills_provider_entity_id_fkey FOREIGN KEY (provider_entity_id) REFERENCES public.entities(id) ON DELETE CASCADE;


--
-- Name: provider_skills provider_skills_skill_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.provider_skills
    ADD CONSTRAINT provider_skills_skill_id_fkey FOREIGN KEY (skill_id) REFERENCES public.skill_definitions(id) ON DELETE CASCADE;


--
-- Name: provider_skills provider_skills_verified_by_fkey; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.provider_skills
    ADD CONSTRAINT provider_skills_verified_by_fkey FOREIGN KEY (verified_by) REFERENCES public.entities(id);


--
-- Name: resource_availability resource_availability_organization_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.resource_availability
    ADD CONSTRAINT resource_availability_organization_id_fkey FOREIGN KEY (organization_id) REFERENCES public.organizations(id) ON DELETE CASCADE;


--
-- Name: resource_availability resource_availability_resource_entity_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.resource_availability
    ADD CONSTRAINT resource_availability_resource_entity_id_fkey FOREIGN KEY (resource_entity_id) REFERENCES public.entities(id) ON DELETE CASCADE;


--
-- Name: resource_capabilities resource_capabilities_catalog_item_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.resource_capabilities
    ADD CONSTRAINT resource_capabilities_catalog_item_id_fkey FOREIGN KEY (catalog_item_id) REFERENCES public.catalog_items(id) ON DELETE CASCADE;


--
-- Name: resource_capabilities resource_capabilities_created_by_fkey; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.resource_capabilities
    ADD CONSTRAINT resource_capabilities_created_by_fkey FOREIGN KEY (created_by) REFERENCES auth.users(id);


--
-- Name: resource_capabilities resource_capabilities_deleted_by_fkey; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.resource_capabilities
    ADD CONSTRAINT resource_capabilities_deleted_by_fkey FOREIGN KEY (deleted_by) REFERENCES auth.users(id);


--
-- Name: resource_capabilities resource_capabilities_organization_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.resource_capabilities
    ADD CONSTRAINT resource_capabilities_organization_id_fkey FOREIGN KEY (organization_id) REFERENCES public.organizations(id) ON DELETE CASCADE;


--
-- Name: resource_capabilities resource_capabilities_resource_entity_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.resource_capabilities
    ADD CONSTRAINT resource_capabilities_resource_entity_id_fkey FOREIGN KEY (resource_entity_id) REFERENCES public.entities(id) ON DELETE CASCADE;


--
-- Name: resource_capabilities resource_capabilities_updated_by_fkey; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.resource_capabilities
    ADD CONSTRAINT resource_capabilities_updated_by_fkey FOREIGN KEY (updated_by) REFERENCES auth.users(id);


--
-- Name: resource_capability_availability resource_capability_availability_capability_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.resource_capability_availability
    ADD CONSTRAINT resource_capability_availability_capability_id_fkey FOREIGN KEY (capability_id) REFERENCES public.resource_capabilities(id) ON DELETE CASCADE;


--
-- Name: resource_unavailability resource_unavailability_organization_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.resource_unavailability
    ADD CONSTRAINT resource_unavailability_organization_id_fkey FOREIGN KEY (organization_id) REFERENCES public.organizations(id) ON DELETE CASCADE;


--
-- Name: resource_unavailability resource_unavailability_resource_entity_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.resource_unavailability
    ADD CONSTRAINT resource_unavailability_resource_entity_id_fkey FOREIGN KEY (resource_entity_id) REFERENCES public.entities(id) ON DELETE CASCADE;


--
-- Name: roles roles_created_by_fkey; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.roles
    ADD CONSTRAINT roles_created_by_fkey FOREIGN KEY (created_by) REFERENCES auth.users(id);


--
-- Name: roles roles_organization_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.roles
    ADD CONSTRAINT roles_organization_id_fkey FOREIGN KEY (organization_id) REFERENCES public.organizations(id) ON DELETE CASCADE;


--
-- Name: roles roles_updated_by_fkey; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.roles
    ADD CONSTRAINT roles_updated_by_fkey FOREIGN KEY (updated_by) REFERENCES auth.users(id);


--
-- Name: scheduled_shifts scheduled_shifts_created_by_fkey; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.scheduled_shifts
    ADD CONSTRAINT scheduled_shifts_created_by_fkey FOREIGN KEY (created_by) REFERENCES public.profiles(user_id);


--
-- Name: scheduled_shifts scheduled_shifts_department_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.scheduled_shifts
    ADD CONSTRAINT scheduled_shifts_department_id_fkey FOREIGN KEY (department_id) REFERENCES public.departments(id) ON DELETE SET NULL;


--
-- Name: scheduled_shifts scheduled_shifts_employee_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.scheduled_shifts
    ADD CONSTRAINT scheduled_shifts_employee_id_fkey FOREIGN KEY (employee_id) REFERENCES public.employees(id) ON DELETE CASCADE;


--
-- Name: scheduled_shifts scheduled_shifts_organization_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.scheduled_shifts
    ADD CONSTRAINT scheduled_shifts_organization_id_fkey FOREIGN KEY (organization_id) REFERENCES public.organizations(id) ON DELETE CASCADE;


--
-- Name: scheduled_shifts scheduled_shifts_original_employee_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.scheduled_shifts
    ADD CONSTRAINT scheduled_shifts_original_employee_id_fkey FOREIGN KEY (original_employee_id) REFERENCES public.employees(id);


--
-- Name: scheduled_shifts scheduled_shifts_published_by_fkey; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.scheduled_shifts
    ADD CONSTRAINT scheduled_shifts_published_by_fkey FOREIGN KEY (published_by) REFERENCES public.profiles(user_id);


--
-- Name: scheduled_shifts scheduled_shifts_shift_template_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.scheduled_shifts
    ADD CONSTRAINT scheduled_shifts_shift_template_id_fkey FOREIGN KEY (shift_template_id) REFERENCES public.shift_templates(id) ON DELETE SET NULL;


--
-- Name: service_providers service_providers_organization_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.service_providers
    ADD CONSTRAINT service_providers_organization_id_fkey FOREIGN KEY (organization_id) REFERENCES public.organizations(id) ON DELETE CASCADE;


--
-- Name: service_providers service_providers_provider_entity_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.service_providers
    ADD CONSTRAINT service_providers_provider_entity_id_fkey FOREIGN KEY (provider_entity_id) REFERENCES public.entities(id) ON DELETE CASCADE;


--
-- Name: service_providers service_providers_service_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.service_providers
    ADD CONSTRAINT service_providers_service_id_fkey FOREIGN KEY (service_id) REFERENCES public.services(id) ON DELETE CASCADE;


--
-- Name: services services_organization_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.services
    ADD CONSTRAINT services_organization_id_fkey FOREIGN KEY (organization_id) REFERENCES public.organizations(id) ON DELETE CASCADE;


--
-- Name: shift_templates shift_templates_organization_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.shift_templates
    ADD CONSTRAINT shift_templates_organization_id_fkey FOREIGN KEY (organization_id) REFERENCES public.organizations(id) ON DELETE CASCADE;


--
-- Name: skill_access skill_access_role_key_fkey; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.skill_access
    ADD CONSTRAINT skill_access_role_key_fkey FOREIGN KEY (role_key) REFERENCES public.roles(key) ON DELETE CASCADE;


--
-- Name: skill_definitions skill_definitions_organization_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.skill_definitions
    ADD CONSTRAINT skill_definitions_organization_id_fkey FOREIGN KEY (organization_id) REFERENCES public.organizations(id) ON DELETE CASCADE;


--
-- Name: skill_definitions skill_definitions_parent_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.skill_definitions
    ADD CONSTRAINT skill_definitions_parent_id_fkey FOREIGN KEY (parent_id) REFERENCES public.skill_definitions(id) ON DELETE SET NULL;


--
-- Name: subscriptions subscriptions_organization_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.subscriptions
    ADD CONSTRAINT subscriptions_organization_id_fkey FOREIGN KEY (organization_id) REFERENCES public.organizations(id) ON DELETE CASCADE;


--
-- Name: subscriptions subscriptions_plan_key_fkey; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.subscriptions
    ADD CONSTRAINT subscriptions_plan_key_fkey FOREIGN KEY (plan_key) REFERENCES public.subscription_plans(key);


--
-- Name: time_entries time_entries_approved_by_fkey; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.time_entries
    ADD CONSTRAINT time_entries_approved_by_fkey FOREIGN KEY (approved_by) REFERENCES public.profiles(user_id);


--
-- Name: time_entries time_entries_created_by_fkey; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.time_entries
    ADD CONSTRAINT time_entries_created_by_fkey FOREIGN KEY (created_by) REFERENCES public.profiles(user_id);


--
-- Name: time_entries time_entries_deleted_by_fkey; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.time_entries
    ADD CONSTRAINT time_entries_deleted_by_fkey FOREIGN KEY (deleted_by) REFERENCES public.profiles(user_id);


--
-- Name: time_entries time_entries_department_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.time_entries
    ADD CONSTRAINT time_entries_department_id_fkey FOREIGN KEY (department_id) REFERENCES public.departments(id);


--
-- Name: time_entries time_entries_employee_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.time_entries
    ADD CONSTRAINT time_entries_employee_id_fkey FOREIGN KEY (employee_id) REFERENCES public.employees(id) ON DELETE CASCADE;


--
-- Name: time_entries time_entries_organization_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.time_entries
    ADD CONSTRAINT time_entries_organization_id_fkey FOREIGN KEY (organization_id) REFERENCES public.organizations(id) ON DELETE CASCADE;


--
-- Name: time_entries time_entries_original_entry_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.time_entries
    ADD CONSTRAINT time_entries_original_entry_id_fkey FOREIGN KEY (original_entry_id) REFERENCES public.time_entries(id);


--
-- Name: time_entry_modifications time_entry_modifications_modified_by_fkey; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.time_entry_modifications
    ADD CONSTRAINT time_entry_modifications_modified_by_fkey FOREIGN KEY (modified_by) REFERENCES public.profiles(user_id);


--
-- Name: time_entry_modifications time_entry_modifications_time_entry_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.time_entry_modifications
    ADD CONSTRAINT time_entry_modifications_time_entry_id_fkey FOREIGN KEY (time_entry_id) REFERENCES public.time_entries(id) ON DELETE CASCADE;


--
-- Name: user_roles user_roles_granted_by_fkey; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.user_roles
    ADD CONSTRAINT user_roles_granted_by_fkey FOREIGN KEY (granted_by) REFERENCES public.profiles(user_id);


--
-- Name: user_roles user_roles_role_key_fkey; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.user_roles
    ADD CONSTRAINT user_roles_role_key_fkey FOREIGN KEY (role_key) REFERENCES public.roles(key);


--
-- Name: user_roles user_roles_user_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.user_roles
    ADD CONSTRAINT user_roles_user_id_fkey FOREIGN KEY (user_id) REFERENCES public.profiles(user_id) ON DELETE CASCADE;


--
-- Name: user_sessions user_sessions_active_org_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.user_sessions
    ADD CONSTRAINT user_sessions_active_org_id_fkey FOREIGN KEY (active_org_id) REFERENCES public.organizations(id) ON DELETE SET NULL;


--
-- Name: user_sessions user_sessions_user_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.user_sessions
    ADD CONSTRAINT user_sessions_user_id_fkey FOREIGN KEY (user_id) REFERENCES public.profiles(user_id) ON DELETE CASCADE;


--
-- Name: vertical_configs vertical_configs_organization_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.vertical_configs
    ADD CONSTRAINT vertical_configs_organization_id_fkey FOREIGN KEY (organization_id) REFERENCES public.organizations(id) ON DELETE CASCADE;


--
-- Name: waitlist_configurations waitlist_configurations_location_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.waitlist_configurations
    ADD CONSTRAINT waitlist_configurations_location_id_fkey FOREIGN KEY (location_id) REFERENCES public.entities(id) ON DELETE CASCADE;


--
-- Name: waitlist_configurations waitlist_configurations_organization_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.waitlist_configurations
    ADD CONSTRAINT waitlist_configurations_organization_id_fkey FOREIGN KEY (organization_id) REFERENCES public.organizations(id) ON DELETE CASCADE;


--
-- Name: waitlist_entries waitlist_entries_client_entity_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.waitlist_entries
    ADD CONSTRAINT waitlist_entries_client_entity_id_fkey FOREIGN KEY (client_entity_id) REFERENCES public.entities(id) ON DELETE SET NULL;


--
-- Name: waitlist_entries waitlist_entries_converted_appointment_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.waitlist_entries
    ADD CONSTRAINT waitlist_entries_converted_appointment_id_fkey FOREIGN KEY (converted_appointment_id) REFERENCES public.appointments(id) ON DELETE SET NULL;


--
-- Name: waitlist_entries waitlist_entries_created_by_fkey; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.waitlist_entries
    ADD CONSTRAINT waitlist_entries_created_by_fkey FOREIGN KEY (created_by) REFERENCES auth.users(id);


--
-- Name: waitlist_entries waitlist_entries_location_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.waitlist_entries
    ADD CONSTRAINT waitlist_entries_location_id_fkey FOREIGN KEY (location_id) REFERENCES public.entities(id) ON DELETE SET NULL;


--
-- Name: waitlist_entries waitlist_entries_organization_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.waitlist_entries
    ADD CONSTRAINT waitlist_entries_organization_id_fkey FOREIGN KEY (organization_id) REFERENCES public.organizations(id) ON DELETE CASCADE;


--
-- Name: waitlist_entries waitlist_entries_preferred_resource_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.waitlist_entries
    ADD CONSTRAINT waitlist_entries_preferred_resource_id_fkey FOREIGN KEY (preferred_resource_id) REFERENCES public.entities(id) ON DELETE SET NULL;


--
-- Name: waitlist_entries waitlist_entries_processed_by_staff_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.waitlist_entries
    ADD CONSTRAINT waitlist_entries_processed_by_staff_id_fkey FOREIGN KEY (processed_by_staff_id) REFERENCES public.entities(id) ON DELETE SET NULL;


--
-- Name: waitlist_entries waitlist_entries_service_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.waitlist_entries
    ADD CONSTRAINT waitlist_entries_service_id_fkey FOREIGN KEY (service_id) REFERENCES public.catalog_items(id) ON DELETE SET NULL;


--
-- Name: walkin_configurations walkin_configurations_location_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.walkin_configurations
    ADD CONSTRAINT walkin_configurations_location_id_fkey FOREIGN KEY (location_id) REFERENCES public.entities(id) ON DELETE CASCADE;


--
-- Name: walkin_configurations walkin_configurations_organization_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.walkin_configurations
    ADD CONSTRAINT walkin_configurations_organization_id_fkey FOREIGN KEY (organization_id) REFERENCES public.organizations(id) ON DELETE CASCADE;


--
-- Name: walkin_entries walkin_entries_ai_suggested_resource_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.walkin_entries
    ADD CONSTRAINT walkin_entries_ai_suggested_resource_id_fkey FOREIGN KEY (ai_suggested_resource_id) REFERENCES public.entities(id) ON DELETE SET NULL;


--
-- Name: walkin_entries walkin_entries_assigned_resource_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.walkin_entries
    ADD CONSTRAINT walkin_entries_assigned_resource_id_fkey FOREIGN KEY (assigned_resource_id) REFERENCES public.entities(id) ON DELETE SET NULL;


--
-- Name: walkin_entries walkin_entries_client_entity_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.walkin_entries
    ADD CONSTRAINT walkin_entries_client_entity_id_fkey FOREIGN KEY (client_entity_id) REFERENCES public.entities(id) ON DELETE SET NULL;


--
-- Name: walkin_entries walkin_entries_created_appointment_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.walkin_entries
    ADD CONSTRAINT walkin_entries_created_appointment_id_fkey FOREIGN KEY (created_appointment_id) REFERENCES public.appointments(id) ON DELETE SET NULL;


--
-- Name: walkin_entries walkin_entries_created_by_fkey; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.walkin_entries
    ADD CONSTRAINT walkin_entries_created_by_fkey FOREIGN KEY (created_by) REFERENCES auth.users(id);


--
-- Name: walkin_entries walkin_entries_gap_from_appointment_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.walkin_entries
    ADD CONSTRAINT walkin_entries_gap_from_appointment_id_fkey FOREIGN KEY (gap_from_appointment_id) REFERENCES public.appointments(id) ON DELETE SET NULL;


--
-- Name: walkin_entries walkin_entries_location_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.walkin_entries
    ADD CONSTRAINT walkin_entries_location_id_fkey FOREIGN KEY (location_id) REFERENCES public.entities(id) ON DELETE CASCADE;


--
-- Name: walkin_entries walkin_entries_organization_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.walkin_entries
    ADD CONSTRAINT walkin_entries_organization_id_fkey FOREIGN KEY (organization_id) REFERENCES public.organizations(id) ON DELETE CASCADE;


--
-- Name: walkin_entries walkin_entries_preferred_resource_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.walkin_entries
    ADD CONSTRAINT walkin_entries_preferred_resource_id_fkey FOREIGN KEY (preferred_resource_id) REFERENCES public.entities(id) ON DELETE SET NULL;


--
-- Name: walkin_entries walkin_entries_processed_by_staff_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.walkin_entries
    ADD CONSTRAINT walkin_entries_processed_by_staff_id_fkey FOREIGN KEY (processed_by_staff_id) REFERENCES public.entities(id) ON DELETE SET NULL;


--
-- Name: walkin_entries walkin_entries_service_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.walkin_entries
    ADD CONSTRAINT walkin_entries_service_id_fkey FOREIGN KEY (service_id) REFERENCES public.catalog_items(id) ON DELETE SET NULL;


--
-- Name: whatsapp_conversations whatsapp_conversations_entity_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.whatsapp_conversations
    ADD CONSTRAINT whatsapp_conversations_entity_id_fkey FOREIGN KEY (entity_id) REFERENCES public.entities(id) ON DELETE SET NULL;


--
-- Name: whatsapp_conversations whatsapp_conversations_organization_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.whatsapp_conversations
    ADD CONSTRAINT whatsapp_conversations_organization_id_fkey FOREIGN KEY (organization_id) REFERENCES public.organizations(id) ON DELETE CASCADE;


--
-- Name: whatsapp_conversations whatsapp_conversations_user_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.whatsapp_conversations
    ADD CONSTRAINT whatsapp_conversations_user_id_fkey FOREIGN KEY (user_id) REFERENCES auth.users(id) ON DELETE SET NULL;


--
-- Name: whatsapp_messages whatsapp_messages_conversation_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.whatsapp_messages
    ADD CONSTRAINT whatsapp_messages_conversation_id_fkey FOREIGN KEY (conversation_id) REFERENCES public.whatsapp_conversations(id) ON DELETE CASCADE;


--
-- Name: whatsapp_org_config whatsapp_org_config_organization_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.whatsapp_org_config
    ADD CONSTRAINT whatsapp_org_config_organization_id_fkey FOREIGN KEY (organization_id) REFERENCES public.organizations(id) ON DELETE CASCADE;


--
-- Name: work_policies work_policies_organization_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.work_policies
    ADD CONSTRAINT work_policies_organization_id_fkey FOREIGN KEY (organization_id) REFERENCES public.organizations(id) ON DELETE CASCADE;


--
-- Name: subscription_plans Anyone can view active plans; Type: POLICY; Schema: public; Owner: -
--

CREATE POLICY "Anyone can view active plans" ON public.subscription_plans FOR SELECT USING (((is_active = true) AND (is_public = true)));


--
-- Name: ai_skill_executions Executions are scoped to organization; Type: POLICY; Schema: public; Owner: -
--

CREATE POLICY "Executions are scoped to organization" ON public.ai_skill_executions TO authenticated USING ((organization_id IN ( SELECT employees.organization_id
   FROM public.employees
  WHERE (ai_skill_executions.user_id = auth.uid()))));


--
-- Name: org_knowledge_base Knowledge is scoped to organization; Type: POLICY; Schema: public; Owner: -
--

CREATE POLICY "Knowledge is scoped to organization" ON public.org_knowledge_base TO authenticated USING (((organization_id = public.current_org_id()) OR (auth.role() = 'service_role'::text)));


--
-- Name: subscriptions Platform admins can manage all subscriptions; Type: POLICY; Schema: public; Owner: -
--

CREATE POLICY "Platform admins can manage all subscriptions" ON public.subscriptions USING ((EXISTS ( SELECT 1
   FROM public.user_roles
  WHERE ((user_roles.user_id = auth.uid()) AND (user_roles.role_key = 'platform_admin'::text)))));


--
-- Name: user_roles Platform admins can manage roles; Type: POLICY; Schema: public; Owner: -
--

CREATE POLICY "Platform admins can manage roles" ON public.user_roles USING ((EXISTS ( SELECT 1
   FROM public.user_roles user_roles_1
  WHERE ((user_roles_1.user_id = auth.uid()) AND (user_roles_1.role_key = 'platform_admin'::text)))));


--
-- Name: user_roles Platform admins can view all roles; Type: POLICY; Schema: public; Owner: -
--

CREATE POLICY "Platform admins can view all roles" ON public.user_roles FOR SELECT USING ((EXISTS ( SELECT 1
   FROM public.user_roles user_roles_1
  WHERE ((user_roles_1.user_id = auth.uid()) AND (user_roles_1.role_key = 'platform_admin'::text)))));


--
-- Name: subscriptions Platform admins can view all subscriptions; Type: POLICY; Schema: public; Owner: -
--

CREATE POLICY "Platform admins can view all subscriptions" ON public.subscriptions FOR SELECT USING ((EXISTS ( SELECT 1
   FROM public.user_roles
  WHERE ((user_roles.user_id = auth.uid()) AND (user_roles.role_key = 'platform_admin'::text)))));


--
-- Name: ai_skill_executions Service role can manage executions; Type: POLICY; Schema: public; Owner: -
--

CREATE POLICY "Service role can manage executions" ON public.ai_skill_executions TO service_role USING (true) WITH CHECK (true);


--
-- Name: org_knowledge_base Service role can manage knowledge; Type: POLICY; Schema: public; Owner: -
--

CREATE POLICY "Service role can manage knowledge" ON public.org_knowledge_base TO service_role USING (true) WITH CHECK (true);


--
-- Name: ai_skills Service role can manage skills; Type: POLICY; Schema: public; Owner: -
--

CREATE POLICY "Service role can manage skills" ON public.ai_skills TO service_role USING (true) WITH CHECK (true);


--
-- Name: user_sessions Service role full access; Type: POLICY; Schema: public; Owner: -
--

CREATE POLICY "Service role full access" ON public.user_sessions TO service_role USING (true) WITH CHECK (true);


--
-- Name: bot_messages Service role full access on bot_messages; Type: POLICY; Schema: public; Owner: -
--

CREATE POLICY "Service role full access on bot_messages" ON public.bot_messages TO service_role USING (true) WITH CHECK (true);


--
-- Name: memberships Service role full access on memberships; Type: POLICY; Schema: public; Owner: -
--

CREATE POLICY "Service role full access on memberships" ON public.memberships TO service_role USING (true) WITH CHECK (true);


--
-- Name: nlu_intent_examples Service role full access on nlu_intent_examples; Type: POLICY; Schema: public; Owner: -
--

CREATE POLICY "Service role full access on nlu_intent_examples" ON public.nlu_intent_examples TO service_role USING (true) WITH CHECK (true);


--
-- Name: nlu_intent_signals Service role full access on nlu_intent_signals; Type: POLICY; Schema: public; Owner: -
--

CREATE POLICY "Service role full access on nlu_intent_signals" ON public.nlu_intent_signals TO service_role USING (true) WITH CHECK (true);


--
-- Name: nlu_keywords Service role full access on nlu_keywords; Type: POLICY; Schema: public; Owner: -
--

CREATE POLICY "Service role full access on nlu_keywords" ON public.nlu_keywords TO service_role USING (true) WITH CHECK (true);


--
-- Name: nlu_typo_corrections Service role full access on nlu_typo_corrections; Type: POLICY; Schema: public; Owner: -
--

CREATE POLICY "Service role full access on nlu_typo_corrections" ON public.nlu_typo_corrections TO service_role USING (true) WITH CHECK (true);


--
-- Name: roles Service role full access on roles; Type: POLICY; Schema: public; Owner: -
--

CREATE POLICY "Service role full access on roles" ON public.roles TO service_role USING (true) WITH CHECK (true);


--
-- Name: skill_access Service role full access on skill_access; Type: POLICY; Schema: public; Owner: -
--

CREATE POLICY "Service role full access on skill_access" ON public.skill_access TO service_role USING (true) WITH CHECK (true);


--
-- Name: vertical_configs Service role full access on vertical_configs; Type: POLICY; Schema: public; Owner: -
--

CREATE POLICY "Service role full access on vertical_configs" ON public.vertical_configs TO service_role USING (true) WITH CHECK (true);


--
-- Name: whatsapp_org_config Service role full access on whatsapp_org_config; Type: POLICY; Schema: public; Owner: -
--

CREATE POLICY "Service role full access on whatsapp_org_config" ON public.whatsapp_org_config TO service_role USING (true) WITH CHECK (true);


--
-- Name: subscription_plans Service role full access plans; Type: POLICY; Schema: public; Owner: -
--

CREATE POLICY "Service role full access plans" ON public.subscription_plans TO service_role USING (true) WITH CHECK (true);


--
-- Name: subscriptions Service role full access subscriptions; Type: POLICY; Schema: public; Owner: -
--

CREATE POLICY "Service role full access subscriptions" ON public.subscriptions TO service_role USING (true) WITH CHECK (true);


--
-- Name: patient_code_sequences Service role has full access to sequences; Type: POLICY; Schema: public; Owner: -
--

CREATE POLICY "Service role has full access to sequences" ON public.patient_code_sequences TO service_role USING (true) WITH CHECK (true);


--
-- Name: ai_skills Skills are readable by authenticated users; Type: POLICY; Schema: public; Owner: -
--

CREATE POLICY "Skills are readable by authenticated users" ON public.ai_skills FOR SELECT TO authenticated USING ((enabled = true));


--
-- Name: user_sessions Users can insert own session; Type: POLICY; Schema: public; Owner: -
--

CREATE POLICY "Users can insert own session" ON public.user_sessions FOR INSERT TO authenticated WITH CHECK ((auth.uid() = user_id));


--
-- Name: user_sessions Users can update own session; Type: POLICY; Schema: public; Owner: -
--

CREATE POLICY "Users can update own session" ON public.user_sessions FOR UPDATE TO authenticated USING ((auth.uid() = user_id));


--
-- Name: memberships Users can view memberships in their organizations; Type: POLICY; Schema: public; Owner: -
--

CREATE POLICY "Users can view memberships in their organizations" ON public.memberships FOR SELECT TO authenticated USING ((organization_id IN ( SELECT auth.user_organizations() AS user_organizations)));


--
-- Name: subscriptions Users can view own org subscription; Type: POLICY; Schema: public; Owner: -
--

CREATE POLICY "Users can view own org subscription" ON public.subscriptions FOR SELECT USING ((organization_id IN ( SELECT memberships.organization_id
   FROM public.memberships
  WHERE (memberships.user_id = auth.uid()))));


--
-- Name: user_roles Users can view own roles; Type: POLICY; Schema: public; Owner: -
--

CREATE POLICY "Users can view own roles" ON public.user_roles FOR SELECT USING ((user_id = auth.uid()));


--
-- Name: user_sessions Users can view own session; Type: POLICY; Schema: public; Owner: -
--

CREATE POLICY "Users can view own session" ON public.user_sessions FOR SELECT TO authenticated USING ((auth.uid() = user_id));


--
-- Name: roles Users can view system roles; Type: POLICY; Schema: public; Owner: -
--

CREATE POLICY "Users can view system roles" ON public.roles FOR SELECT TO authenticated USING ((is_system = true));


--
-- Name: ai_cache; Type: ROW SECURITY; Schema: public; Owner: -
--

ALTER TABLE public.ai_cache ENABLE ROW LEVEL SECURITY;

--
-- Name: ai_cache ai_cache_delete_policy; Type: POLICY; Schema: public; Owner: -
--

CREATE POLICY ai_cache_delete_policy ON public.ai_cache FOR DELETE USING ((auth.role() = 'service_role'::text));


--
-- Name: ai_cache ai_cache_insert_policy; Type: POLICY; Schema: public; Owner: -
--

CREATE POLICY ai_cache_insert_policy ON public.ai_cache FOR INSERT WITH CHECK ((auth.role() = 'service_role'::text));


--
-- Name: ai_cache ai_cache_select_policy; Type: POLICY; Schema: public; Owner: -
--

CREATE POLICY ai_cache_select_policy ON public.ai_cache FOR SELECT USING (((organization_id = public.current_org_id()) OR (organization_id IS NULL) OR (auth.role() = 'service_role'::text)));


--
-- Name: POLICY ai_cache_select_policy ON ai_cache; Type: COMMENT; Schema: public; Owner: -
--

COMMENT ON POLICY ai_cache_select_policy ON public.ai_cache IS 'Cache can be shared across organization for efficiency. Service role manages cache lifecycle.';


--
-- Name: ai_cache ai_cache_update_policy; Type: POLICY; Schema: public; Owner: -
--

CREATE POLICY ai_cache_update_policy ON public.ai_cache FOR UPDATE USING ((auth.role() = 'service_role'::text));


--
-- Name: ai_conversations; Type: ROW SECURITY; Schema: public; Owner: -
--

ALTER TABLE public.ai_conversations ENABLE ROW LEVEL SECURITY;

--
-- Name: ai_conversations ai_conversations_delete_policy; Type: POLICY; Schema: public; Owner: -
--

CREATE POLICY ai_conversations_delete_policy ON public.ai_conversations FOR DELETE USING (((user_id = auth.uid()) OR (auth.role() = 'service_role'::text)));


--
-- Name: ai_conversations ai_conversations_insert_policy; Type: POLICY; Schema: public; Owner: -
--

CREATE POLICY ai_conversations_insert_policy ON public.ai_conversations FOR INSERT WITH CHECK (((user_id = auth.uid()) AND (organization_id = public.current_org_id())));


--
-- Name: ai_conversations ai_conversations_select_policy; Type: POLICY; Schema: public; Owner: -
--

CREATE POLICY ai_conversations_select_policy ON public.ai_conversations FOR SELECT USING (((user_id = auth.uid()) OR (auth.role() = 'service_role'::text)));


--
-- Name: POLICY ai_conversations_select_policy ON ai_conversations; Type: COMMENT; Schema: public; Owner: -
--

COMMENT ON POLICY ai_conversations_select_policy ON public.ai_conversations IS 'Users can only access their own AI conversations. Full isolation between users.';


--
-- Name: ai_conversations ai_conversations_update_policy; Type: POLICY; Schema: public; Owner: -
--

CREATE POLICY ai_conversations_update_policy ON public.ai_conversations FOR UPDATE USING (((user_id = auth.uid()) OR (auth.role() = 'service_role'::text)));


--
-- Name: ai_embedding_queue; Type: ROW SECURITY; Schema: public; Owner: -
--

ALTER TABLE public.ai_embedding_queue ENABLE ROW LEVEL SECURITY;

--
-- Name: ai_embedding_queue ai_embedding_queue_delete_policy; Type: POLICY; Schema: public; Owner: -
--

CREATE POLICY ai_embedding_queue_delete_policy ON public.ai_embedding_queue FOR DELETE USING ((auth.role() = 'service_role'::text));


--
-- Name: ai_embedding_queue ai_embedding_queue_insert_policy; Type: POLICY; Schema: public; Owner: -
--

CREATE POLICY ai_embedding_queue_insert_policy ON public.ai_embedding_queue FOR INSERT WITH CHECK (((organization_id = public.current_org_id()) OR (auth.role() = 'service_role'::text)));


--
-- Name: ai_embedding_queue ai_embedding_queue_select_policy; Type: POLICY; Schema: public; Owner: -
--

CREATE POLICY ai_embedding_queue_select_policy ON public.ai_embedding_queue FOR SELECT USING (((organization_id = public.current_org_id()) OR (auth.role() = 'service_role'::text)));


--
-- Name: ai_embedding_queue ai_embedding_queue_update_policy; Type: POLICY; Schema: public; Owner: -
--

CREATE POLICY ai_embedding_queue_update_policy ON public.ai_embedding_queue FOR UPDATE USING ((auth.role() = 'service_role'::text));


--
-- Name: ai_embeddings; Type: ROW SECURITY; Schema: public; Owner: -
--

ALTER TABLE public.ai_embeddings ENABLE ROW LEVEL SECURITY;

--
-- Name: ai_embeddings ai_embeddings_delete_policy; Type: POLICY; Schema: public; Owner: -
--

CREATE POLICY ai_embeddings_delete_policy ON public.ai_embeddings FOR DELETE USING ((auth.role() = 'service_role'::text));


--
-- Name: ai_embeddings ai_embeddings_insert_policy; Type: POLICY; Schema: public; Owner: -
--

CREATE POLICY ai_embeddings_insert_policy ON public.ai_embeddings FOR INSERT WITH CHECK ((auth.role() = 'service_role'::text));


--
-- Name: ai_embeddings ai_embeddings_select_policy; Type: POLICY; Schema: public; Owner: -
--

CREATE POLICY ai_embeddings_select_policy ON public.ai_embeddings FOR SELECT USING (((organization_id = public.current_org_id()) OR (auth.role() = 'service_role'::text)));


--
-- Name: POLICY ai_embeddings_select_policy ON ai_embeddings; Type: COMMENT; Schema: public; Owner: -
--

COMMENT ON POLICY ai_embeddings_select_policy ON public.ai_embeddings IS 'Users can view embeddings from their organization. Service role has full access.';


--
-- Name: ai_embeddings ai_embeddings_update_policy; Type: POLICY; Schema: public; Owner: -
--

CREATE POLICY ai_embeddings_update_policy ON public.ai_embeddings FOR UPDATE USING ((auth.role() = 'service_role'::text));


--
-- Name: ai_interactions; Type: ROW SECURITY; Schema: public; Owner: -
--

ALTER TABLE public.ai_interactions ENABLE ROW LEVEL SECURITY;

--
-- Name: ai_search_logs; Type: ROW SECURITY; Schema: public; Owner: -
--

ALTER TABLE public.ai_search_logs ENABLE ROW LEVEL SECURITY;

--
-- Name: ai_search_logs ai_search_logs_delete_policy; Type: POLICY; Schema: public; Owner: -
--

CREATE POLICY ai_search_logs_delete_policy ON public.ai_search_logs FOR DELETE USING ((auth.role() = 'service_role'::text));


--
-- Name: ai_search_logs ai_search_logs_insert_policy; Type: POLICY; Schema: public; Owner: -
--

CREATE POLICY ai_search_logs_insert_policy ON public.ai_search_logs FOR INSERT WITH CHECK (((organization_id = public.current_org_id()) OR (auth.role() = 'service_role'::text)));


--
-- Name: ai_search_logs ai_search_logs_select_policy; Type: POLICY; Schema: public; Owner: -
--

CREATE POLICY ai_search_logs_select_policy ON public.ai_search_logs FOR SELECT USING (((organization_id = public.current_org_id()) OR (auth.role() = 'service_role'::text)));


--
-- Name: POLICY ai_search_logs_select_policy ON ai_search_logs; Type: COMMENT; Schema: public; Owner: -
--

COMMENT ON POLICY ai_search_logs_select_policy ON public.ai_search_logs IS 'Organization members can view search analytics. Logs are org-scoped for privacy.';


--
-- Name: ai_search_logs ai_search_logs_update_policy; Type: POLICY; Schema: public; Owner: -
--

CREATE POLICY ai_search_logs_update_policy ON public.ai_search_logs FOR UPDATE USING ((auth.role() = 'service_role'::text));


--
-- Name: ai_skill_executions; Type: ROW SECURITY; Schema: public; Owner: -
--

ALTER TABLE public.ai_skill_executions ENABLE ROW LEVEL SECURITY;

--
-- Name: ai_skills; Type: ROW SECURITY; Schema: public; Owner: -
--

ALTER TABLE public.ai_skills ENABLE ROW LEVEL SECURITY;

--
-- Name: ai_usage; Type: ROW SECURITY; Schema: public; Owner: -
--

ALTER TABLE public.ai_usage ENABLE ROW LEVEL SECURITY;

--
-- Name: appointment_audit_log; Type: ROW SECURITY; Schema: public; Owner: -
--

ALTER TABLE public.appointment_audit_log ENABLE ROW LEVEL SECURITY;

--
-- Name: appointment_resources; Type: ROW SECURITY; Schema: public; Owner: -
--

ALTER TABLE public.appointment_resources ENABLE ROW LEVEL SECURITY;

--
-- Name: appointment_resources appointment_resources_insert_policy; Type: POLICY; Schema: public; Owner: -
--

CREATE POLICY appointment_resources_insert_policy ON public.appointment_resources FOR INSERT WITH CHECK ((appointment_id IN ( SELECT appointments.id
   FROM public.appointments
  WHERE (appointments.organization_id = public.current_org_id()))));


--
-- Name: appointment_resources appointment_resources_select_policy; Type: POLICY; Schema: public; Owner: -
--

CREATE POLICY appointment_resources_select_policy ON public.appointment_resources FOR SELECT USING ((appointment_id IN ( SELECT appointments.id
   FROM public.appointments
  WHERE (appointments.organization_id = public.current_org_id()))));


--
-- Name: appointments; Type: ROW SECURITY; Schema: public; Owner: -
--

ALTER TABLE public.appointments ENABLE ROW LEVEL SECURITY;

--
-- Name: appointments appointments_delete_policy; Type: POLICY; Schema: public; Owner: -
--

CREATE POLICY appointments_delete_policy ON public.appointments FOR DELETE USING ((organization_id = public.current_org_id()));


--
-- Name: appointments appointments_insert_policy; Type: POLICY; Schema: public; Owner: -
--

CREATE POLICY appointments_insert_policy ON public.appointments FOR INSERT WITH CHECK ((organization_id = public.current_org_id()));


--
-- Name: appointments appointments_select_policy; Type: POLICY; Schema: public; Owner: -
--

CREATE POLICY appointments_select_policy ON public.appointments FOR SELECT USING ((organization_id = public.current_org_id()));


--
-- Name: appointments appointments_update_policy; Type: POLICY; Schema: public; Owner: -
--

CREATE POLICY appointments_update_policy ON public.appointments FOR UPDATE USING ((organization_id = public.current_org_id()));


--
-- Name: attribute_definitions; Type: ROW SECURITY; Schema: public; Owner: -
--

ALTER TABLE public.attribute_definitions ENABLE ROW LEVEL SECURITY;

--
-- Name: attribute_definitions attribute_definitions_access; Type: POLICY; Schema: public; Owner: -
--

CREATE POLICY attribute_definitions_access ON public.attribute_definitions USING (((organization_id IS NULL) OR (organization_id = COALESCE((current_setting('app.current_organization_id'::text, true))::uuid, organization_id))));


--
-- Name: attribute_definitions attribute_definitions_service_role; Type: POLICY; Schema: public; Owner: -
--

CREATE POLICY attribute_definitions_service_role ON public.attribute_definitions TO service_role USING (true) WITH CHECK (true);


--
-- Name: appointment_audit_log audit_log_insert_policy; Type: POLICY; Schema: public; Owner: -
--

CREATE POLICY audit_log_insert_policy ON public.appointment_audit_log FOR INSERT WITH CHECK ((organization_id = public.current_org_id()));


--
-- Name: appointment_audit_log audit_log_select_policy; Type: POLICY; Schema: public; Owner: -
--

CREATE POLICY audit_log_select_policy ON public.appointment_audit_log FOR SELECT USING ((organization_id = public.current_org_id()));


--
-- Name: audit_logs; Type: ROW SECURITY; Schema: public; Owner: -
--

ALTER TABLE public.audit_logs ENABLE ROW LEVEL SECURITY;

--
-- Name: audit_logs audit_logs_insert_policy; Type: POLICY; Schema: public; Owner: -
--

CREATE POLICY audit_logs_insert_policy ON public.audit_logs FOR INSERT WITH CHECK ((auth.role() = 'service_role'::text));


--
-- Name: audit_logs audit_logs_select_policy; Type: POLICY; Schema: public; Owner: -
--

CREATE POLICY audit_logs_select_policy ON public.audit_logs FOR SELECT USING (((organization_id = public.current_org_id()) OR (auth.role() = 'service_role'::text)));


--
-- Name: resource_capability_availability availability_delete; Type: POLICY; Schema: public; Owner: -
--

CREATE POLICY availability_delete ON public.resource_capability_availability FOR DELETE USING (true);


--
-- Name: resource_capability_availability availability_insert; Type: POLICY; Schema: public; Owner: -
--

CREATE POLICY availability_insert ON public.resource_capability_availability FOR INSERT WITH CHECK (true);


--
-- Name: resource_capability_availability availability_select; Type: POLICY; Schema: public; Owner: -
--

CREATE POLICY availability_select ON public.resource_capability_availability FOR SELECT USING (true);


--
-- Name: resource_capability_availability availability_update; Type: POLICY; Schema: public; Owner: -
--

CREATE POLICY availability_update ON public.resource_capability_availability FOR UPDATE USING (true);


--
-- Name: booking_configurations booking_config_insert_policy; Type: POLICY; Schema: public; Owner: -
--

CREATE POLICY booking_config_insert_policy ON public.booking_configurations FOR INSERT WITH CHECK ((organization_id = public.current_org_id()));


--
-- Name: booking_configurations booking_config_select_policy; Type: POLICY; Schema: public; Owner: -
--

CREATE POLICY booking_config_select_policy ON public.booking_configurations FOR SELECT USING (true);


--
-- Name: booking_configurations booking_config_update_policy; Type: POLICY; Schema: public; Owner: -
--

CREATE POLICY booking_config_update_policy ON public.booking_configurations FOR UPDATE USING ((organization_id = public.current_org_id()));


--
-- Name: booking_configurations; Type: ROW SECURITY; Schema: public; Owner: -
--

ALTER TABLE public.booking_configurations ENABLE ROW LEVEL SECURITY;

--
-- Name: bot_messages; Type: ROW SECURITY; Schema: public; Owner: -
--

ALTER TABLE public.bot_messages ENABLE ROW LEVEL SECURITY;

--
-- Name: calendar_connections; Type: ROW SECURITY; Schema: public; Owner: -
--

ALTER TABLE public.calendar_connections ENABLE ROW LEVEL SECURITY;

--
-- Name: calendar_connections calendar_connections_delete_policy; Type: POLICY; Schema: public; Owner: -
--

CREATE POLICY calendar_connections_delete_policy ON public.calendar_connections FOR DELETE USING ((user_id = auth.uid()));


--
-- Name: calendar_connections calendar_connections_insert_policy; Type: POLICY; Schema: public; Owner: -
--

CREATE POLICY calendar_connections_insert_policy ON public.calendar_connections FOR INSERT WITH CHECK ((user_id = auth.uid()));


--
-- Name: calendar_connections calendar_connections_select_policy; Type: POLICY; Schema: public; Owner: -
--

CREATE POLICY calendar_connections_select_policy ON public.calendar_connections FOR SELECT USING ((user_id = auth.uid()));


--
-- Name: calendar_connections calendar_connections_update_policy; Type: POLICY; Schema: public; Owner: -
--

CREATE POLICY calendar_connections_update_policy ON public.calendar_connections FOR UPDATE USING ((user_id = auth.uid()));


--
-- Name: resource_capabilities capabilities_delete; Type: POLICY; Schema: public; Owner: -
--

CREATE POLICY capabilities_delete ON public.resource_capabilities FOR DELETE USING (true);


--
-- Name: resource_capabilities capabilities_insert; Type: POLICY; Schema: public; Owner: -
--

CREATE POLICY capabilities_insert ON public.resource_capabilities FOR INSERT WITH CHECK (true);


--
-- Name: resource_capabilities capabilities_select; Type: POLICY; Schema: public; Owner: -
--

CREATE POLICY capabilities_select ON public.resource_capabilities FOR SELECT USING (true);


--
-- Name: resource_capabilities capabilities_update; Type: POLICY; Schema: public; Owner: -
--

CREATE POLICY capabilities_update ON public.resource_capabilities FOR UPDATE USING (true);


--
-- Name: catalog_categories; Type: ROW SECURITY; Schema: public; Owner: -
--

ALTER TABLE public.catalog_categories ENABLE ROW LEVEL SECURITY;

--
-- Name: catalog_categories catalog_categories_org_isolation; Type: POLICY; Schema: public; Owner: -
--

CREATE POLICY catalog_categories_org_isolation ON public.catalog_categories USING ((organization_id = COALESCE((current_setting('app.current_organization_id'::text, true))::uuid, organization_id)));


--
-- Name: catalog_categories catalog_categories_service_role; Type: POLICY; Schema: public; Owner: -
--

CREATE POLICY catalog_categories_service_role ON public.catalog_categories TO service_role USING (true) WITH CHECK (true);


--
-- Name: catalog_items; Type: ROW SECURITY; Schema: public; Owner: -
--

ALTER TABLE public.catalog_items ENABLE ROW LEVEL SECURITY;

--
-- Name: catalog_items catalog_items_org_isolation; Type: POLICY; Schema: public; Owner: -
--

CREATE POLICY catalog_items_org_isolation ON public.catalog_items USING (((organization_id IN ( SELECT memberships.organization_id
   FROM public.memberships
  WHERE ((memberships.user_id = auth.uid()) AND (memberships.status = 'active'::text)))) OR (auth.role() = 'service_role'::text)));


--
-- Name: catalog_items catalog_items_service_role; Type: POLICY; Schema: public; Owner: -
--

CREATE POLICY catalog_items_service_role ON public.catalog_items TO service_role USING (true) WITH CHECK (true);


--
-- Name: clients; Type: ROW SECURITY; Schema: public; Owner: -
--

ALTER TABLE public.clients ENABLE ROW LEVEL SECURITY;

--
-- Name: clients clients_org_isolation; Type: POLICY; Schema: public; Owner: -
--

CREATE POLICY clients_org_isolation ON public.clients USING ((organization_id IN ( SELECT memberships.organization_id
   FROM public.memberships
  WHERE (memberships.user_id = auth.uid()))));


--
-- Name: clients clients_service_role; Type: POLICY; Schema: public; Owner: -
--

CREATE POLICY clients_service_role ON public.clients TO service_role USING (true) WITH CHECK (true);


--
-- Name: conversation_flow_states; Type: ROW SECURITY; Schema: public; Owner: -
--

ALTER TABLE public.conversation_flow_states ENABLE ROW LEVEL SECURITY;

--
-- Name: conversation_flows; Type: ROW SECURITY; Schema: public; Owner: -
--

ALTER TABLE public.conversation_flows ENABLE ROW LEVEL SECURITY;

--
-- Name: conversation_flows conversation_flows_global_read; Type: POLICY; Schema: public; Owner: -
--

CREATE POLICY conversation_flows_global_read ON public.conversation_flows FOR SELECT USING ((organization_id IS NULL));


--
-- Name: conversation_flows conversation_flows_service; Type: POLICY; Schema: public; Owner: -
--

CREATE POLICY conversation_flows_service ON public.conversation_flows TO service_role USING (true) WITH CHECK (true);


--
-- Name: conversation_memory; Type: ROW SECURITY; Schema: public; Owner: -
--

ALTER TABLE public.conversation_memory ENABLE ROW LEVEL SECURITY;

--
-- Name: conversation_memory conversation_memory_auth_select; Type: POLICY; Schema: public; Owner: -
--

CREATE POLICY conversation_memory_auth_select ON public.conversation_memory FOR SELECT TO authenticated USING ((organization_id IN ( SELECT organizations.id
   FROM public.organizations
  WHERE (organizations.id = conversation_memory.organization_id))));


--
-- Name: conversation_memory conversation_memory_service_all; Type: POLICY; Schema: public; Owner: -
--

CREATE POLICY conversation_memory_service_all ON public.conversation_memory TO service_role USING (true) WITH CHECK (true);


--
-- Name: conversation_sessions; Type: ROW SECURITY; Schema: public; Owner: -
--

ALTER TABLE public.conversation_sessions ENABLE ROW LEVEL SECURITY;

--
-- Name: conversation_sessions conversation_sessions_auth_select; Type: POLICY; Schema: public; Owner: -
--

CREATE POLICY conversation_sessions_auth_select ON public.conversation_sessions FOR SELECT TO authenticated USING ((organization_id IN ( SELECT organizations.id
   FROM public.organizations
  WHERE (organizations.id = conversation_sessions.organization_id))));


--
-- Name: conversation_sessions conversation_sessions_service_all; Type: POLICY; Schema: public; Owner: -
--

CREATE POLICY conversation_sessions_service_all ON public.conversation_sessions TO service_role USING (true) WITH CHECK (true);


--
-- Name: daily_time_summary; Type: ROW SECURITY; Schema: public; Owner: -
--

ALTER TABLE public.daily_time_summary ENABLE ROW LEVEL SECURITY;

--
-- Name: daily_time_summary daily_time_summary_insert_policy; Type: POLICY; Schema: public; Owner: -
--

CREATE POLICY daily_time_summary_insert_policy ON public.daily_time_summary FOR INSERT WITH CHECK (((organization_id = public.current_org_id()) OR (auth.role() = 'service_role'::text)));


--
-- Name: daily_time_summary daily_time_summary_select_policy; Type: POLICY; Schema: public; Owner: -
--

CREATE POLICY daily_time_summary_select_policy ON public.daily_time_summary FOR SELECT USING (((organization_id = public.current_org_id()) OR (auth.role() = 'service_role'::text)));


--
-- Name: daily_time_summary daily_time_summary_update_policy; Type: POLICY; Schema: public; Owner: -
--

CREATE POLICY daily_time_summary_update_policy ON public.daily_time_summary FOR UPDATE USING (((organization_id = public.current_org_id()) OR (auth.role() = 'service_role'::text))) WITH CHECK (((organization_id = public.current_org_id()) OR (auth.role() = 'service_role'::text)));


--
-- Name: departments; Type: ROW SECURITY; Schema: public; Owner: -
--

ALTER TABLE public.departments ENABLE ROW LEVEL SECURITY;

--
-- Name: departments departments_delete_policy; Type: POLICY; Schema: public; Owner: -
--

CREATE POLICY departments_delete_policy ON public.departments FOR DELETE TO authenticated USING (((organization_id IN ( SELECT m.organization_id
   FROM public.memberships m
  WHERE ((m.user_id = auth.uid()) AND (m.status = 'active'::text)))) OR (auth.role() = 'service_role'::text)));


--
-- Name: departments departments_insert_policy; Type: POLICY; Schema: public; Owner: -
--

CREATE POLICY departments_insert_policy ON public.departments FOR INSERT TO authenticated WITH CHECK (((organization_id IN ( SELECT m.organization_id
   FROM public.memberships m
  WHERE ((m.user_id = auth.uid()) AND (m.status = 'active'::text)))) OR (auth.role() = 'service_role'::text)));


--
-- Name: departments departments_select_policy; Type: POLICY; Schema: public; Owner: -
--

CREATE POLICY departments_select_policy ON public.departments FOR SELECT TO authenticated USING (((organization_id IN ( SELECT m.organization_id
   FROM public.memberships m
  WHERE ((m.user_id = auth.uid()) AND (m.status = 'active'::text)))) OR (auth.role() = 'service_role'::text)));


--
-- Name: departments departments_update_policy; Type: POLICY; Schema: public; Owner: -
--

CREATE POLICY departments_update_policy ON public.departments FOR UPDATE TO authenticated USING (((organization_id IN ( SELECT m.organization_id
   FROM public.memberships m
  WHERE ((m.user_id = auth.uid()) AND (m.status = 'active'::text)))) OR (auth.role() = 'service_role'::text))) WITH CHECK (((organization_id IN ( SELECT m.organization_id
   FROM public.memberships m
  WHERE ((m.user_id = auth.uid()) AND (m.status = 'active'::text)))) OR (auth.role() = 'service_role'::text)));


--
-- Name: entity_identification_documents docs_delete_org; Type: POLICY; Schema: public; Owner: -
--

CREATE POLICY docs_delete_org ON public.entity_identification_documents FOR DELETE USING ((organization_id IN ( SELECT memberships.organization_id
   FROM public.memberships
  WHERE (memberships.user_id = auth.uid()))));


--
-- Name: entity_identification_documents docs_insert_org; Type: POLICY; Schema: public; Owner: -
--

CREATE POLICY docs_insert_org ON public.entity_identification_documents FOR INSERT WITH CHECK ((organization_id IN ( SELECT memberships.organization_id
   FROM public.memberships
  WHERE (memberships.user_id = auth.uid()))));


--
-- Name: entity_identification_documents docs_select_org; Type: POLICY; Schema: public; Owner: -
--

CREATE POLICY docs_select_org ON public.entity_identification_documents FOR SELECT USING ((organization_id IN ( SELECT memberships.organization_id
   FROM public.memberships
  WHERE (memberships.user_id = auth.uid()))));


--
-- Name: entity_identification_documents docs_update_org; Type: POLICY; Schema: public; Owner: -
--

CREATE POLICY docs_update_org ON public.entity_identification_documents FOR UPDATE USING ((organization_id IN ( SELECT memberships.organization_id
   FROM public.memberships
  WHERE (memberships.user_id = auth.uid()))));


--
-- Name: employees; Type: ROW SECURITY; Schema: public; Owner: -
--

ALTER TABLE public.employees ENABLE ROW LEVEL SECURITY;

--
-- Name: employees employees_delete_policy; Type: POLICY; Schema: public; Owner: -
--

CREATE POLICY employees_delete_policy ON public.employees FOR DELETE USING (((organization_id IN ( SELECT memberships.organization_id
   FROM public.memberships
  WHERE ((memberships.user_id = auth.uid()) AND (memberships.status = 'active'::text)))) OR (auth.role() = 'service_role'::text)));


--
-- Name: employees employees_insert_policy; Type: POLICY; Schema: public; Owner: -
--

CREATE POLICY employees_insert_policy ON public.employees FOR INSERT WITH CHECK (((organization_id IN ( SELECT memberships.organization_id
   FROM public.memberships
  WHERE ((memberships.user_id = auth.uid()) AND (memberships.status = 'active'::text)))) OR (auth.role() = 'service_role'::text)));


--
-- Name: employees employees_select_policy; Type: POLICY; Schema: public; Owner: -
--

CREATE POLICY employees_select_policy ON public.employees FOR SELECT USING (((organization_id IN ( SELECT memberships.organization_id
   FROM public.memberships
  WHERE ((memberships.user_id = auth.uid()) AND (memberships.status = 'active'::text)))) OR (auth.role() = 'service_role'::text)));


--
-- Name: employees employees_update_policy; Type: POLICY; Schema: public; Owner: -
--

CREATE POLICY employees_update_policy ON public.employees FOR UPDATE USING (((organization_id IN ( SELECT memberships.organization_id
   FROM public.memberships
  WHERE ((memberships.user_id = auth.uid()) AND (memberships.status = 'active'::text)))) OR (auth.role() = 'service_role'::text))) WITH CHECK (((organization_id IN ( SELECT memberships.organization_id
   FROM public.memberships
  WHERE ((memberships.user_id = auth.uid()) AND (memberships.status = 'active'::text)))) OR (auth.role() = 'service_role'::text)));


--
-- Name: entities; Type: ROW SECURITY; Schema: public; Owner: -
--

ALTER TABLE public.entities ENABLE ROW LEVEL SECURITY;

--
-- Name: entities entities_delete_policy; Type: POLICY; Schema: public; Owner: -
--

CREATE POLICY entities_delete_policy ON public.entities FOR DELETE USING (((organization_id = public.current_org_id()) OR (auth.role() = 'service_role'::text)));


--
-- Name: entities entities_insert_policy; Type: POLICY; Schema: public; Owner: -
--

CREATE POLICY entities_insert_policy ON public.entities FOR INSERT WITH CHECK (((EXISTS ( SELECT 1
   FROM public.memberships
  WHERE ((memberships.user_id = auth.uid()) AND (memberships.status = 'active'::text)))) OR (auth.role() = 'service_role'::text) OR ((public.current_org_id() IS NOT NULL) AND (organization_id = public.current_org_id()))));


--
-- Name: entities entities_select_policy; Type: POLICY; Schema: public; Owner: -
--

CREATE POLICY entities_select_policy ON public.entities FOR SELECT USING (((organization_id IN ( SELECT memberships.organization_id
   FROM public.memberships
  WHERE ((memberships.user_id = auth.uid()) AND (memberships.status = 'active'::text)))) OR (auth.role() = 'service_role'::text)));


--
-- Name: entities entities_update_policy; Type: POLICY; Schema: public; Owner: -
--

CREATE POLICY entities_update_policy ON public.entities FOR UPDATE USING (((organization_id IN ( SELECT memberships.organization_id
   FROM public.memberships
  WHERE ((memberships.user_id = auth.uid()) AND (memberships.status = 'active'::text)))) OR (auth.role() = 'service_role'::text))) WITH CHECK (((organization_id IN ( SELECT memberships.organization_id
   FROM public.memberships
  WHERE ((memberships.user_id = auth.uid()) AND (memberships.status = 'active'::text)))) OR (auth.role() = 'service_role'::text)));


--
-- Name: entity_ai_cold; Type: ROW SECURITY; Schema: public; Owner: -
--

ALTER TABLE public.entity_ai_cold ENABLE ROW LEVEL SECURITY;

--
-- Name: entity_ai_hot; Type: ROW SECURITY; Schema: public; Owner: -
--

ALTER TABLE public.entity_ai_hot ENABLE ROW LEVEL SECURITY;

--
-- Name: entity_ai_hot entity_ai_hot_select_policy; Type: POLICY; Schema: public; Owner: -
--

CREATE POLICY entity_ai_hot_select_policy ON public.entity_ai_hot FOR SELECT USING ((entity_id IN ( SELECT entities.id
   FROM public.entities
  WHERE (entities.organization_id = public.current_org_id()))));


--
-- Name: entity_ai_traits; Type: ROW SECURITY; Schema: public; Owner: -
--

ALTER TABLE public.entity_ai_traits ENABLE ROW LEVEL SECURITY;

--
-- Name: entity_ai_traits entity_ai_traits_select_policy; Type: POLICY; Schema: public; Owner: -
--

CREATE POLICY entity_ai_traits_select_policy ON public.entity_ai_traits FOR SELECT USING ((organization_id = public.current_org_id()));


--
-- Name: entity_identification_documents; Type: ROW SECURITY; Schema: public; Owner: -
--

ALTER TABLE public.entity_identification_documents ENABLE ROW LEVEL SECURITY;

--
-- Name: entity_insurance_policies; Type: ROW SECURITY; Schema: public; Owner: -
--

ALTER TABLE public.entity_insurance_policies ENABLE ROW LEVEL SECURITY;

--
-- Name: entity_metrics_cache; Type: ROW SECURITY; Schema: public; Owner: -
--

ALTER TABLE public.entity_metrics_cache ENABLE ROW LEVEL SECURITY;

--
-- Name: entity_metrics_cache entity_metrics_cache_select_policy; Type: POLICY; Schema: public; Owner: -
--

CREATE POLICY entity_metrics_cache_select_policy ON public.entity_metrics_cache FOR SELECT USING ((organization_id = public.current_org_id()));


--
-- Name: entity_relationships; Type: ROW SECURITY; Schema: public; Owner: -
--

ALTER TABLE public.entity_relationships ENABLE ROW LEVEL SECURITY;

--
-- Name: entity_relationships entity_relationships_delete_policy; Type: POLICY; Schema: public; Owner: -
--

CREATE POLICY entity_relationships_delete_policy ON public.entity_relationships FOR DELETE USING ((organization_id IN ( SELECT memberships.organization_id
   FROM public.memberships
  WHERE ((memberships.user_id = auth.uid()) AND (memberships.status = 'active'::text)))));


--
-- Name: entity_relationships entity_relationships_insert_policy; Type: POLICY; Schema: public; Owner: -
--

CREATE POLICY entity_relationships_insert_policy ON public.entity_relationships FOR INSERT WITH CHECK ((organization_id IN ( SELECT memberships.organization_id
   FROM public.memberships
  WHERE ((memberships.user_id = auth.uid()) AND (memberships.status = 'active'::text)))));


--
-- Name: entity_relationships entity_relationships_select_policy; Type: POLICY; Schema: public; Owner: -
--

CREATE POLICY entity_relationships_select_policy ON public.entity_relationships FOR SELECT USING ((organization_id IN ( SELECT memberships.organization_id
   FROM public.memberships
  WHERE ((memberships.user_id = auth.uid()) AND (memberships.status = 'active'::text)))));


--
-- Name: entity_relationships entity_relationships_update_policy; Type: POLICY; Schema: public; Owner: -
--

CREATE POLICY entity_relationships_update_policy ON public.entity_relationships FOR UPDATE USING ((organization_id IN ( SELECT memberships.organization_id
   FROM public.memberships
  WHERE ((memberships.user_id = auth.uid()) AND (memberships.status = 'active'::text)))));


--
-- Name: entity_synonyms; Type: ROW SECURITY; Schema: public; Owner: -
--

ALTER TABLE public.entity_synonyms ENABLE ROW LEVEL SECURITY;

--
-- Name: entity_synonyms entity_synonyms_global_read; Type: POLICY; Schema: public; Owner: -
--

CREATE POLICY entity_synonyms_global_read ON public.entity_synonyms FOR SELECT USING ((organization_id IS NULL));


--
-- Name: entity_synonyms entity_synonyms_service_full; Type: POLICY; Schema: public; Owner: -
--

CREATE POLICY entity_synonyms_service_full ON public.entity_synonyms TO service_role USING (true) WITH CHECK (true);


--
-- Name: external_calendar_events; Type: ROW SECURITY; Schema: public; Owner: -
--

ALTER TABLE public.external_calendar_events ENABLE ROW LEVEL SECURITY;

--
-- Name: external_calendar_events external_events_policy; Type: POLICY; Schema: public; Owner: -
--

CREATE POLICY external_events_policy ON public.external_calendar_events FOR SELECT USING ((connection_id IN ( SELECT calendar_connections.id
   FROM public.calendar_connections
  WHERE (calendar_connections.user_id = auth.uid()))));


--
-- Name: conversation_flow_states flow_states_service; Type: POLICY; Schema: public; Owner: -
--

CREATE POLICY flow_states_service ON public.conversation_flow_states TO service_role USING (true) WITH CHECK (true);


--
-- Name: entity_insurance_policies insurance_delete_org; Type: POLICY; Schema: public; Owner: -
--

CREATE POLICY insurance_delete_org ON public.entity_insurance_policies FOR DELETE USING ((organization_id IN ( SELECT memberships.organization_id
   FROM public.memberships
  WHERE (memberships.user_id = auth.uid()))));


--
-- Name: entity_insurance_policies insurance_insert_org; Type: POLICY; Schema: public; Owner: -
--

CREATE POLICY insurance_insert_org ON public.entity_insurance_policies FOR INSERT WITH CHECK ((organization_id IN ( SELECT memberships.organization_id
   FROM public.memberships
  WHERE (memberships.user_id = auth.uid()))));


--
-- Name: entity_insurance_policies insurance_select_org; Type: POLICY; Schema: public; Owner: -
--

CREATE POLICY insurance_select_org ON public.entity_insurance_policies FOR SELECT USING ((organization_id IN ( SELECT memberships.organization_id
   FROM public.memberships
  WHERE (memberships.user_id = auth.uid()))));


--
-- Name: entity_insurance_policies insurance_update_org; Type: POLICY; Schema: public; Owner: -
--

CREATE POLICY insurance_update_org ON public.entity_insurance_policies FOR UPDATE USING ((organization_id IN ( SELECT memberships.organization_id
   FROM public.memberships
  WHERE (memberships.user_id = auth.uid()))));


--
-- Name: invites; Type: ROW SECURITY; Schema: public; Owner: -
--

ALTER TABLE public.invites ENABLE ROW LEVEL SECURITY;

--
-- Name: invites invites_create; Type: POLICY; Schema: public; Owner: -
--

CREATE POLICY invites_create ON public.invites FOR INSERT WITH CHECK (((EXISTS ( SELECT 1
   FROM public.memberships m
  WHERE ((m.organization_id = invites.organization_id) AND (m.user_id = auth.uid()) AND (m.role_key = ANY (ARRAY['owner'::text, 'admin'::text]))))) AND (created_by = auth.uid())));


--
-- Name: invites invites_read; Type: POLICY; Schema: public; Owner: -
--

CREATE POLICY invites_read ON public.invites FOR SELECT USING ((EXISTS ( SELECT 1
   FROM public.memberships m
  WHERE ((m.organization_id = invites.organization_id) AND (m.user_id = auth.uid()) AND (m.role_key = ANY (ARRAY['owner'::text, 'admin'::text]))))));


--
-- Name: invites invites_update; Type: POLICY; Schema: public; Owner: -
--

CREATE POLICY invites_update ON public.invites FOR UPDATE USING ((EXISTS ( SELECT 1
   FROM public.memberships m
  WHERE ((m.organization_id = invites.organization_id) AND (m.user_id = auth.uid()) AND (m.role_key = ANY (ARRAY['owner'::text, 'admin'::text]))))));


--
-- Name: item_attributes; Type: ROW SECURITY; Schema: public; Owner: -
--

ALTER TABLE public.item_attributes ENABLE ROW LEVEL SECURITY;

--
-- Name: item_attributes item_attributes_access; Type: POLICY; Schema: public; Owner: -
--

CREATE POLICY item_attributes_access ON public.item_attributes USING ((EXISTS ( SELECT 1
   FROM public.catalog_items ci
  WHERE ((ci.id = item_attributes.item_id) AND (ci.organization_id = COALESCE((current_setting('app.current_organization_id'::text, true))::uuid, ci.organization_id))))));


--
-- Name: item_attributes item_attributes_service_role; Type: POLICY; Schema: public; Owner: -
--

CREATE POLICY item_attributes_service_role ON public.item_attributes TO service_role USING (true) WITH CHECK (true);


--
-- Name: item_providers; Type: ROW SECURITY; Schema: public; Owner: -
--

ALTER TABLE public.item_providers ENABLE ROW LEVEL SECURITY;

--
-- Name: item_providers item_providers_org_isolation; Type: POLICY; Schema: public; Owner: -
--

CREATE POLICY item_providers_org_isolation ON public.item_providers USING (((organization_id IN ( SELECT m.organization_id
   FROM public.memberships m
  WHERE ((m.user_id = auth.uid()) AND (m.status = 'active'::text)))) OR (auth.role() = 'service_role'::text))) WITH CHECK (((organization_id IN ( SELECT m.organization_id
   FROM public.memberships m
  WHERE ((m.user_id = auth.uid()) AND (m.status = 'active'::text)))) OR (auth.role() = 'service_role'::text)));


--
-- Name: item_providers item_providers_service_role; Type: POLICY; Schema: public; Owner: -
--

CREATE POLICY item_providers_service_role ON public.item_providers TO service_role USING (true) WITH CHECK (true);


--
-- Name: item_skill_requirements; Type: ROW SECURITY; Schema: public; Owner: -
--

ALTER TABLE public.item_skill_requirements ENABLE ROW LEVEL SECURITY;

--
-- Name: item_skill_requirements item_skill_requirements_access; Type: POLICY; Schema: public; Owner: -
--

CREATE POLICY item_skill_requirements_access ON public.item_skill_requirements USING ((EXISTS ( SELECT 1
   FROM public.catalog_items ci
  WHERE ((ci.id = item_skill_requirements.item_id) AND (ci.organization_id = COALESCE((current_setting('app.current_organization_id'::text, true))::uuid, ci.organization_id))))));


--
-- Name: item_skill_requirements item_skill_requirements_service_role; Type: POLICY; Schema: public; Owner: -
--

CREATE POLICY item_skill_requirements_service_role ON public.item_skill_requirements TO service_role USING (true) WITH CHECK (true);


--
-- Name: jobs; Type: ROW SECURITY; Schema: public; Owner: -
--

ALTER TABLE public.jobs ENABLE ROW LEVEL SECURITY;

--
-- Name: jobs jobs_delete_policy; Type: POLICY; Schema: public; Owner: -
--

CREATE POLICY jobs_delete_policy ON public.jobs FOR DELETE TO authenticated USING (((organization_id IN ( SELECT m.organization_id
   FROM public.memberships m
  WHERE ((m.user_id = auth.uid()) AND (m.status = 'active'::text)))) OR (auth.role() = 'service_role'::text)));


--
-- Name: jobs jobs_insert_policy; Type: POLICY; Schema: public; Owner: -
--

CREATE POLICY jobs_insert_policy ON public.jobs FOR INSERT TO authenticated WITH CHECK (((organization_id IN ( SELECT m.organization_id
   FROM public.memberships m
  WHERE ((m.user_id = auth.uid()) AND (m.status = 'active'::text)))) OR (auth.role() = 'service_role'::text)));


--
-- Name: jobs jobs_select_policy; Type: POLICY; Schema: public; Owner: -
--

CREATE POLICY jobs_select_policy ON public.jobs FOR SELECT TO authenticated USING (((organization_id IN ( SELECT m.organization_id
   FROM public.memberships m
  WHERE ((m.user_id = auth.uid()) AND (m.status = 'active'::text)))) OR (auth.role() = 'service_role'::text)));


--
-- Name: jobs jobs_update_policy; Type: POLICY; Schema: public; Owner: -
--

CREATE POLICY jobs_update_policy ON public.jobs FOR UPDATE TO authenticated USING (((organization_id IN ( SELECT m.organization_id
   FROM public.memberships m
  WHERE ((m.user_id = auth.uid()) AND (m.status = 'active'::text)))) OR (auth.role() = 'service_role'::text))) WITH CHECK (((organization_id IN ( SELECT m.organization_id
   FROM public.memberships m
  WHERE ((m.user_id = auth.uid()) AND (m.status = 'active'::text)))) OR (auth.role() = 'service_role'::text)));


--
-- Name: leave_balances; Type: ROW SECURITY; Schema: public; Owner: -
--

ALTER TABLE public.leave_balances ENABLE ROW LEVEL SECURITY;

--
-- Name: leave_balances leave_balances_insert_policy; Type: POLICY; Schema: public; Owner: -
--

CREATE POLICY leave_balances_insert_policy ON public.leave_balances FOR INSERT WITH CHECK (((organization_id = public.current_org_id()) OR (auth.role() = 'service_role'::text)));


--
-- Name: leave_balances leave_balances_select_policy; Type: POLICY; Schema: public; Owner: -
--

CREATE POLICY leave_balances_select_policy ON public.leave_balances FOR SELECT USING (((organization_id = public.current_org_id()) OR (auth.role() = 'service_role'::text)));


--
-- Name: leave_balances leave_balances_update_policy; Type: POLICY; Schema: public; Owner: -
--

CREATE POLICY leave_balances_update_policy ON public.leave_balances FOR UPDATE USING (((organization_id = public.current_org_id()) OR (auth.role() = 'service_role'::text)));


--
-- Name: leave_requests; Type: ROW SECURITY; Schema: public; Owner: -
--

ALTER TABLE public.leave_requests ENABLE ROW LEVEL SECURITY;

--
-- Name: leave_requests leave_requests_insert_policy; Type: POLICY; Schema: public; Owner: -
--

CREATE POLICY leave_requests_insert_policy ON public.leave_requests FOR INSERT WITH CHECK (((organization_id = public.current_org_id()) OR (auth.role() = 'service_role'::text)));


--
-- Name: leave_requests leave_requests_select_policy; Type: POLICY; Schema: public; Owner: -
--

CREATE POLICY leave_requests_select_policy ON public.leave_requests FOR SELECT USING (((organization_id = public.current_org_id()) OR (auth.role() = 'service_role'::text)));


--
-- Name: leave_requests leave_requests_update_policy; Type: POLICY; Schema: public; Owner: -
--

CREATE POLICY leave_requests_update_policy ON public.leave_requests FOR UPDATE USING (((organization_id = public.current_org_id()) OR (auth.role() = 'service_role'::text)));


--
-- Name: leave_types; Type: ROW SECURITY; Schema: public; Owner: -
--

ALTER TABLE public.leave_types ENABLE ROW LEVEL SECURITY;

--
-- Name: leave_types leave_types_delete_policy; Type: POLICY; Schema: public; Owner: -
--

CREATE POLICY leave_types_delete_policy ON public.leave_types FOR DELETE USING (((organization_id = public.current_org_id()) OR (auth.role() = 'service_role'::text)));


--
-- Name: leave_types leave_types_insert_policy; Type: POLICY; Schema: public; Owner: -
--

CREATE POLICY leave_types_insert_policy ON public.leave_types FOR INSERT WITH CHECK (((organization_id = public.current_org_id()) OR (auth.role() = 'service_role'::text)));


--
-- Name: leave_types leave_types_select_policy; Type: POLICY; Schema: public; Owner: -
--

CREATE POLICY leave_types_select_policy ON public.leave_types FOR SELECT USING (((organization_id = public.current_org_id()) OR (auth.role() = 'service_role'::text)));


--
-- Name: leave_types leave_types_update_policy; Type: POLICY; Schema: public; Owner: -
--

CREATE POLICY leave_types_update_policy ON public.leave_types FOR UPDATE USING (((organization_id = public.current_org_id()) OR (auth.role() = 'service_role'::text)));


--
-- Name: llm_prompts; Type: ROW SECURITY; Schema: public; Owner: -
--

ALTER TABLE public.llm_prompts ENABLE ROW LEVEL SECURITY;

--
-- Name: llm_prompts llm_prompts_global_read; Type: POLICY; Schema: public; Owner: -
--

CREATE POLICY llm_prompts_global_read ON public.llm_prompts FOR SELECT USING ((organization_id IS NULL));


--
-- Name: llm_prompts llm_prompts_service_full; Type: POLICY; Schema: public; Owner: -
--

CREATE POLICY llm_prompts_service_full ON public.llm_prompts TO service_role USING (true) WITH CHECK (true);


--
-- Name: memberships; Type: ROW SECURITY; Schema: public; Owner: -
--

ALTER TABLE public.memberships ENABLE ROW LEVEL SECURITY;

--
-- Name: nlu_intent_examples; Type: ROW SECURITY; Schema: public; Owner: -
--

ALTER TABLE public.nlu_intent_examples ENABLE ROW LEVEL SECURITY;

--
-- Name: nlu_intent_signals; Type: ROW SECURITY; Schema: public; Owner: -
--

ALTER TABLE public.nlu_intent_signals ENABLE ROW LEVEL SECURITY;

--
-- Name: nlu_keywords; Type: ROW SECURITY; Schema: public; Owner: -
--

ALTER TABLE public.nlu_keywords ENABLE ROW LEVEL SECURITY;

--
-- Name: nlu_typo_corrections; Type: ROW SECURITY; Schema: public; Owner: -
--

ALTER TABLE public.nlu_typo_corrections ENABLE ROW LEVEL SECURITY;

--
-- Name: org_knowledge_base; Type: ROW SECURITY; Schema: public; Owner: -
--

ALTER TABLE public.org_knowledge_base ENABLE ROW LEVEL SECURITY;

--
-- Name: organization_policies; Type: ROW SECURITY; Schema: public; Owner: -
--

ALTER TABLE public.organization_policies ENABLE ROW LEVEL SECURITY;

--
-- Name: organization_verticals; Type: ROW SECURITY; Schema: public; Owner: -
--

ALTER TABLE public.organization_verticals ENABLE ROW LEVEL SECURITY;

--
-- Name: organization_verticals organization_verticals_delete_policy; Type: POLICY; Schema: public; Owner: -
--

CREATE POLICY organization_verticals_delete_policy ON public.organization_verticals FOR DELETE USING (((auth.role() = 'service_role'::text) AND (is_system = false)));


--
-- Name: organization_verticals organization_verticals_insert_policy; Type: POLICY; Schema: public; Owner: -
--

CREATE POLICY organization_verticals_insert_policy ON public.organization_verticals FOR INSERT WITH CHECK ((auth.role() = 'service_role'::text));


--
-- Name: organization_verticals organization_verticals_select_policy; Type: POLICY; Schema: public; Owner: -
--

CREATE POLICY organization_verticals_select_policy ON public.organization_verticals FOR SELECT USING ((is_active = true));


--
-- Name: organization_verticals organization_verticals_update_policy; Type: POLICY; Schema: public; Owner: -
--

CREATE POLICY organization_verticals_update_policy ON public.organization_verticals FOR UPDATE USING ((auth.role() = 'service_role'::text));


--
-- Name: organizations; Type: ROW SECURITY; Schema: public; Owner: -
--

ALTER TABLE public.organizations ENABLE ROW LEVEL SECURITY;

--
-- Name: organizations organizations_delete_policy; Type: POLICY; Schema: public; Owner: -
--

CREATE POLICY organizations_delete_policy ON public.organizations FOR DELETE USING ((auth.role() = 'service_role'::text));


--
-- Name: organizations organizations_insert_policy; Type: POLICY; Schema: public; Owner: -
--

CREATE POLICY organizations_insert_policy ON public.organizations FOR INSERT WITH CHECK ((auth.role() = 'service_role'::text));


--
-- Name: organizations organizations_select_policy; Type: POLICY; Schema: public; Owner: -
--

CREATE POLICY organizations_select_policy ON public.organizations FOR SELECT USING (((id IN ( SELECT memberships.organization_id
   FROM public.memberships
  WHERE ((memberships.user_id = auth.uid()) AND (memberships.status = 'active'::text)))) OR (auth.role() = 'service_role'::text)));


--
-- Name: organizations organizations_update_policy; Type: POLICY; Schema: public; Owner: -
--

CREATE POLICY organizations_update_policy ON public.organizations FOR UPDATE USING (((id = public.current_org_id()) OR (auth.role() = 'service_role'::text)));


--
-- Name: patient_code_sequences; Type: ROW SECURITY; Schema: public; Owner: -
--

ALTER TABLE public.patient_code_sequences ENABLE ROW LEVEL SECURITY;

--
-- Name: patient_notes; Type: ROW SECURITY; Schema: public; Owner: -
--

ALTER TABLE public.patient_notes ENABLE ROW LEVEL SECURITY;

--
-- Name: patient_notes patient_notes_delete_policy; Type: POLICY; Schema: public; Owner: -
--

CREATE POLICY patient_notes_delete_policy ON public.patient_notes FOR DELETE USING (((organization_id IN ( SELECT patient_notes.organization_id
   FROM public.profiles
  WHERE (profiles.user_id = auth.uid()))) AND (created_by = auth.uid())));


--
-- Name: patient_notes patient_notes_insert_policy; Type: POLICY; Schema: public; Owner: -
--

CREATE POLICY patient_notes_insert_policy ON public.patient_notes FOR INSERT WITH CHECK ((organization_id IN ( SELECT patient_notes.organization_id
   FROM public.profiles
  WHERE (profiles.user_id = auth.uid()))));


--
-- Name: patient_notes patient_notes_select_policy; Type: POLICY; Schema: public; Owner: -
--

CREATE POLICY patient_notes_select_policy ON public.patient_notes FOR SELECT USING (((organization_id IN ( SELECT patient_notes.organization_id
   FROM public.profiles
  WHERE (profiles.user_id = auth.uid()))) AND (deleted_at IS NULL) AND ((NOT is_private) OR (created_by = auth.uid()))));


--
-- Name: patient_notes patient_notes_update_policy; Type: POLICY; Schema: public; Owner: -
--

CREATE POLICY patient_notes_update_policy ON public.patient_notes FOR UPDATE USING (((organization_id IN ( SELECT patient_notes.organization_id
   FROM public.profiles
  WHERE (profiles.user_id = auth.uid()))) AND ((created_by = auth.uid()) OR (NOT is_private))));


--
-- Name: patients; Type: ROW SECURITY; Schema: public; Owner: -
--

ALTER TABLE public.patients ENABLE ROW LEVEL SECURITY;

--
-- Name: patients patients_delete_policy; Type: POLICY; Schema: public; Owner: -
--

CREATE POLICY patients_delete_policy ON public.patients FOR DELETE TO authenticated USING (false);


--
-- Name: POLICY patients_delete_policy ON patients; Type: COMMENT; Schema: public; Owner: -
--

COMMENT ON POLICY patients_delete_policy ON public.patients IS 'Hard deletes are disabled. Use soft delete via deleted_at column.';


--
-- Name: patients patients_insert_policy; Type: POLICY; Schema: public; Owner: -
--

CREATE POLICY patients_insert_policy ON public.patients FOR INSERT WITH CHECK (((organization_id IN ( SELECT memberships.organization_id
   FROM public.memberships
  WHERE ((memberships.user_id = auth.uid()) AND (memberships.status = 'active'::text)))) OR (auth.role() = 'service_role'::text)));


--
-- Name: patients patients_select_policy; Type: POLICY; Schema: public; Owner: -
--

CREATE POLICY patients_select_policy ON public.patients FOR SELECT USING (((organization_id IN ( SELECT memberships.organization_id
   FROM public.memberships
  WHERE ((memberships.user_id = auth.uid()) AND (memberships.status = 'active'::text)))) OR (auth.role() = 'service_role'::text)));


--
-- Name: patients patients_update_policy; Type: POLICY; Schema: public; Owner: -
--

CREATE POLICY patients_update_policy ON public.patients FOR UPDATE USING (((organization_id IN ( SELECT memberships.organization_id
   FROM public.memberships
  WHERE ((memberships.user_id = auth.uid()) AND (memberships.status = 'active'::text)))) OR (auth.role() = 'service_role'::text))) WITH CHECK (((organization_id IN ( SELECT memberships.organization_id
   FROM public.memberships
  WHERE ((memberships.user_id = auth.uid()) AND (memberships.status = 'active'::text)))) OR (auth.role() = 'service_role'::text)));


--
-- Name: positions; Type: ROW SECURITY; Schema: public; Owner: -
--

ALTER TABLE public.positions ENABLE ROW LEVEL SECURITY;

--
-- Name: positions positions_delete_policy; Type: POLICY; Schema: public; Owner: -
--

CREATE POLICY positions_delete_policy ON public.positions FOR DELETE USING (((organization_id = public.current_org_id()) OR (auth.role() = 'service_role'::text)));


--
-- Name: positions positions_insert_policy; Type: POLICY; Schema: public; Owner: -
--

CREATE POLICY positions_insert_policy ON public.positions FOR INSERT WITH CHECK (((organization_id = public.current_org_id()) OR (auth.role() = 'service_role'::text)));


--
-- Name: positions positions_select_policy; Type: POLICY; Schema: public; Owner: -
--

CREATE POLICY positions_select_policy ON public.positions FOR SELECT USING (((organization_id = public.current_org_id()) OR (auth.role() = 'service_role'::text)));


--
-- Name: positions positions_update_policy; Type: POLICY; Schema: public; Owner: -
--

CREATE POLICY positions_update_policy ON public.positions FOR UPDATE USING (((organization_id = public.current_org_id()) OR (auth.role() = 'service_role'::text))) WITH CHECK (((organization_id = public.current_org_id()) OR (auth.role() = 'service_role'::text)));


--
-- Name: profiles; Type: ROW SECURITY; Schema: public; Owner: -
--

ALTER TABLE public.profiles ENABLE ROW LEVEL SECURITY;

--
-- Name: profiles profiles_delete_policy; Type: POLICY; Schema: public; Owner: -
--

CREATE POLICY profiles_delete_policy ON public.profiles FOR DELETE USING ((auth.role() = 'service_role'::text));


--
-- Name: profiles profiles_insert_policy; Type: POLICY; Schema: public; Owner: -
--

CREATE POLICY profiles_insert_policy ON public.profiles FOR INSERT WITH CHECK (((user_id = auth.uid()) OR (auth.role() = 'service_role'::text)));


--
-- Name: profiles profiles_select_policy; Type: POLICY; Schema: public; Owner: -
--

CREATE POLICY profiles_select_policy ON public.profiles FOR SELECT TO authenticated USING (((user_id = auth.uid()) OR (user_id IN ( SELECT auth.users_in_my_organizations() AS users_in_my_organizations)) OR (auth.role() = 'service_role'::text)));


--
-- Name: profiles profiles_update_policy; Type: POLICY; Schema: public; Owner: -
--

CREATE POLICY profiles_update_policy ON public.profiles FOR UPDATE USING (((user_id = auth.uid()) OR (auth.role() = 'service_role'::text)));


--
-- Name: promotions; Type: ROW SECURITY; Schema: public; Owner: -
--

ALTER TABLE public.promotions ENABLE ROW LEVEL SECURITY;

--
-- Name: promotions promotions_org_isolation; Type: POLICY; Schema: public; Owner: -
--

CREATE POLICY promotions_org_isolation ON public.promotions USING ((organization_id = COALESCE((current_setting('app.current_organization_id'::text, true))::uuid, organization_id)));


--
-- Name: promotions promotions_service_full; Type: POLICY; Schema: public; Owner: -
--

CREATE POLICY promotions_service_full ON public.promotions TO service_role USING (true) WITH CHECK (true);


--
-- Name: provider_schedule_exceptions; Type: ROW SECURITY; Schema: public; Owner: -
--

ALTER TABLE public.provider_schedule_exceptions ENABLE ROW LEVEL SECURITY;

--
-- Name: provider_schedule_exceptions provider_schedule_exceptions_delete_policy; Type: POLICY; Schema: public; Owner: -
--

CREATE POLICY provider_schedule_exceptions_delete_policy ON public.provider_schedule_exceptions FOR DELETE USING (((organization_id = public.current_org_id()) OR (auth.role() = 'service_role'::text)));


--
-- Name: provider_schedule_exceptions provider_schedule_exceptions_insert_policy; Type: POLICY; Schema: public; Owner: -
--

CREATE POLICY provider_schedule_exceptions_insert_policy ON public.provider_schedule_exceptions FOR INSERT WITH CHECK (((organization_id = public.current_org_id()) OR (auth.role() = 'service_role'::text)));


--
-- Name: provider_schedule_exceptions provider_schedule_exceptions_select_policy; Type: POLICY; Schema: public; Owner: -
--

CREATE POLICY provider_schedule_exceptions_select_policy ON public.provider_schedule_exceptions FOR SELECT USING (((organization_id = public.current_org_id()) OR (auth.role() = 'service_role'::text)));


--
-- Name: provider_schedule_exceptions provider_schedule_exceptions_update_policy; Type: POLICY; Schema: public; Owner: -
--

CREATE POLICY provider_schedule_exceptions_update_policy ON public.provider_schedule_exceptions FOR UPDATE USING (((organization_id = public.current_org_id()) OR (auth.role() = 'service_role'::text)));


--
-- Name: provider_schedules; Type: ROW SECURITY; Schema: public; Owner: -
--

ALTER TABLE public.provider_schedules ENABLE ROW LEVEL SECURITY;

--
-- Name: provider_schedules provider_schedules_delete_policy; Type: POLICY; Schema: public; Owner: -
--

CREATE POLICY provider_schedules_delete_policy ON public.provider_schedules FOR DELETE USING (((organization_id = public.current_org_id()) OR (auth.role() = 'service_role'::text)));


--
-- Name: provider_schedules provider_schedules_insert_policy; Type: POLICY; Schema: public; Owner: -
--

CREATE POLICY provider_schedules_insert_policy ON public.provider_schedules FOR INSERT WITH CHECK (((organization_id = public.current_org_id()) OR (auth.role() = 'service_role'::text)));


--
-- Name: provider_schedules provider_schedules_select_policy; Type: POLICY; Schema: public; Owner: -
--

CREATE POLICY provider_schedules_select_policy ON public.provider_schedules FOR SELECT USING (((organization_id = public.current_org_id()) OR (auth.role() = 'service_role'::text)));


--
-- Name: provider_schedules provider_schedules_update_policy; Type: POLICY; Schema: public; Owner: -
--

CREATE POLICY provider_schedules_update_policy ON public.provider_schedules FOR UPDATE USING (((organization_id = public.current_org_id()) OR (auth.role() = 'service_role'::text)));


--
-- Name: provider_skills; Type: ROW SECURITY; Schema: public; Owner: -
--

ALTER TABLE public.provider_skills ENABLE ROW LEVEL SECURITY;

--
-- Name: provider_skills provider_skills_access; Type: POLICY; Schema: public; Owner: -
--

CREATE POLICY provider_skills_access ON public.provider_skills USING (((EXISTS ( SELECT 1
   FROM (public.entities e
     JOIN public.memberships m ON ((m.organization_id = e.organization_id)))
  WHERE ((e.id = provider_skills.provider_entity_id) AND (m.user_id = auth.uid()) AND (m.status = 'active'::text)))) OR (auth.role() = 'service_role'::text))) WITH CHECK (((EXISTS ( SELECT 1
   FROM (public.entities e
     JOIN public.memberships m ON ((m.organization_id = e.organization_id)))
  WHERE ((e.id = provider_skills.provider_entity_id) AND (m.user_id = auth.uid()) AND (m.status = 'active'::text)))) OR (auth.role() = 'service_role'::text)));


--
-- Name: provider_skills provider_skills_service_role; Type: POLICY; Schema: public; Owner: -
--

CREATE POLICY provider_skills_service_role ON public.provider_skills TO service_role USING (true) WITH CHECK (true);


--
-- Name: resource_availability; Type: ROW SECURITY; Schema: public; Owner: -
--

ALTER TABLE public.resource_availability ENABLE ROW LEVEL SECURITY;

--
-- Name: resource_availability resource_availability_insert_policy; Type: POLICY; Schema: public; Owner: -
--

CREATE POLICY resource_availability_insert_policy ON public.resource_availability FOR INSERT WITH CHECK ((organization_id = public.current_org_id()));


--
-- Name: resource_availability resource_availability_select_policy; Type: POLICY; Schema: public; Owner: -
--

CREATE POLICY resource_availability_select_policy ON public.resource_availability FOR SELECT USING ((organization_id = public.current_org_id()));


--
-- Name: resource_capabilities; Type: ROW SECURITY; Schema: public; Owner: -
--

ALTER TABLE public.resource_capabilities ENABLE ROW LEVEL SECURITY;

--
-- Name: resource_capability_availability; Type: ROW SECURITY; Schema: public; Owner: -
--

ALTER TABLE public.resource_capability_availability ENABLE ROW LEVEL SECURITY;

--
-- Name: resource_unavailability; Type: ROW SECURITY; Schema: public; Owner: -
--

ALTER TABLE public.resource_unavailability ENABLE ROW LEVEL SECURITY;

--
-- Name: resource_unavailability resource_unavailability_insert_policy; Type: POLICY; Schema: public; Owner: -
--

CREATE POLICY resource_unavailability_insert_policy ON public.resource_unavailability FOR INSERT WITH CHECK ((organization_id = public.current_org_id()));


--
-- Name: resource_unavailability resource_unavailability_select_policy; Type: POLICY; Schema: public; Owner: -
--

CREATE POLICY resource_unavailability_select_policy ON public.resource_unavailability FOR SELECT USING ((organization_id = public.current_org_id()));


--
-- Name: roles; Type: ROW SECURITY; Schema: public; Owner: -
--

ALTER TABLE public.roles ENABLE ROW LEVEL SECURITY;

--
-- Name: scheduled_shifts; Type: ROW SECURITY; Schema: public; Owner: -
--

ALTER TABLE public.scheduled_shifts ENABLE ROW LEVEL SECURITY;

--
-- Name: scheduled_shifts scheduled_shifts_delete_policy; Type: POLICY; Schema: public; Owner: -
--

CREATE POLICY scheduled_shifts_delete_policy ON public.scheduled_shifts FOR DELETE USING (((organization_id = public.current_org_id()) OR (auth.role() = 'service_role'::text)));


--
-- Name: scheduled_shifts scheduled_shifts_insert_policy; Type: POLICY; Schema: public; Owner: -
--

CREATE POLICY scheduled_shifts_insert_policy ON public.scheduled_shifts FOR INSERT WITH CHECK (((organization_id = public.current_org_id()) OR (auth.role() = 'service_role'::text)));


--
-- Name: scheduled_shifts scheduled_shifts_select_policy; Type: POLICY; Schema: public; Owner: -
--

CREATE POLICY scheduled_shifts_select_policy ON public.scheduled_shifts FOR SELECT USING (((organization_id = public.current_org_id()) OR (auth.role() = 'service_role'::text)));


--
-- Name: scheduled_shifts scheduled_shifts_update_policy; Type: POLICY; Schema: public; Owner: -
--

CREATE POLICY scheduled_shifts_update_policy ON public.scheduled_shifts FOR UPDATE USING (((organization_id = public.current_org_id()) OR (auth.role() = 'service_role'::text)));


--
-- Name: service_providers; Type: ROW SECURITY; Schema: public; Owner: -
--

ALTER TABLE public.service_providers ENABLE ROW LEVEL SECURITY;

--
-- Name: service_providers service_providers_delete_policy; Type: POLICY; Schema: public; Owner: -
--

CREATE POLICY service_providers_delete_policy ON public.service_providers FOR DELETE USING (((organization_id = public.current_org_id()) OR (auth.role() = 'service_role'::text)));


--
-- Name: service_providers service_providers_insert_policy; Type: POLICY; Schema: public; Owner: -
--

CREATE POLICY service_providers_insert_policy ON public.service_providers FOR INSERT WITH CHECK (((organization_id = public.current_org_id()) OR (auth.role() = 'service_role'::text)));


--
-- Name: service_providers service_providers_select_policy; Type: POLICY; Schema: public; Owner: -
--

CREATE POLICY service_providers_select_policy ON public.service_providers FOR SELECT USING (((organization_id = public.current_org_id()) OR (auth.role() = 'service_role'::text)));


--
-- Name: service_providers service_providers_update_policy; Type: POLICY; Schema: public; Owner: -
--

CREATE POLICY service_providers_update_policy ON public.service_providers FOR UPDATE USING (((organization_id = public.current_org_id()) OR (auth.role() = 'service_role'::text)));


--
-- Name: appointments service_role_delete_all; Type: POLICY; Schema: public; Owner: -
--

CREATE POLICY service_role_delete_all ON public.appointments FOR DELETE TO service_role USING (true);


--
-- Name: appointments service_role_insert_all; Type: POLICY; Schema: public; Owner: -
--

CREATE POLICY service_role_insert_all ON public.appointments FOR INSERT TO service_role WITH CHECK (true);


--
-- Name: invites service_role_invites; Type: POLICY; Schema: public; Owner: -
--

CREATE POLICY service_role_invites ON public.invites TO service_role USING (true) WITH CHECK (true);


--
-- Name: appointments service_role_select_all; Type: POLICY; Schema: public; Owner: -
--

CREATE POLICY service_role_select_all ON public.appointments FOR SELECT TO service_role USING (true);


--
-- Name: appointments service_role_update_all; Type: POLICY; Schema: public; Owner: -
--

CREATE POLICY service_role_update_all ON public.appointments FOR UPDATE TO service_role USING (true);


--
-- Name: services; Type: ROW SECURITY; Schema: public; Owner: -
--

ALTER TABLE public.services ENABLE ROW LEVEL SECURITY;

--
-- Name: services services_delete_policy; Type: POLICY; Schema: public; Owner: -
--

CREATE POLICY services_delete_policy ON public.services FOR DELETE USING (((organization_id = public.current_org_id()) OR (auth.role() = 'service_role'::text)));


--
-- Name: services services_insert_policy; Type: POLICY; Schema: public; Owner: -
--

CREATE POLICY services_insert_policy ON public.services FOR INSERT WITH CHECK (((organization_id = public.current_org_id()) OR (auth.role() = 'service_role'::text)));


--
-- Name: services services_select_policy; Type: POLICY; Schema: public; Owner: -
--

CREATE POLICY services_select_policy ON public.services FOR SELECT USING (((organization_id = public.current_org_id()) OR (auth.role() = 'service_role'::text)));


--
-- Name: services services_update_policy; Type: POLICY; Schema: public; Owner: -
--

CREATE POLICY services_update_policy ON public.services FOR UPDATE USING (((organization_id = public.current_org_id()) OR (auth.role() = 'service_role'::text)));


--
-- Name: shift_templates; Type: ROW SECURITY; Schema: public; Owner: -
--

ALTER TABLE public.shift_templates ENABLE ROW LEVEL SECURITY;

--
-- Name: shift_templates shift_templates_delete_policy; Type: POLICY; Schema: public; Owner: -
--

CREATE POLICY shift_templates_delete_policy ON public.shift_templates FOR DELETE USING (((organization_id = public.current_org_id()) OR (auth.role() = 'service_role'::text)));


--
-- Name: shift_templates shift_templates_insert_policy; Type: POLICY; Schema: public; Owner: -
--

CREATE POLICY shift_templates_insert_policy ON public.shift_templates FOR INSERT WITH CHECK (((organization_id = public.current_org_id()) OR (auth.role() = 'service_role'::text)));


--
-- Name: shift_templates shift_templates_select_policy; Type: POLICY; Schema: public; Owner: -
--

CREATE POLICY shift_templates_select_policy ON public.shift_templates FOR SELECT USING (((organization_id = public.current_org_id()) OR (auth.role() = 'service_role'::text)));


--
-- Name: shift_templates shift_templates_update_policy; Type: POLICY; Schema: public; Owner: -
--

CREATE POLICY shift_templates_update_policy ON public.shift_templates FOR UPDATE USING (((organization_id = public.current_org_id()) OR (auth.role() = 'service_role'::text)));


--
-- Name: skill_access; Type: ROW SECURITY; Schema: public; Owner: -
--

ALTER TABLE public.skill_access ENABLE ROW LEVEL SECURITY;

--
-- Name: skill_definitions; Type: ROW SECURITY; Schema: public; Owner: -
--

ALTER TABLE public.skill_definitions ENABLE ROW LEVEL SECURITY;

--
-- Name: skill_definitions skill_definitions_access; Type: POLICY; Schema: public; Owner: -
--

CREATE POLICY skill_definitions_access ON public.skill_definitions FOR SELECT USING (((organization_id IS NULL) OR (organization_id IN ( SELECT memberships.organization_id
   FROM public.memberships
  WHERE ((memberships.user_id = auth.uid()) AND (memberships.status = 'active'::text)))) OR (auth.role() = 'service_role'::text)));


--
-- Name: skill_definitions skill_definitions_service_role; Type: POLICY; Schema: public; Owner: -
--

CREATE POLICY skill_definitions_service_role ON public.skill_definitions TO service_role USING (true) WITH CHECK (true);


--
-- Name: subscription_plans; Type: ROW SECURITY; Schema: public; Owner: -
--

ALTER TABLE public.subscription_plans ENABLE ROW LEVEL SECURITY;

--
-- Name: subscriptions; Type: ROW SECURITY; Schema: public; Owner: -
--

ALTER TABLE public.subscriptions ENABLE ROW LEVEL SECURITY;

--
-- Name: time_entries; Type: ROW SECURITY; Schema: public; Owner: -
--

ALTER TABLE public.time_entries ENABLE ROW LEVEL SECURITY;

--
-- Name: time_entries time_entries_insert_policy; Type: POLICY; Schema: public; Owner: -
--

CREATE POLICY time_entries_insert_policy ON public.time_entries FOR INSERT WITH CHECK (((organization_id = public.current_org_id()) OR (auth.role() = 'service_role'::text)));


--
-- Name: time_entries time_entries_select_policy; Type: POLICY; Schema: public; Owner: -
--

CREATE POLICY time_entries_select_policy ON public.time_entries FOR SELECT USING (((organization_id = public.current_org_id()) OR (auth.role() = 'service_role'::text)));


--
-- Name: time_entries time_entries_update_policy; Type: POLICY; Schema: public; Owner: -
--

CREATE POLICY time_entries_update_policy ON public.time_entries FOR UPDATE USING (((organization_id = public.current_org_id()) OR (auth.role() = 'service_role'::text))) WITH CHECK (((organization_id = public.current_org_id()) OR (auth.role() = 'service_role'::text)));


--
-- Name: time_entry_modifications; Type: ROW SECURITY; Schema: public; Owner: -
--

ALTER TABLE public.time_entry_modifications ENABLE ROW LEVEL SECURITY;

--
-- Name: time_entry_modifications time_entry_mods_insert_policy; Type: POLICY; Schema: public; Owner: -
--

CREATE POLICY time_entry_mods_insert_policy ON public.time_entry_modifications FOR INSERT WITH CHECK ((EXISTS ( SELECT 1
   FROM public.time_entries te
  WHERE ((te.id = time_entry_modifications.time_entry_id) AND ((te.organization_id = public.current_org_id()) OR (auth.role() = 'service_role'::text))))));


--
-- Name: time_entry_modifications time_entry_mods_select_policy; Type: POLICY; Schema: public; Owner: -
--

CREATE POLICY time_entry_mods_select_policy ON public.time_entry_modifications FOR SELECT USING ((EXISTS ( SELECT 1
   FROM public.time_entries te
  WHERE ((te.id = time_entry_modifications.time_entry_id) AND ((te.organization_id = public.current_org_id()) OR (auth.role() = 'service_role'::text))))));


--
-- Name: user_roles; Type: ROW SECURITY; Schema: public; Owner: -
--

ALTER TABLE public.user_roles ENABLE ROW LEVEL SECURITY;

--
-- Name: user_sessions; Type: ROW SECURITY; Schema: public; Owner: -
--

ALTER TABLE public.user_sessions ENABLE ROW LEVEL SECURITY;

--
-- Name: ai_interactions users_insert_own_org_interactions; Type: POLICY; Schema: public; Owner: -
--

CREATE POLICY users_insert_own_org_interactions ON public.ai_interactions FOR INSERT WITH CHECK ((organization_id = ((auth.jwt() ->> 'organization_id'::text))::uuid));


--
-- Name: ai_interactions users_see_own_org_interactions; Type: POLICY; Schema: public; Owner: -
--

CREATE POLICY users_see_own_org_interactions ON public.ai_interactions FOR SELECT USING ((organization_id = ((auth.jwt() ->> 'organization_id'::text))::uuid));


--
-- Name: organization_policies users_see_own_org_policies; Type: POLICY; Schema: public; Owner: -
--

CREATE POLICY users_see_own_org_policies ON public.organization_policies FOR SELECT USING ((organization_id = ((auth.jwt() ->> 'organization_id'::text))::uuid));


--
-- Name: ai_usage users_see_own_org_usage; Type: POLICY; Schema: public; Owner: -
--

CREATE POLICY users_see_own_org_usage ON public.ai_usage FOR SELECT USING ((organization_id = ((auth.jwt() ->> 'organization_id'::text))::uuid));


--
-- Name: vertical_configs; Type: ROW SECURITY; Schema: public; Owner: -
--

ALTER TABLE public.vertical_configs ENABLE ROW LEVEL SECURITY;

--
-- Name: waitlist_configurations waitlist_config_insert; Type: POLICY; Schema: public; Owner: -
--

CREATE POLICY waitlist_config_insert ON public.waitlist_configurations FOR INSERT WITH CHECK ((organization_id IN ( SELECT memberships.organization_id
   FROM public.memberships
  WHERE ((memberships.user_id = auth.uid()) AND (memberships.role_key = ANY (ARRAY['owner'::text, 'admin'::text]))))));


--
-- Name: waitlist_configurations waitlist_config_select; Type: POLICY; Schema: public; Owner: -
--

CREATE POLICY waitlist_config_select ON public.waitlist_configurations FOR SELECT USING ((organization_id IN ( SELECT memberships.organization_id
   FROM public.memberships
  WHERE (memberships.user_id = auth.uid()))));


--
-- Name: waitlist_configurations waitlist_config_update; Type: POLICY; Schema: public; Owner: -
--

CREATE POLICY waitlist_config_update ON public.waitlist_configurations FOR UPDATE USING ((organization_id IN ( SELECT memberships.organization_id
   FROM public.memberships
  WHERE ((memberships.user_id = auth.uid()) AND (memberships.role_key = ANY (ARRAY['owner'::text, 'admin'::text]))))));


--
-- Name: waitlist_configurations; Type: ROW SECURITY; Schema: public; Owner: -
--

ALTER TABLE public.waitlist_configurations ENABLE ROW LEVEL SECURITY;

--
-- Name: waitlist_entries; Type: ROW SECURITY; Schema: public; Owner: -
--

ALTER TABLE public.waitlist_entries ENABLE ROW LEVEL SECURITY;

--
-- Name: waitlist_entries waitlist_entries_delete; Type: POLICY; Schema: public; Owner: -
--

CREATE POLICY waitlist_entries_delete ON public.waitlist_entries FOR DELETE USING ((organization_id IN ( SELECT memberships.organization_id
   FROM public.memberships
  WHERE (memberships.user_id = auth.uid()))));


--
-- Name: waitlist_entries waitlist_entries_insert; Type: POLICY; Schema: public; Owner: -
--

CREATE POLICY waitlist_entries_insert ON public.waitlist_entries FOR INSERT WITH CHECK ((organization_id IN ( SELECT memberships.organization_id
   FROM public.memberships
  WHERE (memberships.user_id = auth.uid()))));


--
-- Name: waitlist_entries waitlist_entries_select; Type: POLICY; Schema: public; Owner: -
--

CREATE POLICY waitlist_entries_select ON public.waitlist_entries FOR SELECT USING ((organization_id IN ( SELECT memberships.organization_id
   FROM public.memberships
  WHERE (memberships.user_id = auth.uid()))));


--
-- Name: waitlist_entries waitlist_entries_update; Type: POLICY; Schema: public; Owner: -
--

CREATE POLICY waitlist_entries_update ON public.waitlist_entries FOR UPDATE USING ((organization_id IN ( SELECT memberships.organization_id
   FROM public.memberships
  WHERE (memberships.user_id = auth.uid()))));


--
-- Name: walkin_configurations walkin_config_insert; Type: POLICY; Schema: public; Owner: -
--

CREATE POLICY walkin_config_insert ON public.walkin_configurations FOR INSERT WITH CHECK ((organization_id IN ( SELECT memberships.organization_id
   FROM public.memberships
  WHERE ((memberships.user_id = auth.uid()) AND (memberships.role_key = ANY (ARRAY['owner'::text, 'admin'::text]))))));


--
-- Name: walkin_configurations walkin_config_select; Type: POLICY; Schema: public; Owner: -
--

CREATE POLICY walkin_config_select ON public.walkin_configurations FOR SELECT USING ((organization_id IN ( SELECT memberships.organization_id
   FROM public.memberships
  WHERE (memberships.user_id = auth.uid()))));


--
-- Name: walkin_configurations walkin_config_update; Type: POLICY; Schema: public; Owner: -
--

CREATE POLICY walkin_config_update ON public.walkin_configurations FOR UPDATE USING ((organization_id IN ( SELECT memberships.organization_id
   FROM public.memberships
  WHERE ((memberships.user_id = auth.uid()) AND (memberships.role_key = ANY (ARRAY['owner'::text, 'admin'::text]))))));


--
-- Name: walkin_configurations; Type: ROW SECURITY; Schema: public; Owner: -
--

ALTER TABLE public.walkin_configurations ENABLE ROW LEVEL SECURITY;

--
-- Name: walkin_entries; Type: ROW SECURITY; Schema: public; Owner: -
--

ALTER TABLE public.walkin_entries ENABLE ROW LEVEL SECURITY;

--
-- Name: walkin_entries walkin_entries_delete; Type: POLICY; Schema: public; Owner: -
--

CREATE POLICY walkin_entries_delete ON public.walkin_entries FOR DELETE USING ((organization_id IN ( SELECT memberships.organization_id
   FROM public.memberships
  WHERE (memberships.user_id = auth.uid()))));


--
-- Name: walkin_entries walkin_entries_insert; Type: POLICY; Schema: public; Owner: -
--

CREATE POLICY walkin_entries_insert ON public.walkin_entries FOR INSERT WITH CHECK ((organization_id IN ( SELECT memberships.organization_id
   FROM public.memberships
  WHERE (memberships.user_id = auth.uid()))));


--
-- Name: walkin_entries walkin_entries_select; Type: POLICY; Schema: public; Owner: -
--

CREATE POLICY walkin_entries_select ON public.walkin_entries FOR SELECT USING ((organization_id IN ( SELECT memberships.organization_id
   FROM public.memberships
  WHERE (memberships.user_id = auth.uid()))));


--
-- Name: walkin_entries walkin_entries_update; Type: POLICY; Schema: public; Owner: -
--

CREATE POLICY walkin_entries_update ON public.walkin_entries FOR UPDATE USING ((organization_id IN ( SELECT memberships.organization_id
   FROM public.memberships
  WHERE (memberships.user_id = auth.uid()))));


--
-- Name: whatsapp_conversations; Type: ROW SECURITY; Schema: public; Owner: -
--

ALTER TABLE public.whatsapp_conversations ENABLE ROW LEVEL SECURITY;

--
-- Name: whatsapp_conversations whatsapp_conversations_user_access; Type: POLICY; Schema: public; Owner: -
--

CREATE POLICY whatsapp_conversations_user_access ON public.whatsapp_conversations FOR SELECT TO authenticated USING (((entity_id IN ( SELECT entities.id
   FROM public.entities
  WHERE (entities.id IN ( SELECT whatsapp_conversations.entity_id
           FROM public.profiles
          WHERE (profiles.user_id = auth.uid()))))) OR (organization_id IN ( SELECT organizations.id
   FROM public.organizations
  WHERE (organizations.id IN ( SELECT entities.organization_id
           FROM public.entities
          WHERE (entities.id IN ( SELECT whatsapp_conversations.entity_id
                   FROM public.profiles
                  WHERE (profiles.user_id = auth.uid())))))))));


--
-- Name: whatsapp_messages; Type: ROW SECURITY; Schema: public; Owner: -
--

ALTER TABLE public.whatsapp_messages ENABLE ROW LEVEL SECURITY;

--
-- Name: whatsapp_messages whatsapp_messages_user_access; Type: POLICY; Schema: public; Owner: -
--

CREATE POLICY whatsapp_messages_user_access ON public.whatsapp_messages FOR SELECT TO authenticated USING ((conversation_id IN ( SELECT whatsapp_conversations.id
   FROM public.whatsapp_conversations
  WHERE (whatsapp_conversations.entity_id IN ( SELECT entities.id
           FROM public.entities
          WHERE (entities.id IN ( SELECT whatsapp_conversations.entity_id
                   FROM public.profiles
                  WHERE (profiles.user_id = auth.uid()))))))));


--
-- Name: whatsapp_org_config; Type: ROW SECURITY; Schema: public; Owner: -
--

ALTER TABLE public.whatsapp_org_config ENABLE ROW LEVEL SECURITY;

--
-- Name: work_policies; Type: ROW SECURITY; Schema: public; Owner: -
--

ALTER TABLE public.work_policies ENABLE ROW LEVEL SECURITY;

--
-- Name: work_policies work_policies_org_access; Type: POLICY; Schema: public; Owner: -
--

CREATE POLICY work_policies_org_access ON public.work_policies USING ((organization_id IN ( SELECT memberships.organization_id
   FROM public.memberships
  WHERE (memberships.user_id = auth.uid()))));


--
-- PostgreSQL database dump complete
--

\unrestrict p12L0QOdpdXbBKr98WuOiwqwK06CIeOtomGGVtCyttI4XMMJhem0frKXDbW7wGu

