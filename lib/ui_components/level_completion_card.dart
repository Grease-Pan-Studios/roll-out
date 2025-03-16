
import 'package:amaze_game/logical/color_palette_logic.dart';
import 'package:amaze_game/services/haptic_engine_service.dart';
import 'package:flutter/material.dart';

import 'package:amaze_game/input_elements/button.dart';

class LevelCompletionCard extends StatefulWidget {

  final int rating;
  final String completionTime;
  final ColorPaletteLogic colorPalette;
  final VoidCallback? replayLevelCallback;
  final VoidCallback exitLevelCallback;
  final VoidCallback? nextLevelCallback;

  LevelCompletionCard({
    super.key,
    required this.rating,
    required this.completionTime,
    required this.colorPalette,
    required this.exitLevelCallback,
    this.replayLevelCallback,
    this.nextLevelCallback,
  }){
    assert(replayLevelCallback!=null || nextLevelCallback!=null,
    "Both replayLevelCallback and nextLevelCallback cannot be null");
  }

  @override
  State<LevelCompletionCard> createState() => _LevelCompletionCardState();
}

class _LevelCompletionCardState extends State<LevelCompletionCard> with SingleTickerProviderStateMixin{

  List<bool> starState = [false, false, false];

  String comment = "Great Job!";

  void showStars(int rating){

    if (rating == 0){
      return;
    }
    Future.delayed(Duration(seconds: 1), (){
      if (!mounted) return;

      setState(() {
        starState[0] = true;
      });
      if (rating == 1){
        return;
      }
      Future.delayed(Duration(milliseconds: 500), (){
        if (!mounted) return;
        setState(() {
          starState[1] = true;
        });
        if (rating == 2){
          return;
        }
        Future.delayed(Duration(milliseconds: 500), (){
          if (!mounted) return;
          setState(() {
            starState[2] = true;
          });
        });
      });
    });
  }

  void updateComment(){
    if (widget.rating == 0){
      comment = "Good Try!";
    }
    else if (widget.rating == 1){
      comment = "Fair Enough!";
    }
    else if (widget.rating == 2){
      comment = "Great Job!";
    }
    else if (widget.rating == 3){
      comment = "Excellent!";
    }
  }


  @override
  void didUpdateWidget(covariant LevelCompletionCard oldWidget) {
    super.didUpdateWidget(oldWidget);

    if (oldWidget.rating != widget.rating){
      showStars(widget.rating);
    }
    updateComment();

  }

  @override
  Widget build(BuildContext context) {
    return Material(
      color: widget.colorPalette.activeElementBackground,
      shape: RoundedRectangleBorder(
        side: BorderSide(
          color: widget.colorPalette.activeElementBorder,
          width: 5.0,
          strokeAlign: BorderSide.strokeAlignCenter
        ),
        borderRadius: BorderRadius.circular(10.0),
      ),

      child: Padding(
        padding: const EdgeInsets.only(
            left: 25.0, right: 25.0, top: 25.0, bottom: 40.0),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children:[

            /* Title */
            Text(
              "Level Complete",
              style: TextStyle(
                fontFamily: 'Advent',
                color: widget.colorPalette.activeElementText,
                fontSize: 36,
                fontWeight: FontWeight.w600,
                letterSpacing: -1.08,
              )
            ),

            Column(
              children: [
                const SizedBox(height: 15),
                Text(
                  widget.completionTime,
                  style: TextStyle(
                    fontFamily: 'JetBrainsMono',
                    color: widget.colorPalette.activeElementText,
                    fontSize: 48,
                    fontWeight: FontWeight.w700,
                    letterSpacing: -6.2,
                  )
                ),
                const SizedBox(height: 15),
                Row(
                  mainAxisSize: MainAxisSize.min,
                  mainAxisAlignment: MainAxisAlignment.center,

                  children: [
                    AnimatedCrossFade(
                      duration: const Duration(milliseconds: 500), // Animation duration
                      firstChild: ImageIcon(
                          AssetImage('assets/images/ui_elements/star_outline.png'),
                          size: 50,
                          color: widget.colorPalette.activeElementText,
                      ),
                      secondChild: ImageIcon(
                        AssetImage('assets/images/ui_elements/star_fill.png'),
                        size: 50,
                        color: widget.colorPalette.activeElementText,
                      ), // Second image
                      crossFadeState: starState[0] ? CrossFadeState.showSecond: CrossFadeState.showFirst,
                    ),
                    AnimatedCrossFade(
                      duration: const Duration(milliseconds: 500), // Animation duration
                      firstChild: ImageIcon(
                        AssetImage('assets/images/ui_elements/star_outline.png'),
                        size: 50,
                        color: widget.colorPalette.activeElementText,
                      ),
                      secondChild: ImageIcon(
                        AssetImage('assets/images/ui_elements/star_fill.png'),
                        size: 50,
                        color: widget.colorPalette.activeElementText,
                      ), // Second image
                      crossFadeState: starState[1] ? CrossFadeState.showSecond: CrossFadeState.showFirst,
                    ),
                    AnimatedCrossFade(
                      duration: const Duration(milliseconds: 500), // Animation duration
                      firstChild: ImageIcon(
                        AssetImage('assets/images/ui_elements/star_outline.png'),
                        size: 50,
                        color: widget.colorPalette.activeElementText,
                      ),
                      secondChild: ImageIcon(
                        AssetImage('assets/images/ui_elements/star_fill.png'),
                        size: 50,
                        color: widget.colorPalette.activeElementText,
                      ), // Second image
                      crossFadeState: starState[2] ? CrossFadeState.showSecond: CrossFadeState.showFirst,
                    ),

                  ],

                ),


                Text(
                  comment,
                  style: TextStyle(
                    fontFamily: 'Advent',
                    color: widget.colorPalette.activeElementText,
                    fontSize: 32,
                    fontWeight: FontWeight.w600,
                    letterSpacing: -0.96,
                  )
                ),

                const SizedBox(height: 30),

                widget.replayLevelCallback == null ? Button(
                  colorPalette: widget.colorPalette,
                  text: "Exit",
                  onPressed: widget.exitLevelCallback,
                  isDark: false,
                ) :
                Button(
                  colorPalette: widget.colorPalette,
                  text: "Once Again?",
                  onPressed: widget.replayLevelCallback!,
                  isDark: false,
                ),

                widget.nextLevelCallback != null ? Button(
                    colorPalette: widget.colorPalette,
                    text: "Next Level",
                    onPressed: widget.nextLevelCallback!,
                    isDark: true,
                ) : Button(
                  colorPalette: widget.colorPalette,
                  text: "Exit",
                  onPressed: widget.exitLevelCallback,
                  isDark: true,
                )


              ],
            )

          ]
        ),
      )
    );
  }
}
