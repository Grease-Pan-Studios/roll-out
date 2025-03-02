
import 'package:amaze_game/logical/path_logic.dart';

import 'package:amaze_game/metadata/levels_metadata.dart';
import 'package:amaze_game/states/game_type_state.dart';

class GameLogic{

  late List<PathLogic> pages;

  GameLogic(){

    pages = [];

    int pageIndex = 0;
    Map pageMap = levelsMetaData[pageIndex] ?? {};

    while(pageMap.isNotEmpty){

      pages.add(
        PathLogic(
          pageIndex: pageIndex,
          pageFolderName: pageMap["page_folder_name"],
          hue: pageMap["hue"].toDouble(),
          gameType: pageMap["game_type"] ?? GameType.standard,
          sectionMaps: pageMap["sections"]
        )
      );

      pageIndex++;
      pageMap = levelsMetaData[pageIndex] ?? {};
    }


  }

  void fetchGameLogic() async{
    await Future.forEach(pages, (PathLogic pathway) async {
      for (var section in pathway.sections) {
        section.fetchLevelData();
      }
    });
  }

}