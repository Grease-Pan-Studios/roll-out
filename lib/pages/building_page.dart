import 'dart:convert';
import 'package:amaze_game/games/builder_game.dart';
import 'package:amaze_game/logical/color_palette_logic.dart';
import 'package:amaze_game/states/game_type_state.dart';
import 'package:amaze_game/states/settings_state.dart';
import 'package:flutter/services.dart';
import 'package:flutter/material.dart';
import 'package:flame/game.dart';

import 'package:amaze_game/logical/maze_logic.dart';
import 'package:amaze_game/generation/maze_generator.dart';

import 'package:amaze_game/services/haptic_engine_service.dart';
import 'package:amaze_game/services/audio_player_service.dart';

class BuildingPage extends StatefulWidget {
  final ColorPaletteLogic colorPalette;
  final HapticEngineService hapticEngine;
  final AudioPlayerService audioPlayer;
  final SettingsState settingsState;

  const BuildingPage({
    super.key,
    required this.hapticEngine,
    required this.colorPalette,
    required this.audioPlayer,
    required this.settingsState,
  });

  @override
  State<BuildingPage> createState() => _BuildingPageState();
}

class _BuildingPageState extends State<BuildingPage> {

  int width = 10;
  int height = 15;

  int? startPositionX = 3;
  int? startPositionY = 0;

  int? goalPositionX = 5;
  int? goalPositionY = 4;

  double ballRestitution = 0.8; //0.85;

  double cellSize = MazeLogic.defaultCellSize;
  double passageRatio = 0.57;
  // MazeLogic.defaultPassageRatio;
  double wallRatio = 0.16;
  // MazeLogic.defaultWallRatio;

  Duration threeStarThreshold = Duration(seconds: 10);
  Duration twoStarThreshold = Duration(seconds: 20);
  Duration oneStarThreshold = Duration(seconds: 30);

  int? seedUsed;

  bool seedLocked = true;

  String? fromFile;//= "assets/paths/path_3/section_1/4.json";
  GameType gameType = GameType.lookingGlass;
  late MazeLogic mazeLogic;
  late BuilderGame game;

  Future<void>? _gameFuture; // Future to handle game initialization

  // Existing methods for copying data, building maze, game, etc.
  void _onCopyDataButtonPressed() async {
    String jsonString = getPrettyJSONString(mazeLogic);
    await Clipboard.setData(ClipboardData(text: jsonString));
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('Level Data Copied'),
        duration: Duration(seconds: 3),
      ),
    );
  }

  void _buildMaze() {
    mazeLogic = MazeGenerator.getMaze(
      width,
      height,
      ballRestitution: ballRestitution,
      cellSize: cellSize,
      passageRatio: passageRatio,
      wallRatio: wallRatio,
      threeStarThreshold: threeStarThreshold,
      twoStarThreshold: twoStarThreshold,
      oneStarThreshold: oneStarThreshold,
      startX: startPositionX,
      startY: startPositionY,
      goalX: goalPositionX,
      goalY: goalPositionY,
      seed: seedUsed,
    );
    mazeLogic.adjustStartAndGoal();
    mazeLogic.estimateTimeThreshold(gameType);

  }

  void _buildGame() {
    game = BuilderGame(
      mazeLogic: mazeLogic,
      colorPalette: widget.colorPalette,
      hapticEngine: widget.hapticEngine,
      audioPlayer: widget.audioPlayer,
      settingsState: widget.settingsState,
      exitGameCallback: ({
        required bool isComplete,
        required Duration completionTime,
        required int rating,
      }) {
        // Do Nothing
      },
    );
  }

  Future<void> _loadFromFile() async {
    final String levelString = await rootBundle.loadString(fromFile!);
    final Map<String, dynamic> levelMap = json.decode(levelString);
    mazeLogic = MazeLogic.fromJson(levelMap);

    mazeLogic.estimateTimeThreshold(gameType);


    _buildGame();


  }

  // New initialization Future method.
  Future<void> _initializeGame() async {
    if (fromFile != null) {
      await _loadFromFile();
    } else {
      _buildMaze();
      _buildGame();
    }
  }

  @override
  void initState() {
    super.initState();
    // Initialize the future once.
    _gameFuture = _initializeGame();
  }

  ButtonStyle buttonStyle = ButtonStyle(
    backgroundColor: WidgetStateProperty.all<Color>(Color(0xffDCEEFE)),
    minimumSize: WidgetStateProperty.all<Size>(Size(58, 63)),
    shape: WidgetStateProperty.all<RoundedRectangleBorder>(
      RoundedRectangleBorder(
        side: BorderSide(
          color: Color(0xff253237),
          width: 3.0,
          strokeAlign: BorderSide.strokeAlignCenter,
        ),
        borderRadius: BorderRadius.circular(10.0),
      ),
    ),
  );

  String getPrettyJSONString(jsonObject) {
    var encoder = JsonEncoder.withIndent("     ");
    return encoder.convert(jsonObject);
  }

  void _onGenerateButtonPressed() {
    _buildMaze();
    _buildGame();
    setState(() {});
  }

  void _onSeedLockedButtonPressed() {
    seedLocked = !seedLocked;
    if (seedLocked) {
      seedUsed = mazeLogic.seedUsed;
    } else {
      seedUsed = null;
    }
    setState(() {});
  }

  /*
  * FutureBuilder(
                future: _gameFuture,
                builder: (BuildContext context, AsyncSnapshot snapshot) {
                  if (snapshot.connectionState == ConnectionState.done) {
                    return GameWidget(game: game);
                  } else if (snapshot.hasError) {
                    return Center(
                      child: Text("Error: ${snapshot.error}"),
                    );
                  } else {
                    return Center(
                      child: CircularProgressIndicator(),
                    );
                  }
                },
              ),
  * */


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Level Builder",
            style: TextStyle(
              fontFamily: 'Advent',
              color: Color(0xFF253237),
              fontSize: 40,
              fontWeight: FontWeight.w600,
              letterSpacing: -1.2,
            )),
      ),
      body: Material(
          textStyle: TextStyle(
            fontFamily: 'Advent',
            color: Color(0xFF253237),
            fontSize: 25,
            fontWeight: FontWeight.w600,
            letterSpacing: -0.6,
          ),
          child: FutureBuilder(
            future: _gameFuture,
            builder: (context, snapshot) {

              if (snapshot.hasError) {
                return Center(
                  child: Text("Error: ${snapshot.error}"),
                );
              }
              if (snapshot.connectionState != ConnectionState.done) {
                return Center(
                  child: CircularProgressIndicator(),
                );
              }


              return Stack(
                children: [
                  /*Future builder that builds game widget once initialized*/
                  GameWidget(game: game),
                  Column(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Padding(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 20.0, vertical: 10.0),
                        child: Column(
                          children: [
                            SingleChildScrollView(
                              scrollDirection: Axis.horizontal,
                              physics: AlwaysScrollableScrollPhysics(),
                              child: Row(
                                spacing: 25,
                                children: [
                                  Text(
                                    "Width: $width",
                                  ),
                                  Text(
                                    "Height: $height",
                                  ),
                                  Text(
                                    "Start: (${mazeLogic.startPositionX},"
                                    "${mazeLogic.startPositionY})",
                                  ),
                                  Text(
                                    "End: (${mazeLogic.goalPositionX},"
                                    " ${mazeLogic.goalPositionY})",
                                  ),
                                  Text("Restitution: $ballRestitution"),
                                ],
                              ),
                            ),
                            SingleChildScrollView(
                              scrollDirection: Axis.horizontal,
                              physics: AlwaysScrollableScrollPhysics(),
                              child: Row(
                                spacing: 25,
                                mainAxisAlignment: MainAxisAlignment.start,
                                children: [
                                  Row(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      TextButton(
                                          onPressed: () async {
                                            await Clipboard.setData(
                                              ClipboardData(
                                                  text: mazeLogic.seedUsed
                                                      .toString()),
                                            );

                                            // Copy Success SnackBar
                                            ScaffoldMessenger.of(context)
                                                .showSnackBar(
                                              SnackBar(
                                                content: Text('Seed Copied'),
                                                duration: Duration(seconds: 3),
                                              ),
                                            );
                                          },
                                          child: Row(
                                              // mainAxisAlignment: MainAxisAlignment.end,
                                              children: [
                                                Text(
                                                  "Seed ",
                                                  style: TextStyle(
                                                    fontFamily: 'Advent',
                                                    color: Color(0xFF253237),
                                                    fontSize: 25,
                                                    fontWeight: FontWeight.w600,
                                                    letterSpacing: -0.6,
                                                  ),
                                                ),
                                                Icon(
                                                  Icons.copy,
                                                  color: Color(0xFF253237),
                                                  // weight: 60,
                                                )
                                              ])),
                                      TextButton(
                                          onPressed: _onSeedLockedButtonPressed,
                                          child: Icon(
                                            (seedLocked)
                                                ? Icons.lock
                                                : Icons.lock_open,
                                            color: Color(0xFF253237),
                                            // weight: 60,
                                          ))
                                    ],
                                  ),
                                  Text(
                                      "Three Star: ${threeStarThreshold.inSeconds} s"),
                                  Text("Two Star: ${twoStarThreshold.inSeconds} s"),
                                  Text("One Star: ${oneStarThreshold.inSeconds} s"),
                                  Text("Cell Size: $cellSize"),
                                  Text("Passage Ratio: $passageRatio"),
                                  Text("Wall Ratio: $wallRatio"),
                                ],
                              ),
                            ),
                          ],
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.only(bottom: 20.0),
                        child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceAround,
                            children: [
                              TextButton(
                                  style: buttonStyle.copyWith(
                                    backgroundColor: WidgetStateProperty.all<Color>(
                                        Color(0xffFFC8DD)),
                                    padding:
                                        WidgetStateProperty.all<EdgeInsetsGeometry>(
                                            EdgeInsets.symmetric(horizontal: 30)),
                                  ),
                                  onPressed: _onGenerateButtonPressed,
                                  child: Text("Generate",
                                      style: TextStyle(
                                        fontFamily: 'Advent',
                                        color: Color(0xFF253237),
                                        fontSize: 25,
                                        fontWeight: FontWeight.w600,
                                        letterSpacing: -0.6,
                                      ))),
                              TextButton(
                                  style: buttonStyle,
                                  onPressed: _onCopyDataButtonPressed,
                                  child: Text("Copy Data",
                                      style: TextStyle(
                                        fontFamily: 'Advent',
                                        color: Color(0xFF253237),
                                        fontSize: 20,
                                        fontWeight: FontWeight.w600,
                                        letterSpacing: -0.6,
                                      )))
                            ]),
                      ),
                    ],
                  ),
                ],
              );
            }
          )),
    );
  }
}
