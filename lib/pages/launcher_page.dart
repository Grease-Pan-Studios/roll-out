
import 'package:amaze_game/logical/user_logic.dart';
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

  bool _showLogin = false; // true
  bool _hasLoaded = false;

  late UserLogic userLogic;

  late GameLogic gameLogic;
  late GameState gameState;
  late SettingsState settingsState;
  late ColorPaletteLogic colorPalette;
  late HapticEngineService hapticEngine;
  late AudioPlayerService audioPlayer;
  late StorageService storageService;

  void _updateLauncherPage(){
    setState((){
      userLogic.setUpdateTrigger(_updateLauncherPage);
    });
  }

  void _loadGame() async {

    userLogic = UserLogic();
    // await userLogic.initialize();
    // userLogic.setUpdateTrigger(_updateLauncherPage);

    /* Initialize the storage service */
    storageService = StorageService();
    await storageService.initialize();

    /* Initialize the game logic */
    gameLogic = GameLogic();
    gameLogic.fetchGameLogic();

    /* Initialize the game state */
    gameState = GameState(
      storageService: storageService
    );
    await gameState.initialize();

    /* Initialize the settings state */
    settingsState = storageService.getSettingsState();

    /* Initialize the audio player */
    audioPlayer = AudioPlayerService(
      sfxAssets:["assets/audio/sfx/tap-dull-1.wav"],
      settingsState: settingsState
    );
    await audioPlayer.initialize();

    /* Initialize the haptic engine */
    hapticEngine = HapticEngineService(
        settingsState: settingsState
    );
    await hapticEngine.initialize();

    colorPalette = ColorPaletteLogic.fromHue(
        208, isDarkMode: settingsState.isDarkMode
    );

    setState(()=> _hasLoaded = true);

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
          (!_showLogin || userLogic.isLoggedIn()) ? HomePage(
              gameLogic: gameLogic,
              gameState: gameState,
              settingsState: settingsState,
              hapticEngine: hapticEngine,
              audioPlayer: audioPlayer,
              colorPalette: colorPalette,
              storageService: storageService,
          ) :LoginPage(
            colorPalette: colorPalette,
            userLogic: userLogic,
            goToGame: () {
              setState(() {
                _showLogin = false;
              });
            },
          ) : Material(
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
