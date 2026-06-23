/**
 * config.js — Konfigurasi WC 2026 App
 * =====================================
 * CARA PENGGUNAAN:
 * 1. Isi supabaseUrl + supabaseKey dari supabase.com → Settings → API
 * 2. (Opsional tapi SANGAT DIREKOMENDASIKAN) Daftar GRATIS di:
 * https://dashboard.api-football.com/register
 * → Isi apiFootballToken dengan key yang diterima via email
 * → Dengan ini, Top Scorer, Assist, dan pencetak gol per match
 * akan UPDATE OTOMATIS tanpa perlu deploy ulang!
 * → Free tier: 100 request/hari, cukup untuk polling setiap 15 menit
 */

const APP_CONFIG = {
  // ── Supabase ──────────────────────────────────────────────────────────
  supabaseUrl: 'https://vnkjkvxtiykpnnauepro.supabase.co',
  supabaseKey: 'eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJpc3MiOiJzdXBhYmFzZSIsInJlZiI6InZua2prdnh0aXlrcG5uYXVlcHJvIiwicm9sZSI6ImFub24iLCJpYXQiOjE3ODEyNTExODUsImV4cCI6MjA5NjgyNzE4NX0.F3lMS_AfVj5AU7ZMtSW8CRUAEHznw97NISsPcCPizvE',

  // ── API-Football (untuk auto-update Top Scorer & Assist) ───────────────
  // Token sudah dimasukkan berdasarkan instruksi sebelumnya.
  apiFootballToken: 'd41230d3632c6ab4c7ad5cf4c4acf948',   // Token dari dashboard.api-football.com

  // ── App settings ──────────────────────────────────────────────────────
  sessionMinutes:  30,
  apiPollLive:     60,
  apiPollIdle:     300,
  refreshInterval: 900000, // Tambahkan ini: 15 menit interval untuk mencegah kuota API Football habis
  defaultTimezone: 'Asia/Jakarta',
};
