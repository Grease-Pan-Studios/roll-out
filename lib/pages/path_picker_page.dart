
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


class PathPickerPage extends StatefulWidget {

  final GameLogic gameLogic;
  final GameState gameState;
  final SettingsState settingsState;
  final HapticEngineService hapticEngine;
  final ColorPaletteLogic colorPalette;
  final AudioPlayerService audioPlayer;

  const PathPickerPage({
    super.key,
    required this.gameLogic,
    required this.gameState,
    required this.settingsState,
    required this.audioPlayer,
    required this.hapticEngine,
    required this.colorPalette,
  });

  @override
  State<PathPickerPage> createState() => _PathPickerPageState();
}

class _PathPickerPageState extends State<PathPickerPage> {

  void _onPageChanged(int index) {

    if (index < widget.gameLogic.pages.length){
      widget.colorPalette.update(
        ColorPaletteLogic.fromHue(
            widget.gameLogic.pages[index].hue,
          isDarkMode: widget.settingsState.isDarkMode,
        ),
      );
    }else{
      widget.colorPalette.update(
        ColorPaletteLogic.asMonochrome(isDarkMode: widget.settingsState.isDarkMode),
      );
    }
  }

  @override
  void initState() {
    super.initState();
    // widget.gameState.setUpdateTrigger(_triggerPageUpdate);
  }


  @override
  Widget build(BuildContext context) {
    return PageView(
      controller: PageController(
        initialPage: 0,
      ),
      onPageChanged: _onPageChanged,
      children: List<Widget>.generate(
        growable: true,
        widget.gameLogic.pages.length,
        (index) {
          final pathwayLogic = widget.gameLogic.pages[index];
          return PathPage(
            pathwayLogic: pathwayLogic,
            settingsState: widget.settingsState,
            gameState: widget.gameState,
            hapticEngine: widget.hapticEngine,
            audioPlayer: widget.audioPlayer,
            colorPalette: widget.colorPalette,
          );
        },
      ) + [ComingSoonPage(settingsState: widget.settingsState,)],

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

