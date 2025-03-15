


import 'package:amaze_game/logical/user_logic.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:game_services_firebase_auth/firebase_auth_extension.dart';
import 'package:game_services_firebase_auth/firebase_user_extension.dart';
import 'package:games_services/games_services.dart';
// import 'package:game_services_firebase_auth/game_services_firebase_auth.dart';


class GameService {

  static void login(UserLogic userLogic) async {
    UserCredential userCredentials =  await FirebaseAuth.instance.signInWithGamesServices();
    print("User ID: ${userCredentials.user!.uid}");
    userLogic.setId(userCredentials.user!.uid);
  }

  static Future<bool> isLoggedIn() async{
    User user = FirebaseAuth.instance.currentUser!;
    return user.isLinkedWithGamesServices();
  }
  static void linkUserCredentials(UserLogic userLogic) async {
    User user = FirebaseAuth.instance.currentUser!;
    user.linkWithGamesServices();
    userLogic.setId(user.uid);
  }

}