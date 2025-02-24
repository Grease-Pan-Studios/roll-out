
import 'package:amaze_game/logical/page_logic.dart';

import 'package:amaze_game/metadata/levels_metadata.dart';

class GameLogic{

  late List<PageLogic> pages;

  GameLogic(){

    pages = [];

    int pageIndex = 0;
    Map pageMap = levelsMetaData[pageIndex] ?? {};

    while(pageMap.isNotEmpty){

      pages.add(
        PageLogic(
          pageIndex: pageIndex,
          pageFolderName: pageMap["page_folder_name"],
          hue: pageMap["hue"].toDouble(),
          sectionMaps: pageMap["sections"]
        )
      );

      pageIndex++;
      pageMap = levelsMetaData[pageIndex] ?? {};
    }


  }

  void fetchGameLogic() async{
    await Future.forEach(pages, (PageLogic pathway) async {
      for (var section in pathway.sections) {
        section.fetchLevelData();
      }
    });
  }

}