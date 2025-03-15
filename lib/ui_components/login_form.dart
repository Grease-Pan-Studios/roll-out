
import 'package:amaze_game/services/game_service.dart';
import 'package:flutter/material.dart';
import 'package:games_services/games_services.dart';

import 'package:amaze_game/logical/user_logic.dart';
import 'package:amaze_game/logical/color_palette_logic.dart';

import 'package:amaze_game/input_elements/button.dart';

class LoginForm extends StatelessWidget {

  final ColorPaletteLogic colorPalette;
  final UserLogic userLogic;
  final VoidCallback goToGame;

  const LoginForm({
    super.key,
    required this.colorPalette,
    required this.userLogic,
    required this.goToGame,
  });

  @override
  Widget build(BuildContext context) {
    return Material(
      color: colorPalette.secondary,
      child: Material(
        color: colorPalette.primary,
        shape: RoundedRectangleBorder(
          side: BorderSide(
            color: colorPalette.inactiveElementText,
            width: 2.5,
          ),
          borderRadius: BorderRadius.only(
            topLeft: Radius.circular(35),
            topRight: Radius.circular(35),
          ),
        ),
        textStyle: TextStyle(
          fontFamily: "Advent",
          color: colorPalette.activeElementText,
          fontWeight: FontWeight.w500,
          fontSize: 24,
          letterSpacing: -1.2,
        ),
        child: Column(
          children: [
            Container(
              height: 5,
              width: 140,
              margin: EdgeInsets.only(top: 15, bottom: 5),
              decoration: BoxDecoration(
                color: colorPalette.inactiveElementText,
                borderRadius: BorderRadius.circular(10),
              ),
            ),
            Padding(
              padding: const EdgeInsets.only(top: 35.0, right: 35, left: 35),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                      "Link to an Account",
                    style: TextStyle(
                      fontSize: 40,
                      fontWeight: FontWeight.bold,
                      letterSpacing: -1.2,
                    ),
                  ),
                  SizedBox(height: 10),

                  /* Benefits */
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    spacing: 5,
                    children: [
                      Text("Sync your progress across devices"),
                      Text("Unlock achievements"),
                      Text("Rank on the leaderboard"),
                    ],
                  ),
                  SizedBox(height: 35),
                  Center(
                    child: Button(
                      onPressed: () {
                        GameService.login(userLogic);
                      },
                      text: 'Continue with Google Games',
                      colorPalette: colorPalette,
                      isExpanded: true,
                      icon: Image(
                        image: AssetImage("assets/icon/google_games.png"),
                        width: 45,
                        // color: colorPalette.activeElementText,
                      ),
                    ),
                  ),
                  SizedBox(height: 10),
                  Center(
                    child: TextButton(
                      onPressed: goToGame,
                      style: ButtonStyle(
                        foregroundColor: WidgetStateProperty.all<Color>(
                          colorPalette.activeElementText,
                        ),
                        overlayColor: WidgetStateProperty.all<Color>(
                          colorPalette.activeElementBackground.withAlpha(80),
                        ),
                        padding: WidgetStateProperty.all<EdgeInsetsGeometry>(
                            EdgeInsets.symmetric(horizontal: 20, vertical: 5)),
                        shape: WidgetStateProperty.all<OutlinedBorder>(
                          RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(15),
                          ),
                        ),
                        enableFeedback: true,
                      ),

                      child: Text(
                          "Jump Straight In",
                        style: TextStyle(
                          fontFamily: "Advent",
                          fontWeight: FontWeight.w600,
                          color: colorPalette.inactiveElementText,
                          fontSize: 24,
                          letterSpacing: -0.8,
                          decoration: TextDecoration.underline,
                          decorationColor: colorPalette.inactiveElementText,
                          decorationThickness: 2.2,
                          decorationStyle: TextDecorationStyle.solid,
                        )
                      ),
                    ),
                  )
                ],

              ),
            ),
          ],
        ),
      ),
    );
  }
}
