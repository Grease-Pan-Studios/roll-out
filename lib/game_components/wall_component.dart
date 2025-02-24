
import 'package:flutter/material.dart';
import 'package:flame_forge2d/flame_forge2d.dart';


class WallComponent extends BodyComponent with ContactCallbacks{

  @override
  final Vector2 position;
  final Vector2 size;
  final bool isStatic;
  final Color color;

  WallComponent({
    required this.position, required this.size,
    this.color = Colors.white,
    this.isStatic = true});

  @override
  Body createBody() {

    final shape = PolygonShape()..setAsBox(size.x / 2, size.y / 2, Vector2(0, 0), 0);
    final bodyDef = BodyDef(
      userData: this,
      position: position,
      allowSleep: false,
      type: isStatic ? BodyType.kinematic : BodyType.dynamic,

    );
    final fixtureDef = FixtureDef(
      shape,
      restitution: 0.5,
      density: 1,
      friction: 0.5,
      userData: this,
    );
    // priority = 1;
    return world.createBody(bodyDef)..createFixture(fixtureDef);
  }

  @override
  void render(Canvas canvas) {
    super.render(canvas);
    canvas.drawRect(
      Rect.fromCenter(
        center: Offset.zero,
        width: size.x,
        height: size.y,
      ),
      Paint()..color = color,
    );
  }
}