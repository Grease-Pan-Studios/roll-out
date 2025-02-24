
import 'package:amaze_game/services/haptic_engine_service.dart';
import 'package:amaze_game/services/audio_player_service.dart';
import 'package:amaze_game/services/storage_service.dart';
import 'package:amaze_game/states/settings_state.dart';
import 'package:flutter/material.dart';

import 'package:amaze_game/logical/color_palette_logic.dart';
import 'package:amaze_game/logical/section_logic.dart';

import 'package:amaze_game/ui_components/level_tile.dart';

import 'package:amaze_game/states/level_state.dart';
import 'package:amaze_game/states/game_state.dart';

class PageSection extends StatelessWidget {

  final double hue;
  final GameState gameState;
  final SettingsState settingsState;
  final StorageService storageService;
  final SectionLogic sectionLogic;
  final ColorPaletteLogic colorPalette;
  final HapticEngineService hapticEngine;
  final AudioPlayerService audioPlayer;

  const PageSection({
    super.key,
    required this.hue,
    required this.gameState,
    required this.settingsState,
    required this.storageService,
    required this.sectionLogic,
    required this.hapticEngine,
    required this.audioPlayer,
    required this.colorPalette,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 20.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          Text(
            sectionLogic.sectionName,
            style: TextStyle(
              fontFamily: 'Advent',
              color: colorPalette.activeElementText,
              fontSize: 32,
              fontWeight: FontWeight.w600,
              letterSpacing: -0.96,
            ),
          ),
          SizedBox(height: 10),
          GridView.count(
              crossAxisCount: 5,
              shrinkWrap: true,
              childAspectRatio: 0.92,
              mainAxisSpacing: 15,
              crossAxisSpacing: 15,
              physics: NeverScrollableScrollPhysics(),
              // mainAxisAlignment: MainAxisAlignment.spaceBetween,
              // crossAxisAlignment: CrossAxisAlignment.start,
              children: List.generate(
                sectionLogic.levels.length,
                    (index) {
                  final mazeLogic = sectionLogic.levels[index];
                  return LevelTile(
                    hue: hue,
                    gameState: gameState,
                    settingsState: settingsState,
                    hapticEngine: hapticEngine,
                    audioPlayer: audioPlayer,
                    sectionLogic: sectionLogic,
                    mazeLogic: mazeLogic,
                    levelIndex: index,
                    colorPalette: colorPalette,
                    storageService: storageService,
                    levelState: gameState.getLevelState(
                      sectionLogic: sectionLogic,
                      levelIndex: index,
                    ),
                  );
                },
              ),

              // [
                // Generate 25 LevelTiles


                // LevelTile(
                //   levelNumber: 1,
                //   state: LevelTileState.completed,
                // ),
                // for (int i = 1; i <= 3; i++)
                //   LevelTile(
                //     levelNumber: i + 1,
                //     state: LevelTileState.unlocked,
                //   ),
                // for (int i = 0; i < 2; i++)
                //   LevelTile(
                //     levelNumber: i + 5,
                //     state: LevelTileState.locked,
                //   ),
              // ]
          )
        ],
      ),
    );
  }
}
