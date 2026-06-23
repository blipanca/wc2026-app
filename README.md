# FIFA World Cup 2026 Tracker — GitHub Pages

## Cara deploy
1. Buat repo baru di GitHub (atau pakai yang sudah ada)
2. Upload semua file ini ke root repo (drag & drop di tab "Add file" → "Upload files")
3. Settings → Pages → Source: "Deploy from a branch" → Branch: `main` → Folder: `/ (root)` → Save
4. Tunggu 1-2 menit, situs aktif di: `https://[username].github.io/[nama-repo]/`

## File yang harus diupload
- `index.html` — app utama
- `config.js` — kredensial Supabase
- `manifest.json` — konfigurasi PWA
- `sw.js` — service worker (offline support)
- `icon.svg` — ikon app

## Catatan penting
- Semua path sudah relative (`./`) — otomatis bekerja baik di root domain maupun di subfolder repo
- Setelah deploy, gunakan URL `https://[username].github.io/[nama-repo]/` sebagai Source URL baru di Web2App Pro
- File `analytics.html` dan `supabase_setup.sql` adalah referensi, tidak perlu diupload kecuali ingin akses dashboard analytics terpisah
