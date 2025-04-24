importScripts("https://www.gstatic.com/firebasejs/10.12.9/firebase-app-compat.js");
importScripts("https://www.gstatic.com/firebasejs/10.12.9/firebase-messaging-compat.js");

console.log("[Service Worker] firebase-messaging-sw.js loaded successfully");

try {
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
    const { title, body } = payload.notification;
    self.registration.showNotification(title, {
      body: body,
      icon: "https://tibarose.github.io/nottest/icons/Icon-192.png"
    });
  });

  self.addEventListener('install', (event) => {
    console.log('[Service Worker] Installed');
  });

  self.addEventListener('activate', (event) => {
    console.log('[Service Worker] Activated');
  });
} catch (error) {
  console.error('[Service Worker] Error:', error);
}