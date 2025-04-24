import 'package:flutter/material.dart';
import 'dart:html' as html;
import 'dart:js' as js;
import 'package:supabase_flutter/supabase_flutter.dart';

class NotificationHandler {
  static Future<void> requestPermissionAndSubscribe(BuildContext context) async {
    try {
      // Request notification permission
      final permission = await html.Notification.requestPermission();
      if (permission != 'granted') {
        print('Notification permission denied');
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('تم رفض إذن الإشعارات')),
        );
        return;
      }

      // Check if service worker is supported
      if (html.window.navigator.serviceWorker == null) {
        print('Service Worker is not supported in this browser');
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('المتصفح لا يدعم الإشعارات')),
        );
        return;
      }

      // Wait for the JavaScript environment to be ready
      final windowObj = js.JsObject.fromBrowserObject(js.context['window']);
      bool isReady = windowObj['pushEnvReady'] == true;
      int attempts = 0;
      const maxAttempts = 20; // Wait up to 10 seconds (20 * 500ms)

      while (!isReady && attempts < maxAttempts) {
        await Future.delayed(Duration(milliseconds: 500));
        isReady = windowObj['pushEnvReady'] == true;
        attempts++;
        print('Waiting for push environment to be ready... Attempt $attempts');
      }

      if (!isReady) {
        throw Exception('Push environment not ready after waiting');
      }

      // Fetch the VAPID public key from window (hardcoded in index.html)
      final vapidPublicKey = windowObj['VAPID_PUBLIC_KEY'] as String?;

      if (vapidPublicKey == null) {
        print('VAPID_PUBLIC_KEY is not available');
        throw Exception('VAPID public key not found in window object');
      }

      // Subscribe to push notifications
      final registration = await html.window.navigator.serviceWorker!.ready;

      final applicationServerKey = windowObj.callMethod('urlBase64ToUint8Array', [vapidPublicKey]);
      final pushManager = js.JsObject.fromBrowserObject(registration.pushManager!);
      final options = js.JsObject.jsify({
        'userVisibleOnly': true,
        'applicationServerKey': applicationServerKey,
      });

      final subscription = await js.context['Promise'].callMethod('resolve', [
        pushManager.callMethod('subscribe', [options])
      ]);

      final subscriptionJson = js.JsObject.fromBrowserObject(subscription).callMethod('toJSON');
      final subscriptionData = {
        'endpoint': subscriptionJson['endpoint'],
        'p256dh': subscriptionJson['keys']['p256dh'],
        'auth': subscriptionJson['keys']['auth'],
      };

      // Store subscription in Supabase
      final userId = 'user-id-placeholder'; // TODO: Replace with actual user ID from Supabase Auth
      await Supabase.instance.client.from('push_subscriptions').upsert({
        'user_id': userId,
        'subscription': subscriptionData,
        'created_at': DateTime.now().toIso8601String(),
      });

      print('Push subscription stored successfully');
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('تم تفعيل الإشعارات بنجاح')),
      );
    } catch (e) {
      print('Error subscribing to push notifications: $e');
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('فشل تفعيل الإشعارات: $e')),
      );
    }
  }
}