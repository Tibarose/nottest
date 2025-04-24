importScripts("https://www.gstatic.com/firebasejs/10.12.9/firebase-app-compat.js");
importScripts("https://www.gstatic.com/firebasejs/10.12.9/firebase-messaging-compat.js");

firebase.initializeApp({
  apiKey: "AIzaSyAP8Jq96CySgpAEcYU13vMiw95vTlKYAEA",
  authDomain: "gardeniatoday-82e68.firebaseapp.com",
  projectId: "gardeniatoday-82e68",
  storageBucket: "gardeniatoday-82e68.firebasestorage.app",
  messagingSenderId: "79911467145",
  appId: "1:79911467145:web:34adee95f50ac65e4eae58",
  measurementId: "G-0KWN75E378"
});

const messaging = firebase.messaging();

messaging.onBackgroundMessage(function(payload) {
  console.log('[Push] Background message:', payload);
  const { title, body } = payload.notification;
  self.registration.showNotification(title, {
    body,
    icon: '/icons/Icon-192.png'
  });
});