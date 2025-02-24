
import 'package:amaze_game/services/audio_player_service.dart';
import 'package:amaze_game/services/haptic_engine_service.dart';
import 'package:flutter/material.dart';

import 'package:amaze_game/logical/page_logic.dart';
import 'package:amaze_game/logical/color_palette_logic.dart';

import 'package:amaze_game/ui_components/page_section.dart';

import 'package:amaze_game/states/game_state.dart';
import 'package:amaze_game/states/settings_state.dart';

class PathPage extends StatelessWidget {

  final PageLogic pathwayLogic;
  final GameState gameState;
  final SettingsState settingsState;
  final HapticEngineService hapticEngine;
  final AudioPlayerService audioPlayer;
  final ColorPaletteLogic colorPalette;

  const PathPage({
    super.key,
    required this.pathwayLogic,
    required this.gameState,
    required this.settingsState,
    required this.hapticEngine,
    required this.audioPlayer,
    required this.colorPalette,
  });

  @override
  Widget build(BuildContext context) {
    return Material(
      color: colorPalette.getPrimary(
        hue: pathwayLogic.hue,
        isDarkMode: settingsState.isDarkMode,
      ),
      child: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: pathwayLogic.sections.map(
                    (sectionLogic) {
                  return PageSection(
                    sectionLogic: sectionLogic,
                    audioPlayer: audioPlayer,
                    gameState: gameState,
                    settingsState: settingsState,
                    hapticEngine: hapticEngine,
                    hue: pathwayLogic.hue,
                    colorPalette: colorPalette,
                  );
                }
            ).toList()
          // [PathSection(),],
        ),
      ),
    );
  }
}