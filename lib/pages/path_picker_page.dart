
/* Flutter Libraries */
import 'package:amaze_game/services/audio_player_service.dart';
import 'package:amaze_game/services/haptic_engine_service.dart';
import 'package:amaze_game/states/settings_state.dart';
import 'package:flutter/material.dart';

/* My Packages */
import 'package:amaze_game/logical/color_palette_logic.dart';
import 'package:amaze_game/logical/game_logic.dart';

import 'package:amaze_game/pages/coming_soon_page.dart';
import 'package:amaze_game/pages/path_page.dart';
import 'package:amaze_game/ui_overlays/indicator_tag.dart';

import 'package:amaze_game/states/game_state.dart';

import 'package:amaze_game/services/storage_service.dart';


class PathPickerPage extends StatefulWidget {

  final bool shouldShowIndicator;
  final GameLogic gameLogic;
  final GameState gameState;
  final SettingsState settingsState;
  final HapticEngineService hapticEngine;
  final ColorPaletteLogic colorPalette;
  final AudioPlayerService audioPlayer;
  final StorageService storageService;

  const PathPickerPage({
    super.key,
    required this.gameLogic,
    required this.gameState,
    required this.settingsState,
    required this.audioPlayer,
    required this.hapticEngine,
    required this.colorPalette,
    required this.storageService,
    required this.shouldShowIndicator,
  });

  @override
  State<PathPickerPage> createState() => _PathPickerPageState();
}

class _PathPickerPageState extends State<PathPickerPage> {


  late List<Widget> _paths;

  final bool unlockAllPaths = true;

  final GlobalKey<IndicatorTagState> indicatorKey = GlobalKey<IndicatorTagState>();

  void _onPageChanged(int index) {
    if (index + 1 == _paths.length){
      widget.colorPalette.update(
        ColorPaletteLogic.asMonochrome(isDarkMode: widget.settingsState.isDarkMode),
      );
    }else{
      widget.colorPalette.update(
        ColorPaletteLogic.fromHue(
          widget.gameLogic.pages[index].hue,
          isDarkMode: widget.settingsState.isDarkMode,
        ),
      );
    }
  }

  List<Widget> _unlockedPaths(){

    List<Widget> unlockedPaths = [];

    for (int i = 0; i < widget.gameLogic.pages.length; i++){
      unlockedPaths.add(
          PathPage(
            pathwayLogic: widget.gameLogic.pages[i],
            storageService: widget.storageService,
            settingsState: widget.settingsState,
            gameState: widget.gameState,
            hapticEngine: widget.hapticEngine,
            audioPlayer: widget.audioPlayer,
            colorPalette: widget.colorPalette,
          )
      );

      if (!unlockAllPaths && !widget.gameState.isPageCompleted(
          pageLogic: widget.gameLogic.pages[i])){
        break;
      }
    }

    return unlockedPaths;

  }


  void _buildPages(){
    _paths = _unlockedPaths();
    _paths.add(ComingSoonPage(settingsState: widget.settingsState,));
  }

  @override
  void didUpdateWidget(covariant PathPickerPage oldWidget) {
    super.didUpdateWidget(oldWidget);
    _buildPages();
    if (widget.shouldShowIndicator && !oldWidget.shouldShowIndicator){
      displayIndicator();
    }

  }

  @override
  void initState(){
    super.initState();
    _buildPages();
  }

  void displayIndicator(){
    /*Show after 5 seconds */
    Future.delayed(Duration(milliseconds: 400), (){
      indicatorKey.currentState?.show();

      /*Hide after 10 seconds */
      Future.delayed(Duration(seconds: 5), (){
        indicatorKey.currentState?.hide();
      });

    });
  }



  @override
  Widget build(BuildContext context) {
    // _buildPages(); // Need to call each time for Color Updates
    return Material(
      color: widget.colorPalette.secondary,
      child: Stack(
        children: [
          PageView(
            controller: PageController(
              initialPage: 0,
            ),
            onPageChanged: _onPageChanged,
            children: _paths,
      
          ),
          // moreModesIndicator
          IndicatorTag(
            key: indicatorKey,
            colorPalette: widget.colorPalette,
          )
        ],
      ),
    );

  }
}

