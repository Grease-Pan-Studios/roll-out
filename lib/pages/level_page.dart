
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

class LevelPage extends StatefulWidget {

  final int levelIndex;
  final SectionLogic sectionLogic;

  final GameState gameState;
  final HapticEngineService hapticEngine;
  final AudioPlayerService audioPlayer;
  final ColorPaletteLogic colorPalette;

  final SettingsState settingsState;
  final StorageService storageService;

  const LevelPage({
    super.key,
    required this.levelIndex,
    required this.sectionLogic,
    required this.gameState,
    required this.colorPalette,
    required this.audioPlayer,
    required this.hapticEngine,
    required this.settingsState,
    required this.storageService,
  });

  @override
  State<LevelPage> createState() => _LevelPageState();
}

class _LevelPageState extends State<LevelPage> with SingleTickerProviderStateMixin{

  bool _removeGameObject = false;
  bool _levelComplete = false;
  int _levelRating = 0;
  String _levelCompletionTime = "00:00:00";

  late MazeLogic mazeLogic;
  late AnimationController _controller;
  late Animation<Alignment> _alignmentAnimation;
  late Animation<double> _opacityAnimation;
  late LevelCompletionCard levelCompletionCard;
  late VoidCallback? _nextLevelCallback;

  late StandardGame _game;

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

    if (widget.sectionLogic.isNextLevel(widget.levelIndex)){
      _nextLevelCallback = (){
        widget.hapticEngine.selection();
        Navigator.pushReplacement(context,
          MaterialPageRoute(builder: (context) => LevelPage(
              levelIndex: widget.levelIndex + 1,
              sectionLogic: widget.sectionLogic,
              audioPlayer: widget.audioPlayer,
              settingsState: widget.settingsState,
              hapticEngine: widget.hapticEngine,
              gameState: widget.gameState,
              colorPalette: widget.colorPalette,
              storageService: widget.storageService,
            )
          )
        );
      };
    }else{
      _nextLevelCallback = null;
    }




  }

  void initializeMazeLogic(){
    mazeLogic = widget.sectionLogic.levels[widget.levelIndex];
  }

  void initializeGameObject(){
    // print("Game Type: ${widget.sectionLogic.gameType}");
    if (widget.sectionLogic.gameType == GameType.blackBox){
      _game = BlackBoxGame(
        mazeLogic: mazeLogic,
        colorPalette: widget.colorPalette,
        hapticEngine: widget.hapticEngine,
        audioPlayer: widget.audioPlayer,
        exitGameCallback: _triggerExit,
        settingsState: widget.settingsState,
      );
    }else if(widget.sectionLogic.gameType == GameType.lookingGlass){

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

    // TODO: trigger for non-completion is incomplete
    // assert(isComplete == true, "Functionality for non-completion is incomplete.");

    /* Calculating Time */
    final int time = completionTime.inMilliseconds;
    final int minutes = (time / 60000).floor();
    final int seconds = ((time % 60000) / 1000).floor();
    final int milliseconds = ((time % 1000)/10).floor();

    _levelCompletionTime = "${minutes.toString().padLeft(2, "0")}:${
        seconds.toString().padLeft(2,"0")}:${
        milliseconds.toString().padLeft(2,"0")}";

    _levelComplete = isComplete;

    _levelRating = rating;

    _removeGameObject = true;
    if (isComplete){
      /* Update Level State In Game Logic */
      widget.gameState.setLevelState(
        sectionLogic: widget.sectionLogic,
        levelIndex: widget.levelIndex,
        levelState: LevelState(
          state: LevelStateEnum.completed,
          rating: rating,
          completionTime: completionTime,
        ),
      );

    }else{
      _levelRating = 0;
    }


    _controller.forward();
    print("Updated Rating: $rating");

    setState(() {});

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

  void _replayLevel(){
    widget.hapticEngine.selection();
    Navigator.pushReplacement(context,
      MaterialPageRoute(builder: (context) => LevelPage(
          levelIndex: widget.levelIndex,
          sectionLogic: widget.sectionLogic,
          hapticEngine: widget.hapticEngine,
          audioPlayer: widget.audioPlayer,
          gameState: widget.gameState,
          colorPalette: widget.colorPalette,
          settingsState: widget.settingsState,
          storageService: widget.storageService,
        )
      )
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
                      widget.sectionLogic.sectionName,
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
                    "Level ${widget.levelIndex + 1}",
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
                      isComplete: _levelComplete,
                      colorPalette: widget.colorPalette,
                      completionTime: _levelCompletionTime,
                      rating: _levelRating,
                      replayLevelCallback: _replayLevel,
                      exitLevelCallback: _exitLevelPage,
                      nextLevelCallback: _nextLevelCallback,
                    ),
                  )
                );
              },
              // child:

            ),
           if (!_removeGameObject)
           GameWidget( game: _game ),

          ],
        )
      
      ),
    );
  }
}
