
import 'package:amaze_game/games/standard_game.dart';

class BuilderGame extends StandardGame{

  BuilderGame({
    required super.mazeLogic,
    required super.colorPalette,
    required super.exitGameCallback,
    required super.hapticEngine,
    required super.audioPlayer,
    required super.settingsState,
  });


  @override
  String getTime(){
    return "";
  }

}