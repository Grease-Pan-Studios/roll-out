
import 'package:amaze_game/logical/cell_logic.dart';
import 'package:flame/components.dart';
import 'package:flutter/material.dart';

import 'package:amaze_game/game_components/wall_component.dart';
import 'package:amaze_game/logical/color_palette_logic.dart';

import 'package:flame_forge2d/flame_forge2d.dart';

class CellComponent {

  final double cellSize;
  final double passageRatio;
  final double wallRatio;
  final Vector2 location;
  final ColorPaletteLogic colorPalette;
  final CellLogic cellLogic;
  // final Function(BodyComponent, Vector2) addComponent;

  late double wallWidth;
  late double passageWidth;
  late double paddingRatio;
  late double paddingWidth;

  CellComponent({
    required this.cellLogic,
    required this.cellSize,
    required this.location,
    required this.passageRatio,
    required this.wallRatio,
    required this.colorPalette,
    // required this.addComponent,
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


  List<BodyComponent> getWalls(){
    List<BodyComponent> walls = [];

    if (!cellLogic.topConnection){
      walls.add(getTopWall());
    }else{
      walls.add(getTopLeftConnection());
      walls.add(getTopRightConnection());
    }

    if (!cellLogic.bottomConnection){
      walls.add(getBottomWall());
    }else{
      walls.add(getBottomLeftConnection());
      walls.add(getBottomRightConnection());
    }

    if (!cellLogic.leftConnection){
      walls.add(getLeftWall());
    }else{
      walls.add(getLeftTopConnection());
      walls.add(getLeftBottomConnection());
    }

    if (!cellLogic.rightConnection){
      walls.add(getRightWall());
    } else{
      walls.add(getRightTopConnection());
      walls.add(getRightBottomConnection());
    }

    return walls;

  }



  // @override
  // Future<void> onLoad() async {
  //   super.onLoad();
  //   position = location;
  //
  //   if (!cellLogic.topConnection){
  //     addTopWall();
  //   }else{
  //     addTopConnections();
  //   }
  //   if (!cellLogic.bottomConnection){
  //     addBottomWall();
  //   }else{
  //     addBottomConnections();
  //   }
  //
  //   if (!cellLogic.leftConnection){
  //     addLeftWall();
  //   }else{
  //     addLeftConnections();
  //   }
  //
  //   if (!cellLogic.rightConnection){
  //     addRightWall();
  //   } else{
  //     addRightConnections();
  //   }
  //
  //   // addLeftWall();
  //   // addRightWall();
  //   // addTopWall();
  //   // addBottomWall();
  //
  //   // addLeftConnections();
  //   // addRightConnections();
  //   // position = location;
  // }

  // void getTopConnections(){
  //   getTopLeftConnection();
  //   getTopRightConnection();
  // }
  //
  // void getBottomConnections(){
  //   getBottomLeftConnection();
  //   getBottomRightConnection();
  // }
  //
  // void getLeftConnections(){
  //   getLeftTopConnection();
  //   getLeftBottomConnection();
  // }
  //
  // void getRightConnections(){
  //   getRightTopConnection();
  //   getRightBottomConnection();
  // }

  WallComponent getRightBottomConnection(){
    return WallComponent(
        location: Vector2(
            -(paddingWidth + wallWidth -cellSize)/2,
            (passageWidth + wallWidth)/2) + location,
        size: Vector2(paddingWidth + wallWidth, wallWidth),
        color: colorPalette.activeElementText
    );
  }

  WallComponent getRightTopConnection(){
    return WallComponent(
        location: Vector2(
            -(paddingWidth + wallWidth -cellSize)/2,
            -(passageWidth + wallWidth)/2) + location,
        size: Vector2(paddingWidth + wallWidth, wallWidth),
        color: colorPalette.activeElementText
    );
  }


  WallComponent getLeftTopConnection(){
    return WallComponent(
        location: Vector2(
            (paddingWidth + wallWidth -cellSize)/2,
            (passageWidth + wallWidth)/2) + location,
        size: Vector2(paddingWidth + wallWidth, wallWidth),
        color: colorPalette.activeElementText
    );
  }

  WallComponent getLeftBottomConnection(){
    return WallComponent(
        location: Vector2(
            (paddingWidth + wallWidth -cellSize)/2,
            -(passageWidth + wallWidth)/2) + location,
        size: Vector2(paddingWidth + wallWidth, wallWidth),
        color: colorPalette.activeElementText
    );
  }

  WallComponent getTopLeftConnection(){
    return WallComponent(
      location: Vector2(
          -(passageWidth + wallWidth)/2,
          (paddingWidth + wallWidth -cellSize)/2) + location,
      size: Vector2(wallWidth, paddingWidth + wallWidth),
      color: colorPalette.activeElementText
    );
  }

  WallComponent getTopRightConnection(){
    return WallComponent(
        location: Vector2(
            (passageWidth + wallWidth)/2,
            (paddingWidth + wallWidth -cellSize)/2) + location,
        size: Vector2(wallWidth, paddingWidth + wallWidth),
        color: colorPalette.activeElementText
    );
  }

  WallComponent getBottomLeftConnection(){
    double extra = cellLogic.bottomConnection ?  wallWidth * 0.1:  0;
    return WallComponent(
        location: Vector2(
            -(passageWidth + wallWidth)/2,
            -(paddingWidth + wallWidth -cellSize)/2)
            + location + Vector2(0, extra),
        size: Vector2(wallWidth, paddingWidth + wallWidth + extra),
        color: colorPalette.activeElementText
    );
  }

  WallComponent getBottomRightConnection(){
    double extra = cellLogic.bottomConnection ?  wallWidth * 0.1:  0;
    return WallComponent(
        location: Vector2(
            (passageWidth + wallWidth)/2,
            -(paddingWidth + wallWidth -cellSize)/2)
            + location + Vector2(0, extra),
        size: Vector2(wallWidth, paddingWidth + wallWidth + extra),
        color: colorPalette.activeElementText
    );
  }

  WallComponent getTopWall(){
    return WallComponent(
        location: Vector2(0, -passageWidth/2 - wallWidth/2) + location,
        size: Vector2(cellSize - paddingWidth*2, wallWidth),
        color: colorPalette.activeElementText
    );
  }

  WallComponent getBottomWall(){
    return WallComponent(
      location: Vector2(0, passageWidth/2 + wallWidth/2) + location,
      size: Vector2(cellSize - paddingWidth*2, wallWidth),
      color: colorPalette.activeElementText
    );
  }

  WallComponent getLeftWall(){
    return WallComponent(
      location: Vector2(-(passageWidth + wallWidth)/2, 0) + location,
      size: Vector2(wallWidth, passageWidth + wallWidth*2),
      color: colorPalette.activeElementText
    );
  }

  WallComponent getRightWall(){
    return WallComponent(
        location: Vector2(passageWidth/2 + wallWidth/2, 0) + location,
        size: Vector2(wallWidth, passageWidth + wallWidth*2),
        color: colorPalette.activeElementText
    );

  }

  //
  // @override
  // void render(Canvas canvas) {
  //   super.render(canvas);
  //   // canvas.drawRect(
  //   //   Rect.fromCenter(
  //   //     center: Offset.zero,
  //   //     width: cellSize,
  //   //     height: cellSize,
  //   //   ),
  //   //   Paint()
  //   //     ..color = Colors.red
  //   //     ..style = PaintingStyle.stroke
  //   //     // ..
  //   // );
  // }


}