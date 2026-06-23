-- ============================================================
-- WC2026 Analytics — Supabase Setup SQL
-- Jalankan ini di: Supabase Dashboard → SQL Editor → New Query
-- ============================================================

-- 1. Buat tabel visits
CREATE TABLE IF NOT EXISTS public.visits (
  id          BIGSERIAL    PRIMARY KEY,
  visited_at  TIMESTAMPTZ  NOT NULL DEFAULT NOW(),
  date_key    TEXT         NOT NULL,   -- e.g. '2026-06-12'
  timezone    TEXT         NOT NULL,   -- e.g. 'WIB', 'WITA', 'UTC+8'
  session_id  TEXT         NOT NULL,   -- random UUID per sesi (privacy-safe)
  user_agent  TEXT                     -- browser info (opsional, bisa dihapus)
);

-- 2. Index untuk query cepat
CREATE INDEX IF NOT EXISTS idx_visits_date_key   ON public.visits(date_key);
CREATE INDEX IF NOT EXISTS idx_visits_visited_at ON public.visits(visited_at DESC);

-- 3. Enable Row Level Security
ALTER TABLE public.visits ENABLE ROW LEVEL SECURITY;

-- 4. Policy: siapapun bisa INSERT (anon key) — untuk tracking kunjungan
CREATE POLICY "allow_anon_insert"
  ON public.visits
  FOR INSERT
  TO anon
  WITH CHECK (true);

-- 5. Policy: siapapun bisa SELECT — untuk dashboard analytics
--    Ganti TO anon → TO authenticated jika ingin dashboard hanya bisa diakses setelah login
CREATE POLICY "allow_anon_select"
  ON public.visits
  FOR SELECT
  TO anon
  USING (true);

-- 6. View agregasi harian (untuk dashboard — lebih efisien dari full table scan)
CREATE OR REPLACE VIEW public.visits_daily AS
  SELECT
    date_key,
    COUNT(*)            AS total_visits,
    COUNT(DISTINCT session_id) AS unique_sessions,
    MIN(visited_at)     AS first_visit,
    MAX(visited_at)     AS last_visit
  FROM public.visits
  GROUP BY date_key
  ORDER BY date_key DESC;

-- 7. View agregasi per timezone
CREATE OR REPLACE VIEW public.visits_by_timezone AS
  SELECT
    timezone,
    COUNT(*)            AS total_visits,
    COUNT(DISTINCT session_id) AS unique_sessions,
    MAX(visited_at)     AS last_visit
  FROM public.visits
  GROUP BY timezone
  ORDER BY total_visits DESC;

-- 8. View ringkasan keseluruhan
CREATE OR REPLACE VIEW public.visits_summary AS
  SELECT
    COUNT(*)                    AS total_visits,
    COUNT(DISTINCT session_id)  AS unique_sessions,
    COUNT(DISTINCT date_key)    AS active_days,
    MIN(visited_at)             AS first_visit_ever,
    MAX(visited_at)             AS last_visit_ever
  FROM public.visits;

-- Grant akses view ke anon role
GRANT SELECT ON public.visits_daily        TO anon;
GRANT SELECT ON public.visits_by_timezone  TO anon;
GRANT SELECT ON public.visits_summary      TO anon;

-- ============================================================
-- SELESAI. Sekarang:
-- 1. Catat Project URL dari Settings → API → Project URL
-- 2. Catat anon public key dari Settings → API → anon public
-- 3. Masukkan keduanya ke wc2026_v3.html dan wc2026_analytics.html
-- ============================================================

-- ============================================================
-- Tambahan: Tabel predictions untuk Quiz Komunitas
-- Jalankan ini jika belum ada (aman dijalankan ulang)
-- ============================================================

CREATE TABLE IF NOT EXISTS public.predictions (
  id            BIGSERIAL    PRIMARY KEY,
  session_id    TEXT         NOT NULL,
  match_id      TEXT         NOT NULL,
  score_home    INTEGER      NOT NULL,
  score_away    INTEGER      NOT NULL,
  submitted_at  TIMESTAMPTZ  NOT NULL DEFAULT NOW()
);

CREATE INDEX IF NOT EXISTS idx_pred_session ON public.predictions(session_id);
CREATE INDEX IF NOT EXISTS idx_pred_match   ON public.predictions(match_id);

ALTER TABLE public.predictions ENABLE ROW LEVEL SECURITY;

CREATE POLICY IF NOT EXISTS "allow_anon_insert_pred"
  ON public.predictions FOR INSERT TO anon WITH CHECK (true);
CREATE POLICY IF NOT EXISTS "allow_anon_select_pred"
  ON public.predictions FOR SELECT TO anon USING (true);

-- Tabel match_updates untuk admin sync & API cache
CREATE TABLE IF NOT EXISTS public.match_updates (
  id          BIGSERIAL    PRIMARY KEY,
  match_id    TEXT         NOT NULL,
  score_home  INTEGER,
  score_away  INTEGER,
  status      TEXT,
  scorers     TEXT,
  force       BOOLEAN      DEFAULT false,
  updated_at  TIMESTAMPTZ  NOT NULL DEFAULT NOW()
);

CREATE INDEX IF NOT EXISTS idx_mu_match ON public.match_updates(match_id);
CREATE INDEX IF NOT EXISTS idx_mu_time  ON public.match_updates(updated_at DESC);

ALTER TABLE public.match_updates ENABLE ROW LEVEL SECURITY;

CREATE POLICY IF NOT EXISTS "allow_anon_insert_mu"
  ON public.match_updates FOR INSERT TO anon WITH CHECK (true);
CREATE POLICY IF NOT EXISTS "allow_anon_select_mu"
  ON public.match_updates FOR SELECT TO anon USING (true);

GRANT SELECT, INSERT ON public.predictions   TO anon;
GRANT SELECT, INSERT ON public.match_updates TO anon;
