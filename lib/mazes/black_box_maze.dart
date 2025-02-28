

import 'dart:math';

import 'package:amaze_game/logical/color_palette_logic.dart';
import 'package:amaze_game/mazes/standard_maze.dart';
import 'package:flame/components.dart';
import 'package:flame_forge2d/flame_forge2d.dart';
import 'package:flutter/material.dart';

import 'package:amaze_game/games/standard_game.dart';

class Ray extends RayCastCallback {
  final double angle;
  Vector2? collision;
  int _contactCount = 0; // counter for contacts

  Ray({required this.angle});

  void reset(){
    _contactCount = 0;
    collision = null;
  }

  @override
  double reportFixture(Fixture fixture, Vector2 point, Vector2 normal, double fraction) {
    // _contactCount++;
    //
    // // If this is the first contact, ignore it by returning -1.0.
    // // Returning -1 tells the engine to ignore this fixture.
    // if (_contactCount == 1) {
    //   return 1;
    // }
    // // On the second contact, record the collision and terminate the cast.
    // else if (_contactCount == 2) {
    //   collision = point.clone();
    //   // Returning 0 terminates the ray cast.
    //   return fraction;
    // }
    // return fraction;
    // // In case more contacts are reported, terminate the cast.

    collision = point.clone();

    return fraction;
  }
}


class VisibleRegion extends Component with HasGameRef<StandardGame>{

  final int numberOfRays;
  final double radius;


  late List<Ray> rays;

  final double padding = 0.2;

  VisibleRegion({
    required this.radius,
    required this.numberOfRays
  }){
    rays = List.generate(numberOfRays,
            (index) => Ray(angle: (index * 2 * pi) / numberOfRays));
  }

  void castRays(){

    for (Ray ray in rays){
      ray.reset();
      Vector2 endVector = Vector2(
          game.maze.ballComponent.center.x + radius * cos(ray.angle),
          game.maze.ballComponent.center.y + radius * sin(ray.angle)
      );

      // Vector2 startVector = Vector2(
      //     game.maze.ballComponent.center.x + game.maze.ballComponent.radius * cos(ray.angle),
      //     game.maze.ballComponent.center.y + game.maze.ballComponent.radius * sin(ray.angle)
      // );

      game.world.raycast(ray, game.maze.ballComponent.center, endVector);
    }

  }

  List<Vector2> getVisibleRegion(){

    List<Vector2> visibleRegion = [];

    for (Ray ray in rays){

      Vector2 endPoint = Vector2.zero();

      if (ray.collision != null && ray.collision!.distanceTo(game.maze.ballComponent.center) < radius){
        endPoint = ray.collision!.clone();

        // Extend end point by padding
        // endPoint = endPoint + (endPoint - game.maze.ballComponent.center) * padding;
        endPoint = endPoint + (endPoint - game.maze.ballComponent.center).normalized() * padding;

      }else{
        endPoint = Vector2(
            game.maze.ballComponent.center.x + radius * cos(ray.angle),
            game.maze.ballComponent.center.y + radius * sin(ray.angle)
        );
      }

      visibleRegion.add(endPoint);
    }

    return visibleRegion;

  }

}

class PeepHoleComponent extends PositionComponent with HasGameRef<StandardGame>{

  final ColorPaletteLogic colorPalette;

  late VisibleRegion visibleRegion;

  PeepHoleComponent({
    required this.colorPalette,
  });

  @override
  Future<void> onLoad() async {
    super.onLoad();

    visibleRegion = VisibleRegion(
      radius: game.maze.mazeLogic.cellSize * 1.5,
      numberOfRays: 500
    );

    add(visibleRegion);
  }

  @override
  void render(Canvas canvas){
    super.render(canvas);

    visibleRegion.castRays();

    Path rectangle = Path()..addRect(
        Rect.fromLTWH(0, 0, game.maze.size.x, game.maze.size.y)
    );

    Path visiblePath = Path()..addPolygon(visibleRegion.getVisibleRegion().map(
            (e) => Offset(e.x, e.y)).toList(), true);

    Rect visibleRect = visiblePath.getBounds();



    canvas.drawPath(
      Path.combine(
        PathOperation.difference,
        rectangle,
        visiblePath
      ),
      Paint()..color =
      colorPalette.getLightPrimary()
    );

    canvas.drawPath(
      visiblePath,
      Paint()
        ..shader = RadialGradient(
          colors: [
            colorPalette.getDarkPrimary().withAlpha(0),
            colorPalette.getDarkPrimary()
          ],
          stops: [0,  1.75 * max(visibleRect.width / game.maze.size.x, visibleRect.height / game.maze.size.y)],
          center: Alignment(
              game.maze.ballComponent.center.x / game.maze.size.x * 2 - 1,
              game.maze.ballComponent.center.y / game.maze.size.y * 2 - 1
          )
        ).createShader(
          Rect.fromLTWH(0, 0, game.maze.size.x, game.maze.size.y)
        )
    );

    canvas.drawPath(
      Path.combine(
        PathOperation.difference,
        rectangle,
        visiblePath
      ),
      Paint()
        ..shader = RadialGradient(
          colors: [
            colorPalette.getLightPrimary(),
            colorPalette.getDarkPrimary(),
          ],
          stops: [0, 2 * max(visibleRect.width / game.maze.size.x, visibleRect.height / game.maze.size.y)],
          center: Alignment(
              game.maze.ballComponent.center.x / game.maze.size.x * 2 - 1,
              game.maze.ballComponent.center.y / game.maze.size.y * 2 - 1
          )
        ).createShader(
          Rect.fromLTWH(0, 0, game.maze.size.x, game.maze.size.y)
        )
    );

    
    
    // canvas.drawPath(
    //   rectangle,
    //   Paint()
    //     ..shader = RadialGradient(
    //       colors: [
    //         colorPalette.getDarkPrimary().withAlpha(0),
    //         colorPalette.getDarkPrimary(),
    //         colorPalette.getLightPrimary()
    //       ],
    //       stops: [0, 0.5, 1],
    //       center: Alignment(
    //           (game.maze.ballComponent.center.x / game.maze.size.x) * 2 - 1,
    //           (game.maze.ballComponent.center.y / game.maze.size.y) * 2 - 1
    //       ),
    //     ).createShader(Rect.fromLTWH(0, 0, game.maze.size.x, game.maze.size.y))
    // );


    // canvas.drawPath(
    //   visiblePath,
    //   Paint()
    //     ..color = colorPalette.getDarkPrimary()
    //     ..style = PaintingStyle.stroke
    //     ..strokeWidth = 0.03
    // );


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

    peepHole = PeepHoleComponent(colorPalette: colorPalette);
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
