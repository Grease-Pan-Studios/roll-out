
import 'dart:math';

import 'package:amaze_game/generation/maze_generator.dart';
import 'package:amaze_game/logical/maze_logic.dart';
import 'package:amaze_game/logical/color_palette_logic.dart';
import 'package:amaze_game/logical/section_logic.dart';

import 'package:amaze_game/services/haptic_engine_service.dart';
import 'package:amaze_game/services/audio_player_service.dart';
import 'package:amaze_game/services/storage_service.dart';

import 'package:amaze_game/states/game_state.dart';
import 'package:amaze_game/states/level_state.dart';
import 'package:amaze_game/states/settings_state.dart';
import 'package:amaze_game/states/game_type_state.dart';

import 'package:amaze_game/ui_components/level_completion_card.dart';
import 'package:amaze_game/ui_components/settings_card.dart';
import 'package:flutter/material.dart';
import 'package:flame/game.dart';

import 'package:amaze_game/games/standard_game.dart';
import 'package:amaze_game/games/black_box_game.dart';
import 'package:amaze_game/games/looking_glass_game.dart';

class UnlimitedPage extends StatefulWidget {


  final double screenRatio;

  final HapticEngineService hapticEngine;
  final AudioPlayerService audioPlayer;
  final ColorPaletteLogic colorPalette;

  final SettingsState settingsState;
  final StorageService storageService;

  final GameType gameType;

  const UnlimitedPage({
    super.key,
    required this.gameType,
    required this.screenRatio,
    required this.colorPalette,
    required this.audioPlayer,
    required this.hapticEngine,
    required this.settingsState,
    required this.storageService,
  });

  @override
  State<UnlimitedPage> createState() => _LevelPageState();
}

class _LevelPageState extends State<UnlimitedPage> with SingleTickerProviderStateMixin{


  bool _levelComplete = false;
  int _levelRating = 0;
  String _levelCompletionTime = "00:00:00";

  int _levelNumber = 1;

  late MazeLogic mazeLogic;
  late AnimationController _controller;
  late Animation<Alignment> _alignmentAnimation;
  late Animation<double> _opacityAnimation;
  late LevelCompletionCard levelCompletionCard;
  late StandardGame _game;


  void showCompletionCard(int rating, Duration completionTime){

    /* Calculating Time */
    final int time = completionTime.inMilliseconds;
    final int minutes = (time / 60000).floor();
    final int seconds = ((time % 60000) / 1000).floor();
    final int milliseconds = ((time % 1000)/10).floor();

    _levelCompletionTime = "${minutes.toString().padLeft(2, "0")}:${
        seconds.toString().padLeft(2,"0")}:${
        milliseconds.toString().padLeft(2,"0")}";

    _levelRating = rating;

    _controller.forward();
    setState(() {});

  }

  void hideCompletionCard(){
    _controller.reverse();
    setState(() {});
  }

  void initializeMazeLogic(){

    /* Need to determine size */
    final double levelNumber = _levelNumber.toDouble();
    double widthHeuristic = max(4, pow(2 * levelNumber, 0.5).toDouble() + 3);

    double heightHeuristic = max(widthHeuristic * widget.screenRatio, 4);

    int sizeX = widthHeuristic.floor();
    int sizeY = heightHeuristic.floor();


    /* TODO Need to determine difficulty 0 to 1 */

    /* TODO Need to determine ball restitution 0.5 to 0.9 */

    /* TODO Need to determine star thresholds */
    mazeLogic = MazeGenerator.getMaze(
      sizeX, sizeY,
      ballRestitution: 0.5,
      threeStarThreshold: Duration(seconds: 15),
      twoStarThreshold: Duration(seconds: 30),
      oneStarThreshold: Duration(seconds: 60),
    );

  }

  void initializeGameObject(){

    if (widget.gameType == GameType.blackBox){
      _game = BlackBoxGame(
        mazeLogic: mazeLogic,
        colorPalette: widget.colorPalette,
        hapticEngine: widget.hapticEngine,
        audioPlayer: widget.audioPlayer,
        exitGameCallback: _triggerExit,
        settingsState: widget.settingsState,
      );
    }else if(widget.gameType == GameType.lookingGlass){
      _game = LookingGlassGame(
        mazeLogic: mazeLogic,
        colorPalette: widget.colorPalette,
        hapticEngine: widget.hapticEngine,
        audioPlayer: widget.audioPlayer,
        exitGameCallback: _triggerExit,
        settingsState: widget.settingsState,
      );

    }else{
      _game = StandardGame(
        mazeLogic: mazeLogic,
        colorPalette: widget.colorPalette,
        hapticEngine: widget.hapticEngine,
        audioPlayer: widget.audioPlayer,
        exitGameCallback: _triggerExit,
        settingsState: widget.settingsState,
      );
    }
  }

  void nextLevel(){
    _levelNumber++;
    initializeMazeLogic();
    initializeGameObject();
    hideCompletionCard();
    _levelComplete = false;
    setState(() {});
  }

  @override
  void initState(){

    super.initState();

    initializeMazeLogic();

    initializeGameObject();

    _controller = AnimationController(
      duration: Duration(seconds: 1),
      vsync: this,
    );

    _alignmentAnimation = Tween<Alignment>(
      begin: Alignment(0, 4),
      end: Alignment(0, -0.25),
    ).animate(
      CurvedAnimation(
        parent: _controller,
        curve: Curves.easeOut,
      ),
    );

    _opacityAnimation = Tween<double>(
      begin: 0.0,
      end: 1.0,
    ).animate(
      CurvedAnimation(
        parent: _controller,
        curve: Curves.easeOut,
      ),
    );

  }

  @override
  void dispose(){
    _controller.dispose();
    super.dispose();
  }

  void _triggerExit({
    required bool isComplete,
    required int rating,
    required Duration completionTime,
  }){

    //TODO: trigger for non-completion is incomplete
    assert(isComplete == true, "Functionality for non-completion is incomplete.");

    _levelComplete = true;

    showCompletionCard(rating, completionTime);

  }

  void _exitLevelPage(){
    widget.hapticEngine.selection();
    Navigator.pop(context);
  }

  void _openSettingsPanel() {
    widget.hapticEngine.selection();
    _game.pauseGame();
    SettingsCard.open(
      context,
      widget.colorPalette,
      widget.settingsState,
      widget.storageService,
      widget.hapticEngine,
      onExit: (){
        _game.resumeGame();
      }
    );

  }


  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        backgroundColor: widget.colorPalette.getDarkPrimary(),
        appBar: AppBar(
          toolbarHeight: 120,
          backgroundColor: widget.colorPalette.getDarkPrimary(),
          automaticallyImplyLeading: false,
          centerTitle: true,
          title: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                SizedBox(height: 20),
                FittedBox(
                  child: Text(
                      "Unlimited",
                      style: TextStyle(
                        fontFamily: 'Advent',
                        color: widget.colorPalette.activeElementText,
                        fontSize: 40,
                        fontWeight: FontWeight.w600,
                        letterSpacing: -1.2,
                      )
                  ),
                ),
                Text(
                    "Level $_levelNumber",
                    style: TextStyle(
                      fontFamily: 'Advent',
                      color: widget.colorPalette.activeElementText,
                      fontSize: 20,
                      fontWeight: FontWeight.w600,
                      letterSpacing: -0.6,
                    )
                )
              ]
          ),
          leadingWidth: 75,
          leading: Padding(
            padding: const EdgeInsets.only(left: 20.0, top: 33.0, bottom: 33.0),
            child: IconButton(
              alignment: Alignment.centerLeft,
              icon: ImageIcon(
                AssetImage("assets/images/ui_elements/back_icon.png"),
                size: 45,
                color: widget.colorPalette.activeElementBorder,
              ), onPressed:_exitLevelPage,
            ),
          ),

          actions: [
            Padding(
              padding: const EdgeInsets.only(right: 20.0),
              child: IconButton(
                alignment: Alignment.topRight,
                icon: ImageIcon(
                  AssetImage("assets/images/ui_elements/gear_icon.png"),
                  size: 45,
                  color: widget.colorPalette.activeElementBorder,
                  semanticLabel: "Settings",
                ), onPressed: _openSettingsPanel,

              ),
            )
          ],
          // foregroundColor: Colors.transparent,
        ),

        body: Stack(
          children: [
            AnimatedBuilder(
              animation: _controller,
              builder: (context, child) {
                return Align(
                  alignment: _alignmentAnimation.value,
                  child: Opacity(
                    opacity: _opacityAnimation.value,
                    child: LevelCompletionCard(
                      colorPalette: widget.colorPalette,
                      completionTime: _levelCompletionTime,
                      rating: _levelRating,
                      exitLevelCallback: _exitLevelPage,
                      nextLevelCallback: nextLevel,
                    ),
                  )
                );
              },
              // child:
            ),
           if (_levelComplete == false)
           GameWidget( game: _game ),

          ],
        )
      
      ),
    );
  }
}
