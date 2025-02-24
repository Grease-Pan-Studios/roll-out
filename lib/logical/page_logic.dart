
import 'package:amaze_game/logical/section_logic.dart';

class PageLogic {

  double hue;
  int pageIndex;
  String pageFolderName;

  late List<SectionLogic> sections;

  PageLogic({
    required this.pageIndex,
    required this.pageFolderName,
    required this.hue,
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
