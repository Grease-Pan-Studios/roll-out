
import 'package:flame_forge2d/flame_forge2d.dart';

import 'package:amaze_game/logical/cell_logic.dart';
import 'package:amaze_game/logical/section_logic.dart';

class MazeLogic {

  /* Dimensions of the maze (x, y) */
  int width;
  int height;

  int startPositionX;
  int startPositionY;

  int goalPositionX;
  int goalPositionY;

  double ballRestitution;

  Duration threeStarThreshold;
  Duration twoStarThreshold;
  Duration oneStarThreshold;

  /* */
  int seedUsed;

  /* Render Parameters */
  double passageWidth;
  double wallWidth;
  double borderWidth;


  /* New Shit */
  // double defaultCellSize = 0.5;

  static const double defaultPassageWidth = 0.3;
  static const double defaultWallWidth = 0.1;
  static const double defaultBorderWidth = 0.15;
  static const double defaultBallRestitution = 0.5;

  List<CellLogic> cells;

  MazeLogic({
    required this.width,
    required this.height,
    required this.seedUsed,
    required this.startPositionX,
    required this.startPositionY,
    required this.goalPositionX,
    required this.goalPositionY,
    required this.threeStarThreshold,
    required this.twoStarThreshold,
    required this.oneStarThreshold,
    this.cells = const [],
    this.passageWidth = defaultPassageWidth,
    this.wallWidth = defaultWallWidth,
    this.borderWidth = defaultBorderWidth,
    this.ballRestitution = defaultBallRestitution,
  }){

    assert(
      width > 0 && height > 0,
      "Maze dimensions must be positive"
    );

    assert(
      passageWidth > 0 && wallWidth > 0 && borderWidth > 0,
      "Render parameters must be positive"
    );

    if (cells.isEmpty){
      int size = width * height;
      cells = [];
      for (int i = 0; i < size; i++){
        cells.add(CellLogic());
      }
    }else{
      assert(cells.length == width * height, "Cells must match maze dimensions");
    }


  }

  CellLogic getCellAt(int x, int y){

    assert (x >= 0 && x < width && y >= 0 && y < height,
      "Out of maze index bounds");

    return cells[x + y * width];
  }

  List<int> indexToCoordinates(int index){
    assert(index >= 0 && index < width * height, "Out of maze index bounds");

    return [index % width, index ~/ width];
  }


  List<int> getNeighboursByIndex(int index){

    List<int> neighbours = [];

    List<int> coordinates = indexToCoordinates(index);

    if (coordinates[0] > 0) neighbours.add(index - 1);
    if (coordinates[0] < width - 1) neighbours.add(index + 1);
    if (coordinates[1] > 0) neighbours.add(index - width);
    if (coordinates[1] < height - 1) neighbours.add(index + width);

    return neighbours;
  }

  void connectCellsByIndex(int cellAIndex, int cellBIndex){

    List<int> coordinatesA = indexToCoordinates(cellAIndex);
    List<int> coordinatesB = indexToCoordinates(cellBIndex);

    CellLogic cellA = getCellAt(coordinatesA[0], coordinatesA[1]);
    CellLogic cellB = getCellAt(coordinatesB[0], coordinatesB[1]);

    int manhattanDist = (coordinatesA[0] - coordinatesB[0]).abs() + (coordinatesA[1] - coordinatesB[1]).abs();
    assert(manhattanDist == 1, "Cells must be adjacent to connect");

    if (coordinatesA[0] == coordinatesB[0]){
      if (coordinatesA[1] == coordinatesB[1] - 1){
        cellA.bottomConnection = true;
        cellB.topConnection = true;
      } else if (coordinatesA[1] == coordinatesB[1] + 1){
        cellA.topConnection = true;
        cellB.bottomConnection = true;
      }
    } else if (coordinatesA[1] == coordinatesB[1]){
      if (coordinatesA[0] == coordinatesB[0] - 1){
        cellA.rightConnection = true;
        cellB.leftConnection = true;
      } else if (coordinatesA[0] == coordinatesB[0] + 1){
        cellA.leftConnection = true;
        cellB.rightConnection = true;
      }
    }
  }

  List<List<Vector2>> getHorizontalWalls(){

    List<List<Vector2>> result = [];

    for (int y = 0; y < height - 1; y++){

      List<Vector2> row = [];

      Vector2 section = Vector2(-1, -1);

      for (int x = 0; x < width; x++){
        CellLogic cell = getCellAt(x, y);

        if (section.x == -1 && !cell.bottomConnection){
          section.x = x.toDouble();
        }else if (section.x != -1 && cell.bottomConnection){
          section.y = x.toDouble();
          row.add(section);
          section = Vector2(-1, -1);
        }

      }
      if (section.x != -1 && section.y == -1){
        section.y = width.toDouble();
        row.add(section);
      }

      result.add(row);
    }

    return result;

    return result;

  }


  List<List<Vector2>> getVerticalWalls(){

    List<List<Vector2>> result = [];

    for (int x = 0; x < width - 1; x++){

      List<Vector2> row = [];

      Vector2 section = Vector2(-1, -1);

      for (int y = 0; y < height; y++){
        CellLogic cell = getCellAt(x, y);

        if (section.x == -1 && !cell.rightConnection){
          section.x = y.toDouble();
        }else if (section.x != -1 && cell.rightConnection){
          section.y = y.toDouble();
          row.add(section);
          section = Vector2(-1, -1);
        }

      }
      if (section.x != -1 && section.y == -1){
        section.y = height.toDouble();
        row.add(section);
      }

      result.add(row);
    }

    return result;

  }


  double get internalRenderWidth => width * passageWidth + (width - 1) * wallWidth;
  double get internalRenderHeight => height * passageWidth + (height - 1) * wallWidth;

  Vector2 renderPositionOfCell(int x, int y){
    x = x;
    y = y;
    double positionX = borderWidth + x * (passageWidth + wallWidth) - (internalRenderWidth / 2);
    double positionY = borderWidth + y * (passageWidth + wallWidth) - (internalRenderHeight / 2);
    // double positionY =  internalRenderHeight * ( y / height - 0.5) + borderWidth;
    return Vector2(positionX, positionY);
  }

  Vector2 renderSizeOfMaze(){
    return Vector2(
        internalRenderWidth + 2 * borderWidth,
        internalRenderHeight + 2 * borderWidth
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'width': width,
      'height': height,
      'startPositionX': startPositionX,
      'startPositionY': startPositionY,
      'goalPositionX': goalPositionX,
      'goalPositionY': goalPositionY,
      'seedUsed': seedUsed,
      'passageWidth': passageWidth,
      'wallWidth': wallWidth,
      'borderWidth': borderWidth,
      'cells': cells.map((cell) => cell.toJson()).toList()
    };
  }


  factory MazeLogic.fromJson(
      Map<String, dynamic> json
  ){
    return MazeLogic(
        width: json['width'],
        height: json['height'],
        seedUsed: json['seedUsed'],
        startPositionX: json['startPositionX'],
        startPositionY: json['startPositionY'],
        goalPositionX: json['goalPositionX'],
        goalPositionY: json['goalPositionY'],
        threeStarThreshold: Duration(seconds: json['threeStarThreshold']),
        twoStarThreshold: Duration(seconds: json['twoStarThreshold']),
        oneStarThreshold: Duration(seconds: json['oneStarThreshold']),
        cells: (json['cells'] as List).map((cell) => CellLogic.fromJson(cell)).toList(),
        passageWidth: json['passageWidth'] ?? defaultPassageWidth,
        wallWidth: json['wallWidth'] ?? defaultWallWidth,
        borderWidth: json['borderWidth'] ?? defaultBorderWidth,
        ballRestitution: json['ballRestitution'] ?? defaultBallRestitution,

    );
  }


}
