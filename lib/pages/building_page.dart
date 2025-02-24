
import 'dart:convert';
import 'package:amaze_game/logical/color_palette_logic.dart';
import 'package:flutter/services.dart';
import 'package:flutter/material.dart';
import 'package:flame/game.dart';

import 'package:amaze_game/my_game.dart';
import 'package:amaze_game/logical/maze_logic.dart';
import 'package:amaze_game/generation/maze_generator.dart';

import 'package:amaze_game/services/haptic_engine_service.dart';
import 'package:amaze_game/services/audio_player_service.dart';

class BuildingPage extends StatefulWidget {

  final ColorPaletteLogic colorPalette;
  final HapticEngineService hapticEngine;
  final AudioPlayerService audioPlayer;

  const BuildingPage({
    super.key,
    required this.hapticEngine,
    required this.colorPalette,
    required this.audioPlayer,
  });

  @override
  State<BuildingPage> createState() => _BuildingPageState();
}

class _BuildingPageState extends State<BuildingPage> {

  int width = 8;
  int height = 12;



  int? startPositionX = 0;
  int? startPositionY = 10;

  int? goalPositionX = 2;
  int? goalPositionY = 1;

  int? seedUsed = 1739265073387;

  bool seedLocked = true;

  late MazeLogic mazeLogic;

  @override
  void initState() {
    super.initState();
    mazeLogic = MazeGenerator.getMaze(
        width, height,
        startX: startPositionX,
        startY: startPositionY,
        goalX: goalPositionX,
        goalY: goalPositionY,
        seed: seedUsed
    );

  }

  ButtonStyle buttonStyle = ButtonStyle(
    backgroundColor: WidgetStateProperty.all<Color>(Color(0xffDCEEFE)),
    minimumSize: WidgetStateProperty.all<Size>(Size(58, 63)),
    // maximumSize: WidgetStateProperty.all<Size>(Size(58, 63) * 2),
    shape: WidgetStateProperty.all<RoundedRectangleBorder>(
      RoundedRectangleBorder(
        side: BorderSide(
          color: Color(0xff253237),
          width: 3.0,
          strokeAlign: BorderSide.strokeAlignCenter
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
    mazeLogic = MazeGenerator.getMaze(width, height,
        startX: startPositionX,
        startY: startPositionY,
        goalX: goalPositionX,
        goalY: goalPositionY,
        seed: seedUsed
    );

    setState(() {

    });
  }

  void _onSeedLockedButtonPressed() {
    seedLocked = !seedLocked;
    if (seedLocked) {
      seedUsed = mazeLogic.seedUsed;
    } else {
      seedUsed = null;
    }
    setState(() {

    });

  }


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
          child: Stack(
            children: [

              GameWidget(
                  game: MyGame(
                      mazeLogic: mazeLogic,
                      colorPalette: widget.colorPalette,
                      hapticEngine: widget.hapticEngine,
                      audioPlayer: widget.audioPlayer,
                      exitGameCallback: ({
                        required bool isComplete,
                        required Duration completionTime,
                        required int rating}) {
                        // Do Nothing
                      }
                  )
              ),

              Column(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [

                  Padding(
                    padding: const EdgeInsets.only(top: 5.0),
                    child: Column(
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceAround,
                          children: [
                            Text(
                              "Width: $width",
                              style: TextStyle(
                                fontFamily: 'Advent',
                                color: Color(0xFF253237),
                                fontSize: 25,
                                fontWeight: FontWeight.w600,
                                letterSpacing: -0.6,
                              ),
                            ),

                            Text(
                              "Height: $height",
                              style: TextStyle(
                                fontFamily: 'Advent',
                                color: Color(0xFF253237),
                                fontSize: 25,
                                fontWeight: FontWeight.w600,
                                letterSpacing: -0.6,
                              ),
                            ),

                            Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              // spacing: 0,
                              children: [
                                TextButton(
                                    onPressed: () async{

                                      await Clipboard.setData(
                                          ClipboardData(text: mazeLogic.seedUsed.toString()),
                                      );

                                      // Copy Success SnackBar
                                      ScaffoldMessenger.of(context).showSnackBar(
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

                                      ]
                                    )),

                                TextButton(
                                  onPressed: _onSeedLockedButtonPressed,

                                  child: Icon(
                                    (seedLocked) ? Icons.lock : Icons.lock_open,
                                    color: Color(0xFF253237),
                                    // weight: 60,
                                  )
                                )


                              ],
                            )


                          ],
                        ),

                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceAround,
                          children: [
                            Text(
                              "Start: (${mazeLogic.startPositionX}, ${mazeLogic.startPositionY})",
                              style: TextStyle(
                                fontFamily: 'Advent',
                                color: Color(0xFF253237),
                                fontSize: 25,
                                fontWeight: FontWeight.w600,
                                letterSpacing: -0.6,
                              )
                            ),
                            Text(
                              "End: (${mazeLogic.goalPositionX}, ${mazeLogic.goalPositionY})",
                              style: TextStyle(
                                fontFamily: 'Advent',
                                color: Color(0xFF253237),
                                fontSize: 25,
                                fontWeight: FontWeight.w600,
                                letterSpacing: -0.6,
                              )
                            )
                          ],
                        )
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
                              backgroundColor: WidgetStateProperty.all<Color>(Color(0xffFFC8DD)),
                              padding: WidgetStateProperty.all<EdgeInsetsGeometry>(EdgeInsets.symmetric(horizontal: 30)),
                            ),
                            onPressed: _onGenerateButtonPressed,
                            child: Text(
                              "Generate",
                              style: TextStyle(
                                fontFamily: 'Advent',
                                color: Color(0xFF253237),
                                fontSize: 25,
                                fontWeight: FontWeight.w600,
                                letterSpacing: -0.6,
                              )
                            )
                          ),

                          TextButton(
                              style: buttonStyle,
                              onPressed: () async {


                                String jsonString = getPrettyJSONString(mazeLogic);

                                await Clipboard.setData(
                                    ClipboardData(text: jsonString)
                                );

                                // print("Copied to Clipboard");
                                // Copy Success SnackBar
                                ScaffoldMessenger.of(context).showSnackBar(
                                  SnackBar(
                                    content: Text('Level Data Copied'),
                                    duration: Duration(seconds: 3),
                                  ),
                                );

                              },
                              child: Text("Copy Data",
                                  style: TextStyle(
                                    fontFamily: 'Advent',
                                    color: Color(0xFF253237),
                                    fontSize: 20,
                                    fontWeight: FontWeight.w600,
                                    letterSpacing: -0.6,
                                  )
                              )
                          )
                        ]
                    ),
                  ),

                ],
              ),


            ],
          )
      ),


    );






  }
}
