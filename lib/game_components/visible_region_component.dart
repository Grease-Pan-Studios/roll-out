
import 'dart:math';

import 'package:flame_forge2d/flame_forge2d.dart';
import 'package:flame/components.dart';

import 'package:flutter/material.dart';

import 'package:amaze_game/games/standard_game.dart';
import 'package:amaze_game/logical/color_palette_logic.dart';



class _Ray extends RayCastCallback {
  final double angle;
  Vector2? collision;

  _Ray({required this.angle});

  void reset(){
    collision = null;
  }

  @override
  double reportFixture(Fixture fixture, Vector2 point, Vector2 normal, double fraction) {
    collision = point.clone();

    return fraction;
  }
}


class VisibleRegionComponent extends Component with HasGameRef<StandardGame>{

  final int numberOfRays;
  final double radius;
  final ColorPaletteLogic colorPalette;
  final double regionPadding;

  late List<_Ray> rays;


  VisibleRegionComponent({
    required this.radius,
    required this.regionPadding,
    required this.numberOfRays,
    required this.colorPalette,
  }){
    rays = List.generate(numberOfRays,
            (index) => _Ray(angle: (index * 2 * pi) / numberOfRays));
  }

  void castRays(){

    for (_Ray ray in rays){
      ray.reset();
      Vector2 endVector = Vector2(
          game.maze.ballComponent.center.x + radius * cos(ray.angle),
          game.maze.ballComponent.center.y + radius * sin(ray.angle)
      );


      game.world.raycast(ray, game.maze.ballComponent.center, endVector);
    }

  }

  List<Vector2> getVisibleRegion(){

    List<Vector2> visibleRegion = [];

    for (_Ray ray in rays){

      Vector2 endPoint = Vector2.zero();

      if (ray.collision != null && ray.collision!.distanceTo(game.maze.ballComponent.center) < radius){
        endPoint = ray.collision!.clone();

        endPoint += (endPoint - game.maze.ballComponent.center).normalized() * regionPadding;

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

  Path getVisiblePath(){
    castRays();

    return Path()
      ..addPolygon(getVisibleRegion().map(
              (e) => Offset(e.x, e.y)).toList(), true);
  }


  @override
  void render(Canvas canvas) {
    super.render(canvas);


    Path rectangle = Path()
      ..addRect(
          Rect.fromLTWH(0, 0, game.maze.size.x, game.maze.size.y)
      );

    Path visiblePath = getVisiblePath();

    canvas.drawPath(
        Path.combine(
            PathOperation.difference,
            rectangle,
            visiblePath
        ),
        Paint()
          ..color =
          colorPalette.getLightPrimary()
    );
  }



}


class PeepHoleComponent extends VisibleRegionComponent{


  PeepHoleComponent({
    required super.radius,
    required super.regionPadding,
    required super.numberOfRays,
    required super.colorPalette,
  });

  @override
  void render(Canvas canvas){
    super.render(canvas);

    Path rectangle = Path()
      ..addRect(
          Rect.fromLTWH(0, 0, game.maze.size.x, game.maze.size.y)
      );

    Path visiblePath = getVisiblePath();
    Rect visibleRect = visiblePath.getBounds();

    canvas.drawPath(
        visiblePath,
        Paint()
          ..shader = RadialGradient(
              colors: [
                colorPalette.getDarkPrimary().withAlpha(0),
                colorPalette.getDarkPrimary()
              ],
              stops: [0,  3.75 * max(visibleRect.width / game.maze.size.x, visibleRect.height / game.maze.size.y)],
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
              radius: 3* max(visibleRect.width / game.maze.size.x, visibleRect.height / game.maze.size.y),
              stops: [0, 4 * max(visibleRect.width / game.maze.size.x, visibleRect.height / game.maze.size.y)],
              center: Alignment(
                  game.maze.ballComponent.center.x / game.maze.size.x * 2 - 1,
                  game.maze.ballComponent.center.y / game.maze.size.y * 2 - 1
              )
          ).createShader(
              Rect.fromLTWH(0, 0, game.maze.size.x, game.maze.size.y)
          )
    );

  }

}
