import 'dart:async';
import 'package:firebase_crashlytics/firebase_crashlytics.dart';
import 'package:flutter/material.dart';
import 'package:flame/flame.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_analytics/firebase_analytics.dart';
import 'firebase_options.dart';

import 'package:hive_flutter/hive_flutter.dart';
import 'package:amaze_game/states/level_state.dart';
import 'package:amaze_game/pages/launcher_page.dart';
import 'package:amaze_game/states/duration_adaptor.dart';
import 'package:amaze_game/states/settings_state.dart';

const bool enableCrashlytics = false;

Future<void> setUp() async {
  WidgetsFlutterBinding.ensureInitialized();

  // Lock to portrait mode
  await Flame.device.setPortraitUpOnly();

  // Initialize Hive
  await Hive.initFlutter();
  Hive.registerAdapter(LevelStateAdapter());
  Hive.registerAdapter(LevelStateEnumAdapter());
  Hive.registerAdapter(DurationAdapter());
  Hive.registerAdapter(SettingsStateAdapter());

  // Initialize Firebase
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);

  // Disable Firebase Analytics when Crashlytics is off
  await FirebaseAnalytics.instance.setAnalyticsCollectionEnabled(enableCrashlytics);
}

void main() async {
  await setUp();

  if (enableCrashlytics) {
    runZonedGuarded(() {
      // Set up Crashlytics error handling
      FlutterError.onError = FirebaseCrashlytics.instance.recordFlutterError;

      runApp(const MaterialApp(
        debugShowCheckedModeBanner: false,
        home: SafeArea(child: LauncherPage()),
      ));
    }, (error, stackTrace) {
      FirebaseCrashlytics.instance.recordError(error, stackTrace, fatal: true);
    });
  } else {
    runApp(const MaterialApp(
      debugShowCheckedModeBanner: false,
      home: SafeArea(child: LauncherPage()),
    ));
  }
}
