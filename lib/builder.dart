

import 'package:amaze_game/services/haptic_engine_service.dart';
import 'package:amaze_game/services/audio_player_service.dart';
import 'package:flutter/material.dart';
import 'package:flame/flame.dart';

import 'package:amaze_game/states/settings_state.dart';
import 'package:amaze_game/pages/building_page.dart';

import 'package:amaze_game/logical/color_palette_logic.dart';


void main() async {

  WidgetsFlutterBinding.ensureInitialized();
  Flame.device.setPortraitUpOnly();
  //
  final ColorPaletteLogic colorPalette = ColorPaletteLogic.fromHue(208);
  final SettingsState settingsState = SettingsState();
  final HapticEngineService hapticEngine = HapticEngineService(settingsState: settingsState);
  final AudioPlayerService audioPlayer = AudioPlayerService(
    sfxAssets:["assets/audio/sfx/tap-dull-1.wav"],
    settingsState: settingsState
  );

  await audioPlayer.initialize();
  await hapticEngine.initialize();

  runApp(MaterialApp(
    title: 'Bottom Tray Example',
    theme: ThemeData(
      primarySwatch: Colors.blue,
    ),
    home: SafeArea(
        child: BuildingPage(
          audioPlayer: audioPlayer,
          hapticEngine: hapticEngine,
          colorPalette: colorPalette,
          settingsState: settingsState,
        )
    ),
  ));
  // print("Hello World");
  // MazeLogic mazeLogic = MazeGenerator.getMaze(8, 12);
  // log(getPrettyJSONString(mazeLogic));

  // print(getPrettyJSONString(mazeLogic));
}
