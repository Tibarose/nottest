import 'dart:html' as html;
import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';

import 'firebaseoptions.dart';

// Optional background handler (only for completeness, not used on web)
Future<void> _firebaseMessagingBackgroundHandler(RemoteMessage message) async {
  print("🔙 Background message: ${message.messageId}");
}

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // Step 1: Initialize Firebase
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );

  // Step 2: Set background message handler (not used on web, handled by service worker)
  FirebaseMessaging.onBackgroundMessage(_firebaseMessagingBackgroundHandler);

  // Step 3: Register the service worker manually for web
  if (html.window.navigator.serviceWorker != null) {
    await html.window.navigator.serviceWorker!.register('/nottest/firebase-messaging-sw.js');
    print('Service Worker registered successfully from /nottest/firebase-messaging-sw.js');
    await html.window.navigator.serviceWorker!.ready;
  }

  // Step 4: Listen to foreground messages
  FirebaseMessaging.onMessage.listen((RemoteMessage message) {
    print('📩 New foreground message received!');
    if (message.notification != null) {
      print('🔔 Title: ${message.notification?.title}');
      print('📝 Body: ${message.notification?.body}');
    }
  });

  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Web FCM',
      theme: ThemeData(primarySwatch: Colors.blue),
      home: const NotificationHomePage(),
    );
  }
}

class NotificationHomePage extends StatefulWidget {
  const NotificationHomePage({super.key});

  @override
  _NotificationHomePageState createState() => _NotificationHomePageState();
}

class _NotificationHomePageState extends State<NotificationHomePage> {
  final FirebaseMessaging _messaging = FirebaseMessaging.instance;
  String? _token;
  String _permissionStatus = 'Not requested';

  Future<void> _requestPermission() async {
    NotificationSettings settings = await _messaging.requestPermission(
      alert: true,
      badge: true,
      sound: true,
    );

    setState(() {
      _permissionStatus = settings.authorizationStatus.toString();
    });
    print('🔐 User granted permission: ${settings.authorizationStatus}');

    if (settings.authorizationStatus == AuthorizationStatus.authorized) {
      // Get the token
      String? token = await _messaging.getToken(
        vapidKey: 'BOX59MKvsok_QHYmSkD06klzNhJ6KPBAuf5nN0SZLjCfxQWcuwyEc08p4dkdhNUXrdXP3eZTtuON1sMBifgWgVk',
      );
      setState(() {
        _token = token;
      });
      print('📱 FCM Token (web): $token');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('FCM Web Notification')),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Text(
              '💬 Waiting for push notifications...',
              style: TextStyle(fontSize: 20),
            ),
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: _requestPermission,
              child: const Text('Enable Notifications'),
            ),
            const SizedBox(height: 20),
            Text('Permission Status: $_permissionStatus'),
            const SizedBox(height: 10),
            if (_token != null)
              Text(
                'FCM Token: $_token',
                style: const TextStyle(fontSize: 16),
                textAlign: TextAlign.center,
              ),
          ],
        ),
      ),
    );
  }
}