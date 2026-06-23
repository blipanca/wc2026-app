const CACHE = 'wc2026-v5';
const SHELL = ['./', './index.html', './manifest.json', './icon.svg', './config.js'];
self.addEventListener('install', e => {
  e.waitUntil(caches.open(CACHE).then(c => c.addAll(SHELL)).then(() => self.skipWaiting()));
});
self.addEventListener('activate', e => {
  e.waitUntil(caches.keys().then(ks => Promise.all(ks.filter(k=>k!==CACHE).map(k=>caches.delete(k)))).then(()=>self.clients.claim()));
});
self.addEventListener('fetch', e => {
  if(e.request.method!=='GET') return;
  e.respondWith(fetch(e.request).then(r=>{const clone=r.clone();caches.open(CACHE).then(ca=>ca.put(e.request,clone));return r;}).catch(()=>caches.match(e.request)));
});
self.addEventListener('push', e => {
  let d={title:'⚽ WC 2026',body:'Ada update pertandingan!',tag:'wc2026'};
  try{d={...d,...e.data.json()};}catch{}
  e.waitUntil(self.registration.showNotification(d.title,{body:d.body,icon:'./icon.svg',badge:'./icon.svg',tag:d.tag,vibrate:[200,100,200],actions:[{action:'open',title:'Lihat'},{action:'dismiss',title:'Tutup'}]}));
});
self.addEventListener('notificationclick', e => {
  e.notification.close();
  if(e.action==='dismiss') return;
  e.waitUntil(clients.matchAll({type:'window'}).then(list=>{for(const c of list)if('focus' in c)return c.focus();return clients.openWindow('./');}));
});
