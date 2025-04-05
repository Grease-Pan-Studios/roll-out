
import 'package:amaze_game/states/game_type_state.dart';
import 'package:amaze_game/states/settings_state.dart';
import 'package:amaze_game/ui_components/level_appbar.dart';
import 'package:flutter/material.dart';

import 'package:amaze_game/pages/unlimited_page.dart';
import 'package:amaze_game/logical/color_palette_logic.dart';

import 'package:amaze_game/states/game_state.dart';

import 'package:amaze_game/services/storage_service.dart';
import 'package:amaze_game/services/audio_player_service.dart';
import 'package:amaze_game/services/haptic_engine_service.dart';

class UnlimitedCard extends StatefulWidget {

  final double hue;
  final GameType gameType;

  final ColorPaletteLogic colorPalette;
  late ColorPaletteLogic cardPalette;

  final GameState gameState;
  final SettingsState settingsState;

  final StorageService storageService;
  final AudioPlayerService audioPlayer;
  final HapticEngineService hapticEngine;


  UnlimitedCard({
    super.key,
    required this.hue,
    required this.gameType,
    required this.gameState,
    required this.audioPlayer,
    required this.colorPalette,
    required this.hapticEngine,
    required this.storageService,
    required this.settingsState,
  }){
    cardPalette = ColorPaletteLogic.fromHue(
      hue, isDarkMode: settingsState.isDarkMode
    );
  }

  @override
  State<UnlimitedCard> createState() => _UnlimitedCardState();
}

class _UnlimitedCardState extends State<UnlimitedCard> {
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(top: 15, bottom: 25.0),
      child: MaterialButton(
        onPressed: () {

          widget.hapticEngine.selection();

          /*Calculate Screen Ratio */
          double effectiveHeight = MediaQuery.of(context).size.height
               - LevelAppBar.appBarHeight - 100;
          double screenRatio = effectiveHeight / MediaQuery.of(context).size.width;
          print("Screen Ratio: $screenRatio");
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => UnlimitedPage(
              gameType: widget.gameType,
              gameState: widget.gameState,
              screenRatio: screenRatio,
              hapticEngine: widget.hapticEngine,
              audioPlayer: widget.audioPlayer,
              colorPalette: widget.colorPalette,
              storageService: widget.storageService,
              settingsState: widget.settingsState,
            )),
          ).whenComplete((){
            setState(() {});
          });

        },
        color: widget.cardPalette.activeElementBackground,
        shape: RoundedRectangleBorder(
          side: BorderSide(
            color: widget.cardPalette.activeElementText,
            strokeAlign: BorderSide.strokeAlignInside,
            width: 3,
          ),
          borderRadius: BorderRadius.circular(15),
        ),
        padding: EdgeInsets.zero,
        elevation: 0,
        child: SizedBox(
          height: 100,
          width: double.infinity,
          child: Stack(
            children: [
              Align(
                alignment: Alignment.centerLeft,
                child: Padding(
                  padding: const EdgeInsets.only(left: 15.0),
                  child:  Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        "Unlimited",
                        style: TextStyle(
                          fontSize: 32,
                          fontWeight: FontWeight.bold,
                          fontFamily: "Advent",
                          color: widget.cardPalette.activeElementText,
                          letterSpacing: -1.2,
                          height: 1,
                        ),
                      ),
                      Text.rich(
                        style: TextStyle(
                          fontFamily: "Advent",
                          color: widget.cardPalette.activeElementText,
                          fontSize: 20,
                          letterSpacing: -1.2,
                          height: 1,
                        ),
                        TextSpan(
                          children: [
                            TextSpan(
                              text: "High Score ",
                              style: TextStyle(
                                fontWeight: FontWeight.w600,
                                letterSpacing: -1,

                              ),
                            ),
                            TextSpan(
                              text: "${widget.gameState.getUnlimitedHighScore(levelKey: widget.gameType.name)}",
                              style: TextStyle(
                                fontWeight: FontWeight.bold,
                                letterSpacing: -1,
                              ),
                            ),
                          ]
                        )
                      ),
                    ],
                  ),
                ),
              ),
              Align(
                alignment: Alignment.topRight,
                child: Image.asset(
                  "assets/images/infinity.png",
                  alignment: Alignment.topRight,
                  height: 150,
                  width: 240,
                )
              ),
              /*Align(
                alignment: Alignment(1, 1.2),
                child: IconButton(
                  onPressed: () {},
                  icon: ImageIcon(
                    AssetImage("assets/images/ui_elements/trophy.png"),
                    size: 24,
                    color: cardPalette.activeElementText,
                  )
                ),
              )*/
            ],

          ),
        ),
      ),
    );
  }
}
