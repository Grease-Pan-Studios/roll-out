
import 'package:amaze_game/mazes/standard_maze.dart';

import 'package:amaze_game/game_components/visible_region_component.dart';



class BlackBoxMaze extends StandardMaze {


  // late PeepHoleComponent peepHole;
  late VisibleRegionComponent peepHole;

  BlackBoxMaze({
    required super.mazeLogic,
    required super.audioPlayer,
    required super.hapticEngine,
    required super.controller,
    required super.colorPalette,
    required super.levelCompletionCallback
  });

  @override
  Future<void> onLoad() async {

    super.onLoad();

    peepHole = PeepHoleComponent(
      radius: mazeLogic.cellSize * 1.5,
      regionPadding: mazeLogic.cellSize * 0.5,
      numberOfRays: 500,
      colorPalette: colorPalette
    );
    add(peepHole);
  }


}
