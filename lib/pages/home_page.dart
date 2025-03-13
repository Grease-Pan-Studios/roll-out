
import 'package:amaze_game/logical/game_logic.dart';
import 'package:amaze_game/services/storage_service.dart';
import 'package:amaze_game/states/settings_state.dart';
import 'package:amaze_game/ui_components/settings_card.dart';
import 'package:flutter/material.dart';
import 'package:sliding_up_panel/sliding_up_panel.dart';

import 'package:amaze_game/pages/path_picker_page.dart';
import 'package:amaze_game/logical/color_palette_logic.dart';
import 'package:amaze_game/states/game_state.dart';

import 'package:amaze_game/services/haptic_engine_service.dart';
import 'package:amaze_game/services/audio_player_service.dart';

class HomePage extends StatefulWidget {

  final GameLogic gameLogic;
  final GameState gameState;
  final SettingsState settingsState;
  final HapticEngineService hapticEngine;
  final AudioPlayerService audioPlayer;
  final ColorPaletteLogic colorPalette;
  final StorageService storageService;

  const HomePage({
    super.key,
    required this.gameLogic,
    required this.gameState,
    required this.settingsState,
    required this.hapticEngine,
    required this.audioPlayer,
    required this.colorPalette,
    required this.storageService,
  });

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {

  final PanelController _panelController = PanelController();
  late int _pageBuildCount;

  double _panelSlide = 0.0;


  void _updateHomePage(){
    setState(() {
      widget.colorPalette.setUpdateTrigger(_updateHomePage);
      widget.gameState.setUpdateTrigger(_updateHomePage);
    });
  }


  void _openSettings(){
    widget.hapticEngine.selection();
    SettingsCard.open(
      context,
      widget.colorPalette,
      widget.settingsState,
      widget.storageService,
      widget.hapticEngine,
      onExit: () {},
    );
  }

  void _onPanelOpen(){

    setState(() {
      if (_pageBuildCount == 0){
        _pageBuildCount = 1;
      }else{
        _pageBuildCount = 2;
      }
    });

  }


  @override
  void initState() {
    super.initState();
    _pageBuildCount = 0;
    widget.colorPalette.setUpdateTrigger(_updateHomePage);
    widget.gameState.setUpdateTrigger(_updateHomePage);
  }


  @override
  Widget build(BuildContext context) {
    return SlidingUpPanel(

      onPanelOpened: _onPanelOpen,

      color: widget.colorPalette.secondary,
      parallaxOffset: 0,
      panel: PathPickerPage(
        gameLogic: widget.gameLogic,
        gameState: widget.gameState,
        settingsState: widget.settingsState,
        storageService: widget.storageService,
        hapticEngine: widget.hapticEngine,
        audioPlayer: widget.audioPlayer,
        colorPalette: widget.colorPalette,
        shouldShowIndicator: _pageBuildCount == 1,
      ),

      collapsed: Material(

        color: widget.colorPalette.secondary,

        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [

            Text(
              "Swipe Up To Start",
              style: TextStyle(
                color: widget.colorPalette.activeElementText,//Color(0xFF253237),
                fontSize: 20,
                fontWeight: FontWeight.w600,
                letterSpacing: -0.6,
              ),
            ),
            ImageIcon(
              AssetImage("assets/images/ui_elements/pull_up.png"),
              size: 45,
              color: widget.colorPalette.activeElementText, //Color(0xFF253237),
            ),
            SizedBox(height: 20),
          ],
        ),
      ),

      body: Material(
        color: widget.colorPalette.secondary,
        child: Stack(
          children: [

            Align(
              alignment:
              Alignment.lerp(
                  Alignment(-0.1, -0.1), // Center
                  Alignment(-0.9, -1), // TopLeft
                  _panelSlide)!
                  .add(Alignment(0, 0.0)),
              child: Text(
                "Roll Out",
                style: TextStyle(
                  fontFamily: "Advent",
                  fontWeight: FontWeight.w700,
                  color: widget.colorPalette.activeElementText,
                  letterSpacing: -3.0,
                  fontSize: 48 + (96 - 50) * (1-_panelSlide),
                ),
              ),
            ),

            GestureDetector(
              behavior: HitTestBehavior.opaque,
              onTap: (){
                _panelController.close();
              },
              onVerticalDragUpdate: (details){

                if (details.primaryDelta == null) return;

                if (details.primaryDelta! < -5){
                  _panelController.open();
                }

              },
            ),

            /* Settings Button */
            Align(
              alignment: Alignment.topRight.add(Alignment(0, 0.01)),
              child: TextButton(
                style: ButtonStyle(
                  overlayColor: WidgetStateProperty.all<Color>(
                      widget.colorPalette.activeElementText.withAlpha(20)
                  ),
                  enableFeedback: true,
                ),

                onPressed: _openSettings,
                child: ImageIcon(
                  AssetImage("assets/images/ui_elements/gear_icon.png"),
                  size: 45,
                  color: widget.colorPalette.activeElementText,
                  semanticLabel: "Settings",
                ),
              ),
            )

          ],
        ),
      ),

      minHeight: 100.0,  // Height of the collapsed panel
      maxHeight: MediaQuery.of(context).size.height - 95,
      controller: _panelController,
      boxShadow: [],
      onPanelSlide: (double pos) {
        setState(() {
          _panelSlide = pos;
        });
      },
    );
  }
}
