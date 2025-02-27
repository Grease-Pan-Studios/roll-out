

import 'package:amaze_game/mazes/standard_maze.dart';
import 'package:flame/components.dart';
import 'package:flutter/material.dart';

import 'package:amaze_game/games/standard_game.dart';

class PeepHoleComponent extends PositionComponent with HasGameRef<StandardGame>{
  
  final Color color;
  
  PeepHoleComponent({
    required this.color,
  });
  
  @override
  void render(Canvas canvas) {
    super.render(canvas);

    Path rectangle = Path()..addRect(
      Rect.fromLTWH(0, 0, game.maze.size.x, game.maze.size.y)
    );


    Path peepHole = Path()..addOval(
      Rect.fromCircle(
        center: Offset(game.maze.ballComponent.position.x, game.maze.ballComponent.position.y),
        radius: game.mazeLogic.cellSize * 1.4,
      )
    );

    // canvas.drawPath(
    //   Path.combine(
    //     PathOperation.difference,
    //     rectangle, peepHole
    //   )
    //   , Paint()..color = color
    //     // Colors.red.withAlpha(100)
    // );


    // canvas.drawRect(
    //   Rect.fromLTWH(0, 0, game.maze.size.x, game.maze.size.y),
    //   Paint()..color = Colors.red.withAlpha(100),
    // );
    // canvas.drawCircle(
    //   Offset(game.maze.ballComponent.position.x, game.maze.ballComponent.position.y),
    //   game.mazeLogic.cellSize,
    //   Paint()..color = Colors.red.withAlpha(100),
    // );


  }
  
  
}


class BlackBoxMaze extends StandardMaze {


  late PeepHoleComponent peepHole;

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

    peepHole = PeepHoleComponent(color: colorPalette.getLightPrimary());
    add(peepHole);
  }




  // @override
  // void render(Canvas canvas) {
  //   super.render(canvas);
  //
  //   double padding = mazeLogic.cellSize / 4;
  //   canvas.drawRRect(
  //     RRect.fromRectAndRadius(
  //       Rect.fromLTWH(
  //           -padding, -padding,
  //           size.x + 2 * padding,
  //           size.y + 2 * padding),
  //       Radius.circular(padding),
  //     ),
  //     Paint()..color = Colors.red,
  //   );
  //
  // }


}
