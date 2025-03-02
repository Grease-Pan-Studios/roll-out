
import 'package:amaze_game/logical/section_logic.dart';
import 'package:amaze_game/states/game_type_state.dart';

class PathLogic {

  double hue;
  int pageIndex;
  String pageFolderName;
  GameType gameType;

  late List<SectionLogic> sections;

  PathLogic({
    required this.pageIndex,
    required this.pageFolderName,
    required this.hue,
    required this.gameType,
    required Map sectionMaps,
  }){

    int sectionIndex = 0;
    Map sectionMap = sectionMaps[sectionIndex] ?? {};

    sections = [];

    while(sectionMap.isNotEmpty) {
      sections.add(
          SectionLogic(
            hue: hue,
            pageIndex: pageIndex,
            pageFolderName: pageFolderName,
            gameType: gameType,
            sectionFolderName: sectionMap["section_folder_name"],
            sectionIndex: sectionIndex,
            sectionName: sectionMap["section_name"],
            defaultUnlockedLevelIndices: sectionMap["unlocked"].cast<int>(),

            levelFileNames: sectionMap["levels"].cast<String>(),
          )
      );

      sectionIndex++;
      sectionMap = sectionMaps[sectionIndex] ?? {};

    }
  }


}
