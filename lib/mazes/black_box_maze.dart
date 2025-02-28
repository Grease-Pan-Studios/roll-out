

import 'dart:math';

import 'package:amaze_game/mazes/standard_maze.dart';
import 'package:flame/components.dart';
import 'package:flame_forge2d/flame_forge2d.dart';
import 'package:flutter/material.dart';

import 'package:amaze_game/games/standard_game.dart';

class VisibleRegion extends RayCastCallback{

  List<Vector2> region = [];

  
  
  @override
  double reportFixture(Fixture fixture, Vector2 point, Vector2 normal, double fraction) {

    region.add(point);

    return fraction;
  }

}

class PeepHoleComponent extends PositionComponent with HasGameRef<StandardGame>{
  
  final Color color;
  final VisibleRegion visibleRegion = VisibleRegion();

  PeepHoleComponent({
    required this.color,
  });

  
  @override
  void render(Canvas canvas){
    super.render(canvas);

    visibleRegion.region.clear();
    
    double radius = game.maze.mazeLogic.cellSize * 3;
    
    double rayCount = 1;
    
    for (int i = 0; i < rayCount; i++){
      double angle = (i * 2 * pi) / rayCount;

      // print("Angle: $angle");
      Vector2 endVector = Vector2(
        game.maze.ballComponent.center.x + radius * cos(angle),
        game.maze.ballComponent.center.y + radius * sin(angle)
      );

      // print("End Vector: $endVector");

      game.world.raycast(visibleRegion, game.maze.ballComponent.center, endVector);
      
    }
    // print(visibleRegion.region.length);
    // Path peepHole = Path()..addPolygon(
    //   visibleRegion.region.map((e) => Offset(e.x, e.y)).toList(),
    //   true
    // );
    //
    // canvas.drawPath(
    //   peepHole,
    //   Paint()..color = Colors.red.withAlpha(100)
    // );


    

    for (Vector2 point in visibleRegion.region){
      canvas.drawCircle(
        Offset(point.x, point.y),
        game.maze.ballComponent.radius * 0.4,
        Paint()..color = Colors.red
      );
    }

  }
  
  
  /*
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

    canvas.drawPath(
      Path.combine(
        PathOperation.difference,
        rectangle, peepHole
      )
      , Paint()..color = color
        // Colors.red.withAlpha(100)
    );


  }
  */
  
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
