
import 'dart:math';

import 'package:amaze_game/game_components/wall_component.dart';
import 'package:amaze_game/logical/color_palette_logic.dart';
import 'package:amaze_game/logical/maze_logic.dart';
import 'package:amaze_game/game_components/ball_component.dart';
import 'package:amaze_game/controls/controller.dart';
import 'package:amaze_game/services/audio_player_service.dart';
import 'package:amaze_game/services/haptic_engine_service.dart';

import 'package:flame/components.dart';
import 'package:flame/effects.dart';

import 'package:flame_forge2d/flame_forge2d.dart';
import 'package:flutter/material.dart';

class MazeComponent extends PositionComponent{

  MazeLogic mazeLogic;
  Controller controller;
  ColorPaletteLogic colorPalette;
  HapticEngineService hapticEngine;
  AudioPlayerService audioPlayer;
  void Function() levelCompletionCallback;


  late BallComponent ballComponent;
  late Vector2 goalPosition;
  late CircleComponent irisOutComponent;

  // lat
  double goalThreshold = 0.1;
  bool mazeComplete = false;

  MazeComponent({
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

    position = Vector2.zero();

    // // priority = 6;
    // await initializeAudioPlayer();

    buildBorders();

    buildWallsHorizontal();

    buildWallsVertical();

    addBall();

    addGoal();

    addIrisOutEffect();

  }

  @override
  void update(double dt) {
    super.update(dt);

    double dist = goalPosition.distanceTo(ballComponent.position);
    if (!mazeComplete && dist < goalThreshold){
      gameCompleteTrigger();
    }
  }


  // Future<void> initializeAudioPlayer() async {
  //
  //   audioPlayer = AudioPlayerService(sfxAssets: [
  //     "assets/audio/sfx/tap-dull-1.wav",
  //   ]);
  //   await audioPlayer.initialize();
  //
  // }

  void addBall(){
    ballComponent = BallComponent(
      initialPosition: mazeLogic.renderPositionOfCell(
          mazeLogic.startPositionX, mazeLogic.startPositionY),
      controller: controller,
      hapticEngine: hapticEngine,
      audioPlayer: audioPlayer,
      colorPalette: colorPalette,
      restitution: mazeLogic.ballRestitution,
      radius: 0.07,
      // color: Colors.green
    );
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
      paint: Paint()..color = colorPalette.secondary,
      anchor: Anchor.center,
    );
    add(irisOutComponent);
  }

  void buildWallsHorizontal(){
    List<List<Vector2>> horizontalWalls = mazeLogic.getHorizontalWalls();

    double passageWidth = mazeLogic.passageWidth;
    double wallWidth = mazeLogic.wallWidth;
    double internalWidth = mazeLogic.internalRenderWidth;
    double internalHeight = mazeLogic.internalRenderHeight;

    for (int rowIndex = 0; rowIndex < horizontalWalls.length; rowIndex++){
      // print(horizontalWalls[rowIndex]);
      for (var wall in horizontalWalls[rowIndex]) {

        double sectionWidth = (wall.y - wall.x) * (passageWidth + wallWidth);

        double positionX = (passageWidth * wall.x) + (wallWidth * ((wall.x == 0) ? 0 : wall.x - 1)) - (internalWidth / 2) + sectionWidth / 2; //wall.x * passageWidth
        double positionY = (rowIndex + 1 ) * passageWidth + (rowIndex) * wallWidth  - (internalHeight / 2) + (wallWidth / 2);


        add(WallComponent(
            position: Vector2(positionX, positionY),
            size: Vector2(sectionWidth, wallWidth),
            color: colorPalette.activeElementBorder// Colors.white//
            // color: Colors.red.withOpacity(0.6)
        ));
      }

    }
  }

  void buildWallsVertical(){
    List<List<Vector2>> verticalWalls = mazeLogic.getVerticalWalls();
    List<Set<int>> rowEnds = [];

    for (List<Vector2> column in mazeLogic.getHorizontalWalls()){
      Set<int> ends = {};
      for (Vector2 wall in column){
        ends.add(wall.y.toInt());
      }
      rowEnds.add(ends);
    }

    double passageWidth = mazeLogic.passageWidth;
    double wallWidth = mazeLogic.wallWidth;
    double internalWidth = mazeLogic.internalRenderWidth;
    double internalHeight = mazeLogic.internalRenderHeight;

    for (int rowIndex = 0; rowIndex < verticalWalls.length; rowIndex++) {
      // print("Row Idx ${rowIndex} : ${verticalWalls[rowIndex]}");
      for (var wall in verticalWalls[rowIndex]) {

        double extension = 0;
        // print("Indexing: ${wall.y.toInt()}");
        if (wall.y != mazeLogic.height){
          // print("Set: ${rowEnds[wall.y.toInt() - 1]}");
         if(rowEnds[wall.y.toInt() - 1].contains(rowIndex + 1)){
          extension = wallWidth;
        }
        }

        double sectionHeight = (wall.y - wall.x) * (passageWidth + wallWidth) + extension ;

        double positionY = (passageWidth * wall.x) +
            (wallWidth * ((wall.x == 0) ? 0 : wall.x - 1)) -
            (internalHeight / 2) + sectionHeight / 2; //wall.x * passageWidth
        double positionX = (rowIndex + 1) * passageWidth +
            (rowIndex) * wallWidth - (internalWidth / 2) + (wallWidth / 2);

        add(WallComponent(
            position: Vector2(positionX, positionY),
            size: Vector2(wallWidth, sectionHeight),
            color: colorPalette.activeElementBorder
            // color: Colors.blue.withOpacity(0.6)
        ));
      }
    }
  }

  void buildBorders(){

    double borderWidth = mazeLogic.borderWidth;
    double internalWidth = mazeLogic.internalRenderWidth;
    double internalHeight = mazeLogic.internalRenderHeight;

    Color borderColor = colorPalette.activeElementBorder;

    final topBorder = WallComponent(
        position: Vector2(0,  - (internalHeight + borderWidth) / 2),
        size: Vector2(internalWidth + 2 * borderWidth, borderWidth),
        color: borderColor

    );

    final bottomBorder = WallComponent(
        position: Vector2(0, (internalHeight + borderWidth) / 2),
        size: Vector2(internalWidth + 2 * borderWidth, borderWidth),
        color: borderColor
    );

    final leftBorder = WallComponent(
        position: Vector2(- (internalWidth + borderWidth) / 2, 0),
        size: Vector2(borderWidth, internalHeight),
        color: borderColor
    );

    final rightBorder = WallComponent(
        position: Vector2((internalWidth + borderWidth) / 2, 0),
        size: Vector2(borderWidth, internalHeight),
        color: borderColor
    );

    addAll([topBorder, bottomBorder, leftBorder, rightBorder]);
  }

  void gameCompleteTrigger(){
    // print("Goal Reached");
    mazeComplete = true;

    ballComponent.body.setType(BodyType.static);
    ballComponent.setPositionGoal(goalPosition);
    ballComponent.setSizeGoal(0.1);

    // Future.delayed(Duration(seconds: 1), () {
      levelCompletionCallback();
    // });


  }

  @override
  void render(Canvas canvas) {
    super.render(canvas);

    /* Draw a dot of 0.1 radius */
    // Vector2 testPosition = positionOfCell(3, 0);
    // canvas.drawCircle(Offset(testPosition.x, testPosition.y), 0.1, Paint()..color = Colors.red);
    final strokePaint = Paint()
      ..color = colorPalette.activeElementBorder
      ..style = PaintingStyle.stroke
      ..strokeWidth = 0.03;

    final fillPaint = Paint()
      ..color = colorPalette.primary
      ..style = PaintingStyle.fill;
      // ..strokeWidth = 0.02;

    Offset goalOffset = Offset(goalPosition.x, goalPosition.y);
    canvas.drawCircle(goalOffset, 0.1, fillPaint);
    canvas.drawCircle(goalOffset, 0.1, strokePaint);


    if (mazeComplete){
      irisOutComponent.radius = irisOutComponent.radius + 0.12;
    }

  }

}


