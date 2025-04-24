import { initializeApp } from "https://www.gstatic.com/firebasejs/9.1.3/firebase-app.js";
import { getAnalytics } from "https://www.gstatic.com/firebasejs/9.1.3/firebase-analytics.js";

const firebaseConfig = {
  apiKey: "AIzaSyAP8Jq96CySgpAEcYU13vMiw95vTlKYAEA",
  authDomain: "gardeniatoday-82e68.firebaseapp.com",
  projectId: "gardeniatoday-82e68",
  storageBucket: "gardeniatoday-82e68.firebasestorage.app",
  messagingSenderId: "79911467145",
  appId: "1:79911467145:web:34adee95f50ac65e4eae58",
  measurementId: "G-0KWN75E378"
};

const app = initializeApp(firebaseConfig);
const analytics = getAnalytics(app);