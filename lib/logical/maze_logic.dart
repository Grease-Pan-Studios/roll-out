
import 'dart:math';
import 'dart:io';
import 'package:flame_forge2d/flame_forge2d.dart';

import 'package:amaze_game/logical/cell_logic.dart';
import 'package:amaze_game/logical/section_logic.dart';

import 'package:amaze_game/states/game_type_state.dart';

class MazeLogic {

  /* Dimensions of the maze (x, y) */
  int width;
  int height;

  int startPositionX;
  int startPositionY;

  int goalPositionX;
  int goalPositionY;

  double ballRestitution;
  static const double defaultBallRestitution = 0.5;

  Duration threeStarThreshold;
  Duration twoStarThreshold;
  Duration oneStarThreshold;


  int seedUsed;

  /* Render Parameters */
  double cellSize;
  double passageRatio;
  double wallRatio;


  static const double defaultCellSize = 0.5;
  static const double defaultPassageRatio = 0.6;
  static const double defaultWallRatio = 0.15;

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
    this.cellSize = defaultCellSize,
    this.passageRatio = defaultPassageRatio,
    this.wallRatio = defaultWallRatio,
    this.ballRestitution = defaultBallRestitution,
  }){

    assert(
      width > 0 && height > 0,
      "Maze dimensions must be positive"
    );

    assert( passageRatio <= 1 && passageRatio >= 0, 'Padding must be between 0 and 1');
    assert( wallRatio <= 1 && wallRatio >= 0, 'Wall width must be between 0 and 1');
    // assert( )
    assert(passageRatio + wallRatio * 2 <= 1, 'Cant Have Negative Padding Dummy');


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


  double get internalRenderWidth => width * cellSize;
  double get internalRenderHeight => height * cellSize;

  double get ballRadius => cellSize * passageRatio * 0.25 ;

  Vector2 renderPositionOfCell(int x, int y){
    double positionX = cellSize / 2 + cellSize * x;
    double positionY = cellSize / 2 + cellSize * y;
    return Vector2(positionX, positionY);
  }

  Vector2 renderSizeOfMaze(){
    return Vector2(internalRenderWidth,internalRenderHeight);
  }

  Map<String, dynamic> toJson() {
    return {
      'width': width,
      'height': height,
      'seedUsed': seedUsed,
      'startPositionX': startPositionX,
      'startPositionY': startPositionY,
      'goalPositionX': goalPositionX,
      'goalPositionY': goalPositionY,
      'threeStarThreshold': threeStarThreshold.inSeconds,
      'twoStarThreshold': twoStarThreshold.inSeconds,
      'oneStarThreshold': oneStarThreshold.inSeconds,
      'cellSize': cellSize,
      'wallRatio': wallRatio,
      'passageRatio': passageRatio,
      'ballRestitution': ballRestitution,
      'cells': cells.map((cell) => cell.toJson()).toList(),
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
        cellSize: json['cellSize'] ?? defaultCellSize,
        wallRatio: json['wallRatio'] ?? defaultWallRatio,
        passageRatio: json['passageRatio'] ?? defaultPassageRatio,
        ballRestitution: json['ballRestitution'] ?? defaultBallRestitution,
        cells: (json['cells'] as List).map((cell) => CellLogic.fromJson(cell)).toList(),

    );
  }



  // Add this helper method to return only connected neighbours.
  List<int> getConnectedNeighbours(int index) {
    List<int> coords = indexToCoordinates(index);
    int x = coords[0];
    int y = coords[1];
    List<int> neighbours = [];

    // Left neighbour
    if (x > 0) {
      CellLogic current = getCellAt(x, y);
      CellLogic leftCell = getCellAt(x - 1, y);
      if (current.leftConnection && leftCell.rightConnection) {
        neighbours.add(index - 1);
      }
    }
    // Right neighbour
    if (x < width - 1) {
      CellLogic current = getCellAt(x, y);
      CellLogic rightCell = getCellAt(x + 1, y);
      if (current.rightConnection && rightCell.leftConnection) {
        neighbours.add(index + 1);
      }
    }
    // Top neighbour
    if (y > 0) {
      CellLogic current = getCellAt(x, y);
      CellLogic topCell = getCellAt(x, y - 1);
      if (current.topConnection && topCell.bottomConnection) {
        neighbours.add(index - width);
      }
    }
    // Bottom neighbour
    if (y < height - 1) {
      CellLogic current = getCellAt(x, y);
      CellLogic bottomCell = getCellAt(x, y + 1);
      if (current.bottomConnection && bottomCell.topConnection) {
        neighbours.add(index + width);
      }
    }
    return neighbours;
  }

  // Method to calculate path metrics: distance and number of turns.
  void estimateTimeThreshold(GameType gameType) {
    // Convert start and goal positions to indices.
    int startIndex = startPositionX + startPositionY * width;
    int goalIndex = goalPositionX + goalPositionY * width;

    // Map to keep track of each cell's predecessor.
    List<int?> parent = List.filled(width * height, null);
    // Distance array to store the number of steps from the start.
    List<int> distance = List.filled(width * height, -1);
    // Queue for BFS.
    List<int> queue = [];

    // Initialize BFS with the start cell.
    distance[startIndex] = 0;
    queue.add(startIndex);

    // BFS loop.
    while (queue.isNotEmpty) {
      int current = queue.removeAt(0);
      if (current == goalIndex) {
        break; // Found the goal.
      }
      for (int neighbour in getConnectedNeighbours(current)) {
        if (distance[neighbour] == -1) {
          distance[neighbour] = distance[current] + 1;
          parent[neighbour] = current;
          queue.add(neighbour);
        }
      }
    }

    // If goal is unreachable, return metrics as -1.
    if (distance[goalIndex] == -1) {
      print("FAKE NEWS");
      return;
    }

    // Reconstruct the shortest path from goal to start.
    List<int> pathIndices = [];
    int current = goalIndex;
    while (current != startIndex) {
      pathIndices.add(current);
      current = parent[current]!;
    }
    pathIndices.add(startIndex);
    // Reverse to get path from start to goal.
    pathIndices = pathIndices.reversed.toList();

    // Calculate the number of turns.
    int turns = 0;
    // A helper function to compute the direction vector between two cells.
    Vector2 getDirection(int fromIndex, int toIndex) {
      List<int> fromCoords = indexToCoordinates(fromIndex);
      List<int> toCoords = indexToCoordinates(toIndex);
      return Vector2(
          (toCoords[0] - fromCoords[0]).toDouble(),
          (toCoords[1] - fromCoords[1]).toDouble()
      );
    }

    // Calculate turns: for each segment of three cells, check if direction changes.
    if (pathIndices.length >= 3) {
      Vector2 prevDir = getDirection(pathIndices[0], pathIndices[1]);
      for (int i = 1; i < pathIndices.length - 1; i++) {
        Vector2 currentDir = getDirection(pathIndices[i], pathIndices[i + 1]);
        // A turn is detected when the current direction differs from the previous one.
        if (currentDir != prevDir) {
          turns++;
        }
        prevDir = currentDir;
      }
    }

    // Distance in cells is the number of steps between start and goal.
    int steps = pathIndices.length - 1;


    if (gameType == GameType.standard){
      double stepBuffer = 0.1; // For easy
      int fullBuffer = 1; // For easy

      double timePerStep1 = 0.48 + stepBuffer;
      double timePerTurn1 = 0.78 + stepBuffer;

      double timePerStep2 = 0.38 + stepBuffer;
      double timePerTurn2 = 0.68 + stepBuffer;

      double timePerStep3 = 0.28 + stepBuffer;
      double timePerTurn3 = 0.53 + stepBuffer;

      int threeStarThreshold = (timePerStep3 * steps + timePerTurn3 * turns).toInt() + fullBuffer;
      int twoStarThreshold = (timePerStep2 * steps + timePerTurn2 * turns).toInt() + fullBuffer;
      int oneStarThreshold = (timePerStep1 * steps + timePerTurn1 * turns).toInt() + fullBuffer;

      print("threeStarThreshold: $threeStarThreshold");
      print("twoStarThreshold: $twoStarThreshold");
      print("oneStarThreshold: $oneStarThreshold");

      this.oneStarThreshold = Duration(seconds: oneStarThreshold);
      this.twoStarThreshold = Duration(seconds: twoStarThreshold);
      this.threeStarThreshold = Duration(seconds: threeStarThreshold);
    }else if (gameType == GameType.bouncy){

      double stepBuffer = 0.18; // For medium  //0.25; // For easy
      int fullBuffer = 1; // For easy

      double timePerStep1 = 0.48 + stepBuffer;
      double timePerTurn1 = 0.88 + stepBuffer;

      double timePerStep2 = 0.38 + stepBuffer;
      double timePerTurn2 = 0.78 + stepBuffer;

      double timePerStep3 = 0.28 + stepBuffer;
      double timePerTurn3 = 0.63 + stepBuffer;

      int threeStarThreshold = (timePerStep3 * steps + timePerTurn3 * turns).toInt() + fullBuffer;
      int twoStarThreshold = (timePerStep2 * steps + timePerTurn2 * turns).toInt() + fullBuffer;
      int oneStarThreshold = (timePerStep1 * steps + timePerTurn1 * turns).toInt() + fullBuffer;

      print("threeStarThreshold: $threeStarThreshold");
      print("twoStarThreshold: $twoStarThreshold");
      print("oneStarThreshold: $oneStarThreshold");

      this.oneStarThreshold = Duration(seconds: oneStarThreshold);
      this.twoStarThreshold = Duration(seconds: twoStarThreshold);
      this.threeStarThreshold = Duration(seconds: threeStarThreshold);


    }else if (GameType.lookingGlass == gameType){

      double stepBuffer = 0.2; // For easy // 0.15; // For medium  //
      int fullBuffer = 1; // For easy

      double timePerStep1 = 0.48 + stepBuffer;
      double timePerTurn1 = 0.88 + stepBuffer;

      double timePerStep2 = 0.38 + stepBuffer;
      double timePerTurn2 = 0.78 + stepBuffer;

      double timePerStep3 = 0.28 + stepBuffer;
      double timePerTurn3 = 0.63 + stepBuffer;

      int threeStarThreshold = (timePerStep3 * steps + timePerTurn3 * turns).toInt() + fullBuffer;
      int twoStarThreshold = (timePerStep2 * steps + timePerTurn2 * turns).toInt() + fullBuffer;
      int oneStarThreshold = (timePerStep1 * steps + timePerTurn1 * turns).toInt() + fullBuffer;

      print("threeStarThreshold: $threeStarThreshold");
      print("twoStarThreshold: $twoStarThreshold");
      print("oneStarThreshold: $oneStarThreshold");

      this.oneStarThreshold = Duration(seconds: oneStarThreshold);
      this.twoStarThreshold = Duration(seconds: twoStarThreshold);
      this.threeStarThreshold = Duration(seconds: threeStarThreshold);
    }



  }


  void adjustStartAndGoal(){
    List<Vector2> diameter = findMazeDiameter();

    Random random = Random(seedUsed);
    if (random.nextBool()){
      Vector2 temp = diameter[0];
      diameter[0] = diameter[1];
      diameter[1] = temp;
    }

    Vector2 start = diameter[0];
    Vector2 goal = diameter[1];
    startPositionX = start.x.toInt();
    startPositionY = start.y.toInt();
    goalPositionX = goal.x.toInt();
    goalPositionY = goal.y.toInt();
  }


  /// Returns a list of 2 points
  /// points are coordinates of the two farthest apart cells
  List<Vector2> findMazeDiameter() {
    final random = Random();

    // Helper function: convert index to (x, y) coordinates.
    List<int> indexToCoords(int index) => indexToCoordinates(index);

    // Helper function: get connected neighbours of a cell based on connection flags,
    // sampling the directions in random order.
    List<int> getConnectedNeighbours(int index) {
      List<int> neighbours = [];
      List<int> coords = indexToCoords(index);
      int x = coords[0];
      int y = coords[1];

      // Define directions with deltas and associated connection flags.
      List<Map<String, dynamic>> directions = [
        {
          'dx': -1,
          'dy': 0,
          'currentFlag': 'leftConnection',
          'neighborFlag': 'rightConnection'
        },
        {
          'dx': 1,
          'dy': 0,
          'currentFlag': 'rightConnection',
          'neighborFlag': 'leftConnection'
        },
        {
          'dx': 0,
          'dy': -1,
          'currentFlag': 'topConnection',
          'neighborFlag': 'bottomConnection'
        },
        {
          'dx': 0,
          'dy': 1,
          'currentFlag': 'bottomConnection',
          'neighborFlag': 'topConnection'
        },
      ];

      // Shuffle the directions randomly.
      directions.shuffle(random);

      // Process each direction.
      for (var dir in directions) {
        int newX = x + (dir['dx'] as int);
        int newY = y + (dir['dy'] as int);

        // Check maze bounds.
        if (newX < 0 || newX >= width || newY < 0 || newY >= height) continue;

        int neighborIndex = newX + newY * width;
        CellLogic current = getCellAt(x, y);
        CellLogic neighborCell = getCellAt(newX, newY);

        // Determine connection status based on direction.
        bool currentConnected;
        bool neighborConnected;
        switch (dir['currentFlag']) {
          case 'leftConnection':
            currentConnected = current.leftConnection;
            neighborConnected = neighborCell.rightConnection;
            break;
          case 'rightConnection':
            currentConnected = current.rightConnection;
            neighborConnected = neighborCell.leftConnection;
            break;
          case 'topConnection':
            currentConnected = current.topConnection;
            neighborConnected = neighborCell.bottomConnection;
            break;
          case 'bottomConnection':
            currentConnected = current.bottomConnection;
            neighborConnected = neighborCell.topConnection;
            break;
          default:
            currentConnected = false;
            neighborConnected = false;
        }

        if (currentConnected && neighborConnected) {
          neighbours.add(neighborIndex);
        }
      }
      return neighbours;
    }

    // Helper function: perform BFS from a given start index.
    // Returns a list of distances from start (with -1 for unreachable cells).
    List<int> bfs(int start) {
      List<int> distances = List.filled(width * height, -1);
      List<int> queue = [];
      distances[start] = 0;
      queue.add(start);

      while (queue.isNotEmpty) {
        int current = queue.removeAt(0);
        int currentDist = distances[current];
        for (int neighbor in getConnectedNeighbours(current)) {
          if (distances[neighbor] == -1) {
            distances[neighbor] = currentDist + 1;
            queue.add(neighbor);
          }
        }
      }
      return distances;
    }

    // Helper function: find the index of the farthest cell given a distances list.
    Map<String, int> findFarthest(List<int> distances) {
      int maxDist = -1;
      int farthestIndex = 0;
      for (int i = 0; i < distances.length; i++) {
        if (distances[i] > maxDist) {
          maxDist = distances[i];
          farthestIndex = i;
        }
      }
      return {"index": farthestIndex, "distance": maxDist};
    }

    // Choose an arbitrary starting cell (e.g., cell at index 0).
    int arbitraryStart = 0;
    // First BFS to find one endpoint.
    List<int> distancesFromStart = bfs(arbitraryStart);
    Map<String, int> firstFarthest = findFarthest(distancesFromStart);
    int pointA = firstFarthest["index"]!;

    // Second BFS from pointA to find the other endpoint.
    List<int> distancesFromA = bfs(pointA);
    Map<String, int> secondFarthest = findFarthest(distancesFromA);
    int pointB = secondFarthest["index"]!;

    // Convert indices to coordinates.
    List<int> coordinatesA = indexToCoords(pointA);
    List<int> coordinatesB = indexToCoords(pointB);

    return [
      Vector2(coordinatesA[0].toDouble(), coordinatesA[1].toDouble()),
      Vector2(coordinatesB[0].toDouble(), coordinatesB[1].toDouble())
    ];
  }



}
