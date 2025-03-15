

import 'package:flutter/material.dart';
import 'package:amaze_game/services/game_service.dart';

class UserLogic{

  String? id;
  VoidCallback? updateTrigger;


  Future<void> initialize() async {
    if (await GameService.isLoggedIn()){
      GameService.linkUserCredentials(this);
    }
  }


  bool isLoggedIn(){
    return id != null;
  }

  void setId(String? id){
    this.id = id;
    updateTrigger?.call();
  }

  void setUpdateTrigger(VoidCallback callback){
    updateTrigger = callback;
  }

}