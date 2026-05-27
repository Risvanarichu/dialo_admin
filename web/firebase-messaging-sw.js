importScripts(
'https://www.gstatic.com/firebasejs/10.13.2/firebase-app-compat.js');

importScripts(
'https://www.gstatic.com/firebasejs/10.13.2/firebase-messaging-compat.js');

firebase.initializeApp({
 apiKey: "YOUR_API_KEY",
 authDomain: "YOUR_DOMAIN",
 projectId: "YOUR_PROJECT_ID",
 storageBucket: "YOUR_BUCKET",
 messagingSenderId: "YOUR_SENDER_ID",
 appId: "YOUR_APP_ID",
});

const messaging = firebase.messaging();