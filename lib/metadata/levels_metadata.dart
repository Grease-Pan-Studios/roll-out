

import 'package:amaze_game/states/game_type_state.dart';

Map levelsMetaData = {

  0 : {
    "page_folder_name": "path_1",
    "hue": 210,
    "sections" : {
      0 : {
        "section_folder_name": "section_1",
        "section_name": "Ready?",
        "unlocked": [0],
        "levels": ["1.json", "2.json", "3.json", "4.json","5.json",
          "6.json", "7.json", "8.json","9.json", "10.json"]
      },
      1 : {
        "section_folder_name": "section_2",
        "section_name": "Steady...",
        "unlocked": [0],
        "levels": ["1.json", "2.json", "3.json", "4.json","5.json",
          "6.json", "7.json", "8.json","9.json", "10.json",
          // "11.json", "12.json", "13.json", "14.json","15.json",
        ],
      },
      2 : {
        "section_folder_name": "section_3",
        "section_name": "G0!",
        "unlocked": [0],
        "levels": ["1.json", "2.json", "3.json", "4.json","5.json",]
      }
    }
  },
  1 : {
    "page_folder_name": "path_2",
    "hue": 235,
    "sections" : {
      0 : {
        "section_folder_name" : "section_1",
        "section_name": "Shake it,",
        "unlocked": [0, 1, 2],
        "levels": ["1.json", "2.json", "3.json", "4.json","5.json",
          "6.json", "7.json", "8.json","9.json", "10.json",]
      },
      1 : {
        "section_folder_name": "section_2",
        "section_name": "Break it.",
        "unlocked": [0],
        "levels": ["1.json", "2.json", "3.json", "4.json","5.json",
          "6.json", "7.json", "8.json","9.json", "10.json",]
      },
      2 : {
        "section_folder_name": "section_2",
        "section_name": "Make it BOUNCE!",
        "unlocked": [0],
        "levels": ["1.json", "2.json", "3.json", "4.json","5.json",
          "6.json", "7.json", "8.json","9.json", "10.json",]
      }
    }

  },
  2 : {
    "page_folder_name": "path_3",
    "hue": 315,
    "game_type" : GameType.lookingGlass,
    "sections" : {
      0 : {
        "section_folder_name" : "section_1",
        "section_name": "Those who don't",
        "unlocked": [0, 1],
        "levels": ["1.json", "2.json", "3.json", "4.json","5.json",
          "6.json", "7.json", "8.json","9.json", "10.json",]
      },
      1 : {
        "section_folder_name": "section_2",
        "section_name": "believe in magic,",
        "unlocked": [0, 1],
        "levels": ["1.json", "2.json", "3.json", "4.json","5.json",
          "6.json", "7.json", "8.json","9.json", "10.json",],
      },
      2 : {
        "section_folder_name": "section_3",
        "section_name": "will never find it",
        "unlocked": [0],
        "levels": ["1.json", "2.json", "3.json", "4.json","5.json",
          "6.json", "7.json", "8.json","9.json", "10.json",],
      },
    }

  },
  3 : {
    "page_folder_name": "path_1",
    "hue": 280,
    "game_type" : GameType.blackBox,
    "sections" : {
      0 : {
        "section_folder_name" : "section_1",
        "section_name": "Darkness may hide",
        "unlocked": [0, 1],
        "levels": ["1.json", "2.json", "3.json", "4.json","5.json",
          "6.json", "7.json", "8.json","9.json", "10.json",],
      },
      1 : {
        "section_folder_name": "section_2",
        "section_name": "the trees and the flowers,",
        "unlocked": [0, 1],
        "levels": ["1.json", "2.json", "3.json", "4.json","5.json",
          "6.json", "7.json", "8.json","9.json", "10.json",],
      },
      2 : {
        "section_folder_name": "section_2",
        "section_name": "but it cannot hide...",
        "unlocked": [0, 1],
        "levels": ["1.json", "2.json", "3.json", "4.json","5.json",
          "6.json", "7.json", "8.json","9.json", "10.json",],
      },
      3 : {
        "section_folder_name": "section_2",
        "section_name": "love from the soul.",
        "unlocked": [0,],
        "levels": ["1.json", "2.json", "3.json", "4.json","5.json",
          "6.json", "7.json", "8.json","9.json", "10.json",],
      }
    }

  }

};