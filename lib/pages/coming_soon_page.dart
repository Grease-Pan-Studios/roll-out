
import 'package:amaze_game/logical/color_palette_logic.dart';
import 'package:amaze_game/states/settings_state.dart';
import 'package:flutter/material.dart';

class ComingSoonPage extends StatelessWidget {

  // static double hue = 0;

  final SettingsState settingsState;

  late ColorPaletteLogic colorPalette;

  ComingSoonPage({
    super.key,
    required this.settingsState,
  }){
    colorPalette = ColorPaletteLogic.asMonochrome(isDarkMode: settingsState.isDarkMode);
  }


  @override
  Widget build(BuildContext context) {
    return Material(
        color: colorPalette.primary,
        child: Padding(
          padding: const EdgeInsets.only(left: 30.0, top: 120.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
                Text(
                  "Coming Soon",
                  style: TextStyle(
                      fontFamily: 'Advent',
                      color: colorPalette.activeElementText,
                      fontSize: 48,
                      fontWeight: FontWeight.w700,
                      letterSpacing: -1.92,
                    ),
                ),
              Text(
                "More levels and modes on the way!",
                style: TextStyle(
                  fontFamily: 'Advent',
                  color: colorPalette.inactiveElementText,
                  fontSize: 32,
                  fontWeight: FontWeight.w600,
                  height: 1.2,
                  letterSpacing: -1.08,
                ),
              ),
              SizedBox(height: 25),
              Text(
                "With Love,\n"
                "Nathan",
                style: TextStyle(
                  fontFamily: 'Advent',
                  color: colorPalette.inactiveElementText,
                  fontSize: 30,
                  // Italics
                  fontStyle: FontStyle.italic,
                  fontWeight: FontWeight.w500,
                  letterSpacing: -1.08,
                  height: 1
                ),
              )

            ]
            )
            // [PathSection(),],
          )
      );
  }
}

