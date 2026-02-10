-- ============================================================================
-- SL Sound Slicer — Supabase Schema
-- ============================================================================
-- Run this in your Supabase SQL Editor (Dashboard → SQL Editor → New Query)
--
-- Setup steps:
--   1. Create a free Supabase project at https://supabase.com
--   2. Go to SQL Editor and run this entire file
--   3. Copy your project URL + anon key from Settings → API
--   4. Paste them into index.html and dashboard.html (SUPABASE_URL / SUPABASE_KEY)
-- ============================================================================

-- ── Slice events table ──────────────────────────────────────
CREATE TABLE IF NOT EXISTS slice_events (
    id              UUID DEFAULT gen_random_uuid() PRIMARY KEY,
    created_at      TIMESTAMPTZ DEFAULT now() NOT NULL,
    session_id      TEXT NOT NULL DEFAULT '',
    song_name       TEXT DEFAULT '',
    artist          TEXT DEFAULT '',
    input_format    TEXT DEFAULT '',
    duration_secs   REAL DEFAULT 0,
    clip_count      INTEGER DEFAULT 0,
    clip_length     REAL DEFAULT 29.98,
    user_agent      TEXT DEFAULT '',
    screen_width    INTEGER DEFAULT 0
);

-- ── Indexes for dashboard queries ───────────────────────────
CREATE INDEX IF NOT EXISTS idx_slice_created   ON slice_events(created_at);
CREATE INDEX IF NOT EXISTS idx_slice_artist    ON slice_events(artist);
CREATE INDEX IF NOT EXISTS idx_slice_song      ON slice_events(song_name);
CREATE INDEX IF NOT EXISTS idx_slice_session   ON slice_events(session_id);

-- ── Page visits table (lightweight traffic counter) ─────────
CREATE TABLE IF NOT EXISTS page_visits (
    id              UUID DEFAULT gen_random_uuid() PRIMARY KEY,
    created_at      TIMESTAMPTZ DEFAULT now() NOT NULL,
    session_id      TEXT NOT NULL DEFAULT '',
    page            TEXT DEFAULT 'slicer',
    referrer        TEXT DEFAULT '',
    user_agent      TEXT DEFAULT '',
    screen_width    INTEGER DEFAULT 0
);

CREATE INDEX IF NOT EXISTS idx_visit_created ON page_visits(created_at);
CREATE INDEX IF NOT EXISTS idx_visit_page    ON page_visits(page);

-- ── Row Level Security ──────────────────────────────────────
-- Anyone can INSERT (anonymous users logging events)
-- Anyone can SELECT (public dashboard reads)
-- No UPDATE/DELETE from anonymous users

ALTER TABLE slice_events ENABLE ROW LEVEL SECURITY;
ALTER TABLE page_visits  ENABLE ROW LEVEL SECURITY;

-- Allow anonymous inserts
CREATE POLICY "Anyone can insert slice events"
    ON slice_events FOR INSERT
    TO anon
    WITH CHECK (true);

CREATE POLICY "Anyone can read slice events"
    ON slice_events FOR SELECT
    TO anon
    USING (true);

CREATE POLICY "Anyone can insert page visits"
    ON page_visits FOR INSERT
    TO anon
    WITH CHECK (true);

CREATE POLICY "Anyone can read page visits"
    ON page_visits FOR SELECT
    TO anon
    USING (true);
