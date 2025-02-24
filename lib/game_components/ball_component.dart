
import 'package:amaze_game/services/audio_player_service.dart';
import 'package:amaze_game/services/haptic_engine_service.dart';
import 'package:flutter/material.dart';
import 'package:flame_forge2d/flame_forge2d.dart';

import 'package:amaze_game/logical/color_palette_logic.dart';
import 'package:amaze_game/controls/controller.dart';


class BallComponent extends BodyComponent with ContactCallbacks {

  final double radius;
  final double restitution;
  final Vector2 initialPosition;
  final Controller controller;
  final ColorPaletteLogic colorPalette;
  final AudioPlayerService audioPlayer;
  final HapticEngineService hapticEngine;

  Vector2? positionGoal;
  double? sizeGoal;
  double? sizeCurrent;

  BallComponent({
    required this.radius,
    required this.restitution,
    required this.initialPosition,
    required this.controller,
    required this.colorPalette,
    required this.audioPlayer,
    required this.hapticEngine,
  });

  @override
  Body createBody() {
    final shape = CircleShape()..radius = radius;
    final fixtureDef = FixtureDef(shape)
      ..userData = this
      ..restitution = restitution
      ..density = 1
      ..friction = 0.5;
    final bodyDef = BodyDef()
      ..bullet = true
      ..userData = this
      ..allowSleep = false
      ..position = initialPosition
      ..type = BodyType.dynamic //BodyType.static//
      ..gravityScale = Vector2.all(6);
      // ..gravityOverride = Vector2(1, 0);

    return world.createBody(bodyDef)
      ..createFixture(fixtureDef);
  }

  // @override
  // void beginContact(Object other, Contact contact) {
  //   audioPlayer.playSfxSound();
  // }

  @override
  void postSolve(Object other, Contact contact, ContactImpulse impulse) {
    final maxImpulse = impulse.normalImpulses.reduce((a, b) => a > b ? a : b);

    // print("Impulse / mass: ${maxImpulse / body.mass}");

    final deltaVelocity = maxImpulse / body.mass;

    /* delta velocity range 10 to 2 */

    if (deltaVelocity > 0.5) {
      audioPlayer.playSfxSound(volume: deltaVelocity / 10);
    }

    if (deltaVelocity > 0.1){
      hapticEngine.vibrate(amplitude: (deltaVelocity * 100).toInt());
    }

  }


  @override
  void update(double dt) {

    super.update(dt);
    body.gravityOverride = Vector2(controller.x, controller.y);

    if (positionGoal != null){
      body.setTransform(position + (positionGoal! - position) * 0.3, 0);
    }
    if (sizeGoal != null && sizeCurrent != null){
      sizeCurrent = sizeCurrent! + (sizeGoal! - sizeCurrent!) * 0.08;
      // print(sizeCurrent);
    }

  }

  void setPositionGoal(Vector2 position){
    positionGoal = position;
  }

  void setSizeGoal(double size){
    sizeGoal = size;
    sizeCurrent = radius;
  }

  @override
  void render(Canvas canvas) {
    // TODO: implement render
    super.render(canvas);

    canvas.drawCircle(
      Offset.zero,
      radius,
      Paint()..color = colorPalette.inactiveElementBackground,
    );


    if (sizeGoal != null && sizeCurrent != null){
      final paint = Paint()
        ..color = colorPalette.primary
        ..style = PaintingStyle.stroke
        ..strokeWidth = (sizeCurrent! - radius) * 5;

      // canves.drawCircle(Offset(position.x, position.y), radius, paint);
      final clipPath = Path()
        ..addOval(Rect.fromCircle(center: Offset(0, 0), radius: radius));

      canvas.clipPath(clipPath);
      canvas.save();

      canvas.drawCircle(Offset(0, 0), radius, paint);
      canvas.restore();
    }



  }
}