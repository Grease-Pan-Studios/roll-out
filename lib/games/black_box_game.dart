


import 'dart:ui';

import 'package:amaze_game/games/standard_game.dart';

import 'package:amaze_game/mazes/black_box_maze.dart';
import 'package:flutter/material.dart';

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

  @override
  void render(Canvas canvas) {
    super.render(canvas);

    //
    // Path rectangle = Path()..addRect(
    //   Rect.fromCenter(
    //     center: Offset(size.x/2, size.y/2),
    //     width: maze.size.x * camera.viewfinder.zoom ,
    //     height: maze.size.y * camera.viewfinder.zoom
    //   )
    // );
    // print("Size of maze: ${maze.size}");
    // print("Cell size: ${maze.mazeLogic.cellSize}");
    // print("Ball position: ${maze.ballComponent.position}");
    // print("Maze position: ${maze.position}");

    // print("Mze size: ${maze.size}, Size : $size");
    // Offset center = Offset(
    //     lerpDouble(0, size.x,
    //         maze.ballComponent.position.x / maze.size.x)!,
    //     lerpDouble(0, size.y,
    //         maze.ballComponent.position.y / maze.size.y)!
    // );
    // center = ;
    // print("Center: $center");
    // Path peepHole = Path()..addRect(
    //   Rect.fromCenter(
    //     center: center,
    //     width: mazeLogic.cellSize * camera.viewfinder.zoom,
    //     height: mazeLogic.cellSize * camera.viewfinder.zoom
    //   )
    // );

    // canvas.drawPath(
    //   Path.combine(
    //     PathOperation.difference,
    //     rectangle, peepHole
    //   )
    //   , Paint()..color = Colors.red.withAlpha(100)
    // );

    // canvas.drawRect(
    //   Rect.fromCenter(
    //         center: Offset(size.x/2, size.y/2),
    //         width: maze.size.x * camera.viewfinder.zoom ,
    //         height: maze.size.y * camera.viewfinder.zoom),
    //   Paint()..color = Colors.red.withAlpha(100)
    // );


  }

}