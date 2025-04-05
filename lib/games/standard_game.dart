
import 'dart:math';

import 'package:amaze_game/controls/controller.dart';
import 'package:amaze_game/logical/color_palette_logic.dart';
import 'package:amaze_game/logical/maze_logic.dart';
import 'package:amaze_game/services/audio_player_service.dart';
import 'package:amaze_game/services/haptic_engine_service.dart';

import 'package:flutter/material.dart';
import 'package:flame_forge2d/flame_forge2d.dart';
import 'package:flame/components.dart';

import 'package:amaze_game/mazes/standard_maze.dart';
import 'package:amaze_game/states/settings_state.dart';


class StandardGame extends Forge2DGame{

  final MazeLogic mazeLogic;
  final ColorPaletteLogic colorPalette;
  final HapticEngineService hapticEngine;
  final AudioPlayerService audioPlayer;
  final SettingsState settingsState;
  final void Function({
    required bool isComplete,
    required int rating,
    required Duration completionTime,
  }) exitGameCallback;


  late StandardMaze maze;
  late Controller controller;
  late TextComponent timeText;
  late Stopwatch stopwatch;

  StandardGame({
    required this.mazeLogic,
    required this.colorPalette,
    required this.exitGameCallback,
    required this.hapticEngine,
    required this.audioPlayer,
    required this.settingsState,
  }) : super(
    world: Forge2DWorld(gravity: Vector2(0, 10)),
    zoom: 100
  );

  void triggerGameCompletion({required bool isComplete}){

    stopwatch.stop();
    Duration completionTime = Duration(
      milliseconds: stopwatch.elapsedMilliseconds
    );

    int rating = 0;
    if (completionTime.inMilliseconds < mazeLogic.threeStarThreshold.inMilliseconds){
      rating = 3;
    } else if (completionTime.inMilliseconds < mazeLogic.twoStarThreshold.inMilliseconds){
      rating = 2;
    } else if (completionTime.inMilliseconds < mazeLogic.oneStarThreshold.inMilliseconds){
      rating = 1;
    }
    /*Delay For Animation*/
    Future.delayed(Duration(seconds: 1), (){
      exitGameCallback(
        isComplete: isComplete,
        rating: rating,
        completionTime: completionTime
      );
    });

  }

  void pauseGame(){
    stopwatch.stop();
    pauseEngine();
  }

  void resumeGame(){
    stopwatch.start();
    resumeEngine();
  }

  @override
  Future<void> onLoad() async {

    initializeController();

    initializeMaze();
    world.add(maze);

    timeText = TextComponent(
      text: "00:00:00",
      position: Vector2(size.x/2, 0),
      anchor: Anchor.topCenter ,
      textRenderer: TextPaint(
        style: TextStyle(
          fontFamily: 'JetBrainsMono',
          color: colorPalette.activeElementText,
          fontSize: 40,
          fontWeight: FontWeight.w700,
          letterSpacing: -5,
          // fontFeatures: [FontFeature.tabularFigures()],
        ),
      )
    );
    add(timeText);

    adjustCamera(reference: maze);
    print("Call Again");
    stopwatch = Stopwatch();
    stopwatch.start();

  }

  void initializeController(){
    controller = Controller(settingsState: settingsState);
  }

  void initializeMaze(){
    maze = StandardMaze(
      mazeLogic: mazeLogic,
      colorPalette: colorPalette,
      audioPlayer: audioPlayer,
      hapticEngine: hapticEngine,
      controller: controller,
      levelCompletionCallback: triggerGameCompletion,
    );

  }

  void gameFailedTrigger({bool force = false}){

    if (force || mazeLogic.hasTimeLimit
        && stopwatch.elapsed.inSeconds
            > mazeLogic.oneStarThreshold.inSeconds){
      exitGameCallback(
        isComplete: false,
        rating: 0,
        completionTime: stopwatch.elapsed
      );
    }
  }

  void adjustCamera({required StandardMaze reference}){
    double padding = reference.mazeLogic.cellSize / 2;
    // print("Height of text: ${timeText.height}");

    final mazeSize = reference.size;
    final cameraSize = size;

    for (int iteration = 0; iteration < 10; iteration++){

      final scaleX = cameraSize.x / (mazeSize.x + 2 * padding);
      // print("Time Text Height: ${timeText.height}");
      final scaleY = cameraSize.y / (mazeSize.y + 2* padding + (timeText.height / camera.viewfinder.zoom));

      // print("ScaleX: $scaleX, ScaleY: $scaleY");

      if (scaleX > scaleY){
        camera.viewfinder.zoom = scaleY;
        // camera.moveTo(reference.position + Vector2(mazeSize.x/2, mazeSize.y/2) - Vector2(0, timeText.height * 0.4 / camera.viewfinder.zoom));
        camera.moveTo(reference.position + Vector2(mazeSize.x/2, mazeSize.y/2) - Vector2(0, timeText.height * 0.4 / camera.viewfinder.zoom));

      } else {
        camera.viewfinder.zoom = scaleX;
        camera.moveTo(reference.position + Vector2(mazeSize.x/2, mazeSize.y/2));
      }

    }





  }

  String getTime(){
    /*Minutes 00: Seconds 00: Milliseconds 00*/
    int time = stopwatch.elapsedMilliseconds;

    if (mazeLogic.hasTimeLimit){
      final int totalTime = mazeLogic.oneStarThreshold.inMilliseconds;
      time = totalTime - time;
      if (time < 0){
        time = 0;
        gameFailedTrigger(force: true);
      }

    }


    final int minutes = (time / 60000).floor();
    final int seconds = ((time % 60000) / 1000).floor();
    final int milliseconds = ((time % 1000)/10).floor();

    return "${minutes.toString().padLeft(2, "0")}:${
        seconds.toString().padLeft(2,"0")}:${
        milliseconds.toString().padLeft(2,"0")}";
  }

  @override
  void update(double dt) {
    super.update(dt);
    timeText.text = getTime();
    gameFailedTrigger();
  }


  @override
  Color backgroundColor() => colorPalette.getDarkPrimary();

}