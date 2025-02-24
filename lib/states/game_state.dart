
import 'package:amaze_game/services/storage_service.dart';
import 'package:flutter/material.dart';

import 'package:amaze_game/logical/game_logic.dart';
import 'package:amaze_game/logical/section_logic.dart';
import 'package:amaze_game/states/level_state.dart';

class GameState{

  // final StorageService _storageService = StorageService();
  final StorageService storageService;
  late Map<String, LevelState> _levelStates;
  VoidCallback? updateTrigger;

  GameState({
    required this.storageService
  });


  Future<void> initialize() async{
    // await storageService.initialize();
    _levelStates = {};
    // Get all the states present in the storage
    _levelStates = storageService.getLevelStates();

  }

  void setUpdateTrigger(VoidCallback trigger){
    updateTrigger = trigger;
  }

  void setLevelState({
      required SectionLogic sectionLogic,
      required int levelIndex,
      required LevelState levelState,
  }){

    /* Is there a cached state */
    LevelState? cachedState = _getCachedLevelState(
        sectionLogic: sectionLogic,
        levelIndex: levelIndex
    );

    if (cachedState == null
      || (cachedState.state == LevelStateEnum.completed
          && cachedState.completionTime > levelState.completionTime)
    ){
      _setCachedLevelState(
          sectionLogic: sectionLogic,
          levelIndex: levelIndex,
          levelState: levelState
      );
    }

    if (updateTrigger != null){
      updateTrigger!();
    }
  }

  void _setCachedLevelState({
      required SectionLogic sectionLogic,
      required int levelIndex,
      required LevelState levelState
  }){
    final String levelCode = sectionLogic.levelCode(levelIndex);
    _levelStates[levelCode] = levelState;

    storageService.setLevelState(
      key: levelCode,
      value: levelState,
      isLocal: true
    );
  }

  LevelState? _getCachedLevelState(
      {required SectionLogic sectionLogic, required int levelIndex}
  ){
    final String levelCode = sectionLogic.levelCode(levelIndex);
    return _levelStates[levelCode];
  }

  LevelState getLevelState({
      required SectionLogic sectionLogic,
      required int levelIndex
  }){

    /* Is there a cached state ? */
    LevelState? cachedState = _getCachedLevelState(
        sectionLogic: sectionLogic,
        levelIndex: levelIndex
    );

    if (cachedState != null) {
      return cachedState;
    }

    /* If no cached state it is either locked or unlocked */

    /* Is it default unlocked ? */
    if (sectionLogic.defaultUnlockedLevelIndices.contains(levelIndex)) {
      return LevelState(state: LevelStateEnum.unlocked);
    }
    /* What is the previous level? */
    /* Is the previous level completed ? */

    if (levelIndex > 0){
      cachedState = _getCachedLevelState(
          sectionLogic: sectionLogic,
          levelIndex: levelIndex - 1
      );

      if (cachedState != null && cachedState.state == LevelStateEnum.completed) {
        return LevelState(state: LevelStateEnum.unlocked);
      }else{
        return LevelState(state: LevelStateEnum.locked);
      }

    }else{
      /* This should check if the previous section is completed */
    }

    return LevelState(state: LevelStateEnum.locked);
  }

  // bool isLevelLocked({
  //   required SectionLogic sectionLogic,
  //   required int levelIndex
  // }){
  //
  //   if (sectionLogic.defaultUnlockedLevelIndices.contains(levelIndex)) {
  //     return false;
  //   }
  //
  //   return true;
  // }

  // bool isSectionLocked({required SectionLogic sectionLogic}){
  //   return isLevelLocked(sectionLogic: sectionLogic, levelIndex: 0);
  // }


}