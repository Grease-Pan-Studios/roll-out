import 'package:amaze_game/services/haptic_engine_service.dart';
import 'package:amaze_game/services/storage_service.dart';
import 'package:amaze_game/states/settings_state.dart';
import 'package:flutter/material.dart';

import 'package:amaze_game/ui_components/settings_card.dart';
import 'package:amaze_game/logical/color_palette_logic.dart';

class LevelAppBar extends StatelessWidget {

  final SettingsState settingsState;
  final StorageService storageService;
  final ColorPaletteLogic colorPalette;
  final HapticEngineService hapticEngine;
  final BuildContext context;
  final String title;
  final String subtitle;
  final VoidCallback? onSettingsOpen;
  final VoidCallback? onSettingsClose;

  const LevelAppBar({
    super.key,
    required this.context,
    required this.title,
    required this.subtitle,
    required this.hapticEngine,
    required this.colorPalette,
    required this.settingsState,
    required this.storageService,
    this.onSettingsOpen,
    this.onSettingsClose,
  });

  void exitLevelPage() {
    hapticEngine.selection();
    Navigator.pop(context);
  }

  void _openSettingsPanel() {
    hapticEngine.selection();

    onSettingsOpen?.call();

    SettingsCard.open(
        context, colorPalette, settingsState, storageService, hapticEngine,
        onExit: () {
      onSettingsClose?.call();
    });
  }

  @override
  Widget build(BuildContext context) {
    return AppBar(
      toolbarHeight: 120,
      backgroundColor: colorPalette.getDarkPrimary(),
      automaticallyImplyLeading: false,
      centerTitle: true,
      title: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            SizedBox(height: 20),
            FittedBox(
              child: Text(title,
                  style: TextStyle(
                    fontFamily: 'Advent',
                    color: colorPalette.activeElementText,
                    fontSize: 40,
                    fontWeight: FontWeight.w600,
                    letterSpacing: -1.2,
                  )),
            ),
            Text(subtitle,
                style: TextStyle(
                  fontFamily: 'Advent',
                  color: colorPalette.activeElementText,
                  fontSize: 20,
                  fontWeight: FontWeight.w600,
                  letterSpacing: -0.6,
                ))
          ]),
      leadingWidth: 75,
      leading: Padding(
        padding: const EdgeInsets.only(left: 20.0, top: 33.0, bottom: 33.0),
        child: IconButton(
          alignment: Alignment.centerLeft,
          icon: ImageIcon(
            AssetImage("assets/images/ui_elements/back_icon.png"),
            size: 45,
            color: colorPalette.activeElementBorder,
          ),
          onPressed: exitLevelPage,
        ),
      ),

      actions: [
        Padding(
          padding: const EdgeInsets.only(right: 20.0),
          child: IconButton(
            alignment: Alignment.topRight,
            icon: ImageIcon(
              AssetImage("assets/images/ui_elements/gear_icon.png"),
              size: 45,
              color: colorPalette.activeElementBorder,
              semanticLabel: "Settings",
            ),
            onPressed: _openSettingsPanel,
          ),
        )
      ],
    );
  }
}
