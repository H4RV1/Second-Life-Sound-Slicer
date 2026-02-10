# Analytics Setup Guide

## 1. Create a Supabase Project (Free)

1. Go to [supabase.com](https://supabase.com) and sign up / sign in
2. Click **New Project**
3. Give it a name (e.g. `sl-sound-slicer`)
4. Set a database password (save it somewhere)
5. Choose a region close to your users
6. Click **Create new project** — wait ~2 minutes for provisioning

## 2. Create the Database Tables

1. In your Supabase dashboard, go to **SQL Editor**
2. Click **New Query**
3. Paste the entire contents of [`supabase-setup.sql`](supabase-setup.sql)
4. Click **Run** — you should see "Success" for all statements

This creates two tables:
- **`slice_events`** — logs every song sliced (name, artist, format, duration, clips)
- **`page_visits`** — logs unique page visits per session

Both tables have Row Level Security (RLS) policies allowing anonymous reads and inserts.

## 3. Get Your API Credentials

1. Go to **Settings** → **API** in your Supabase dashboard
2. Copy:
   - **Project URL** — looks like `https://xxxxx.supabase.co`
   - **anon public** key — the long `eyJ...` string under "Project API keys"

## 4. Add Credentials to Your Site

Open **`index.html`** and find these lines near the top of the `<script>` block:

```js
const SUPABASE_URL = 'YOUR_SUPABASE_URL';
const SUPABASE_KEY = 'YOUR_SUPABASE_ANON_KEY';
```

Replace with your actual values:

```js
const SUPABASE_URL = 'https://xxxxx.supabase.co';
const SUPABASE_KEY = 'eyJhbGciOi...';
```

Do the same in **`dashboard.html`** — same two lines at the top of the `<script>` block.

## 5. Deploy

Commit and push to GitHub. The site updates automatically via GitHub Pages.

```bash
git add index.html dashboard.html supabase-setup.sql ANALYTICS.md
git commit -m "Add analytics dashboard with Supabase"
git push
```

## 6. View Your Dashboard

Visit `https://your-site.com/dashboard.html` — it will show:

- **Overview** — total visitors, sessions, songs sliced, clips, audio processed, upload cost
- **Activity chart** — daily/monthly bar chart
- **Top songs & artists** — most frequently sliced
- **Format breakdown** — MP3 vs WAV vs FLAC distribution
- **Clip lengths** — which presets are used most
- **Recent activity** — last 50 slice events

## How It Works

- **Privacy-first**: audio files never leave the browser. Only metadata (song name, artist, format, duration, clip count) is logged.
- **Anonymous**: no accounts, no PII. Sessions use `crypto.randomUUID()` stored in `sessionStorage` (cleared when browser tab closes).
- **Non-blocking**: analytics logging is fire-and-forget. If Supabase is down, slicing works normally.
- **Graceful fallback**: if credentials aren't configured, analytics is silently disabled.

## Supabase Free Tier Limits

- 500 MB database storage
- 2 GB bandwidth per month
- Unlimited API requests
- Project pauses after 1 week of inactivity (wakes on next request)

For a tool like this, the free tier is more than enough.
