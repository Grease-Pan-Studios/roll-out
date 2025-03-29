
import 'dart:math';

import 'package:amaze_game/game_components/cell_component.dart';
import 'package:amaze_game/game_components/wall_component.dart';

import 'package:amaze_game/logical/color_palette_logic.dart';
import 'package:amaze_game/logical/maze_logic.dart';
import 'package:amaze_game/logical/cell_logic.dart';

import 'package:amaze_game/game_components/ball_component.dart';
import 'package:amaze_game/controls/controller.dart';
import 'package:amaze_game/services/audio_player_service.dart';
import 'package:amaze_game/services/haptic_engine_service.dart';

import 'package:flame/components.dart';

import 'package:flame_forge2d/flame_forge2d.dart';
import 'package:flutter/material.dart';

class StandardMaze extends PositionComponent with HasGameRef{

  MazeLogic mazeLogic;
  Controller controller;
  ColorPaletteLogic colorPalette;
  HapticEngineService hapticEngine;
  AudioPlayerService audioPlayer;
  void Function({required bool isComplete}) levelCompletionCallback;


  late BallComponent ballComponent;
  late Vector2 goalPosition;
  late CircleComponent irisOutComponent;


  bool mazeComplete = false;


  StandardMaze({
    required this.mazeLogic,
    required this.audioPlayer,
    required this.hapticEngine,
    required this.controller,
    required this.colorPalette,
    required this.levelCompletionCallback,
  });

  @override
  Future<void> onLoad() async {
    super.onLoad();

    size = mazeLogic.renderSizeOfMaze();

    position = Vector2(0, 0);

    buildCells();

    addBall();

    addGoal();

    addIrisOutEffect();

  }

  @override
  void update(double dt) {
    super.update(dt);

    double dist = goalPosition.distanceTo(ballComponent.position);
    if (!mazeComplete && dist < mazeLogic.cellSize * 0.3){
      gameCompleteTrigger();
    }

    // if ()

  }


  void addBall(){
    ballComponent = BallComponent(
      initialPosition: mazeLogic.renderPositionOfCell(
          mazeLogic.startPositionX, mazeLogic.startPositionY),
      controller: controller,
      hapticEngine: hapticEngine,
      audioPlayer: audioPlayer,
      colorPalette: colorPalette,
      restitution: mazeLogic.ballRestitution,
      radius: mazeLogic.ballRadius,
      // color: Colors.green
    );
    // ballComponent.body.setTransform(ballComponent.position , 0);
    add(ballComponent);
  }

  void addGoal(){
    goalPosition = mazeLogic.renderPositionOfCell(
        mazeLogic.goalPositionX,
        mazeLogic.goalPositionY
    );
  }

  void addIrisOutEffect(){
    irisOutComponent = CircleComponent(
      radius: 0,
      position: goalPosition,
      paint: Paint()..color = colorPalette.getDarkPrimary(),
      anchor: Anchor.center,
    );
    add(irisOutComponent);
  }

  void buildCells(){

    for (int x = 0; x < mazeLogic.width; x++){
      for (int y = 0; y < mazeLogic.height; y++){

        CellLogic cell = mazeLogic.getCellAt(x, y);
        Vector2 position = mazeLogic.renderPositionOfCell(x, y);

        CellComponent cellComponent = CellComponent(
          cellLogic: cell,
          location: position,
          cellSize: mazeLogic.cellSize,
          passageRatio: mazeLogic.passageRatio,
          wallRatio: mazeLogic.wallRatio,
          colorPalette: colorPalette,
        );

        for (BodyComponent wall in cellComponent.getWalls()){
          // Vector2 offset = wall.position;

          // wall.body.setTransform(wall + position, 0);
          add(wall);
          // wall.body.worldPoint(mazeLogic.renderPositionOfCell(x, y));
          // print(wall.body.position);
        }

        // add(cellComponent);

      }
    }

  }

  // void gameFailTrigger(){
  //   print("Game Failed");
  //   levelCompletionCallback(isComplete: false);
  // }
  //
  void gameCompleteTrigger(){
    // print("Goal Reached");
    mazeComplete = true;

    ballComponent.body.setType(BodyType.static);
    ballComponent.setPositionGoal(goalPosition);
    ballComponent.setSizeGoal(0.1);

    // Future.delayed(Duration(seconds: 1), () {
      levelCompletionCallback(isComplete: true);
    // });
  }


  void drawBackground(Canvas canvas){
    double padding = mazeLogic.cellSize / 4;
    canvas.drawRRect(
      RRect.fromRectAndRadius(
        Rect.fromLTWH(
            -padding, -padding,
            size.x + 2 * padding,
            size.y + 2 * padding),
        Radius.circular(padding),
      ),
      Paint()..color = colorPalette.getLightPrimary(),
    );
  }

  void drawGoal(Canvas canvas){
    final goalStrokePaint = Paint()
      ..color = colorPalette.activeElementBorder
      ..style = PaintingStyle.stroke
      ..strokeMiterLimit = 1
      ..strokeWidth = mazeLogic.ballRadius * 0.3;

    final goalFillPaint = Paint()
      ..color = colorPalette.primary
      ..style = PaintingStyle.fill;

    Offset goalOffset = Offset(goalPosition.x, goalPosition.y);
    canvas.drawCircle(goalOffset, mazeLogic.ballRadius, goalFillPaint);
    canvas.drawCircle(goalOffset, mazeLogic.ballRadius, goalStrokePaint);
  }

  void whileComplete(){
    if (mazeComplete){
      irisOutComponent.radius += 0.12;
    }
  }

  @override
  void render(Canvas canvas) {

    super.render(canvas);
    drawBackground(canvas);

    drawGoal(canvas);

    whileComplete();

  }

}


