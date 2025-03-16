
import 'dart:async';

import 'package:amaze_game/services/audio_player_service.dart';
import 'package:amaze_game/services/haptic_engine_service.dart';
import 'package:amaze_game/services/storage_service.dart';
import 'package:amaze_game/ui_components/unlimited_card.dart';
import 'package:amaze_game/ui_overlays/indicator_tag.dart';
import 'package:flutter/material.dart';

import 'package:amaze_game/logical/path_logic.dart';
import 'package:amaze_game/logical/color_palette_logic.dart';

import 'package:amaze_game/ui_components/page_section.dart';

import 'package:amaze_game/states/game_state.dart';
import 'package:amaze_game/states/settings_state.dart';

class PathPage extends StatefulWidget {

  final bool showModesIndicator;
  final PathLogic pathwayLogic;
  final GameState gameState;
  final SettingsState settingsState;
  final HapticEngineService hapticEngine;
  final AudioPlayerService audioPlayer;
  final ColorPaletteLogic colorPalette;
  final StorageService storageService;

  const PathPage({
    super.key,
    required this.pathwayLogic,
    required this.storageService,
    required this.gameState,
    required this.settingsState,
    required this.hapticEngine,
    required this.audioPlayer,
    required this.colorPalette,
    this.showModesIndicator = true,
  });

  @override
  State<PathPage> createState() => _PathPageState();
}

class _PathPageState extends State<PathPage> {


  final bool _showAllSection = true;


  final GlobalKey<IndicatorTagState> indicatorKey = GlobalKey<IndicatorTagState>();

  @override
  void initState() {
    super.initState();
    // moreModesIndicator = IndicatorTag(
    //   colorPalette: widget.colorPalette
    // );
  }


  List<Widget> _unlockedSections() {

    List<PageSection> unlockedSections = [];

    if (widget.pathwayLogic.sections.isEmpty){
      return unlockedSections;
    }

    for (int i = 0; i < widget.pathwayLogic.sections.length; i++){

      unlockedSections.add(
        PageSection(
          sectionLogic: widget.pathwayLogic.sections[i],
          audioPlayer: widget.audioPlayer,
          gameState: widget.gameState,
          settingsState: widget.settingsState,
          hapticEngine: widget.hapticEngine,
          hue: widget.pathwayLogic.hue,
          storageService: widget.storageService,
          colorPalette: widget.colorPalette,
        )
      );

      if (!_showAllSection && !widget.gameState.isSectionCompleted(
          sectionLogic: widget.pathwayLogic.sections[i])){
        break;
      }

    }

    return unlockedSections;

  }

  @override
  Widget build(BuildContext context) {
    return Material(
      color: widget.colorPalette.getPrimary(
        hue: widget.pathwayLogic.hue,
        isDarkMode: widget.settingsState.isDarkMode,
      ),
      child: Padding(
        padding: const EdgeInsets.only(left: 20.0, right: 20.0, top: 20.0),
        child: SingleChildScrollView(
          physics: BouncingScrollPhysics(),
          child: Padding(
            padding: const EdgeInsets.only(bottom: 80.0),
            child: Column(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  UnlimitedCard(
                    gameType: widget.pathwayLogic.gameType,
                    colorPalette: widget.colorPalette,
                    hapticEngine: widget.hapticEngine,
                    storageService: widget.storageService,
                    settingsState: widget.settingsState,
                    audioPlayer: widget.audioPlayer,
                  )
                ] + _unlockedSections(),
            ),
          ),
        ),
      ),
    );
  }
}