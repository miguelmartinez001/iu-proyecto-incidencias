-- ============================================================
-- Urbana Report - MVP Database Schema
-- PostgreSQL + Supabase + PostGIS
-- ============================================================

-- ============================================================
-- EXTENSIONS
-- ============================================================

CREATE EXTENSION IF NOT EXISTS pgcrypto;
CREATE EXTENSION IF NOT EXISTS postgis;

-- ============================================================
-- ENUMS
-- ============================================================

DO $$
BEGIN
    IF NOT EXISTS (
        SELECT 1
        FROM pg_type
        WHERE typname = 'report_status'
    ) THEN
        CREATE TYPE report_status AS ENUM (
            'ACTIVE',
            'IN_REVIEW',
            'RESOLVED'
        );
    END IF;
END
$$;

DO $$
BEGIN
    IF NOT EXISTS (
        SELECT 1
        FROM pg_type
        WHERE typname = 'report_priority'
    ) THEN
        CREATE TYPE report_priority AS ENUM (
            'LOW',
            'MEDIUM',
            'HIGH'
        );
    END IF;
END
$$;

DO $$
BEGIN
    IF NOT EXISTS (
        SELECT 1
        FROM pg_type
        WHERE typname = 'report_action_type'
    ) THEN
        CREATE TYPE report_action_type AS ENUM (
            'REPORT_CREATED',
            'PHOTO_ADDED',
            'CONFIRM',
            'WORSENED',
            'POSSIBLY_RESOLVED',
            'SHARED',
            'STATUS_CHANGED'
        );
    END IF;
END
$$;

-- ============================================================
-- TABLE: profiles
-- ============================================================

CREATE TABLE IF NOT EXISTS public.profiles (
    id uuid PRIMARY KEY REFERENCES auth.users(id) ON DELETE CASCADE,
    display_name text NOT NULL CHECK (length(trim(display_name)) BETWEEN 2 AND 100),
    avatar_url text,
    created_at timestamptz NOT NULL DEFAULT now(),
    updated_at timestamptz NOT NULL DEFAULT now()
);

COMMENT ON TABLE public.profiles IS
'Información pública del usuario.';

-- ============================================================
-- TABLE: user_preferences
-- ============================================================

CREATE TABLE IF NOT EXISTS public.user_preferences (
    profile_id uuid PRIMARY KEY
        REFERENCES public.profiles(id)
        ON DELETE CASCADE,

    notifications_enabled boolean NOT NULL DEFAULT true,
    show_context_tips boolean NOT NULL DEFAULT true,
    compact_view boolean NOT NULL DEFAULT false,
    hide_images boolean NOT NULL DEFAULT false,

    language text NOT NULL DEFAULT 'es'
        CHECK (length(language) BETWEEN 2 AND 10),

    theme text NOT NULL DEFAULT 'system'
        CHECK (theme IN ('light','dark','system'))
);

COMMENT ON TABLE public.user_preferences IS
'Preferencias del usuario.';

-- ============================================================
-- TABLE: categories
-- ============================================================

CREATE TABLE IF NOT EXISTS public.categories (

    id uuid PRIMARY KEY DEFAULT gen_random_uuid(),

    name text NOT NULL,

    description text,

    icon text,

    color text,

    authority_name text,

    active boolean NOT NULL DEFAULT true,

    created_at timestamptz NOT NULL DEFAULT now(),

    CONSTRAINT uq_categories_name UNIQUE(name),

    CONSTRAINT chk_category_name
        CHECK(length(trim(name)) > 1)
);

COMMENT ON TABLE public.categories IS
'Catálogo de categorías.';

-- ============================================================
-- TABLE: reports
-- ============================================================

CREATE TABLE IF NOT EXISTS public.reports (

    id uuid PRIMARY KEY DEFAULT gen_random_uuid(),

    creator_id uuid NOT NULL
        REFERENCES public.profiles(id)
        ON DELETE CASCADE,

    category_id uuid NOT NULL
        REFERENCES public.categories(id),

    title text NOT NULL,

    description text NOT NULL,

    address text NOT NULL,

    latitude double precision NOT NULL
        CHECK(latitude BETWEEN -90 AND 90),

    longitude double precision NOT NULL
        CHECK(longitude BETWEEN -180 AND 180),

    location geography(Point,4326) NOT NULL,

    status report_status NOT NULL
        DEFAULT 'ACTIVE',

    priority report_priority NOT NULL
        DEFAULT 'MEDIUM',

    created_at timestamptz NOT NULL DEFAULT now(),

    updated_at timestamptz NOT NULL DEFAULT now(),

    CONSTRAINT chk_title
        CHECK(length(trim(title)) BETWEEN 5 AND 200),

    CONSTRAINT chk_description
        CHECK(length(trim(description)) >= 10)
);

COMMENT ON TABLE public.reports IS
'Reportes ciudadanos.';

-- ============================================================
-- TABLE: report_images
-- ============================================================

CREATE TABLE IF NOT EXISTS public.report_images (

    id uuid PRIMARY KEY DEFAULT gen_random_uuid(),

    report_id uuid NOT NULL
        REFERENCES public.reports(id)
        ON DELETE CASCADE,

    storage_path text NOT NULL,

    uploaded_at timestamptz NOT NULL DEFAULT now()
);

COMMENT ON TABLE public.report_images IS
'Imágenes almacenadas en Supabase Storage.';

-- ============================================================
-- TABLE: report_actions
-- ============================================================

CREATE TABLE IF NOT EXISTS public.report_actions (

    id uuid PRIMARY KEY DEFAULT gen_random_uuid(),

    report_id uuid NOT NULL
        REFERENCES public.reports(id)
        ON DELETE CASCADE,

    user_id uuid NOT NULL
        REFERENCES public.profiles(id)
        ON DELETE CASCADE,

    action_type report_action_type NOT NULL,

    metadata jsonb NOT NULL DEFAULT '{}'::jsonb,

    created_at timestamptz NOT NULL DEFAULT now()
);

COMMENT ON TABLE public.report_actions IS
'Historial de acciones realizadas sobre los reportes.';

-- ============================================================
-- TABLE: notifications
-- ============================================================

CREATE TABLE IF NOT EXISTS public.notifications (

    id uuid PRIMARY KEY DEFAULT gen_random_uuid(),

    user_id uuid NOT NULL
        REFERENCES public.profiles(id)
        ON DELETE CASCADE,

    title text NOT NULL,

    message text NOT NULL,

    is_read boolean NOT NULL DEFAULT false,

    created_at timestamptz NOT NULL DEFAULT now(),

    CONSTRAINT chk_notification_title
        CHECK(length(trim(title)) > 0),

    CONSTRAINT chk_notification_message
        CHECK(length(trim(message)) > 0)
);

COMMENT ON TABLE public.notifications IS
'Notificaciones del usuario.';

-- ============================================================
-- INDEXES
-- ============================================================

CREATE INDEX IF NOT EXISTS idx_reports_creator
ON public.reports(creator_id);

CREATE INDEX IF NOT EXISTS idx_reports_category
ON public.reports(category_id);

CREATE INDEX IF NOT EXISTS idx_reports_status
ON public.reports(status);

CREATE INDEX IF NOT EXISTS idx_reports_priority
ON public.reports(priority);

CREATE INDEX IF NOT EXISTS idx_reports_created
ON public.reports(created_at DESC);

CREATE INDEX IF NOT EXISTS idx_reports_location
ON public.reports
USING GIST(location);

CREATE INDEX IF NOT EXISTS idx_report_images_report
ON public.report_images(report_id);

CREATE INDEX IF NOT EXISTS idx_report_actions_report
ON public.report_actions(report_id);

CREATE INDEX IF NOT EXISTS idx_report_actions_user
ON public.report_actions(user_id);

CREATE INDEX IF NOT EXISTS idx_report_actions_type
ON public.report_actions(action_type);

CREATE INDEX IF NOT EXISTS idx_notifications_user
ON public.notifications(user_id);

CREATE INDEX IF NOT EXISTS idx_notifications_read
ON public.notifications(user_id, is_read);