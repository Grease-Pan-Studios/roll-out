


import 'package:flutter/material.dart';
import 'package:flame/flame.dart';

import 'package:hive_flutter/hive_flutter.dart';
import 'package:amaze_game/states/level_state.dart';
import 'package:amaze_game/pages/launcher_page.dart';
import 'package:amaze_game/states/duration_adaptor.dart';

import 'package:amaze_game/states/settings_state.dart';


void main()async {

  WidgetsFlutterBinding.ensureInitialized();
  Flame.device.setPortraitUpOnly();

  await Hive.initFlutter();
  Hive.registerAdapter(LevelStateAdapter());
  Hive.registerAdapter(LevelStateEnumAdapter());
  Hive.registerAdapter(DurationAdapter());
  Hive.registerAdapter(SettingsStateAdapter());


  runApp(
      const MaterialApp(
        home: SafeArea(
            child: LauncherPage(),
        ),
      )
  );
}



// GameWidget(game: MyGame()),


