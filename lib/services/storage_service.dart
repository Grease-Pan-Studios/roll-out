
import 'package:hive/hive.dart';

import 'package:amaze_game/states/level_state.dart';
import 'package:amaze_game/states/settings_state.dart';

class StorageService {

  late final Box<LevelState> _levelStates;
  late final Box<SettingsState> _settingState;

  StorageService();

  Future<void> initialize() async {
    _levelStates = await Hive.openBox<LevelState>('level_states');
    _settingState = await Hive.openBox<SettingsState>('setting_state');
  }

  Map<String, LevelState> getLevelStates(){

    Map<String, LevelState> levelStates = {};
    for (var key in _levelStates.keys){
      levelStates[key] = _levelStates.get(key)!;
    }
    return levelStates;
  }

  void setLevelState({
    required String key,
    required LevelState value,
    isLocal = true
  }){
    _levelStates.put(key, value);
  }

  void setSettingsState({
    required SettingsState value,
    isLocal = true
  }){
    _settingState.put('settings', value);
  }

  SettingsState getSettingsState(){
    return _settingState.get('settings') ?? SettingsState();
  }


}