// main.dart
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:todoo_app/my_app.dart';
import 'package:todoo_app/services/hive_service.dart';
import 'package:timezone/timezone.dart' as tz;
import 'package:timezone/data/latest.dart' as tz;
import 'package:todoo_app/services/notification.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  tz.initializeTimeZones(); // Fixes the _local error

  final hiveService = HiveService();
  await hiveService.init();

  // Create one container and put everything in it
  final container = ProviderContainer(
    overrides: [hiveServiceProvider.overrideWithValue(hiveService)],
  );

  // Initialize notifications on THIS container
  await container.read(notificationServiceProvider).initNotification();

  runApp(UncontrolledProviderScope(container: container, child: const MyApp()));
}
