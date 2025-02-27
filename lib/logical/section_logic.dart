
import 'dart:convert';
import 'package:amaze_game/states/game_type_state.dart';
import 'package:flutter/services.dart';

import 'package:amaze_game/logical/maze_logic.dart';

class SectionLogic{

  double hue;
  int pageIndex;
  int sectionIndex;
  String pageFolderName;
  String sectionFolderName;
  String sectionName;
  GameType gameType;
  List<String> levelFileNames;
  List<int> defaultUnlockedLevelIndices;
  late List<MazeLogic> levels;

  SectionLogic({
    required this.hue,
    required this.gameType,
    required this.pageIndex,
    required this.sectionIndex,
    required this.pageFolderName,
    required this.sectionFolderName,
    required this.sectionName,
    required this.defaultUnlockedLevelIndices,
    required this.levelFileNames,
  });

  void fetchLevelData() async{
    levels = [];

    final manifestContent = await rootBundle.loadString('AssetManifest.json');
    final Map<String, dynamic> manifest = json.decode(manifestContent);

    for (var levelFileName in levelFileNames) {
      final String filePath = getFilePath(levelFileName);
      assert(manifest.containsKey(filePath), 'Could not find $filePath in asset manifest');
    }

    for (int i =0 ; i < levelFileNames.length; i++) {
      final String levelFileName = levelFileNames[i];
      final String filePath = getFilePath(levelFileName);
      final String levelString = await rootBundle.loadString(filePath);
      final Map<String, dynamic> levelMap = json.decode(levelString);
      levels.add(MazeLogic.fromJson(levelMap));
    }


  }

  String getFilePath(String fileName){
    return 'assets/paths/$pageFolderName/$sectionFolderName/$fileName';
  }

  String levelCode(int level){
    assert(level >= 0 && level < levelFileNames.length, 'Level Index out of bounds');
    return "$pageIndex\\$sectionIndex\\$level";
  }

  bool isNextLevel(int level){
    return level + 1 < levels.length;
  }

}