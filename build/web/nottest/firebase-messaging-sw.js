// Check if importScripts is available
if (typeof importScripts !== 'function') {
  console.error('[Service Worker] importScripts is not available in this context');
  throw new Error('importScripts is not available');
}

try {
  importScripts("https://www.gstatic.com/firebasejs/10.12.9/firebase-app-compat.js");
  console.log('[Service Worker] firebase-app-compat.js loaded successfully');

  importScripts("https://www.gstatic.com/firebasejs/10.12.9/firebase-messaging-compat.js");
  console.log('[Service Worker] firebase-messaging-compat.js loaded successfully');
} catch (error) {
  console.error('[Service Worker] Error loading Firebase scripts:', error);
  throw error;
}

console.log("[Service Worker] firebase-messaging-sw.js loaded successfully");

try {
  if (typeof firebase === 'undefined') {
    console.error('[Service Worker] Firebase is not defined after importScripts');
    throw new Error('Firebase is not defined');
  }

  firebase.initializeApp({
    apiKey: "AIzaSyAP8Jq96CySgpAEcYU13vMiw95vTlKYAEA",
    authDomain: "gardeniatoday-82e68.firebaseapp.com",
    projectId: "gardeniatoday-82e68",
    storageBucket: "gardeniatoday-82e68.firebasestorage.app",
    messagingSenderId: "79911467145",
    appId: "1:79911467145:web:34adee95f50ac65e4eae58",
    measurementId: "G-0KWN75E378"
  });

  console.log("[Service Worker] Firebase initialized");

  const messaging = firebase.messaging();

  messaging.onBackgroundMessage(function(payload) {
    console.log('[Push] Background message:', payload);
    const { title, body } = payload.notification || {};
    if (title && body) {
      self.registration.showNotification(title, {
        body: body,
        icon: "https://tibarose.github.io/nottest/icons/Icon-192.png"
      });
    } else {
      console.error('[Push] Invalid notification payload:', payload);
    }
  });

  self.addEventListener('install', (event) => {
    console.log('[Service Worker] Installed');
    self.skipWaiting();
  });

  self.addEventListener('activate', (event) => {
    console.log('[Service Worker] Activated');
    event.waitUntil(self.clients.claim());
  });
} catch (error) {
  console.error('[Service Worker] Error:', error);
  throw error;
}
