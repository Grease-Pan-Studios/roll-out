
import 'dart:math';

import 'package:flame_forge2d/flame_forge2d.dart';

import 'package:amaze_game/logical/maze_logic.dart';

class MazeGenerator{

  static MazeLogic getMaze(int sizeX, int sizeY, {int? startX, int? startY, int? goalX, int? goalY, int? seed}){


    seed ??= DateTime.now().millisecondsSinceEpoch;
    Random random = Random(seed);

    int startPositionX = startX ?? random.nextInt(sizeX);
    int startPositionY = startY ?? random.nextInt(sizeY);

    int goalPositionX = goalX ?? random.nextInt(sizeX);
    int goalPositionY = goalY ?? random.nextInt(sizeY);

    final MazeLogic maze = MazeLogic(
        width: sizeX,
        height:  sizeY,
        startPositionX: startPositionX,
        startPositionY: startPositionY,
        goalPositionX: goalPositionX,
        goalPositionY: goalPositionY,
        threeStarThreshold: Duration(seconds: 10),
        twoStarThreshold: Duration(seconds: 20),
        oneStarThreshold: Duration(seconds: 30),
        seedUsed: seed,
    );




    int start = random.nextInt(sizeX * sizeY);



    Set<int> visited = {start};

    List<int> stack = [start];

    while (stack.isNotEmpty) {

      int current = stack.removeLast();

      List<int> unvisitedNeighbours = maze.getNeighboursByIndex(current)
          .where((neighbour) => !visited.contains(neighbour))
          .toList();

      if (unvisitedNeighbours.isEmpty) continue;

      stack.add(current);

      unvisitedNeighbours.shuffle(random);

      for (int neighbour in unvisitedNeighbours){

        visited.add(neighbour);
        stack.add(neighbour);

        /* Connect current and neighbour */
        maze.connectCellsByIndex(current, neighbour);

      }

    }


    return maze;

  }



}