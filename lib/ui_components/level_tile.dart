
import 'package:amaze_game/logical/color_palette_logic.dart';
import 'package:amaze_game/logical/maze_logic.dart';
import 'package:amaze_game/logical/section_logic.dart';

import 'package:amaze_game/pages/level_page.dart';
import 'package:amaze_game/services/audio_player_service.dart';
import 'package:amaze_game/services/haptic_engine_service.dart';
import 'package:amaze_game/services/storage_service.dart';
import 'package:amaze_game/states/settings_state.dart';
import 'package:flutter/material.dart';

import 'package:amaze_game/states/level_state.dart';
import 'package:amaze_game/states/game_state.dart';

class LevelTile extends StatelessWidget {

  int levelIndex;
  double hue;

  LevelState levelState;
  GameState gameState;
  SettingsState settingsState;
  HapticEngineService hapticEngine;
  AudioPlayerService audioPlayer;

  SectionLogic sectionLogic;
  ColorPaletteLogic colorPalette;
  StorageService storageService;

  late Color bgColor;
  late Color borderColor;
  late Color textColor;

  late AssetImage filledStar;
  late AssetImage emptyStar;

  LevelTile({
    super.key,
    required this.gameState,
    required this.settingsState,
    required this.storageService,
    required this.hapticEngine,
    required this.audioPlayer,
    required this.sectionLogic,
    required this.hue,
    required this.colorPalette,
    required this.levelIndex,
    required this.levelState,
    // this.rating = -1,
    // this.state = LevelCompletionState.locked,
  }){

    assert(levelIndex >= 0, 'Level Index must be valid');
    // assert(hue >= 0 && hue <= 360, 'Hue must be between 0 and 360');

    if (levelState.state == LevelStateEnum.locked){
      bgColor = colorPalette.getInactiveElementBackground(
        hue: hue, isDarkMode: settingsState.isDarkMode,
      );
      borderColor = colorPalette.getInactiveElementBorder(
        hue: hue, isDarkMode: settingsState.isDarkMode,
      );
      textColor = colorPalette.getInactiveElementText(
        hue: hue, isDarkMode: settingsState.isDarkMode,
      );
    }else{
      bgColor = colorPalette.getActiveElementBackground(
        hue: hue, isDarkMode: settingsState.isDarkMode,
      );
      borderColor = colorPalette.getActiveElementBorder(
        hue: hue, isDarkMode: settingsState.isDarkMode,
      );
      textColor = colorPalette.getActiveElementText(
        hue: hue, isDarkMode: settingsState.isDarkMode,
      );
    }

    filledStar = AssetImage('assets/images/ui_elements/star_fill.png');
    emptyStar = AssetImage('assets/images/ui_elements/star_outline_small.png');

  }

  @override
  Widget build(BuildContext context) {
    return TextButton(
        style: ButtonStyle(
          enableFeedback: true,
          backgroundColor: WidgetStateProperty.all<Color>(bgColor),
          minimumSize: WidgetStateProperty.all<Size>(Size(58, 63)),
          overlayColor: WidgetStateProperty.all<Color>(textColor.withAlpha(50)),
          shape: WidgetStateProperty.all<RoundedRectangleBorder>(
            RoundedRectangleBorder(
              side: BorderSide(
                color: borderColor,
                width: 3.0,
                strokeAlign: BorderSide.strokeAlignCenter
              ),
              borderRadius: BorderRadius.circular(10.0),
            ),
          ),
        ),
        onPressed: () {

          if (levelState.state == LevelStateEnum.locked){
            return;
          }

          hapticEngine.selection();

          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => LevelPage(
              levelIndex: levelIndex,
              sectionLogic: sectionLogic,
              gameState: gameState,
              hapticEngine: hapticEngine,
              audioPlayer: audioPlayer,
              colorPalette: colorPalette,
              storageService: storageService,
              settingsState: settingsState,
            )),
          );

        },
        child: Column(
          mainAxisSize: MainAxisSize.min,
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,

          children: [
            Text(
                (levelIndex+1).toString(),
                style: TextStyle(
                  fontFamily: 'Advent',
                  fontWeight: FontWeight.w600,
                  color: textColor,
                  height: 1,
                  fontSize: 32,
                  letterSpacing: -0.96,
                )
            ),

            if (levelState.isCompleted())
              FittedBox(
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    ImageIcon(
                      levelState.rating >= 1 ? filledStar : emptyStar,
                      size: 12,
                      color: borderColor,
                    ),
                    ImageIcon(
                      levelState.rating >= 2 ? filledStar : emptyStar,
                      size: 12,
                      color: borderColor,
                    ),
                    ImageIcon(
                      levelState.rating >= 3 ? filledStar : emptyStar,
                      size: 12,
                      color: borderColor,
                    ),
                  ],
                ),
              ),

          ],
        )

      // ),
    );
  }

}



/*
* Dep
*
* // if (state == LevelTileState.completed)
        //   Align(
        //       alignment: Alignment.bottomRight,
        //       child: ImageIcon(
        //         AssetImage('assets/images/ui_elements/rr_tick.png'),
        //         size: 20,
        //         color: borderColor,
        //       )
        //   ),
        *
        * if (levelState.isCompleted())
        Align(
          alignment: Alignment(0.26,-0.76),
          child: Transform.rotate(
            angle: pi/3.5,
            child: ImageIcon(
              levelState.rating >= 1 ? filledStar : emptyStar,
              size: 12,
              color: borderColor,
            ),
          ),
        ),
        if (levelState.isCompleted())
        Align(
          alignment: Alignment(0.75,-0.3),
          child: Transform.rotate(
            angle: pi/5,
            child: ImageIcon(
              levelState.rating >= 3 ? filledStar : emptyStar,
              size: 12,
              color: borderColor,
            ),
          ),
        ),
*
*
*
* */