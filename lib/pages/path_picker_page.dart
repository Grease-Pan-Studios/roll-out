
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

import 'package:amaze_game/states/game_state.dart';

import 'package:amaze_game/services/storage_service.dart';

class PathPickerPage extends StatefulWidget {

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
  });

  @override
  State<PathPickerPage> createState() => _PathPickerPageState();
}

class _PathPickerPageState extends State<PathPickerPage> {


  late List<Widget> _paths;

  final bool unlockAllPaths = true;

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
  Widget build(BuildContext context) {
    _buildPages();
    return PageView(
      controller: PageController(
        initialPage: 0,
      ),
      onPageChanged: _onPageChanged,
      children: _paths,

    );
    //   Material(
    //     color: Color(0xffBDE0FE),
    //     child: Padding(
    //       padding: const EdgeInsets.all(20.0),
    //       child: Column(
    //         mainAxisAlignment: MainAxisAlignment.start,
    //         crossAxisAlignment: CrossAxisAlignment.start,
    //         children: gameLogic.pathways[0].sections.map(
    //             (SectionLogic) {
    //               return PathSection(
    //                 sectionLogic: SectionLogic,
    //               );
    //             }
    //         ).toList()
    //         // [PathSection(),],
    //       ),
    //     ),
    // );
  }
}

