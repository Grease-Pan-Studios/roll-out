
import 'package:amaze_game/pages/home_page.dart';
import 'package:amaze_game/pages/login_page.dart';
import 'package:amaze_game/services/audio_player_service.dart';
import 'package:amaze_game/services/haptic_engine_service.dart';
import 'package:amaze_game/services/storage_service.dart';

import 'package:amaze_game/states/settings_state.dart';


import 'package:flutter/material.dart';

import 'package:amaze_game/logical/color_palette_logic.dart';
import 'package:amaze_game/logical/game_logic.dart';
import 'package:amaze_game/states/game_state.dart';


class LauncherPage extends StatefulWidget {
  const LauncherPage({super.key});

  @override
  State<LauncherPage> createState() => _LauncherPageState();
}

class _LauncherPageState extends State<LauncherPage> {

  bool _showLogin = true;

  bool _hasLoaded = false;

  late GameLogic gameLogic;
  late GameState gameState;
  late SettingsState settingsState;
  late ColorPaletteLogic colorPalette;
  late HapticEngineService hapticEngine;
  late AudioPlayerService audioPlayer;
  late StorageService storageService;

  void _loadGame() async {

    storageService = StorageService();
    await storageService.initialize();

    gameLogic = GameLogic();
    gameLogic.fetchGameLogic();

    gameState = GameState(
      storageService: storageService
    );

    await gameState.initialize();

    settingsState = storageService.getSettingsState();

    audioPlayer = AudioPlayerService(
      sfxAssets:["assets/audio/sfx/tap-dull-1.wav"],
      settingsState: settingsState
    );

    await audioPlayer.initialize();

    hapticEngine = HapticEngineService(
        settingsState: settingsState
    );

    await hapticEngine.initialize();

    colorPalette = ColorPaletteLogic.fromHue(
        208, isDarkMode: settingsState.isDarkMode
    );

    Future.delayed(Duration(seconds: 0), () {
      setState(() {
        _hasLoaded = true;
      });
    });

  }

  @override
  void initState() {
    _loadGame();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return
        _hasLoaded ?
          // _showLogin ? LoginPage(
          //   colorPalette: colorPalette,
          //   goToGame: () {
          //     setState(() {
          //       _showLogin = false;
          //     });
          //   },
          // ):
          HomePage(
              gameLogic: gameLogic,
              gameState: gameState,
              settingsState: settingsState,
              hapticEngine: hapticEngine,
              audioPlayer: audioPlayer,
              colorPalette: colorPalette,
              storageService: storageService,
          ): Material(
            color: ColorPaletteLogic.asBlackTheme().activeElementBackground,
            child: Align(
              alignment: Alignment(-0.1, -0.1),
              child: Text(
                "Roll Out",
                style: TextStyle(
                  fontFamily: "Advent",
                  fontWeight: FontWeight.w700,
                  color: ColorPaletteLogic.asBlackTheme().activeElementText,
                  letterSpacing: -3.0,
                  fontSize: 96
                ),
              ),
            )
    );
  }

}
