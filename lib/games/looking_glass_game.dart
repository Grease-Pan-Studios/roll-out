


import 'package:amaze_game/games/standard_game.dart';

import 'package:amaze_game/mazes/looking_glass_maze.dart';


class LookingGlassGame extends StandardGame{

  LookingGlassGame({
    required super.mazeLogic,
    required super.colorPalette,
    required super.exitGameCallback,
    required super.hapticEngine,
    required super.audioPlayer
  });


  @override
  void initializeMaze() {
    maze = LookingGlassMaze(
        mazeLogic: mazeLogic,
        audioPlayer: audioPlayer,
        hapticEngine: hapticEngine,
        controller: controller,
        colorPalette: colorPalette,
        levelCompletionCallback: triggerGameCompletion
    );
  }

  @override
  String getTime(){
    return "LOOKING GLASS";
  }

}