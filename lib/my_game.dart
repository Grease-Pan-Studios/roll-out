
import 'package:amaze_game/controls/controller.dart';
import 'package:amaze_game/logical/color_palette_logic.dart';
import 'package:amaze_game/logical/maze_logic.dart';
import 'package:amaze_game/services/audio_player_service.dart';
import 'package:amaze_game/services/haptic_engine_service.dart';

import 'package:flutter/material.dart';
import 'package:flame_forge2d/flame_forge2d.dart';
import 'package:flame/components.dart';

import 'package:amaze_game/game_components/maze_component.dart';
import 'package:amaze_game/generation/maze_generator.dart';


class MyGame extends Forge2DGame{

  final MazeLogic mazeLogic;
  final ColorPaletteLogic colorPalette;
  final HapticEngineService hapticEngine;
  final AudioPlayerService audioPlayer;

  final void Function({
    required bool isComplete,
    required int rating,
    required Duration completionTime,
  }) exitGameCallback;


  late TextComponent timeText;
  late Stopwatch stopwatch;

  MyGame(
    {
      required this.mazeLogic,
      required this.colorPalette,
      required this.exitGameCallback,
      required this.hapticEngine,
      required this.audioPlayer,
    }
  ) : super(
      world: Forge2DWorld(gravity: Vector2(0, 10)),
      zoom: 100
  );

  void _triggerGameCompletion(){

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
        isComplete: true,
        rating: rating,
        completionTime: completionTime
      );
    });

  }


  @override
  Future<void> onLoad() async {

    final controller = Controller();


    final maze = MazeComponent(
        mazeLogic: mazeLogic,
        colorPalette: colorPalette,
        audioPlayer: audioPlayer,
        hapticEngine: hapticEngine,
        controller: controller,
        levelCompletionCallback: _triggerGameCompletion,
    );

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

    world.addAll([maze]);

    add(timeText);

    adjustCamera(reference: maze);

    stopwatch = Stopwatch();
    stopwatch.start();

  }

  void adjustCamera({required MazeComponent reference}){
    double padding = 0.2;
    print("Height of text: ${timeText.height}");
    final mazeSize = reference.size;
    final cameraSize = size;

    final scaleX = cameraSize.x / (mazeSize.x + 2 * padding);
    final scaleY = cameraSize.y / (mazeSize.y + padding + (timeText.height / camera.viewfinder.zoom));
    camera.viewfinder.zoom = scaleX > scaleY ? scaleY : scaleX;
    print("Zoom: ${camera.viewfinder.zoom}");
    camera.viewfinder.position = (reference.position) + Vector2(0, 0.1);
  }

  String getTime(){
    /*Minutes 00: Seconds 00: Milliseconds 00*/
    final time = stopwatch.elapsedMilliseconds;
    final minutes = (time / 60000).floor();
    final seconds = ((time % 60000) / 1000).floor();
    final milliseconds = ((time % 1000)/10).floor();
    return "${minutes.toString().padLeft(2, "0")}:${
        seconds.toString().padLeft(2,"0")}:${
        milliseconds.toString().padLeft(2,"0")}";
  }

  @override
  void update(double dt) {
    super.update(dt);
    timeText.text = getTime();
    // timeText.position = Vector2(size.x/2, 0);
  }

  @override
  void render(Canvas canvas) {
    super.render(canvas);
    // final fillPaint = Paint()
    //   ..color = Colors.red//colorPalette.secondary
    //   ..style = PaintingStyle.fill;

    // Vector2 goalPosition = mazeLogic.renderPositionOfCell(
    //     mazeLogic.goalPositionX,
    //     mazeLogic.goalPositionY
    // );
    //
    // Offset goalOffset = Offset(
    //     goalPosition.x,
    //     goalPosition.y
    // );
    // canvas.drawCircle(goalOffset, 100, fillPaint);
  }


  @override
  Color backgroundColor() => colorPalette.secondary;

}