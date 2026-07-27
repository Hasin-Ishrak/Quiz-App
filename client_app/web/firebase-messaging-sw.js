importScripts('https://www.gstatic.com/firebasejs/10.13.2/firebase-app-compat.js');
importScripts('https://www.gstatic.com/firebasejs/10.13.2/firebase-messaging-compat.js');

firebase.initializeApp({
  apiKey: 'AIzaSyAijNdC8ak9rLqv8ms8NMeqFjUYuAs2Cgk',
  appId: '1:388385014884:web:f4b59fe5d94c82d5d00b71',
  messagingSenderId: '388385014884',
  projectId: 'quiz-app-bdapps',
  authDomain: 'quiz-app-bdapps.firebaseapp.com',
  storageBucket: 'quiz-app-bdapps.firebasestorage.app',
});

const messaging = firebase.messaging();

messaging.onBackgroundMessage((payload) => {
  console.log('Received background message:', payload);
  const notificationTitle = payload.notification?.title ?? 'New notification';
  const notificationOptions = {
    body: payload.notification?.body,
    icon: '/icons/Icon-192.png',
  };
  self.registration.showNotification(notificationTitle, notificationOptions);
});