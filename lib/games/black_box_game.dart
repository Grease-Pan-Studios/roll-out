

import 'package:amaze_game/games/standard_game.dart';

import 'package:amaze_game/mazes/black_box_maze.dart';


class BlackBoxGame extends StandardGame{

  BlackBoxGame({
    required super.mazeLogic,
    required super.colorPalette,
    required super.exitGameCallback,
    required super.hapticEngine,
    required super.audioPlayer
  });


  @override @override
  void initializeMaze() {
    maze = BlackBoxMaze(
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
    return "DARK MODE";
  }

}