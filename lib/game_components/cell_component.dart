
import 'package:flutter/material.dart';

import 'package:amaze_game/game_components/wall_component.dart';
import 'package:amaze_game/logical/color_palette_logic.dart';
import 'package:flame/components.dart';

class CellComponent extends PositionComponent{

  final double cellSize;
  final double passageRatio;
  final double wallRatio;
  final Vector2 location;
  final ColorPaletteLogic colorPalette;

  late double wallWidth;
  late double passageWidth;
  late double paddingRatio;
  late double paddingWidth;

  CellComponent({
    required this.cellSize,
    required this.location,
    required this.passageRatio,
    required this.wallRatio,
    required this.colorPalette,
  }){
    assert( cellSize > 0, 'Cell size must be greater than 0');
    assert( passageRatio <= 1 && passageRatio >= 0, 'Padding must be between 0 and 1');
    assert( wallRatio <= 1 && wallRatio >= 0, 'Wall width must be between 0 and 1');
    // assert( )
    assert(passageRatio + wallRatio * 2 <= 1, 'Cant Have Negative Padding Dummy');

    wallWidth = cellSize * wallRatio;
    passageWidth = cellSize * passageRatio;
    paddingRatio = 0.5 - passageRatio / 2 - wallRatio;
    paddingWidth = cellSize * paddingRatio;
  }

  @override
  Future<void> onLoad() async {
    super.onLoad();

    // addLeftWall();
    // addRightWall();
    // addTopWall();
    // addBottomWall();

    // addLeftConnections();
    // addRightConnections();
    position = location;
  }

  void addTopConnections(){
    addTopLeftConnection();
    addTopRightConnection();
  }

  void addBottomConnections(){
    addBottomLeftConnection();
    addBottomRightConnection();
  }

  void addLeftConnections(){
    addLeftTopConnection();
    addLeftBottomConnection();
  }

  void addRightConnections(){
    addRightTopConnection();
    addRightBottomConnection();
  }

  void addRightBottomConnection(){
    add(WallComponent(
        position: Vector2(
            -(paddingWidth + wallWidth -cellSize)/2,
            (passageWidth + wallWidth)/2),
        size: Vector2(paddingWidth + wallWidth, wallWidth),
        color: colorPalette.activeElementBorder
    ));
  }

  void addRightTopConnection(){
    add(WallComponent(
        position: Vector2(
            -(paddingWidth + wallWidth -cellSize)/2,
            -(passageWidth + wallWidth)/2),
        size: Vector2(paddingWidth + wallWidth, wallWidth),
        color: colorPalette.activeElementBorder
    ));
  }


  void addLeftTopConnection(){
    add(WallComponent(
        position: Vector2(
            (paddingWidth + wallWidth -cellSize)/2,
            (passageWidth + wallWidth)/2),
        size: Vector2(paddingWidth + wallWidth, wallWidth),
        color: colorPalette.activeElementBorder
    ));
  }

  void addLeftBottomConnection(){
    add(WallComponent(
        position: Vector2(
            (paddingWidth + wallWidth -cellSize)/2,
            -(passageWidth + wallWidth)/2),
        size: Vector2(paddingWidth + wallWidth, wallWidth),
        color: colorPalette.activeElementBorder
    ));
  }

  void addTopLeftConnection(){
    add(WallComponent(
      position: Vector2(
          -(passageWidth + wallWidth)/2,
          (paddingWidth + wallWidth -cellSize)/2),
      size: Vector2(wallWidth, paddingWidth + wallWidth),
      color: colorPalette.activeElementBorder
    ));
  }

  void addTopRightConnection(){
    add(WallComponent(
        position: Vector2(
            (passageWidth + wallWidth)/2,
            (paddingWidth + wallWidth -cellSize)/2),
        size: Vector2(wallWidth, paddingWidth + wallWidth),
        color: colorPalette.activeElementBorder
    ));
  }

  void addBottomLeftConnection(){
    add(WallComponent(
        position: Vector2(
            -(passageWidth + wallWidth)/2,
            -(paddingWidth + wallWidth -cellSize)/2),
        size: Vector2(wallWidth, paddingWidth + wallWidth),
        color: colorPalette.activeElementBorder
    ));
  }

  void addBottomRightConnection(){
    add(WallComponent(
        position: Vector2(
            (passageWidth + wallWidth)/2,
            -(paddingWidth + wallWidth -cellSize)/2),
        size: Vector2(wallWidth, paddingWidth + wallWidth),
        color: colorPalette.activeElementBorder
    ));
  }

  void addTopWall(){
    add(WallComponent(
        position: Vector2(0, -passageWidth/2 - wallWidth/2),
        size: Vector2(cellSize - paddingWidth*2, wallWidth),
        color: colorPalette.activeElementBorder
    ));
  }

  void addBottomWall(){
    add(WallComponent(
      position: Vector2(0, passageWidth/2 + wallWidth/2),
      size: Vector2(cellSize - paddingWidth*2, wallWidth),
      color: colorPalette.activeElementBorder
    ));
  }

  void addLeftWall(){
    add(WallComponent(
        position: Vector2(-(passageWidth + wallWidth)/2, 0),
        size: Vector2(wallWidth, passageWidth + wallWidth*2),
        color: colorPalette.activeElementBorder
    ));
  }

  void addRightWall(){
    add(WallComponent(
        position: Vector2(passageWidth/2 + wallWidth/2, 0),
        size: Vector2(wallWidth, passageWidth + wallWidth*2),
        color: colorPalette.activeElementBorder
    ));

  }


  @override
  void render(Canvas canvas) {
    super.render(canvas);
    canvas.drawRect(
      Rect.fromCenter(
        center: Offset.zero,
        width: cellSize,
        height: cellSize,
      ),
      Paint()
        ..color = Colors.red
        ..style = PaintingStyle.stroke
        // ..
    );
  }


}