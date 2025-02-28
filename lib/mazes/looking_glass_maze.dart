
import 'dart:math';
import 'dart:ui' as ui;

import 'package:flame/components.dart';
import 'package:flutter/material.dart';

import 'package:amaze_game/mazes/standard_maze.dart';
import 'package:amaze_game/game_components/visible_region_component.dart';
import 'package:amaze_game/games/standard_game.dart';
import 'package:amaze_game/logical/color_palette_logic.dart';

class LookingGlass extends Component with HasGameRef<StandardGame> {

  final double radius;
  final ColorPaletteLogic colorPalette;


  LookingGlass({
    required this.radius,
    required this.colorPalette,
  });



  @override
  void render(Canvas canvas) {
    super.render(canvas);

    Offset center = Offset(
        game.maze.ballComponent.center.x,
        game.maze.ballComponent.center.y
    );

    Path rectangle = Path()
      ..addRect(Rect.fromLTWH(0, 0, game.maze.size.x, game.maze.size.y));

    Path window = Path()
      ..addOval(Rect.fromCircle(
          center: center,
          radius: radius)
      );

    Rect visibleRect = window.getBounds();

    canvas.drawPath(
      Path.combine(
        PathOperation.difference,
        rectangle,
        window
      ),
      Paint()
        ..color = colorPalette.primary
        ..style = PaintingStyle.fill
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

    canvas.drawPath(
      window,
      Paint()
        ..color = colorPalette.activeElementBorder
        ..style = PaintingStyle.stroke
        ..strokeWidth = radius * 0.08
    );

  }
}


class LookingGlassMaze extends StandardMaze {


  late PeepHoleComponent peepHole;

  LookingGlassMaze({
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

    LookingGlass lookingGlass = LookingGlass(
      radius: mazeLogic.cellSize * 1.5,
      colorPalette: colorPalette
    );

    add(lookingGlass);
  }


}
